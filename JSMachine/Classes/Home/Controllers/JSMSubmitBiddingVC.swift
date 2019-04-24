//
//  JSMSubmitBiddingVC.swift
//  JSMachine
//  //  提交竞标
//  Created by gouyz on 2019/4/24.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import IQKeyboardManagerSwift

private let submitBiddingCell = "submitBiddingCell"
private let submitBiddingHeaderView = "submitBiddingHeaderView"

class JSMSubmitBiddingVC: UIViewController {
    
    /// 闭包
    var didSubmitBlock : ((_ prices:String,_ selectTime: Int) -> ())?
    
    /// contentView高度
    var contentVH : CGFloat = 0
    /// contentView的y值
    var contentViewY : CGFloat = 0
    /// 数据源
    var detailModel: JSMNeedModel?
    
    /// 选择时间戳
    var selectTime: Int = 0
    var selectTimeStr: String = ""
    var priceDic: [Int:String] = [Int:String]()
    
    ///输入是否有小数点
    var isHaveDian: Bool = false
    ///输入第一位是否是0
    var isFirstZero: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(bgButton)
        self.view.addSubview(contentView)
        contentView.addSubview(footerBtn)
        contentView.addSubview(tableView)
        
        setupDefaultStyle()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //隐藏键盘上的工具条(默认打开)
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //隐藏键盘上的工具条(默认打开)
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    /// 背景view
    fileprivate lazy var bgButton : UIView = {
        let btn = UIView.init(frame: self.view.frame)
        btn.backgroundColor = UIColor.black
        btn.alpha = 0.35
        btn.addOnClickListener(target: self, action: #selector(dismissSheetView))
        
        return btn
    }()
    /// title和sheetView的容器View
    fileprivate lazy var contentView : UIView = UIView()
    /// 按钮
    fileprivate lazy var footerBtn : UIButton = {
        let btn = UIButton.init(frame: CGRect.zero)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitle("提交", for: .normal)
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.cornerRadius = 22
        btn.addTarget(self, action: #selector(onClickedSubmit), for: .touchUpInside)
        
        return btn
    }()
    
    /// 标题view
    fileprivate lazy var titleView : UILabel = {
        let lab = UILabel()
        lab.font = k18Font
        lab.textColor = kBlueFontColor
        lab.backgroundColor = kWhiteColor
        lab.text = "竞标"
        lab.textAlignment = .center
        
        return lab
    }()
    /// 初始化tableView
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        
        table.register(JSMSubmitBidingCell.self, forCellReuseIdentifier: submitBiddingCell)
        table.register(LHSGeneralHeaderView.self, forHeaderFooterViewReuseIdentifier: submitBiddingHeaderView)
        return table
    }()
    
    /// 默认样式
    fileprivate func setupDefaultStyle(){
        
        contentView.backgroundColor = kWhiteColor
        titleView.frame = CGRect.init(x: 0, y: 0, width: kSheetViewWidth, height: kCellH)
        contentView.addSubview(titleView)
        
        ///contentView高度
        contentVH = kCellH * CGFloat(((detailModel?.needProductsModels.count)! + 2)) + kCellH
        if contentVH > kSheetViewMaxH {
            contentVH = kSheetViewMaxH
            tableView.isScrollEnabled = true
        } else {
            tableView.isScrollEnabled = false
        }
        contentViewY = kScreenHeight - contentVH
        contentView.frame = CGRect.init(x: 0, y: contentViewY, width: kScreenWidth, height: contentVH)
        let sheetHeight = contentView.height - titleView.height - kCellH
        
        tableView.frame = CGRect.init(x: 0, y: titleView.bottomY, width: contentView.width, height: sheetHeight)
        footerBtn.frame = CGRect.init(x: 20, y: tableView.bottomY + 20, width: kScreenWidth - 40, height: kTitleHeight)
        
    }
    
    //消失默认样式
    func dismissDefaulfSheetView(){
        self.dismiss(animated: true, completion: nil)
    }
    /// 消失样式
    @objc func dismissSheetView(){
        dismissDefaulfSheetView()
    }
    /// 提交
    @objc func onClickedSubmit(){
        if priceDic.count != detailModel?.needProductsModels.count {
            MBProgressHUD.showAutoDismissHUD(message: "竞标价填写不完整")
            return
        }
        if selectTime == 0 {
            MBProgressHUD.showAutoDismissHUD(message: "请选择预发货日期")
            return
        }
        
        if didSubmitBlock != nil {
            var prices: String = ""
            for key in priceDic.keys{
                prices += priceDic[key]! + " / "
            }
            prices = prices.subString(start: 0, length: prices.count - 3)
            didSubmitBlock!(prices,selectTime)
        }
        dismissDefaulfSheetView()
    }
    
    func selectDate(){
        UsefulPickerView.showDatePicker("请选择预发货日期") { [weak self](date) in
            self?.selectTime = Int(date.timeIntervalSince1970)
            self?.selectTimeStr = date.dateToStringWithFormat(format: "yyyy-MM-dd")
            self?.tableView.reloadData()
        }
    }
    
    //监听文本输入变化
    @objc func txtFieldChangeValue(txtFiled : UITextField){
        let tag = txtFiled.tag
        priceDic[tag] = txtFiled.text!
    }
}

extension JSMSubmitBiddingVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if detailModel != nil {
            return (detailModel?.needProductsModels.count)! + 1
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: submitBiddingCell) as! JSMSubmitBidingCell
        cell.textFiled.delegate = self
        cell.textFiled.tag = indexPath.row
        if indexPath.row == detailModel?.needProductsModels.count {// 交货日期
            cell.desLab.text = "选择预发货日期:"
            cell.textFiled.placeholder = "请选择预发货日期"
            cell.textFiled.isEnabled = false
            cell.textFiled.text = selectTimeStr
            cell.textFiled.keyboardType = .default
        }else{
            let model = detailModel?.needProductsModels[indexPath.row]
            cell.desLab.text = (model?.pro_model)! + ":"
            cell.textFiled.placeholder = "请输入竞标价"
            cell.textFiled.keyboardType = .decimalPad
            cell.textFiled.isEnabled = true
            cell.textFiled.addTarget(self, action: #selector(txtFieldChangeValue(txtFiled : )), for: .editingChanged)
            
            if priceDic.keys.contains(indexPath.row){
                cell.textFiled.text = priceDic[indexPath.row]
            }else{
                cell.textFiled.text = ""
            }
        }
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == detailModel?.needProductsModels.count {// 交货日期
            selectDate()
        }
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCellH
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
extension JSMSubmitBiddingVC: UITextFieldDelegate{
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
