//
//  JPush.swift
//  通讯录
//
//  Created by Zhang on 5/20/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate{
    
    func applicationJPush(application:UIApplication,launchOptions:[NSObject: AnyObject]?){
        let systemVersion = Float(UIDevice.currentDevice().systemVersion)
        if systemVersion >= 8.0{
            JPUSHService.registerForRemoteNotificationTypes(1, categories: nil)
        }else{
            JPUSHService.registerForRemoteNotificationTypes(1, categories: nil)
        }
        JPUSHService.setupWithOption(launchOptions, appKey: JPushappKey, channel: channel, apsForProduction: true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.setAxisTage(_:)), name: "setAxisTage", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.removeAxisTage(_:)), name: "removeAxisTage", object: nil)
    }
    
    
    func setAxisTage(notification:NSNotification){
        JPUSHService.setAlias(notification.object as! String, callbackSelector: #selector(AppDelegate.tagsAliasCallback(_:tags:alias:)), object: nil)
    }
    
    func removeAxisTage(notification:NSNotification){
        JPUSHService.setAlias("" , callbackSelector: #selector(AppDelegate.tagsAliasCallback(_:tags:alias:)), object: nil)
    }
    
    func tagsAliasCallback(iResCode:Int, tags:Int, alias:String){
        
    }
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            EMClient.sharedClient().bindDeviceToken(deviceToken)
        }
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        JPUSHService.resetBadge()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        if ((mainTabBarController) != nil){
            mainTabBarController.jumpToChatList()
        }
        let apsDic = userInfo as NSDictionary
        let aps = apsDic.valueForKey("aps") as! NSDictionary
        let content = aps.valueForKey("alert") as! String
        if !NSUserDefaults.standardUserDefaults().boolForKey("readMgs"){
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "readMgs")
            let array = NSMutableArray()
            array.addObject(content)
            NSUserDefaults.standardUserDefaults().setValue(array, forKey: "contents")
        }else{
            let array = NSUserDefaults.standardUserDefaults().objectForKey("contents") as! NSMutableArray
            array.addObject(content)
            NSUserDefaults.standardUserDefaults().setValue(array, forKey: "contents")
        }
        
        let badge = aps.valueForKey("badge") as! NSInteger
        let sound = aps.valueForKey("sound") as! String
        
        if application.applicationState == UIApplicationState.Active{
            
        }else if application.applicationState == UIApplicationState.Inactive{
            
        }
        
    }
    
}