//
//  LoginViewController.swift
//  通讯录
//
//  Created by admin on 16/4/12.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit
import ReactiveCocoa

class LoginViewController: UIViewController {

    var userName:UITextField!
    var userPassword:UITextField!
    var companyName:UITextField!
    var loginBt:UIButton!
    var viewModel:LoginViewModel!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupForDismissKeyboard()
        self.title = "登录"
        self.view.backgroundColor = UIColor.whiteColor()
        self.setUpLoginView()
        // Do any additional setup after loading the view.
    }
    
    func setUpLoginView(){
        userName = UITextField()
        userName.layer.borderColor = UIColor.darkGrayColor().CGColor
        userName.layer.borderWidth = 0.5
        userName.textColor = UIColor.blackColor()
        userName.placeholder = "请输入用户名"
        self.view.addSubview(userName)
        
        userPassword = UITextField()
        userPassword.layer.borderColor = UIColor.darkGrayColor().CGColor
        userPassword.layer.borderWidth = 0.5
        userPassword.textColor = UIColor.blackColor()
        userPassword.placeholder = "请输入密码"
        self.view.addSubview(userPassword)
        
        companyName = UITextField()
        companyName.layer.borderColor = UIColor.darkGrayColor().CGColor
        companyName.layer.borderWidth = 0.5
        companyName.textColor = UIColor.blackColor()
        companyName.placeholder = "请输入公司名称"
        self.view.addSubview(companyName)
        
        loginBt = UIButton(type: UIButtonType.Custom)
//        RAC(loginBt,"enable") ~> RACSignal.mapAs(userName.rac_textSignal())
        loginBt.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (x) -> Void in
            self.showHudInView(self.view, hint: "登录中")
            self.viewModel.loginWithUsername(self.userName.text!, password: self.userPassword.text!)
        }
        loginBt.backgroundColor = THEMECOLOR
        loginBt.setTitle("登录", forState: UIControlState.Normal)
        self.view.addSubview(loginBt)
        
        self.makeConstraints()
        
        self.bindeViewModel()
    }

    func makeConstraints(){
        userName.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_top).offset(74)
            make.left.equalTo(self.view.snp_left).offset(10)
            make.right.equalTo(self.view.snp_right).offset(-10)
            make.height.equalTo(40)
        }
        userPassword.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(userName.snp_bottom).offset(20)
            make.left.equalTo(self.view.snp_left).offset(10)
            make.right.equalTo(self.view.snp_right).offset(-10)
            make.height.equalTo(40)
        }
        companyName.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(userPassword.snp_bottom).offset(20)
            make.left.equalTo(self.view.snp_left).offset(10)
            make.right.equalTo(self.view.snp_right).offset(-10)
            make.height.equalTo(40)
        }
        
        loginBt.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(companyName.snp_bottom).offset(20)
            make.left.equalTo(self.view.snp_left).offset(10)
            make.right.equalTo(self.view.snp_right).offset(-10)
            make.height.equalTo(40)
        }
    }
    
    func bindeViewModel(){
        viewModel = LoginViewModel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
