//
//  PostMailViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/8/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AddPostUserViewController.h"
#import "BBSAPI.h"

@protocol PostMailViewControllerDelegate <NSObject>
-(void)dismissPostMailView;
@end


@interface PostMailViewController : UIViewController
{
    IBOutlet UILabel * topTitleLabel;
    
    IBOutlet UITextField * postUser;
    IBOutlet UIButton * addUserButton;
    IBOutlet UIButton * sendButton;
    
    IBOutlet UITextField * postTitle;
    IBOutlet UILabel * postTitleCount;
    
    IBOutlet UIImageView * postBack;
    IBOutlet UITextView * postContent;
    
    MBProgressHUD * HUD;
    Mail * rootMail;
    NSString * sentToUser;
    int postType; // 发表类型，0发新邮件，1回复邮件，2已指定发件人
    MyBBS * myBBS;
    id __unsafe_unretained mDelegate;
}
@property(nonatomic, strong)Mail * rootMail;
@property(nonatomic, strong)NSString * sentToUser;
@property(nonatomic, assign)int postType;
@property(nonatomic, unsafe_unretained)id mDelegate;

-(IBAction)cancel:(id)sender;
-(IBAction)sent:(id)sender;
@end
