//
//  BFNavigationBarDrawer.m
//  BFNavigationBarDrawer
//
//  Created by Balázs Faludi on 04.03.14.
//  Copyright (c) 2014 Balazs Faludi. All rights reserved.
//

#import "BFNavigationBarDrawer.h"
#import "CommonUI.h"

#define kAnimationDuration 0.3

@implementation BFNavigationBarDrawer {
	UINavigationBar *parentBar;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		//[self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self setFrame:CGRectMake(0, 0, rect.size.width, 70)];
}

- (void)setCustomView:(UIView *)view {
	if (_customView != view) {
		_customView = view;
	}
}

- (CGRect)finalFrameForNavigationBar:(UINavigationBar *)bar {
	CGRect rect = CGRectMake(bar.frame.origin.x,
							 bar.frame.origin.y + bar.frame.size.height,
							 bar.frame.size.width,
							 self.frame.size.height);
	return rect;
}

- (CGRect)initialFrameForNavigationBar:(UINavigationBar *)bar {
	CGRect rect = [self finalFrameForNavigationBar:bar];
	rect.origin.y -= rect.size.height;
	return rect;
}

- (void)showFromNavigationBar:(UINavigationBar *)bar onView:(UIView *)view animated:(BOOL)animated {
	parentBar = bar;
	if (!parentBar) {
		NSLog(@"Cannot display navigation bar from nil.");
		return;
	}
	[view addSubview:self];
	
	if (animated) {
		self.frame = [self initialFrameForNavigationBar:bar];
	}
	
	CGFloat height = self.frame.size.height;
    
	void (^animations)() = ^void() {
		self.frame = [self finalFrameForNavigationBar:bar];
		_customView.frame = CGRectMake(_customView.frame.origin.x, _customView.frame.origin.y + height, _customView.frame.size.width, _customView.frame.size.height);
	};
	
	void (^completion)(BOOL) = ^void(BOOL finished) {
		_visible = YES;
	};
	
	if (animated) {
		[UIView animateWithDuration:kAnimationDuration animations:animations completion:completion];
	} else {
		animations();
		completion(YES);
	}
	
}

- (void)hideAnimated:(BOOL)animated {
	if (!parentBar) {
		NSLog(@"Navigation bar should not be released while drawer is visible.");
		return;
	}
	
	void (^animations)() = ^void() {
		self.frame = [self initialFrameForNavigationBar:parentBar];
        CGFloat height = self.frame.size.height;
		_customView.frame = CGRectMake(_customView.frame.origin.x, _customView.frame.origin.y - height, _customView.frame.size.width, _customView.frame.size.height);
		
	};
	
	void (^completion)(BOOL) = ^void(BOOL finished) {
		_visible = NO;
		[self removeFromSuperview];
	};
	
	if (animated) {
		[UIView animateWithDuration:kAnimationDuration animations:animations completion:completion];
	} else {
		animations();
		completion(YES);
	}
}

@end
