//
//  MainTabBarController.swift
//  通讯录
//
//  Created by admin on 16/4/5.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit
import Foundation

let kConversationChatter = "ConversationChatter"

class MainTabBarController: UITabBarController {

    var message:MessageViewController!
    var contact:ContactViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViewControllers()
        // Do any additional setup after loading the view.
    }
    
    func setUpViewControllers(){
        contact = ContactViewController()
        contact.tabBarItem.title = "联系人"
        contact.tabBarItem.image = UIImage(named: "Contact")
        let contactViewController = BaseNavigationController(rootViewController:contact)
        
        message = MessageViewController()
        message.tabBarItem.image = UIImage(named: "Message")
        message.tabBarItem.title = "消息"
        let messageViewController = BaseNavigationController(rootViewController: message)
        
        self.viewControllers = [contactViewController,messageViewController]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func jumpToChatList(){
        if ((self.navigationController?.topViewController?.isKindOfClass(ContactViewController.self)) != nil){
            
        }else{
            self.navigationController?.popToViewController(self, animated: true);
            self.tabBarController?.selectedIndex = 0
        }

    }
    
    func didReceiveLocalNotification(notification: UILocalNotification){
        let userInfo = notification.userInfo
        if (userInfo != nil){
            if ((self.navigationController?.topViewController?.isKindOfClass(ContactViewController.self)) != nil){
                
            }
        }else{
            let viewControllers = self.navigationController!.viewControllers as NSArray;
            viewControllers.enumerateObjectsUsingBlock({ (obj, idx, stop) -> Void in
                if (obj as! MainTabBarController != self){
                    if (obj.isKindOfClass(ContactViewController.self)){
                        self.navigationController?.popViewControllerAnimated(false);
                    }else{
//                        let conversationChatter = userInfo![kConversationChatter];
//                        let chatViewController = obj as! MessageViewController;
                    }
                }
            })
        }
    }

}
