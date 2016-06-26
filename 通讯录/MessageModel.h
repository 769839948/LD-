//
//  MessageModel.h
//  好好修车技师版
//
//  Created by admin on 16/3/7.
//  Copyright © 2016年 观微科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Extras : NSObject

@property (nonatomic, assign) NSInteger nid;

@property (nonatomic, copy) NSString *time;

@end

@interface MessageModel : NSObject

@property (nonatomic, strong) Extras *extras;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *content_type;

@end
