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
#import "MPNotificationView.h"

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

@property(nonatomic, strong)NSArray * hotTopics;
@property(nonatomic, strong)NSArray * hotBoards;
@property(nonatomic, strong)NSArray * photographyArray;
@property(nonatomic, strong)NSArray * picturesArray;
@property(nonatomic, strong)NSArray * newsArray;
@property(nonatomic, strong)NSArray * actionsArray;

@property(nonatomic, strong)NSArray * mapNewsArray;
@property(nonatomic, strong)NSArray * mapAVObjectArray;
@property(nonatomic, strong)NSArray * mapPointArray;

@property(nonatomic, strong)NSArray * myFavorites;
@property(nonatomic, strong)NSArray * myOnlineFriends;
@property(nonatomic, strong)NSArray * myAllFriends;
@property(nonatomic, strong)NSArray * myMails0;
@property(nonatomic, strong)NSArray * myMails1;
@property(nonatomic, strong)NSArray * myMails2;

@property(nonatomic, strong)NSArray * voteListNew;
@property(nonatomic, strong)NSArray * voteListHot;
@property(nonatomic, strong)NSArray * voteListAll;

@property(nonatomic, strong)User * mySelf;
@property(nonatomic, strong)Notification * notification;
@property(nonatomic, assign)int notificationCount;

-(User *)userLogin:(NSString *)user Pass:(NSString *)pass;
-(BOOL)addPushNotificationToken;
-(void)userLogout;
-(void)refreshNotification;
-(void)clearNotification;
@end
