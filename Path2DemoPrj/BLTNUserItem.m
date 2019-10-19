//
//  BLTNUserItem.m
//  BYR
//
//  Created by Boyce on 10/19/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "BLTNUserItem.h"
#import <BLTNBoard-Swift.h>
#import <Masonry/Masonry.h>

@interface BLTNUserItem ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *loginStatusLabel;

@end

@implementation BLTNUserItem

- (instancetype)initWithTitle:(NSString *)title {
    self = [super initWithTitle:title];
    if (self) {
        self.actionButtonTitle = @"回复";
        self.alternativeButtonTitle = @"发站内信";
        self.requiresCloseButton = NO;
    }
    return self;
}

- (NSArray<UIView *> *)makeViewsUnderTitleWithInterfaceBuilder:(BLTNInterfaceBuilder *)interfaceBuilder {
    return @[
        [interfaceBuilder wrapView:self.headImageView width:@128 height:@128 position:BLTNViewPositionCentered],
        [interfaceBuilder wrapView:self.usernameLabel width:nil height:nil position:BLTNViewPositionPinnedToEdges],
        [interfaceBuilder wrapView:self.loginStatusLabel width:nil height:nil position:BLTNViewPositionPinnedToEdges],
    ];
}

#pragma mark - getter

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headImageView.layer.cornerRadius = 64;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.backgroundColor = [UIColor secondarySystemBackgroundColor];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.layer.borderColor = [UIColor separatorColor].CGColor;
        _headImageView.layer.borderWidth = 0.5;
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(128);
        }];
    }
    return _headImageView;
}

- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [UILabel new];
        _usernameLabel.numberOfLines = 0;
        _usernameLabel.adjustsFontForContentSizeCategory = YES;
        _usernameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        _usernameLabel.textColor = [UIColor labelColor];
        _usernameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _usernameLabel;
}

- (UILabel *)loginStatusLabel {
    if (!_loginStatusLabel) {
        _loginStatusLabel = [UILabel new];
        _loginStatusLabel.numberOfLines = 0;
        _loginStatusLabel.adjustsFontForContentSizeCategory = YES;
        _loginStatusLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _loginStatusLabel.textColor = [UIColor secondaryLabelColor];
        _loginStatusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _loginStatusLabel;
}

@end
