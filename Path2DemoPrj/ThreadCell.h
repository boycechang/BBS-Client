//
//  ThreadCell.h
//  BYR
//
//  Created by Boyce on 10/5/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Topic, BYRBBCodeToYYConverter;

@interface ThreadCell : UITableViewCell

- (void)updateWithTopic:(Topic *)topic
              converter:(BYRBBCodeToYYConverter *)converter;

@end

NS_ASSUME_NONNULL_END
