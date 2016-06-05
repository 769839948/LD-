//
//  ContactViewController.swift
//  通讯录
//
//  Created by admin on 16/4/5.
//  Copyright © 2016年 Zhang. All rights reserved.
//
///去除排序功能。按Excle顺序显示


import UIKit
import SnapKit
import Contacts
import ContactsUI
import MJRefresh


class ContactViewController: UIViewController,UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    var contacts = [Contacts]()
    var contactSearch:UISearchController!
    
    var itemsString:[String]!
    var contactView:CNContactViewController!
    
    var contactArray:NSMutableArray!
    var orginArray:NSMutableArray!
    var searchArray:NSMutableArray!
    
    var viewModel:ContactViewModel!
    var tableView:UITableView!
    var groupView:ContactGroupViewController!
    var searchString = [String]()
    var adHeaders:[String] = []
    var segmentController:UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSearchBar()
//        self.setUpTableView()
//        self.setUpRefreshView()
        self.setUpNavigationItem()
        self.initSectionIndexAreaColors()
        self.view.backgroundColor = UIColor.clearColor()
        
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: #selector(ContactViewController.leftItemClick))
        self.setUpTableViewOne()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "排序", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ContactViewController.sortBtPress))
        
    }
    
    func  sortBtPress(){
        //显示右边A-Z
        self.performSelectorOnMainThread(#selector(ContactViewController.showHudInView(_:)), withObject: "排序中", waitUntilDone: true)
        
        let data = ContactDataHelp()
        self.adHeaders = data.tableViewSectionArray(self.contacts).copy() as! [String]
        self.contactArray = data.tableViewLetterSortArray(self.contacts)
        self.performSelectorOnMainThread(#selector(ContactViewController.updateTable), withObject: nil, waitUntilDone: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消排序", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ContactViewController.cancesortBtPress))
    }
    
    func cancesortBtPress(){
//        self.showHudInView(self.view, hint: "取消排序中")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "排序", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ContactViewController.sortBtPress))
        self.adHeaders = [""]
        self.contactArray.removeAllObjects()
        self.contactArray.addObject(self.orginArray)
        self.performSelectorOnMainThread(#selector(ContactViewController.updateTable), withObject: nil, waitUntilDone: true)
    }
    
    func leftItemClick(){
        if self.tableView.hidden {
            self.groupView.loadContactGroup()
        }else{
            self.loadContact()
        }
    }
    
    func setUpTableViewOne(){
        self.navigationItem.rightBarButtonItem?.enabled = true
        if self.tableView == nil {
            self.setUpTableView()
        }else{
            self.tableView.hidden = false
            if self.groupView != nil{
                self.groupView.view.hidden = true
                self.view.sendSubviewToBack(self.groupView.view)
            }
            self.view.bringSubviewToFront(self.tableView)
        }
    }
    
    func setUpTableViewTwo(){
        self.navigationItem.rightBarButtonItem?.enabled = false
        if self.groupView == nil {
            self.tableView.hidden = true
            self.view.sendSubviewToBack(self.tableView)
            self.groupView = ContactGroupViewController()
            self.view.addSubview(self.groupView.view)
            self.groupView.view.snp_makeConstraints(closure: { (make) -> Void in
                make.top.equalTo(self.view.snp_top).offset(64)
                make.left.equalTo(self.view.snp_left).offset(0)
                make.right.equalTo(self.view.snp_right).offset(0)
                make.bottom.equalTo(self.view.snp_bottom).offset(0)
            })
        }else{
            self.groupView.view.hidden = false
            self.tableView.hidden = true
            self.view.sendSubviewToBack(self.tableView)
            self.view.bringSubviewToFront(self.groupView.view)
        }
        self.groupView.myClosure = {(model) -> Void in
            self.pushViewController(model)
        }
        self.groupView.hiderClourse = { () -> Void in
            self.performSelectorOnMainThread(#selector(ContactViewController.hiderGroupHud), withObject: nil, waitUntilDone: true)
        }
    }
    
    func setUpRefreshView(){
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadContact()
        })
//        tableView.mj_header.automaticallyChangeAlpha = true
    }
    
    func hiderGroupHud(){
        self.hideHud()
    }
    
    func pushViewController(model:Contacts) {
        let controller = ContectDetailViewController()
        controller.contact = model
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func setUpSearchBar(){
        contactSearch = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchBar.frame = CGRectMake(0, 64, 0, 44)
            controller.searchBar.backgroundColor = UIColor.whiteColor()
            controller.hidesNavigationBarDuringPresentation = true
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.searchBarStyle = .Minimal
            controller.searchBar.delegate = self
            controller.delegate = self
            controller.searchResultsUpdater = self
            definesPresentationContext = true
            controller.searchBar.sizeToFit()
            return controller
        })()
        
//        self.view.addSubview(self.contactSearch.searchBar)
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
    
    func initSectionIndexAreaColors() {
        // 正常的BackgroundColor（没有被按下的时候）
        // 透明色
        self.tableView.sectionIndexBackgroundColor = UIColor.clearColor()
        // 被按下的时候的背景色
        self.tableView.sectionIndexTrackingBackgroundColor = UIColor.redColor()
        // 字体颜色
        self.tableView.sectionIndexColor = UIColor.blueColor()
    }
    
    func setUpTableView(){
        tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.tableHeaderView = self.contactSearch.searchBar
//        self.automaticallyAdjustsScrollViewInsets = false;
        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_top).offset(0)
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.bottom.equalTo(self.view.snp_bottom).offset(0)
        }
        self.bindeViewModel()
    }
    
    func bindeViewModel(){
        
        viewModel = ContactViewModel()
        self.loadContact()
        viewModel.hidder = { (msg) -> Void in
            self.performSelectorOnMainThread(#selector(UIViewController.hideHud), withObject: nil, waitUntilDone: true)
        }
    }
    
    func loadContact(){
        
        self.performSelectorOnMainThread(#selector(ContactViewController.showHudInView(_:)), withObject: "加载中", waitUntilDone: true)
        let compayName = NSUserDefaults.standardUserDefaults().objectForKey("compayName") as! String
        let userPhone = NSUserDefaults.standardUserDefaults().objectForKey("userPhone") as! String
        viewModel.loadContact(compayName).subscribeNext { (model) -> Void in
            self.contacts.removeAll()
            let phoneArray = NSMutableArray()
//            let coreDate = CoreDateMethod()
            let contactModel = model as! ContactModel
            for contact in contactModel.contacts{
                let model = contact as! Contacts
//                coreDate.insertDataBase(model)
                self.contacts.append(model)
                if model.phone == userPhone{
                    saveContacts(model)
                }
                uploadUserMessage(model)
                phoneArray.addObject(model.phone)
                NSUserDefaults.standardUserDefaults().setValue(model.username, forKey: model.phone!)
            }
//            let userContact = NSDictionary()
//            userContact.setValue(phoneArray, forKey: "contactPhones")
            NSUserDefaults.standardUserDefaults().setObject(phoneArray, forKey: "contactPhones")
            
            self.orginArray = NSMutableArray()
            self.searchArray = NSMutableArray()
            self.contactArray = NSMutableArray()
            self.orginArray.addObjectsFromArray(self.contacts)
            self.cancesortBtPress()
        }
    }
    
    func updateTable(){
        self.tableView.reloadData()
        self.hideHud()
//        self.tableView.mj_header.endRefreshing()
    }
    
    func showHudInView(hint: String!) {
        self.showHudInView(self.tableView, hint: hint);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        //        searchString.removeAll(keepCapacity: false)
        searchArray.removeAllObjects()
        let range = searchController.searchBar.text!.characters.startIndex ..< searchController.searchBar.text!.characters.endIndex
        var searchString = String()
        searchController.searchBar.text?.enumerateSubstringsInRange(range, options: .ByComposedCharacterSequences, { (substring, substringRange, enclosingRange, success) in
            searchString.appendContentsOf(substring!)
            searchString.appendContentsOf("*")
        })
        
        let searchPredicate = NSPredicate(format: "SELF.username LIKE[cd] %@", searchString)
        let array = (self.orginArray).filteredArrayUsingPredicate(searchPredicate)
        for model in array{
            searchArray.addObject(model)
        }
        self.tableView.reloadData()
    }

    
}

extension ContactViewController : UITableViewDelegate{
    
    //实现索引数据源代理方法
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return adHeaders;
    }
    
    //    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        if section == 0{
    //            return 50
    //        }else{
    //            return 0.001
    //        }
    //    }
    
    //点击索引，移动TableView的组位置
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String,
        atIndex index: Int) -> Int {
            var tpIndex:Int = 0
            //遍历索引值
            for character in adHeaders{
                //判断索引值和组名称相等，返回组坐标
                if character == title{
                    return tpIndex
                }
                tpIndex += 1
            }
            return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch contactSearch.active{
        case true:
            return 1
        case false:
            return adHeaders.count
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch contactSearch.active{
        case true:
            return searchArray.count
        case false:
            if section >= 22{
                return 10
            }else{
                return contactArray[section].count
            }
        }
    }
    
    
    
    //设置分组尾部高度（不需要尾部，设0.0好像无效）
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}

extension ContactViewController : UITableViewDataSource{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    // UITableViewDataSource协议中的方法，该方法的返回值决定指定分区的头部
    func tableView(tableView:UITableView, titleForHeaderInSection
        section:Int)->String?
    {
        switch contactSearch.active{
        case true:
            return "搜索中"
        case false:
            var headers =  self.adHeaders;
            return headers[section];
        }
        
    }
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0{
//            return self.contactSearch.searchBar
//        }else{
//            return nil
//        }
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "ContactCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: identifier)
        }
        var model:Contacts!
        if contactSearch.active{
            if self.searchArray.count > 0{
                model = self.searchArray[indexPath.row] as! Contacts
                cell?.imageView?.image = UIImage(named: "address_book")
                cell?.textLabel?.text = "\(model.username)+\(model.department)"
                cell?.detailTextLabel?.text = model.phone
            }
            return cell!
        }else{
            model = contactArray.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row) as! Contacts
            cell?.imageView?.image = UIImage(named:"address_book")
            cell?.textLabel?.text = "\(model.username)+\(model.department)"
            cell?.detailTextLabel?.text = model.phone
            return cell!
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var model = Contacts()
        if contactSearch.active{
            if self.searchArray.count > 0{
                model = searchArray[indexPath.row] as! Contacts
            }
        }else{
            model = contactArray.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row) as! Contacts
            
        }
        self.pushViewController(model)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
}


