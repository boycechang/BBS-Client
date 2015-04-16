//
//  NotificationViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/7/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "NotificationViewController.h"
@implementation NotificationViewController
@synthesize showNotificationArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(IBAction)back:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.homeViewController leftBarBtnTapped:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    customTableView = [[CustomNoFooterTableView alloc] initWithFrame:CGRectMake(0, 88, self.view.frame.size.width, self.view.frame.size.height - 108) Delegate:self];
    [self.view insertSubview:customTableView atIndex:0];
    [self refreshTableView];
    
    UISwipeGestureRecognizer* recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizer];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    customTableView = nil;
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UIScrollViewDelegateMethods
//The TimeScroller needs to know what's happening with the UITableView (UIScrollView)
- (void)scrollViewDidScroll{
  
}

- (void)scrollViewDidEndDecelerating{
    
}

- (void)scrollViewWillBeginDragging{
  
}

- (void)scrollViewDidEndDragging:(BOOL)decelerate{
    if (!decelerate) {
     
    }
}


#pragma mark - 
#pragma mark tableViewDelegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.showNotificationArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (seg.selectedSegmentIndex == 2) {
        MailsViewCell * cell = (MailsViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MailsViewCell"];
        if (cell == nil) {
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"MailsViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        
        Mail * mail = [myBBS.notification.mails objectAtIndex:indexPath.row];
        cell.mail = mail;
        [cell setReadyToShow];
        
        return cell;
    }
    
    if (seg.selectedSegmentIndex == 1) {
        TopTenTableViewCell * cell = (TopTenTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TopTenTableViewCell"];
        if (cell == nil) {
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"TopTenTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
    
        Topic * topic = [myBBS.notification.ats objectAtIndex:indexPath.row];
        cell.ID = topic.ID;
        cell.title = topic.title;
        cell.author = topic.author;
        cell.board = topic.board;
        cell.unread = YES;
        [cell setReadyToShow];
        return cell;
    }
    
    if (seg.selectedSegmentIndex == 0) {
        TopTenTableViewCell * cell = (TopTenTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TopTenTableViewCell"];
        if (cell == nil) {
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"TopTenTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        
        Topic * topic = [myBBS.notification.replies objectAtIndex:indexPath.row];
        cell.ID = topic.ID;
        cell.title = topic.title;
        cell.author = topic.author;
        cell.board = topic.board;
        cell.unread = YES;
        [cell setReadyToShow];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   
{
    if (seg.selectedSegmentIndex == 2) {
        return 70;
    }
    return 80;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (seg.selectedSegmentIndex == 2) {
        SingleMailViewController * singleMailViewController = [[SingleMailViewController alloc] initWithNibName:@"SingleMailViewController" bundle:nil];
        singleMailViewController.rootMail = [myBBS.notification.mails objectAtIndex:indexPath.row];
        singleMailViewController.isForShowNotification = YES;
        singleMailViewController.mDelegate = self;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate refreshNotification];
        HomeViewController * home = appDelegate.homeViewController;
        [home.navigationController pushViewController:singleMailViewController animated:YES];
    }
    if (seg.selectedSegmentIndex == 1) {
        SingleTopicViewController * singleTopicViewController = [[SingleTopicViewController alloc] initWithNibName:@"SingleTopicViewController" bundle:nil];
        singleTopicViewController.rootTopic = [myBBS.notification.ats objectAtIndex:indexPath.row];
        singleTopicViewController.isForShowNotification = YES;
        singleTopicViewController.mDelegate = self;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        HomeViewController * home = appDelegate.homeViewController;
        [home.navigationController pushViewController:singleTopicViewController animated:YES];
    }
    if (seg.selectedSegmentIndex == 0) {
        SingleTopicViewController * singleTopicViewController = [[SingleTopicViewController alloc] initWithNibName:@"SingleTopicViewController" bundle:nil];
        singleTopicViewController.rootTopic = [myBBS.notification.replies objectAtIndex:indexPath.row];
        singleTopicViewController.isForShowNotification = YES;
        singleTopicViewController.mDelegate = self;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        HomeViewController * home = appDelegate.homeViewController;
        [home.navigationController pushViewController:singleTopicViewController animated:YES];
    }
}
-(void)showActionSheet
{
    UIActionSheet*actionSheet = [[UIActionSheet alloc] 
                                 initWithTitle:@"确定删除所有消息？"
                                 delegate:self
                                 cancelButtonTitle:@"取消"
                                 destructiveButtonTitle:@"确定"
                                 otherButtonTitles:nil, nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    [actionSheet showInView:self.view]; //show from our table view (pops up in the middle of the table)
    
}
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self doclear];
    }
}

-(IBAction)clearAll:(id)sender
{
    if (myBBS.notification.count > 0) {
        [self showActionSheet];
    }
}

-(void)clearNotification
{
    [myBBS clearNotification];
    [myBBS refreshNotification];
    [self refreshTableView];
    [HUD removeFromSuperview];
    HUD = nil;
}
- (void)doclear
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view insertSubview:HUD atIndex:1];
	HUD.labelText = @"清除消息中...";
    [HUD showWhileExecuting:@selector(clearNotification) onTarget:self withObject:nil animated:YES];
}

#pragma -
#pragma mark CustomtableView delegate
-(void)refreshTable
{
    @autoreleasepool {
        [myBBS refreshNotification];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate refreshTableView];
        [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    }
}

-(void)refreshTableView
{
    if (seg.selectedSegmentIndex == 0) {
        self.showNotificationArray = myBBS.notification.replies;
    }
    if (seg.selectedSegmentIndex == 1) {
        self.showNotificationArray = myBBS.notification.ats;
    }
    if (seg.selectedSegmentIndex == 2) {
        self.showNotificationArray = myBBS.notification.mails;
    }
    [self refreshNotificationImageView];
    [customTableView reloadData];
}

- (void)refreshTableHeaderDidTriggerRefresh:(UITableView *)tableView
{
    [NSThread detachNewThreadSelector:@selector(refreshTable) toTarget:self withObject:nil];
}

#pragma -
#pragma mark RefreshNotification delegate
-(void)refreshNotification
{
    [self refreshTable];
}

-(void)refreshNotificationImageView
{
    if ([myBBS.notification.replies count] == 0)
        [commentNotificationImageView setHidden:YES];
    else
        [commentNotificationImageView setHidden:NO];
    
    if ([myBBS.notification.ats count] == 0)
        [atNotificationImageView setHidden:YES];
    else
        [atNotificationImageView setHidden:NO];
    
    if ([myBBS.notification.mails count] == 0)
        [mailNotificationImageView setHidden:YES];
    else
        [mailNotificationImageView setHidden:NO];
}

-(IBAction)segmentControlValueChanged:(id)sender
{
    [self refreshTableView];
}
@end
