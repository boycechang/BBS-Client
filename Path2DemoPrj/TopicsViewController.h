//
//  TopTenViewController.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFNavigationBarDrawer.h"
#import "CustomTableView.h"
#import "TopTenTableViewCell.h"
#import "SingleTopicViewController.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"

@interface TopicsViewController : UIViewController<MBProgressHUDDelegate, UISearchBarDelegate>
{
    Board * board;
    NSMutableArray * topTenArray;
    NSMutableArray * searchArray;
    CustomTableView * customTableView;
    NSArray *modeContent;
    IBOutlet UILabel * topTitle;
    UISegmentedControl * readModeSeg;
    BOOL readModeSegIsShowing;
    FPActivityView* activityView;
    int curMode;// 0 全部帖子（默认） 1 主题贴 2 论坛模式 3 置顶帖 4 文摘区 5 保留区
    MyBBS * myBBS;
    
    int userOnline;
    int postToday;
    int postAll;
    
    BOOL isSearching;
    NSString *searchString;
}
@property(nonatomic, retain)Board * board;
@property(nonatomic, strong)NSMutableArray * topTenArray;
@property(nonatomic, strong)NSMutableArray * searchArray;
@property(nonatomic, strong)CustomTableView * customTableView;
@property(nonatomic, strong)UISegmentedControl * readModeSeg;
@property(nonatomic, strong)BFNavigationBarDrawer *drawer;

-(void)changeReadMode;
-(IBAction)readModeSegChanged:(id)sender;

@end
