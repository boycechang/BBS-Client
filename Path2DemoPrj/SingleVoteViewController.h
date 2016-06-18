//
//  SingleVoteViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/5/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
#import "UIImageView+AFNetworking.h"
#import "VoteCellView.h"
#import "OptionCellView.h"

@interface SingleVoteViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *optionsTableView;
    IBOutlet UIBarButtonItem *voteButton;
    
    Vote *rootVote;
    MBProgressHUD * HUD;
    FPActivityView* activityView;
    
    id __unsafe_unretained mDelegate;
    
    NSArray *myVoted;
    
    Vote *backVote;
    MBProgressHUD *hud;
}
@property(nonatomic, strong)Vote *rootVote;
@property(nonatomic, unsafe_unretained)id mDelegate;
@property(nonatomic, strong)NSArray *myVoted;

-(IBAction)vote:(id)sender;

@end
