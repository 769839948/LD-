//
//  EdiltContactViewController.swift
//  通讯录
//
//  Created by admin on 16/4/7.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit

class EdiltContactViewController: UIViewController {

    var contact:Contacts!
    var tableView:UITableView!
    var viewModel:ContactViewModel!
    var nameArray:NSArray!
    var textFieldAtay:NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "编辑信息"
        self.view.backgroundColor = UIColor.whiteColor()
        self.setUpTableView()
        self.setBottomBt()
        // Do any additional setup after loading the view.
    }

    func setUpTableView(){
        tableView = UITableView(frame: CGRectMake(0,0,UISCREEN_SIZE.width,UISCREEN_SIZE.height - 40), style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    
        self.bindViewModel()
    }
    
    func setBottomBt(){
        let cofimBt = UIButton(type:UIButtonType.Custom)
        cofimBt.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cofimBt.backgroundColor = THEMECOLOR
        cofimBt.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (x) -> Void in
            self.performSelectorOnMainThread(Selector("showHudIN:"), withObject: "修改中", waitUntilDone: true)
            self.viewModel.changeContact(self.contact)
            let myTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("updataTable"), userInfo: nil, repeats: false)
        }
        
        cofimBt.setTitle("确定修改", forState: UIControlState.Normal)
        self.view.addSubview(cofimBt)
        cofimBt.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.bottom.equalTo(self.view.snp_bottom).offset(0)
            make.height.equalTo(40)
        }
    }
    
    func updataTable(){
        self.performSelectorOnMainThread(Selector("hideHud"), withObject: nil, waitUntilDone: true)
    }
    
    func showHudIN(string:String){
        self.showHudInView(self.view, hint: string)
    }
    
    func bindViewModel(){
        viewModel = ContactViewModel()
        nameArray = viewModel.editTableNameArray()
        textFieldAtay = viewModel.editTableTextArray()
        
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
    
    func setTextField(textField:UITextField, row:NSInteger){
        switch row{
        case 0:
            textField.text = contact.username
            break
        case 1:
            textField.text = contact.phone
            break
        case 2:
            textField.text = contact.home
            break
        case 3:
            textField.text = contact.department
            break
        case 4:
            textField.text = contact.position
            break
        case 5:
            textField.text = contact.email
            break
        case 6:
            textField.text = contact.qq
            break
        case 7:
            textField.text = contact.age
            break
        case 8:
            contact.company = NSUserDefaults.standardUserDefaults().objectForKey("compayName") as! String
            textField.text = contact.company
            break
        default:
            break
        }
    }
    
    func setContact(x:String,row:NSInteger){
        switch row{
        case 0:
            contact.username = x
            break
        case 1:
            contact.phone = x
            break
        case 2:
            contact.home = x
            break
        case 3:
            contact.department = x
            break
        case 4:
            contact.position = x
            break
        case 5:
            contact.email = x
            break
        case 6:
            contact.qq = x
            break
        case 7:
            contact.age = x
            break
        case 8:
            contact.company = x
            break
        default:
            break
        }
    }

}

extension EdiltContactViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

extension EdiltContactViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellString = "CellString"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellString)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellString)
        }
        let lableName = UILabel(frame: CGRectMake(10,5,80,40))
        lableName.text = nameArray[indexPath.row] as? String
        cell!.contentView.addSubview(lableName)
        
        let textField = UITextField(frame: CGRectMake(80,5,UISCREEN_SIZE.width - 100,40))
        textField.layer.borderColor = UIColor.darkGrayColor().CGColor
        if indexPath.row == 8 {
            textField.enabled = false
        }
        
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 0.5
        textField.placeholder = textFieldAtay[indexPath.row] as? String
        textField.tag = indexPath.row
        textField.delegate = self
        self.setTextField(textField,row: indexPath.row)
        textField.textColor = UIColor.blackColor()
        cell!.contentView.addSubview(textField)
        return cell!
    }
}


extension EdiltContactViewController : UITextFieldDelegate{
    func textFieldDidEndEditing(textField: UITextField) {
        switch textField.tag{
        case 0:
            contact.username = textField.text
            break
        case 1:
            contact.phone = textField.text
            break
        case 2:
            contact.home = textField.text
            break
        case 3:
            contact.department = textField.text
            break
        case 4:
            contact.position = textField.text
            break
        case 5:
            contact.email = textField.text
            break
        case 6:
            contact.qq = textField.text
            break
        case 7:
            contact.age = textField.text
            break
        case 8:
            contact.company = textField.text
            break
        default:
            break
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
}
