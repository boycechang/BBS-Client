//
//  VoteCell.m
//  BYR
//
//  Created by Boyce on 10/28/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "VoteCell.h"
#import <Masonry.h>
#import "Models.h"
#import "BBSAPI.h"
#import <UIImageView+WebCache.h>
#import "BYRUtil.h"

@interface VoteCell ()

@property (nonatomic, strong) UILabel *topicTitleLabel;
@property (nonatomic, strong) UILabel *voteCountLabel;
@property (nonatomic, strong) UILabel *voteCountLabel2;

@end

@implementation VoteCell

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
    
    [self.contentView addSubview:self.voteCountLabel];
    [self.contentView addSubview:self.voteCountLabel2];
    
    [self.topicTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.voteCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topicTitleLabel.mas_bottom).offset(8);
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    [self.voteCountLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.voteCountLabel);
        make.left.equalTo(self.voteCountLabel.mas_right).offset(2);
    }];
}

#pragma mark - public

- (void)updateWithVote:(Vote *)vote {
    self.topicTitleLabel.text = vote.title;
    self.voteCountLabel.text = [NSString stringWithFormat:@"%i", vote.user_count];
}

#pragma mark - getter

- (UILabel *)topicTitleLabel {
    if (!_topicTitleLabel) {
        _topicTitleLabel = [UILabel new];
        _topicTitleLabel.numberOfLines = 0;
        _topicTitleLabel.adjustsFontForContentSizeCategory = YES;
        _topicTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return _topicTitleLabel;
}

- (UILabel *)voteCountLabel {
    if (!_voteCountLabel) {
        _voteCountLabel = [UILabel new];
        _voteCountLabel.adjustsFontForContentSizeCategory = YES;
        
        UIFontDescriptor *descriptor = [[UIFont preferredFontForTextStyle:UIFontTextStyleTitle3] fontDescriptor];
        UIFontDescriptor *newDescriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        _voteCountLabel.font = [UIFont fontWithDescriptor:newDescriptor size:0];
        _voteCountLabel.textColor = [UIColor systemOrangeColor];
    }
    return _voteCountLabel;
}

- (UILabel *)voteCountLabel2 {
    if (!_voteCountLabel2) {
        _voteCountLabel2 = [UILabel new];
        _voteCountLabel2.text = @"人参与";
        _voteCountLabel2.adjustsFontForContentSizeCategory = YES;
        _voteCountLabel2.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _voteCountLabel2.textColor = [UIColor secondaryLabelColor];
    }
    return _voteCountLabel2;
}

@end
