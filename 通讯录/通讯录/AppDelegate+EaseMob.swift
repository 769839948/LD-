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
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("loginStateChange:"), name: KNOTIFICATION_LOGINCHANGE, object: nil)
        
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
            let loginController = LoginViewController();
            let navigationController = UINavigationController(rootViewController:loginController);
            self.window!.rootViewController = navigationController;
//            let mainViewController = MainTabBarController();
//            self.window!.rootViewController = mainViewController;
        }else{//登陆失败加载登陆页面控制器
//            self.mainController = nil;
//            [ChatDemoHelper shareHelper].mainVC = nil;
            let loginController = LoginViewController();
            let navigationController = UINavigationController(rootViewController:loginController);
            self.window!.rootViewController = navigationController;

//            [self clearParse];
        }
        
        
    }
    
    //MARK APP delegate
}