//
//  ContactViewController.swift
//  通讯录
//
//  Created by admin on 16/4/5.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit
import SnapKit
import Contacts
import ContactsUI
import MJRefresh

class OldViewController: UIViewController,UISearchBarDelegate,UISearchDisplayDelegate {
    
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
    var searchBar:EMSearchBar!
//    var searchController:EMSearchDisplayController!
    
    var adHeaders:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSearchBar()
        self.setUpTableView()
        self.setUpRefreshView()
        self.initSectionIndexAreaColors()
        self.view.backgroundColor = UIColor.clearColor()
        
    }
    
    func setUpRefreshView(){
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadContact()
        })
        tableView.mj_header.automaticallyChangeAlpha = true
    }
    
    func setUpSearchBar(){
        if (searchBar == nil) {
            searchBar = EMSearchBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 44))
            searchBar.delegate = self;
            searchBar.placeholder = "search"
        }
        self.view.addSubview(searchBar)
        
        //MARK- 9.0
        //        contactSearch = ({
        //            let controller = UISearchController(searchResultsController: nil)
        //            controller.searchBar.frame = CGRectMake(0, 64, 0, 44)
        //            controller.searchBar.backgroundColor = UIColor.whiteColor()
        //            controller.hidesNavigationBarDuringPresentation = true
        //            controller.dimsBackgroundDuringPresentation = false
        //            controller.searchBar.searchBarStyle = .Minimal
        //            controller.searchBar.delegate = self
        //            controller.searchResultsUpdater = self
        //            controller.searchBar.sizeToFit()
        //            return controller
        //        })()
    }
    
    
//    func setUpSearchsearchController(){
//        if (searchController == nil) {
//            searchController = EMSearchDisplayController(searchBar: self.searchBar, contentsController: self)
//            searchController.delegate = self;
//            searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine;
//            searchController.searchResultsTableView.tableFooterView = UIView();
//            searchController.cellForRowAtIndexPathCompletion = {(tableView,indexPath) -> UITableViewCell in
//                let CellIdentifier = "ContactCell"
//                var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier)
//                if cell == nil{
//                    cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: CellIdentifier)
//                }
//                if self.searchArray.count > 0{
//                    let model = self.searchArray[indexPath.row] as! Contacts
//                    cell?.imageView?.image = UIImage(named:model.phone!)
//                    cell?.textLabel?.text = model.username
//                    cell?.detailTextLabel?.text = model.phone
//                }
//                return cell!
//                
//            }
//            
//            searchController.heightForRowAtIndexPathCompletion = {
//                (tableView, indexPath) -> CGFloat in
//                return 40
//            }
//            // Configure the cell...
//            
//            searchController.didSelectRowAtIndexPathCompletion = {
//                (tableView,indexPath) -> Void in
//                if self.searchArray.count > 0{
//                    let model = self.searchArray[indexPath.row] as! Contacts
//                    self.pushViewController(model)
//                }
//                
//            }
//        }
//    }
    
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchArray.removeAllObjects()
//        let range = searchController.searchBar.text!.characters.startIndex ..< searchController.searchBar.text!.characters.endIndex
//        var searchString = String()
//        searchController.searchBar.text?.enumerateSubstringsInRange(range, options: .ByComposedCharacterSequences, { (substring, substringRange, enclosingRange, success) in
//            searchString.appendContentsOf(substring!)
//            searchString.appendContentsOf("*")
//        })
        
        let searchPredicate = NSPredicate(format: "SELF.userName LIKE[cd] %@", searchString)
        let array = (self.orginArray).filteredArrayUsingPredicate(searchPredicate)
        for model in array{
            searchArray.addObject(model)
        }
        //        if (results) {
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                [weakSelf.searchController.resultsSource removeAllObjects];
        //                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
        //                [weakSelf.searchController.searchResultsTableView reloadData];
        //                });
        //        }
        //    }];
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar:UISearchBar){
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    //搜索框开始编辑事件
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        //2.3将状态栏变为白色
        //        searchBar.frame = CGRectMake(0, -64, 50, 100)
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
        self.tableView.sectionIndexTrackingBackgroundColor = UIColor.clearColor()
        // 字体颜色
        self.tableView.sectionIndexColor = UIColor.blueColor()
    }
    
    func setUpTableView(){
        tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
//        tableView.delegate = self
//        tableView.dataSource = self
        //        tableView.tableHeaderView = self.contactSearch.searchBar
        self.view.addSubview(tableView)
        
        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(searchBar.snp_bottom).offset(0)
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
            self.performSelectorOnMainThread(Selector("hideHud"), withObject: nil, waitUntilDone: true)
        }
    }
    
    func loadContact(){
        let compayName = NSUserDefaults.standardUserDefaults().objectForKey("compayName") as! String
        let userPhone = NSUserDefaults.standardUserDefaults().objectForKey("userPhone") as! String
        viewModel.loadContact(compayName).subscribeNext { (model) -> Void in
            self.performSelectorOnMainThread(Selector("showHudInView:"), withObject: "加载中", waitUntilDone: true)
            let contactModel = model as! ContactModel
            self.contacts.removeAll()
            for contact in contactModel.contacts{
                let model = contact as! Contacts
                self.contacts.append(model)
                if model.phone == userPhone{
                    saveContacts(model)
                }
            }
            self.orginArray = NSMutableArray()
            self.searchArray = NSMutableArray()
            self.orginArray.addObjectsFromArray(self.contacts)
            let data = ContactDataHelp()
            self.adHeaders = data.tableViewSectionArray(self.contacts).copy() as! [String]
            self.contactArray = data.tableViewLetterSortArray(self.contacts)
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    func showHudInView(hint: String!) {
        self.showHudInView(self.view, hint: hint);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    func updateSearchResultsForSearchController(searchController: UISearchController) {
    ////        searchString.removeAll(keepCapacity: false)
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
    //    }
    
    func pushViewController(model:Contacts) {
        let controller = ContectDetailViewController()
        controller.contact = model
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
/*
extension ContactViewController : UITableViewDelegate{
    
    //实现索引数据源代理方法
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return adHeaders;
    }
    
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
                tpIndex++
            }
            return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //        switch contactSearch.active{
        //        case true:
        //            return 1
        //        case false:
        return adHeaders.count
        //        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        switch contactSearch.active{
        //        case true:
        //            return searchArray.count
        //        case false:
        return contactArray[section].count
        //        }
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
        //        switch contactSearch.active{
        //        case true:
        //            return "搜索中"
        //        case false:
        var headers =  self.adHeaders;
        return headers[section];
        //        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "ContactCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: identifier)
        }
        var model:Contacts!
        //        if contactSearch.active{
        //            if self.searchArray.count > 0{
        //                model = self.searchArray[indexPath.row] as! Contacts
        //                cell?.imageView?.image = UIImage(named:model.phone)
        //                cell?.textLabel?.text = model.username
        //                cell?.detailTextLabel?.text = model.phone
        //            }
        //            return cell!
        //        }else{
        model = contactArray.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row) as! Contacts
        cell?.imageView?.image = UIImage(named:model.phone)
        cell?.textLabel?.text = model.username
        cell?.detailTextLabel?.text = model.phone
        return cell!
        //        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var model = Contacts()
        if contactSearch.active{
            if self.searchArray.count > 0{
                model = searchArray[indexPath.row] as! Contacts
            }
            self.pushViewController(model)
        }else{
            model = contactArray.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row) as! Contacts
            self.pushViewController(model)
        }
        
    }
}
*/
