//
//
//  AboutViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//
\

#import <UIKit/UIKit.h>
#import "QuadCurveMenu.h"
#import "MyBBS.h"
#import "MPNotificationView.h"

@class LeftViewController;
@class HomeViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, MPNotificationViewDelegate> {
    
    MyBBS * myBBS;
    BOOL isSearching;
    
    UIImageView * zakerLikeImageView;
}

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UINavigationController *navController;
@property (strong, nonatomic) IBOutlet UINavigationController *leftnavController;
@property (strong, nonatomic) IBOutlet HomeViewController *homeViewController;
@property (strong, nonatomic) IBOutlet LeftViewController *leftViewController;
@property (strong, nonatomic) MyBBS * myBBS;
@property (nonatomic, assign)BOOL isSearching;

- (void)showLeftViewTotaly;
- (void)showLeftView;
-(void)refreshNotification;
-(void)refreshTableView;
@end
