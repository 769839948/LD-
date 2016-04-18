//
//  ContactGroupViewController.swift
//  通讯录
//
//  Created by admin on 16/4/18.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit
import RATreeView

typealias pushNavigation = (model:Contacts) -> Void

class ContactGroupViewController: UIViewController {
    
    var treeView = RATreeView()
    var contactGroup:NSMutableArray!
    var contacts:NSMutableArray!
    var viewModel = ContactViewModel()
    var myClosure:pushNavigation!
    override func viewDidLoad() {
        super.viewDidLoad()
        contactGroup = NSMutableArray()
        self.setUpTreeView()
        // Do any additional setup after loading the view.
    }

    func setUpTreeView(){
        treeView = RATreeView(frame: CGRectZero, style: RATreeViewStylePlain)
        treeView.delegate = self
        treeView.dataSource = self
        treeView.rowsExpandingAnimation = RATreeViewRowAnimationRight;
        treeView.rowsCollapsingAnimation = RATreeViewRowAnimationLeft;
        let footerView = UIView(frame: CGRectMake(0,0,320,80))
        treeView.treeFooterView = footerView
        self.view.addSubview(treeView)
        treeView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_top).offset(0)
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.bottom.equalTo(self.view.snp_bottom).offset(0)
        }
        self.bindViewModel()
    }
    
    func bindViewModel(){
        viewModel = ContactViewModel()
        viewModel.contactGroup().subscribeNext { (model) -> Void in
            self.contactGroup = model as! NSMutableArray
            
            self.treeView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ContactGroupViewController : RATreeViewDelegate{
    func treeView(treeView: RATreeView, didSelectRowForItem item: AnyObject) {
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
            }
            cell?.imageView?!.image = UIImage(named:contact.phone)
            cell?.textLabel?!.text = contact.username
            cell?.detailTextLabel?!.text = contact.phone
            return cell as! UITableViewCell
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
