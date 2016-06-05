//
//  ChineseString.h
//  通讯录
//
//  Created by admin on 16/4/6.
//  Copyright © 2016年 Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import "pinyin.h"

@interface ChineseString : NSObject
@property(retain,nonatomic)NSString *string;
@property(retain,nonatomic)NSString *pinYin;

//-----  返回tableview右方indexArray
+(NSMutableArray*)IndexArray:(NSArray*)stringArr;
//-----  返回联系人
+(NSMutableArray*)LetterSortArray:(id)stringArr;

@end
