//
//  ThreadCell.h
//  BYR
//
//  Created by Boyce on 10/5/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Topic, User, BYRBBCodeToYYConverter;

@interface ThreadCell : UITableViewCell

@property (nonatomic, readonly) Topic *topic;

@property (nonatomic, copy) void (^cellUserTapped)(Topic *topic);

- (void)updateWithTopic:(Topic *)topic converter:(BYRBBCodeToYYConverter *)converter;

@end

NS_ASSUME_NONNULL_END
