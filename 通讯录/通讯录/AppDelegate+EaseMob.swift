//
//  AppDelegate+EaseMob.swift
//  通讯录
//
//  Created by admin on 16/4/8.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate{
    
    func easemobApplication(application:UIApplication, launchOptions:NSDictionary, appKey:String, apnsCerName:String, otherConfig:NSDictionary){
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.loginStateChange(_:)), name: KNOTIFICATION_LOGINCHANGE, object: nil)
        
        EaseSDKHelper.shareHelper().easemobApplication(application, didFinishLaunchingWithOptions: launchOptions as [NSObject : AnyObject], appkey: appKey, apnsCertName: apnsCerName, otherConfig: otherConfig as [NSObject : AnyObject])
        
        EaseSDKHelper.shareHelper()
        
        let isAutoLogin = EMClient.sharedClient().isAutoLogin
        if isAutoLogin{
            NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGINCHANGE, object: true)
        }else{
            NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGINCHANGE, object: false)
        }
        
    }
    
    func loginStateChange(notificaiton:NSNotification){
        let loginSuccess = notificaiton.object as! Bool
//        let loginSuccess = notification.object().boolValue;
//        UINavigationController *navigationController = nil;
        if (loginSuccess) {//登陆成功加载主窗口控制器
            //加载申请通知的数据
            ApplyViewController.shareController().loadDataSourceFromLocalDB()
            mainTabBarController = MainTabBarController();
            self.window!.rootViewController = mainTabBarController
            ChatDemoHelper.shareHelper().mainVC =  mainTabBarController
            ChatDemoHelper.shareHelper().asyncPushOptions()
            ChatDemoHelper.shareHelper().asyncGroupFromServer()
            ChatDemoHelper.shareHelper().asyncConversationFromDB()
        }else{//登陆失败加载登陆页面控制器
            mainTabBarController = nil;
            ChatDemoHelper.shareHelper().mainVC = nil;
            let loginController = LoginViewController();
            let navigationController = BaseNavigationController(rootViewController:loginController);
            self.window!.rootViewController = navigationController;
            
//            [self clearParse];
        }
        
        
    }
    
    //MARK APP delegate
}