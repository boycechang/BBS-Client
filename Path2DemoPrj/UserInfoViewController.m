//
//  UserInfoViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/5/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+MJPopupViewController.h"
#import "POP.h"

@implementation UserInfoViewController
@synthesize userString;
@synthesize user;
@synthesize mDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)refreshView
{
    NSString *genderString = @"";
    if([[user.gender lowercaseString] isEqualToString:@"m"])
        genderString = @"♂";
    else if([[user.gender lowercaseString] isEqualToString:@"f"])
        genderString = @"♀";
    
    [astro setText:[NSString stringWithFormat:@"%@", [user.astro isEqualToString:@""]?@"未知":user.astro]];
    
    [ID setText:[NSString stringWithFormat:@"%@ %@", user.ID, genderString]];
    [name setText:[NSString stringWithFormat:@"%@", user.name]];
    [role setText:[NSString stringWithFormat:@"%@", user.level]];
    [posts setText:[NSString stringWithFormat:@"%i", user.posts]];
    [medals setText:[NSString stringWithFormat:@"%i", user.medals]];
    [logins setText:[NSString stringWithFormat:@"%i", user.logins]];
    [life setText:[NSString stringWithFormat:@"%i", user.life]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yy-MM-dd hh:mm"];
    NSString * lastloginstring = [dateFormatter stringFromDate:user.lastlogin];
    
    if (user.isOnline) {
        [isOnline setText:[NSString stringWithFormat:@"在线:%@",lastloginstring]];
        
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
            [isOnline setTextColor:[UIColor colorWithRed:34/255.0 green:124/255.0 blue:255/255.0 alpha:1]];
        }
        else {
            [isOnline setTextColor:[UIColor whiteColor]];
        }
    }
    else {
        [isOnline setText:[NSString stringWithFormat:@"不在线:%@",lastloginstring]];
        [isOnline setTextColor:[UIColor darkGrayColor]];
    }
}

- (void)tapAvatar:(UITapGestureRecognizer*)recognizer
{
    if (!isShowBigAvatar) {
        avatar.layer.cornerRadius = 10.0f;
        POPSpringAnimation *popOutAnimation = [POPSpringAnimation animation];
        popOutAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
        popOutAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(-5, -5, self.view.frame.size.width + 10, self.view.frame.size.height + 10)];
        popOutAnimation.springBounciness = 10.0;
        popOutAnimation.springSpeed = 10.0;
        [avatar pop_addAnimation:popOutAnimation forKey:@"pop"];
        isShowBigAvatar = YES;
    }
    else {
        avatar.layer.cornerRadius = 50.0f;
        isShowBigAvatar = NO;
        POPSpringAnimation *popOutAnimation = [POPSpringAnimation animation];
        popOutAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
        popOutAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(90, 32, 100, 100)];
        popOutAnimation.springBounciness = 10.0;
        popOutAnimation.springSpeed = 10.0;
        [avatar pop_addAnimation:popOutAnimation forKey:@"pop"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.layer.cornerRadius = 10;
    self.view.clipsToBounds = YES;
    
    isShowBigAvatar = NO;
    [addFriendButton setEnabled:NO];
    [sentMailButton setEnabled:NO];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    [activityView start];
    [self.view addSubview:activityView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.user = [BBSAPI userInfo:userString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (myBBS.mySelf.ID != nil && [myBBS.mySelf.ID isEqualToString:userString]) {
                if (myBBS.mySelf.avatar == nil) {
                    User *mySelfDetal = [BBSAPI userInfo:myBBS.mySelf.ID];
                    if (mySelfDetal) {
                        myBBS.mySelf.avatar = mySelfDetal.avatar;
                    }
                    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                    if (myBBS.mySelf.avatar != nil) {
                        [defaults setValue:[myBBS.mySelf.avatar absoluteString] forKey:@"UserAvatar"];
                    }
                }
            }
            else if (myBBS.mySelf){
                [sentMailButton setEnabled:YES];
            }
            else if (myBBS.mySelf.ID != nil && ![myBBS.mySelf.ID isEqualToString:userString]){
                [sentMailButton setEnabled:YES];
                [addFriendButton setEnabled:YES];
            }
            
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            BOOL isLoadAvatar = [defaults boolForKey:@"isLoadAvatar"];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatar:)];
            tap.numberOfTapsRequired = 1;
            [avatar addGestureRecognizer:tap];
            
            UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatar:)];
            tap2.numberOfTapsRequired = 1;
            [avatarBack addGestureRecognizer:tap2];
            
            if (isLoadAvatar && self.user.avatar != nil) {
                [avatar setImageWithURL:user.avatar];
                avatar.layer.cornerRadius = 50.0f;
                avatar.clipsToBounds = YES;
            }
            else {
                [avatar setImage:[UIImage imageNamed:@"leftbackground"]];
                avatar.layer.cornerRadius = 50.0f;
                avatar.clipsToBounds = YES;
            }
            
            [self refreshView];
            [activityView stop];
            activityView = nil;
        });
    });
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
        [self registerEffectForView:self.view depth:20];
    }
}

-(void)dealloc
{
    ID = nil;
    name = nil;
    posts = nil;
    medals = nil;
    logins = nil;
    life = nil;
    avatar = nil;
    [activityView stop];
    activityView = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    ID = nil;
    name = nil;
    posts = nil;
    medals = nil;
    logins = nil;
    life = nil;
    avatar = nil;
    [activityView stop];
    activityView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)sendMail:(id)sender
{
    PostMailViewController * postMailViewController = [[PostMailViewController alloc] init];
    postMailViewController.postType = 2;
    postMailViewController.sentToUser = user.ID;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postMailViewController];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [mDelegate presentViewController:nav animated:YES completion:nil];
}


- (void)registerEffectForView:(UIView *)aView depth:(CGFloat)depth;
{
	UIInterpolatingMotionEffect *effectX;
	UIInterpolatingMotionEffect *effectY;
    effectX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                              type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    effectY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                              type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
	
	effectX.maximumRelativeValue = @(depth);
	effectX.minimumRelativeValue = @(-depth);
	effectY.maximumRelativeValue = @(depth);
	effectY.minimumRelativeValue = @(-depth);
	
	[aView addMotionEffect:effectX];
	[aView addMotionEffect:effectY];
}

@end
