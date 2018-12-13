//
//  JSMGoodsParamsModel.swift
//  JSMachine
//  产品参数详情
//  Created by gouyz on 2018/12/13.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

@objcMembers
class JSMGoodsParamsModel: LHSBaseModel {

    var goodsModel: JSMGoodsModel?
    var typeList: [JSMGoodsTypeModel] = [JSMGoodsTypeModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "param"{
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = JSMGoodsTypeModel(dict: dict)
                typeList.append(model)
            }
        }else if key == "shop"{
            guard let datas = value as? [String : Any] else { return }
            goodsModel = JSMGoodsModel(dict: datas)
        }else {
            super.setValue(value, forKey: key)
        }
    }
}

/// 商品型号 model
@objcMembers
class JSMGoodsTypeModel: LHSBaseModel {
    /// 产品型号
    var p_model : String?
    /// 图片
    var ratioList : [String] = [String]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "p_drive_ratio"{
            guard let datas = value as? [String] else { return }
            for item in datas {
                ratioList.append(item)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
