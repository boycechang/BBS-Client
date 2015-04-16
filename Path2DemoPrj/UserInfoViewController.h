//
//  UserInfoViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/5/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import "CustomTableView.h"
#import "PostMailViewController.h"
#import "SingleTopicCell.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"

@protocol UserInfoViewControllerDelegate <NSObject>
-(void)dismissUserInfoView;
@end

@interface UserInfoViewController : UIViewController
{
    NSString * userString;
    User * user;
    MyBBS * myBBS;
    MBProgressHUD * HUD;
    FPActivityView* activityView;
    BOOL isShowBigAvatar;
    
    IBOutlet UIBarButtonItem * sentMailButton;
    IBOutlet UIBarButtonItem * addFriendButton;
    
    IBOutlet UILabel * ID; //用户ID
    IBOutlet UILabel * name; //用户中文昵称
    IBOutlet UILabel * posts; //发文数
    IBOutlet UILabel * medals; //勋章数
    IBOutlet UILabel * logins; //上站次数
    IBOutlet UILabel * life; //生命值
    IBOutlet UIImageView * avatar;//用户头像
    IBOutlet UIView * avatarBack;
    IBOutlet UILabel * role;
    IBOutlet UILabel * astro;
    IBOutlet UILabel * isOnline;
    
    id __unsafe_unretained mDelegate;
}
@property(nonatomic, strong)NSString * userString;
@property(nonatomic, strong)User * user;
@property(nonatomic, unsafe_unretained)id mDelegate;

-(IBAction)addFriend:(id)sender;
-(IBAction)sendMail:(id)sender;


@end
