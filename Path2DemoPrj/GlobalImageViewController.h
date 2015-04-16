//
//  TopTenViewController.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableView.h"
#import "GlobalImageTableViewCell.h"
#import "SingleTopicViewController.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"

@interface GlobalImageViewController : UIViewController<MBProgressHUDDelegate, CustomTableViewDataDeleage, CustomTableViewDelegate>
{
    NSMutableArray * photographyArray;
    NSMutableArray * picturesArray;
    
    CustomTableView * customTableView;
    
    UISegmentedControl * readModeSeg;
    
    FPActivityView* activityView;
    id __unsafe_unretained mDelegate;
}
@property(nonatomic, strong)NSMutableArray * photographyArray;
@property(nonatomic, strong)NSMutableArray * picturesArray;
@property(nonatomic, strong)CustomTableView * customTableView;
@property(nonatomic, strong)UISegmentedControl * readModeSeg;
@property(nonatomic, unsafe_unretained)id mDelegate;

-(IBAction)readModeSegChanged:(id)sender;

@end
