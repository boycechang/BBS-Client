//
//  TopicViewController.h
//  BYR
//
//  Created by Boyce on 10/5/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "BYRTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class Topic;

@interface TopicViewController : BYRTableViewController

@property (nonatomic, strong) Topic *topic;

@end

NS_ASSUME_NONNULL_END
