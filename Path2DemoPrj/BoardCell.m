//
//  BoardCell.m
//  BYR
//
//  Created by Boyce on 10/4/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "BoardCell.h"
#import "Models.h"
#import <Masonry.h>

@interface BoardCell ()

@property (nonatomic, strong) UILabel *boardLabel;
@property (nonatomic, strong) UILabel *boardDescriptionLabel;

@property (nonatomic, strong) UIImageView *folderImageView;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UIImageView *indicatorImageView;

@end

@implementation BoardCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    CGFloat itemWidth = (UIScreen.mainScreen.nativeBounds.size.width / UIScreen.mainScreen.nativeScale - 45) / 2;
    self.contentView.backgroundColor = [UIColor secondarySystemBackgroundColor];
    self.contentView.layer.cornerRadius = 6.f;
    self.contentView.layer.masksToBounds = YES;
    
    [self.contentView addSubview:self.boardLabel];
    [self.contentView addSubview:self.indicatorImageView];
    
    [self.contentView addSubview:self.boardDescriptionLabel];
    [self.contentView addSubview:self.folderImageView];
    [self.contentView addSubview:self.dateLabel];
    
    [self.boardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-25);
    }];
    
    [self.indicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(-8);
        make.width.height.mas_equalTo(15);
    }];
    
    [self.boardDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.boardLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(itemWidth - 21);
    }];
    
    [self.folderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.boardDescriptionLabel);
        make.top.equalTo(self.boardDescriptionLabel.mas_bottom).offset(5);
        make.height.width.mas_equalTo(20);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.boardDescriptionLabel);
        make.top.equalTo(self.boardDescriptionLabel.mas_bottom).offset(15);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.height.mas_greaterThanOrEqualTo(10);
    }];
}

- (void)updateWithBoard:(Board *)board isMyFav:(BOOL)isMyFav {
    self.boardLabel.text = board.section ? board.name : nil;
    self.boardDescriptionLabel.text = board.board_description ?: board.name;
    self.indicatorImageView.hidden = !board.is_favorite || isMyFav;
    
    if (board.is_root ||
        !board.section) {
        self.folderImageView.hidden = NO;
        self.dateLabel.text = nil;
    } else {
        self.folderImageView.hidden = YES;
        self.dateLabel.text = [NSString stringWithFormat:@"%li在线 · %li新帖", board.user_online_count, board.post_today_count];
    }
}

#pragma mark - getter

- (UILabel *)boardLabel {
    if (!_boardLabel) {
        _boardLabel = [UILabel new];
        _boardLabel.numberOfLines = 0;
        _boardLabel.adjustsFontForContentSizeCategory = YES;
        _boardLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        _boardLabel.textColor = [UIColor secondaryLabelColor];
    }
    return _boardLabel;
}

- (UILabel *)boardDescriptionLabel {
    if (!_boardDescriptionLabel) {
        _boardDescriptionLabel = [UILabel new];
        _boardDescriptionLabel.numberOfLines = 0;
        _boardDescriptionLabel.adjustsFontForContentSizeCategory = YES;
        _boardDescriptionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return _boardDescriptionLabel;
}

- (UIImageView *)folderImageView {
    if (!_folderImageView) {
        _folderImageView = [UIImageView new];
        _folderImageView.image = [UIImage systemImageNamed:@"folder"];
        _folderImageView.tintColor = [UIColor systemBlueColor];
    }
    return _folderImageView;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.numberOfLines = 0;
        _dateLabel.adjustsFontForContentSizeCategory = YES;
        
        UIFont *caption2 = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        UIFont *scaledCaption2 = [caption2 fontWithSize:caption2.pointSize * 0.9];
        _dateLabel.font = scaledCaption2;
        
        _dateLabel.textColor = [UIColor secondaryLabelColor];
    }
    return _dateLabel;
}

- (UIImageView *)indicatorImageView {
    if (!_indicatorImageView) {
        _indicatorImageView = [UIImageView new];
        _indicatorImageView.image = [UIImage systemImageNamed:@"star.fill"];
        _indicatorImageView.tintColor = [UIColor systemBlueColor];
    }
    return _indicatorImageView;
}

@end
