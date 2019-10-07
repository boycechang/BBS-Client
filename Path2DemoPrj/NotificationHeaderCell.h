//
//  NotificationHeaderCell.h
//  BYR
//
//  Created by Boyce on 10/4/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotificationHeaderCell : UITableViewCell

@property (nonatomic, copy) void (^loadMoreTapped)(void);

- (void)updateWithSectionName:(NSString *)secionName
                        total:(NSInteger)count
                       unread:(NSInteger)unread;

@end

@interface NotificationFooterCell : UITableViewCell
@end

NS_ASSUME_NONNULL_END
