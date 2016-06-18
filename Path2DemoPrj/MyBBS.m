//
//  MyBBS.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "MyBBS.h"

@implementation MyBBS
@synthesize allSections;
@synthesize hotTopics;
@synthesize hotBoards;
@synthesize photographyArray;
@synthesize picturesArray;
@synthesize newsArray;
@synthesize actionsArray;

@synthesize mapNewsArray;
@synthesize mapAVObjectArray;
@synthesize mapPointArray;

@synthesize myFavorites;
@synthesize myOnlineFriends;
@synthesize myAllFriends;
@synthesize myMails0;
@synthesize myMails1;
@synthesize myMails2;
@synthesize mySelf;
@synthesize notification;
@synthesize notificationCount;
@synthesize voteListNew;
@synthesize voteListHot;
@synthesize voteListAll;

- (id)init {
    self = [super init];
    
    if (self) {
        notificationCount = 0;
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString * username = [defaults stringForKey:@"UserName"];
        NSString * userid = [defaults stringForKey:@"UserID"];
        NSString * usertoken = [defaults stringForKey:@"UserToken"];
        NSString * userAvatar = [defaults stringForKey:@"UserAvatar"];
        
        if (username != NULL) {
            self.mySelf = [[User alloc] init];
            mySelf.name = username;
            mySelf.ID = userid;
            mySelf.username = userid;
            mySelf.password = usertoken;
            
            if (userAvatar != NULL) {
                mySelf.avatar = [NSURL URLWithString:userAvatar];
            }
        }
    }
    return self;
}

- (User *)userLogin:(NSString *)user Pass:(NSString *)pass {
    self.mySelf = [BBSAPI login:user Pass:pass];
    
    if (mySelf == nil) {
        return nil;
    } else {
        User *mySelfDetal = [BBSAPI userInfo:mySelf.ID];
        if (mySelfDetal) {
            self.mySelf.avatar = mySelfDetal.avatar;
        }
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        BOOL isGotDeviceToken = [defaults boolForKey:@"isGotDeviceToken"];
        if (isGotDeviceToken) {
            BOOL success = [BBSAPI addNotificationToken:mySelf.token iToken:[defaults objectForKey:@"DeviceToken"]];
            [defaults setBool:success forKey:@"isPostDeviceToken"];
            if (!success) {
                return nil;
            }
        }
        
        if (self.mySelf.avatar != nil) {
            [defaults setValue:[mySelf.avatar absoluteString] forKey:@"UserAvatar"];
        }
        [defaults setValue:mySelf.name forKey:@"UserName"];
        [defaults setValue:mySelf.ID forKey:@"UserID"];
        [defaults setValue:mySelf.password forKey:@"UserToken"];
        [defaults setValue:mySelf.username forKey:@"UserID"];
        return mySelf;
    }   
}

- (BOOL)addPushNotificationToken {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    BOOL success = [BBSAPI addNotificationToken:mySelf.token iToken:[defaults objectForKey:@"DeviceToken"]];
    [defaults setBool:success forKey:@"isPostDeviceToken"];
    return success;
}

- (void)userLogout {
    mySelf.name = nil;
    mySelf.ID = nil;
    mySelf.token = nil;
    mySelf.avatar = nil;
    mySelf.username = nil;
    mySelf.password = nil;
    mySelf = nil;
    notificationCount = 0;
    notification = nil;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:NULL forKey:@"UserName"];
    [defaults setValue:NULL forKey:@"UserID"];
    [defaults setValue:NULL forKey:@"UserToken"];
    [defaults setValue:NULL forKey:@"UserAvatar"];
}

- (void)refreshNotification {
    Notification *notifacation = [BBSAPI getAllNotificationCount:mySelf];
    self.notification = notifacation;
    if ((notification.atCount + notification.replyCount) > self.notificationCount) {
        AudioServicesPlayAlertSound (1009);
    }
    self.notificationCount = notification.atCount + notification.replyCount;
}

- (void)clearNotification {
    [BBSAPI clearNotification:mySelf];
}

@end
