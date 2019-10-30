//
//  VoteCell.h
//  BYR
//
//  Created by Boyce on 10/28/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Vote;

@interface VoteCell : UITableViewCell

- (void)updateWithVote:(Vote *)vote;

@end

NS_ASSUME_NONNULL_END
