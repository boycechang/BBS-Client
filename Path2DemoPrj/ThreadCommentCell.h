//
//  ThreadCommentCell.h
//  BYR
//
//  Created by Boyce on 10/7/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Topic;

@interface ThreadCommentCell : UITableViewCell

- (void)updateWithTopic:(Topic *)topic position:(NSInteger)position;
- (void)refreshContent;

@end

NS_ASSUME_NONNULL_END
