//
//  WPKeyboardPressedCellPopupView.m
//  WeicoPlusUniversal
//
//  Created by YuAo on 2/1/13.
//  Copyright (c) 2013 北京微酷奥网络技术有限公司. All rights reserved.
//

#import "WUDemoKeyboardPressedCellPopupView.h"

@interface WUDemoKeyboardPressedCellPopupView ()
@property (nonatomic,weak) UIImageView *imageView;
@property (nonatomic,weak) UILabel  *textLabel;
@property (nonatomic,weak) UIWebView  *webView;
@end

@implementation WUDemoKeyboardPressedCellPopupView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *popupBackground = [UIImage imageNamed:@"keyboard_popup"];
        UIImageView *popupBackgroundView = [[UIImageView alloc] initWithImage:popupBackground];
        popupBackgroundView.frame = frame;
        [self addSubview:popupBackgroundView];
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        webView.backgroundColor = [UIColor clearColor];
        webView.userInteractionEnabled = NO;
        webView.scalesPageToFit = YES;
        [self addSubview:webView];
        self.webView = webView;
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:11];
        textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:textLabel];
        self.textLabel = textLabel;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(25, 9, 32, 32);
    self.textLabel.frame = CGRectMake(10, 50, 63, 18);
    self.webView.frame = CGRectMake(20, 7, 42, 42);
}

- (void)setKeyItem:(WUEmoticonsKeyboardKeyItem *)keyItem {
    _keyItem = keyItem;
    self.textLabel.text = keyItem.textToInput;
    //self.imageView.image = keyItem.image;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:keyItem.textToInput ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.userInteractionEnabled = NO;
    self.webView.scalesPageToFit = YES;
    [self.webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
}

@end
