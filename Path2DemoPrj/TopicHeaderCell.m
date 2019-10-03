//
//  TopicHeaderCell.m
//  BYR
//
//  Created by Boyce on 10/3/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "TopicHeaderCell.h"
#import <Masonry.h>

@interface TopicHeaderCell ()

@property (nonatomic, strong) UILabel *sectionNameLabel;

@end

@implementation TopicHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self.contentView addSubview:self.sectionNameLabel];
    
    [self.sectionNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(40);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
}

#pragma mark - public

- (void)updateWithSectionName:(NSString *)secionName {
    self.sectionNameLabel.text = secionName;
}

#pragma mark - getter

- (UILabel *)sectionNameLabel {
    if (!_sectionNameLabel) {
        _sectionNameLabel = [UILabel new];
        _sectionNameLabel.adjustsFontForContentSizeCategory = YES;
        _sectionNameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        _sectionNameLabel.textColor = [UIColor colorNamed:@"MainTheme"];
    }
    return _sectionNameLabel;
}

@end
