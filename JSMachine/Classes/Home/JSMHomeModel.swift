//
//  JSMHomeModel.swift
//  JSMachine
//  首页model
//  Created by gouyz on 2018/12/11.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

@objcMembers
class JSMHomeModel: LHSBaseModel {
    /// banner
    var bannerModels: [JSMHomeBannerModel] = [JSMHomeBannerModel]()
    /// 热点model
    var hotModels: [JSMHotModel] = [JSMHotModel]()
    /// 资讯model
    var newModels: [JSMNewsModel] = [JSMNewsModel]()
    /// 平台介绍地址
    var platform_url: String? = ""
    /// 招商加盟地址
    var join_url: String? = ""
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "banner"{
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = JSMHomeBannerModel(dict: dict)
                bannerModels.append(model)
            }
        }else if key == "hot"{
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = JSMHotModel(dict: dict)
                hotModels.append(model)
            }
        }else if key == "trade"{
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = JSMNewsModel(dict: dict)
                newModels.append(model)
            }
        }
        else {
            super.setValue(value, forKey: key)
        }
    }
}

/// 首页hot model
@objcMembers
class JSMHotModel: LHSBaseModel {
    /// id
    var id : String?
    /// 热点内容
    var content : String? = ""
}
/// 首页banner model
@objcMembers
class JSMHomeBannerModel: LHSBaseModel {
    /// id
    var id : String?
    /// 图片
    var img : String? = ""
}