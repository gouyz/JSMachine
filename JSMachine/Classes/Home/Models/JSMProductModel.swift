//
//  JSMProductModel.swift
//  JSMachine
//
//  Created by gouyz on 2018/12/11.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

@objcMembers
class JSMProductModel: LHSBaseModel {
    /// 资讯model
    var goodsList: [JSMGoodsModel] = [JSMGoodsModel]()
    /// 分类的名称
    var class_name: String? = ""
    /// 分类的id
    var id: String? = ""
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "list"{
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = JSMGoodsModel(dict: dict)
                goodsList.append(model)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}


/// 商品 model
@objcMembers
class JSMGoodsModel: LHSBaseModel {
    /// id
    var id : String?
    /// 图片
    var img : String? = ""
    /// 产品的名称
    var shop_name : String? = ""
    /// 产品的转速
    var pro_speed : String? = ""
}
