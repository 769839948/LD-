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


//func description() -> String {
//    return "\(Contacts.username)"
//}


func saveContacts(model:Contacts){
    NSUserDefaults.standardUserDefaults().setObject(model.username, forKey: "username")
    NSUserDefaults.standardUserDefaults().setObject(model.phone, forKey: "phone")
    NSUserDefaults.standardUserDefaults().setObject(model.age, forKey: "age")
    NSUserDefaults.standardUserDefaults().setObject(model.department, forKey: "department")
    NSUserDefaults.standardUserDefaults().setObject(model.email, forKey: "email")
    NSUserDefaults.standardUserDefaults().setObject(model.qq, forKey: "qq")
    NSUserDefaults.standardUserDefaults().setObject(model.home, forKey: "home")
    NSUserDefaults.standardUserDefaults().setObject(model.position, forKey: "position")
    NSUserDefaults.standardUserDefaults().setObject(model.company, forKey: "company")
}

func getContactsValue(string:String) -> AnyObject{
    return NSUserDefaults.standardUserDefaults().objectForKey(string)!
}

func getContacts() -> Contacts{
    let contact =  Contacts()
    contact.username = getContactsValue("username") as! String
    contact.phone = getContactsValue("phone") as! String
    contact.age = getContactsValue("age") as! String
    contact.department = getContactsValue("department") as! String
    contact.email = getContactsValue("email") as! String
    contact.qq = getContactsValue("qq") as! String
    contact.home = getContactsValue("home") as! String
    contact.position = getContactsValue("position") as! String
    return contact
}

func setContactsValue(string:String){
    NSUserDefaults.standardUserDefaults().setObject(string, forKey: "string")
}

func uploadUserMessage(model:Contacts){
    let dic = [kPARSE_HXUSER:"",kPARSE_HXUSER_USERNAME:model.phone,kPARSE_HXUSER_NICKNAME:model.username,kPARSE_HXUSER_AVATAR:""]
    UserProfileManager.sharedInstance().updateUserProfileInBackground(dic) { (success, error) -> Void in
        
    }
}
