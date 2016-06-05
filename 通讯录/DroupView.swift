//
//  DroupView.swift
//  通讯录
//
//  Created by admin on 16/4/19.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit

typealias tableClourse = (companyName:String) -> Void

class DroupView: UIView {

    var tableView:UITableView!
    var titleArray:NSArray!
    var backGropView:UIView!
    var clourse:tableClourse!
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.tableView = UITableView(frame: frame)
    }

    func setUpDroupView(array:NSArray){
        titleArray = NSArray(array: array)
        self.backGropView = UIView(frame: CGRectMake(0 ,0,UISCREEN_SIZE.width,UISCREEN_SIZE.height))
        backGropView.backgroundColor = UIColor(red: 103.0/255.0, green: 103.0/255.0, blue: 122.0/255.0, alpha: 0.5)
        let tap = UITapGestureRecognizer(target: self, action: Selector("dismissView"))
        self.backGropView.addGestureRecognizer(tap)
        self.addSubview(self.backGropView)
        self.setUptableView(frame)
        
    }
    
    func dismissView(){
        self.disMissView()
    }
    
    func setUptableView(frame:CGRect){
        var tableHeight:CGFloat = 0.0
        if titleArray.count * 44 > 220{
            tableHeight = 220
        }else{
            tableHeight = (CGFloat)(titleArray.count * 44)
        }
        self.tableView = UITableView(frame: CGRectMake(frame.origin.x, 0, frame.size.width, tableHeight),style: UITableViewStyle.Plain)
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.addSubview(self.tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData(){
        self.tableView.reloadData()
    }
    
    func disMissView(){
//        self.tableView.removeFromSuperview()
//        self.backGropView.removeFromSuperview()
        self.removeFromSuperview()
    }

}

extension DroupView : UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if clourse != nil{
            clourse(companyName: titleArray.objectAtIndex(indexPath.row) as! String)
            self.disMissView()
        }
    }
}

extension DroupView :UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let companyCell = "companyCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(companyCell)
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: companyCell)
        }
        
        cell?.textLabel?.text = titleArray[indexPath.row] as? String
        return cell!
        
    }
}
