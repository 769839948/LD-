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
        UMSocialData.setAppKey(AppKey)
    }
}