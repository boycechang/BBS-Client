//
//  BYRTableViewController.m
//  BYR
//
//  Created by Boyce on 10/3/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "BYRTableViewController.h"
#import <Masonry.h>

@interface BYRTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isLoadingMore;

@end


@implementation BYRTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - triggle

- (void)refreshTriggled:(void (^)(void))completion {
    completion();
    // subclass override
}

- (void)loadMoreTriggled:(void (^)(void))completion {
    completion();
    // subclass override
}

#pragma mark - private

- (void)refresh {
    [self refreshTriggled:^{
        [self.tableView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.refreshControl endRefreshing];
        });
    }];
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.enableLoadMore ||
        self.isLoadingMore ||
        tableView.refreshControl.isRefreshing) {
        return;
    }
    
    if (indexPath.section == [tableView numberOfSections] - 1 &&
        indexPath.row >= [tableView numberOfRowsInSection:indexPath.section] - 4) {
    
        self.isLoadingMore = YES;
        [self loadMoreTriggled:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.isLoadingMore = NO;
                [self.tableView reloadData];
            });
        }];
    }
}

#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorNamed:@"Background"];
        _tableView.estimatedRowHeight = 70;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.refreshControl = [UIRefreshControl new];
        [_tableView.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    }
    return _tableView;
}

@end
