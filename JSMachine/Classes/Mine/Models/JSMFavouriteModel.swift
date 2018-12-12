//
//  JSMFavouriteModel.swift
//  JSMachine
//  我的收藏 model
//  Created by gouyz on 2018/12/12.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

@objcMembers
class JSMFavouriteModel: LHSBaseModel {
    /// id
    var id : String?
    /// 图片
    var img : String? = ""
    /// 产品的名称
    var shop_name : String? = ""
    /// 商品id
    var shop_id : String? = ""
    /// 多少人关注
    var sum : String? = "0"
}
