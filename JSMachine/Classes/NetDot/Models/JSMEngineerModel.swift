//
//  JSMEngineerModel.swift
//  JSMachine
//  工程师model
//  Created by gouyz on 2019/4/12.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit

@objcMembers
class JSMEngineerModel: LHSBaseModel {
    /// 工程师id
    var id : String?
    /// 工号
    var code : String? = ""
    /// 工职
    var position : String? = ""
    /// 手机号
    var phone : String? = ""
    /// 图片
    var head : String? = ""
    /// 姓名
    var real_name : String? = ""
    /// 地址
    var address : String? = ""
    /// 入职时间
    var date : String? = ""
}
@objcMembers
class JSMWorkTypeModel: LHSBaseModel {
    /// 职位id
    var id : String?
    /// 职位名称
    var position : String? = ""
}
