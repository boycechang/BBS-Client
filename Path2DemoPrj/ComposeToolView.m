//
//  ComposeToolView.m
//  BYR
//
//  Created by Boyce on 10/13/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "ComposeToolView.h"
#import <Masonry.h>

@interface ComposeToolView ()

@property (nonatomic, strong) UICollectionView *attchmentContainer;
@property (nonatomic, strong) UIView *toolContainer;

@end


@implementation ComposeToolView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.3];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.toolContainer];
    [self.toolContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self);
    }];
}

#pragma mark - getter

- (UIView *)toolContainer {
    if (!_toolContainer) {
        _toolContainer = [UIView new];
        _toolContainer.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    }
    return _toolContainer;
}

@end
