//
//  EditTableViewCell.swift
//  通讯录
//
//  Created by Zhang on 16/4/23.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit

class EditTableViewCell: UITableViewCell {

    var lableName:UILabel!
    var textField:UITextField!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        lableName = UILabel(frame: CGRectMake(10,5,80,20))
        self.contentView.addSubview(lableName)
        
        textField = UITextField(frame: CGRectMake(90,5,UISCREEN_SIZE.width - 100,20))
        textField.layer.borderColor = UIColor.darkGrayColor().CGColor
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 0.5
        textField.textColor = UIColor.blackColor()
        self.contentView.addSubview(textField)
    }

    func configCell(name:String){
        lableName.text = name
        textField.placeholder = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
