//
//  BoardHeaderCollectionReusableView.m
//  BYR
//
//  Created by Boyce on 10/4/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "BoardHeaderCollectionReusableView.h"
#import <Masonry.h>

@interface BoardHeaderCollectionReusableView ()

@property (nonatomic, strong) UILabel *sectionNameLabel;

@end


@implementation BoardHeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.sectionNameLabel];
    [self.sectionNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(15);
    }];
}

- (void)updateWithSectionName:(NSString *)secionName {
    self.sectionNameLabel.text = secionName;
}

#pragma mark - getter

- (UILabel *)sectionNameLabel {
    if (!_sectionNameLabel) {
        _sectionNameLabel = [UILabel new];
        _sectionNameLabel.adjustsFontForContentSizeCategory = YES;
        
        UIFontDescriptor *descriptor = [[UIFont preferredFontForTextStyle:UIFontTextStyleTitle3] fontDescriptor];
        UIFontDescriptor *newDescriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        _sectionNameLabel.font = [UIFont fontWithDescriptor:newDescriptor size:0];
        _sectionNameLabel.textColor = [UIColor colorNamed:@"Title3"];
    }
    return _sectionNameLabel;
}

@end
