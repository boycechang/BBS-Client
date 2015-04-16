//
//  BoardsViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/1/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "AddPostUserViewController.h"

@implementation AddPostUserViewController
@synthesize onlineFriendsArray;
@synthesize allFriendsArray;
@synthesize mDelegate;

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
    showArray = onlineFriendsArray;
    customTableView = [[CustomNoFooterWithDeleteTableView alloc] initWithFrame:CGRectMake(0, 88, 320, self.view.frame.size.height-88) Delegate:self];
    [self.view addSubview:customTableView];
    [customTableView reloadData];
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    [editFriendButton setHidden:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view insertSubview:HUD atIndex:0];
    HUD.labelText = @"载入中...";
    [HUD showWhileExecuting:@selector(firstTimeLoad) onTarget:self withObject:nil animated:YES];
    [HUD release];
    
}
-(IBAction)back:(id)sender
{
    [mDelegate dismissAddUserView];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc{
    [super dealloc];
    [allFriendsArray release];
    allFriendsArray = nil;
    [onlineFriendsArray release];
    onlineFriendsArray = nil;
    [customTableView release];
    customTableView = nil;
    showArray = nil;
    
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

-(void)clearCellBack:(UITableViewCell *)cell
{
    cell.backgroundColor = [UIColor clearColor];
}
// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell * cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightTextColor];
    [self performSelector:@selector(clearCellBack:) withObject:cell afterDelay:0.5];
    
    User * user = [showArray objectAtIndex:indexPath.row];
    [mDelegate didAddUser:user.ID];
    [mDelegate dismissAddUserView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCellView * cell = (FriendCellView *)[tableView dequeueReusableCellWithIdentifier:@"FriendCellView"];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"FriendCellView" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.user = [showArray objectAtIndex:indexPath.row];
    [cell setReadyToShow];
	return cell;
}





#pragma -
#pragma mark CustomtableView delegate
-(void)refreshTable
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.onlineFriendsArray = [BBSAPI onlineFriends:myBBS.mySelf.token];
    self.allFriendsArray = [BBSAPI allFriends:myBBS.mySelf.token];
    
    switch (seg.selectedSegmentIndex) {
        case 0:
            [editFriendButton setHidden:YES];
            showArray = onlineFriendsArray;
            break;
        case 1:
            [editFriendButton setHidden:NO];
            showArray = allFriendsArray;
            break;
        default:
            break;
    }
    
    [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    [pool release];
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
            [editFriendButton setHidden:YES];
            showArray = onlineFriendsArray;
            break;
        case 1:
            [editFriendButton setHidden:NO];
            showArray = allFriendsArray;
            break;
        default:
            break;
    }
    [customTableView reloadData];
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



@end
