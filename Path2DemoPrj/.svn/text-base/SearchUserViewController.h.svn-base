//
//  SearchBoardViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/4/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "CustomNoFooterTableView.h"
#import "TimeScroller.h"
#import "QuadCurveMenu.h"
#import "BoardsCellView.h"
#import "TopicsViewController.h"
#import "FriendCellView.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"


@interface SearchUserViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSString * searchString;
    User * searchedUser;
    CustomNoFooterTableView * customTableView;
    MBProgressHUD * HUD;
    
    MyBBS * myBBS;
}
@property(nonatomic, strong)NSString * searchString;
@property(nonatomic, strong)User * searchedUser;

-(void)reloadData;
@end
