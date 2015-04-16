//
//  AccountInfoHeaderView.h
//  佳邮
//
//  Created by Boyce on 6/1/14.
//  Copyright (c) 2014 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccountInfoHeaderViewDelegate <NSObject>
- (void)loginButtonClicked;
- (void)favButtonClicked;
- (void)mailButtonClicked;
- (void)notificationButtonClicked;
@end

@interface AccountInfoHeaderView : UIView
{
    IBOutlet UIImageView * avatarImageView;
    IBOutlet UIButton * nameButton;
    IBOutlet UIButton * favButton;
    IBOutlet UIButton * mailButton;
    IBOutlet UIButton * notifButton;
    IBOutlet UIImageView * notificatonInageView;
}
@property (nonatomic, weak)id<AccountInfoHeaderViewDelegate>delegate;

- (IBAction)nameButtonClicked:(id)sender;
- (void)refresh;

@end
