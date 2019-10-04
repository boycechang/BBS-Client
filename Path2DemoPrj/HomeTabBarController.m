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
#import "BYRSession.h"
#import "HomeHeadView.h"
#import "AboutViewController.h"

@interface HomeTabBarControllerAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

@end


@implementation HomeTabBarControllerAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    [transitionContext.containerView addSubview:toViewController.view];

    toViewController.view.alpha = 0.0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toViewController.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.15;
}

@end


@interface HomeTabBarController () <UITabBarControllerDelegate>

@end

@implementation HomeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.delegate = self;
    
    TopTenViewController *topTen = [TopTenViewController new];
    topTen.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage systemImageNamed:@"flame"] selectedImage:[UIImage systemImageNamed:@"flame.fill"]];
    topTen.navigationItem.leftBarButtonItem = [self generateHeadItem];
    UINavigationController *topTenNav = [[UINavigationController alloc] initWithRootViewController:topTen];
    
    
    BoardsViewController *boards = [BoardsViewController new];
    boards.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage systemImageNamed:@"square.stack.3d.down.right"] selectedImage:[UIImage systemImageNamed:@"square.stack.3d.down.right.fill"]];
    boards.navigationItem.leftBarButtonItem = [self generateHeadItem];
    UINavigationController *boardsNav = [[UINavigationController alloc] initWithRootViewController:boards];
    
    NotificationViewController *notification = [NotificationViewController new];
    notification.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage systemImageNamed:@"bell"] selectedImage:[UIImage systemImageNamed:@"bell.fill"]];
    notification.navigationItem.leftBarButtonItem = [self generateHeadItem];
    UINavigationController *notificationNav = [[UINavigationController alloc] initWithRootViewController:notification];
    
    self.tabBar.tintColor = [UIColor colorNamed:@"MainTheme"];
    self.viewControllers = @[topTenNav, boardsNav, notificationNav];
}

- (UIBarButtonItem *)generateHeadItem {
    HomeHeadView *headView = [[HomeHeadView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [headView updateWithUser:[BYRSession sharedInstance].currentUser];
    headView.headTapped = ^{
        AboutViewController *aboutVC = [AboutViewController new];
        UINavigationController *aboutVCNav = [[UINavigationController alloc] initWithRootViewController:aboutVC];
        [self presentViewController:aboutVCNav animated:YES completion:nil];
    };
    UIBarButtonItem *headItem = [[UIBarButtonItem alloc] initWithCustomView:headView];
    return headItem;
}


#pragma mark - UITabBarControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    return [HomeTabBarControllerAnimatedTransitioning new];
}

@end
