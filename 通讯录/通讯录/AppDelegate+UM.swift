//
//  AppDelegate+UM.swift
//  通讯录
//
//  Created by admin on 16/4/14.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import Foundation
import UIKit

let AppKey = "57071c9d67e58e5385002054"

extension AppDelegate{
    
    func umShareApplication(application:UIApplication, launchOptions:NSDictionary, appKey:String){
        CoreUMeng.umengSetAppKey(AppKey)
        //集成新浪
        CoreUMeng.umengSetSinaSSOWithRedirectURL("http://sns.whalecloud.com/sina2/callback");
        //集成微信
//        CoreUMeng.umengSetWXAppId(<#T##String!#>, appSecret: <#T##String!#>, url: <#T##String!#>)WXAPPID appSecret:WXAPPsecret url:WXUrl);
        //集成QQ
        CoreUMeng.umengSetQQAppId("100424468", appSecret: "c7394704798a158208a74ab60104f0ba", url: "http://www.qq.com/")
    }
    
    func application(application:UIApplication, handleOpenURL:NSURL) -> Bool{
        return CoreUMeng.umengHandleOpenURL(handleOpenURL)
    }
    
    func application(application:UIApplication, openUrl:NSURL, sourcesApplication:String, annotation:AnyObject) -> Bool{
        return CoreUMeng.umengHandleOpenURL(openUrl)
    }
    
}