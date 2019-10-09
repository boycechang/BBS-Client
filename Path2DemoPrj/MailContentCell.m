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
#import <YYText.h>
#import "BYRBBCodeToYYConverter.h"
#import "BYRUtil.h"

@interface MailContentCell ()

@property (nonatomic, strong) YYLabel *contentLabel;

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

- (void)updateWithMail:(Mail *)mail
converter:(BYRBBCodeToYYConverter *)converter {
    NSString *trimedContent = [mail.content trimedWhitespaceString];
    
    CGFloat contentWidth = self.safeAreaLayoutGuide.layoutFrame.size.width - 30;
    if (!mail.attributedContentCache) {
        NSAttributedString *richText = [converter parseBBCode:trimedContent attachemtns:nil containerWidth:contentWidth];
        mail.attributedContentCache = richText;
    }
    self.contentLabel.preferredMaxLayoutWidth = contentWidth;
    self.contentLabel.attributedText = mail.attributedContentCache;
}

#pragma mark - getter

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [YYLabel new];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return _contentLabel;
}

@end
