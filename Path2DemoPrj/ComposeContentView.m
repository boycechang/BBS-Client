//
//  ComposeContentView.m
//  BYR
//
//  Created by Boyce on 10/13/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "ComposeContentView.h"
#import <YYText.h>
#import <Masonry.h>

NSString * const KSAKeyboardFrameDidChangeNotification = @"KSAKeyboardFrameDidChangeNotification";

@interface KSAObservingInputAccessoryView : UIView
@end

@implementation KSAObservingInputAccessoryView

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview) {
        [self.superview removeObserver:self forKeyPath:@"center"];
    }
    
    [newSuperview addObserver:self forKeyPath:@"center" options:0 context:NULL];
    [super willMoveToSuperview:newSuperview];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self.superview && [keyPath isEqualToString:@"center"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KSAKeyboardFrameDidChangeNotification object:self];
    }
}

@end

@interface ComposeContentView () <UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic) UITextField *titleTextField;
@property (nonatomic) UILabel *countLabel;
@property (nonatomic) YYTextView *contentTextView;

@end

@implementation ComposeContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        [self setupViews];
    }
    return self;
}

#pragma mark - private

- (void)setupViews {
    [self addSubview:self.countLabel];
    [self addSubview:self.titleTextField];
    [self addSubview:self.contentTextView];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self).offset(-25);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
    
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self.countLabel.mas_left).offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleTextField.mas_bottom).offset(5);
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.bottom.equalTo(self).offset(-10);
        make.width.mas_equalTo(325);
    }];
    [self.contentTextView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentTextView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}


#pragma mark - getter

- (UITextField *)titleTextField {
    if (!_titleTextField) {
        _titleTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _titleTextField.inputAccessoryView = [KSAObservingInputAccessoryView new];
        _titleTextField.placeholder = @"输入标题";
    }
    return _titleTextField;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.text = @"20";
        _countLabel.hidden = YES;
    }
    return _countLabel;
}

- (YYTextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[YYTextView alloc] initWithFrame:CGRectMake(0, 0, 325, 50)];
        _contentTextView.showsVerticalScrollIndicator = NO;
        _contentTextView.alwaysBounceVertical = YES;
        _contentTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        _contentTextView.inputAccessoryView = [KSAObservingInputAccessoryView new];
        _contentTextView.backgroundColor = [UIColor redColor];
    }
    return _contentTextView;
}
@end
