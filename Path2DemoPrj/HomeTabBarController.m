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
    UINavigationController *topTenNav = [[UINavigationController alloc] initWithRootViewController:topTen];
    
    BoardsViewController *boards = [BoardsViewController new];
    boards.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage systemImageNamed:@"square.stack.3d.down.right"] selectedImage:[UIImage systemImageNamed:@"square.stack.3d.down.right.fill"]];
    UINavigationController *boardsNav = [[UINavigationController alloc] initWithRootViewController:boards];
    
    NotificationViewController *notification = [NotificationViewController new];
    notification.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage systemImageNamed:@"bell"] selectedImage:[UIImage systemImageNamed:@"bell.fill"]];
    UINavigationController *notificationNav = [[UINavigationController alloc] initWithRootViewController:notification];
    
    self.tabBar.tintColor = [UIColor colorNamed:@"MainTheme"];
    self.viewControllers = @[topTenNav, boardsNav, notificationNav];
}


#pragma mark - UITabBarControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    return [HomeTabBarControllerAnimatedTransitioning new];
}

@end
