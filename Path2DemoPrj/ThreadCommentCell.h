//
//  ThreadCommentCell.h
//  BYR
//
//  Created by Boyce on 10/7/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Topic, BYRBBCodeToYYConverter;

@interface ThreadCommentCell : UITableViewCell

- (void)updateWithTopic:(Topic *)topic
               position:(NSInteger)position
              converter:(BYRBBCodeToYYConverter *)converter;

@end

NS_ASSUME_NONNULL_END
