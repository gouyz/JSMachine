//
//  JSMSaleServiceRecordModel.swift
//  JSMachine
//  维修记录 model
//  Created by gouyz on 2018/12/19.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

@objcMembers
class JSMSaleServiceRecordModel: LHSBaseModel {
    
    /// 图片地址
    var imgList: [String] = [String]()
    /// 记录id
    var list_id: String? = ""
    /// 机械型号
    var w_model: String? = ""
    /// 故障原因
    var w_reason: String? = ""
    /// 维修备注说明
    var w_remark: String? = ""
    /// 维修日期
    var w_date: String? = "0"
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "w_pic"{
            guard let datas = value as? [[String : String]] else { return }
            for dict in datas {
                imgList.append(dict["pic"]!)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}

@objcMembers
class JSMSaleServiceRecordListModel: LHSBaseModel {
    
    /// 记录list
    var recordList: [JSMSaleServiceRecordModel] = [JSMSaleServiceRecordModel]()
    /// status =2 时可以继续添加记录，当status>=3时，不能继续添加记录，显示已完成
    var status: String? = ""
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "list_res"{
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = JSMSaleServiceRecordModel(dict: dict)
                recordList.append(model)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
