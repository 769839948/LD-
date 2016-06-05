//
//  HistoryMessageViewController.swift
//  通讯录
//
//  Created by admin on 16/4/19.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit

class HistoryMessageViewController: UIViewController {

    var tableView:UITableView!
    var messageArray:NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "历史消息"
        if !NSUserDefaults.standardUserDefaults().boolForKey("readMgs"){
            messageArray = NSMutableArray()
        }else{
            messageArray = NSUserDefaults.standardUserDefaults().objectForKey("contents") as! NSMutableArray
        }
        
        self.setUpTableView()
        
        self.view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
    }
    
    
    func setUpTableView(){
        tableView = UITableView(frame: CGRectMake(0,0,UISCREEN_SIZE.width,UISCREEN_SIZE.height), style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
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

extension HistoryMessageViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}

extension HistoryMessageViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIndef = "HistoryCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIndef)
        if (cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: CellIndef)
        }
        cell?.textLabel?.text = messageArray.objectAtIndex(indexPath.row) as! String
        cell?.detailTextLabel?.text = "2016-4-23"
        return cell!
    }
}

