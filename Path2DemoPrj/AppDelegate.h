//
//
//  AppDelegate.h
//
//  Created by 张晓波 on 10/30/13.
//  Copyright (c) 2013 BoyceChang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBBS.h"

@class PushNotificationWindow;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate> {
    MyBBS * myBBS;
    BOOL isSearching;
    NSDictionary * selectedUserInfo;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) UINavigationController *leftnavController;
@property (strong, nonatomic) MyBBS * myBBS;
@property (strong, nonatomic) NSDictionary * selectedUserInfo;

@end

