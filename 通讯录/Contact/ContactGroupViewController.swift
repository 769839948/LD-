//
//  ContactGroupViewController.swift
//  通讯录
//
//  Created by admin on 16/4/18.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit
import RATreeView
import MJRefresh

typealias pushNavigation = (model:Contacts) -> Void
typealias hiderHudClourse = () -> Void
class ContactGroupViewController: UIViewController {
    
    var treeView = RATreeView()
    var hiderClourse:hiderHudClourse!
    var contactGroup:NSMutableArray!
    var contacts:NSMutableArray!
    var viewModel = ContactViewModel()
    var myClosure:pushNavigation!
    override func viewDidLoad() {
        super.viewDidLoad()
        contactGroup = NSMutableArray()
        self.setUpTreeView()
        self.setUpRefreshView()
        // Do any additional setup after loading the view.
    }

    func setUpTreeView(){
        treeView = RATreeView(frame: CGRectZero, style: RATreeViewStylePlain)
        treeView.delegate = self
        treeView.dataSource = self
        treeView.rowsExpandingAnimation = RATreeViewRowAnimationRight;
        treeView.rowsCollapsingAnimation = RATreeViewRowAnimationLeft;
        self.view.addSubview(treeView)
        treeView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_top).offset(0)
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.bottom.equalTo(self.view.snp_bottom).offset(0)
        }
        self.bindViewModel()
    }
    
    func setUpRefreshView(){
        self.treeView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadContactGroup()
        })
        self.treeView.scrollView.mj_header.automaticallyChangeAlpha = true
    }
    
    func bindViewModel(){
        viewModel = ContactViewModel()
        self.loadContactGroup()
    }
    
    func loadContactGroup(){
        self.performSelectorOnMainThread(#selector(ContactGroupViewController.showHid(_:)), withObject: "加载中", waitUntilDone: true)
        let compayName = NSUserDefaults.standardUserDefaults().objectForKey("compayName") as! String
        viewModel.contactGroup(compayName).subscribeNext { (model) -> Void in
            self.contactGroup = model as! NSMutableArray
            self.performSelectorOnMainThread(#selector(ContactGroupViewController.updateTableView), withObject: nil, waitUntilDone: true)
            
        }
        viewModel.hidder = { (msg)->Void in
            if self.hiderClourse != nil{
                self.hiderClourse()
                self.performSelectorOnMainThread(#selector(UIViewController.hideHud), withObject: nil, waitUntilDone: true)
                self.treeView.scrollView.mj_header.endRefreshing()
            }
        }
    }
    
    func updateTableView(){
        self.treeView.reloadData()
        if hiderClourse != nil{
            self.hiderClourse()
        }
        self.hideHud()
        self.treeView.scrollView.mj_header.endRefreshing()
    }
    
    func showHid(string:String){
        self.showHudInView(self.view, hint: string)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ContactGroupViewController : RATreeViewDelegate{
    func treeView(treeView: RATreeView, didSelectRowForItem item: AnyObject) {
        treeView.deselectRowForItem(item, animated: true)
        if (item.isKindOfClass(Contacts.classForCoder())){
            if (myClosure != nil){
                myClosure(model: item as! Contacts)
            }
        }else{
            
        }
    }
}

extension ContactGroupViewController : RATreeViewDataSource{
    func treeView(treeView: RATreeView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if item == nil{
            return self.contactGroup.count
        }else if(item!.isKindOfClass(Groups.classForCoder())){
            let group = item as! Groups
            return group.contactsGroup.count
        }else{
            return 0
        }
    }
    
    func treeView(treeView: RATreeView, indentationLevelForRowForItem item: AnyObject) -> Int {
        return 1
    }
    
    func treeView(treeView: RATreeView, cellForItem item: AnyObject?) -> UITableViewCell {
    
        if (item!.isKindOfClass(Groups.classForCoder())){
            let group = item as! Groups
            let identifier = "departmnet"
            var cell = treeView.dequeueReusableCellWithIdentifier(identifier)
            if cell == nil{
                cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: identifier)
            }
            
            cell?.textLabel!!.text = group.departmnet
            return cell as! UITableViewCell
        }else{
            let contact = item as! Contacts
            let identifier = "Contact"
            var cell = treeView.dequeueReusableCellWithIdentifier(identifier)
            if cell == nil{
                cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: identifier)
            }else{
                while(cell?.contentView.subviews.last != nil){
                    cell?.contentView.subviews.last?.removeFromSuperview()
                }
            }
            
            let imageView = UIImageView(frame: CGRectMake(25, 10, 30, 30))
            imageView.image = UIImage(named: "address_book")
            cell?.contentView.addSubview(imageView)
            
            let username = UILabel(frame: CGRectMake(70, 15, UISCREEN_SIZE.width - 90, 15))
            username.font = UIFont.boldSystemFontOfSize(15.0)
            username.text = contact.username
            cell?.contentView.addSubview(username)
            
            let phone = UILabel(frame: CGRectMake(70, 35, UISCREEN_SIZE.width - 90, 10))
            phone.text = contact.phone
            phone.font = UIFont.boldSystemFontOfSize(10.0)
            cell?.contentView.addSubview(phone)
            return cell! as! UITableViewCell
        }
        
    }
    
    func treeView(treeView: RATreeView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if item == nil {
            return self.contactGroup.objectAtIndex(index)
        }else{
            let data = item as! Groups;
            let items = Contacts.mj_objectArrayWithKeyValuesArray(data.contactsGroup)
            return items[index]
        }
    }
}
