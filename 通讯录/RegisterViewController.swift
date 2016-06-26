//
//  RegisterViewController.swift
//  通讯录
//
//  Created by Zhang on 5/7/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    var userName:UITextField!
    var userPassword:UITextField!
    var companyName:UITextField!
    var registerBt:UIButton!
    var viewModel = LoginViewModel()
    let model = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.setupForDismissKeyboard()
        self.title = "注册"
        self.setUpRegisterView()
        // Do any additional setup after loading the view.
    }

    func setUpRegisterView(){
        userName = UITextField()
        userName.layer.borderColor = UIColor.darkGrayColor().CGColor
        userName.layer.cornerRadius = 5
        userName.rac_textSignal().subscribeNext { (string) -> Void in
            self.model.username = string as! String
        }
        userName.layer.borderWidth = 0.5
        userName.keyboardType = UIKeyboardType.NamePhonePad
        userName.textColor = UIColor.blackColor()
        userName.placeholder = "请输入用户名"
        self.view.addSubview(userName)
        
        userPassword = UITextField()
        userPassword.layer.cornerRadius = 5
        userPassword.secureTextEntry = true
        userPassword.layer.borderColor = UIColor.darkGrayColor().CGColor
        userPassword.rac_textSignal().subscribeNext { (string) -> Void in
            self.model.password = string as! String
        }
        
        userPassword.layer.borderWidth = 0.5
        userPassword.textColor = UIColor.blackColor()
        userPassword.placeholder = "请输入密码"
        self.view.addSubview(userPassword)
        
        companyName = UITextField()
        companyName.layer.cornerRadius = 5
        companyName.layer.borderColor = UIColor.darkGrayColor().CGColor
        companyName.layer.borderWidth = 0.5
        companyName.textColor = UIColor.blackColor()
        companyName.placeholder = "请输入公司名称"
        self.view.addSubview(companyName)
        
        registerBt = UIButton(type: UIButtonType.Custom)
        registerBt.layer.cornerRadius = 5
        registerBt.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (x) -> Void in
            self.performSelectorOnMainThread(Selector("showHid:"), withObject: "注册中", waitUntilDone: true)
            self.viewModel.registerUser(self.model).subscribeNext({ (x) in
                
            })
        }
        registerBt.backgroundColor = THEMECOLOR
        registerBt.setTitle("注册", forState: UIControlState.Normal)
        self.view.addSubview(registerBt)
        
        self.makeConstraints()
        
        self.bindeViewModel()
    }
    
    func makeConstraints(){
        companyName.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_top).offset(74)
            make.left.equalTo(self.view.snp_left).offset(20)
            make.right.equalTo(self.view.snp_right).offset(-20)
            make.height.equalTo(40)
        }
        userName.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(companyName.snp_bottom).offset(20)
            make.left.equalTo(self.view.snp_left).offset(20)
            make.right.equalTo(self.view.snp_right).offset(-20)
            make.height.equalTo(40)
        }
        userPassword.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(userName.snp_bottom).offset(20)
            make.left.equalTo(self.view.snp_left).offset(20)
            make.right.equalTo(self.view.snp_right).offset(-20)
            make.height.equalTo(40)
        }
        
        registerBt.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(userPassword.snp_bottom).offset(20)
            make.left.equalTo(self.view.snp_left).offset(20)
            make.right.equalTo(self.view.snp_right).offset(-20)
            make.height.equalTo(40)
        }
    }
    
    func bindeViewModel(){
        viewModel = LoginViewModel()
        viewModel.hidder = { (msg) -> Void in
            self.performSelectorOnMainThread(#selector(UIViewController.hideHud), withObject: nil, waitUntilDone: true)
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
