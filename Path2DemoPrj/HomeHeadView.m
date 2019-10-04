//
//  HomeHeadView.m
//  BYR
//
//  Created by Boyce on 10/5/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "HomeHeadView.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "Models.h"

@interface HomeHeadView ()
@property (nonatomic, strong) UIImageView *headImageView;
@end

@implementation HomeHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.headImageView];
}

- (void)updateWithUser:(User *)user {
    [self.headImageView sd_setImageWithURL:user.face_url];
}

- (IBAction)headClick:(id)sender {
    if (self.headTapped) {
        self.headTapped();
    }
}

#pragma mark - getter

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:self.frame];
        _headImageView.layer.cornerRadius = 15.f;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick:)];
        [_headImageView addGestureRecognizer:tap];
    }
    return _headImageView;
}

@end
