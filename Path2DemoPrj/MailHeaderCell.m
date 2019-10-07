//
//  MailHeaderCell.m
//  BYR
//
//  Created by Boyce on 10/6/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "MailHeaderCell.h"
#import "BoardCell.h"
#import "Models.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "BYRUtil.h"

@interface MailHeaderCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *mailTitleLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation MailHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.usernameLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.mailTitleLabel];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.height.width.mas_equalTo(40);
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.centerY.equalTo(self.headImageView).offset(-10);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.usernameLabel.mas_right).offset(5);
        make.centerY.equalTo(self.usernameLabel);
    }];
    
    [self.mailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameLabel.mas_bottom).offset(3);
        make.left.equalTo(self.usernameLabel);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor secondarySystemFillColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - public

- (void)updateWithMail:(Mail *)mail {
    self.usernameLabel.text = mail.user.id.length ? mail.user.id : @"匿名";
    self.mailTitleLabel.text = mail.title;
    self.dateLabel.text = [BYRUtil dateDescriptionFromTimestamp:mail.post_time];
    [self.headImageView sd_setImageWithURL:mail.user.face_url];
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
        _usernameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    }
    return _usernameLabel;
}

- (UILabel *)mailTitleLabel {
    if (!_mailTitleLabel) {
        _mailTitleLabel = [UILabel new];
        _mailTitleLabel.numberOfLines = 0;
        _mailTitleLabel.adjustsFontForContentSizeCategory = YES;
        _mailTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    }
    return _mailTitleLabel;
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

@end
