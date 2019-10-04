//
//
//  AppDelegate.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "HomeTabBarController.h"

@interface AppDelegate ()
@property (nonatomic, strong) IBOutlet HomeTabBarController *homeVC;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize myBBS;
@synthesize selectedUserInfo;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UINavigationBar appearance].prefersLargeTitles = YES;
    [UINavigationBar appearance].barTintColor = [UIColor colorNamed:@"Background"];
    [UINavigationBar appearance].tintColor = [UIColor colorNamed:@"MainTheme"];
    
    self.myBBS = [[MyBBS alloc] init];
    return YES;
}

@end
