//
//  SingleMailViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/6/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CustomTableView.h"
#import "TimeScroller.h"
#import "QuadCurveMenu.h"
#import "MailsViewCell.h"
#import "PostMailViewController.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
#import "MyBBS.h"

@interface SingleMailViewController : UIViewController<MBProgressHUDDelegate>
{
    IBOutlet UIScrollView * realScrollView;
    Mail * rootMail;
    Mail * mail;
    CustomTableView * customTableView;
    TimeScroller *_timeScroller;
    MBProgressHUD * HUD;
    MyBBS * myBBS;
    
    IBOutlet UILabel * topTitle;
    
    IBOutlet UILabel * authorLabel;
    IBOutlet UILabel * titleLabel;
    IBOutlet UILabel * content;
    
    IBOutlet UIScrollView * scrollView;
    IBOutlet UIView * realView;
    
    //用于查看消息提示时使用代理
    BOOL isForShowNotification;
    id mDelegate;
}
@property(nonatomic, retain)Mail * rootMail;
@property(nonatomic, retain)Mail * mail;
@property(nonatomic, assign)BOOL isForShowNotification;
@property(nonatomic, assign)id mDelegate;

-(IBAction)back:(id)sender;
@end