//
//  JSMNeedConmentModel.swift
//  JSMachine
//  需求评价
//  Created by gouyz on 2019/4/11.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit

@objcMembers
class JSMNeedConmentModel: LHSBaseModel {

    /// 用户综合分数
    var score : String? = ""
    /// 竞标者昵称
    var nickname : String? = ""
    /// 头像
    var head : String? = ""
    /// 客服打分
    var cscore : String? = ""
    /// 商品打分
    var pscore : String? = ""
    /// 评价时间 时间戳
    var pj_time : String? = ""
    /// 物流打分
    var wscore : String? = ""
    /// 评价
    var evaluate : String? = ""
    var imgList: [String] = [String]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "image"{
            guard let datas = value as? [String] else { return }
            for dict in datas {
                imgList.append(dict)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
