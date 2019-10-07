//
//  ProtocolViewController.m
//  BYR
//
//  Created by Boyce on 10/5/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "ProtocolViewController.h"
#import <WebKit/WebKit.h>
#import <Masonry.h>

@interface ProtocolViewController ()

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"论坛管理办法";
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"protocol" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:htmlPath];
    [self.webView loadFileURL:url allowingReadAccessToURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath] isDirectory:YES]];
}

#pragma mark - getter

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [WKWebView new];
    }
    return _webView;
}

@end
