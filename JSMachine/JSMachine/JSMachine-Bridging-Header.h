//
//  JSMachine-Bridging-Header.h
//  JSMachine
//  桥接文件
//  Created by gouyz on 2018/11/21.
//  Copyright © 2018 gouyz. All rights reserved.
//

#import <UIKit/UIKit.h>

/// OC工具类 验证银行卡等
#import "GYZCheckTool.h"
/// 微信支付
#import "WXApi.h"
/// qq
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>

/// 多标签选择
#import "HXTagsView.h"
#import "HXTagAttribute.h"
#import "HXTagCollectionViewFlowLayout.h"
/// 高度可定制化环形进度条
#import "ZZCircleProgress.h"

/// 极光推送相关头文件
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
