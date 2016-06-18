//
//  FTPagingViewController.h
//  FTAPP
//
//  Created by Boyce on 7/8/15.
//  Copyright (c) 2015 XSpace. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, FTPagingViewSelectionType) {
    FTPagingViewSelectionTypeClick = 0,
    FTPagingViewSelectionTypeScroll,
};

@class FTPagingViewController;

@protocol FTPagingViewControllerProtocol <NSObject>

@optional
- (NSArray *)leftNavigationBarItemsInPagingViewController:(FTPagingViewController *)controller;
- (NSArray *)rightNavigationBarItemsInPagingViewController:(FTPagingViewController *)controller;
- (void)didSelectedByPagingViewController:(FTPagingViewController *)controller withSelectionType:(FTPagingViewSelectionType)type;

@end


@interface FTPagingViewController : UIViewController

@property (nonatomic, assign) CGFloat tabButtonFontSize; //头部tab按钮字体大小
@property (nonatomic, assign) CGFloat tabMargin; //头部tab左右两端和边缘的间隔

@property (nonatomic, strong) UIColor* tabButtonTitleColorForNormal;
@property (nonatomic, strong) UIColor* tabButtonTitleColorForSelected;

@property (nonatomic, assign) CGFloat selectedLineWidth; //下划线的宽

@property (nonatomic, readonly) UIViewController *selectedViewController;
@property (nonatomic, readonly) NSInteger selectedViewControllerIndex;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles;


/**
 * @param badges 是 NSString 数组
 */
- (void)setBadges:(NSArray *)badges;

/**
 * @return NSString 数组
 */
- (NSArray *)getBadges;

@end
