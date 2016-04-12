//
//  LoginViewController.swift
//  通讯录
//
//  Created by admin on 16/4/12.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var userName:YoshikoTextField!
    var userPassword:YoshikoTextField!
    var companyName:YoshikoTextField!
    var loginBt:UIButton!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.setUpLoginView()
        // Do any additional setup after loading the view.
    }
    
    func setUpLoginView(){
        userName = YoshikoTextField()
        userName.textColor = UIColor.blackColor()
        userName.placeholder = "请输入用户名"
        self.view.addSubview(userName)
        
        userPassword = YoshikoTextField()
        userPassword.textColor = UIColor.blackColor()
        userPassword.placeholder = "请输入密码"
        self.view.addSubview(userPassword)
        
        companyName = YoshikoTextField()
        companyName.textColor = UIColor.blackColor()
        companyName.placeholder = "请输入公司名称"
        self.view.addSubview(companyName)
        
        loginBt = UIButton(type: UIButtonType.Custom)
        loginBt.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (x) -> Void in
            
        }
        loginBt.setTitle("登录", forState: UIControlState.Normal)
        self.view.addSubview(loginBt)
        
        self.makeConstraints()
    }

    func makeConstraints(){
        userName.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_top).offset(74)
            make.left.equalTo(self.view.snp_left).offset(10)
            make.right.equalTo(self.view.snp_right).offset(10)
            make.height.equalTo(40)
        }
        userPassword.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(userName.snp_bottom).offset(20)
            make.left.equalTo(self.view.snp_left).offset(10)
            make.right.equalTo(self.view.snp_right).offset(10)
            make.height.equalTo(40)
        }
        companyName.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(userPassword.snp_bottom).offset(20)
            make.left.equalTo(self.view.snp_left).offset(10)
            make.right.equalTo(self.view.snp_right).offset(10)
            make.height.equalTo(40)
        }
        
        loginBt.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(companyName.snp_bottom).offset(20)
            make.left.equalTo(self.view.snp_left).offset(10)
            make.right.equalTo(self.view.snp_right).offset(10)
            make.height.equalTo(40)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
