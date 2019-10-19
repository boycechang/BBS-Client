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
#import "NotificationListViewController.h"
#import "MailViewController.h"
#import "PostMailViewController.h"
#import "TopicViewController.h"

@interface NotificationViewController ()

@property (nonatomic, strong) NSArray *replys;
@property (nonatomic, strong) NSArray *ats;
@property (nonatomic, strong) NSArray *mails;

@property (nonatomic, assign) NSInteger replysTotal;
@property (nonatomic, assign) NSInteger replysNewCount;

@property (nonatomic, assign) NSInteger atsTotal;
@property (nonatomic, assign) NSInteger atsNewCount;

@property (nonatomic, assign) NSInteger mailsTotal;

@end

@implementation NotificationViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self refreshNotificationCount];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:NotificationCell.class
           forCellReuseIdentifier:NotificationCell.class.description];
    [self.tableView registerClass:NotificationHeaderCell.class
           forCellReuseIdentifier:NotificationHeaderCell.class.description];
    [self.tableView registerClass:NotificationFooterCell.class
           forCellReuseIdentifier:NotificationFooterCell.class.description];
    
    [self refresh];
}

#pragma mark - private

- (void)refreshNotificationCount {
    [[BYRNetworkManager sharedInstance] GET:@"/refer/reply/info.json" parameters:nil responseClass:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        self.replysNewCount = [[responseObject objectForKey:@"new_count"] intValue];
    } failure:nil];
    
    [[BYRNetworkManager sharedInstance] GET:@"/refer/at/info.json" parameters:nil responseClass:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        self.atsNewCount = [[responseObject objectForKey:@"new_count"] intValue];
    } failure:nil];
}


- (void)setReplysNewCount:(NSInteger)replysNewCount {
    _replysNewCount = replysNewCount;
    
    NSInteger total = _replysNewCount + _atsNewCount;
    self.tabBarItem.badgeValue = total == 0 ? nil : [NSString stringWithFormat:@"%li", total];
    [self.tableView reloadData];
}

- (void)setAtsNewCount:(NSInteger)atsNewCount {
    _atsNewCount = atsNewCount;
    
    NSInteger total = _replysNewCount + _atsNewCount;
    self.tabBarItem.badgeValue = total == 0 ? nil : [NSString stringWithFormat:@"%li", total];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
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
            [cell updateWithSectionName:@"回复" total:self.replysTotal unread:self.replysNewCount];
        } else if (section == 1) {
            [cell updateWithSectionName:@"@我" total:self.atsTotal unread:self.atsNewCount];
        } else {
            [cell updateWithSectionName:@"站内信" total:self.mailsTotal unread:0];
        }
        
        __weak typeof (self) wself = self;
        cell.loadMoreTapped = ^{
            [wself openNotificationList:section];
        };
        
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
        Mail *mail = [notifications objectAtIndex:row];
        NotificationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NotificationCell.class.description forIndexPath:indexPath];
        [cell updateWithMail:mail];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row - 1;
    
    if (section == 0) {
        Topic *topic = [self.replys objectAtIndex:row];
        TopicViewController *topicVC = [TopicViewController new];
        topicVC.topic = topic;
        [self.navigationController pushViewController:topicVC animated:YES];
    } else if (section == 1) {
        Topic *topic = [self.ats objectAtIndex:row];
        TopicViewController *topicVC = [TopicViewController new];
        topicVC.topic = topic;
        [self.navigationController pushViewController:topicVC animated:YES];
    } else if (section == 2) {
        Mail *mail = [self.mails objectAtIndex:row];
        MailViewController *mailVC = [MailViewController new];
        mailVC.mail = mail;
        [self.navigationController pushViewController:mailVC animated:YES];
    }
}

- (nullable UIContextMenuConfiguration *)tableView:(UITableView *)tableView contextMenuConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row - 1;
    
    UIContextMenuConfiguration *config = [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:^UIViewController * _Nullable{
        if (section == 0) {
            Topic *topic = [self.replys objectAtIndex:row];
            TopicViewController *topicVC = [TopicViewController new];
            topicVC.topic = topic;
            return topicVC;
        } else if (section == 1) {
            Topic *topic = [self.ats objectAtIndex:row];
            TopicViewController *topicVC = [TopicViewController new];
            topicVC.topic = topic;
            return topicVC;
        } else if (section == 2) {
            Mail *mail = [self.mails objectAtIndex:row];
            MailViewController *mailVC = [MailViewController new];
            mailVC.mail = mail;
            return mailVC;
        }
        return nil;
    } actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        if (section == 2) {
            Mail *mail = [self.mails objectAtIndex:row];
            UIAction *action1 = [UIAction actionWithTitle:@"回复" image:[UIImage systemImageNamed:@"arrowshape.turn.up.left"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                PostMailViewController * postMailVC = [[PostMailViewController alloc] init];
                postMailVC.postType = 1;
                postMailVC.rootMail = mail;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postMailVC];
                [self presentViewController:nav animated:YES completion:nil];
            }];
            UIMenu *menu = [UIMenu menuWithTitle:nil children:@[action1]];
            return menu;
        }
        return nil;
    }];

    return config;
}

- (void)openNotificationList:(NSInteger)type {
    NotificationListViewController *notificationList = [NotificationListViewController new];
    notificationList.type = type;
    [self.navigationController pushViewController:notificationList animated:YES];
}

#pragma mark - BYRTableViewControllerProtocol

- (void)refreshTriggled:(void (^)(void))completion {
    NSDictionary *params = @{@"count" : @5};
    
    [[BYRNetworkManager sharedInstance] GET:@"/refer/reply.json" parameters:params responseClass:TopicResponse.class success:^(NSURLSessionDataTask * _Nonnull task, TopicResponse * _Nullable responseObject) {
        self.replys = responseObject.topics;
        self.replysTotal = responseObject.pagination.item_all_count;
        completion();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion();
    }];
    
    [[BYRNetworkManager sharedInstance] GET:@"/refer/at.json" parameters:params responseClass:TopicResponse.class success:^(NSURLSessionDataTask * _Nonnull task, TopicResponse * _Nullable responseObject) {
        self.ats = responseObject.topics;
        self.atsTotal = responseObject.pagination.item_all_count;
        completion();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion();
    }];
    
    [[BYRNetworkManager sharedInstance] GET:@"/mail/inbox.json" parameters:params responseClass:MailResponse.class success:^(NSURLSessionDataTask * _Nonnull task, MailResponse * _Nullable responseObject) {
        self.mails = responseObject.mails;
        self.mailsTotal = responseObject.pagination.item_all_count;
        completion();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion();
    }];
}

@end
