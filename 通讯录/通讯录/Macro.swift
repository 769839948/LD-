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

let BaseUrl = "http://localhost:8080/Contact/"
let GetCompanyUser = "getCompanyUserAction"
let GetCompanyGroup = "getCompanyGroup"

let UISCREEN_SIZE = UIScreen.mainScreen().bounds

let KNOTIFICATION_LOGINCHANGE = "LOGINSTATECHANGE"

let THEMECOLOR = UIColor(colorLiteralRed: 0.0/255.0, green: 204.0/255.0, blue: 53.0/255.0, alpha: 1.0)