//
//  TopTenViewController.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNoFooterViewSectionHeaderTableView.h"
#import "TopTenTableViewCell.h"
#import "SingleTopicViewController.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"

@interface TopTenViewController : UIViewController<MBProgressHUDDelegate>
{
    NSArray * topTenArray;
    CustomNoFooterViewSectionHeaderTableView * customTableView;
    FPActivityView* activityView;
}

@property(nonatomic, strong)NSArray * topTenArray;
@property(nonatomic, strong)CustomNoFooterViewSectionHeaderTableView * customTableView;

@end
