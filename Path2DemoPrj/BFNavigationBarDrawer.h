//
//  BFNavigationBarDrawer.h
//  BFNavigationBarDrawer
//
//  Created by Balázs Faludi on 04.03.14.
//  Copyright (c) 2014 Balazs Faludi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFNavigationBarDrawer : UIView

@property (nonatomic, readonly, getter=isVisible) BOOL visible;
@property (nonatomic) UIView *customView;

@property (nonatomic, strong)IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong)IBOutlet UILabel *userOnline;
@property (nonatomic, strong)IBOutlet UILabel *postToday;
@property (nonatomic, strong)IBOutlet UILabel *postAll;

- (void)showFromNavigationBar:(UINavigationBar *)bar onView:(UIView *)view animated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated;

@end
