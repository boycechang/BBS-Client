//
//  ThreadCommentCell.m
//  BYR
//
//  Created by Boyce on 10/7/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "ThreadCommentCell.h"
#import "ThreadCell.h"
#import <Masonry.h>
#import "Models.h"
#import "BBSAPI.h"
#import <UIImageView+WebCache.h>
#import <YYText.h>
#import "BYRBBCodeToYYConverter.h"
#import "BYRUtil.h"

@interface ThreadCommentCell ()

@property (nonatomic, strong) YYLabel *contentTextView;

@property (nonatomic, strong) UILabel *authorTagLabel;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *usernameLabel;

@property (nonatomic, strong) UILabel *boardLabel;

@property (nonatomic, assign) NSInteger position;
@property (nonatomic, strong) Topic *topic;

@end

@implementation ThreadCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self.contentView addSubview:self.contentTextView];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.usernameLabel];
    [self.contentView addSubview:self.authorTagLabel];
    
    [self.contentView addSubview:self.boardLabel];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(15);
        make.width.height.mas_equalTo(30);
    }];
    [self.authorTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.equalTo(self.headImageView);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(15);
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView).offset(0);
        make.left.equalTo(self.headImageView.mas_right).offset(8);
    }];
    [self.boardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameLabel.mas_bottom).offset(2);
        make.left.equalTo(self.usernameLabel);
    }];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.boardLabel.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    [self.contentTextView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.contentTextView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - public

- (void)updateWithTopic:(Topic *)topic
               position:(NSInteger)position
              converter:(BYRBBCodeToYYConverter *)converter {
    self.position = position;
    self.topic = topic;
    
    if (!topic.attributedContentCache) {
        NSAttributedString *richText = [converter parseBBCode:topic.content attachemtns:topic.attachments containerWidth:self.frame.size.width - 30];
        topic.attributedContentCache = richText;
    }
    self.contentTextView.preferredMaxLayoutWidth = self.frame.size.width - 30;
    self.contentTextView.attributedText = topic.attributedContentCache;
    
    [self.headImageView sd_setImageWithURL:topic.user.face_url];
    self.usernameLabel.text = topic.user.id.length ? topic.user.id : @"匿名";
    
    self.boardLabel.text = [NSString stringWithFormat:@"%@ · %@", [NSString stringWithFormat:@"%li楼", position] ,[BYRUtil fullDateDescriptionFromTimestamp:topic.post_time]];
}

- (void)showAuthorTag:(BOOL)show {
    self.authorTagLabel.hidden = !show;
}

- (void)showHighlightAnimation {
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.backgroundColor = [[UIColor systemYellowColor] colorWithAlphaComponent:0.1];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0.5 options:kNilOptions animations:^{
            self.contentView.backgroundColor = [UIColor systemBackgroundColor];
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (IBAction)headImageViewClicked:(id)sender {
    if (self.cellUserTapped) {
        self.cellUserTapped(self.topic);
    }
}

#pragma mark - getter

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [UIImageView new];
        _headImageView.layer.cornerRadius = 15.f;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.borderColor = [UIColor separatorColor].CGColor;
        _headImageView.layer.borderWidth = 0.5;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageViewClicked:)];
        [_headImageView addGestureRecognizer:tap];
        _headImageView.userInteractionEnabled = YES;
    }
    return _headImageView;
}

- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [UILabel new];
        _usernameLabel.adjustsFontForContentSizeCategory = YES;
        _usernameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _usernameLabel.textColor = [UIColor labelColor];
    }
    return _usernameLabel;
}

- (UILabel *)authorTagLabel {
    if (!_authorTagLabel) {
        _authorTagLabel = [UILabel new];
        _authorTagLabel.text = @"楼主";
        _authorTagLabel.adjustsFontForContentSizeCategory = YES;
        _authorTagLabel.font = [UIFont systemFontOfSize:8];
        _authorTagLabel.textColor = [UIColor whiteColor];
        _authorTagLabel.backgroundColor = [UIColor systemBlueColor];
        _authorTagLabel.textAlignment = NSTextAlignmentCenter;
        
        _authorTagLabel.layer.cornerRadius = 4;
        _authorTagLabel.layer.masksToBounds = YES;
    }
    return _authorTagLabel;
}

- (UILabel *)boardLabel {
    if (!_boardLabel) {
        _boardLabel = [UILabel new];
        _boardLabel.adjustsFontForContentSizeCategory = YES;
        _boardLabel.font =[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        _boardLabel.textColor = [UIColor secondaryLabelColor];
    }
    return _boardLabel;
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
