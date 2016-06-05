//
//  ContactViewModel.swift
//  通讯录
//
//  Created by admin on 16/4/5.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Alamofire
import CoreData

//typealias successRequestClosure = (string:AnyObject) -> Void
//typealias errorRequestClosure = (string:AnyObject) -> Void
//typealias netErrorRequestClosure = (string:AnyObject) -> Void




class ContactViewModel: BaseRequestViewModel {
    func loadContact(companyName:String) -> RACSignal{
        let url = "\(BaseUrl)\(GetCompanyUser)"
        let signal = RACSignal.createSignal { (subscriber) -> RACDisposable! in
            Alamofire.request(.POST, url, parameters: ["companyName":companyName], encoding: ParameterEncoding.URL, headers: nil).responseJSON(completionHandler: { (response) -> Void in
                if response.result.error == nil {
//                    print(response.result.value)
                    let model = ContactModel.mj_objectWithKeyValues(response.result.value)
                    model.contacts = Contacts.mj_objectArrayWithKeyValuesArray(model.contacts)
                    
//                    let context = NSManagedObjectContext();
//                    let contacts = Contacts.mj_objectWithKeyValues(response.result.value, context: context)
//                    do {
//                        try context.save()
//                    }catch{
//                        
//                    }
                    subscriber.sendNext(model)
                    subscriber.sendCompleted()
                    
                }else{
                    self.hidder(msg:"")
                    print(response.result.error)
                }
            })
            return nil
        }
        return signal
    }
    
    func contactGroup(companyName:String) -> RACSignal{
        let url = "\(BaseUrl)\(GetCompanyGroup)"
        let signal = RACSignal.createSignal { (subscriber) -> RACDisposable! in
            Alamofire.request(.POST, url, parameters: ["companyName":companyName], encoding: ParameterEncoding.URL, headers: nil).responseJSON(completionHandler: { (response) -> Void in
                if response.result.error == nil {
//                    print(response.result.value)
                    let model = GroupModel.mj_objectWithKeyValues(response.result.value)
                    let depatment = model.department
                    let contacts = Groups.mj_objectArrayWithKeyValuesArray(depatment.groups)
                    subscriber.sendNext(contacts)
                    subscriber.sendCompleted()
                    
                }else{
                    if self.hidder != nil {
                        self.hidder(msg:"")
                    }
                    
                    print(response.result.error)
                }
            })
            return nil
        }
        return signal
    }
    
    func changeContact(contact:Contacts) -> RACSignal{
        let url = "\(BaseUrl)\(ChangeContact)"
        saveContacts(contact)
        let signal = RACSignal.createSignal { (subscriber) -> RACDisposable! in
            Alamofire.request(.POST, url, parameters: ["username":contact.username!,"phone":contact.phone!,"home":contact.home!,"department":contact.department!,"position":contact.position!,"email":contact.email!,"qq":contact.qq!,"age":contact.age!,"company":contact.company!], encoding: ParameterEncoding.URL, headers: nil).responseJSON(completionHandler: { (response) -> Void in
                if response.result.error == nil {
//
                    do{
                        let dic = try NSJSONSerialization.JSONObjectWithData(response.result.value as! NSData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                        subscriber.sendNext(dic["code"])
                        subscriber.sendCompleted()
                    }catch{
                        self.hidder(msg:"")
                        subscriber.sendNext("error")
                        subscriber.sendCompleted()
                    }
                    
                    
                    
                }else{
                    print(response.result.error)
                }
            })
            return nil
        }
        
        return signal
    }
    
    func editTableNameArray() -> NSArray {
        return ["用户名:","电    话:","家    乡:","部    门:","职    位:","邮    箱:","Q    Q:","年    龄:","公    司:"]
    }
    
    func editTableTextArray() -> NSArray {
        return ["请输入用户名","请输入电话","请输入家乡","请输入部门","请输入职位","请输入邮箱","请输入QQ","请输入年龄","请输入公司"]
    }
}
