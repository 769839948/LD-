//
//  GroupModel.h
//  通讯录
//
//  Created by admin on 16/4/18.
//  Copyright © 2016年 Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Department,Groups,Contactsgroup,Contacts;

//@interface Contacts : NSObject
//
//@property (nonatomic, copy) NSString *phone;
//
//@property (nonatomic, copy) NSString *position;
//
//@property (nonatomic, copy) NSString *qq;
//
//@property (nonatomic, assign) NSInteger age;
//
//@property (nonatomic, copy) NSString *company;
//
//@property (nonatomic, copy) NSString *home;
//
//@property (nonatomic, copy) NSString *email;
//
//@property (nonatomic, copy) NSString *username;
//
//@property (nonatomic, copy) NSString *department;
//
//@end

@interface Department : NSObject

@property (nonatomic, strong) NSArray<Groups *> *groups;

@end

@interface Groups : NSObject

@property (nonatomic, strong) NSArray<Contacts *> *contactsGroup;

@property (nonatomic, copy) NSString *departmnet;

@end


@interface GroupModel : NSObject

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) Department *department;

@end
