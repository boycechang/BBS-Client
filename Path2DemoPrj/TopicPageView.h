//
//  TopicPageView.h
//  BYR
//
//  Created by Boyce on 10/17/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopicPageView : UIView

@property (nonatomic, copy) void (^pageSelected)(NSInteger page);

- (void)updateWithCurrent:(NSInteger)current total:(NSInteger)total;
- (void)fold;

@end

NS_ASSUME_NONNULL_END
