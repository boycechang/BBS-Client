//
//  AllFavViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CustomNoFooterWithDeleteTableView.h"
#import "BoardsViewController.h"
#import "BoardsCellView.h"
#import "TopicsViewController.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
#import "MyBBS.h"


@interface AllFavViewController : UIViewController<MBProgressHUDDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSArray * topTenArray;
    CustomNoFooterWithDeleteTableView * customTableView;
    UITableView * normalTableView;
    FPActivityView* activityView;
    
    NSString * topTitleString;
    MyBBS * myBBS;
}
@property(nonatomic, strong)NSArray * topTenArray;
@property(nonatomic, strong)NSString * topTitleString;
-(IBAction)back:(id)sender;
@end
