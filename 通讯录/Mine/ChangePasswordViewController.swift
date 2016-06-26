//
//  ChangePasswordViewController.swift
//  通讯录
//
//  Created by Zhang on 5/11/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ChangePasswordViewController: UIViewController {

    var oldpassword:UITextField!
    var newpassword:UITextField!
    var verifypassword:UITextField!
    var oldpasswordStr:String!
    var newpasswordStr:String!
    var coffirm:UIButton!
    var viewModel = MineViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.setUpView()
        self.setupForDismissKeyboard()
        // Do any additional setup after loading the view.
    }

    func setUpView(){
        oldpassword = UITextField()
        oldpassword.layer.borderColor = UIColor.darkGrayColor().CGColor
        oldpassword.layer.cornerRadius = 5
        oldpassword.rac_textSignal().subscribeNext { (string) -> Void in
            self.oldpasswordStr = string as! String
        }
        oldpassword.layer.borderWidth = 0.5
        oldpassword.keyboardType = UIKeyboardType.NamePhonePad
        oldpassword.textColor = UIColor.blackColor()
        oldpassword.placeholder = "请输入原密码"
        self.view.addSubview(oldpassword)
        
        newpassword = UITextField()
        newpassword.layer.cornerRadius = 5
        newpassword.secureTextEntry = true
        newpassword.layer.borderColor = UIColor.darkGrayColor().CGColor
        newpassword.rac_textSignal().subscribeNext { (string) -> Void in
            self.newpasswordStr = string as! String
        }
        
        newpassword.layer.borderWidth = 0.5
        newpassword.textColor = UIColor.blackColor()
        newpassword.placeholder = "请输入密码"
        self.view.addSubview(newpassword)
        
        verifypassword = UITextField()
        verifypassword.layer.cornerRadius = 5
        verifypassword.layer.borderColor = UIColor.darkGrayColor().CGColor
        verifypassword.secureTextEntry = true
        verifypassword.layer.borderWidth = 0.5
        verifypassword.textColor = UIColor.blackColor()
        verifypassword.placeholder = "确认密码"
        self.view.addSubview(verifypassword)
        
        coffirm = UIButton(type: UIButtonType.Custom)
        coffirm.layer.cornerRadius = 5
        coffirm.rac_signalForControlEvents(UIControlEvents.TouchUpInside).flattenMap { (AnyObject) -> RACStream! in
            self.performSelectorOnMainThread(#selector(ChangePasswordViewController.showHud(_:)), withObject: "修改中", waitUntilDone: true)
            return self.viewModel.changePassword(self.oldpasswordStr, newPassword: self.newpasswordStr)
        }.subscribeNext { (x) -> Void in
            let state = x as! String
            if state == "Success"{
                self.performSelectorOnMainThread(#selector(ChangePasswordViewController.hidderHUD), withObject: nil, waitUntilDone: true)
                self.navigationController?.popToRootViewControllerAnimated(true)
                TTAlertNoTitle("修改成功")
                print("修改成功")
            }else{
                self.performSelectorOnMainThread(#selector(ChangePasswordViewController.hidderHUD), withObject: nil, waitUntilDone: true)
                TTAlertNoTitle("修改失败")
                print("修改失败")
            }
        }
        coffirm.backgroundColor = THEMECOLOR
        coffirm.setTitle("登录", forState: UIControlState.Normal)
        self.view.addSubview(coffirm)
        
        self.makeConstraints()
        
        self.bindeViewModel()
    }
    
    func hidderHUD(){
        self.hideHud()
    }
    
    func showHud(hint:String){
        self.showHudInView(self.view, hint: hint)
    }
    
    func makeConstraints(){
        oldpassword.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_top).offset(74)
            make.left.equalTo(self.view.snp_left).offset(20)
            make.right.equalTo(self.view.snp_right).offset(-20)
            make.height.equalTo(40)
        }
        newpassword.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(oldpassword.snp_bottom).offset(20)
            make.left.equalTo(self.view.snp_left).offset(20)
            make.right.equalTo(self.view.snp_right).offset(-20)
            make.height.equalTo(40)
        }
        verifypassword.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(newpassword.snp_bottom).offset(20)
            make.left.equalTo(self.view.snp_left).offset(20)
            make.right.equalTo(self.view.snp_right).offset(-20)
            make.height.equalTo(40)
        }
        
        coffirm.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(verifypassword.snp_bottom).offset(20)
            make.left.equalTo(self.view.snp_left).offset(20)
            make.right.equalTo(self.view.snp_right).offset(-20)
            make.height.equalTo(40)
        }
    }
    
    func bindeViewModel(){
        viewModel.hidder = { (msg) -> Void in
            self.performSelectorOnMainThread(Selector("hideHud"), withObject: nil, waitUntilDone: true)
            TTAlertNoTitle(msg)
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
