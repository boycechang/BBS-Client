//
//  TopTenViewController.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNoFooterWithDeleteTableView.h"
#import "GlobalViewCell.h"
#import "SingleTopicViewController.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"

@interface GlobalViewController : UIViewController<MBProgressHUDDelegate>
{
    NSMutableArray * newsArray;
    NSMutableArray * actionsArray;
    
    CustomNoFooterWithDeleteTableView * customTableView;
    UISegmentedControl * readModeSeg;
    
    FPActivityView* activityView;
    id __unsafe_unretained mDelegate;
}
@property(nonatomic, strong)NSMutableArray * newsArray;
@property(nonatomic, strong)NSMutableArray * actionsArray;
@property(nonatomic, strong)CustomNoFooterWithDeleteTableView * customTableView;
@property(nonatomic, strong)UISegmentedControl * readModeSeg;
@property(nonatomic, unsafe_unretained)id mDelegate;

-(IBAction)readModeSegChanged:(id)sender;

@end
