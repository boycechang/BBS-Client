//
//  BLTNVoteItem.h
//  BYR
//
//  Created by Boyce on 10/29/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <BLTNBoard/BLTNBoard.h>

NS_ASSUME_NONNULL_BEGIN

@class Vote;

@interface BLTNVoteItem : BLTNPageItem

@property (nonatomic, readonly) UIImageView *headImageView;
@property (nonatomic, readonly) UILabel *usernameLabel;
@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, readonly) NSMutableSet <NSNumber *> *voted;

- (void)updateWithVote:(Vote *)vote;

@end

NS_ASSUME_NONNULL_END
