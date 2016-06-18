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
    
    CustomNoFooterWithDeleteTableView * customTableView;
    UISegmentedControl * readModeSeg;
    
    FPActivityView* activityView;
    id __weak mDelegate;
}
@property (nonatomic, strong) NSMutableArray * newsArray;
@property (nonatomic, strong) CustomNoFooterWithDeleteTableView * customTableView;
@property (nonatomic, weak)id mDelegate;
@property (nonatomic, assign) int mode;

-(IBAction)readModeSegChanged:(id)sender;

@end
