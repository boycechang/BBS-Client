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
#import <MBProgressHUD/MBProgressHUD.h>

@interface NotificationViewController ()

@property (nonatomic, strong) NSArray *replys;
@property (nonatomic, strong) NSArray *ats;
@property (nonatomic, strong) NSArray *mails;

@property (nonatomic, assign) NSInteger replysTotal;
@property (nonatomic, assign) NSInteger replysNewCount;

@property (nonatomic, assign) NSInteger atsTotal;
@property (nonatomic, assign) NSInteger atsNewCount;

@property (nonatomic, assign) NSInteger mailsTotal;

@property (nonatomic, strong) UIBarButtonItem *clearButton;

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
    
    self.clearButton = [[UIBarButtonItem alloc] initWithTitle:@"全部标为已读" style:UIBarButtonItemStylePlain target:self action:@selector(clearAllNotifications:)];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:NotificationCell.class
           forCellReuseIdentifier:NotificationCell.class.description];
    [self.tableView registerClass:NotificationHeaderCell.class
           forCellReuseIdentifier:NotificationHeaderCell.class.description];
    [self.tableView registerClass:NotificationFooterCell.class
           forCellReuseIdentifier:NotificationFooterCell.class.description];
    
    self.tableView.layer.masksToBounds = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.layer.shadowOffset = CGSizeMake(0.f, 0.f);
    self.tableView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.tableView.layer.shadowOpacity = 0.12f;
    self.tableView.layer.shadowRadius = 15.f;
    
    [self refresh];
}

#pragma mark - private

- (void)refreshNotificationCount {
    [[BYRNetworkManager sharedInstance] GET:@"/refer/reply/info.json" parameters:nil responseClass:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        self.replysNewCount = [[responseObject objectForKey:@"new_count"] intValue];
        [self updateNotificationCountDisplay];
    } failure:nil];
    
    [[BYRNetworkManager sharedInstance] GET:@"/refer/at/info.json" parameters:nil responseClass:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        self.atsNewCount = [[responseObject objectForKey:@"new_count"] intValue];
        [self updateNotificationCountDisplay];
    } failure:nil];
}

- (void)updateNotificationCountDisplay {
    NSInteger total = _replysNewCount + _atsNewCount;
    self.tabBarItem.badgeValue = total == 0 ? nil : [NSString stringWithFormat:@"%li", total];
    [self.tableView reloadData];
    
    if (total > 0) {
        self.navigationItem.rightBarButtonItem = self.clearButton;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
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
    if (row < 0 ||
        row >= [tableView numberOfRowsInSection:section] - 2) {
        return;
    }
    
    if (section == 0 || section == 1) {
        Topic *topic = section == 0 ? [self.replys objectAtIndex:row] : [self.ats objectAtIndex:row];
        
        if (topic.pos == -1) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"内容已被删除";
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES afterDelay:1];
        } else {
            TopicViewController *topicVC = [TopicViewController new];
            topicVC.topic = topic;
            [self.navigationController pushViewController:topicVC animated:YES];
        }
        
        if (!topic.is_read) {
            [self deleteNotificationType:section topic:topic];
        }
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
    if (row < 0 ||
        row >= [tableView numberOfRowsInSection:section] - 2) {
        return nil;
    }
    
    UIContextMenuConfiguration *config = [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:^UIViewController * _Nullable{
        if (section == 0 || section == 1) {
            Topic *topic = section == 0 ? [self.replys objectAtIndex:row] : [self.ats objectAtIndex:row];
            TopicViewController *topicVC = [TopicViewController new];
            topicVC.topic = topic;
            
            if (!topic.is_read) {
                [self deleteNotificationType:section topic:topic];
            }
            
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


#pragma mark - API

- (void)deleteNotificationType:(NSInteger)type topic:(Topic *)topic {
    topic.is_read = YES;
    [[BYRNetworkManager sharedInstance] POST:[NSString stringWithFormat:@"/refer/%@/setRead/%li.json", type == 0 ? @"reply" : @"at", topic.index] parameters:nil responseClass:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        if (type == 0) {
            self.replysNewCount--;
        } else {
            self.atsNewCount--;
        }
        [self.tableView reloadData];
        [self updateNotificationCountDisplay];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}

- (IBAction)clearAllNotifications:(id)sender {
    [[BYRNetworkManager sharedInstance] POST:@"/refer/at/setRead.json" parameters:nil responseClass:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        for (Topic *topic in self.ats) {
            topic.is_read = YES;
        }
        self.atsNewCount = 0;
        [self updateNotificationCountDisplay];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
    
    [[BYRNetworkManager sharedInstance] POST:@"/refer/reply/setRead.json" parameters:nil responseClass:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        for (Topic *topic in self.replys) {
            topic.is_read = YES;
        }
        self.replysNewCount = 0;
        [self updateNotificationCountDisplay];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}

@end
