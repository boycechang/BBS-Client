//
//  VoteOptionCell.h
//  BYR
//
//  Created by Boyce on 10/30/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Vote, VoteOption;

@interface VoteOptionCell : UITableViewCell


- (void)selectOption:(BOOL)select;

- (void)updateWithVote:(Vote *)vote option:(VoteOption *)option;

@end

NS_ASSUME_NONNULL_END
