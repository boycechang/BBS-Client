//
//  NotificationListViewController.h
//  BYR
//
//  Created by Boyce on 10/6/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "BYRTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, NotificationType) {
    NotificationTypeReply = 0,
    NotificationTypeAt = 1,
    NotificationTypeMail = 2,
};

@interface NotificationListViewController : BYRTableViewController

@property (nonatomic, assign) NotificationType type;

@end

NS_ASSUME_NONNULL_END
