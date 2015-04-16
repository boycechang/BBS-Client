//
//  AllFavViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNoFooterTableView.h"
#import "BoardsCellView.h"
#import "TopicsViewController.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
#import "MyBBS.h"


@interface BoardsViewController : UIViewController<MBProgressHUDDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSArray * topTenArray;
    CustomNoFooterTableView * customTableView;
    UITableView * normalTableView;
    FPActivityView* activityView;
    
    NSString * rootSection;
    MyBBS * myBBS;
}
@property(nonatomic, strong)NSArray * topTenArray;
@property(nonatomic, strong)NSString * rootSection;
-(IBAction)back:(id)sender;
@end
