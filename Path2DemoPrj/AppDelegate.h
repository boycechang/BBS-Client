//
//
//  AppDelegate.h
//  佳邮
//
//  Created by 张晓波 on 10/30/13.
//  Copyright (c) 2013 BoyceChang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBBS.h"
#import "MPNotificationView.h"
#import "EAIntroView.h"
#import <AVOSCloud/AVOSCloud.h>
#import "IntroViewViewController.h"

NSUInteger DeviceSystemMajorVersion ();

@class LeftViewController;
@class PushNotificationWindow;

@interface AppDelegate : UIResponder <UIApplicationDelegate, MPNotificationViewDelegate, UIAlertViewDelegate, EAIntroDelegate, IntroViewViewControllerDelegate> {
    MyBBS * myBBS;
    BOOL isSearching;
    NSDictionary * selectedUserInfo;
    AVGeoPoint *geoPoint;
    IntroViewViewController *intro;
}

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UINavigationController *navController;
@property (strong, nonatomic) IBOutlet UINavigationController *leftnavController;
@property (strong, nonatomic) IBOutlet LeftViewController *leftViewController;
@property (strong, nonatomic) MyBBS * myBBS;
@property (nonatomic, assign)BOOL isSearching;
@property (strong, nonatomic) NSDictionary * selectedUserInfo;

- (void)refreshNotification;

@end

