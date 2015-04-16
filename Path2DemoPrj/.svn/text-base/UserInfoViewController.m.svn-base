//
//  UserInfoViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/5/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "UserInfoViewController.h"

@implementation UserInfoViewController
@synthesize userString;
@synthesize user;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        BOOL * isLoadAvatar = [defaults boolForKey:@"isLoadAvatar"];
        if (isLoadAvatar) {
            //self.view = userInfoWithAvatar;
            NSLog(@"userInfoWithAvatar");
        }
        else
        {
            //self.view = userInfoWithoutAvatar;
            NSLog(@"userInfoWithoutAvatar");
        }

    }
        
    return self;
    
}

-(void)refreshView
{
    //[progressIndicator setHidden:YES];
    [ID setText:[NSString stringWithFormat:@"%@", user.ID]];
    [name setText:[NSString stringWithFormat:@"%@", user.name]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString * lastloginstring = [dateFormatter stringFromDate:user.lastlogin];
    [lastlogin setText:[NSString stringWithFormat:@"%@",lastloginstring]];
    
    [level setText:[NSString stringWithFormat:@"%@", user.level]];
    
    [posts setText:[NSString stringWithFormat:@"%i", user.posts]];
    [perform setText:[NSString stringWithFormat:@"%i", user.perform]];
    [experience setText:[NSString stringWithFormat:@"%i", user.experience]];
    [medals setText:[NSString stringWithFormat:@"%i", user.medals]];
    [logins setText:[NSString stringWithFormat:@"%i", user.logins]];
    [life setText:[NSString stringWithFormat:@"%i", user.life]];
    
    if (user.gender != NULL) {
        if([user.gender isEqualToString:@"M"])
            [gender setText:[NSString stringWithFormat:@"%@", @"帅哥"]];
        else
            [gender setText:[NSString stringWithFormat:@"%@", @"美女"]];
        
        [astro setText:[NSString stringWithFormat:@"%@", user.astro]];
    }
    else {
        [gender setText:@"保密"];
        [astro setText:@"保密"];
    }
}

-(void)firstTimeLoad
{
    if (myBBS.mySelf.ID != nil && [myBBS.mySelf.ID isEqualToString:userString]) {
        [sentMailButton setHidden:YES];
        [addFriendButton setHidden:YES];
    }
    
    if ([BBSAPI isFriend:myBBS.mySelf.token ID:userString])
        [addFriendButton setHidden:YES];
    if (myBBS.mySelf.ID == nil) {
        [addFriendButton setHidden:YES];
        [sentMailButton setHidden:YES];
    }
    
    self.user = [BBSAPI userInfo:userString];
    [HUD removeFromSuperview];
    HUD = nil;
    
    [avatar setImage:nil];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    BOOL * isLoadAvatar = [defaults boolForKey:@"isLoadAvatar"];
    if (isLoadAvatar) {
        if (!networkQueue) {
            networkQueue = [[ASINetworkQueue alloc] init];
        }
        failed = NO;
        [networkQueue reset];
        [networkQueue setDownloadProgressDelegate:progressIndicator];
        [networkQueue setRequestDidFinishSelector:@selector(imageFetchComplete:)];
        [networkQueue setRequestDidFailSelector:@selector(imageFetchFailed:)];
        [networkQueue setShowAccurateProgress:YES];
        [networkQueue setDelegate:self];
        
        ASIHTTPRequest *request;
        request = [ASIHTTPRequest requestWithURL:user.avatar];
        [request setDownloadDestinationPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:user.ID]];
        [request setDownloadProgressDelegate:progressIndicator];
        //[request setUserInfo:[NSDictionary dictionaryWithObject:@"request1" forKey:@"name"]];
        [networkQueue addOperation:request];
        [networkQueue go];
    }
    else {
        [avatar setImage:[UIImage imageNamed:@"noavatar.png"]];
        [progressIndicator setHidden:YES];
    }
    
    [self refreshView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    // Do any additional setup after loading the view from its nib.
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view insertSubview:HUD atIndex:26];
	HUD.labelText = @"载入中...";
    [HUD showWhileExecuting:@selector(firstTimeLoad) onTarget:self withObject:nil animated:YES];
    
    UISwipeGestureRecognizer* recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizer];
}

-(void)dealloc
{
    ID = nil;
    name = nil;
    lastlogin = nil;
    level = nil;
    posts = nil;
    perform = nil;
    experience = nil;
    medals = nil;
    logins = nil;
    life = nil;
    gender = nil;
    astro = nil;
    avatar = nil;
    progressIndicator = nil;
    networkQueue.delegate = nil;
    [networkQueue cancelAllOperations];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    ID = nil;
    name = nil;
    lastlogin = nil;
    level = nil;
    posts = nil;
    perform = nil;
    experience = nil;
    medals = nil;
    logins = nil;
    life = nil;
    gender = nil;
    astro = nil;
    avatar = nil;
    progressIndicator = nil;
    networkQueue.delegate = nil;
    [networkQueue cancelAllOperations];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)back:(id)sender
{
    NSFileManager *fm=[[NSFileManager alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fm contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while (filename = [e nextObject])
    {
        //NSLog(@"filename:%@",filename);
        [fm removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
    }
    [networkQueue reset];
    
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.homeViewController leftBarBtnTapped:nil];
    }
}


- (void)imageFetchComplete:(ASIHTTPRequest *)request
{
	UIImage *img = [UIImage imageWithContentsOfFile:[request downloadDestinationPath]];
	if (img) {
		[avatar setImage:img];
	}
    else
    {
        [avatar setImage:[UIImage imageNamed:@"noavatar.png"]];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"用户没有头像";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.8];
    }
    [progressIndicator setHidden:YES];
}

- (void)imageFetchFailed:(ASIHTTPRequest *)request
{
	if (!failed) {
		if ([[request error] domain] != NetworkRequestErrorDomain || [[request error] code] != ASIRequestCancelledErrorType) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"头像下载失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
			[alertView show];
		}
		failed = YES;
	}
}

-(IBAction)addFriend:(id)sender
{
    BOOL success = [BBSAPI addFriend:myBBS.mySelf.token ID:user.ID];
    if (success) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"添加好友成功";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.8];
        [addFriendButton setHidden:YES];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"添加好友失败";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.8];
        [addFriendButton setHidden:YES];
    }
}

-(IBAction)sendMail:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PostMailViewController * postMailViewController = [[PostMailViewController alloc] initWithNibName:@"PostMailViewController" bundle:nil];
    postMailViewController.postType = 2;
    postMailViewController.sentToUser = user.ID;
    postMailViewController.mDelegate = self;
    [appDelegate.homeViewController presentModalViewController:postMailViewController animated:YES];
}

-(void)dismissPostMailView
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.homeViewController dismissModalViewControllerAnimated:YES];
}

@end
