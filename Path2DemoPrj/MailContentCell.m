//
//  MailContentCell.m
//  BYR
//
//  Created by Boyce on 10/6/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "MailContentCell.h"
#import <Masonry.h>
#import "Models.h"
#import "NSString+BYRTool.h"

@interface MailContentCell ()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation MailContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(15, 15, 15, 15));
    }];
}

#pragma mark - public

- (void)updateWithMail:(Mail *)mail {
    NSString *trimedContent = [mail.content trimedWhitespaceString];
    self.contentLabel.text = trimedContent;
}

#pragma mark - getter

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.numberOfLines = 0;
        _contentLabel.adjustsFontForContentSizeCategory = YES;
        _contentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return _contentLabel;
}

@end
