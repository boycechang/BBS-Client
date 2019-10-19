//
//  BLTNUserItem.h
//  BYR
//
//  Created by Boyce on 10/19/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <BLTNBoard/BLTNBoard.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLTNUserItem : BLTNPageItem

@property (nonatomic, readonly) UIImageView *headImageView;
@property (nonatomic, readonly) UILabel *usernameLabel;
@property (nonatomic, readonly) UILabel *loginStatusLabel;

@end

NS_ASSUME_NONNULL_END
