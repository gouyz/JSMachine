//
//  JSMBiddingPersonModel.swift
//  JSMachine
//  竞标者model
//  Created by gouyz on 2019/4/11.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit

@objcMembers
class JSMBiddingPersonModel: LHSBaseModel {
    ///  需求id 招标时需要用到
    var id : String? = ""
    var personList: [JSMBiddingPersonDataModel] = [JSMBiddingPersonDataModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "data"{
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = JSMBiddingPersonDataModel(dict: dict)
                personList.append(model)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
@objcMembers
class JSMBiddingPersonDataModel: LHSBaseModel {
    /// 竞标者竞标记录id
    var b_id : String? = ""
    /// 竞标者id
    var bidder_id : String? = ""
    /// 用户综合分数
    var score : String? = ""
    /// 竞标者昵称
    var nickname : String? = ""
    /// 头像
    var head : String? = ""
    /// 手机号
    var phone : String? = ""
    /// 竞标价格
    var b_price : String? = ""
    /// 竞标交货日期
    var b_delivery_time : String? = ""
}
