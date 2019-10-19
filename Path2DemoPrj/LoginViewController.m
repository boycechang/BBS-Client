//
//  LoginViewController.m
//  BYR
//
//  Created by Boyce on 10/5/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "LoginViewController.h"
#import <Masonry.h>
#import "LoginInfoView.h"
#import "ProtocolViewController.h"
#import "BYRSession.h"
#import <MBProgressHUD.h>

@interface LoginViewController ()

@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) LoginInfoView *loginInfoView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"byr_icon"]];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = logoImageView;
    
    self.loginInfoView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.contentView addSubview:self.loginInfoView];
}

#pragma mark - getter

- (UIScrollView *)contentView {
    if (!_contentView) {
        _contentView = [UIScrollView new];
        _contentView.backgroundColor = [UIColor systemBackgroundColor];
        _contentView.alwaysBounceVertical = YES;
        _contentView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    }
    return _contentView;
}

- (LoginInfoView *)loginInfoView {
    if (!_loginInfoView) {
        _loginInfoView = [LoginInfoView new];
        
        __weak typeof (self) wself = self;
        _loginInfoView.infoTapped = ^{
            [wself.navigationController pushViewController:[ProtocolViewController new] animated:YES];
        };
        
        _loginInfoView.loginTapped = ^(NSString * _Nonnull username, NSString * _Nonnull password) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:wself.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.label.text = @"登录中";
            [[BYRSession sharedInstance] logInWithUsername:username password:password completion:^(BOOL success, NSError * _Nonnull error) {
                [hud hideAnimated:YES];
                if (success) {
                    
                }
            }];
        };
    }
    return _loginInfoView;
}

@end
