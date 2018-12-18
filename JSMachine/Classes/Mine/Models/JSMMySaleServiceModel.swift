//
//  JSMMySaleServiceModel.swift
//  JSMachine
//  申请售后 model
//  Created by gouyz on 2018/12/17.
//  Copyright © 2018 gouyz. All rights reserved.
//

import UIKit

@objcMembers
class JSMMySaleServiceModel: LHSBaseModel {
    /// 常见问题model
    var problemModels: [JSMNewsModel] = [JSMNewsModel]()
    /// 处理中的未查看数量
    var handingNum: String? = "0"
    /// 已处理的未查看数量
    var handedNum: String? = "0"
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "problem_url"{
            guard let datas = value as? [[String : Any]] else { return }
            for dict in datas {
                let model = JSMNewsModel(dict: dict)
                problemModels.append(model)
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
