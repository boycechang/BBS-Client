//
//  SingleTopicViewController.h
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TopicsViewController.h"
#import "CustomTableView.h"
#import "SingleTopicCellImage.h"
#import "SingleTopicCellVideo.h"
#import "PostTopicViewController.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
#import "UserInfoViewController.h"
#import "WebViewController.h"
#import "UIViewController+MJPopupViewController.h"

@protocol SingleMapNewsViewController <NSObject>
-(void)refreshNotification;
@end

@interface SingleMapNewsViewController : UIViewController<MBProgressHUDDelegate, UIActionSheetDelegate, SingleTopicCellDelegate, SingleTopicCellVideoDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    Topic *rootTopic;
    AVObject *rootNews;
    
    NSMutableArray *topicsArray;

    UITableView *customTableView;
    
    FPActivityView* activityView;
    MyBBS * myBBS;
    
    int tableHeight;
}
@property(nonatomic, strong)Topic * rootTopic;
@property(nonatomic, strong)AVObject * rootNews;
@property(nonatomic, strong)Memo * memo;
@property(nonatomic, strong)UITableView * customTableView;
@property(nonatomic, strong)UIViewController *forRetainController;

- (id)initWithRootTopic:(Topic *)topic;
- (id)initWithRootNews:(AVObject *)news;
- (IBAction)back:(id)sender;

@end
