//
//  SingleMailViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/6/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "SingleMailViewController.h"

@implementation SingleMailViewController
@synthesize rootMail;
@synthesize mail;
@synthesize isForShowNotification;
@synthesize mDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isForShowNotification = NO;
    }
    return self;
}

-(void)firstTimeLoad
{
    self.mail = [BBSAPI getSingleMail:myBBS.mySelf.token Type:rootMail.type ID:rootMail.ID];
    
    if (mail.type == 0)
        [authorLabel setText:[NSString stringWithFormat:@"发件人：%@", mail.author]];
    if (mail.type == 1)
        [authorLabel setText:[NSString stringWithFormat:@"收件人：%@", mail.author]];
    if (mail.type == 2)
        [authorLabel setText:[NSString stringWithFormat:@"发件人：%@", mail.author]];
    [titleLabel setText:mail.title];
    [content setText:mail.content];
    
    [scrollView addSubview:realView];
    
    UIFont *font = [UIFont systemFontOfSize:15.0];
    CGSize size = [mail.content sizeWithFont:font constrainedToSize:CGSizeMake(290, 10000) lineBreakMode:UILineBreakModeWordWrap];

    [content setFrame:CGRectMake(content.frame.origin.x, content.frame.origin.y, content.frame.size.width, size.height)];
    

    [realView setFrame:CGRectMake(0, 0, 320, content.frame.origin.y + size.height)];
    [scrollView setContentSize:CGSizeMake(320, content.frame.origin.y + size.height+10)];
    if (content.frame.origin.y + size.height+10 <= 480) {
        [scrollView setContentSize:CGSizeMake(320, 490)];
    }
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [realScrollView setFrame:CGRectMake(0, 44, rect.size.width, rect.size.height - 64)];
    scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    if (rootMail.type == 0)
        [topTitle setText:@"收件箱"];
    if (rootMail.type == 1)
        [topTitle setText:@"发件箱"];
    if (rootMail.type == 2)
        [topTitle setText:@"废件箱"];
    
    realView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view insertSubview:HUD atIndex:1];
	HUD.labelText = @"载入中...";
	[HUD showWhileExecuting:@selector(firstTimeLoad) onTarget:self withObject:nil animated:YES];
    [HUD release];
    
    UISwipeGestureRecognizer* recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizer];
    
    [self attachLongPressHandler];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    [super dealloc];
    [rootMail release];
    rootMail = nil;
    [mail release];
    mail = nil;
}
-(IBAction)back:(id)sender
{
    if (isForShowNotification) {
        [mDelegate refreshNotification];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)shouldAutorotate{
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


-(IBAction)reply:(id)sender
{
    PostMailViewController * postMailViewController = [[PostMailViewController alloc] initWithNibName:@"PostMailViewController" bundle:nil];
    postMailViewController.postType = 1;
    postMailViewController.rootMail = rootMail;
    postMailViewController.mDelegate = self;
    [self presentModalViewController:postMailViewController animated:YES];
    [postMailViewController release];
}

-(void)dismissPostMailView
{
    [self dismissModalViewControllerAnimated:YES];
}




#pragma -Longpress

- (BOOL)canBecomeFirstResponder{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(copyTitleLabel:) || action == @selector(copyContentLabel:) || action == @selector(copyAuthorLabel:) ) {
        return YES;
    }
    return NO;
}

//针对于copy的实现
-(void)copyTitleLabel:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = titleLabel.text;
}
-(void)copyContentLabel:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = content.text;
}
-(void)copyAuthorLabel:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = authorLabel.text;
}

//添加touch事件
-(void)attachLongPressHandler{
    self.view.userInteractionEnabled = YES;  //用户交互的总开关
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.view addGestureRecognizer:longPress];
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuItem *copyTitle = [[UIMenuItem alloc] initWithTitle:@"复制标题" action:@selector(copyTitleLabel:)];
        UIMenuItem *copyContent = [[UIMenuItem alloc] initWithTitle:@"复制正文" action:@selector(copyContentLabel:)];
        UIMenuItem *copyAuthor = [[UIMenuItem alloc] initWithTitle:@"复制发信人" action:@selector(copyAuthorLabel:)];
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:copyAuthor, copyTitle, copyContent, nil]];
        [menu setTargetRect:self.view.frame inView:self.view];
        [menu setMenuVisible:YES animated:YES];
    }
}

@end
