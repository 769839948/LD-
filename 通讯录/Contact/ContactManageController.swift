//
//  ContactManageController.swift
//  通讯录
//
//  Created by admin on 16/4/22.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit

class ContactManageController: UIViewController,UISearchResultsUpdating,UISearchBarDelegate ,UISearchControllerDelegate{

    var segmentController:UISegmentedControl!
    var groupView:ContactGroupViewController!
    var contactView:ContactViewController!
    var selectSegementIndex:NSInteger!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavigationItem()
        self.navigationController?.navigationBar.translucent = true
        self.view.addSubview(ContactViewController().view)
        self.setUpTableViewOne()
        // Do any additional setup after loading the view.
    }

    
    func setUpNavigationItem(){
        segmentController = UISegmentedControl(items: ["通讯录","群组"])
        segmentController.selectedSegmentIndex = 0
        segmentController.rac_signalForControlEvents(UIControlEvents.ValueChanged).subscribeNext { (segmentIndex) -> Void in
            if segmentIndex.selectedSegmentIndex == 0{
                self.setUpTableViewOne()
            }else{
               self.setUpTableViewTwo()
            }
        }
        self.navigationItem.titleView = segmentController;
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: Selector("leftItemClick"))
    }
    
    func leftItemClick(){
        if selectSegementIndex == 1 {
//            self.contactView.loadContact()
        }else{
           self.groupView.loadContactGroup()
        }
    }
    
    func setUpTableViewOne(){
        selectSegementIndex = 1
        if self.contactView != nil{
            self.contactView.tableView.hidden = false
        }else{
            self.contactView = ContactViewController()
            self.contactView.view.frame = CGRectMake(0, 64, 380, 500)
            self.view.addSubview(self.contactView.view)
            self.contactView.view.snp_makeConstraints(closure: { (make) -> Void in
                make.top.equalTo(self.view.snp_top).offset(64)
                make.left.equalTo(self.view.snp_left).offset(0)
                make.right.equalTo(self.view.snp_right).offset(0)
                make.bottom.equalTo(self.view.snp_bottom).offset(0)
            })
        }
//        self.contactView.myClourse = {(model) -> Void in
//            self.pushViewController(model)
//        }
        if self.groupView != nil{
            self.groupView.view.hidden = true
        }
    }
    
    func setUpTableViewTwo(){
        selectSegementIndex = 2
        if self.groupView != nil{
            self.groupView.view.hidden = false
        }else{
            self.groupView = ContactGroupViewController()
            self.view.addSubview(self.groupView.view)
            self.groupView.view.snp_makeConstraints(closure: { (make) -> Void in
                make.top.equalTo(self.view.snp_top).offset(64)
                make.left.equalTo(self.view.snp_left).offset(0)
                make.right.equalTo(self.view.snp_right).offset(0)
                make.bottom.equalTo(self.view.snp_bottom).offset(0)
            })
        }
        if self.contactView != nil {
            self.contactView.tableView.hidden = true
        }
        self.groupView.myClosure = {(model) -> Void in
            self.pushViewController(model)
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("b");
        //2.3将状态栏变为白色
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
    }
    //搜索框开始编辑事件
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        //2.3将状态栏变为白色
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default;
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        //2.3将状态栏变为白色
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
        
    }
    
    func pushViewController(model:Contacts) {
        let controller = ContectDetailViewController()
        controller.contact = model
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        //        searchString.removeAll(keepCapacity: false)
//        searchArray.removeAllObjects()
//        let range = searchController.searchBar.text!.characters.startIndex ..< searchController.searchBar.text!.characters.endIndex
//        var searchString = String()
//        searchController.searchBar.text?.enumerateSubstringsInRange(range, options: .ByComposedCharacterSequences, { (substring, substringRange, enclosingRange, success) in
//            searchString.appendContentsOf(substring!)
//            searchString.appendContentsOf("*")
//        })
//        
//        let searchPredicate = NSPredicate(format: "SELF.userName LIKE[cd] %@", searchString)
//        let array = (self.orginArray).filteredArrayUsingPredicate(searchPredicate)
//        for model in array{
//            searchArray.addObject(model)
//        }
//        self.tableView.reloadData()
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
