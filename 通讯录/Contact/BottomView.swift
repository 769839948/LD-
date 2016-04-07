//
//  BottomView.swift
//  通讯录
//
//  Created by admin on 16/4/7.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit

class BottomView: UIView {

    var messageBt:UIButton!
    var chatBt:UIButton!
    var email:UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpBottonView()
    }
    
    func setUpBottonView(){
        messageBt = self.createButton("message_", tag: 1, action: "buttonPress:")
        messageBt.backgroundColor = UIColor.grayColor()
        messageBt.setTitle("fsfs", forState: UIControlState.Normal)
        self.addSubview(messageBt)
        
        chatBt = self.createButton("Chat", tag: 2, action: "buttonPress:")
        chatBt.backgroundColor = UIColor.orangeColor()
        self.addSubview(chatBt)
        
        email = self.createButton("email", tag: 3, action: "buttonPress:")
        email.backgroundColor = UIColor.greenColor()
        self.addSubview(email)
        
        self.makeConstraints()
    }
    
    func makeConstraints() {
        chatBt.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp_top).offset(0)
            make.left.equalTo(self.snp_left).offset(0)
            make.right.equalTo(messageBt.snp_left).offset(0)
            make.bottom.equalTo(self.snp_bottom).offset(0)
            make.width.equalTo(messageBt.snp_width)
        }
        messageBt.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp_top).offset(0)
            make.left.equalTo(chatBt.snp_right).offset(0)
            make.right.equalTo(email.snp_left).offset(0)
            make.bottom.equalTo(self.snp_bottom).offset(0)
            make.width.equalTo(email.snp_width)
        }
        email.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp_top).offset(0)
            make.left.equalTo(messageBt.snp_right).offset(0)
            make.bottom.equalTo(self.snp_bottom).offset(0)
            make.right.equalTo(self.snp_right).offset(0)
            make.width.equalTo(chatBt.snp_width)
        }
    }
    
    func createButton(btImage:String, tag:NSInteger,action:String) -> UIButton{
        let button = UIButton(type: UIButtonType.Custom)
        button.imageView?.image = UIImage(named: btImage)
        button.addTarget(self, action: Selector(action), forControlEvents: UIControlEvents.TouchUpInside)
        button.tag = tag
        return button
    }
    
    func action(sender:UIButton){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
