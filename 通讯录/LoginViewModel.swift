//
//  LoginViewModel.swift
//  通讯录
//
//  Created by admin on 16/4/12.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Alamofire



class LoginViewModel: BaseRequestViewModel {

    func loginEase(username:String, password:String){
        self.loginWithUsername(username,password:password)
    }
    
    func loadContact(model:UserModel){
        let url = "\(BaseUrl)\(RequestLogin)"
        if model.company != nil{
            let params = ["username":model.username,"password":model.password,"company":model.company]
            self.requestNetPost(params, url: url, headrer: nil, requestSuccess: { (response) -> Void in
                self.loginEase(model.username, password: model.password)
                NSUserDefaults.standardUserDefaults().setObject(model.company, forKey: "compayName")
                NSNotificationCenter.defaultCenter().postNotificationName("setAxisTage", object: model.username)
                NSUserDefaults.standardUserDefaults().setObject(model.username, forKey: "userPhone")
                }, requestError: { (error) -> Void in
                    print(error)
            })
        }
        
    }
    
    func getCompany() -> RACSignal{
        let url = "\(BaseUrl)\(GetAllCompany)"
        let signal = RACSignal.createSignal { (subscriber) -> RACDisposable! in
            let parmars = NSDictionary()
            self.requestNetPost(parmars, url: url, headrer: nil, requestSuccess: { (response) -> Void in
                let dic = response as! NSDictionary
                let array = dic["companys"]  as! NSArray
                subscriber.sendNext(array)
                subscriber.sendCompleted()
                }, requestError: { (error) -> Void in
                    print(error)
            })
            return nil
        }
        return signal
    }
    
    func loginWithUsername(username:String, password:String){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let logoutError = EMClient.sharedClient().logout(true)
            if logoutError == nil{
                
            }
            
            let error = EMClient.sharedClient().loginWithUsername(username, password: password)
            if error == nil {
                EMClient.sharedClient().options.isAutoLogin = true
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    EMClient.sharedClient().dataMigrationTo3()
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        ChatDemoHelper.shareHelper().asyncGroupFromServer()
                        ChatDemoHelper.shareHelper().asyncConversationFromDB()
                        ChatDemoHelper.shareHelper().asyncPushOptions()
                        NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGINCHANGE, object: true)
                        self.hidder(msg:"登录成功")
                        NSUserDefaults.standardUserDefaults().setObject(username, forKey: "UserPhone")
                    })
                    
                }
            }else{
                switch (error.code)
                {
                case EMErrorNetworkUnavailable:
                         TTAlertNoTitle("No network connection!");
                    break;
                case EMErrorServerNotReachable:
                    TTAlertNoTitle("Connect to the server failed!");
                    break;
                case EMErrorUserAuthenticationFailed:
                    self.registerEason(username, password: password)
//                    TTAlertNoTitle(error.errorDescription);
                    break;
                case EMErrorServerTimeout:
                TTAlertNoTitle("Connect to the server timed out!")
                    break;
                default:
                    
                    self.registerEason(username, password: password)
//                    TTAlertNoTitle("Login failure")
                    break;
                }
            }
        }
    }
    
    func registerEason(username:String,password:String){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let error = EMClient.sharedClient().registerWithUsername(username, password: password)
            if error == nil {
                self.loginEase(username, password: password)
            }else{
                self.hidder(msg: "Login failure")
//                switch (error.code)
//                {
//                case EMErrorNetworkUnavailable:
//                    TTAlertNoTitle("No network connection!");
//                    break;
//                case EMErrorServerNotReachable:
//                    TTAlertNoTitle("Connect to the server failed!");
//                    break;
//                case EMErrorUserAuthenticationFailed:
//                    TTAlertNoTitle(error.errorDescription);
//                    break;
//                case EMErrorServerTimeout:
//                    TTAlertNoTitle("Connect to the server timed out!")
//                    break;
//                default:
//                    self.registerEason(username, password: password)
//                    TTAlertNoTitle("Login failure")
//                    break;
//                }
            }
        }
    }
    
    func registerUser(user:UserModel) ->RACSignal {
        let url = "\(BaseUrl)\(RegisterAction)"
        let signal = RACSignal.createSignal { (subscriber) -> RACDisposable! in
            Alamofire.request(.POST, url, parameters: ["username":user.username,"password":user.password,"company":user.company], encoding: ParameterEncoding.URL, headers: nil).responseJSON(completionHandler: { (response) -> Void in
                if response.result.error == nil {
                    print(response.result.value)
                }else{
                    if self.hidder != nil {
                        self.hidder(msg:"注册成功")
                    }
                    
                    print(response.result.error)
                }
            })
            return nil
        }
        return signal
    }
    
    
    
}
