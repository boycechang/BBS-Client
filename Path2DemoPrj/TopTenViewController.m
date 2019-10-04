;//
//  TopTenViewController.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "TopTenViewController.h"
#import "FTPagingViewController.h"
#import <Masonry.h>
#import "TopicCell.h"
#import "TopicHeaderCell.h"
#import "BYRNetworkManager.h"
#import "SingleTopicViewController.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
#import "BYRNetworkReponse.h"

@interface TopTenViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableDictionary <NSString *, NSArray *> *topTenContent;
@property (nonatomic, strong) NSDictionary <NSString *, NSString *> *topTenTitles;

@end

@implementation TopTenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"热门";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:TopicCell.class
           forCellReuseIdentifier:TopicCell.class.description];
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
    return [self.topTenTitles.allKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *topics = [self.topTenContent objectForKey:[self keyForSection:section]];
    if ([topics count] == 0) {
        return 0;
    }
    return [topics count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row - 1;
    if (row == -1) {
        TopicHeaderCell *cell = (TopicHeaderCell *)[tableView dequeueReusableCellWithIdentifier:TopicHeaderCell.class.description];
        [cell updateWithSectionName:[self.topTenTitles objectForKey:[self keyForSection:section]]];
        return cell;
    }
    
    TopicCell *cell = (TopicCell *)[tableView dequeueReusableCellWithIdentifier:TopicCell.class.description];
    NSArray *topics = [self.topTenContent objectForKey:[self keyForSection:section]];
    Topic *topic = [topics objectAtIndex:row];
    [cell updateWithTopic:topic];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row - 1;
    if (row == -1) {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *topics = [self.topTenContent objectForKey:[self keyForSection:section]];
    Topic *topic = [topics objectAtIndex:row];
    SingleTopicViewController * singleTopicViewController = [[SingleTopicViewController alloc] initWithRootTopic:topic];
    [self.navigationController pushViewController:singleTopicViewController animated:YES];
}

#pragma mark - BYRTableViewControllerProtocol

- (void)refreshTriggled:(void (^)(void))completion {
    __block int finishedCount = 0;
    
    [[BYRNetworkManager sharedInstance] GET:@"/widget/topten.json" parameters:nil responseClass:TopicResponse.class success:^(NSURLSessionDataTask * _Nonnull task, TopicResponse * _Nullable responseObject) {
        [self.topTenContent setValue:responseObject.topics forKey:[self keyForSection:0]];
        
        finishedCount++;
        if (finishedCount == 11) {
            completion();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finishedCount++;
        if (finishedCount == 11) {
            completion();
        }
    }];
    
    for (int section = 1; section <= 10; section++) {
        [[BYRNetworkManager sharedInstance] GET:[NSString stringWithFormat:@"/widget/section-%i.json", section - 1] parameters:nil responseClass:TopicResponse.class success:^(NSURLSessionDataTask * _Nonnull task, TopicResponse * _Nullable responseObject) {
            [self.topTenContent setValue:responseObject.topics forKey:[self keyForSection:section]];
            
            finishedCount++;
            if (finishedCount == 11) {
                completion();
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            finishedCount++;
            if (finishedCount == 11) {
                completion();
            }
        }];
    }
}

@end
