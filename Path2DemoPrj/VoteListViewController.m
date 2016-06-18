//
//  NotificationViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/7/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "VoteListViewController.h"
#import "CommonUI.h"

@implementation VoteListViewController
@synthesize mailsArray0;
@synthesize mailsArray1;
@synthesize mailsArray2;
@synthesize seg;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [customTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"投票";
    
    self.navigationController.navigationBar.barTintColor = NAVBARCOLORBLUE;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    customTableView = [[CustomNoFooterWithDeleteTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) Delegate:self];
    activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 1)];
    [self.view addSubview:customTableView];
    
    customTableView.backgroundColor = [UIColor clearColor];
    customTableView.mTableView.separatorColor = [UIColor lightGrayColor];
    customTableView.mRefreshTableHeaderView.backgroundColor = [UIColor clearColor];
    
    NSArray * itemArray = [NSArray arrayWithObjects:@"最新投票", @"热门投票", @"全部投票", nil];
    self.seg = [[UISegmentedControl alloc] initWithItems:itemArray];
    [seg setSelectedSegmentIndex:0];
    [seg setFrame:CGRectMake(70, 27, self.view.frame.size.width - 140, 30)];
    [seg addTarget:self action:@selector(segmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = seg;
    
    [activityView start];
    [self.view addSubview:activityView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (appDelegate.myBBS.voteListNew != nil) {
            self.mailsArray0 = appDelegate.myBBS.voteListNew;
            self.mailsArray1 = appDelegate.myBBS.voteListHot;
            self.mailsArray2 = appDelegate.myBBS.voteListAll;
        }
        else {
            self.mailsArray0 = [BBSAPI getVoteList:myBBS.mySelf Type:@"new"];
            self.mailsArray1 = [BBSAPI getVoteList:myBBS.mySelf Type:@"hot"];
            self.mailsArray2 = [BBSAPI getVoteList:myBBS.mySelf Type:@"all"];
   
            appDelegate.myBBS.voteListNew = self.mailsArray0;
            appDelegate.myBBS.voteListHot = self.mailsArray1;
            appDelegate.myBBS.voteListAll = self.mailsArray2;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [customTableView reloadData];
            [activityView removeFromSuperview];
            activityView = nil;
        });
    });
    
    UIBarButtonItem *menuBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menuiconwhite.png"] style:UIBarButtonItemStyleDone target:appDelegate.leftViewController action:@selector(showLeftView:)];
    self.navigationItem.leftBarButtonItem = menuBarItem;
}

-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    customTableView = nil;
    activityView = nil;
}

#pragma mark - 
#pragma mark tableViewDelegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (seg.selectedSegmentIndex) {
        case 0:
            return [mailsArray0 count];
            break;
        case 1:
            return [mailsArray1 count];
            break;
        case 2:
            return [mailsArray2 count];
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoteCellView * cell = (VoteCellView *)[tableView dequeueReusableCellWithIdentifier:@"VoteCellView"];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"VoteCellView" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    switch (seg.selectedSegmentIndex) {
        case 0:
            cell.vote = [mailsArray0 objectAtIndex:indexPath.row];
            break;
        case 1:
            cell.vote = [mailsArray1 objectAtIndex:indexPath.row];
            break;
        case 2:
            cell.vote = [mailsArray2 objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    cell.backImageView.layer.cornerRadius = 10.0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SingleVoteViewController *singleVoteViewController = [[SingleVoteViewController alloc] init];
    switch (seg.selectedSegmentIndex) {
        case 0:
            singleVoteViewController.rootVote = [mailsArray0 objectAtIndex:indexPath.row];
            break;
        case 1:
            singleVoteViewController.rootVote = [mailsArray1 objectAtIndex:indexPath.row];
            break;
        case 2:
            singleVoteViewController.rootVote = [mailsArray2 objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    [self presentPopupViewController:singleVoteViewController animationType:MJPopupViewAnimationSlideTopBottom];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

#pragma -
#pragma mark CustomtableView delegate
- (void)refreshTableHeaderDidTriggerRefresh:(UITableView *)tableView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.mailsArray0 = [BBSAPI getVoteList:myBBS.mySelf Type:@"new"];
        self.mailsArray1 = [BBSAPI getVoteList:myBBS.mySelf Type:@"hot"];
        self.mailsArray2 = [BBSAPI getVoteList:myBBS.mySelf Type:@"all"];
            
        appDelegate.myBBS.voteListNew = self.mailsArray0;
        appDelegate.myBBS.voteListHot = self.mailsArray1;
        appDelegate.myBBS.voteListAll = self.mailsArray2;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [customTableView reloadData];

        });
    });
}

-(IBAction)segmentControlValueChanged:(id)sender
{
    [customTableView.mTableView setContentOffset:CGPointMake(0, 0)];
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
