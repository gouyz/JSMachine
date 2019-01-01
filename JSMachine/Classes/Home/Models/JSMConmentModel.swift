//
//  JSMConmentModel.swift
//  JSMachine
//  客户评论model
//  Created by gouyz on 2019/1/1.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit

@objcMembers
class JSMConmentModel: LHSBaseModel {
    /// 评论model
    var conmentModels: [JSMConmentDetailModel] = [JSMConmentDetailModel]()
    /// 用户评价着装，持上岗证满意度比例
    var post: String? = ""
    /// 用户评价态度友善满意度比例
    var manner: String? = ""
    /// 用户评价工作效率满意度比例
    var efficient: String? = ""
    /// 用户评价准时处理满意度比例
    var time: String? = ""
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "sale_app_rec"{
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = JSMConmentDetailModel(dict: dict)
                conmentModels.append(model)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}

/// 评论详情 model
@objcMembers
class JSMConmentDetailModel: LHSBaseModel {
    /// 用户售后的申请问题
    var f_reason : String? = ""
    /// 用户姓名
    var a_name : String? = ""
    /// 用户手机号
    var a_phone : String? = ""
    /// 用户的头像
    var head : String? = ""
    /// 是否穿工作服持上岗证 （1是0否）
    var is_post : String? = ""
    /// 态度是否友好 （1是0否）
    var is_manner : String? = ""
    /// 效率是否高效 （1是0否）
    var is_efficient : String? = ""
    /// 是否准时上门处理 （1是0否）
    var is_time : String? = ""
    /// 用户的评价建议
    var pj_jy : String? = ""
    /// 用户的评价时间
    var w_date : String? = ""
}
