//
//  TopicsViewController.h
//  BYR
//
//  Created by Boyce on 10/4/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "BYRTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class Board;

@interface TopicsViewController : BYRTableViewController

@property (nonatomic, strong) Board *board;

@end

NS_ASSUME_NONNULL_END
