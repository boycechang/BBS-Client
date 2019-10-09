//
//  MailViewController.m
//  BYR
//
//  Created by Boyce on 10/6/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "MailViewController.h"
#import "MailHeaderCell.h"
#import "MailContentCell.h"
#import "BYRNetworkManager.h"
#import "BYRNetworkReponse.h"
#import "Models.h"
#import "PostMailViewController.h"
#import "BYRBBCodeToYYConverter.h"
#import <SafariServices/SafariServices.h>
#import <BlocksKit.h>
#import "KSPhotoBrowser.h"

@interface MailViewController ()
@property (nonatomic, strong) BYRBBCodeToYYConverter *converter;
@end

@implementation MailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    UIBarButtonItem *replyButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"arrowshape.turn.up.left"] style:UIBarButtonItemStylePlain target:self action:@selector(reply:)];
    self.navigationItem.rightBarButtonItem = replyButton;
    
    self.converter = [BYRBBCodeToYYConverter new];
    self.converter.actionDelegate = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:MailHeaderCell.class
           forCellReuseIdentifier:MailHeaderCell.class.description];
    [self.tableView registerClass:MailContentCell.class
           forCellReuseIdentifier:MailContentCell.class.description];
    
    [self refresh];
}

- (IBAction)reply:(id)sender {
    PostMailViewController * postMailVC = [[PostMailViewController alloc] init];
    postMailVC.postType = 1;
    postMailVC.rootMail = self.mail;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postMailVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark -
#pragma mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MailHeaderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MailHeaderCell.class.description forIndexPath:indexPath];
        [cell updateWithMail:self.mail];
        return cell;
    }
    
    MailContentCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MailContentCell.class.description forIndexPath:indexPath];
    [cell updateWithMail:self.mail converter:self.converter];
    return cell;
}

#pragma mark - BYRTableViewControllerProtocol

- (void)refreshTriggled:(void (^)(void))completion {
    [[BYRNetworkManager sharedInstance] GET:[NSString  stringWithFormat:@"/mail/inbox/%@.json", self.mail.index] parameters:nil responseClass:Mail.class success:^(NSURLSessionDataTask * _Nonnull task, Mail * _Nullable responseObject) {
        self.mail = responseObject;
        completion();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion();
    }];
}

#pragma mark - Trait Collection

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    self.mail.attributedContentCache = nil;
    [self.tableView reloadData];
}

#pragma mark - BYRBBCodeToYYConverterActionDelegate

- (void)BBCodeDidClickURL:(NSString *)url {
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

@end
