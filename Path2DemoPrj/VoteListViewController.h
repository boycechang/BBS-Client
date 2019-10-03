//
//  NotificationViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/7/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SingleVoteViewController.h"
#import "VoteCellView.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
#import "CustomTableView.h"
#import "UIViewController+MJPopupViewController.h"


@interface VoteListViewController : UIViewController {
    MyBBS * myBBS;
    FPActivityView* activityView;
    
    NSArray * mailsArray0;
    NSArray * mailsArray1;
    NSArray * mailsArray2;
    
    UISegmentedControl * seg;
}
@property(nonatomic, strong)NSArray * mailsArray0;
@property(nonatomic, strong)NSArray * mailsArray1;
@property(nonatomic, strong)NSArray * mailsArray2;

@property(nonatomic, strong)UISegmentedControl * seg;

-(IBAction)newMail:(id)sender;
@end
