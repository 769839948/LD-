//
//  NSObject+CurrentVC.h
//  通讯录
//
//  Created by admin on 16/4/12.
//  Copyright © 2016年 Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (CurrentVC)

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC;

@end
