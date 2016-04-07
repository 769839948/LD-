//
//  ContactDataHelp.swift
//  通讯录
//
//  Created by admin on 16/4/6.
//  Copyright © 2016年 Zhang. All rights reserved.
//

import UIKit
import Contacts

class ContactDataHelp: NSObject {

    func tableViewSectionArray(contact:[ContectsModel]) -> NSMutableArray{
//        gicenName;
        let names = NSMutableArray()
        for index in contact{
            names.addObject(index.userName)
        }
        
        return ChineseString.IndexArray(names as [AnyObject])
    
    }
    
    func tableViewLetterSortArray(contact:[ContectsModel]) -> NSMutableArray{
        //        gicenName;
//        let names = NSMutableArray()
//        for index in contact{
//            names.addObject(index.givenName)
//        }
        return ChineseString.LetterSortArray(contact)
        
    }
}
