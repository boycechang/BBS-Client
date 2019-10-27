//
//  TopicPageView.m
//  BYR
//
//  Created by Boyce on 10/17/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "TopicPageView.h"
#import <Masonry.h>


@interface TopicPageCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIView *selectedView;
@end

@implementation TopicPageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self.contentView addSubview:self.selectedView];
    [self.contentView addSubview:self.numberLabel];
    
    [self.selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - action

- (void)markSelected:(BOOL)selected {
    self.selectedView.hidden = !selected;
}

#pragma mark - getter

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [UILabel new];
        _numberLabel.adjustsFontForContentSizeCategory = YES;
        _numberLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _numberLabel.textColor = [UIColor labelColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}

- (UIView *)selectedView {
    if (!_selectedView) {
        _selectedView = [UIView new];
        _selectedView.backgroundColor = [UIColor systemGray3Color];
        _selectedView.layer.cornerRadius = 10.f;
        _selectedView.layer.masksToBounds = YES;
    }
    return _selectedView;
}

@end


@interface TopicPageView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *currentNumLabel;
@property (nonatomic, strong) UILabel *totalNumLabel;

@property (nonatomic, strong) UIView *contentView2;
@property (nonatomic, strong) UICollectionView *chooseCollectionView;

@property (nonatomic, assign) NSInteger current;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) BOOL isExpanded;

@end

@implementation TopicPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        self.layer.masksToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        self.layer.shadowOffset = CGSizeMake(0.f, 0.f);
        self.layer.shadowColor = [UIColor systemGrayColor].CGColor;
        self.layer.shadowOpacity = 0.5f;
        self.layer.shadowRadius = 8.f;
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.contentView2];
    [self.contentView2 addSubview:self.chooseCollectionView];
    
    [self.chooseCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView2);
    }];
    [self.contentView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.width.mas_equalTo(44);
    }];
    
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.currentNumLabel];
    [self.contentView addSubview:self.totalNumLabel];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.width.mas_greaterThanOrEqualTo(44);
    }];
    
    [self.currentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
    }];
    
    [self.totalNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.currentNumLabel.mas_right);
    }];
}

- (void)updateWithCurrent:(NSInteger)current total:(NSInteger)total {
    self.current = current;
    self.total = total;
    
    self.currentNumLabel.text = [NSString stringWithFormat:@"%li", current];
    self.totalNumLabel.text = [NSString stringWithFormat:@" / %li", total];
    
    [self.chooseCollectionView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.chooseCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:current - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    });
}

#pragma makr - actions

- (void)fold {
    if (self.isExpanded) {
        [self.contentView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.right.equalTo(self);
                make.width.mas_equalTo(44);
            }];
        
        [UIView animateWithDuration:0.20 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self layoutIfNeeded];
        } completion:nil];
        
        self.isExpanded = NO;
    }
}

- (IBAction)chooseClicked:(id)sender {
    if (!self.isExpanded) {
        [self.contentView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.right.equalTo(self.contentView.mas_left).offset(-10);
        }];
    } else {
        [self.contentView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self);
            make.width.mas_equalTo(44);
        }];
    }
    
    [UIView animateWithDuration:0.20 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self layoutIfNeeded];
    } completion:nil];
    
    self.isExpanded = !self.isExpanded;
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.total;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TopicPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TopicPageCell.class.description forIndexPath:indexPath];
    cell.numberLabel.text = [NSString stringWithFormat:@"%li", indexPath.row + 1];
    [cell markSelected:indexPath.row + 1 == self.current];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pageSelected) {
        self.pageSelected(indexPath.row + 1);
    }
    [self fold];
}

#pragma mark - getter

- (UILabel *)currentNumLabel {
    if (!_currentNumLabel) {
        _currentNumLabel = [UILabel new];
        _currentNumLabel.text = @"";
        _currentNumLabel.adjustsFontForContentSizeCategory = YES;
        _currentNumLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _currentNumLabel.textColor = [UIColor labelColor];
    }
    return _currentNumLabel;
}

- (UILabel *)totalNumLabel {
    if (!_totalNumLabel) {
        _totalNumLabel = [UILabel new];
        _totalNumLabel.text = @"/";
        _totalNumLabel.adjustsFontForContentSizeCategory = YES;
        _totalNumLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        _totalNumLabel.textColor = [UIColor secondaryLabelColor];
        _totalNumLabel.textAlignment = NSTextAlignmentRight;
    }
    return _totalNumLabel;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.layer.cornerRadius = 10.f;
        _contentView.layer.masksToBounds = YES;
        _contentView.backgroundColor = [[UIColor tertiarySystemBackgroundColor] colorWithAlphaComponent:0.6];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseClicked:)];
        [_contentView addGestureRecognizer:tap];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [_contentView addSubview:blurEffectView];
        [blurEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_contentView);
        }];
        blurEffectView.layer.cornerRadius = 10.f;
        blurEffectView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIView *)contentView2 {
    if (!_contentView2) {
        _contentView2 = [UIView new];
        _contentView2.layer.cornerRadius = 10.f;
        _contentView2.layer.masksToBounds = YES;
        _contentView2.backgroundColor = [[UIColor tertiarySystemBackgroundColor] colorWithAlphaComponent:0.6];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [_contentView2 addSubview:blurEffectView];
        [blurEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_contentView2);
        }];
        blurEffectView.layer.cornerRadius = 10.f;
        blurEffectView.layer.masksToBounds = YES;
    }
    return _contentView2;
}

- (UICollectionView *)chooseCollectionView {
    if (!_chooseCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(44, 44);
        flowLayout.minimumInteritemSpacing = 5;
        
        _chooseCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _chooseCollectionView.backgroundColor = [UIColor clearColor];
        _chooseCollectionView.layer.cornerRadius = 10.f;
        _chooseCollectionView.layer.masksToBounds = YES;
        
        _chooseCollectionView.delegate = self;
        _chooseCollectionView.dataSource = self;
        _chooseCollectionView.showsHorizontalScrollIndicator = NO;
        [_chooseCollectionView registerClass:TopicPageCell.class
                  forCellWithReuseIdentifier:TopicPageCell.class.description];
    }
    return _chooseCollectionView;
}

@end
