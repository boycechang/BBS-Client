//
//  NotificationHeaderCell.m
//  BYR
//
//  Created by Boyce on 10/4/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "NotificationHeaderCell.h"
#import <Masonry.h>

@interface NotificationHeaderCell ()

@property (nonatomic, strong) UIView *contentBackground;
@property (nonatomic, strong) UILabel *sectionNameLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIButton *seeAllButton;

@end

@implementation NotificationHeaderCell

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
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(15, 15, 0, 15));
    }];
    
    [self.contentView addSubview:self.sectionNameLabel];
    [self.sectionNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(30);
        make.top.equalTo(self.contentView).offset(30);
        make.bottom.equalTo(self.contentView).offset(-8);
    }];
    
    [self.contentView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sectionNameLabel.mas_right).offset(5);
        make.bottom.equalTo(self.sectionNameLabel).offset(-2);
    }];
    
    [self.contentView addSubview:self.seeAllButton];
    [self.seeAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-30);
        make.centerY.equalTo(self.sectionNameLabel);
    }];
}

#pragma mark - actions

- (IBAction)seeAllClicked:(id)sender {
    if (self.loadMoreTapped) {
        self.loadMoreTapped();
    }
}

#pragma mark - public

- (void)updateWithSectionName:(NSString *)secionName
                        total:(NSInteger)count
                       unread:(NSInteger)unread {
    self.sectionNameLabel.text = secionName;
    
    if (unread != 0) {
        self.countLabel.text = [NSString stringWithFormat:@"(%li条未读)", unread];
    } else {
        self.countLabel.text = nil;
    }
}

#pragma mark - getter

- (UILabel *)sectionNameLabel {
    if (!_sectionNameLabel) {
        _sectionNameLabel = [UILabel new];
        _sectionNameLabel.adjustsFontForContentSizeCategory = YES;
        
        UIFontDescriptor *descriptor = [[UIFont preferredFontForTextStyle:UIFontTextStyleTitle3] fontDescriptor];
        UIFontDescriptor *newDescriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        _sectionNameLabel.font = [UIFont fontWithDescriptor:newDescriptor size:0];
    }
    return _sectionNameLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [UILabel new];
        _countLabel.adjustsFontForContentSizeCategory = YES;
        _countLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _countLabel.textColor = [UIColor secondaryLabelColor];
    }
    return _countLabel;
}

- (UIView *)contentBackground {
    if (!_contentBackground) {
        _contentBackground = [UIView new];
        _contentBackground.backgroundColor = [UIColor secondarySystemBackgroundColor];
        _contentBackground.layer.cornerRadius = 10.f;
        _contentBackground.layer.masksToBounds = YES;
        _contentBackground.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    }
    return _contentBackground;
}

- (UIButton *)seeAllButton {
    if (!_seeAllButton) {
        _seeAllButton = [UIButton new];
        [_seeAllButton setTitle:@"查看全部" forState:UIControlStateNormal];
        [_seeAllButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        _seeAllButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCallout];
        _seeAllButton.titleLabel.adjustsFontForContentSizeCategory = YES;
        [_seeAllButton addTarget:self action:@selector(seeAllClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seeAllButton;
}

@end


@interface NotificationFooterCell ()
@property (nonatomic, strong) UIView *contentBackground;
@end

@implementation NotificationFooterCell

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
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 15, 15, 15));
        make.height.mas_equalTo(15);
    }];
}

#pragma mark - getter

- (UIView *)contentBackground {
    if (!_contentBackground) {
        _contentBackground = [UIView new];
        _contentBackground.backgroundColor = [UIColor secondarySystemBackgroundColor];
        _contentBackground.layer.cornerRadius = 10.f;
        _contentBackground.layer.masksToBounds = YES;
        _contentBackground.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
    }
    return _contentBackground;
}


@end


