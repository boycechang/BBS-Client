//
//  NotificationCell.m
//  BYR
//
//  Created by Boyce on 10/4/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "NotificationCell.h"
#import "BoardCell.h"
#import "Models.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "BYRUtil.h"

@interface NotificationCell ()
@property (nonatomic, strong) UIView *contentBackground;

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *notificationContentLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UIView *indicatorView;
@end

@implementation NotificationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self.contentView addSubview:self.contentBackground];
    [self.contentBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    
    [self.contentView addSubview:self.usernameLabel];
    [self.contentView addSubview:self.indicatorView];
    
    [self.contentView addSubview:self.notificationContentLabel];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.dateLabel];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(30);
        make.height.width.mas_equalTo(40);
    }];
    
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView).offset(3);
        make.right.equalTo(self.headImageView.mas_left).offset(-3);
        make.width.height.mas_equalTo(7);
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.centerY.equalTo(self.headImageView).offset(-10);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.usernameLabel.mas_right).offset(5);
        make.bottom.equalTo(self.usernameLabel);
    }];
    
    [self.notificationContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameLabel.mas_bottom).offset(3);
        make.left.equalTo(self.usernameLabel);
        make.right.equalTo(self.contentView).offset(-30);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
}

#pragma mark - public

- (void)showPlainStyle:(BOOL)plainStyle {
    self.contentBackground.hidden = YES;
    
    _usernameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.contentView).offset(18);
        make.height.width.mas_equalTo(40);
    }];
    
    [self.notificationContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameLabel.mas_bottom).offset(3);
        make.left.equalTo(self.usernameLabel);
        make.right.equalTo(self.contentView).offset(-30);
        make.bottom.equalTo(self.contentView).offset(-18);
    }];
}

- (void)updateWithTopic:(Topic *)topic {
    self.usernameLabel.text = topic.user.id.length ? topic.user.id : @"匿名";
    self.notificationContentLabel.text = topic.title;
    self.dateLabel.text = [BYRUtil dateDescriptionFromTimestamp:topic.time];
    [self.headImageView sd_setImageWithURL:topic.user.face_url];
    self.indicatorView.hidden = topic.is_read;
}

- (void)updateWithMail:(Mail *)mail {
    self.usernameLabel.text = mail.user.id.length ? mail.user.id : @"匿名";
    self.notificationContentLabel.text = mail.title;
    self.dateLabel.text = [BYRUtil dateDescriptionFromTimestamp:mail.post_time];
    [self.headImageView sd_setImageWithURL:mail.user.face_url];
    self.indicatorView.hidden = mail.is_read;
}

#pragma mark - getter

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [UIImageView new];
        _headImageView.layer.cornerRadius = 20.f;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.borderColor = [UIColor separatorColor].CGColor;
        _headImageView.layer.borderWidth = 0.5;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headImageView;
}

- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [UILabel new];
        _usernameLabel.adjustsFontForContentSizeCategory = YES;
        
        UIFontDescriptor *descriptor = [[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote] fontDescriptor];
        UIFontDescriptor *newDescriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        _usernameLabel.font = [UIFont fontWithDescriptor:newDescriptor size:0];
    }
    return _usernameLabel;
}

- (UILabel *)notificationContentLabel {
    if (!_notificationContentLabel) {
        _notificationContentLabel = [UILabel new];
        _notificationContentLabel.numberOfLines = 0;
        _notificationContentLabel.adjustsFontForContentSizeCategory = YES;
        _notificationContentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _notificationContentLabel.textColor = [UIColor secondaryLabelColor];
    }
    return _notificationContentLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.numberOfLines = 0;
        _dateLabel.adjustsFontForContentSizeCategory = YES;
        _dateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        _dateLabel.textColor = [UIColor secondaryLabelColor];
    }
    return _dateLabel;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [UIView new];
        _indicatorView.backgroundColor = [UIColor systemBlueColor];
        _indicatorView.layer.cornerRadius = 3.5;
        _indicatorView.layer.masksToBounds = YES;
    }
    return _indicatorView;
}

- (UIView *)contentBackground {
    if (!_contentBackground) {
        _contentBackground = [UIView new];
        _contentBackground.backgroundColor = [UIColor secondarySystemBackgroundColor];
    }
    return _contentBackground;
}

@end
