//
//  LoginViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CustomTableView.h"
#import "BoardsCellView.h"
#import "DataModel.h"
#import "WBUtil.h"
#import "BBSAPI.h"
#import "MyBBS.h"
#import "PostMailViewController.h"

@protocol LoginViewControllerDelegate <NSObject>
-(void)LoginSuccess;
@end

@interface LoginViewController : UIViewController
{
    IBOutlet UITextField * user;
    IBOutlet UITextField * pass;
    MBProgressHUD * HUD;
    UIToolbar *keyboardToolbar;
    id mDelegate;
    MyBBS * myBBS;
}
@property(nonatomic, assign)id mDelegate;

-(IBAction)back:(id)sender;
-(IBAction)login:(id)sender;
@end
