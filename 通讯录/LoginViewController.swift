//
//  LoginViewController.swift
//  通讯录
//
//  Created by admin on 16/4/12.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit
import ReactiveCocoa

class LoginViewController: UIViewController,UITextFieldDelegate {

    var userName:UITextField!
    var userPassword:UITextField!
    var companyName:UITextField!
    var loginBt:UIButton!
    var array:NSMutableArray!
    var dropView:DroupView!
    let model = UserModel()
    var viewModel:LoginViewModel!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupForDismissKeyboard()
        self.title = "登录"
        self.view.backgroundColor = UIColor.whiteColor()
        self.setUpLoginView()
        self.setNavigationItem()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.performSelectorOnMainThread(Selector("hideHud"), withObject: nil, waitUntilDone: true)
    }
    
    func setNavigationItem(){
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(LoginViewController.register))
    }
    
    func register(){
        let gegister = RegisterViewController()
        self.navigationController?.pushViewController(gegister, animated: true)
    }
    
    func setUpLoginView(){
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
        companyName.delegate = self
        self.view.addSubview(companyName)
        
        loginBt = UIButton(type: UIButtonType.Custom)
        loginBt.layer.cornerRadius = 5
        loginBt.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (x) -> Void in
            self.performSelectorOnMainThread(Selector("showHid:"), withObject: "登录中", waitUntilDone: true)
            self.viewModel.loadContact(self.model)
        }
        loginBt.backgroundColor = THEMECOLOR
        loginBt.setTitle("登录", forState: UIControlState.Normal)
        self.view.addSubview(loginBt)
        
        self.makeConstraints()
        
        self.bindeViewModel()
    }

    func showHid(string:String){
        self.showHudInView(self.view, hint: string)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        if dropView == nil{
            //写你要实现的：页面跳转的相关代码
            dropView = DroupView(frame: CGRectMake(0,companyName.frame.origin.y + companyName.frame.size.height,UISCREEN_SIZE.width,UISCREEN_SIZE.height))
            dropView.clourse = { (company) -> Void in
                textField.text = company
                self.model.company = company
            }
            dropView.setUpDroupView(array)
            self.view.addSubview(dropView)
        }else{
            self.view.addSubview(dropView)
        }
        return false
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
        
        loginBt.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(userPassword.snp_bottom).offset(20)
            make.left.equalTo(self.view.snp_left).offset(20)
            make.right.equalTo(self.view.snp_right).offset(-20)
            make.height.equalTo(40)
        }
    }
    
    func bindeViewModel(){
        array = NSMutableArray()
        viewModel = LoginViewModel()
        viewModel.getCompany().subscribeNext { (arrays) -> Void in
            self.array = NSMutableArray(array: arrays as! NSArray)
        }
        viewModel.hidder = { (msg) -> Void in
            self.performSelectorOnMainThread(Selector("hideHud"), withObject: nil, waitUntilDone: true)
            TTAlertNoTitle(msg)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
