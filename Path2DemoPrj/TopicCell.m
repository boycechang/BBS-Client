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

@interface TopicCell ()

@property (nonatomic, strong) UILabel *topicTitleLabel;
@property (nonatomic, strong) UILabel *boardLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIImageView *genderImageView;
@property (nonatomic, strong) UILabel *postCountLabel;

@end

@implementation TopicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self.contentView addSubview:self.topicTitleLabel];
    
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.usernameLabel];
    [self.contentView addSubview:self.genderImageView];
    [self.contentView addSubview:self.postCountLabel];
    
    [self.contentView addSubview:self.boardLabel];
    [self.contentView addSubview:self.dateLabel];
    
    [self.topicTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topicTitleLabel);
        make.centerY.equalTo(self.usernameLabel);
        make.height.width.mas_equalTo(20);
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(5);
        make.top.equalTo(self.topicTitleLabel.mas_bottom).offset(15);
    }];
    [self.usernameLabel setContentHuggingPriority:UILayoutPriorityRequired
                                          forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.genderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.usernameLabel.mas_right).offset(2);
        make.centerY.equalTo(self.usernameLabel);
        make.height.width.mas_equalTo(15);
    }];
    
    [self.postCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.genderImageView.mas_right).offset(5);
        make.centerY.equalTo(self.usernameLabel);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.boardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView);
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(5);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.boardLabel);
        make.top.equalTo(self.boardLabel.mas_bottom).offset(5);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}


#pragma mark - public

- (void)updateWithTopic:(Topic *)topic {
    self.topicTitleLabel.text = topic.title;
    
    self.usernameLabel.text = topic.user.user_name;
    self.postCountLabel.text = [NSString stringWithFormat:@"%li文章", topic.user.post_count];
    
    [self.avatarImageView sd_setImageWithURL:topic.user.face_url];
    if ([topic.user.gender isEqualToString:@"f"]) {
        self.genderImageView.image = [UIImage systemImageNamed:@"f.circle.fill"];
        self.genderImageView.tintColor = [UIColor colorNamed:@"Pink"];
    } else {
        self.genderImageView.image = [UIImage systemImageNamed:@"m.circle.fill"];
        self.genderImageView.tintColor = [UIColor colorNamed:@"MainTheme"];
    }
    
    if (!topic.user.is_online) {
        self.genderImageView.tintColor = [UIColor colorNamed:@"Footnote"];
    }
    
    self.boardLabel.text = [NSString stringWithFormat:@"%li回复 · %@", topic.reply_count, topic.board_description];
    self.dateLabel.text = [NSString stringWithFormat:@"%@", [self getDateDesc:topic.post_time]];
}

- (NSString *)getDateDesc:(NSTimeInterval)timeinterval {
    double ti = [[NSDate date] timeIntervalSince1970] - timeinterval;
    
    if (ti < 60) {
        return @"刚刚";
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%d分钟前", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return [NSString stringWithFormat:@"%d小时前", diff];
    } else if (ti < 259200) {
        int diff = round(ti / 60 / 60 / 24);
        return [NSString stringWithFormat:@"%d天前", diff];
    } else if (ti < 15552000) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日"];
        NSString * lastloginstring = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeinterval]];
        return lastloginstring;
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        NSString * lastloginstring = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeinterval]];
        return lastloginstring;
    }
}

#pragma mark - getter

- (UILabel *)topicTitleLabel {
    if (!_topicTitleLabel) {
        _topicTitleLabel = [UILabel new];
        _topicTitleLabel.numberOfLines = 0;
        _topicTitleLabel.adjustsFontForContentSizeCategory = YES;
        _topicTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
        _topicTitleLabel.textColor = [UIColor colorNamed:@"Title3"];
    }
    return _topicTitleLabel;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.layer.cornerRadius = 10.f;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.borderColor = [UIColor colorNamed:@"Footnote"].CGColor;
        _avatarImageView.layer.borderWidth = 0.5;
    }
    return _avatarImageView;
}

- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [UILabel new];
        _usernameLabel.adjustsFontForContentSizeCategory = YES;
        
        UIFontDescriptor *descriptor = [[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote] fontDescriptor];
        UIFontDescriptor *newDescriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        _usernameLabel.font = [UIFont fontWithDescriptor:newDescriptor size:0];;
    }
    return _usernameLabel;
}

- (UIImageView *)genderImageView {
    if (!_genderImageView) {
        _genderImageView = [UIImageView new];
    }
    return _genderImageView;
}

- (UILabel *)postCountLabel {
    if (!_postCountLabel) {
        _postCountLabel = [UILabel new];
        _postCountLabel.adjustsFontForContentSizeCategory = YES;
        _postCountLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _postCountLabel.textColor = [UIColor colorNamed:@"Footnote"];
    }
    return _postCountLabel;
}


- (UILabel *)boardLabel {
    if (!_boardLabel) {
        _boardLabel = [UILabel new];
        _boardLabel.adjustsFontForContentSizeCategory = YES;
        _boardLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _boardLabel.textColor = [UIColor colorNamed:@"Footnote"];
    }
    return _boardLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.adjustsFontForContentSizeCategory = YES;
        _dateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        _dateLabel.textColor = [UIColor colorNamed:@"Footnote"];
    }
    return _dateLabel;
}

@end
