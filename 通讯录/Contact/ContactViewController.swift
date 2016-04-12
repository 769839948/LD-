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

class ContactViewController: UIViewController,UISearchResultsUpdating,UISearchBarDelegate {

    var contactStore = CNContactStore()
    var myContacts = [CNContact]()
    var Contacts = [ContectsModel]()
    
    var contactSearch:UISearchController!

    var itemsString:[String]!
    var contactView:CNContactViewController!
    
    var segmentController:UISegmentedControl!
    
    var contactArray:NSMutableArray!
    var orginArray:NSMutableArray!
    var searchArray:NSMutableArray!
    
    var viewModel:ContactViewModel!
    var tableView:UITableView!
    
    var searchString = [String]()
    var adHeaders:[String] = []
////    ["A", "B", "C", "D", "E", "F", "G",
//        "H", "I", "J", "K", "L", "M", "N",
//        "O", "P", "Q", "R", "S", "T",
//        "U", "V", "W", "X", "Y", "Z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        self.setUpContact()
        self.setUpSearchBar()
        self.setUpNavigationItem()
        self.setUpTableView()
        self.initSectionIndexAreaColors()
        
//        let data = ContactDataHelp()
//        adHeaders = data.tableViewSectionArray(self.Contacts).copy() as! [String]
//        contactArray = data.tableViewLetterSortArray(self.Contacts)
        // Do any additional setup after loading the view.
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
            controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            return controller
        })()
        
//        self.view.addSubview(searcher.searchBar)
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
//        searchBar.backgroundColor = UIColor.redColor()
//        searchBar.frame = CGRectMake(0, 64, 500, 500)
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
    
//    func setUpContact(){
//        requestForAccess { (accessGranted) -> Void in
//            if accessGranted {
//                // Fetch contacts from address book
//                let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey]
//                let containerId = CNContactStore().defaultContainerIdentifier()
//                let predicate: NSPredicate = CNContact.predicateForContactsInContainerWithIdentifier(containerId)
//                do {
//                    self.myContacts = try CNContactStore().unifiedContactsMatchingPredicate(predicate, keysToFetch: keysToFetch)
//                    
//                    for index in self.myContacts{
//                        let model = ContectsModel()
//                        model.userPhoto = "address_book"
//                        model.userGroup = ""
//                        model.userSchool = ""
//                        model.userHomeTown = ""
//                        model.contact = index
//                        self.Contacts.append(model)
//                    }
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        self.tableView.reloadData()
//                    })
//                } catch _ {
//                    print("Error retrieving contacts")
//                }
//            }
//        }
//    }
    
    func setUpNavigationItem(){
        segmentController = UISegmentedControl(items: ["通讯录","群组"])
        segmentController.selectedSegmentIndex = 0
        self.navigationItem.titleView = segmentController;
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("addContact"))
    }
    
    func addContact(){
        let controller = EdiltContactViewController()
        controller.contact = ContectsModel()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func setUpTableView(){
        tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = self.contactSearch.searchBar
        self.view.addSubview(tableView)
        
        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_top).offset(0)
//            make.top.equalTo(self.searcher.searchBar.snp_bottom).offset(0)
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.bottom.equalTo(self.view.snp_bottom).offset(0)
        }
        
        
        self.bindeViewModel()
    }
    
    func bindeViewModel(){
        viewModel = ContactViewModel()
        viewModel.testloadContact().subscribeNext { (array) -> Void in
            self.Contacts = array as! [ContectsModel]
            self.orginArray = NSMutableArray()
            self.searchArray = NSMutableArray()
            self.orginArray.addObjectsFromArray(self.Contacts)
            let data = ContactDataHelp()
            self.adHeaders = data.tableViewSectionArray(self.Contacts).copy() as! [String]
            self.contactArray = data.tableViewLetterSortArray(self.Contacts)
            self.tableView.reloadData()
        }
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
        
        let searchPredicate = NSPredicate(format: "SELF.userName LIKE[cd] %@", searchString)
        let array = (self.orginArray).filteredArrayUsingPredicate(searchPredicate)
        for model in array{
            searchArray.addObject(model)
        }
        self.tableView.reloadData()
//        print(array)
//        searchArray.addObjectsFromArray(array)
//        countryTable.reloadData()
        
    }
    
    // MARK: CNContactStore Authorization Methods
//    func requestForAccess(completionHandler: (accessGranted: Bool) -> Void) {
//        let authorizationStatus = CNContactStore.authorizationStatusForEntityType(.Contacts)
//        
//        switch authorizationStatus {
//        case .Authorized:
//            completionHandler(accessGranted: true)
//            
//        case .Denied, .NotDetermined:
//            self.contactStore.requestAccessForEntityType(.Contacts, completionHandler: { (access, accessError) -> Void in
//                if access {
//                    completionHandler(accessGranted: access)
//                }
//                else {
//                    if authorizationStatus == .Denied {
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
//                            self.showMessage(message)
//                        })
//                    }
//                }
//            })
//            
//        default:
//            completionHandler(accessGranted: false)
//        }
//    }
//    
//    func showMessage(message: String) {
//        let alert = UIAlertController(title: "MyContacts", message: message, preferredStyle: .Alert)
//        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
//        alert.addAction(okAction)
//        presentViewController(alert, animated: true, completion: nil)
//    }

}

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
            return contactArray[section].count
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "ContactCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: identifier)
        }
        var model:ContectsModel!
        if contactSearch.active{
            if self.searchArray.count > 0{
                model = self.searchArray[indexPath.row] as! ContectsModel
                cell?.imageView?.image = UIImage(named:model.userPhoto)
                cell?.textLabel?.text = model.userName
                cell?.detailTextLabel?.text = model.userPhone
            }
            return cell!
        }else{
            model = contactArray.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row) as! ContectsModel
            cell?.imageView?.image = UIImage(named:model.userPhoto)
            cell?.textLabel?.text = model.userName
            cell?.detailTextLabel?.text = model.userPhone
            return cell!
        }
        
//        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        
//        let contact = contactArray[indexPath.section][indexPath.row] as! ContectsModel
//        cell!.imageView?.image = UIImage(named: contact.userPhoto)
//        cell!.textLabel!.text = contact.contact.familyName + " " + contact.contact.givenName
//        
//        var emailString = ""
//        for emailAddress in contact.contact.emailAddresses {
//            emailString = emailString + (emailAddress.value as! String) + ", "
//        }
//        
//        // Remove the final ", " from the concatenated string
//        if emailString != "" {
//            let myRange = Range<String.Index>(start: emailString.endIndex.predecessor().predecessor(), end: emailString.endIndex.predecessor())
//            emailString.removeRange(myRange)
//        }
//        if let phoneNumber =  contact.contact.phoneNumbers.first?.value as? CNPhoneNumber{
//            cell!.detailTextLabel?.text = phoneNumber.stringValue
//        }
//        cell!.detailTextLabel?.text = emailString
//        cell!.detailTextLabel?.text = numberArray[0];
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var model = ContectsModel()
        if contactSearch.active{
            if self.searchArray.count > 0{
            model = searchArray[indexPath.row] as! ContectsModel
            }
        }else{
            model = contactArray.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row) as! ContectsModel
        }
        let controller = ContectDetailViewController()
        controller.contact = model
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

