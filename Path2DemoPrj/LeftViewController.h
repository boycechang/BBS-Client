//
//  AboutViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BBSAPI.h"
#import "MyBBS.h"
#import "GlobalViewController.h"
#import "TopTenViewController.h"
#import "BoardsViewController.h"
#import "LoginViewController.h"
#import "AllFavViewController.h"
#import "MailBoxViewController.h"
#import "NotificationViewController.h"
#import "TopicsViewController.h"
#import "AboutViewController.h"
#import "GlobalImageViewController.h"
#import "VoteListViewController.h"
#import "XDKAirMenuController.h"
#import "AccountInfoHeaderView.h"
#import "ZFModalTransitionAnimator.h"

@interface LeftViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIActionSheetDelegate, AboutViewControllerDelegate, XDKAirMenuDelegate, AccountInfoHeaderViewDelegate> {
    
    NSArray *tableTitles;
    
    NSArray *tableIcon1;
    NSArray *tableIcon2;
    NSArray *tableIcon3;
    
    IBOutlet UISearchBar * search;
    IBOutlet UITableView * mainTableView;
    IBOutlet UIImageView * leftBackView;
    
    UIView * accountInfoHeaderView;
    
    IBOutlet UIButton * settingsButton;

    MyBBS * myBBS;
}

@property (nonatomic, strong) IBOutlet UITableView * mainTableView;
@property (nonatomic, strong) XDKAirMenuController *airMenuController;
@property (nonatomic, strong) AccountInfoHeaderView * accountInfoViewHeader;
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;

- (IBAction)cancelSearchButtonClicked:(id)sender;
- (IBAction)showLeftView:(id)sender;

@end
