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

#import "EaseConversationListViewController.h"
#import "EaseUI.h"
#import "EaseSDKHelper.h"
#import "EaseEmotionEscape.h"
#import "EaseConversationCell.h"
#import "EaseConvertToCommonEmoticonsHelper.h"
#import "NSDate+Category.h"
#import "GroupListViewController.h"
#import "ApplyViewController.h"

@interface EaseConversationListViewController ()
{
    dispatch_queue_t refreshQueue;
}
@property (nonatomic) NSInteger unapplyCount;

@end

@implementation EaseConversationListViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0){
        return 2;
    }else{
        return [self.dataArray count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"提醒群组";
    }else{
        return @"聊天信息";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSString *CellIdentifier = @"addFriend";
            EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.avatarView.image = [UIImage imageNamed:@"newFriends"];
            cell.titleLabel.text = @"应用消息提醒";
            cell.avatarView.badge = self.unapplyCount;
            return cell;
        }
        
        NSString *CellIdentifier = @"commonCell";
        EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if (indexPath.row == 1) {
            cell.avatarView.image = [UIImage imageNamed:@"EaseUIResource.bundle/group"];
            cell.titleLabel.text = @"群组";
        }
        return cell;
    }else{
        NSString *CellIdentifier = [EaseConversationCell cellIdentifierWithModel:nil];
        EaseConversationCell *cell = (EaseConversationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (cell == nil) {
            cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if ([self.dataArray count] <= indexPath.row) {
            return cell;
        }
        
        id<IConversationModel> model = [self.dataArray objectAtIndex:indexPath.row];
        cell.model = model;
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTitleForConversationModel:)]) {
            cell.detailLabel.attributedText =  [[EaseEmotionEscape sharedInstance] attStringFromTextForChatting:[_dataSource conversationListViewController:self latestMessageTitleForConversationModel:model] textFont:cell.detailLabel.font];
        } else {
            cell.detailLabel.attributedText =  [[EaseEmotionEscape sharedInstance] attStringFromTextForChatting:[self _latestMessageTitleForConversationModel:model]textFont:cell.detailLabel.font];
        }
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTimeForConversationModel:)]) {
            cell.timeLabel.text = [_dataSource conversationListViewController:self latestMessageTimeForConversationModel:model];
        } else {
            cell.timeLabel.text = [self _latestMessageTimeForConversationModel:model];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
        return cell;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [EaseConversationCell cellHeightWithModel:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[ApplyViewController shareController] animated:YES];
        }
        else if (indexPath.row == 1)
        {
            GroupListViewController *groupController = [[GroupListViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:groupController animated:YES];
        }
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(conversationListViewController:didSelectConversationModel:)]) {
            EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
            [_delegate conversationListViewController:self didSelectConversationModel:model];
        }
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [[EMClient sharedClient].chatManager deleteConversation:model.conversation.conversationId deleteMessages:YES];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - data

-(void)refreshAndSortView
{
    __weak typeof(self) weakself = self;
    if (!refreshQueue) {
        refreshQueue = dispatch_queue_create("com.easemob.conversation.refresh", DISPATCH_QUEUE_SERIAL);
    }
    dispatch_async(refreshQueue, ^{
        if ([weakself.dataArray count] > 1) {
            if ([[weakself.dataArray objectAtIndex:0] isKindOfClass:[EaseConversationModel class]]) {
                NSArray* sorted = [weakself.dataArray sortedArrayUsingComparator:
                                   ^(EaseConversationModel *obj1, EaseConversationModel* obj2){
                                       EMMessage *message1 = [obj1.conversation latestMessage];
                                       EMMessage *message2 = [obj2.conversation latestMessage];
                                       if(message1.timestamp > message2.timestamp) {
                                           return(NSComparisonResult)NSOrderedAscending;
                                       }else {
                                           return(NSComparisonResult)NSOrderedDescending;
                                       }
                                   }];
                [weakself.dataArray removeAllObjects];
                [weakself.dataArray addObjectsFromArray:sorted];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.tableView reloadData];
        });
    });
}

- (void)tableViewDidTriggerHeaderRefresh
{
    __weak typeof(self) weakself = self;
    if (!refreshQueue) {
        refreshQueue = dispatch_queue_create("com.easemob.conversation.refresh", DISPATCH_QUEUE_SERIAL);
    }
    dispatch_async(refreshQueue, ^{
        NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
        NSArray* sorted = [conversations sortedArrayUsingComparator:
                           ^(EMConversation *obj1, EMConversation* obj2){
                               EMMessage *message1 = [obj1 latestMessage];
                               EMMessage *message2 = [obj2 latestMessage];
                               if(message1.timestamp > message2.timestamp) {
                                   return(NSComparisonResult)NSOrderedAscending;
                               }else {
                                   return(NSComparisonResult)NSOrderedDescending;
                               }
                           }];
        
        
        
        [weakself.dataArray removeAllObjects];
        for (EMConversation *converstion in sorted) {
            EaseConversationModel *model = nil;
            if (weakself.dataSource && [weakself.dataSource respondsToSelector:@selector(conversationListViewController:modelForConversation:)]) {
                model = [weakself.dataSource conversationListViewController:weakself
                                               modelForConversation:converstion];
            }
            else{
                
//                EMConversation *conversation = [[EMConversation alloc] init];
//                converstion.conversationId = @"123456";
//                converstion
                
                model = [[EaseConversationModel alloc] initWithConversation:converstion];
            }
            
            if (model) {
                [weakself.dataArray addObject:model];
            }
        }
        
        [weakself tableViewDidFinishTriggerHeader:YES reload:YES];
    });
}

#pragma mark - EMGroupManagerDelegate

- (void)didUpdateGroupList:(NSArray *)groupList
{
    [self tableViewDidTriggerHeaderRefresh];
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
}

#pragma mark - private
- (NSString *)_latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTitle = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = NSEaseLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = NSEaseLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSEaseLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSEaseLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSEaseLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
    }
    return latestMessageTitle;
}

- (NSString *)_latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        double timeInterval = lastMessage.timestamp ;
        if(timeInterval > 140000000000) {
            timeInterval = timeInterval / 1000;
        }
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        latestMessageTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    }
    return latestMessageTime;
}

- (void)reloadApplyView
{
    NSInteger count = [[[ApplyViewController shareController] dataSource] count];
    self.unapplyCount = count;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUntreatedApplyCount" object:nil];
    [self.tableView reloadData];
}

@end
