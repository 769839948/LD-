//
//  LoginViewModel.swift
//  通讯录
//
//  Created by admin on 16/4/12.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit
import ReactiveCocoa

class LoginViewModel: BaseRequestViewModel {

    func loginEase(username:String, password:String){
        self.loginWithUsername(username,password:password)
    }
    
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
    
    
    func loginWithUsername(username:String, password:String){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let error = EMClient.sharedClient().loginWithUsername(username, password: password)
            self.getCurrentVC().hideHud()
            if error == nil {
                EMClient.sharedClient().options.isAutoLogin = true
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    EMClient.sharedClient().dataMigrationTo3()
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        ChatDemoHelper.shareHelper().asyncGroupFromServer()
                        ChatDemoHelper.shareHelper().asyncConversationFromDB()
                        ChatDemoHelper.shareHelper().asyncPushOptions()
                        NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGINCHANGE, object: true)
                    })
                }
            }else{
                switch (error.code)
                {
                    //                    case EMErrorNotFound:
                    //                        TTAlertNoTitle(error.errorDescription);
                    //                        break;
                case EMErrorNetworkUnavailable:
                         TTAlertNoTitle("No network connection!");
                    break;
                case EMErrorServerNotReachable:
                    TTAlertNoTitle("Connect to the server failed!");
                    break;
                case EMErrorUserAuthenticationFailed:
                    TTAlertNoTitle(error.errorDescription);
                    break;
                case EMErrorServerTimeout:
                TTAlertNoTitle("Connect to the server timed out!")
                    break;
                default:
                    TTAlertNoTitle("Login failure")
                    break;
                }
            }
        }
    }
}
