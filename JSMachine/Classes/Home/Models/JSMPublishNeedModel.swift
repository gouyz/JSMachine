//
//  JSMPublishNeedModel.swift
//  JSMachine
//  发布需求 model
//  Created by gouyz on 2018/12/11.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

@objcMembers
class JSMPublishNeedModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 用户姓名
    var needs : String? = ""
    ///      用户头像
    var head : String? = ""
    /// 创建日期
    var create_date : String? = ""
    /// 产品型号
    var pro_model : String? = ""
    /// 产品转速
    var pro_speed : String? = ""
    /// 传动比
    var drive_ratio : String? = ""
    /// 产品数量
    var num : String? = ""
    /// 交货日期
    var deal_date : String? = ""
    /// 用户备注
    var remark : String? = ""
    /// 0：已提交、1：确认有货、2：已上传合同、3：确认合同（未发货）、4：发货（已发货）、5：确认收货（完成）
    var status : String? = ""
}
