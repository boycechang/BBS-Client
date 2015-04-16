//
//  BoardsViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/1/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "FriendsViewController.h"

@implementation FriendsViewController
@synthesize allFriendsArray;
@synthesize onlineFriendsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)firstTimeLoad
{
    self.onlineFriendsArray = [BBSAPI onlineFriends:myBBS.mySelf.token];
    self.allFriendsArray = [BBSAPI allFriends:myBBS.mySelf.token];
    [HUD removeFromSuperview];
    showArray = onlineFriendsArray;
    customTableView = [[CustomNoFooterWithDeleteTableView alloc] initWithFrame:CGRectMake(0, 44, 290, self.view.frame.size.height - 44) Delegate:self];
    customTableView.mTableView.backgroundColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
    customTableView.mRefreshTableHeaderView.backgroundColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
    [customTableView.mTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:customTableView];
    [customTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, 290, rect.size.height - 64)];
    self.view.backgroundColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
    self.title = @"好友";
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view insertSubview:HUD atIndex:0];
    HUD.labelText = @"载入中...";
    [HUD showWhileExecuting:@selector(firstTimeLoad) onTarget:self withObject:nil animated:YES];
    
    UISwipeGestureRecognizer* recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizer];
}

-(void)dealloc
{
    customTableView = nil;
    showArray = nil;
}

-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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


#pragma mark UIScrollViewDelegateMethods
//The TimeScroller needs to know what's happening with the UITableView (UIScrollView)
- (void)scrollViewDidScroll{
    // [_timeScroller scrollViewDidScroll];
}

- (void)scrollViewDidEndDecelerating{
    // [_timeScroller scrollViewDidEndDecelerating];
}

- (void)scrollViewWillBeginDragging{
    //  [_timeScroller scrollViewWillBeginDragging];
}

- (void)scrollViewDidEndDragging:(BOOL)decelerate{
    
}
//You should return an NSDate related to the UITableViewCell given. This will be
//the date displayed when the TimeScroller is above that cell.
- (UITableView *)tableViewForTimeScroller:(TimeScroller *)timeScroller {
    return nil;
}
- (NSDate *)dateForCell:(UITableViewCell *)cell {
    return nil;
}

#pragma mark - UITableView delegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [showArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   
{
    return 44;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    User * user = [showArray objectAtIndex:indexPath.row];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    BOOL * isLoadAvatar = [defaults boolForKey:@"isLoadAvatar"];
    UserInfoViewController * userInfoViewController;
    if (isLoadAvatar) {
        userInfoViewController = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
    }
    else {
        userInfoViewController = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController_noAvatar" bundle:nil];
    }

    userInfoViewController.userString = user.ID;

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    HomeViewController * home = appDelegate.homeViewController;
    [home restoreViewLocation];
    [home removeOldViewController];
    home.realViewController = userInfoViewController;
    [home showViewController:user.ID];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCellView * cell = (FriendCellView *)[tableView dequeueReusableCellWithIdentifier:@"FriendCellView"];
    if (cell == nil) {
        cell = [[FriendCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendCellView"];
    }
    
    cell.user = [showArray objectAtIndex:indexPath.row];
    [cell setReadyToShow];
	return cell;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (seg.selectedSegmentIndex) {
        case 0:
            return UITableViewCellEditingStyleNone;
            break;
        case 1:
            return UITableViewCellEditingStyleDelete;
            break;
        default:
            break;
    }
    return UITableViewCellEditingStyleNone;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
    User * user = [showArray objectAtIndex:indexPath.row];
    BOOL deletFriend = [BBSAPI deletFriend:myBBS.mySelf.token ID:user.ID];
    if (deletFriend) {
        
        NSMutableArray * newallFriendsArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [allFriendsArray count]; i++) {
            if (i != indexPath.row) {
                [newallFriendsArray addObject:[allFriendsArray objectAtIndex:i]];
            }
        }
        allFriendsArray = newallFriendsArray;
        showArray = allFriendsArray;
        [customTableView.mTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    else {

    }
}



#pragma -
#pragma mark CustomtableView delegate
-(void)refreshTable
{
    @autoreleasepool {
        self.onlineFriendsArray = [BBSAPI onlineFriends:myBBS.mySelf.token];
        self.allFriendsArray = [BBSAPI allFriends:myBBS.mySelf.token];
        switch (seg.selectedSegmentIndex) {
            case 0:
                showArray = onlineFriendsArray;
                break;
            case 1:
                showArray = allFriendsArray;
                break;
            default:
                break;
        }
        
        [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    }
}
-(void)refreshTableView
{
    [customTableView reloadData];
}

- (void)refreshTableHeaderDidTriggerRefresh:(UITableView *)tableView
{
    [NSThread detachNewThreadSelector:@selector(refreshTable) toTarget:self withObject:nil];
}



-(IBAction)segmentControlValueChanged:(id)sender
{
    UISegmentedControl *myUISegmentedControl=(UISegmentedControl *)sender;
    switch (myUISegmentedControl.selectedSegmentIndex) {
        case 0:
            showArray = onlineFriendsArray;
            break;
        case 1:
            showArray = allFriendsArray;
            break;
        default:
            break;
    }
    [customTableView reloadData];
}




@end
