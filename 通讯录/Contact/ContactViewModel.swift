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

//typealias successRequestClosure = (string:AnyObject) -> Void
//typealias errorRequestClosure = (string:AnyObject) -> Void
//typealias netErrorRequestClosure = (string:AnyObject) -> Void


class ContactViewModel: BaseRequestViewModel {
    func loadContact() -> RACSignal{
        let url = "\(BaseUrl)\(GetCompanyUser)"
        let signal = RACSignal.createSignal { (subscriber) -> RACDisposable! in
            Alamofire.request(.POST, url, parameters: ["companyName":"观微科技"], encoding: ParameterEncoding.URL, headers: nil).responseJSON(completionHandler: { (response) -> Void in
                if response.result.error == nil {
                    print(response.result.value)
                    let model = ContactModel.mj_objectWithKeyValues(response.result.value)
                    model.contacts = Contacts.mj_objectArrayWithKeyValuesArray(model.contacts)
        
                    subscriber.sendNext(model)
                    subscriber.sendCompleted()
                    
                }else{
                    print(response.result.error)
                }
            })
            return nil
        }
        return signal
    }
    
    func contactGroup() -> RACSignal{
        let url = "\(BaseUrl)\(GetCompanyGroup)"
        let signal = RACSignal.createSignal { (subscriber) -> RACDisposable! in
            Alamofire.request(.POST, url, parameters: ["companyName":"观微科技"], encoding: ParameterEncoding.URL, headers: nil).responseJSON(completionHandler: { (response) -> Void in
                if response.result.error == nil {
                    print(response.result.value)
                    let model = GroupModel.mj_objectWithKeyValues(response.result.value)
                    let depatment = model.department
                    let contacts = Groups.mj_objectArrayWithKeyValuesArray(depatment.groups)
//                    let groups = NSMutableArray()
//                    for group in contacts {
//                        let model = group as! Groups
//                        model.contactsGroup = Contacts.mj_objectArrayWithKeyValuesArray(model.contactsGroup)
//                        groups.addObject(model)
//                    }
                    subscriber.sendNext(contacts)
                    subscriber.sendCompleted()
                    
                }else{
                    print(response.result.error)
                }
            })
            return nil
        }
        return signal
    }
}
