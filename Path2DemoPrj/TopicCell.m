//
//  TopicCell.m
//  BYR
//
//  Created by Boyce on 10/3/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "TopicCell.h"
#import <Masonry.h>
#import "Models.h"
#import "BBSAPI.h"
#import <UIImageView+WebCache.h>
#import "BYRUtil.h"

@interface TopicCell ()

@property (nonatomic, strong) UILabel *topicTitleLabel;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *usernameLabel;

@property (nonatomic, strong) UILabel *boardLabel;
@property (nonatomic, strong) UIImageView *indicatorImageView1;
@property (nonatomic, strong) UIImageView *indicatorImageView2;

@end

@implementation TopicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self.contentView addSubview:self.topicTitleLabel];
    
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.usernameLabel];
    
    [self.contentView addSubview:self.boardLabel];
    [self.contentView addSubview:self.indicatorImageView1];
    [self.contentView addSubview:self.indicatorImageView2];
 
    [self.topicTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.boardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topicTitleLabel.mas_bottom).offset(6);
        make.left.equalTo(self.topicTitleLabel);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    [self.boardLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.boardLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.boardLabel);
        make.top.equalTo(self.boardLabel.mas_bottom).offset(3);
        make.width.height.mas_equalTo(20);
    }];
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatarImageView);
        make.left.equalTo(self.avatarImageView.mas_right).offset(5);
    }];
    [self.usernameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [self.indicatorImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.boardLabel.mas_right).offset(8);
        make.top.equalTo(self.boardLabel);
        make.height.equalTo(self.usernameLabel).multipliedBy(1.2);
        make.width.equalTo(self.indicatorImageView1.mas_height);
    }];
    [self.indicatorImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.indicatorImageView1.mas_right).offset(8);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.indicatorImageView1);
        make.height.equalTo(self.indicatorImageView1);
        make.width.equalTo(self.indicatorImageView2.mas_height);
    }];
}


#pragma mark - public

- (void)updateWithTopic:(Topic *)topic hideBoard:(BOOL)hideBoard {
    [self updateWithTopic:topic];
    self.boardLabel.text = [NSString stringWithFormat:@"%li回复 · %@", topic.reply_count - 1, [NSString stringWithFormat:@"%@", [BYRUtil dateDescriptionFromTimestamp:topic.post_time]]];
}

- (void)updateWithTopic:(Topic *)topic {
    self.indicatorImageView1.image = nil;
    self.indicatorImageView2.image = nil;
    
    self.topicTitleLabel.text = topic.title;
    
    [self.avatarImageView sd_setImageWithURL:topic.user.face_url];
    self.usernameLabel.text = topic.user.id.length ? topic.user.id : @"匿名";
    
    self.boardLabel.text = [NSString stringWithFormat:@"%li回复 · %@ · %@", topic.reply_count, [NSString stringWithFormat:@"%@", [BYRUtil dateDescriptionFromTimestamp:topic.post_time]], topic.board_description];
    
    if (topic.flag.length) {
        self.indicatorImageView1.image = [UIImage systemImageNamed:@"bookmark"];
    }
    
    if (topic.has_attachment) {
        UIImageView *imageView = topic.flag.length ? self.indicatorImageView2 : self.indicatorImageView1;
        imageView.image = [UIImage systemImageNamed:@"paperclip"];
    }
}

#pragma mark - getter

- (UILabel *)topicTitleLabel {
    if (!_topicTitleLabel) {
        _topicTitleLabel = [UILabel new];
        _topicTitleLabel.numberOfLines = 0;
        _topicTitleLabel.adjustsFontForContentSizeCategory = YES;
        _topicTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    }
    return _topicTitleLabel;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.layer.cornerRadius = 10;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.borderColor = [UIColor separatorColor].CGColor;
        _avatarImageView.layer.borderWidth = 0.5;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _avatarImageView.hidden = YES;
    }
    return _avatarImageView;
}

- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [UILabel new];
        _usernameLabel.adjustsFontForContentSizeCategory = YES;
        _usernameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _usernameLabel.textColor = [UIColor secondaryLabelColor];
        
        _usernameLabel.hidden = YES;
    }
    return _usernameLabel;
}

- (UILabel *)boardLabel {
    if (!_boardLabel) {
        _boardLabel = [UILabel new];
        _boardLabel.numberOfLines = 0;
        _boardLabel.adjustsFontForContentSizeCategory = YES;
        _boardLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _boardLabel.textColor = [UIColor secondaryLabelColor];
    }
    return _boardLabel;
}


- (UIImageView *)indicatorImageView1 {
    if (!_indicatorImageView1) {
        _indicatorImageView1 = [UIImageView new];
        _indicatorImageView1.tintColor = [UIColor systemBlueColor];
        _indicatorImageView1.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _indicatorImageView1;
}


- (UIImageView *)indicatorImageView2 {
    if (!_indicatorImageView2) {
        _indicatorImageView2 = [UIImageView new];
        _indicatorImageView2.tintColor = [UIColor systemBlueColor];
        _indicatorImageView2.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _indicatorImageView2;
}

@end
