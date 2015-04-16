//
//  AboutViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "AboutViewController.h"
#import "SEFilterControl.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation AboutViewController
@synthesize mDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    
    [settingTableView setFrame:CGRectMake(0, 44, rect.size.width, rect.size.height-44)];
    settingTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }
    if(section == 1){
        return 4;
    }
    if (section == 2) {
        return 3;
    }
    if (section == 3) {
        return 2;
    }
    if (section == 4) {
        return 1;
    }
    return 0;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 && indexPath.row == 3){
        return 74;
    }
    return 44;
}


- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            return @"偏好设置";
            break;
        default:
            break;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    /*
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"uploadImageCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"uploadImageCell"];
        }
    }
    else
     */
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    cell.textLabel.text = @"当前用户";
                    cell.detailTextLabel.text = appDelegate.myBBS.mySelf.ID;
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
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
                    cell.textLabel.text = @"新消息提示音";
                    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                    BOOL isNotifySound = [defaults boolForKey:@"isNotifySound"];
                    UISwitch * notifySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(210, 8, 80, 28)];
                    notifySwitch.backgroundColor = [UIColor clearColor];
                    notifySwitch.on = isNotifySound;
                    [notifySwitch addTarget:self action:@selector(notifySwitch:) forControlEvents:UIControlEventValueChanged];
                    [cell.contentView addSubview:notifySwitch];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
                case 1:
                {
                    cell.textLabel.text = @"加载用户头像";
                    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                    BOOL isLoadAvatar = [defaults boolForKey:@"isLoadAvatar"];
                    UISwitch * loadAvatarSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(210, 8, 80, 28)];
                    loadAvatarSwitch.backgroundColor = [UIColor clearColor];
                    loadAvatarSwitch.on = isLoadAvatar;
                    [loadAvatarSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
                    [cell.contentView addSubview:loadAvatarSwitch];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
                case 2:
                {
                    cell.textLabel.text = @"图文混排显示";
                    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                    BOOL ShowAttachments = [defaults boolForKey:@"ShowAttachments"];
                    UISwitch * loadAvatarSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(210, 8, 80, 28)];
                    loadAvatarSwitch.backgroundColor = [UIColor clearColor];
                    loadAvatarSwitch.on = ShowAttachments;
                    [loadAvatarSwitch addTarget:self action:@selector(showAttachments:) forControlEvents:UIControlEventValueChanged];
                    [cell.contentView addSubview:loadAvatarSwitch];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
                case 3:
                {
                    cell.textLabel.text = @"上传图片质量";
                    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                    int uploadImage = [defaults integerForKey:@"uploadImage"];
                    
                    SEFilterControl *filter = [[SEFilterControl alloc] initWithFrame:CGRectMake(130, 4, 170, 70) Titles:[NSArray arrayWithObjects:@"原图", @"中等", @"低质", nil]];
                    [filter setSelectedIndex:uploadImage];
                    [filter setProgressColor:[UIColor colorWithRed:0.21 green:0.47 blue:0.79 alpha:1]];
                    [filter addTarget:self action:@selector(filterValueChanged:) forControlEvents:UIControlEventValueChanged];
                    [cell.contentView addSubview:filter];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                }
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                {
                    NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"Path2DemoPrj copy-Info" ofType:@"plist"];
                    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
                    
                    cell.textLabel.text = @"软件版本";
                    cell.detailTextLabel.text = [dictionary objectForKey:@"CFBundleVersion"];
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    break;
                }
                case 1:
                    cell.textLabel.text = @"意见反馈";
                    break;
                case 2:
                    cell.textLabel.text = @"评价应用";
                    break;
                default:
                    break;
            }
            break;
        case 3:
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"清除图片缓存";
                    break;
                }
                case 1:
                {
                    cell.textLabel.text = @"清除所有网络缓存";
                    break;
                }
                default:
                    break;
            }
            break;
        case 4:
        {
            UIButton *logOutButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [logOutButton setFrame:CGRectMake(0, 0, 300, 47)];
            [logOutButton setImage:[UIImage imageNamed:@"LogOutNormal.png"] forState:UIControlStateNormal];
            [logOutButton setImage:[UIImage imageNamed:@"LogOutPress.png"] forState:UIControlStateHighlighted];
            [logOutButton addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell setBackgroundView:logOutButton];
            [cell.contentView setHidden:YES];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        BOOL * isLoadAvatar = [defaults boolForKey:@"isLoadAvatar"];
        UserInfoViewController * userInfoViewController;
        if (isLoadAvatar) {
            userInfoViewController = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
        }
        else {
            userInfoViewController = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController_noAvatar" bundle:nil];
        }
        
        userInfoViewController.userString = appDelegate.myBBS.mySelf.ID;
        [self.navigationController pushViewController:userInfoViewController animated:YES];
    }
    
    if(indexPath.section == 2 && indexPath.row == 0){
        articleViewController *articleVC = [[articleViewController alloc] init];
        [self.navigationController pushViewController:articleVC animated:YES];
    }
    
    if(indexPath.section == 2 && indexPath.row == 1){
        [self sendFeedBack];
    }
    
    if(indexPath.section == 2 && indexPath.row == 2){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=535692842"]];
    }
    
    if(indexPath.section == 3 && indexPath.row == 0){
        [[SDImageCache sharedImageCache] cleanDisk];
        [[SDImageCache sharedImageCache] clearDisk];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"图片缓存清除成功";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.8];
    }
    
    if(indexPath.section == 3 && indexPath.row == 1){
        [[SDImageCache sharedImageCache] cleanDisk];
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        [ASIHTTPRequest clearSession];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"网络缓存清除成功";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.8];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



-(IBAction)done:(id)sender
{
    [mDelegate dismissAboutView];
}

-(IBAction)showActionSheet:(id)sender
{
    UIActionSheet*actionSheet = [[UIActionSheet alloc]
                                 initWithTitle:@"确定登出虎踞龙蟠BBS？"
                                 delegate:self
                                 cancelButtonTitle:@"取消"
                                 destructiveButtonTitle:@"登出"
                                 otherButtonTitles:nil, nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view]; //show from our table view (pops up in the middle of the table)
}

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [mDelegate logout];
        [mDelegate dismissAboutView];
    }
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isButtonOn forKey:@"isLoadAvatar"];
}
-(void)notifySwitch:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isButtonOn forKey:@"isNotifySound"];
    if (isButtonOn) {
        CFURLRef		soundFileURLRef;
        SystemSoundID	soundFileObject;
        NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: @"notification"
                                                    withExtension: @"wav"];
        soundFileURLRef = (__bridge CFURLRef) tapSound;
        AudioServicesCreateSystemSoundID (soundFileURLRef, &soundFileObject);
        AudioServicesPlaySystemSound (soundFileObject);
        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    }
}
-(void)showAttachments:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isButtonOn forKey:@"ShowAttachments"];
}

-(void)sendFeedBack
{
    NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"Path2DemoPrj copy-Info" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    [picker setToRecipients:[NSArray arrayWithObject:@"zhangxiaobo@me.com"]];
    [picker setSubject:@"虎踞龙蟠客户端反馈"];
    [picker setMessageBody:[NSString stringWithFormat:@"\n\n\n\n设备: %@\n系统: iOS %@\n软件: 虎踞龙蟠 %@", [self _platformString], [UIDevice currentDevice].systemVersion, [dictionary objectForKey:@"CFBundleVersion"]]  isHTML:NO];
    picker.mailComposeDelegate = self;
    [self presentModalViewController:picker animated:YES];
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
    [controller dismissModalViewControllerAnimated:YES];
}

#pragma mark - SEFilterControlDelegate

-(void)filterValueChanged:(SEFilterControl *) sender{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:sender.SelectedIndex forKey:@"uploadImage"];
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
    NSLog(@"%@",platform);
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
