//
//  AllFavViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "CustomNoFooterWithDeleteTableView.h"
#import "TimeScroller.h"
#import "QuadCurveMenu.h"
#import "BoardsCellView.h"
#import "TopicsViewController.h"
#import "FriendCellView.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
#import "MyBBS.h"


@interface AddPostUserViewController : UIViewController<TimeScrollerDelegate, MBProgressHUDDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSArray * onlineFriendsArray;
    NSArray * allFriendsArray;
    NSArray * showArray;
    
    IBOutlet UIButton * editFriendButton;
    IBOutlet UISegmentedControl * seg;
    CustomNoFooterWithDeleteTableView * customTableView;
    MBProgressHUD * HUD;
    id mDelegate;
    
    MyBBS * myBBS;
}
@property(nonatomic, retain)NSArray * onlineFriendsArray;
@property(nonatomic, retain)NSArray * allFriendsArray;
@property(nonatomic, assign)id mDelegate;

-(IBAction)back:(id)sender;
-(IBAction)segmentControlValueChanged:(id)sender;

-(IBAction)editFriends:(id)sender;
@end
