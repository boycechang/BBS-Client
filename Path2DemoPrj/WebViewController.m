//
//  WebViewController.m
//  虎踞龙蟠
//
//  Created by Boyce on 8/17/13.
//  Copyright (c) 2013 Ethan. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

- (id)initWithURL:(NSString *)AttachmentName AttachmentURL:(NSURL *)URL
{
    self = [super init];
    if (self) {
        attachmentName = AttachmentName;
        url = URL;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = attachmentName;
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    UIBarButtonItem *openButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(open)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = openButton;
    
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [webView setScalesPageToFit:YES];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)open
{
    NSArray *activityItems = [[NSArray alloc] initWithObjects:url, nil];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];

    [self presentViewController:activityController animated:YES completion:Nil];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
