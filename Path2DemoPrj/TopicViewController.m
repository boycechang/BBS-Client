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
#import "ComposeViewController.h"
#import "TopicPageView.h"
#import <Masonry/Masonry.h>
#import "BLTNUserItem.h"
#import <BLTNBoard/BLTNBoard.h>
#import <BLTNBoard-Swift.h>
#import <UIImageView+WebCache.h>

@interface TopicViewController () <BYRBBCodeToYYConverterActionDelegate>

@property (nonatomic, strong) Pagination *pagination;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableDictionary *pageTopics;
@property (nonatomic, strong) BYRBBCodeToYYConverter *converter;

@property (nonatomic, strong) UIBarButtonItem *composeButtonItem;

@property (nonatomic, strong) TopicPageView *pageView;
@property (nonatomic, assign) BOOL isLoadingPage;

@property (nonatomic, strong) NSMutableDictionary *cellHeightsDictionary;

@property (nonatomic, strong) BLTNItemManager *BLTNManager;

@end

@implementation TopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    self.cellHeightsDictionary = @{}.mutableCopy;
    
    self.converter = [BYRBBCodeToYYConverter new];
    self.converter.actionDelegate = self;
    [self.tableView registerClass:ThreadCell.class
           forCellReuseIdentifier:ThreadCell.class.description];
    [self.tableView registerClass:ThreadCommentCell.class
           forCellReuseIdentifier:ThreadCommentCell.class.description];
    
    self.pageTopics = [NSMutableDictionary new];
    
    self.composeButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(compose:)];
    self.navigationItem.rightBarButtonItems = @[self.composeButtonItem];
    
    NSInteger initialSection = self.topic.pos / 20;
    [self loadSection:initialSection completion:^{
        [self.tableView reloadData];
        
        if ([self.tableView numberOfRowsInSection:initialSection] > self.topic.pos - initialSection * 20) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.topic.pos - initialSection * 20 inSection:initialSection];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:initialSection == 0 ? UITableViewScrollPositionTop : UITableViewScrollPositionTop animated:NO];
                
                if (self.topic.pos != 0) {
                    ThreadCommentCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                    [cell showHighlightAnimation];
                }
                
                self.isLoadingPage = NO;
            });
        }
    }];
    
    [self.view addSubview:self.pageView];
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(15);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-15);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
        make.height.mas_equalTo(44);
    }];
}

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

- (void)setPagination:(Pagination *)pagination {
    if (!_pagination) {
        [self.pageView updateWithCurrent:pagination.page_current_count total:pagination.page_all_count];
    }
    _pagination = pagination;
}

#pragma mark - actions

- (IBAction)compose:(id)sender {
    ComposeViewController * composeVC = [[ComposeViewController alloc] init];
//    postTopicViewController.postType = 0;
//    postTopicViewController.boardName = self.board.name;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:composeVC];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark -
#pragma mark tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.pagination.page_all_count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *topics = [self.pageTopics objectForKey:@(section)];
    return [topics count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *topics = [self.pageTopics objectForKey:@(indexPath.section)];
    Topic *topic = [topics objectAtIndex:indexPath.row];
    
    if ([topic.id isEqualToString:topic.group_id]) {
        ThreadCell *cell = (ThreadCell *)[tableView dequeueReusableCellWithIdentifier:ThreadCell.class.description];
        Topic *topic = [topics objectAtIndex:indexPath.row];
        cell.frame = self.view.frame;
        [cell updateWithTopic:topic converter:self.converter];
        
        __weak typeof (self) wself = self;
        cell.userTapped = ^(User * _Nonnull user) {
            [wself showUser:user];
        };
        return cell;
    } else {
        ThreadCommentCell *cell = (ThreadCommentCell *)[tableView dequeueReusableCellWithIdentifier:ThreadCommentCell.class.description];
        Topic *topic = [topics objectAtIndex:indexPath.row];
        [cell updateWithTopic:topic position:topic.position converter:self.converter];
        
        __weak typeof (self) wself = self;
        cell.userTapped = ^(User * _Nonnull user) {
            [wself showUser:user];
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *topics = [self.pageTopics objectForKey:@(indexPath.section)];
    Topic *topic = [topics objectAtIndex:indexPath.row];
    [self showUser:topic.user];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.cellHeightsDictionary setObject:@(cell.frame.size.height) forKey:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = [self.cellHeightsDictionary objectForKey:indexPath];
    if (height) return height.doubleValue;
    return UITableViewAutomaticDimension;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!scrollView.dragging && !scrollView.decelerating) {
        return;
    }
    
    NSArray <NSIndexPath *> *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
    if (visibleIndexPaths.count == 0) {
        return;
    }
    NSIndexPath *middleIndexPath = visibleIndexPaths.lastObject;
    [self.pageView updateWithCurrent:middleIndexPath.section + 1 total:self.pagination.page_all_count];
    
    // 判断是否需要加载上一页，跳页或锚点情况
    NSIndexPath *indexPath = visibleIndexPaths.firstObject;
    if (indexPath.section != 0 &&
        ![self.pageTopics objectForKey:@(indexPath.section - 1)] &&
        !self.isLoadingPage) {
    
        [self loadSection:indexPath.section - 1 completion:^{
            [self refreshTableViewData];
            self.isLoadingPage = NO;
        }];
    }
    
    // 判断是否需要加载下一页，跳页或锚点情况
    indexPath = visibleIndexPaths.lastObject;
    if (indexPath.section <= [self.tableView numberOfSections] - 1 &&
        indexPath.section < self.pagination.page_all_count - 1 &&
        ![self.pageTopics objectForKey:@(indexPath.section + 1)] &&
        !self.isLoadingPage) {
    
        [self loadSection:indexPath.section + 1 completion:^{
            [self refreshTableViewData];
            self.isLoadingPage = NO;
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.pageView fold];
}

#pragma mark - private

- (void)showUser:(User *)user {
    NSString *genderString = @"";
    if ([[user.gender lowercaseString] isEqualToString:@"m"]) {
        genderString = @"♂";
    } else if([[user.gender lowercaseString] isEqualToString:@"f"]) {
        genderString = @"♀";
    }
    
    BLTNUserItem *userItem = [[BLTNUserItem alloc] initWithTitle:user.id];
    [userItem.headImageView sd_setImageWithURL:user.face_url];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mm"];
    NSString * lastloginstring = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:user.last_login_time]];
    
    userItem.usernameLabel.text = [NSString stringWithFormat:@"%@\n%@ · 发帖数%li · %@ · %@", user.id, user.level, user.post_count, user.astro, genderString];
    
    userItem.loginStatusLabel.text = [NSString stringWithFormat:@"%@\n%@", user.is_online ? @"在线" : [NSString stringWithFormat:@"上次登录:%@", lastloginstring], [NSString stringWithFormat:@"访问IP: %@", user.last_login_ip]];
    
    
    self.BLTNManager = [[BLTNItemManager alloc] initWithRootItem:userItem];
    self.BLTNManager.backgroundColor = [UIColor systemBackgroundColor];
    self.BLTNManager.backgroundViewStyle = [BLTNBackgroundViewStyle blurredWithStyle:UIBlurEffectStyleDark isDark:YES];
    [self.BLTNManager showBulletinAboveViewController:self animated:YES completion:^{
        
    }];
}

- (void)refreshTableViewData {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat oldContentHeight = self.tableView.contentSize.height;
        CGFloat oldOffsetY = self.tableView.contentOffset.y;
        
        [self.tableView reloadData];
        
        CGFloat newContentHeight = self.tableView.contentSize.height;
        CGFloat newOffsetY = oldOffsetY + (newContentHeight - oldContentHeight);
        
//        [self.tableView setContentOffset:CGPointMake(0, newOffsetY) animated:NO];
    });
}

#pragma mark - BYRTableViewControllerProtocol

- (void)refreshTriggled:(void (^)(void))completion {
    [self loadSection:0 completion:^{
        completion();
    }];
}

- (void)loadSection:(NSInteger)section completion:(void (^)(void))completion {
    if (self.isLoadingPage) {
        return;
    }
    
    self.isLoadingPage = YES;
    
    NSDictionary *params = @{@"page"  : @(section + 1),
                             @"count" : @20};
    
    [[BYRNetworkManager sharedInstance] GET:[NSString stringWithFormat:@"/threads/%@/%@.json", self.topic.board_name, self.topic.group_id] parameters:params responseClass:TopicResponse.class success:^(NSURLSessionDataTask * _Nonnull task, TopicResponse * _Nullable responseObject) {
        if (section == 0) {
            Topic *firstTopic = responseObject.topics.firstObject;
            firstTopic.reply_count = responseObject.reply_count;
        }
        
        self.pagination = responseObject.pagination;
        [self.pageTopics setObject:responseObject.topics
                            forKey:@(section)];
        
        completion();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion();
    }];
}

#pragma mark - Trait Collection

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    for (NSArray *topics in [self.pageTopics allValues]) {
        for (Topic *topic in topics) {
            topic.attributedContentCache = nil;
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - BYRBBCodeToYYConverterActionDelegate

- (void)BBCodeDidClickURL:(NSString *)url {
    if (![url hasPrefix:@"http"]) {
        return;
    }
    
    SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
    safari.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:safari animated:YES completion:nil];
}

- (void)BBCodeDidClickAttachment:(BYRImageAttachmentModel *)attachmentModel {
    NSArray <KSPhotoItem *>* items = [attachmentModel.allSortedAttachments bk_map:^id(BYRImageAttachmentModel *attModel) {
        return [[KSPhotoItem alloc] initWithSourceView:attModel.imageView imageUrl:[NSURL URLWithString:attModel.attachment.url]];
    }];
    
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:[attachmentModel.allSortedAttachments indexOfObject:attachmentModel]];
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlur;
    [browser showFromViewController:self];
}

#pragma mark - getter

- (TopicPageView *)pageView {
    if (!_pageView) {
        _pageView = [[TopicPageView alloc] initWithFrame:CGRectZero];
        __weak typeof (self) wself = self;
        _pageView.pageSelected = ^(NSInteger page) {
            [wself loadSection:page - 1 completion:^{
                [wself.tableView reloadData];
                if ([self.tableView numberOfRowsInSection:page - 1] > 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:page - 1];
                        [wself.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    });
                }
                wself.isLoadingPage = NO;
            }];
        };
    }
    return _pageView;
}

@end
