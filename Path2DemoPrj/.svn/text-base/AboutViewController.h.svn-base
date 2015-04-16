//
//  AboutViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#include <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"
#import "UserInfoViewController.h"
#import "SDImageCache.h"
#import "ASIHTTPRequest.h"
#import "articleViewController.h"

@protocol AboutViewControllerDelegate <NSObject>

-(void)dismissAboutView;
-(void)logout;

@end

@interface AboutViewController : UIViewController<UIActionSheetDelegate, MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    MBProgressHUD * HUD;
    IBOutlet UITableView * settingTableView;
    id __unsafe_unretained mDelegate;
}
@property(nonatomic, unsafe_unretained)id mDelegate;
-(IBAction)done:(id)sender;

@end
