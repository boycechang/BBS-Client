//
//  TopicCell.h
//  BYR
//
//  Created by Boyce on 10/3/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Topic, User;

@interface TopicCell : UITableViewCell

- (void)updateWithTopic:(Topic *)topic;
- (void)updateWithTopic:(Topic *)topic hideBoard:(BOOL)hideBoard;

@end

NS_ASSUME_NONNULL_END
