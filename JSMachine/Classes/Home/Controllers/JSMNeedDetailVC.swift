//
//  JSMNeedDetailVC.swift
//  JSMachine
//  竞标需求详情
//  Created by gouyz on 2019/4/9.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let needDetailCell = "needDetailCell"
private let needDetailInfoCell = "needDetailInfoCell"
private let needDetailUserHeader = "needDetailUserHeader"
private let needDetailInfoHeader = "needDetailInfoHeader"

class JSMNeedDetailVC: GYZBaseVC {

    var needId : String = ""
    var detailModel: JSMNeedModel?
    /// 竞标价格
    var needPrice: String = ""
    /// 选择时间戳
    var selectTime: Int = 0
    
    ///输入是否有小数点
    var isHaveDian: Bool = false
    ///输入第一位是否是0
    var isFirstZero: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "需求详情"
        
        view.addSubview(submitBtn)
        view.addSubview(tableView)
        submitBtn.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.bottom.equalTo(-20)
            make.height.equalTo(kUIButtonHeight)
        }
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(submitBtn.snp.top).offset(-20)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view)
            }else{
                make.top.equalTo(kTitleAndStateHeight)
            }
        }
        requestProductDatas()
    }
    
    
    /// 懒加载UITableView
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorColor = kGrayLineColor
        
        // 设置大概高度
        table.estimatedRowHeight = 120
        // 设置行高为自动适配
        table.rowHeight = UITableViewAutomaticDimension
        
        table.register(JSMNeedDetailCell.self, forCellReuseIdentifier: needDetailCell)
        table.register(GYZLabAndFieldCell.self, forCellReuseIdentifier: needDetailInfoCell)
        table.register(JSMNeedDetailUserHeaderView.self, forHeaderFooterViewReuseIdentifier: needDetailUserHeader)
        table.register(JSMNeedDetailInfoHeader.self, forHeaderFooterViewReuseIdentifier: needDetailInfoHeader)
        
        return table
    }()
    /// 提交按钮
    fileprivate lazy var submitBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("提交", for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(onClickedSubmitBtn), for: .touchUpInside)
        btn.cornerRadius = CGFloat(kUIButtonHeight * 0.5)
        
        return btn
    }()
    /// 提交
    @objc func onClickedSubmitBtn(){
        if !userDefaults.bool(forKey: kIsLoginTagKey) {
            goLogin()
        }else{
            if needPrice.isEmpty{
                MBProgressHUD.showAutoDismissHUD(message: "请输入竞标价格")
                return
            }
            if selectTime == 0{
                MBProgressHUD.showAutoDismissHUD(message: "请选择发货日期")
                return
            }
            requestSubmitDatas()
        }
    }
    ///获取详情数据
    func requestProductDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("second/bidDetials",parameters: ["id":needId],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].dictionaryObject else { return }
                weakSelf?.detailModel = JSMNeedModel.init(dict: data)
                weakSelf?.tableView.reloadData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 登录
    func goLogin(){
        let vc = JSMLoginVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///竞价提交
    func requestSubmitDatas(){

        if !GYZTool.checkNetWork() {
            return
        }

        weak var weakSelf = self
        createHUD(message: "加载中...")

        GYZNetWork.requestNetwork("second/bid",parameters: ["user_id":userDefaults.string(forKey: "userId") ?? "","need_id":needId,"price": needPrice,"time":selectTime],  success: { (response) in

            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)

            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["status"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.clickedBackBtn()

            }

        }, failture: { (error) in

            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    func selectDate(){
        UsefulPickerView.showDatePicker("请选择发货日期") { [weak self](date) in
            self?.selectTime = Int(date.timeIntervalSince1970)
            self?.tableView.reloadData()
        }
    }
    
    //监听文本输入变化
    @objc func txtFieldChangeValue(txtFiled : UITextField){
        needPrice = txtFiled.text!
    }
}

extension JSMNeedDetailVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 2
        }else{
            if detailModel != nil {
                return (detailModel?.needProductsModels.count)! + 1
            }else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: needDetailCell) as! JSMNeedDetailCell
            
            if indexPath.row == detailModel?.needProductsModels.count {// 交货日期
                cell.typeLab.snp.updateConstraints { (make) in
                    make.height.equalTo(0)
                }
                cell.typeLab.isHidden = true
                cell.numberLab.isHidden = true
                cell.noteLab.text = "交货日期：" + (detailModel?.deal_date?.getDateTime(format: "yyyy-MM-dd"))!
            }else{
                cell.typeLab.snp.updateConstraints { (make) in
                    make.height.equalTo(30)
                }
                cell.typeLab.isHidden = false
                cell.numberLab.isHidden = false
                let model = detailModel?.needProductsModels[indexPath.row]
                cell.typeLab.text = "产品型号：" + (model?.pro_model)!
                cell.numberLab.text = "产品数量：" + (model?.num)!
                cell.noteLab.text = "用户备注：" + (model?.remark)!
            }
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: needDetailInfoCell) as! GYZLabAndFieldCell
            
            if indexPath.row == 0 {// 竞标价
                cell.desLab.text = "竞标价格："
                cell.textFiled.placeholder = "请输入竞标价格"
                cell.textFiled.delegate = self
                cell.textFiled.keyboardType = .decimalPad
                cell.textFiled.isEnabled = true
                cell.textFiled.addTarget(self, action: #selector(txtFieldChangeValue(txtFiled : )), for: .editingChanged)
            }else{
                cell.desLab.text = "发货日期："
                cell.textFiled.isEnabled = false
                cell.textFiled.keyboardType = .default
                cell.textFiled.placeholder = "请选择发货日期"
                if selectTime > 0{
                    cell.textFiled.text = String.init(selectTime).getDateTime(format: "yyyy-MM-dd")
                }
            }
            
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: needDetailUserHeader) as! JSMNeedDetailUserHeaderView
            
            if detailModel != nil{
                headerView.iconView.kf.setImage(with: URL.init(string: (detailModel?.n_head)!), placeholder: UIImage.init(named: "icon_header_default"), options: nil, progressBlock: nil, completionHandler: nil)
                headerView.useNameLab.text = detailModel?.n_nickname
                headerView.dateLab.text = detailModel?.create_date?.getDateTime(format: "yyyy/MM/dd")
            }
            
            return headerView
        }else{
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: needDetailInfoHeader) as! JSMNeedDetailInfoHeader
            
            return headerView
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 1 {// 选择日期
            selectDate()
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return kMargin
        }
        return 0.00001
    }
}
extension JSMNeedDetailVC: UITextFieldDelegate{
    //1.要求用户输入首位不能为小数点;
    //2.小数点后不超过两位，小数点无法输入超过一个;
    //3.如果首位为0，后面仅能输入小数点
    //MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        if ((textField.text?.range(of: ".")) == nil) {//是否输入点.
            isHaveDian = false
        }
        if ((textField.text?.range(of: "0")) == nil) {//首位是否输入0.
            isFirstZero = false
        }
        
        if string.count > 0 {
            //当前输入的字符
            let single = string[string.startIndex]
            //数据格式正确
            if (single >= "0" && single <= "9") || single == "." {
                if textField.text?.count == 0 {
                    //首字母不能为小数点
                    if single == "." {
                        return false
                    }else if single == "0" {
                        isFirstZero = true
                        return true
                    }
                }else{
                    if single == "." {
                        if isHaveDian {//不允许输入多个小数点
                            return false
                        } else {//text中还没有小数点
                            isHaveDian = true
                            return true
                        }
                    }else if single == "0" {
                        //首位有0有.（0.01）或首位没0有.（10200.00）可输入两位数的0
                        if (isHaveDian && isFirstZero) || (!isFirstZero && isHaveDian) {
                            
                            if textField.text == "0.0" {
                                return false
                            }
                            let ran = textField.text?.nsRange(from: (textField.text?.range(of: "."))!)
                            let tt = range.location - (ran?.location)!
                            //判断小数点后的位数,只允许输入2位
                            if tt <= 2 {
                                return true
                            }else{
                                return false
                            }
                        } else if isFirstZero && !isHaveDian{
                            //首位有0没.不能再输入0
                            return false
                        }else{
                            ///整数部分不能超过8位，与数据库匹配
                            if textField.text?.count > 7 {
                                return false
                            }
                            return true
                        }
                    }else{
                        if isHaveDian {//存在小数点，保留两位小数
                            let ran = textField.text?.nsRange(from: (textField.text?.range(of: "."))!)
                            let tt = range.location - (ran?.location)!
                            //判断小数点后的位数,只允许输入2位
                            if tt <= 2 {
                                return true
                            }else{
                                return false
                            }
                        } else if isFirstZero && !isHaveDian{
                            //首位有0没.不能再输入0
                            return false
                        }else{
                            ///整数部分不能超过8位，与数据库匹配
                            if textField.text?.count > 7 {
                                return false
                            }
                            return true
                        }
                    }
                }
            }else{
                //输入的数据格式不正确
                return false
            }
        }else{
            return true
        }
        return true
    }
}
