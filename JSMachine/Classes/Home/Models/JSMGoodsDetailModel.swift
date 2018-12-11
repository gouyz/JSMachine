//
//  JSMGoodsDetailModel.swift
//  JSMachine
//  商品详情model
//  Created by gouyz on 2018/12/11.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

@objcMembers
class JSMGoodsDetailModel: LHSBaseModel {
    /// 商品model
    var goodsModel: JSMGoodsModel?
    /// 图片地址
    var goodImgList: [String] = [String]()
    /// 图文详情url地址
    var image_text_url: String? = ""
    /// 产品参数url
    var parameter_url: String? = ""
    /// 关注 0:未关注，1：已关注
    var follow: String? = "0"
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "good_img"{
            guard let datas = value as? [[String : String]] else { return }
            for dict in datas {
                goodImgList.append(dict["pic"]!)
            }
        }else if key == "shop_name"{
            guard let datas = value as? [String : Any] else { return }
            goodsModel = JSMGoodsModel(dict: datas)
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
