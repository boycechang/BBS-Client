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
@synthesize mySelf;
@synthesize notification;
@synthesize notificationCount;
@synthesize voteListNew;
@synthesize voteListHot;
@synthesize voteListAll;

+ (MyBBS *)sharedInstance {
    static MyBBS *_session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _session = [[self alloc] init];
    });
    return _session;
}

- (id)init {
    self = [super init];
    
    if (self) {
        notificationCount = 0;
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString *username = [defaults stringForKey:@"UserName"];
        NSString *userid = [defaults stringForKey:@"UserID"];
        NSString *usertoken = [defaults stringForKey:@"UserToken"];
        NSString *userAvatar = [defaults stringForKey:@"UserAvatar"];
        
        if (username != NULL) {
            self.mySelf = [[User alloc] init];
            mySelf.user_name = username;
            mySelf.id = userid;
            
            if (userAvatar != NULL) {
                mySelf.face_url = [NSURL URLWithString:userAvatar];
            }
        }
    }
    return self;
}

- (void)userLogout {
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
