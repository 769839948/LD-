//
//  BaseRequstViewModel.swift
//  通讯录
//
//  Created by admin on 16/4/5.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit
import ReactiveCocoa
import MJExtension
import Alamofire
import ReactiveCocoa

typealias successRequestClosure = (response:AnyObject) -> Void
typealias errorRequestClosure = (error:AnyObject) -> Void
typealias netErrorRequestClosure = (error:AnyObject) -> Void
typealias hidderHid = (msg:String) -> Void

class BaseRequestViewModel: NSObject {
    
    
    var successClosure:successRequestClosure!
    var errorClosure:errorRequestClosure!
    var netErrorClosure:netErrorRequestClosure!
    var hidder:hidderHid!
    func requestNetGet(parameter:NSDictionary, url:String, headrer:[String:String]?, requestSuccess:successRequestClosure, requestError:errorRequestClosure) {
        Alamofire.request(.GET, url, parameters: parameter as? [String : AnyObject], encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response) -> Void in
            if response.result.error == nil{
                requestSuccess(response:response.result.value!)
            }else{
                requestError(error: response.result.error!)
            }
        }
    }
    
    func requestNetPost(parameter:NSDictionary, url:String, headrer:[String:String]?, requestSuccess:successRequestClosure, requestError:errorRequestClosure) {
        Alamofire.request(.POST, url, parameters: parameter as? [String : AnyObject], encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response) -> Void in
            if response.result.error == nil{
                requestSuccess(response:response.result.value!)
            }else{
                requestError(error: response.result.error!)
            }
        }
    }
}
