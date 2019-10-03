//
//  AccountInfoHeaderView.m
//
//  Created by Boyce on 6/1/14.
//  Copyright (c) 2014 Ethan. All rights reserved.
//

#import "AccountInfoHeaderView.h"
#import "DataModel.h"
#import "AppDelegate.h"
#import <UIImageView+WebCache.h>

@implementation AccountInfoHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    avatarImageView.layer.cornerRadius = 45.0f;
    avatarImageView.clipsToBounds = YES;
    
    self.layer.cornerRadius = 20.0f;
    self.clipsToBounds = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameButtonClicked:)];
    tap.numberOfTapsRequired = 1;
    [avatarImageView addGestureRecognizer:tap];
}

- (void)refresh
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.myBBS.mySelf.id == nil) {
        [nameButton setTitle:@"立即登录" forState:UIControlStateNormal];
        [nameButton setEnabled:YES];
        [avatarImageView setUserInteractionEnabled:YES];
        [favButton setEnabled:NO];
        [mailButton setEnabled:NO];
        [notifButton setEnabled:NO];
        [avatarImageView setImage:[UIImage imageNamed:@"LoginAvatar"]];
    } else {
        [nameButton setTitle:appDelegate.myBBS.mySelf.id forState:UIControlStateNormal];
        [nameButton setEnabled:NO];
        [avatarImageView setUserInteractionEnabled:NO];
        [favButton setEnabled:YES];
        [mailButton setEnabled:YES];
        [notifButton setEnabled:YES];
        [avatarImageView sd_setImageWithURL:appDelegate.myBBS.mySelf.face_url];
    }
    
    if (appDelegate.myBBS.notificationCount == 0) {
        [notifButton setImage:[UIImage imageNamed:@"notificationButton"] forState:UIControlStateNormal];
    } else {
        [notifButton setImage:[UIImage imageNamed:@"notificationButton2"] forState:UIControlStateNormal];
        CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        
        //设置抖动幅度
        shake.fromValue = [NSNumber numberWithFloat:-0.3];
        
        shake.toValue = [NSNumber numberWithFloat:+0.3];
        
        shake.duration = 0.1;
        
        shake.autoreverses = YES;
        
        shake.repeatCount = 10;
        
        [notifButton.layer addAnimation:shake forKey:@"imageView"];
        notifButton.alpha = 1.0;
        
        [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:nil];
        
    }
}

- (IBAction)nameButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(loginButtonClicked)]) {
        [self.delegate loginButtonClicked];
    }
}

- (IBAction)favButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(favButtonClicked)]) {
        [self.delegate favButtonClicked];
    }
}

- (IBAction)mailButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(mailButtonClicked)]) {
        [self.delegate mailButtonClicked];
    }
}

- (IBAction)notificationButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(notificationButtonClicked)]) {
        [self.delegate notificationButtonClicked];
    }
}


@end
