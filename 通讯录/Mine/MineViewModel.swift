//
//  MineViewModel.swift
//  通讯录
//
//  Created by admin on 16/4/19.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Alamofire

class MineViewModel: BaseRequestViewModel {
    func tableTitleArray() -> NSArray{
       return [[""],["修改密码"],["编辑信息","分享朋友"],["历史消息","关于我们"],["退出"]]
    }
    
    func tableImageTitleArray() -> NSArray{
        return [["Contact"],["key"],["edit","share"],["historyMessage","about"],["logout"]]
    }
    
    func changePassword(oldPassword:String, newPassword:String) -> RACSignal{
        let url = "\(BaseUrl)\(ChangePasswordAction)"
        let signal = RACSignal.createSignal { (subscriber) -> RACDisposable! in
            let parmars = ["username":getContactsValue("phone") as! String,"password":oldPassword,"company":getContactsValue("company") as! String,"newpassword":newPassword];
            Alamofire.request(.POST, url, parameters: parmars, encoding: ParameterEncoding.URL, headers: nil).responseJSON(completionHandler: { (response) -> Void in
                if response.result.error == nil {
                    print(response.result.value)
                    let dic = response.result.value as! NSDictionary
                    subscriber.sendNext(dic["state"])
                    subscriber.sendCompleted()
                    
                }else{
                    subscriber.sendNext("faile")
                    subscriber.sendCompleted()
//                    self.hidder(msg:"")
                    print(response.result.error)
                }
            })
            return nil
        }
        return signal
        
    }
}
