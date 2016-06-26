//
//  NotificationView.h
//  好好修车技师版
//
//  Created by admin on 16/3/4.
//  Copyright © 2016年 观微科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SwipNotificationViewBlock)();
typedef void (^TapNotificationViewBlock)();

@interface NotificationView : UIView

@property (nonatomic, strong) TapNotificationViewBlock tapblcok;
@property (nonatomic, strong) SwipNotificationViewBlock swipblock;

- (void)configView:(NSString *)title time:(NSString *)time conten:(NSString *)conten;

@end
