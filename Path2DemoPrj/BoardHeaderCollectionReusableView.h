//
//  BoardHeaderCollectionReusableView.h
//  BYR
//
//  Created by Boyce on 10/4/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BoardHeaderCollectionReusableView : UICollectionReusableView

- (void)updateWithSectionName:(NSString *)secionName;

@end

NS_ASSUME_NONNULL_END
