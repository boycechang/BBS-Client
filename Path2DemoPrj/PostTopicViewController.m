//
//  PostTopicViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/5/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "PostTopicViewController.h"

@implementation PostTopicViewController
@synthesize rootTopic;
@synthesize boardName;
@synthesize postType;
@synthesize mDelegate;
@synthesize keyboardToolbar;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, rect.size.height)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    UIBarButtonItem *sendButton =[[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];

    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = sendButton;
    
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        postScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    }
    else {
        postScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    }

    postScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 64 + 1);
    postScrollView.delegate = self;
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 21)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor lightGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"标题";
    titleLabel.layer.cornerRadius = 2.0f;
    titleLabel.clipsToBounds = YES;
    
    postTitle = [[UITextField alloc] initWithFrame:CGRectMake(60, 10, self.view.frame.size.width - 115, 21)];
    NSLog(@"postTitle Width : %f", self.view.frame.size.width - 115);
    postTitle.textColor = [UIColor lightGrayColor];
    postTitle.placeholder = @"添加标题";
    [postTitle addTarget:self action:@selector(inputTitle) forControlEvents:UIControlEventEditingChanged];
    
    postTitleCount = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, 10, 30, 21)];
    postTitleCount.textColor = [UIColor lightGrayColor];
    postTitleCount.textAlignment = NSTextAlignmentRight;
    
    postContent = [[UITextView alloc] initWithFrame:CGRectMake(5, 35, self.view.frame.size.width - 10, self.view.frame.size.height - 30 - 64)];
    [postContent setFont:[UIFont systemFontOfSize:17]];
    [postScrollView addSubview:titleLabel];
    [postScrollView addSubview:postTitle];
    [postScrollView addSubview:postTitleCount];
    [postScrollView addSubview:postContent];
    [self.view addSubview:postScrollView];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;

    if (postType == 0) {
        self.title = @"发新帖子";
        [postTitle setText:@""];
        [postTitle becomeFirstResponder];
        [postContent setText:@""];
        [postTitleCount setText:[NSString stringWithFormat:@"%i", [postTitle.text length]]];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    if (postType == 1) {
        self.title = @"回帖";
        if ([rootTopic.title length] >= 4 && [[rootTopic.title substringToIndex:4] isEqualToString:@"Re: "]) {
            [postTitle setText:[NSString stringWithFormat:@"%@", rootTopic.title]];
        }
        else {
            [postTitle setText:[NSString stringWithFormat:@"Re: %@", rootTopic.title]];
        }
        [postTitleCount setText:[NSString stringWithFormat:@"%i", [postTitle.text length]]];
        
        if (rootTopic.content != nil) {
            [postContent setText:[NSString stringWithFormat:@"\n【 在 %@ 的大作中提到: 】\n%@", rootTopic.author, rootTopic.content.length > 30 ? [NSString stringWithFormat:@"%@...", [rootTopic.content substringToIndex:27]] : rootTopic.content]];
        } else {
            [postContent setText:@""];
        }
        [postContent becomeFirstResponder];
        postContent.selectedRange = NSMakeRange(0, 0);
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    if (postType == 2) {
        self.title = @"修改帖子";
        [postTitle setText:rootTopic.title];
        [postContent becomeFirstResponder];
        [postContent setText:rootTopic.content];
        [postTitleCount setText:[NSString stringWithFormat:@"%i", [postTitle.text length]]];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    
    self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
    keyboardToolbar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    
    UIBarButtonItem *emotionBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"face"] style:UIBarButtonItemStylePlain target:self action:@selector(switchToEmotionKeyboard)];
    
    UIBarButtonItem *spaceBarItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    
    UIBarButtonItem *attachmentBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera64"] style:UIBarButtonItemStylePlain target:self action:@selector(operateAtt:)];
    
    UIBarButtonItem *spaceBarItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [keyboardToolbar setItems:[NSArray arrayWithObjects:spaceBarItem, emotionBarItem, spaceBarItem1,  attachmentBarItem, spaceBarItem2, nil]];
    
    postContent.inputAccessoryView = keyboardToolbar;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(switchToDefaultKeyboard)
               name:WUEmoticonsKeyboardDidSwitchToDefaultKeyboardNotification
             object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [postTitle resignFirstResponder];
    [postContent resignFirstResponder];
}

-(void)cancel
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)send
{
    [postTitle resignFirstResponder];
    [postContent resignFirstResponder];
    
    [self.navigationController showSGProgressWithDuration:3 andTintColor:self.navigationController.navigationBar.tintColor andTitle:@"发送中..." ];
    [NSThread detachNewThreadSelector:@selector(firstTimeLoad) toTarget:self withObject:nil];
}

-(void)didAddUser:(NSString *)userID
{
    NSMutableString * string = [postContent.text mutableCopy];
    [string appendString:@"@"];
    [string appendString:userID];
    [string appendString:@" "];
    [postContent setText:string];
    [postContent becomeFirstResponder];
}
-(void)dismissAddUserView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)firstTimeLoad
{
    if([self post]) {
        [self performSelectorOnMainThread:@selector(sendSuccess) withObject:nil waitUntilDone:NO];
    }
    else {
        [self performSelectorOnMainThread:@selector(sendFailed) withObject:nil waitUntilDone:NO];
    }
}

-(void)sendSuccess
{
    [self.navigationController finishSGProgress];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendFailed
{
    [self.navigationController finishSGProgress];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"发送失败";
    hud.margin = 30.f;
    hud.yOffset = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:0.8];
}

-(BOOL)post
{
    if (postType == 0) {
        return [BBSAPI postTopic:myBBS.mySelf Board:boardName Title:postTitle.text Content:[NSString stringWithFormat:@"%@", postContent.text] Reid:0];
    }
    if (postType == 1) {
        return [BBSAPI postTopic:myBBS.mySelf Board:rootTopic.board Title:postTitle.text Content:[NSString stringWithFormat:@"%@", postContent.text] Reid:rootTopic.ID];
    }
    if (postType == 2) {
        return [BBSAPI editTopic:myBBS.mySelf Board:rootTopic.board Title:postTitle.text Content:[NSString stringWithFormat:@"%@", postContent.text] Reid:rootTopic.ID];
    }
    return 0;
}


#pragma mark -
#pragma mark textViewDelegate
-(void)inputTitle
{
    int count = [postTitle.text length];
    [postTitleCount setText:[NSString stringWithFormat:@"%i",count]];
    if (count == 0) {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    else {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
}

-(IBAction)operateAtt:(id)sender
{
    if (postType == 0) {
        UploadAttachmentsViewController * uavc = [[UploadAttachmentsViewController alloc] init];
        uavc.postType = 0;//新帖
        uavc.board = boardName;
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:uavc];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    else if(postType == 2)
    {
        UploadAttachmentsViewController * uavc = [[UploadAttachmentsViewController alloc] init];
        uavc.postType = 2;//修改贴
        uavc.postId=rootTopic.ID;
        uavc.board=rootTopic.board;
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:uavc];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    else
    {
        UploadAttachmentsViewController * uavc = [[UploadAttachmentsViewController alloc] init];
        uavc.postType = 1;//回复
        uavc.postId=rootTopic.ID;
        uavc.board=rootTopic.board;
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:uavc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    NSDictionary *userInfo = [notification userInfo];
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    
    [postScrollView setContentOffset:CGPointMake(0, 0)];
    [postContent setFrame:CGRectMake(5, 35, self.view.frame.size.width - 10, self.view.frame.size.height - 64 - 35 - keyboardRect.size.height - 2)];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    if (postContent.contentSize.height < self.view.frame.size.height - 64 - 35) {
        [postContent setFrame:CGRectMake(5, 35, self.view.frame.size.width - 10, self.view.frame.size.height - 64 - 35)];
    }
    else
    {
        [postContent setFrame:CGRectMake(5, 35, self.view.frame.size.width - 10, postContent.contentSize.height)];
        [postScrollView setContentSize:CGSizeMake(postScrollView.contentSize.width, postContent.contentSize.height + 35)];
    }
}

- (void)switchToDefaultKeyboard {
    [postContent resignFirstResponder];
    
    [postContent switchToDefaultKeyboard];
    postContent.inputAccessoryView = keyboardToolbar;
    
    [postContent becomeFirstResponder];
}

- (void)switchToEmotionKeyboard {
    [postContent resignFirstResponder];
    
    [postContent switchToEmoticonsKeyboard:[WUDemoKeyboardBuilder sharedEmoticonsKeyboard]];
    postContent.inputAccessoryView = nil;
    
    [postContent becomeFirstResponder];
}


#pragma mark - Rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}
- (BOOL)shouldAutorotate{
    return YES;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
