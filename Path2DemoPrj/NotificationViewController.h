//
//  NotificationViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/7/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CustomTableView.h"
#import "TopTenTableViewCell.h"
#import "SingleTopicViewController.h"
#import "SingleMailViewController.h"
#import "MailsViewCell.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
@interface NotificationViewController : UIViewController<UIActionSheetDelegate>
{
    CustomTableView * customTableView;
    MyBBS * myBBS;
    MBProgressHUD * HUD;
    FPActivityView* activityView;
    
    NSArray * atArray;
    NSArray * replyArray;
    
    UISegmentedControl * seg;
    UIImageView * atImageView;
    UIImageView * replyImageView;
}
@property(nonatomic, strong)NSArray * atArray;
@property(nonatomic, strong)NSArray * replyArray;
@property(nonatomic, strong)UISegmentedControl * seg;
@property(nonatomic, strong)UIImageView * atImageView;
@property(nonatomic, strong)UIImageView * replyImageView;

-(IBAction)clearAll:(id)sender;
@end
