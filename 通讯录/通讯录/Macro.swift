//
//  Macro.swift
//  通讯录
//
//  Created by admin on 16/4/5.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import Foundation
import ReactiveCocoa
import MJExtension
import MJRefresh
import SDWebImage
import SnapKit
import Alamofire

let BaseUrl = "http://zhangs-macbook-pro.local:8080/Contact/"
let RequestLogin = "userLogin"
let GetCompanyUser = "getCompanyUserAction"
let GetCompanyGroup = "getCompanyGroup"
let GetAllCompany = "getCompanyAction"
let ChangeContact = "changeContactAction"
let RegisterAction = "userRegister"
let ChangePasswordAction = "changePassword"

let JPushappKey = "e019de7de82ef898f36fda81"
let JPushappMaster = "d648b6a385ba46c9005a448d"
let channel = "Publish channel"

let UISCREEN_SIZE = UIScreen.mainScreen().bounds

let KNOTIFICATION_LOGINCHANGE = "LOGINSTATECHANGE"

let THEMECOLOR = UIColor(colorLiteralRed: 0.0/255.0, green: 204.0/255.0, blue: 53.0/255.0, alpha: 1.0)