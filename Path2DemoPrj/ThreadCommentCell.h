//
//  ThreadCommentCell.h
//  BYR
//
//  Created by Boyce on 10/7/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Topic, User, BYRBBCodeToYYConverter;

@interface ThreadCommentCell : UITableViewCell

@property (nonatomic, readonly) Topic *topic;

@property (nonatomic, copy) void (^cellUserTapped)(Topic *topic);

- (void)updateWithTopic:(Topic *)topic
               position:(NSInteger)position
              converter:(BYRBBCodeToYYConverter *)converter;

- (void)showHighlightAnimation;

@end

NS_ASSUME_NONNULL_END
