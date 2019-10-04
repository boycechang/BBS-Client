//
//  BoardCell.h
//  BYR
//
//  Created by Boyce on 10/4/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Board;

@interface BoardCell : UICollectionViewCell

- (void)updateWithBoard:(Board *)board isMyFav:(BOOL)isMyFav;

@end

NS_ASSUME_NONNULL_END
