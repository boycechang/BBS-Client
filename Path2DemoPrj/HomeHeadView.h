//
//  HomeHeadView.h
//  BYR
//
//  Created by Boyce on 10/5/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class User;

@interface HomeHeadView : UIView

@property (nonatomic, copy) void (^headTapped)(void);

- (void)updateWithUser:(User *)user;

@end

NS_ASSUME_NONNULL_END
