//
//  MailContentCell.h
//  BYR
//
//  Created by Boyce on 10/6/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Mail;

@interface MailContentCell : UITableViewCell

- (void)updateWithMail:(Mail *)mail;

@end

NS_ASSUME_NONNULL_END
