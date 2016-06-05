//
//  MainTabBarController.h
//  通讯录
//
//  Created by Zhang on 5/11/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMClient.h"

@interface MainTabBarController : UITabBarController
{
    EMConnectionState _connectionState;
}

- (void)jumpToChatList;

- (void)setupUntreatedApplyCount;

- (void)setupUnreadMessageCount;

- (void)networkChanged:(EMConnectionState)connectionState;

- (void)didReceiveLocalNotification:(UILocalNotification *)notification;

- (void)playSoundAndVibration;

- (void)showNotificationWithMessage:(EMMessage *)message;

@end
