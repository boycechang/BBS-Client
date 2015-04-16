//
//  MailsViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/6/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "CustomTableWithDeleteView.h"
#import "TimeScroller.h"
#import "QuadCurveMenu.h"
#import "MailsViewCell.h"
#import "SingleMailViewController.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
#import "MyBBS.h"

@protocol MailsViewControllerDelegate <NSObject>
-(void)refreshNotification;
@end

@interface MailsViewController : UIViewController<TimeScrollerDelegate, MBProgressHUDDelegate>
{
    int mailBoxType;
    NSMutableArray * topTenArray;
    CustomTableWithDeleteView * customTableView;
    TimeScroller *_timeScroller;
    MBProgressHUD * HUD;
    id mDelegate;
    
    MyBBS * myBBS;
}
@property(nonatomic, assign)int mailBoxType;
@property(nonatomic, strong)NSArray * topTenArray;
@property(nonatomic, strong)id mDelegate;

@end
