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
    NSArray * allSections;
    User * mySelf;
    
    Notification * notification;
    int notificationCount;
}
@property(nonatomic, strong)NSArray * allSections;
@property(nonatomic, strong)User * mySelf;
@property(nonatomic, strong)Notification * notification;
@property(nonatomic, assign)int notificationCount;

-(void)refreshAllSections;
-(User *)userLogin:(NSString *)user Pass:(NSString *)pass;
-(void)userLogout;
-(void)refreshNotification;
-(void)clearNotification;
@end
