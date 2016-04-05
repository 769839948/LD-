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

typealias successRequestClosure = (string:AnyObject) -> Void
typealias errorRequestClosure = (string:AnyObject) -> Void
typealias netErrorRequestClosure = (string:AnyObject) -> Void

class BaseRequestViewModel: NSObject {
    
    
    var successClosure:successRequestClosure!
    var errorClosure:errorRequestClosure!
    var netErrorClosure:netErrorRequestClosure!
    
    func requestNet(parameter:NSDictionary, url:String, headrer:[String:String]?){
        Alamofire.request(.GET, url, parameters: parameter as? [String : AnyObject], encoding: ParameterEncoding.JSON, headers: headrer).responseJSON { (response) -> Void in
//            if response.result.error == nil{
////                self.initWithClosure
//               self.initWithClosure(response.result.value)
//            }else{
////               errorRequestClosure(response.result.error)
//            }
        }
    }
    
    func initWithClosure(closure:successRequestClosure?){
        //将函数指针赋值给myClosure闭包，该闭包中涵盖了someFunctionThatTakesAClosure函数中的局部变量等的引用
        successClosure = closure
    }
    
    func disposable() -> RACDisposable{
        return RACDisposable()
    }
    
    func success(response:AnyObject){
        
    }
    
    func error(response:AnyObject){
        
    }
    
    func netError(response:AnyObject){
        
    }
}
