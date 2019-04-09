//
//  JSMNeedModel.swift
//  JSMachine
//  需求信息 model
//  Created by gouyz on 2019/4/9.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit

@objcMembers
class JSMNeedModel: LHSBaseModel {
    /// 需求id
    var id : String? = ""
    /// 需求id
    var need_id : String? = ""
    /// 产品型号
    var pro_model : String? = ""
    /// 产品数量
    var num : String? = ""
    /// 发布者昵称
    var n_nickname : String? = ""
    /// 发布者头像
    var n_head : String? = ""
    /// 发布时间
    var create_date : String? = ""
    /// 交货日期
    var deal_date : String? = ""
    /// 发布者备注
    var remark : String? = ""
    
    /// 需求产品model
    var needProductsModels: [JSMNeedProductModel] = [JSMNeedProductModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "need"{
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = JSMNeedProductModel(dict: dict)
                needProductsModels.append(model)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}

/// 产品需求model
@objcMembers
class JSMNeedProductModel: LHSBaseModel {
    
    /// 产品型号
    var pro_model : String? = ""
    /// 产品数量
    var num : String? = ""
    /// 备注
    var remark : String? = ""
}
