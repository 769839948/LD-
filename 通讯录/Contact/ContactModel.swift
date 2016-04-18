//
//  ContectsModel.swift
//  通讯录
//
//  Created by admin on 16/4/5.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit
import Contacts

class Contacts:NSObject {
    var username:String!
    var phone:String!
    var age:String!
    var department:String!
    var email:String!
    var qq:String!
    var home:String!
    var position:String!
    var company:String!
}

class ContactModel: NSObject {
    var contacts:NSMutableArray!
    var success:Bool!
}


