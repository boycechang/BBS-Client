//
//  TopicsViewController.m
//  BYR
//
//  Created by Boyce on 10/4/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "TopicsViewController.h"
#import <Masonry.h>
#import "TopicCell.h"
#import "TopicHeaderCell.h"
#import "BYRNetworkManager.h"
#import "TopicViewController.h"
#import "Models.h"
#import "BYRNetworkReponse.h"
#import "BYRNetworkManager.h"
#import "PostTopicViewController.h"

@interface TopicsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray <Topic *> *topics;
@property (nonatomic, strong) UIBarButtonItem *favButtonItem;
@property (nonatomic, strong) UIBarButtonItem *composeButtonItem;

@end

@implementation TopicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    self.title = self.board.board_description;
    
    self.enableLoadMore = YES;
    [self.tableView registerClass:TopicCell.class
           forCellReuseIdentifier:TopicCell.class.description];
    self.topics = [NSMutableArray new];
    
    self.favButtonItem = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(fav:)];
    [self updateFavButtonItem];
    self.composeButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"square.and.pencil"] style:UIBarButtonItemStylePlain target:self action:@selector(compose:)];
    self.navigationItem.rightBarButtonItems = @[self.composeButtonItem, self.favButtonItem];
    
    [self refresh];
}


#pragma mark - actions

- (void)updateFavButtonItem {
    [self.favButtonItem setImage:self.board.is_favorite ? [UIImage systemImageNamed:@"star.fill"] : [UIImage systemImageNamed:@"star"]];
}

- (IBAction)fav:(id)sender {
    NSString *baseurl;
    if (self.board.is_favorite) {
        baseurl = @"/favorite/delete/0.json";
    } else {
        baseurl = @"/favorite/add/0.json";
    }
    
    NSDictionary *params = @{@"name" : self.board.name,
                             @"dir" : @"0"};
    
    [[BYRNetworkManager sharedInstance] POST:baseurl parameters:params responseClass:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        self.board.is_favorite = !self.board.is_favorite;
        [self updateFavButtonItem];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (IBAction)compose:(id)sender {
    PostTopicViewController * postTopicViewController = [[PostTopicViewController alloc] init];
    postTopicViewController.postType = 0;
    postTopicViewController.boardName = self.board.name;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postTopicViewController];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    nav.navigationBar.prefersLargeTitles = NO;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.topics count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicCell *cell = (TopicCell *)[tableView dequeueReusableCellWithIdentifier:TopicCell.class.description];
    Topic *topic = [self.topics objectAtIndex:indexPath.row];
    [cell updateWithTopic:topic hideBoard:YES];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Topic *topic = [self.topics objectAtIndex:indexPath.row];
    TopicViewController *topicViewController = [TopicViewController new];
    topicViewController.topic = topic;
    [self.navigationController pushViewController:topicViewController animated:YES];
}

- (nullable UIContextMenuConfiguration *)tableView:(UITableView *)tableView contextMenuConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point {
    
    UIContextMenuConfiguration *config = [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:^UIViewController * _Nullable{
        Topic *topic = [self.topics objectAtIndex:indexPath.row];
        TopicViewController *topicViewController = [TopicViewController new];
        topicViewController.topic = topic;
        return topicViewController;
    } actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
//        if (self.type == NotificationTypeMail) {
//            Mail *mail = [self.notifications objectAtIndex:indexPath.row];
//            UIAction *action1 = [UIAction actionWithTitle:@"回复" image:[UIImage systemImageNamed:@"arrowshape.turn.up.left"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
//                PostMailViewController * postMailVC = [[PostMailViewController alloc] init];
//                postMailVC.postType = 1;
//                postMailVC.rootMail = mail;
//                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postMailVC];
//                [self presentViewController:nav animated:YES completion:nil];
//            }];
//            UIMenu *menu = [UIMenu menuWithTitle:nil children:@[action1]];
//            return menu;
//        }
        return nil;
    }];

    return config;
}

#pragma mark - BYRTableViewControllerProtocol

- (void)refreshTriggled:(void (^)(void))completion {
    NSDictionary *params = @{@"mode"  : @2,
                             @"page"  : @1,
                             @"count" : @20};
    
    [[BYRNetworkManager sharedInstance] GET:[NSString stringWithFormat:@"/board/%@.json", self.board.name] parameters:params responseClass:TopicResponse.class success:^(NSURLSessionDataTask * _Nonnull task, TopicResponse * _Nullable responseObject) {
        [self.topics removeAllObjects];
        [self.topics addObjectsFromArray:responseObject.topics];
        completion();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion();
    }];
}

- (void)loadMoreTriggled:(void (^)(void))completion {
    NSDictionary *params = @{@"mode"  : @2,
                             @"page"  : @(self.topics.count / 20 + 1),
                             @"count" : @20};
    
    [[BYRNetworkManager sharedInstance] GET:[NSString stringWithFormat:@"/board/%@.json", self.board.name] parameters:params responseClass:TopicResponse.class success:^(NSURLSessionDataTask * _Nonnull task, TopicResponse * _Nullable responseObject) {
        [self.topics addObjectsFromArray:responseObject.topics];
        completion();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion();
    }];
}

@end
