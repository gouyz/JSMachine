//
//  JSMSaleServiceOrderModel.swift
//  JSMachine
//  售后订单model
//  Created by gouyz on 2018/12/18.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

@objcMembers
class JSMSaleServiceOrderModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 故障原因
    var f_reason : String? = ""
    /// 提交申请的时间
    var a_date : String? = ""
    /// 联系人
    var a_name : String? = ""
    /// 联系电话
    var a_phone : String? = ""
    /// 备注
    var a_remark : String? = ""
    /// 公司地址（市/区）
    var c_address : String? = "0"
    /// 公司地址（具体）
    var s_address : String? = "0"
    /// 机械型号
    var model : String? = ""
    /// 是否申请部件（0否，1是）
    var a_part : String? = ""
    /// 处理状态（0：未分配，1和2：已分配,3：完成,4和5：查看）
    /// 状态（0，提交状态)(1,已分配状态)(2,上门维修)(3,工程师维修完成)（4，客户维修完成）
    var status : String? = ""
    /// 维修工程师电话
    var w_phone : String? = ""
    /// 是否评价 0未评价 1已评价
    var is_pj : String? = "0"
}
