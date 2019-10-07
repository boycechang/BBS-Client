//
//  ThreadCell.m
//  BYR
//
//  Created by Boyce on 10/3/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "ThreadCell.h"
#import <Masonry.h>
#import "Models.h"
#import "BBSAPI.h"
#import <UIImageView+WebCache.h>
#import <YYText.h>
#import "BYRBBCodeToYYConverter.h"
#import "BYRUtil.h"

@interface ThreadCell ()

@property (nonatomic, strong) UILabel *topicTitleLabel;
@property (nonatomic, strong) YYLabel *contentTextView;

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *usernameLabel;

@property (nonatomic, strong) UILabel *boardLabel;
@property (nonatomic, strong) UILabel *replyCountLabel;

@property (nonatomic, strong) Topic *topic;

@end

@implementation ThreadCell

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
    [self.contentView addSubview:self.contentTextView];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.usernameLabel];
    
    [self.contentView addSubview:self.boardLabel];
    [self.contentView addSubview:self.replyCountLabel];
    
    [self.topicTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topicTitleLabel.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.width.height.mas_equalTo(40);
    }];
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView).offset(3);
        make.left.equalTo(self.headImageView.mas_right).offset(8);
    }];
    [self.boardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameLabel.mas_bottom).offset(3);
        make.left.equalTo(self.usernameLabel);
    }];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    [self.contentTextView setContentHuggingPriority:UILayoutPriorityRequired
                                            forAxis:UILayoutConstraintAxisVertical];
    
    [self.replyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTextView.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
}


#pragma mark - public

- (void)refreshContent {
    if (!self.topic.attributedContentCache) {
        NSAttributedString *richText = [[BYRBBCodeToYYConverter sharedInstance] parseBBCode:self.topic.content attachemtns:self.topic.attachments containerWidth:self.frame.size.width - 30];
        self.topic.attributedContentCache = richText;
    }
    self.contentTextView.preferredMaxLayoutWidth = self.frame.size.width - 30;
    self.contentTextView.attributedText = self.topic.attributedContentCache;
}

- (void)updateWithTopic:(Topic *)topic {
    self.topic = topic;
    
    if (!topic.attributedContentCache) {
        NSAttributedString *richText = [[BYRBBCodeToYYConverter sharedInstance] parseBBCode:topic.content attachemtns:topic.attachments containerWidth:self.frame.size.width - 30];
        topic.attributedContentCache = richText;
    }
    self.contentTextView.preferredMaxLayoutWidth = self.frame.size.width - 30;
    self.contentTextView.attributedText = topic.attributedContentCache;
    
    self.topicTitleLabel.text = topic.title;
    [self.headImageView sd_setImageWithURL:topic.user.face_url];
    self.usernameLabel.text = topic.user.id.length ? topic.user.id : @"匿名";
    
    self.boardLabel.text = [NSString stringWithFormat:@"%@ · %@", @"楼主" ,[BYRUtil fullDateDescriptionFromTimestamp:topic.post_time]];
    
    if (topic.reply_count == 0) {
        self.replyCountLabel.text = @"没有回复";
    } else {
        self.replyCountLabel.text = [NSString stringWithFormat:@"全部 %li 条回复", topic.reply_count];
    }
}

#pragma mark - getter

- (UILabel *)topicTitleLabel {
    if (!_topicTitleLabel) {
        _topicTitleLabel = [UILabel new];
        _topicTitleLabel.numberOfLines = 0;
        _topicTitleLabel.adjustsFontForContentSizeCategory = YES;
        _topicTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
    }
    return _topicTitleLabel;
}

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
        _usernameLabel.textColor = [UIColor labelColor];
    }
    return _usernameLabel;
}

- (UILabel *)boardLabel {
    if (!_boardLabel) {
        _boardLabel = [UILabel new];
        _boardLabel.adjustsFontForContentSizeCategory = YES;
        _boardLabel.font =[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _boardLabel.textColor = [UIColor secondaryLabelColor];
    }
    return _boardLabel;
}

- (UILabel *)replyCountLabel {
    if (!_replyCountLabel) {
        _replyCountLabel = [UILabel new];
        _replyCountLabel.adjustsFontForContentSizeCategory = YES;
        _replyCountLabel.font =[UIFont preferredFontForTextStyle:UIFontTextStyleCallout];
        _replyCountLabel.textColor = [UIColor secondaryLabelColor];
    }
    return _replyCountLabel;
}

- (YYLabel *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [YYLabel new];
        _contentTextView.numberOfLines = 0;
        _contentTextView.textVerticalAlignment = YYTextVerticalAlignmentTop;
        _contentTextView.highlightTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            
        };
    }
    return _contentTextView;
}

@end
