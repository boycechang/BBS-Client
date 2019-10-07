//
//  NotificationListViewController.m
//  BYR
//
//  Created by Boyce on 10/6/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "NotificationListViewController.h"
#import "NotificationCell.h"
#import "BYRNetworkManager.h"
#import "BYRNetworkReponse.h"
#import "Models.h"
#import "MailViewController.h"
#import "PostMailViewController.h"

@interface NotificationListViewController () <UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *notifications;
@property (nonatomic, assign) NSInteger notificationTotal;

@end

@implementation NotificationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.type) {
        case NotificationTypeReply:
            self.navigationItem.title = @"回复";
            break;
        case NotificationTypeAt:
            self.navigationItem.title = @"@我";
            break;
        case NotificationTypeMail:
            self.navigationItem.title = @"站内信";
            break;
        default:
            break;
    }
    
    self.notifications = [NSMutableArray new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:NotificationCell.class
           forCellReuseIdentifier:NotificationCell.class.description];
    
    [self refresh];
}

- (void)setNotificationTotal:(NSInteger)notificationTotal {
    _notificationTotal = notificationTotal;
    self.enableLoadMore = (self.notifications.count != notificationTotal);
}

#pragma mark -
#pragma mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NotificationCell.class.description forIndexPath:indexPath];
    
    if (self.type == NotificationTypeReply ||
        self.type == NotificationTypeAt) {
        Topic *topic = [self.notifications objectAtIndex:indexPath.row];
        [cell updateWithTopic:topic];
    } else {
        Mail *mail = [self.notifications objectAtIndex:indexPath.row];
        [cell updateWithMail:mail];
    }
    
    [cell showPlainStyle:YES];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == NotificationTypeMail) {
        Mail *mail = [self.notifications objectAtIndex:indexPath.row];
        MailViewController *mailVC = [MailViewController new];
        mailVC.mail = mail;
        [self.navigationController pushViewController:mailVC animated:YES];
    }
}

- (nullable UIContextMenuConfiguration *)tableView:(UITableView *)tableView contextMenuConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point {
    if (self.type != NotificationTypeMail) {
        return nil;
    }
    
    if (self.type == NotificationTypeMail) {
        Mail *mail = [self.notifications objectAtIndex:indexPath.row];
        MailViewController *mailVC = [MailViewController new];
        mailVC.mail = mail;
    }
    
    UIContextMenuConfiguration *config = [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:^UIViewController * _Nullable{
        if (self.type == NotificationTypeMail) {
            Mail *mail = [self.notifications objectAtIndex:indexPath.row];
            MailViewController *mailVC = [MailViewController new];
            mailVC.mail = mail;
            return mailVC;
        }
        return nil;
    } actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        if (self.type == NotificationTypeMail) {
            Mail *mail = [self.notifications objectAtIndex:indexPath.row];
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

#pragma mark - BYRTableViewControllerProtocol

- (void)refreshTriggled:(void (^)(void))completion {
    NSDictionary *params = @{@"count" : @20};
    
    switch (self.type) {
        case NotificationTypeReply:
        case NotificationTypeAt: {
            [[BYRNetworkManager sharedInstance] GET: self.type == NotificationTypeReply ? @"/refer/reply.json" : @"/refer/at.json" parameters:params responseClass:TopicResponse.class success:^(NSURLSessionDataTask * _Nonnull task, TopicResponse * _Nullable responseObject) {
                [self.notifications removeAllObjects];
                [self.notifications addObjectsFromArray:responseObject.topics];
                self.notificationTotal = responseObject.pagination.item_all_count;
                completion();
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completion();
            }];
        }
            break;
        case NotificationTypeMail: {
            [[BYRNetworkManager sharedInstance] GET:@"/mail/inbox.json" parameters:params responseClass:MailResponse.class success:^(NSURLSessionDataTask * _Nonnull task, MailResponse * _Nullable responseObject) {
                [self.notifications removeAllObjects];
                [self.notifications addObjectsFromArray:responseObject.mails];
                self.notificationTotal = responseObject.pagination.item_all_count;
                completion();
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completion();
            }];
        }
            break;
        default:
            break;
    }
}

- (void)loadMoreTriggled:(void (^)(void))completion {
    NSDictionary *params = @{@"page"  : @(self.notifications.count / 20 + 1),
                             @"count" : @20};
    
    switch (self.type) {
        case NotificationTypeReply:
        case NotificationTypeAt: {
            [[BYRNetworkManager sharedInstance] GET: self.type == NotificationTypeReply ? @"/refer/reply.json" : @"/refer/at.json" parameters:params responseClass:TopicResponse.class success:^(NSURLSessionDataTask * _Nonnull task, TopicResponse * _Nullable responseObject) {
                [self.notifications addObjectsFromArray:responseObject.topics];
                self.notificationTotal = responseObject.pagination.item_all_count;
                completion();
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completion();
            }];
        }
            break;
        case NotificationTypeMail: {
            [[BYRNetworkManager sharedInstance] GET:@"/mail/inbox.json" parameters:params responseClass:MailResponse.class success:^(NSURLSessionDataTask * _Nonnull task, MailResponse * _Nullable responseObject) {
                [self.notifications addObjectsFromArray:responseObject.mails];
                self.notificationTotal = responseObject.pagination.item_all_count;
                completion();
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completion();
            }];
        }
            break;
        default:
            break;
    }
}

@end
