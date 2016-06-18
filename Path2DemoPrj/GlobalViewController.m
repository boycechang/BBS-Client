//
//  TopTenViewController.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "GlobalViewController.h"
#import "FTPagingViewController.h"

@implementation GlobalViewController
@synthesize newsArray;
@synthesize customTableView;
@synthesize mDelegate;

- (id)init {
    self = [super init];
    if (self) {
        newsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.5 blue:1 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    if (self.mode == 0) {
        self.title = @"公告";
    } else {
        self.title = @"活动";
    }
    
    self.customTableView = [[CustomNoFooterWithDeleteTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) Delegate:self];
    activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    customTableView.mTableView.separatorColor = [UIColor lightGrayColor];
    customTableView.mRefreshTableHeaderView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:customTableView];

    [activityView start];
    [self.view addSubview:activityView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (self.mode == 0) {
            if (appDelegate.myBBS.newsArray != nil) {
                self.newsArray = [appDelegate.myBBS.newsArray mutableCopy];
            } else {
                [newsArray addObjectsFromArray:[BBSAPI boardTopics:@"byr_bulletin" Start:0 Limit:50 User:nil Mode:6]];
                appDelegate.myBBS.newsArray = newsArray;
            }
        } else {
            if (appDelegate.myBBS.newsArray != nil) {
                self.newsArray = [appDelegate.myBBS.actionsArray mutableCopy];
            } else {
                [newsArray addObjectsFromArray:[BBSAPI hotTopics]];
                appDelegate.myBBS.actionsArray = newsArray;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [customTableView reloadData];
            [activityView stop];
            activityView = nil;
        });
    });
}

-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [activityView stop];
    activityView = nil;
}

#pragma mark -
#pragma mark tableViewDelegate

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [newsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identi = @"GlobalViewCell";
    GlobalViewCell * cell = (GlobalViewCell *)[tableView dequeueReusableCellWithIdentifier:identi];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"GlobalViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    
    Topic *topic = [newsArray objectAtIndex:indexPath.row];

    cell.ID = topic.ID;
    cell.title = topic.title;
    cell.time = topic.time;
    cell.author = topic.author;
    cell.replies = topic.replies;
    cell.read = topic.read;
    cell.board = topic.board;
    cell.top = topic.top;
    cell.mark = topic.mark;
    cell.boardLabel.hidden = YES;
    cell.readandreplyLabel.hidden = YES;
    cell.authorLabel.hidden = YES;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.unread = YES;
    cell.hasAtt = topic.hasAtt;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   
{
    return 70;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    Topic *topic = [newsArray objectAtIndex:indexPath.row];
    SingleTopicViewController * singleTopicViewController = [[SingleTopicViewController alloc] initWithRootTopic:topic];
    [self.navigationController pushViewController:singleTopicViewController animated:YES];
}

#pragma -
#pragma mark CustomtableView delegate
- (void)refreshTableHeaderDidTriggerRefresh:(UITableView *)tableView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (self.mode == 0) {
            [newsArray addObjectsFromArray:[BBSAPI boardTopics:@"byr_bulletin" Start:0 Limit:50 User:nil Mode:6]];
            appDelegate.myBBS.newsArray = newsArray;
        } else {
            [newsArray addObjectsFromArray:[BBSAPI hotTopics]];
            
            appDelegate.myBBS.actionsArray = newsArray;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [customTableView reloadData];
        });
    });
}

-(IBAction)readModeSegChanged:(id)sender
{
    [customTableView.mTableView setContentOffset:CGPointMake(0, 0)];
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

- (NSArray *)leftNavigationBarItemsInPagingViewController:(FTPagingViewController *)controller {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIBarButtonItem *menuBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menuiconwhite.png"] style:UIBarButtonItemStyleDone target:appDelegate.leftViewController action:@selector(showLeftView:)];
    return @[menuBarItem];
}
@end
