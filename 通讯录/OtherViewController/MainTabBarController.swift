//
//  MainTabBarController.swift
//  通讯录
//
//  Created by admin on 16/4/5.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViewControllers()
        // Do any additional setup after loading the view.
    }
    
    func setUpViewControllers(){
        let contact = ContactViewController()
        contact.tabBarItem.title = "联系人"
        contact.tabBarItem.image = UIImage(named: "Contact")
        let contactViewController = BaseNavigationController(rootViewController:contact)
        
        let message = MessageViewController()
        message.tabBarItem.image = UIImage(named: "Message")
        message.tabBarItem.title = "消息"
        let messageViewController = BaseNavigationController(rootViewController: message)
        
        self.viewControllers = [contactViewController,messageViewController]
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
