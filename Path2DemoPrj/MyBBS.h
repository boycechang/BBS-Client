//
//  MyBBS.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "DataModel.h"
#import "BBSAPI.h"

@interface MyBBS : NSObject
{
    //磁盘缓存
    NSArray * allSections;
    
    //内存缓存
    NSArray * hotTopics;
    NSArray * hotBoards;
    NSArray * photographyArray;
    NSArray * picturesArray;
    NSArray * newsArray;
    NSArray * actionsArray;
    
    NSArray * mapNewsArray;
    NSArray * mapAVObjectArray;
    NSArray * mapPointArray;
    
    NSArray * myFavorites;
    NSArray * myOnlineFriends;
    NSArray * myAllFriends;
    NSArray * myMails0;
    NSArray * myMails1;
    NSArray * myMails2;
    
    NSArray * voteListNew;
    NSArray * voteListHot;
    NSArray * voteListAll;
    
    User * mySelf;
    Notification * notification;
    int notificationCount;
}
@property(nonatomic, strong)NSArray * allSections;
@property(nonatomic, strong)NSArray * voteListNew;
@property(nonatomic, strong)NSArray * voteListHot;
@property(nonatomic, strong)NSArray * voteListAll;

@property(nonatomic, strong) User * mySelf;
@property(nonatomic, strong) Notification * notification;
@property(nonatomic, assign) int notificationCount;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

+ (MyBBS *)sharedInstance;

-(BOOL)addPushNotificationToken;
-(void)userLogout;
-(void)refreshNotification;
-(void)clearNotification;

@end
