//
//  ContectDetailViewController.swift
//  通讯录
//
//  Created by admin on 16/4/6.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit

class ContectDetailViewController: UIViewController {

    var tableView:UITableView!
    var bottomView:BottomView!
    var contact: ContectsModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.setUpTableView()
        self.setUpBottomView()
        self.setUpNavigationItem()
        // Do any additional setup after loading the view.
    }

    func setUpTableView(){
        tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    func setUpBottomView(){
        bottomView = BottomView()
        bottomView.myClosure = { (tag) -> Void in
            print(tag)
            self.pushViewController(tag)
        }
        self.view.addSubview(bottomView)
        
        self.makeConstraints()
    }
    
    func makeConstraints(){
        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_top).offset(0)
            make.bottom.equalTo(bottomView.snp_top).offset(0)
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
        }
        
        bottomView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(tableView.snp_bottom).offset(0)
            make.bottom.equalTo(self.view.snp_bottom).offset(0)
            make.left.equalTo(self.view.snp_left).offset(0)
            make.height.equalTo(50)
            make.right.equalTo(self.view.snp_right).offset(0)
        }
    }
    
    
    
    func setUpNavigationItem()
    {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", style: UIBarButtonItemStyle.Done, target: self, action: Selector("editButtonPress:"))
        let controller = EdiltContactViewController()
        controller.contact = contact
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func editButtonPress(sender:UIBarButtonItem){
        
    }
    
    
    func pushViewController(tag:NSInteger){
        if tag == 1{
           let conversation = EMClient.sharedClient().chatManager.getConversation(contact.userName, type: EMConversationTypeChat, createIfNotExist: true) as EMConversation
            let chatControler = ChatViewController(conversationChatter: conversation.conversationId, conversationType: conversation.type)
            chatControler.title = conversation.conversationId;
            self.navigationController?.pushViewController(chatControler, animated: true)
        }else if(tag == 2){
            
        }else{
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ContectDetailViewController : UITableViewDelegate{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
}

extension ContectDetailViewController : UITableViewDataSource{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 80;
        }else{
            return 50;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let Identifier = "ContactDetailCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(Identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: Identifier)
        }
        if indexPath.row == 0 {
            cell?.imageView?.image = UIImage(named: "user")
            cell?.textLabel?.text = contact.userName
        }else if indexPath.row == 1{
            cell?.textLabel?.text = contact.userPhone
        }else if indexPath.row == 2{
            cell?.textLabel?.text = contact.userEmail
        }else{
            cell?.textLabel?.text = "部门:" + contact.userGroup
        }
        return cell!
    }
}
