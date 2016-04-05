//
//  ContactViewController.swift
//  通讯录
//
//  Created by admin on 16/4/5.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    var segmentController:UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavigationItem()
        // Do any additional setup after loading the view.
    }
    
    func setUpNavigationItem(){
        segmentController = UISegmentedControl(items: ["通讯录","群组"])
        segmentController.selectedSegmentIndex = 0
        
        self.navigationItem.titleView = segmentController;
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
