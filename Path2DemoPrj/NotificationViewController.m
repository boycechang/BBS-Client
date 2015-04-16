//
//  NotificationViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/7/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "NotificationViewController.h"
#import "CommonUI.h"

@implementation NotificationViewController
@synthesize atArray;
@synthesize replyArray;
@synthesize seg;
@synthesize atImageView;
@synthesize replyImageView;

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
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"提醒";
    
    self.navigationController.navigationBar.barTintColor = NAVBARCOLORBLUE;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
     myBBS = appDelegate.myBBS;
    
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)];
    NSArray * itemArray = [NSArray arrayWithObjects:@"回复", @"@我", nil];
    self.seg = [[UISegmentedControl alloc] initWithItems:itemArray];
    [seg setSelectedSegmentIndex:0];
    [seg setFrame:CGRectMake(6, 7, self.view.frame.size.width - 10, 30)];
    [seg addTarget:self action:@selector(segmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [toolbar addSubview:seg];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.replyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(140, 17, 10, 10)];
        self.atImageView = [[UIImageView alloc] initWithFrame:CGRectMake(290, 17, 10, 10)];
    }
    else {
        self.replyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(300, 17, 10, 10)];
        self.atImageView = [[UIImageView alloc] initWithFrame:CGRectMake(700, 17, 10, 10)];
    }
    
    [replyImageView setBackgroundColor:[UIColor redColor]];
    [atImageView setBackgroundColor:[UIColor redColor]];
    
    replyImageView.layer.cornerRadius = 5.0f;
    replyImageView.clipsToBounds = YES;
    atImageView.layer.cornerRadius = 5.0f;
    atImageView.clipsToBounds = YES;
    
    [replyImageView setHidden:YES];
    [atImageView setHidden:YES];
    
    
    [toolbar addSubview:replyImageView];
    [toolbar addSubview:atImageView];
    [self.view addSubview:toolbar];
    
    UIBarButtonItem *clearButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearAll:)];
    self.navigationItem.rightBarButtonItem = clearButton;
    
    customTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 108, self.view.frame.size.width, self.view.frame.size.height - 108) Delegate:self];
    activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 1)];
    
    [self.view insertSubview:customTableView atIndex:0];
    [activityView start];
    [self.view addSubview:activityView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (appDelegate.myBBS.notification != nil && appDelegate.myBBS.notification.at != nil) {
            self.atArray = appDelegate.myBBS.notification.at;
            self.replyArray = appDelegate.myBBS.notification.reply;
        }
        else {
            [appDelegate refreshNotification];
            self.atArray = [BBSAPI getNotification:myBBS.mySelf Type:@"at" Start:0 Limit:50];
            self.replyArray = [BBSAPI getNotification:myBBS.mySelf Type:@"reply" Start:0 Limit:50];
            
            appDelegate.myBBS.notification.at = self.atArray;
            appDelegate.myBBS.notification.reply = self.replyArray;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshNotificationImageView];
            [customTableView reloadData];
            [activityView removeFromSuperview];
            activityView = nil;
        });
    });
    
    UIBarButtonItem *backBarItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"down"] style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backBarItem;
}

-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
-(void)dealloc
{
    customTableView = nil;
}

#pragma mark - 
#pragma mark tableViewDelegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (seg.selectedSegmentIndex) {
        case 0:
            return [replyArray count];
            break;
        case 1:
            return [atArray count];
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopTenTableViewCell * cell = (TopTenTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TopTenTableViewCell"];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"TopTenTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    Topic * topic;
    switch (seg.selectedSegmentIndex) {
        case 0:
            topic = [replyArray objectAtIndex:indexPath.row];
            break;
        case 1:
            topic = [atArray objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    
    cell.ID = topic.ID;
    cell.title = topic.title;
    cell.author = topic.author;
    cell.board = topic.board;
    cell.unread = topic.unread;
    cell.hasAtt = topic.hasAtt;
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Topic *topic;
    switch (seg.selectedSegmentIndex) {
        case 0:
            topic = [replyArray objectAtIndex:indexPath.row];
            break;
        case 1:
            topic = [atArray objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    SingleTopicViewController * singleTopicViewController = [[SingleTopicViewController alloc] initWithRootTopic:topic];
    [self.navigationController pushViewController:singleTopicViewController animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [BBSAPI deleteNotification:myBBS.mySelf Type:(seg.selectedSegmentIndex == 0)? @"reply" : @"at" ID:topic.index];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [myBBS refreshNotification];
        [appDelegate refreshNotification];
        topic.unread = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshNotificationImageView];
            [customTableView reloadData];
        });
    });
}

-(void)showActionSheet
{
    UIActionSheet*actionSheet = [[UIActionSheet alloc] 
                                 initWithTitle:@"清除所有提醒？"
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
    if (myBBS.notification.atCount + myBBS.notification.replyCount > 0) {
        [self showActionSheet];
    }
}

-(void)clearNotification
{
    [myBBS clearNotification];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate refreshNotification];
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void)doclear
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view insertSubview:HUD atIndex:1];
	HUD.labelText = @"清除提醒...";
    [HUD showWhileExecuting:@selector(clearNotification) onTarget:self withObject:nil animated:YES];
}

#pragma -
#pragma mark CustomtableView delegate

- (void)refreshTableHeaderDidTriggerRefresh:(UITableView *)tableView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate refreshNotification];
        
        self.atArray = [BBSAPI getNotification:myBBS.mySelf Type:@"at" Start:0 Limit:50];
        self.replyArray = [BBSAPI getNotification:myBBS.mySelf Type:@"reply" Start:0 Limit:50];
        
        appDelegate.myBBS.notification.at = self.atArray;
        appDelegate.myBBS.notification.reply = self.replyArray;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshNotificationImageView];
            [customTableView reloadData];
        });
    });
}

- (void)refreshTableFooterDidTriggerRefresh:(UITableView *)tableView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray * loadMoreArray;
        switch (seg.selectedSegmentIndex) {
            case 0:
                loadMoreArray = replyArray;
                break;
            case 1:
                loadMoreArray = atArray;
                break;
            default:
                break;
        }
        NSArray * topics = [BBSAPI getNotification:myBBS.mySelf Type:(seg.selectedSegmentIndex == 0? @"reply" : @"at") Start:[loadMoreArray count] Limit:50];
        
        NSMutableArray * moreArray = [NSMutableArray arrayWithArray:loadMoreArray];
        [moreArray addObjectsFromArray:topics];
        
        switch (seg.selectedSegmentIndex) {
            case 0:
                self.replyArray = moreArray;
                myBBS.notification.reply = self.replyArray;
                break;
            case 1:
                self.atArray = moreArray;
                myBBS.notification.at = self.atArray;
                break;
            default:
                break;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [customTableView reloadData];
        });
    });
}



-(void)refreshNotificationImageView
{
    if (myBBS.notification.replyCount == 0)
        [replyImageView setHidden:YES];
    else
        [replyImageView setHidden:NO];
    
    if (myBBS.notification.atCount == 0)
        [atImageView setHidden:YES];
    else
        [atImageView setHidden:NO];
}


-(IBAction)segmentControlValueChanged:(id)sender
{
    [customTableView reloadData];
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
