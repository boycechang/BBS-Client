//
//
//  AppDelegate.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "VWWWaterView.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize leftnavController = _leftnavController;
@synthesize leftViewController;
@synthesize myBBS;
@synthesize isSearching;
@synthesize selectedUserInfo;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    self.myBBS = [[MyBBS alloc] init];
    [self.leftnavController.navigationBar setHidden:YES];
    
    self.window.backgroundColor = [UIColor clearColor];
    self.window.rootViewController = self.leftnavController;
    [self.window makeKeyAndVisible];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    BOOL isIntroShowed = [defaults boolForKey:@"isIntroShowed"];
    if (!isIntroShowed) {
        [defaults setBool:YES forKey:@"isIntroShowed"];
        [defaults setBool:YES forKey:@"isLoadAvatar"];
        [defaults setBool:YES forKey:@"ShowAttachments"];
    }
    
    [self showWave];
    return YES;
}

- (void)showWave {
    VWWWaterView *waterView = [[VWWWaterView alloc] initWithFrame:CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height + 200)];
    waterView.transform = CGAffineTransformIdentity;
    [self.window addSubview:waterView];
    [waterView stopWave];
    
    [UIView animateWithDuration:0.4 animations:^{
        [waterView setFrame:CGRectMake(0, 0, self.window.bounds.size.width, 94)];
    }];
}

- (void)refreshNotification {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.myBBS refreshNotification];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.leftViewController.accountInfoViewHeader refresh];
        });
    });
}

-(void)applicationDidBecomeActive:(UIApplication *)application {
    [self refreshNotification];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if (self.myBBS.notificationCount == 0) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:self.myBBS.notificationCount];
}

@end
