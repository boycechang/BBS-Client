//
//  SingleTopicViewController.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "TopicsViewController.h"
#import "CustomTableView.h"
#import "TimeScroller.h"
#import "QuadCurveMenu.h"
#import "SingleTopicCell.h"
#import "SingleTopicCommentCell.h"
#import "PostTopicViewController.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
#import "UserInfoViewController.h"
#import "AttachmentsViewController.h"
//#import "MWPhotoBrowserIncell.h"

@protocol SingleTopicViewControllerDelegate <NSObject>
-(void)refreshNotification;
@end


@interface SingleTopicViewController : UIViewController<TimeScrollerDelegate, MBProgressHUDDelegate, QuadCurveMenuDelegate, UIActionSheetDelegate>
{
    Topic * rootTopic;
    Topic * selectTopic;
    NSMutableArray * topicsArray;
    CustomTableView * customTableView;
    TimeScroller *_timeScroller;
    MBProgressHUD * HUD;
    QuadCurveMenu * menu;

    UILabel * topTitle;
    
    MyBBS * myBBS;
    
    BOOL isForShowNotification;
    
    id __unsafe_unretained mDelegate;
    TopTenTableViewCell * selectedCell;
    
    int tableHeight;
}
@property(nonatomic, strong)Topic * rootTopic;
@property(nonatomic, assign)BOOL isForShowNotification;
@property(nonatomic, unsafe_unretained)id mDelegate;
@property(nonatomic)CustomTableView * customTableView;
@property(nonatomic, strong)TopTenTableViewCell * selectedCell;
-(IBAction)back:(id)sender;

@end
