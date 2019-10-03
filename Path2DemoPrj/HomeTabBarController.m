//
//  HomeTabBarController.m
//  BYR
//
//  Created by Boyce on 10/3/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "HomeTabBarController.h"
#import "TopTenViewController.h"
#import "BoardsViewController.h"
#import "VoteListViewController.h"
#import "NotificationViewController.h"

@interface HomeTabBarController ()

@end

@implementation HomeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TopTenViewController *topTen = [TopTenViewController new];
    topTen.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage systemImageNamed:@"flame"] selectedImage:[UIImage systemImageNamed:@"flame.fill"]];
    UINavigationController *topTenNav = [[UINavigationController alloc] initWithRootViewController:topTen];
    
    BoardsViewController *boards = [BoardsViewController new];
    boards.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage systemImageNamed:@"square.grid.2x2"] selectedImage:[UIImage systemImageNamed:@"square.grid.2x2.fill"]];
    UINavigationController *boardsNav = [[UINavigationController alloc] initWithRootViewController:boards];
    
    VoteListViewController *vote = [VoteListViewController new];
    vote.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage systemImageNamed:@"chart.bar"] selectedImage:[UIImage systemImageNamed:@"chart.bar.fill"]];
    UINavigationController *voteNav = [[UINavigationController alloc] initWithRootViewController:vote];
    
    NotificationViewController *notification = [NotificationViewController new];
    notification.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage systemImageNamed:@"bell"] selectedImage:[UIImage systemImageNamed:@"bell.fill"]];
    UINavigationController *notificationNav = [[UINavigationController alloc] initWithRootViewController:notification];
    
    self.tabBar.tintColor = [UIColor colorNamed:@"MainTheme"];
    self.viewControllers = @[topTenNav, boardsNav, voteNav, notificationNav];
}

@end
