//
//  AboutViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "LeftViewController.h"
#import "ImageBlur.m"
#import "TumblrLikeMenu.h"
#import "CommonUI.h"
#import "ImageBlur.m"
#import "HotTopicsViewController.h"

@implementation LeftViewController
@synthesize mainTableView;
@synthesize animator;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSData * backImageData = [defaults dataForKey:@"backImage"];
    
    if (backImageData == nil) {
        UIImage * pickedImage = [UIImage imageNamed:@"leftbackground"];
        NSData * data = UIImagePNGRepresentation([pickedImage applyBlurWithRadius:10.f tintColor:nil saturationDeltaFactor:1.8 maskImage:nil]);
        [defaults setObject:data forKey:@"backImage"];
    }
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.title = @"北邮人";
    
    search.delegate = self;
    search.alpha = 0.8;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    tableTitles = [NSArray arrayWithObjects:@"热帖", @"版面", nil];
    tableIcon1 = [NSArray arrayWithObjects:@"TopTenIcon", @"BoardIcon", nil];
    
    [self changeLeftBack];
    
    NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"AccountInfoHeaderView" owner:self options:nil];
    self.accountInfoViewHeader = [array objectAtIndex:0];
    [self.accountInfoViewHeader refresh];
    self.accountInfoViewHeader.delegate = self;

    self.airMenuController = [XDKAirMenuController sharedMenu];
    self.airMenuController.airDelegate = self;
    
    [self.view addSubview:self.airMenuController.view];
    [self addChildViewController:self.airMenuController];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    tableTitles = nil;
    search = nil;
    myBBS = nil;
}

-(void)changeLeftBack
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSData * backImageData = [defaults dataForKey:@"backImage"];
    UIImage * image = [UIImage imageWithData:backImageData];
    [leftBackView setImage:image];
}

#pragma mark - UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 220.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.accountInfoViewHeader;
}

#pragma mark - UITableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableTitles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MenuCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *bgViewIndication = [[UIView alloc] init];
    
    [bgViewIndication setFrame:CGRectMake(0, 1, 200, 43)];
    bgViewIndication.backgroundColor = NAVBARCOLORBLUE;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:bgViewIndication];
    bgView.clipsToBounds = YES;
    bgView.layer.cornerRadius = 22.0;
    cell.selectedBackgroundView = bgView;
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:20]];
    [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    cell.textLabel.text = [tableTitles objectAtIndex:indexPath.row];
    [cell.imageView setImage:[UIImage imageNamed:[tableIcon1 objectAtIndex:indexPath.row]]];
	return cell;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark - LoginViewDelegate
-(void)LoginSuccess
{
    [self.accountInfoViewHeader refresh];
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

#pragma mark - AboutViewDelegate
-(void)logout{
    [myBBS userLogout];
    [self.accountInfoViewHeader refresh];
}

#pragma mark - XDKAirMenuDelegate

- (UIViewController*)airMenu:(XDKAirMenuController*)airMenu viewControllerAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0) {
        TopTenViewController * topTenViewController = [[TopTenViewController alloc] init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:topTenViewController];
        return nav;
    }
    if (indexPath.row == 1 && indexPath.section == 0) {
        BoardsViewController * boardsViewController = [[BoardsViewController alloc] init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:boardsViewController];
        return nav;
    }
    if (indexPath.row == 2 && indexPath.section == 0) {
        VoteListViewController *voteListViewController = [[VoteListViewController alloc] init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:voteListViewController];
        return nav;
    }
    
    return nil;
}

- (UITableView*)tableViewForAirMenu:(XDKAirMenuController*)airMenu
{
    return self.mainTableView;
}

- (IBAction)showLeftView:(id)sender
{
    [self.airMenuController openMenuAnimated];
}


#pragma mark TumblrMenu
- (IBAction)showTumblrMune:(id)sender
{
    TumblrLikeMenuItem *menuItem0 = [[TumblrLikeMenuItem alloc] initWithImage:[UIImage imageNamed:@"TumblrNews"]
                                                             highlightedImage:[UIImage imageNamed:@"TumblrNews"]
                                                                         text:@"公告活动"];
    
    TumblrLikeMenuItem *menuItem1 = [[TumblrLikeMenuItem alloc] initWithImage:[UIImage imageNamed:@"TumblrVote"]
                                                             highlightedImage:[UIImage imageNamed:@"TumblrVote"]
                                                                         text:@"全站投票"];
    
    TumblrLikeMenuItem *menuItem2 = [[TumblrLikeMenuItem alloc] initWithImage:[UIImage imageNamed:@"TumblrSettings"]
                                                             highlightedImage:[UIImage imageNamed:@"TumblrSettings"]
                                                                         text:@"设置"];
    
    NSArray *subMenus = @[menuItem0, menuItem1, menuItem2];
    TumblrLikeMenu *menu = [[TumblrLikeMenu alloc] initWithFrame:self.view.bounds
                                                        subMenus:subMenus
                                                             tip:@"取消"];
    menu.selectBlock = ^(NSUInteger index) {
        switch (index) {
            case 0: {
                GlobalViewController * globalViewController = [[GlobalViewController alloc] init];
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:globalViewController];
                nav.modalPresentationStyle = UIModalPresentationCustom;
                
                self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:nav];
                self.animator.dragable = YES;
                self.animator.direction = ZFModalTransitonDirectionBottom;
                nav.transitioningDelegate = self.animator;
                [self presentViewController:nav animated:YES completion:nil];
            }
                break;
            case 1: {
                VoteListViewController *voteListViewController = [[VoteListViewController alloc] init];
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:voteListViewController];
                nav.modalPresentationStyle = UIModalPresentationCustom;
                
                self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:nav];
                self.animator.dragable = YES;
                self.animator.direction = ZFModalTransitonDirectionBottom;
                nav.transitioningDelegate = self.animator;
                [self presentViewController:nav animated:YES completion:nil];
            }
                break;
            case 2: {
                AboutViewController * aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
                aboutViewController.mDelegate = self;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
                nav.modalPresentationStyle = UIModalPresentationCustom;
                
                self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:nav];
                self.animator.dragable = YES;
                self.animator.direction = ZFModalTransitonDirectionBottom;
                nav.transitioningDelegate = self.animator;
                
                [self presentViewController:nav animated:YES completion:nil];
            }
                break;
            default:
                break;
        }

    };
    [menu show];
}


#pragma mark AccountInfoHeaderViewDelegate
- (void)loginButtonClicked {
    LoginViewController * loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    loginViewController.mDelegate = self;
    [self presentViewController:loginViewController animated:YES completion:nil];
}

- (void)favButtonClicked {
    AllFavViewController *allFavViewController = [[AllFavViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:allFavViewController];
    nav.modalPresentationStyle = UIModalPresentationCustom;
    
    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:nav];
    self.animator.dragable = YES;
    self.animator.direction = ZFModalTransitonDirectionBottom;
    nav.transitioningDelegate = self.animator;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)mailButtonClicked {
    MailBoxViewController * mailBoxViewController = [[MailBoxViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:mailBoxViewController];
    nav.modalPresentationStyle = UIModalPresentationCustom;
    
    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:nav];
    self.animator.dragable = YES;
    self.animator.direction = ZFModalTransitonDirectionBottom;
    nav.transitioningDelegate = self.animator;
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)notificationButtonClicked
{
    NotificationViewController * notificationViewController = [[NotificationViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:notificationViewController];
    nav.modalPresentationStyle = UIModalPresentationCustom;
    
    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:nav];
    self.animator.dragable = YES;
    self.animator.direction = ZFModalTransitonDirectionBottom;
    nav.transitioningDelegate = self.animator;
    
    [self presentViewController:nav animated:YES completion:nil];
}

@end
