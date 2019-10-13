//
//  AboutViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "AboutViewController.h"
#import "UIViewController+MJPopupViewController.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <SDImageCache.h>
#import "BYRSession.h"

@implementation AboutViewController
@synthesize mDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        imageCache = 0.0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    
    [settingTableView setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.title = @"设置";
    
//    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 2;
    }
    if (section == 1) {
        return 3;
    }
    if (section == 2) {
        return 1;
    }
    if (section == 3) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
//                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//                    cell.textLabel.text = @"当前用户";
//                    if (appDelegate.myBBS.mySelf.id != nil) {
//                        cell.detailTextLabel.text = appDelegate.myBBS.mySelf.id;
//                        [cell setAccessoryType:UITableViewCellAccessoryNone];
//                    }
//                    else{
//                        cell.detailTextLabel.text = @"未登录";
//                        [cell setAccessoryType:UITableViewCellAccessoryNone];
//                    }
                    break;
                }
                case 1:
                {
                    cell.textLabel.text = @"更改背景";
                    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                    if (self.backImage == nil) {
                        [cell.imageView setImage:[UIImage imageNamed:@"icon.png"]];
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                            self.backImage = [UIImage imageWithData:[defaults dataForKey:@"backImage"]];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [cell.imageView setImage:self.backImage];
                            });
                        });
                    } else {
                        [cell.imageView setImage:self.backImage];
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"关于";
                    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
                    NSString* version = [infoDict objectForKey:@"CFBundleShortVersionString"];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", version];
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    break;
                }
                case 1:
                    cell.textLabel.text = @"反馈";
                    break;
                case 2:
                    cell.textLabel.text = @"评价";
                    break;
                case 3:
                    cell.textLabel.text = @"帮助";
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"清除缓存";
                    if (imageCache != 0) {
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2f M", imageCache];
                    }
                    else {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            self->imageCache = [[SDImageCache sharedImageCache] totalDiskSize] / 1024.0 / 1024.0;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2f M", self->imageCache];
                            });
                        });
                    }
                }
                    break;
                default:
                    break;
            }
            break;
        case 3:
        {            
            cell.textLabel.text = @"登出";
            cell.textLabel.textColor = [UIColor redColor];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if (indexPath.section == 0 && indexPath.row == 0 && appDelegate.myBBS.mySelf.id != nil) {
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//
//        UserInfoViewController * userInfoViewController;
//        userInfoViewController = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
//        userInfoViewController.userString = appDelegate.myBBS.mySelf.id;
//        [self presentPopupViewController:userInfoViewController animationType:MJPopupViewAnimationSlideTopBottom];
//    }
    
//    if (indexPath.section == 0 && indexPath.row == 0 && appDelegate.myBBS.mySelf.id == nil) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"请先登录";
//        hud.margin = 30.f;
//        hud.yOffset = 0.f;
//        hud.removeFromSuperViewOnHide = YES;
//        [hud hide:YES afterDelay:0.8];
//        [tableView reloadData];
//    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
//        [self pickImageFromAlbum:nil];
    }
    
    if(indexPath.section == 1 && indexPath.row == 0) {
        articleViewController *articleVC = [[articleViewController alloc] init];
        [self.navigationController pushViewController:articleVC animated:YES];
    }
    
    if(indexPath.section == 1 && indexPath.row == 1) {
        [self sendFeedBack];
    }
    
    if(indexPath.section == 1 && indexPath.row == 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=736043107"]];
    }
    
    if(indexPath.section == 2 && indexPath.row == 0){
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        imageCache = 0;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"缓存清除成功";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.8];
        [tableView reloadData];
    }
    
    if(indexPath.section == 3 && indexPath.row == 0){
        [self showActionSheet:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(IBAction)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)showActionSheet:(id)sender
{
    UIActionSheet*actionSheet = [[UIActionSheet alloc]
                                 initWithTitle:@"确定登出北邮人？"
                                 delegate:self
                                 cancelButtonTitle:@"取消"
                                 destructiveButtonTitle:@"确定"
                                 otherButtonTitles:nil, nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view]; //show from our table view (pops up in the middle of the table)
}

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[BYRSession sharedInstance] logOut];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)sendFeedBack
{
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* version = [infoDict objectForKey:@"CFBundleVersion"];
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    [picker setToRecipients:[NSArray arrayWithObject:@"zhangxiaobo@me.com"]];
    [picker setSubject:@"北邮人客户端反馈"];
    [picker setMessageBody:[NSString stringWithFormat:@"\n\n\n\n设备: %@\n系统: iOS %@\n软件: 北邮人 %@", [self _platformString], [UIDevice currentDevice].systemVersion, version]  isHTML:NO];
    picker.mailComposeDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if(result==MFMailComposeResultCancelled){
    }else if(result==MFMailComposeResultSent){
        
    }else if(result==MFMailComposeResultFailed){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"邮件发送失败"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"好", nil];
        [alert show];
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Internal Info

- (NSString *) _platform
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

- (NSString *) _platformString
{
    NSString *platform = [self _platform];
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad 4 (CDMA)";
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

@end
