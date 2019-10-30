//
//  VoteOptionCell.m
//  BYR
//
//  Created by Boyce on 10/30/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "VoteOptionCell.h"
#import <YLProgressBar/YLProgressBar.h>
#import <Masonry.h>
#import "Models.h"
#import "BBSAPI.h"
#import "BYRUtil.h"

@interface VoteOptionCell ()

@property (nonatomic, strong) UIImageView *checkImageView;
@property (nonatomic, strong) YLProgressBar *progressBar;
@property (nonatomic, strong) UILabel *optionTitleLabel;
@property (nonatomic, strong) UILabel *percentLabel;

@property (nonatomic, strong) Vote *vote;
@property (nonatomic, strong) VoteOption *voteOption;

@end

@implementation VoteOptionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor tertiarySystemBackgroundColor];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self.contentView addSubview:self.progressBar];
    
    [self.contentView addSubview:self.optionTitleLabel];
    [self.contentView addSubview:self.checkImageView];
    
    [self.contentView addSubview:self.percentLabel];
    
    [self.progressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(3);
        make.bottom.equalTo(self.contentView).offset(-3);
        make.height.greaterThanOrEqualTo(@40);
    }];

    [self.optionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.bottom.equalTo(self.contentView).offset(-8);
        make.left.equalTo(self.contentView).offset(15);
        make.right.lessThanOrEqualTo(self.percentLabel.mas_left).offset(-50);
    }];
    [self.optionTitleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.optionTitleLabel.mas_right).offset(5);
        make.centerY.equalTo(self.optionTitleLabel);
        make.width.height.mas_equalTo(20);
    }];

    [self.percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.bottom.equalTo(self.contentView).offset(-8);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    [self.percentLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)updateWithVote:(Vote *)vote option:(VoteOption *)option {
    self.vote = vote;
    self.voteOption = option;
    
    CGFloat percent = vote.vote_count == 0 ? 0 : (CGFloat)option.num / (CGFloat)vote.vote_count;
    [self.progressBar setProgress:percent];
    self.optionTitleLabel.text = option.label;
    self.percentLabel.text = [NSString stringWithFormat:@"%2.0f%%", percent * 100];
    
    if ([self.vote.voted containsObject: [NSString stringWithFormat:@"%i", option.viid]]) {
        self.checkImageView.hidden = NO;
        self.checkImageView.tintColor = [UIColor labelColor];
    } else {
        self.checkImageView.hidden = YES;
    }
}

- (void)selectOption:(BOOL)select {
    if (self.vote.voted) {
        return;
    }
    
    self.checkImageView.hidden = !select;
    self.checkImageView.tintColor = [UIColor systemBlueColor];
}

#pragma mark - getter

- (YLProgressBar *)progressBar {
    if (!_progressBar) {
        _progressBar = [YLProgressBar new];
        _progressBar.type = YLProgressBarTypeFlat;
        _progressBar.trackTintColor = [UIColor tertiarySystemBackgroundColor];
        _progressBar.progressTintColor = [UIColor secondarySystemFillColor];
        _progressBar.uniformTintColor = YES;
        _progressBar.progressStretch = NO;
        _progressBar.hideStripes = YES;
        _progressBar.hideGloss = YES;
    }
    return _progressBar;
}

- (UILabel *)optionTitleLabel {
    if (!_optionTitleLabel) {
        _optionTitleLabel = [UILabel new];
        _optionTitleLabel.numberOfLines = 0;
        _optionTitleLabel.adjustsFontForContentSizeCategory = YES;
        _optionTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _optionTitleLabel.textColor = [UIColor labelColor];
    }
    return _optionTitleLabel;
}

- (UIImageView *)checkImageView {
    if (!_checkImageView) {
        _checkImageView = [UIImageView new];
        _checkImageView.image = [UIImage systemImageNamed:@"checkmark.circle"];
        _checkImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _checkImageView;
}

- (UILabel *)percentLabel {
    if (!_percentLabel) {
        _percentLabel = [UILabel new];
        _percentLabel.adjustsFontForContentSizeCategory = YES;
        _percentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _percentLabel.textColor = [UIColor labelColor];
    }
    return _percentLabel;
}

@end
