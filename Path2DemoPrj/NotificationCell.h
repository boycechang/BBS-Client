//
//  NotificationCell.h
//  BYR
//
//  Created by Boyce on 10/4/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Topic, Mail;

@interface NotificationCell : UITableViewCell

- (void)updateWithTopic:(Topic *)topic;
- (void)updateWithMail:(Mail *)mail;

- (void)showPlainStyle:(BOOL)plainStyle;

@end

NS_ASSUME_NONNULL_END
