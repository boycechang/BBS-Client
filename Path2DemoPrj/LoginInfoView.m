//
//  LoginInfoView.m
//  BYR
//
//  Created by Boyce on 10/5/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "LoginInfoView.h"
#import <Masonry.h>

@interface LoginInfoView () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIButton *infoButton;

@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *loginButton;

@end


@implementation LoginInfoView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIView *line1 = [UIView new];
    UIView *line2 = [UIView new];
    line1.backgroundColor = [UIColor secondarySystemFillColor];
    line2.backgroundColor = [UIColor secondarySystemFillColor];
    
    [self addSubview:self.infoLabel];
    [self addSubview:self.infoButton];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self).offset(15);
    }];
    [self.infoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.infoLabel);
        make.left.equalTo(self.infoLabel.mas_right).offset(2);
    }];
    
    
    [self addSubview:self.usernameField];
    [self addSubview:self.passwordField];
    [self addSubview:line1];
    [self addSubview:line2];
    [self addSubview:self.loginButton];
    
    [self.usernameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoLabel.mas_bottom).offset(25);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameField.mas_bottom).offset(10);
        make.left.right.equalTo(self.usernameField);
        make.height.mas_equalTo(1);
    }];
    
    
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(15);
        make.left.right.equalTo(self.usernameField);
    }];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordField.mas_bottom).offset(10);
        make.left.right.equalTo(self.passwordField);
        make.height.mas_equalTo(1);
    }];
    
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom).offset(20);
        make.left.right.equalTo(self.passwordField);
    }];
}

- (IBAction)infoClicked:(id)sender {
    if (self.infoTapped) {
        self.infoTapped();
    }
}

- (IBAction)loginClicked:(id)sender {
    if (self.loginTapped) {
        self.loginTapped(self.usernameField.text, self.passwordField.text);
    }
}

- (IBAction)textFieldDidChange:(id)sender {
    if (self.tokenChanged) {
        self.tokenChanged(self.usernameField.text, self.passwordField.text);
    }
    
    if (self.usernameField.text.length != 0 &&
        self.passwordField.text.length != 0) {
        self.loginButton.enabled = YES;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.usernameField.isFirstResponder) {
        [self.passwordField becomeFirstResponder];
    } else {
        [self.passwordField resignFirstResponder];
    }
    return NO;
}

#pragma mark - getter

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [UILabel new];
        _infoLabel.adjustsFontForContentSizeCategory = YES;
        _infoLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        _infoLabel.textColor = [UIColor secondaryLabelColor];
        _infoLabel.text = @"使用前请查看";
    }
    return _infoLabel;
}

- (UIButton *)infoButton {
    if (!_infoButton) {
        _infoButton = [UIButton new];
        _infoButton.titleLabel.adjustsFontForContentSizeCategory = YES;
        _infoButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        [_infoButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        [_infoButton setTitle:@"论坛管理办法" forState:UIControlStateNormal];
        [_infoButton addTarget:self action:@selector(infoClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _infoButton;
}

- (UITextField *)usernameField {
    if (!_usernameField) {
        _usernameField = [UITextField new];
        _usernameField.textContentType = UITextContentTypeUsername;
        _usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _usernameField.tintColor = [UIColor systemBlueColor];
        _usernameField.placeholder = @"用户名";
        _usernameField.adjustsFontForContentSizeCategory = YES;
        _usernameField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _usernameField.delegate = self;
        _usernameField.keyboardType = UIKeyboardTypeASCIICapable;
        [_usernameField addTarget:self action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    }
    return _usernameField;
}

- (UITextField *)passwordField {
    if (!_passwordField) {
        _passwordField = [UITextField new];
        _passwordField.textContentType = UITextContentTypePassword;
        _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordField.tintColor = [UIColor systemBlueColor];
        _passwordField.secureTextEntry = YES;
        _passwordField.placeholder = @"密码";
        _passwordField.delegate = self;
        _passwordField.adjustsFontForContentSizeCategory = YES;
        _passwordField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        
        [_passwordField addTarget:self action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordField;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton new];
        _loginButton.backgroundColor = [UIColor tertiarySystemFillColor];
        _loginButton.layer.cornerRadius = 10.f;
        _loginButton.layer.masksToBounds = YES;
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        [_loginButton setTitleColor:[[UIColor systemBlueColor] colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
        [_loginButton setTitleColor:[[UIColor systemBlueColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        
        _loginButton.titleLabel.adjustsFontForContentSizeCategory = YES;
        _loginButton.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
        _loginButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        _loginButton.enabled = NO;
        
        [_loginButton addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

@end
