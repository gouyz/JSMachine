//
//  JSMJingBiaoModel.swift
//  JSMachine
//  竞标model
//  Created by gouyz on 2019/4/10.
//  Copyright © 2019 gouyz. All rights reserved.
//

import UIKit

@objcMembers
class JSMJingBiaoModel: LHSBaseModel {
    /// id
    var id : String? = ""
    /// 产品型号
    var pro_model : String? = ""
    /// 产品数量
    var num : String? = ""
    /// 发布者昵称
    var nickname : String? = ""
    /// 发布者头像
    var head : String? = ""
    /// 发布时间
    var create_date : String? = ""
    /// 交货日期
    var deal_date : String? = ""
    /// 发布者备注
    var remark : String? = ""
    /// 竞标价格
    var price : String? = ""
    /// 竞标交货日期
    var time : String? = ""
    /// 发布者联系方式
    var phone : String? = ""
    /// 状态（0：已提交、1:等待上传合同、2：已上传合同、3：确认合同（未发货，等待上传打款凭证）、4：发货（已发货）、5：确认收货（完成））6.已上传打款凭证. 7已评价
    var status : String? = ""
}
