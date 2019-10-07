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
@property (nonatomic, strong) IBOutlet HomeViewController *homeVC;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UINavigationBar appearance].prefersLargeTitles = YES;
    [UINavigationBar appearance].tintColor = [UIColor systemBlueColor];
    return YES;
}

@end
