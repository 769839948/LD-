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
    
    var contactModels:[ContectsModel]!
    
    func loadContact() -> RACSignal{
        let signal = RACSignal.createSignal { (subscriber) -> RACDisposable! in
            self.requestNetGet(["":""], url: "", headrer: nil, requestSuccess: { (response,data) -> Void in
                subscriber.sendNext(response)
                subscriber.sendCompleted()
                }, requestError: { (string) -> Void in
                subscriber.sendNext(string)
                subscriber.sendCompleted()
            })
            return nil
        }
        return signal
    }
    
    func testloadContact() -> RACSignal{
        let signal = RACSignal.createSignal { (subscriber) -> RACDisposable! in
            var contacts = [ContectsModel]()
                        let string = "A"
            let number = Int(string)
            let stringq = "Z"
            let numberq = Int(stringq)
            print("\(number)\(numberq)")
            for _ in 0...100{
                let model = ContectsModel()
                model.userPhoto = "address_book"
                model.userName = self.randomString(10)
                model.userPhone = "18363899711"
                model.userGroup = "技术部"
                model.userEmail = "769839948@qq.com"
                model.userSchool = "暂无"
                contacts.append(model)
            }
            subscriber.sendNext(contacts)
            subscriber.sendCompleted()
            return nil
        }
        return signal
    }
    
    func random(min:UInt32,max:UInt32)->UInt32{
        return  arc4random_uniform(max-min)+min
    }
    
    func randomString(len:Int)->String{
        let min:UInt32=65,max:UInt32=91
        var string=""
        for _ in 0..<len{
            string.append(UnicodeScalar(random(min,max:max)))
        }
        return string
        
    }
}
