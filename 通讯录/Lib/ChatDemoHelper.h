/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import <Foundation/Foundation.h>
#import "ConversationListController.h"

#import "ChatViewController.h"
#import "MainTabBarController.h"

#if DEMO_CALL == 1

@interface ChatDemoHelper : NSObject <EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate,EMCallManagerDelegate>

#else

@interface ChatDemoHelper : NSObject <EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate>

#endif

//@property (nonatomic, weak) ContactListViewController *contactViewVC;

@property (nonatomic, weak) ConversationListController *conversationListVC;

@property (nonatomic, weak) MainTabBarController *mainVC;

@property (nonatomic, weak) ChatViewController *chatVC;

#if DEMO_CALL == 1

@property (strong, nonatomic) EMCallSession *callSession;
@property (strong, nonatomic) CallViewController *callController;

#endif

+ (instancetype)shareHelper;

- (void)asyncPushOptions;

- (void)asyncGroupFromServer;

- (void)asyncConversationFromDB;

#if DEMO_CALL == 1

- (void)makeCallWithUsername:(NSString *)aUsername
                     isVideo:(BOOL)aIsVideo;

- (void)hangupCallWithReason:(EMCallEndReason)aReason;

- (void)answerCall;

#endif

@end
