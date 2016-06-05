//
//  MainTabBarController.m
//  通讯录
//
//  Created by Zhang on 5/11/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

#import "MainTabBarController.h"
//#import "SettingsViewController.h"
#import "ApplyViewController.h"
#import "ChatViewController.h"
#import "UserProfileManager.h"
#import "ConversationListController.h"
//#import "ContactListViewController.h"
#import "ChatDemoHelper.h"
#import "通讯录-Swift.h"
//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";
#if DEMO_CALL == 1
@interface MainTabBarController () <UIAlertViewDelegate, EMCallManagerDelegate>
#else
@interface MainTabBarController ()<UIAlertViewDelegate>
#endif
{
    ConversationListController *_chatListVC;
    ContactViewController *_contactsVC;
    MineViewController *_settingsVC;
    //    __weak CallViewController *_callController;
    
    UIBarButtonItem *_addFriendItem;
    
    NSInteger unApplyCount;
    NSInteger unreadMessageCount;
}

@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@end

@implementation MainTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //if 使tabBarController中管理的viewControllers都符合 UIRectEdgeNone
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = NSLocalizedString(@"title.conversation", @"Conversations");
    
    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
    //    [self didUnreadMessagesCountChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
    
    [self setupSubviews];
    self.selectedIndex = 0;
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [addButton setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [addButton addTarget:_contactsVC action:@selector(addFriendAction) forControlEvents:UIControlEventTouchUpInside];
    _addFriendItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    [self setupUnreadMessageCount];
    [self setupUntreatedApplyCount];
    
//    [ChatDemoHelper shareHelper]. = _contactsVC;
    [ChatDemoHelper shareHelper].conversationListVC = _chatListVC;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 0) {
//        self.title = @"通讯录";
//        self.navigationItem.rightBarButtonItem = nil;
    }else if (item.tag == 1){
        self.title = @"消息";
        self.navigationItem.rightBarButtonItem = _addFriendItem;
    }else if (item.tag == 2){
        self.title = @"我的";
        self.navigationItem.rightBarButtonItem = nil;
//        [_settingsVC refreshConfig];
    }
}

#pragma mark - private

- (void)setupSubviews
{
//    self.tabBar.backgroundImage = [[UIImage imageNamed:@"tabbarBackground"] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
//    self.tabBar.selectionIndicatorImage = [[UIImage imageNamed:@"tabbarSelectBg"] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
    
    _chatListVC = [[ConversationListController alloc] initWithNibName:nil bundle:nil];
    [_chatListVC networkChanged:_connectionState];
    _chatListVC.tabBarItem.image = [UIImage imageNamed:@"Message"];
//    = [[UITabBarItem alloc] initWithTitle:@"消息"
//                                                           image:[UIImage imageNamed:@"Message"]
//                                                             tag:0];
    _chatListVC.tabBarItem.title = @"消息";
//    [self unSelectedTapTabBarItems:_chatListVC.tabBarItem];
//    [self selectedTapTabBarItems:_chatListVC.tabBarItem];
    
    BaseNavigationController *chatListView = [[BaseNavigationController alloc] initWithRootViewController:_chatListVC];
    _contactsVC = [[ContactViewController alloc] init];
    _contactsVC.tabBarItem.image = [UIImage imageNamed:@"Contact"];
//    = [[UITabBarItem alloc] initWithTitle:@"联系人"
//                                                           image:[UIImage imageNamed:@"Contact"]
//                                                             tag:1];
    _contactsVC.tabBarItem.title = @"联系人";
//    [_contactsVC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_contactsHL"]
//                         withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_contacts"]];
//    [self unSelectedTapTabBarItems:_contactsVC.tabBarItem];
//    [self selectedTapTabBarItems:_contactsVC.tabBarItem];
    BaseNavigationController *contactsVC = [[BaseNavigationController alloc] initWithRootViewController:_contactsVC];
    _settingsVC = [[MineViewController alloc] init];
    _settingsVC.tabBarItem.image = [UIImage imageNamed:@"mine"];
//    = [[UITabBarItem alloc] initWithTitle: @"我的"
//                                                           image:[UIImage imageNamed:@"mine"]
//                                                             tag:2];
    _settingsVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _settingsVC.tabBarItem.title = @"我的";
//    [self unSelectedTapTabBarItems:_settingsVC.tabBarItem];
//    [self selectedTapTabBarItems:_settingsVC.tabBarItem];
    BaseNavigationController *mineVC = [[BaseNavigationController alloc] initWithRootViewController:_settingsVC];
    self.viewControllers = @[contactsVC, chatListView, mineVC];
//    [self selectedTapTabBarItems:_chatListVC.tabBarItem];
}

//-(void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem
//{
//    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                        [UIFont systemFontOfSize:14], UITextAttributeFont,[UIColor whiteColor],UITextAttributeTextColor,
//                                        nil] forState:UIControlStateNormal];
//}
//
//-(void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem
//{
//    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                        [UIFont systemFontOfSize:14],
//                                        UITextAttributeFont,[UIColor whiteColor],UITextAttributeTextColor,
//                                        nil] forState:UIControlStateSelected];
//}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    unreadMessageCount = unreadCount;
    if (_chatListVC) {
        if (unreadCount > 0) {
            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%li",(int)unreadCount + unApplyCount];
        }else{
            _chatListVC.tabBarItem.badgeValue = nil;
        }
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

- (void)setupUntreatedApplyCount
{
    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
    unApplyCount = unreadCount;
    if (_chatListVC) {
        if (unreadCount > 0) {
            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%li",(int)unreadCount + unreadMessageCount];
        }else{
            _chatListVC.tabBarItem.badgeValue = nil;
        }
    }
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [_chatListVC networkChanged:connectionState];
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        NSString *title = [[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
        if (message.chatType == EMChatTypeGroupChat) {
            NSArray *groupArray = [[EMClient sharedClient].groupManager getAllGroups];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationId]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.from, group.subject];
                    break;
                }
            }
        }
        else if (message.chatType == EMChatTypeChatRoom)
        {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[EMClient sharedClient] currentUsername]];
            NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
            NSString *chatroomName = [chatrooms objectForKey:message.conversationId];
            if (chatroomName)
            {
                title = [NSString stringWithFormat:@"%@(%@)", message.from, chatroomName];
            }
        }
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
    [userInfo setObject:message.conversationId forKey:kConversationChatter];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //    UIApplication *application = [UIApplication sharedApplication];
    //    application.applicationIconBadgeNumber += 1;
}

#pragma mark - 自动登录回调

- (void)willAutoReconnect{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        [self showHint:NSLocalizedString(@"reconnection.ongoing", @"reconnecting...")];
    }
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        if (error) {
            [self showHint:NSLocalizedString(@"reconnection.fail", @"reconnection failure, later will continue to reconnection")];
        }else{
            [self showHint:NSLocalizedString(@"reconnection.success", @"reconnection successful！")];
        }
    }
}

#pragma mark - public

- (void)jumpToChatList
{
    if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
        //        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
        //        [chatController hideImagePicker];
    }
    else if(_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
//        [self setSelectedViewController:_chatListVC];
    }
}

- (EMConversationType)conversationTypeFromMessageType:(EMChatType)type
{
    EMConversationType conversatinType = EMConversationTypeChat;
    switch (type) {
        case EMChatTypeChat:
            conversatinType = EMConversationTypeChat;
            break;
        case EMChatTypeGroupChat:
            conversatinType = EMConversationTypeGroupChat;
            break;
        case EMChatTypeChatRoom:
            conversatinType = EMConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
            //            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
            //            [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMChatType messageType = [userInfo[kMessageType] intValue];
                        chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                        switch (messageType) {
                            case EMChatTypeChat:
                            {
                                NSArray *groupArray = [[EMClient sharedClient].groupManager getAllGroups];
                                for (EMGroup *group in groupArray) {
                                    if ([group.groupId isEqualToString:conversationChatter]) {
                                        chatViewController.title = group.subject;
                                        break;
                                    }
                                }
                            }
                                break;
                            default:
                                chatViewController.title = conversationChatter;
                                break;
                        }
                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                ChatViewController *chatViewController = (ChatViewController *)obj;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMChatType messageType = [userInfo[kMessageType] intValue];
                chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                switch (messageType) {
                    case EMChatTypeGroupChat:
                    {
                        NSArray *groupArray = [[EMClient sharedClient].groupManager getAllGroups];
                        for (EMGroup *group in groupArray) {
                            if ([group.groupId isEqualToString:conversationChatter]) {
                                chatViewController.title = group.subject;
                                break;
                            }
                        }
                    }
                        break;
                    default:
                        chatViewController.title = conversationChatter;
                        break;
                }
                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
    }
}

@end