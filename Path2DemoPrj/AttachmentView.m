//
//  AttachmentView.m
//  虎踞龙蟠
//
//  Created by Boyce on 8/16/13.
//  Copyright (c) 2013 Ethan. All rights reserved.
//

#import "AttachmentView.h"
#import "Models.h"
#import <Masonry.h>

@interface AttachmentView ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) Attachment *attachment;

@end

@implementation AttachmentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        self.backgroundColor = [UIColor tertiarySystemFillColor];
        self.layer.cornerRadius = 10.f;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.nameLabel];
    [self addSubview:self.sizeLabel];
    [self addSubview:self.iconImageView];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(15);
        make.right.equalTo(self.iconImageView.mas_left).offset(-15);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.nameLabel);
    }];
}

- (void)updateWithAttachment:(Attachment *)attachment {
    _attachment = attachment;
    self.nameLabel.text = attachment.name;
    self.sizeLabel.text = attachment.size;
}

#pragma mark - getter

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.numberOfLines = 2;
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
        _nameLabel.textColor = [UIColor labelColor];
    }
    return _nameLabel;
}

- (UILabel *)sizeLabel {
    if (!_sizeLabel) {
        _sizeLabel = [UILabel new];
        _sizeLabel.font = [UIFont systemFontOfSize:12];
        _sizeLabel.textColor = [UIColor secondaryLabelColor];
    }
    return _sizeLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.image = [UIImage systemImageNamed:@"doc.text.fill"];
        _iconImageView.tintColor = [UIColor systemBlueColor];
    }
    return _iconImageView;
}

@end
