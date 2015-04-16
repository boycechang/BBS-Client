//
//  TopTenViewController.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "CustomTableView.h"
#import "TimeScroller.h"
#import "QuadCurveMenu.h"
#import "TopTenTableViewCell.h"
#import "SingleTopicViewController.h"

#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"

@interface TopicsViewController : UIViewController<TimeScrollerDelegate, MBProgressHUDDelegate, QuadCurveMenuDelegate>
{
    NSString * boardName;
    NSMutableArray * topTenArray;
    CustomTableView * customTableView;
    TimeScroller *_timeScroller;
    MBProgressHUD * HUD;
    QuadCurveMenu *menu;
    NSArray *modeContent;
    UIPickerView *modePicker;
    IBOutlet UILabel * topTitle;
    IBOutlet UISegmentedControl * readModeSeg;
    BOOL readModeSegIsShowing;
    
    int curMode;// 0 全部帖子（默认） 1 主题贴 2 论坛模式 3 置顶帖 4 文摘区 5 保留区
    MyBBS * myBBS;
}
@property(nonatomic, strong)NSString * boardName;
@property(nonatomic, strong)NSArray * topTenArray;
@property(nonatomic)CustomTableView * customTableView;

-(IBAction)back:(id)sender;
-(IBAction)changeCurMode:(id)sender;
-(IBAction)readModeSegChanged:(id)sender;
@end
