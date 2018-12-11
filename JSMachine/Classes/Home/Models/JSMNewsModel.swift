//
//  JSMNewsModel.swift
//  JSMachine
//  行业资讯  model
//  Created by gouyz on 2018/12/11.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

@objcMembers
class JSMNewsModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 资讯标题
    var title : String? = ""
    /// 资讯摘要
    var subtitle : String? = ""
    /// 时间
    var add_time : String? = ""
    /// 资讯展示图
    var img : String? = ""
    /// 资讯详情地址
    var url : String? = ""
}
