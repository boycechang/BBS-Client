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

@end


@implementation BYRTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

- (void)loadMore {
    
}

#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor colorNamed:@"Background"];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 70;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.refreshControl = [UIRefreshControl new];
        [_tableView.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    }
    return _tableView;
}

@end
