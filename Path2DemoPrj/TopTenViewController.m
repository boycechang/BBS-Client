;//
//  TopTenViewController.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "TopTenViewController.h"
#import <Masonry.h>
#import "TopicCell.h"
#import "TopTenCell.h"
#import "TopicHeaderCell.h"
#import "BYRNetworkManager.h"
#import "TopicViewController.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
#import "BYRNetworkReponse.h"
#import "VoteCell.h"
#import "BLTNVoteItem.h"
#import <UIImageView+WebCache.h>
#import <BLTNBoard/BLTNBoard.h>
#import <BLTNBoard-Swift.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface TopTenViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableDictionary <NSString *, NSArray *> *topTenContent;
@property (nonatomic, strong) NSDictionary <NSString *, NSString *> *topTenTitles;

@property (nonatomic, strong) NSArray *votes;
@property (nonatomic, strong) BLTNItemManager *BLTNManager;

@end

@implementation TopTenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    self.navigationItem.title = @"热门";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:TopTenCell.class
           forCellReuseIdentifier:TopTenCell.class.description];
    
    [self.tableView registerClass:TopicCell.class
           forCellReuseIdentifier:TopicCell.class.description];
    
    [self.tableView registerClass:VoteCell.class
           forCellReuseIdentifier:VoteCell.class.description];
    
    [self.tableView registerClass:TopicHeaderCell.class
           forCellReuseIdentifier:TopicHeaderCell.class.description];
    
    self.topTenContent = [NSMutableDictionary new];
    self.topTenTitles = @{@"-1" : @"今日十大",
                          @"0" : @"本站站务",
                          @"1" : @"北邮校园",
                          @"2" : @"学术科技",
                          @"3" : @"信息社会",
                          @"4" : @"人文艺术",
                          @"5" : @"生活时尚",
                          @"6" : @"休闲娱乐",
                          @"7" : @"体育健身",
                          @"8" : @"游戏对战",
                          @"9" : @"乡亲乡爱",
    };
    
    [self refresh];
}

#pragma mark -
#pragma mark tableViewDelegate

- (NSString *)keyForSection:(NSInteger)section {
    return [NSString stringWithFormat:@"%li", (long)section - 1];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.topTenTitles.allKeys count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //投票栏
    if (section == [self.topTenTitles.allKeys count]) {
        return [self.votes count] + 1;
    }
    
    NSArray *topics = [self.topTenContent objectForKey:[self keyForSection:section]];
    if ([topics count] == 0) {
        return 0;
    }
    
    return [topics count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row - 1;
    
    //投票栏
    if (section == [self.topTenTitles.allKeys count]) {
        if (row == -1) {
            TopicHeaderCell *cell = (TopicHeaderCell *)[tableView dequeueReusableCellWithIdentifier:TopicHeaderCell.class.description];
            [cell updateWithSectionName:@"最新投票"];
            return cell;
        }
        
        VoteCell *cell = (VoteCell *)[tableView dequeueReusableCellWithIdentifier:VoteCell.class.description];
        Vote *vote = [self.votes objectAtIndex:row];
        [cell updateWithVote:vote];
        return cell;
    }
    
    //第一个row是标题
    if (row == -1) {
        TopicHeaderCell *cell = (TopicHeaderCell *)[tableView dequeueReusableCellWithIdentifier:TopicHeaderCell.class.description];
        [cell updateWithSectionName:[self.topTenTitles objectForKey:[self keyForSection:section]]];
        return cell;
    }
    
    //第一个section用特殊cell
    if (section == 0) {
        TopTenCell *cell = (TopTenCell *)[tableView dequeueReusableCellWithIdentifier:TopTenCell.class.description];
        NSArray *topics = [self.topTenContent objectForKey:[self keyForSection:section]];
        Topic *topic = [topics objectAtIndex:row];
        [cell updateWithTopic:topic index:row];
        return cell;
    } else {
        TopicCell *cell = (TopicCell *)[tableView dequeueReusableCellWithIdentifier:TopicCell.class.description];
        NSArray *topics = [self.topTenContent objectForKey:[self keyForSection:section]];
        Topic *topic = [topics objectAtIndex:row];
        [cell updateWithTopic:topic];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row - 1;
    if (row == -1) {
        return;
    }
    
    //投票栏
    if (section == [self.topTenTitles.allKeys count]) {
        Vote *vote = [self.votes objectAtIndex:row];
        [self showSingleVote:vote];
        return;
    }
    
    NSArray *topics = [self.topTenContent objectForKey:[self keyForSection:section]];
    Topic *topic = [topics objectAtIndex:row];
    TopicViewController *topicViewController = [TopicViewController new];
    topicViewController.topic = topic;
    [self.navigationController pushViewController:topicViewController animated:YES];
}

- (nullable UIContextMenuConfiguration *)tableView:(UITableView *)tableView contextMenuConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point {
    
    UIContextMenuConfiguration *config = [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:^UIViewController * _Nullable{
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row - 1;
        if (row == -1) {
            return nil;
        }
        
        //投票栏
        if (section == [self.topTenTitles.allKeys count]) {
            return nil;
        }
        
        NSArray *topics = [self.topTenContent objectForKey:[self keyForSection:section]];
        Topic *topic = [topics objectAtIndex:row];
        TopicViewController *topicViewController = [TopicViewController new];
        topicViewController.topic = topic;
        
        return topicViewController;
    } actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        return nil;
    }];

    return config;
}

#pragma mark - BYRTableViewControllerProtocol

- (void)refreshTriggled:(void (^)(void))completion {
    [[BYRNetworkManager sharedInstance] GET:@"/widget/topten.json" parameters:nil responseClass:TopicResponse.class success:^(NSURLSessionDataTask * _Nonnull task, TopicResponse * _Nullable responseObject) {
        [self.topTenContent setValue:responseObject.topics forKey:[self keyForSection:0]];
        completion();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion();
    }];
    
    for (int section = 1; section <= 10; section++) {
        [[BYRNetworkManager sharedInstance] GET:[NSString stringWithFormat:@"/widget/section-%i.json", section - 1] parameters:nil responseClass:TopicResponse.class success:^(NSURLSessionDataTask * _Nonnull task, TopicResponse * _Nullable responseObject) {
            [self.topTenContent setValue:responseObject.topics forKey:[self keyForSection:section]];
            completion();
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            completion();
        }];
    }
    
    [[BYRNetworkManager sharedInstance] GET:@"/vote/category/all.json" parameters:nil responseClass:VoteResponse.class success:^(NSURLSessionDataTask * _Nonnull task, VoteResponse * _Nullable responseObject) {
        self.votes = responseObject.votes;
        completion();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion();
    }];
}


- (void)showSingleVote:(Vote *)vote {
    BLTNVoteItem *voteItem = [[BLTNVoteItem alloc] initWithTitle:vote.title];
    [voteItem.headImageView sd_setImageWithURL:vote.user.face_url];
    voteItem.usernameLabel.text = vote.user.user_name;
    [voteItem updateWithVote:vote];
    voteItem.alternativeButtonTitle = vote.type == 0 ? @"单选" : [NSString stringWithFormat:@"可选%i项", vote.limit];
    voteItem.actionButtonTitle = (vote.is_end ? @"已结束" : (vote.voted ? @"已投票" : @"投票"));
    voteItem.actionHandler = ^(BLTNActionItem * _Nonnull item) {
        if (voteItem.voted.count == 0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:voteItem.tableView animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"至少勾选一项";
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES afterDelay:1];
        } else {
            NSDictionary *param;
            if (vote.type == 0) {
                param = @{@"vote" : voteItem.voted.allObjects.firstObject};
            } else {
                param = @{@"vote" : voteItem.voted.allObjects};
            }
            
            [[BYRNetworkManager sharedInstance] POST:[NSString stringWithFormat:@"/vote/%i.json", vote.vid] parameters:param responseClass:SingleVoteResponse.class success:^(NSURLSessionDataTask * _Nonnull task, SingleVoteResponse * _Nullable response) {
                response.vote.vote_count++;
                response.vote.user_count++;
                
                vote.voted = response.vote.voted;
                vote.options = response.vote.options;
                vote.vote_count = response.vote.vote_count;
                vote.user_count = response.vote.user_count;
                [self.tableView reloadData];
                
                [voteItem updateWithVote:response.vote];
                
                voteItem.alternativeButtonTitle = vote.type == 0 ? @"单选" : [NSString stringWithFormat:@"可选%i项", vote.limit];
                voteItem.alternativeButton.titleLabel.textColor = [UIColor secondaryLabelColor];
                
                voteItem.actionButtonTitle = (vote.is_end ? @"已结束" : (vote.voted ? @"已投票" : @"投票"));
                voteItem.actionButton.enabled = !(vote.is_end || vote.voted);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
    };
    
    self.BLTNManager = [[BLTNItemManager alloc] initWithRootItem:voteItem];
    self.BLTNManager.backgroundColor = [UIColor tertiarySystemBackgroundColor];
    [self.BLTNManager showBulletinAboveViewController:self animated:YES completion:^{
        [[BYRNetworkManager sharedInstance] GET:[NSString stringWithFormat:@"/vote/%i.json", vote.vid] parameters:nil responseClass:SingleVoteResponse.class success:^(NSURLSessionDataTask * _Nonnull task, SingleVoteResponse * _Nullable response) {
            vote.voted = response.vote.voted;
            vote.options = response.vote.options;
            vote.vote_count = response.vote.vote_count;
            vote.user_count = response.vote.user_count;
            
            [voteItem updateWithVote:response.vote];
            
            voteItem.alternativeButtonTitle = vote.type == 0 ? @"单选" : [NSString stringWithFormat:@"可选%i项", vote.limit];
            voteItem.alternativeButton.titleLabel.textColor = [UIColor secondaryLabelColor];
            
            voteItem.actionButtonTitle = (vote.is_end ? @"已结束" : (vote.voted ? @"已投票" : @"投票"));
            voteItem.actionButton.enabled = !(vote.is_end || vote.voted);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }];
}

@end
