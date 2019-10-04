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

@interface NotificationCell ()
@property (nonatomic, strong) UIView *contentBackground;

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *notificationContentLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UIImageView *indicatorImageView;
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
    [self.contentView addSubview:self.indicatorImageView];
    
    [self.contentView addSubview:self.notificationContentLabel];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.dateLabel];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(7.5);
        make.left.equalTo(self.contentView).offset(30);
        make.height.width.mas_equalTo(40);
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(5);
        make.centerY.equalTo(self.headImageView).offset(-10);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.usernameLabel.mas_right).offset(5);
        make.centerY.equalTo(self.usernameLabel);
    }];
    
    [self.indicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-30);
        make.width.height.mas_equalTo(5);
    }];
    
    [self.notificationContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.usernameLabel);
        make.right.equalTo(self.contentView).offset(-30);
        make.bottom.equalTo(self.contentView).offset(-7.5);
    }];
}

- (void)updateWithTopic:(Topic *)topic {
    self.usernameLabel.text = topic.user.user_name.length ? topic.user.user_name : @"匿名";
    self.notificationContentLabel.text = topic.title;
    self.dateLabel.text = @"1小时前";
    [self.headImageView sd_setImageWithURL:topic.user.face_url];
    self.indicatorImageView.hidden = topic.is_read;
}

#pragma mark - getter

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [UIImageView new];
        _headImageView.layer.cornerRadius = 20.f;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.borderColor = [UIColor colorNamed:@"Footnote"].CGColor;
        _headImageView.layer.borderWidth = 0.5;
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
        _notificationContentLabel.textColor = [UIColor colorNamed:@"Footnote"];
    }
    return _notificationContentLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.numberOfLines = 0;
        _dateLabel.adjustsFontForContentSizeCategory = YES;
        
        UIFont *caption2 = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        UIFont *scaledCaption2 = [caption2 fontWithSize:caption2.pointSize * 0.9];
        _dateLabel.font = scaledCaption2;
        _dateLabel.textColor = [UIColor colorNamed:@"Footnote"];
    }
    return _dateLabel;
}

- (UIImageView *)indicatorImageView {
    if (!_indicatorImageView) {
        _indicatorImageView = [UIImageView new];
        _indicatorImageView.image = [UIImage systemImageNamed:@"star.fill"];
        _indicatorImageView.tintColor = [UIColor colorNamed:@"MainTheme"];
    }
    return _indicatorImageView;
}

- (UIView *)contentBackground {
    if (!_contentBackground) {
        _contentBackground = [UIView new];
        _contentBackground.backgroundColor = [UIColor colorNamed:@"Background-Light"];
    }
    return _contentBackground;
}

@end
