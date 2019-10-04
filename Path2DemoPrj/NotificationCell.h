//
//  NotificationCell.h
//  BYR
//
//  Created by Boyce on 10/4/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Topic;

@interface NotificationCell : UITableViewCell

- (void)updateWithTopic:(Topic *)topic;

@end

NS_ASSUME_NONNULL_END
