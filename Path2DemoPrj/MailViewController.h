//
//  MailViewController.h
//  BYR
//
//  Created by Boyce on 10/6/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "BYRTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class Mail;

@interface MailViewController : BYRTableViewController

@property (nonatomic, strong) Mail *mail;

@end

NS_ASSUME_NONNULL_END
