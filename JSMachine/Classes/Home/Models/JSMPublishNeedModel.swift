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
    /// 已提交(0已提交未确认有货，只能下载合同。1已确认有货，可以下载合同和上传合同。2已上传合同，还未审核合同是否有效，只能查看合同)。
    /// 未发货(3合同有效未发货，只能查看合同)
    /// 已发货(4已发货，待完成，可以查看合同和确认收货)
    /// 5完成订单,只能查看合同
    var status : String? = ""
}
