//
//  AboutViewController.swift
//  通讯录
//
//  Created by admin on 16/4/19.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "关于我们"
        self.view.backgroundColor = UIColor.whiteColor()
        
        let lable = UILabel(frame: CGRectMake(0,0,UISCREEN_SIZE.width,50))
        lable.textAlignment = NSTextAlignment.Center
        lable.text = "移动终端实验室设计"
        lable.textColor = UIColor.blackColor()
        self.view.addSubview(lable)
        // Do any additional setup after loading the view.
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
