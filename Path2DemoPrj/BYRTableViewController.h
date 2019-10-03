//
//  BYRTableViewController.h
//  BYR
//
//  Created by Boyce on 10/3/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BYRTableViewControllerProtocol <NSObject>

- (void)refreshTriggled:(void (^)(void))completion;
- (void)loadMoreTriggled:(void (^)(void))completion;

@end


@interface BYRTableViewController : UIViewController <BYRTableViewControllerProtocol>

@property (readonly) UITableView *tableView;

- (void)refresh;

@end

NS_ASSUME_NONNULL_END
