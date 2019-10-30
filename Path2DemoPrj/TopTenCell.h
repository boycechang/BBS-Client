//
//  TopTenCell.h
//  BYR
//
//  Created by Boyce on 10/28/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Topic;

@interface TopTenCell : UITableViewCell

- (void)updateWithTopic:(Topic *)topic index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
