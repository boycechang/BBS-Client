//
//  BYRCollectionViewController.h
//  BYR
//
//  Created by Boyce on 10/4/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BYRCollectionViewControllerProtocol <NSObject>

- (void)refreshTriggled:(void (^)(void))completion;
- (void)loadMoreTriggled:(void (^)(void))completion;

@end

@interface BYRCollectionViewController : UIViewController <BYRCollectionViewControllerProtocol>

@property (readonly) UICollectionViewFlowLayout *flowLayout;
@property (readonly) UICollectionView *collectionView;

- (void)refresh;

@end

NS_ASSUME_NONNULL_END
