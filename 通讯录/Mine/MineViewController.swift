//
//  MineViewController.swift
//  通讯录
//
//  Created by admin on 16/4/19.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit

class MineViewController: UIViewController {

    var tableView:UITableView!
    var tableTitleArray:NSArray!
    var tableTitileImageArray:NSArray!
    var viewMode:MineViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的"
        self.setUpTableView()
        // Do any additional setup after loading the view.
    }

    func setUpTableView(){
        self.tableView = UITableView(frame: UISCREEN_SIZE, style: UITableViewStyle.Grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        
        self.bindViewModel()
    }
    
    func bindViewModel(){
        viewMode = MineViewModel()
        self.tableTitleArray = viewMode.tableTitleArray()
        self.tableTitileImageArray = viewMode.tableImageTitleArray()
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logOut(){
        self.showHudInView(self.view, hint:"退出");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let error = EMClient.sharedClient().logout(true)
            if error == nil{
                let loginController = LoginViewController();
                let navigationController = BaseNavigationController(rootViewController:loginController);
                self.presentViewController(navigationController, animated: true, completion: nil)
                NSNotificationCenter.defaultCenter().postNotificationName("removeAxisTage", object: nil)
                NSNotificationCenter.defaultCenter().postNotificationName(KNOTIFICATION_LOGINCHANGE, object: false)
                
                
            
            }
        }
    }
}

extension MineViewController:UITableViewDelegate{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.tableTitleArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableTitleArray[section].count
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
}

extension MineViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0{
            return 80;
        }else{
            return 50;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            
            let Identifier = "UserCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(Identifier)
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: Identifier)
            }
            let array = self.tableTitileImageArray[indexPath.section] as! NSArray
            cell?.imageView?.image = UIImage(named: array[indexPath.row] as! String)
            cell?.textLabel?.text = getContactsValue("username") as? String
            cell?.detailTextLabel?.text = getContactsValue("phone") as? String
            return cell!
        }else{
            let Identifier = "userDetali"
            var cell = tableView.dequeueReusableCellWithIdentifier(Identifier)
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: Identifier)
            }
            let imageArray = self.tableTitileImageArray[indexPath.section] as! NSArray
            cell?.imageView?.image = UIImage(named: imageArray[indexPath.row] as! String)
            let array = self.tableTitleArray[indexPath.section] as!NSArray
            cell?.textLabel?.text = array[indexPath.row] as? String
            return cell!
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1 {
            let changePassword = ChangePasswordViewController()
            self.navigationController?.pushViewController(changePassword, animated:true)
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let editView = EdiltContactViewController()
                editView.contact = getContacts()
                self.navigationController?.pushViewController(editView, animated: true)
            }else{
                CoreUmengShare.show(self, text: getContactsValue("phone") as? String, image: nil)
            }
        }else if indexPath.section == 3 {
            if indexPath.row == 0 {
                let historyMessage = HistoryMessageViewController()
                self.navigationController?.pushViewController(historyMessage, animated: true)
            }else{
                let aboutViewController = AboutViewController()
                self.navigationController?.pushViewController(aboutViewController, animated: true)
            }
        }else if indexPath.section == 4{
            self.logOut()
        }
    }
}
