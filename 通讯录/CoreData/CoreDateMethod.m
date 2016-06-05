//
//  CoreDateMethod.m
//  Kaoban
//
//  Created by Jane on 15/10/30.
//  Copyright © 2015年 kaoban. All rights reserved.
//

#import "CoreDateMethod.h"

@interface CoreDateMethod()
{
    
}
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation CoreDateMethod


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [NSManagedObjectContext new];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return _managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

/**
 Returns the URL to the application's documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // copy the default store (with a pre-populated data) into our Documents folder
    //
    NSString *documentsStorePath =
    [[[self applicationDocumentsDirectory] path] stringByAppendingPathComponent:@"Contact.sqlite"];
    
    // if the expected store doesn't exist, copy the default store
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsStorePath]) {
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Recipes" ofType:@"sqlite"];
        if (defaultStorePath) {
            [[NSFileManager defaultManager] copyItemAtPath:defaultStorePath toPath:documentsStorePath error:NULL];
        }
    }
    
    _persistentStoreCoordinator =
    [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    // add the default store to our coordinator
    NSError *error;
    NSURL *defaultStoreURL = [NSURL fileURLWithPath:documentsStorePath];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:defaultStoreURL
                                                         options:nil
                                                           error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible
         * The schema for the persistent store is incompatible with current managed object model
         Check the error message to determine what the actual problem was.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    // setup and add the user's store to our coordinator
    NSURL *userStoreURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"UserContact.sqlite"];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:userStoreURL
                                                         options:nil
                                                           error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible
         * The schema for the persistent store is incompatible with current managed object model
         Check the error message to determine what the actual problem was.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

/*
-(BOOL)insertDataBase:(Contacts *)model
{
    NSError *error=nil;
   NSManagedObjectContext *context = [self managedObjectContext];
    if([self dataFetchRequest] != nil){
        [self updateData:model with:[self dataFetchRequest]];
        return YES;
    }else{
        Contacts *contacts = [NSEntityDescription insertNewObjectForEntityForName:@"Contacts" inManagedObjectContext:context];
        contacts.username = model.username;
        contacts.phone = model.phone;
        contacts.home = model.home;
        contacts.department = model.department;
        contacts.position = model.position;
        contacts.qq = model.qq;
        contacts.email = model.email;
        contacts.company = model.company;
        contacts.age = model.age;
        if(![context save:&error])
        {
            NSLog(@"不能保存：%@",[error localizedDescription]);
            return YES;
        }else{
            return NO;
        }
    }
    //return YES;
}
/*
-(BOOL)insertDataBaseOtherInfo:(ProfileModel *)user
{
    NSError *error=nil;
    NSManagedObjectContext *context = [self managedObjectContext];
    if([self dataFetchRequestOtherInfo:user.userNum] != nil){
        [self updateDataOtherInfo:user];
        return YES;
    }else{
        OtherInfo *info = [NSEntityDescription insertNewObjectForEntityForName:@"OtherInfo" inManagedObjectContext:context];
        info.userNumber = user.userNum;
        info.userName = user.userName;
        info.headImage = [NSString stringWithFormat:@"%@%@",KAOBANIMGURL,user.headImage];
//        info.descr = info.descr;
//        info.islook = info.islook;
//        info = [self resultOtherInfo:user];
        if(![context save:&error])
        {
            return YES;
        }else{
            return NO;
        }
    }
    //return YES;
}

-(BOOL)insertDataBaseNotification:(Notification *)notification
{
    NSError *error=nil;
    NSManagedObjectContext *context = [self managedObjectContext];
    if([self dataFetchRequestNotifation:notification.uid] != nil){
        [self updateNotifation:notification];
        return YES;
    }else{
        Notification *info = [NSEntityDescription insertNewObjectForEntityForName:@"Notification" inManagedObjectContext:context];
        info.uid = @"1";
        info.disturbing = notification.disturbing;
        info.detailMessage = notification.detailMessage;
        
        if(![context save:&error])
        {
            return YES;
        }else{
            return NO;
        }
    }

}

-(Notification *)dataFetchRequestNotifation:(NSString *)uid
{
    
    Notification *notification = nil;
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"uid like[cd] %@",@"1"];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Notification" inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    //https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    for (Notification *info in result) {
        notification = info;
    }
    
    return notification;
}

-(void)updateNotifation:(Notification *)notification{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"uid like[cd] %@",@"1"];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Notification" inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    //https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    //UserInfo *userinfo;
    for (Notification *info in result) {
        info.disturbing = notification.disturbing;
        info.detailMessage = notification.detailMessage;
    }
    //保存
    if ([context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
}

//更新
- (void)updateDataOtherInfo:(ProfileModel *)model
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"userNumber like[cd] %@",model.userNum];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"OtherInfo" inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    //https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    //UserInfo *userinfo;
    for (OtherInfo *info in result) {
        info.userNumber = model.userNum;
        info.userName = model.userName;
        info.artical = model.artical;
        info.follow = model.follow;
        info.befollow = model.beFollow;
        info.birthday = model.bitthDay;
        info.headImage = model.headImage;
        info.sex = model.sex;
        info.province = model.province;
        info.habit = model.habit;
        info.sign = model.sign ;
        info.school = model.school;
        info.schooltime = model.schoolTime;
        //info.de = model.department;
        info.iffollow = model.ifFollow;
        info.headerImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KAOBANIMGURL,model.headImage]]];
    }
    //保存
    if ([context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
}


- (void)updateData:(Contacts *)model with:(Contacts *)model
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"phone like[cd] %@",model.phone];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    //https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    //UserInfo *userinfo;
    for (Contacts *info in result) {
        info.username = model.username;
        info.phone = model.phone;
        info.email = model.email;
        info.qq = model.qq;
        info.age = model.age;
        info.department = model.department;
        info.position = model.position;
        info.home = model.home;
        info.company = model.company;
    }
    //保存
    if ([context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
}
/*
- (void)updateHeadOtherImage:(NSString *)headerImage
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"userNumber like[cd] %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userNum"]];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"OtherInfo" inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    //https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    //UserInfo *userinfo;
    for (OtherInfo *info in result) {
        info.headImage = headerImage;
        info.headerImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KAOBANIMGURL,headerImage]]];
    }
    //保存
    if ([context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
}



- (void)updateHeadImage:(NSString *)headerImage
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"userNum like[cd] %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userNum"]];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    //https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    //UserInfo *userinfo;
    for (UserInfo *info in result) {
        info.headimage = headerImage;
        info.headImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KAOBANIMGURL,headerImage]]];
    }
    //保存
    if ([context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
}

- (OtherInfo *)dataFetchRequestOtherInfo:(NSString *)userNum
{
    OtherInfo *otherInfo =nil ;
    NSManagedObjectContext *context = [self managedObjectContext];
   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userNumber like[cd] %@",userNum];
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"OtherInfo" inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    //https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    for (OtherInfo *info in result) {
        otherInfo = info;
    }
    return otherInfo;
}

- (Contacts *)dataFetchRequest
{
    Contacts *userInfo;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (Contacts *info in fetchedObjects) {
       userInfo = info;
    }
    return userInfo;
}
/*
-(OtherInfo *)resultOtherInfo:(ProfileModel *)model
{
    OtherInfo *otherInfo = [[OtherInfo alloc] init];
    //otherInfo.userNumber = model.userNum;
    otherInfo.userName = model.userName;
//    otherInfo.artical = model.artical;
//    otherInfo.follow = model.follow;
//    otherInfo.befollow = model.beFollow;
//    otherInfo.birthday = model.bitthDay;
    otherInfo.headImage = model.headImage;
//    otherInfo.sex = model.sex;
//    otherInfo.province = model.province;
//    otherInfo.habit = model.habit;
//    otherInfo.sign = model.sign ;
//    otherInfo.school = model.school;
//    otherInfo.schooltime = model.schoolTime;
//    //otherInfo.department = model.department;
//    otherInfo.iffollow = model.ifFollow;
    otherInfo.headerImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KAOBANIMGURL,model.headImage]]];
    return otherInfo;
}

-(UserInfo *)result:(ProfileModel *)model
{
    UserInfo *userInfo = [[UserInfo alloc] init];
    userInfo.userNum = model.userNum;
    userInfo.userName = model.userName;
    userInfo.artical = model.artical;
    userInfo.follow = model.follow;
    userInfo.befollow = model.beFollow;
    userInfo.birthday = model.bitthDay;
    userInfo.headimage = model.headImage;
    userInfo.sex = model.sex;
    userInfo.province = model.province;
    userInfo.habit = model.habit;
    userInfo.sign = model.sign ;
    userInfo.school = model.school;
    userInfo.schoolTime = model.schoolTime;
    userInfo.department = model.department;
    userInfo.iffollow = model.ifFollow;
    userInfo.headImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KAOBANIMGURL,model.headImage]]];
    return userInfo;
}

-(ProfileModel *)model:(UserInfo *)userInfo
{
    ProfileModel *model = [[ProfileModel alloc] init];
    model.userNum = userInfo.userNum;
    model.userName = userInfo.userName;
    model.artical = userInfo.artical;
    model.follow = userInfo.follow;
    model.beFollow = userInfo.befollow;
    model.bitthDay = userInfo.birthday;
    model.headImage = userInfo.headimage;
    model.sex = userInfo.sex;
    model.province = userInfo.province;
    model.habit = userInfo.habit;
    model.sign = userInfo.sign;
    model.school = userInfo.school;
    model.schoolTime = userInfo.schoolTime;
    model.department = userInfo.department;
    model.ifFollow = userInfo.iffollow;
    model.headimage = userInfo.headImage;
    return model;
}

-(ProfileModel *)modelOtherInfo:(OtherInfo *)otherInfo
{
    ProfileModel *model = [[ProfileModel alloc] init];
    model.userNum = otherInfo.userNumber;
    model.userName = otherInfo.userName;
    model.artical = otherInfo.artical;
    model.follow = otherInfo.follow;
    model.beFollow = otherInfo.befollow;
    model.bitthDay = otherInfo.birthday;
    model.headImage = otherInfo.headImage;
    model.sex = otherInfo.sex;
    model.province = otherInfo.province;
    model.habit = otherInfo.habit;
    model.sign = otherInfo.sign;
    model.school = otherInfo.school;
    model.schoolTime = otherInfo.schooltime;
    //model.department = otherInfo.department;
    model.ifFollow = otherInfo.iffollow;
    model.headimage = otherInfo.headerImage;
    return model;
}
*/
@end
