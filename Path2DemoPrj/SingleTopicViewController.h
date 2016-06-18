//
//  SingleTopicViewController.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TopicsViewController.h"
#import "CustomTableView.h"
#import "SingleTopicCell.h"
#import "SingleTopicCommentCell.h"
#import "PostTopicViewController.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
#import "UserInfoViewController.h"
#import "WebViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "ModalViewController.h"

@protocol SingleTopicViewControllerDelegate <NSObject>
-(void)refreshNotification;
@end

@interface SingleTopicViewController : UIViewController<MBProgressHUDDelegate, UIActionSheetDelegate, SingleTopicCellDelegate, SingleTopicCommentCellDelegate, UIGestureRecognizerDelegate, ModalViewControllerDelegate>
{
    Topic *rootTopic;
    Topic * newRootTopic;
    NSMutableArray *topicsArray;

    CustomTableView *customTableView;
    
    FPActivityView* activityView;
    MyBBS * myBBS;
    
    int tableHeight;
    
    BOOL isPageChangeViewShowing;
    ModalViewController *pageChangeView;
    UIBarButtonItem *pageButton;
    int pageCount;
    int currentLowPage;
    int currentShowPage;
    int currentHighPage;
}

@property(nonatomic, strong)Topic * rootTopic;
@property(nonatomic, strong)CustomTableView * customTableView;
@property(nonatomic, strong)UIViewController *forRetainController;

- (id)initWithRootTopic:(Topic *)topic;

@end
