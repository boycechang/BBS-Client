//
//  NotificationViewController.m
//  BYR
//
//  Created by Boyce on 10/4/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "NotificationViewController.h"
#import <Masonry.h>
#import "Models.h"
#import "TopicsViewController.h"
#import "BYRNetworkManager.h"
#import "BYRNetworkReponse.h"
#import "NotificationCell.h"
#import "NotificationHeaderCell.h"

@interface NotificationViewController ()

@property (nonatomic, strong) NSArray *replys;
@property (nonatomic, assign) NSInteger replysTotal;

@property (nonatomic, strong) NSArray *ats;
@property (nonatomic, assign) NSInteger atsTotal;

@property (nonatomic, strong) NSArray *mails;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:NotificationCell.class
           forCellReuseIdentifier:NotificationCell.class.description];
    [self.tableView registerClass:NotificationHeaderCell.class
           forCellReuseIdentifier:NotificationHeaderCell.class.description];
    [self.tableView registerClass:NotificationFooterCell.class
           forCellReuseIdentifier:NotificationFooterCell.class.description];
    
    [self refresh];
}

#pragma mark -
#pragma mark tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.replys.count == 0 ? 0 : self.replys.count + 2;
    } else if (section == 1) {
        return self.ats.count == 0 ? 0 : self.ats.count + 2;
    } else {
        return self.mails.count == 0 ? 0 : self.mails.count + 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row - 1;
    
    if (row == -1) {
        NotificationHeaderCell *cell = (NotificationHeaderCell *)[tableView dequeueReusableCellWithIdentifier:NotificationHeaderCell.class.description];
        
        if (section == 0) {
            [cell updateWithSectionName:@"回复" count:self.replysTotal];
        } else if (section == 1) {
            [cell updateWithSectionName:@"@我的" count:self.atsTotal];
        } else {
            [cell updateWithSectionName:@"收件箱" count:self.atsTotal];
        }
        
        return cell;
    }
    
    NSArray *notifications;
    if (section == 0 ) {
        notifications = self.replys;
    } else if (section == 1){
        notifications = self.ats;
    } else {
        notifications = self.mails;
    }
    
    if (row == notifications.count) {
        return [tableView dequeueReusableCellWithIdentifier:NotificationFooterCell.class.description];
    }
    
    if (section == 0 || section == 1) {
        Topic *topic = [notifications objectAtIndex:row];
        NotificationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NotificationCell.class.description forIndexPath:indexPath];
        [cell updateWithTopic:topic];
        return cell;
    } else {
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    Topic *topic = [self.topics objectAtIndex:indexPath.row];
//    SingleTopicViewController * singleTopicViewController = [[SingleTopicViewController alloc] initWithRootTopic:topic];
//    [self.navigationController pushViewController:singleTopicViewController animated:YES];
}


#pragma mark - BYRTableViewControllerProtocol

- (void)refreshTriggled:(void (^)(void))completion {
    
    NSDictionary *params = @{@"count" : @5};
    [[BYRNetworkManager sharedInstance] GET:[NSString stringWithFormat:@"/refer/%@.json", @"at"] parameters:params responseClass:TopicResponse.class success:^(NSURLSessionDataTask * _Nonnull task, TopicResponse * _Nullable responseObject) {
        self.ats = responseObject.topics;
        self.atsTotal = responseObject.pagination.item_all_count;
        completion();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion();
    }];
    
    [[BYRNetworkManager sharedInstance] GET:[NSString stringWithFormat:@"/refer/%@.json", @"reply"] parameters:params responseClass:TopicResponse.class success:^(NSURLSessionDataTask * _Nonnull task, TopicResponse * _Nullable responseObject) {
        self.replys = responseObject.topics;
        self.replysTotal = responseObject.pagination.item_all_count;
        completion();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion();
    }];
}

@end
