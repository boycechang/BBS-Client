//
//  ComposeViewController.m
//  BYR
//
//  Created by Boyce on 10/13/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "ComposeViewController.h"
#import <Masonry.h>
#import "LoginInfoView.h"
#import "ProtocolViewController.h"
#import "BYRSession.h"
#import <MBProgressHUD.h>
#import "ComposeContentView.h"
#import "ComposeToolView.h"

@interface ComposeViewController ()

@property (nonatomic, strong) UIBarButtonItem *sendButtonItem;
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) ComposeContentView *composeContentView;
@property (nonatomic, strong) ComposeToolView *composeToolView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发帖";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    self.sendButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"arrow.up.circle.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(send:)];
    self.navigationItem.rightBarButtonItems = @[self.sendButtonItem];
    
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.composeToolView];
    [self.contentView addSubview:self.composeContentView];
    
    [self.composeToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.height.mas_equalTo(100);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.composeToolView.mas_top).offset(-5);
    }];
    
    [self.composeContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.composeContentView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.composeContentView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ksa_keyboardFrameChange:)
                                                 name:KSAKeyboardFrameDidChangeNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - actions

- (void)ksa_keyboardFrameChange:(NSNotification *)notification {
    UIView *view = notification.object;
    UIView *keyboardView = view.superview;
    
    CGFloat offset = MAX(keyboardView.window.frame.size.height - keyboardView.frame.origin.y - self.view.safeAreaInsets.bottom, 0);
    
    [self.composeToolView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-offset);
    }];
    
    [UIView animateWithDuration:0.01 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)send:(id)sender {
    
}

#pragma mark - getter

- (UIScrollView *)contentView {
    if (!_contentView) {
        _contentView = [UIScrollView new];
        _contentView.alwaysBounceVertical = YES;
        _contentView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        _contentView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3];
    }
    return _contentView;
}

- (ComposeContentView *)composeContentView {
    if (!_composeContentView) {
        _composeContentView = [[ComposeContentView alloc] initWithFrame:CGRectZero];
    }
    return _composeContentView;
}

- (ComposeToolView *)composeToolView {
    if (!_composeToolView) {
        _composeToolView = [[ComposeToolView alloc] initWithFrame:CGRectZero];
    }
    return _composeToolView;
}

@end
