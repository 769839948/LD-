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

typealias successRequestClosure = (response:AnyObject, data:AnyObject) -> Void
typealias errorRequestClosure = (string:AnyObject) -> Void
typealias netErrorRequestClosure = (string:AnyObject) -> Void

class BaseRequestViewModel: NSObject {
    
    
    var successClosure:successRequestClosure!
    var errorClosure:errorRequestClosure!
    var netErrorClosure:netErrorRequestClosure!
    
    func requestNetGet(parameter:NSDictionary, url:String, headrer:[String:String]?, requestSuccess:successRequestClosure, requestError:errorRequestClosure) {
        Alamofire.request(.GET, url, parameters: parameter as? [String : AnyObject], encoding: ParameterEncoding.JSON, headers: nil).response { (request, response, data, error) -> Void in
            if error != nil{
                requestError(string: error!)
            }else{
                requestSuccess(response: response!, data: data!)
            }
            
        }
    }
    
    func requestNetPost(parameter:NSDictionary, url:String, headrer:[String:String]?, requestSuccess:successRequestClosure, requestError:errorRequestClosure) {
        Alamofire.request(.POST, url, parameters: parameter as? [String : AnyObject], encoding: ParameterEncoding.JSON, headers: nil).response { (request, response, data, error) -> Void in
            if error != nil{
                requestError(string: error!)
            }else{
                requestSuccess(response: response!, data: data!)
            }
            
        }
    }
}
