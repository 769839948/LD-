//
//  NSObject+CurrentVC.m
//  通讯录
//
//  Created by admin on 16/4/12.
//  Copyright © 2016年 Zhang. All rights reserved.
//

#import "NSObject+CurrentVC.h"

@implementation NSObject (CurrentVC)

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else if([nextResponder isKindOfClass:[UINavigationController class]]){
        
//        result = nextResponder.r
    }else{
        result = window.rootViewController;
    }
    return result;
}

@end
