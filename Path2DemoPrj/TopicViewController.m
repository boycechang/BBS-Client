//
//  TopicViewController.m
//  BYR
//
//  Created by Boyce on 10/5/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "TopicViewController.h"
#import "Models.h"
#import "ThreadCell.h"
#import "ThreadCommentCell.h"
#import "BYRNetworkReponse.h"
#import "BYRNetworkManager.h"
#import "BYRBBCodeToYYConverter.h"
#import <SafariServices/SafariServices.h>
#import <BlocksKit.h>
#import "KSPhotoBrowser.h"

@interface TopicViewController () <BYRBBCodeToYYConverterActionDelegate>

@property (nonatomic, strong) Pagination *pagination;
@property (nonatomic, strong) NSMutableArray <Topic *> *topics;

@end

@implementation TopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    
    [BYRBBCodeToYYConverter sharedInstance].actionDelegate = self;
    
    [self.tableView registerClass:ThreadCell.class
           forCellReuseIdentifier:ThreadCell.class.description];
    [self.tableView registerClass:ThreadCommentCell.class
           forCellReuseIdentifier:ThreadCommentCell.class.description];
    
    self.topics = [NSMutableArray new];
    
//    self.favButtonItem = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(fav:)];
//    [self updateFavButtonItem];
//    self.composeButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"square.and.pencil"] style:UIBarButtonItemStylePlain target:self action:@selector(compose:)];
//    self.navigationItem.rightBarButtonItems = @[self.composeButtonItem, self.favButtonItem];
    
    [self refresh];
}

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

- (void)setPagination:(Pagination *)pagination {
    _pagination = pagination;
    self.enableLoadMore = (_pagination.item_all_count != [self.topics count]);
}

#pragma mark - actions

//- (void)updateFavButtonItem {
//    [self.favButtonItem setImage:self.board.is_favorite ? [UIImage systemImageNamed:@"star.fill"] : [UIImage systemImageNamed:@"star"]];
//}

//- (IBAction)fav:(id)sender {
//    NSString *baseurl;
//    if (self.board.is_favorite) {
//        baseurl = @"/favorite/delete/0.json";
//    } else {
//        baseurl = @"/favorite/add/0.json";
//    }
//
//    NSDictionary *params = @{@"name" : self.board.name,
//                             @"dir" : @"0"};
//
//    [[BYRNetworkManager sharedInstance] POST:baseurl parameters:params responseClass:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
//        self.board.is_favorite = !self.board.is_favorite;
//        [self updateFavButtonItem];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
//}
//
//- (IBAction)compose:(id)sender {
//    PostTopicViewController * postTopicViewController = [[PostTopicViewController alloc] init];
//    postTopicViewController.postType = 0;
//    postTopicViewController.boardName = self.board.name;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postTopicViewController];
//    nav.modalPresentationStyle = UIModalPresentationFormSheet;
//    nav.navigationBar.prefersLargeTitles = NO;
//    [self presentViewController:nav animated:YES completion:nil];
//}

#pragma mark -
#pragma mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.topics count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ThreadCell *cell = (ThreadCell *)[tableView dequeueReusableCellWithIdentifier:ThreadCell.class.description];
        Topic *topic = [self.topics objectAtIndex:indexPath.row];
        cell.frame = self.view.frame;
        [cell updateWithTopic:topic];
        return cell;
    } else {
        ThreadCommentCell *cell = (ThreadCommentCell *)[tableView dequeueReusableCellWithIdentifier:ThreadCommentCell.class.description];
        Topic *topic = [self.topics objectAtIndex:indexPath.row];
        [cell updateWithTopic:topic position:indexPath.row];
        return cell;
    }
}

#pragma mark - BYRTableViewControllerProtocol

- (void)refreshTriggled:(void (^)(void))completion {
    NSDictionary *params = @{@"page"  : @1,
                             @"count" : @20};
    
    [[BYRNetworkManager sharedInstance] GET:[NSString stringWithFormat:@"/threads/%@/%@.json", self.topic.board_name, self.topic.id] parameters:params responseClass:TopicResponse.class success:^(NSURLSessionDataTask * _Nonnull task, TopicResponse * _Nullable responseObject) {
        [self.topics removeAllObjects];
        [self.topics addObjectsFromArray:responseObject.topics];
        Topic *firstTopic = self.topics.firstObject;
        firstTopic.reply_count = responseObject.reply_count;
        
        self.pagination = responseObject.pagination;
        completion();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion();
    }];
}

- (void)loadMoreTriggled:(void (^)(void))completion {
    NSDictionary *params = @{@"page"  : @(self.topics.count / 20 + 1),
                             @"count" : @20};
    
    [[BYRNetworkManager sharedInstance] GET:[NSString stringWithFormat:@"/threads/%@/%@.json", self.topic.board_name, self.topic.id] parameters:params responseClass:TopicResponse.class success:^(NSURLSessionDataTask * _Nonnull task, TopicResponse * _Nullable responseObject) {
        [self.topics addObjectsFromArray:responseObject.topics];
        self.pagination = responseObject.pagination;
        completion();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion();
    }];
}

#pragma mark - Trait Collection

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    for (Topic *topic in self.topics) {
        topic.attributedContentCache = nil;
    }
    
    [self.tableView reloadData];
}

#pragma mark - BYRBBCodeToYYConverterActionDelegate

- (void)BBCodeDidClickURL:(NSString *)url {
    SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
    safari.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:safari animated:YES completion:nil];
}

- (void)BBCodeDidClickAttachmentImage:(NSArray *)attachments index:(NSInteger)indx sourceView:(UIView *)view {
    Attachment *currentAtt = [attachments objectAtIndex:indx];
    NSArray *picArray = [attachments bk_select:^BOOL(Attachment *att) {
        return att.thumbnail_middle.length != 0;
    }];
    
    NSArray <KSPhotoItem *>* items = [picArray bk_map:^id(Attachment *att) {
        if (currentAtt == att) {
            return [[KSPhotoItem alloc] initWithSourceView:view imageUrl:[NSURL URLWithString:att.url]];
        }
        return [[KSPhotoItem alloc] initWithSourceView:nil imageUrl:[NSURL URLWithString:att.url]];
    }];
    
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:[picArray indexOfObject:currentAtt]];
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlur;
    [browser showFromViewController:self];
}

@end
