//
//  BLTNVoteItem.m
//  BYR
//
//  Created by Boyce on 10/29/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "BLTNVoteItem.h"
#import <BLTNBoard-Swift.h>
#import <Masonry/Masonry.h>
#import "Models.h"
#import "VoteOptionCell.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface BLTNVoteItem () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *topicTitleLabel;
@property (nonatomic, strong) UILabel *voteCountLabel;
@property (nonatomic, strong) UILabel *voteCountLabel2;

@property (nonatomic, strong) UIView *userView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *usernameLabel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) Vote *vote;
@property (nonatomic, strong) NSMutableSet <NSNumber *> *voted;

@end

@implementation BLTNVoteItem

- (instancetype)initWithTitle:(NSString *)title {
    self = [super initWithTitle:title];
    if (self) {
        self.requiresCloseButton = NO;
        self.appearance.titleFontSize = 18;
        self.appearance.titleTextColor = [UIColor labelColor];
        self.voted = [NSMutableSet new];
    }
    
    return self;
}

- (NSArray<UIView *> *)makeViewsUnderTitleWithInterfaceBuilder:(BLTNInterfaceBuilder *)interfaceBuilder {
    return @[
        [interfaceBuilder wrapView:self.userView width:nil height:@128 position:BLTNViewPositionPinnedToEdges],
        [interfaceBuilder wrapView:self.tableView width:nil height:@200 position:BLTNViewPositionPinnedToEdges]
    ];
}

- (void)updateWithVote:(Vote *)vote {
    self.vote = vote;
    self.voteCountLabel.text = [NSString stringWithFormat:@"%i", vote.user_count];
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.vote.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"%@-section%li-row%li", VoteOptionCell.class.description, indexPath.section, indexPath.row];
    [_tableView registerClass:VoteOptionCell.class forCellReuseIdentifier:identifier];
    VoteOptionCell *cell = (VoteOptionCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    VoteOption *option = [self.vote.options objectAtIndex:indexPath.row];
    [cell updateWithVote:self.vote option:option];
    [cell selectOption:[self.voted containsObject:@(option.viid)]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.vote.voted) {
        return;
    }
    
    VoteOption *option = [self.vote.options objectAtIndex:indexPath.row];
    if (self.vote.type == 0) {
        //单选
        if ([self.voted containsObject:@(option.viid)]) {
            
        } else {
            [self.voted removeAllObjects];
            [self.voted addObject:@(option.viid)];
        }
    } else {
        if ([self.voted containsObject:@(option.viid)]) {
            [self.voted removeObject:@(option.viid)];
        } else if (self.voted.count == self.vote.limit){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = [NSString stringWithFormat:@"最多可选%i项", self.vote.limit];
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES afterDelay:1];
        } else {
            [self.voted addObject:@(option.viid)];
        }
    }
    
    [tableView reloadData];
}

#pragma mark - getter

- (UIView *)userView {
    if (!_userView) {
        _userView = [UIView new];
        [_userView addSubview:self.headImageView];
        [_userView addSubview:self.usernameLabel];
        [_userView addSubview:self.voteCountLabel];
        [_userView addSubview:self.voteCountLabel2];
        
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(_userView).offset(5);
            make.width.height.mas_equalTo(40);
        }];
        
        [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.headImageView);
            make.left.equalTo(self.headImageView.mas_right).offset(5);
        }];
        
        [self.voteCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.headImageView);
            make.right.equalTo(self.voteCountLabel2.mas_left).offset(-5);
        }];
        
        [self.voteCountLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.headImageView);
            make.right.equalTo(_userView).offset(-5);
        }];
        
        [_userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
        }];
    }
    return _userView;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headImageView.layer.cornerRadius = 20;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.backgroundColor = [UIColor secondarySystemBackgroundColor];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.layer.borderColor = [UIColor separatorColor].CGColor;
        _headImageView.layer.borderWidth = 0.5;
    }
    return _headImageView;
}

- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [UILabel new];
        _usernameLabel.numberOfLines = 0;
        _usernameLabel.adjustsFontForContentSizeCategory = YES;
        _usernameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        _usernameLabel.textColor = [UIColor labelColor];
        _usernameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _usernameLabel;
}

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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor tertiarySystemBackgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 60;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:VoteOptionCell.class forCellReuseIdentifier:VoteOptionCell.class.description];
    }
    return _tableView;
}

@end
