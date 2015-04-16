//
//  TopTenViewController.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "GlobalImageViewController.h"

@implementation GlobalImageViewController
@synthesize photographyArray;
@synthesize picturesArray;
@synthesize customTableView;
@synthesize readModeSeg;
@synthesize mDelegate;

- (id)init
{
    self = [super init];
    if (self) {
        photographyArray = [[NSMutableArray alloc] init];
        picturesArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.customTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) Delegate:self];
    activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 1)];
    
    customTableView.backgroundColor = [UIColor clearColor];
    customTableView.mTableView.backgroundColor = [UIColor clearColor];
    customTableView.mTableView.separatorColor = [UIColor clearColor];
    customTableView.mRefreshTableHeaderView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:customTableView];

    [activityView start];
    [self.view addSubview:activityView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (appDelegate.myBBS.photographyArray != nil && appDelegate.myBBS.picturesArray != nil ) {
            self.photographyArray = [appDelegate.myBBS.photographyArray mutableCopy];
            self.picturesArray = [appDelegate.myBBS.picturesArray mutableCopy];
        }
        else {
            NSArray * topics = [BBSAPI photographyTopics:0];
            [photographyArray addObjectsFromArray:topics];
            topics = [BBSAPI picturesTopics:0];
            [picturesArray addObjectsFromArray:topics];
            
            appDelegate.myBBS.photographyArray = photographyArray;
            appDelegate.myBBS.picturesArray = picturesArray;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [customTableView reloadData];
            [activityView stop];
            activityView = nil;
        });
    });

    NSArray * itemArray = [NSArray arrayWithObjects:@"摄影", @"贴图", nil];
    self.readModeSeg = [[UISegmentedControl alloc] initWithItems:itemArray];
    [readModeSeg setSelectedSegmentIndex:0];
    [readModeSeg setFrame:CGRectMake(70, 27, self.view.frame.size.width - 140, 30)];
    [readModeSeg addTarget:self action:@selector(readModeSegChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = readModeSeg;
    
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
    [activityView stop];
    activityView = nil;
}

#pragma mark -
#pragma mark tableViewDelegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (readModeSeg.selectedSegmentIndex) {
        case 0:
            return [photographyArray count];
            break;
        case 1:
            return [picturesArray count];
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identi = @"GlobalImageTableViewCell";
    GlobalImageTableViewCell * cell = (GlobalImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identi];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"GlobalImageTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    Topic *topic;
    switch (readModeSeg.selectedSegmentIndex) {
        case 0:
            topic = [photographyArray objectAtIndex:indexPath.row];
            break;
        case 1:
            topic = [picturesArray objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }

    cell.ID = topic.ID;
    cell.title = topic.title;
    cell.time = topic.time;
    cell.author = topic.author;
    cell.replies = topic.replies;
    cell.read = topic.read;
    cell.board = nil;
    cell.top = topic.top;
    cell.mark = topic.mark;
    cell.unread = YES;
    cell.backgroundColor = [UIColor clearColor];
    
    if (topic.attachments != nil && [topic.attachments count] > 0) {
        Attachment * att = [topic.attachments objectAtIndex:0];
        cell.imageURL = [NSURL URLWithString:att.attUrl];
    }
    else
        cell.imageURL = nil;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   
{
    return 310;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    Topic *topic;
    switch (readModeSeg.selectedSegmentIndex) {
        case 0:
            topic = [photographyArray objectAtIndex:indexPath.row];
            break;
        case 1:
            topic = [picturesArray objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    SingleTopicViewController * singleTopicViewController = [[SingleTopicViewController alloc] initWithRootTopic:topic];
    [self.navigationController pushViewController:singleTopicViewController animated:YES];
}

#pragma -
#pragma mark CustomtableView delegate
- (void)refreshTableHeaderDidTriggerRefresh:(UITableView *)tableView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        switch (readModeSeg.selectedSegmentIndex) {
            case 0:
            {
                
                NSArray * topics = [BBSAPI photographyTopics:0];
                [photographyArray removeAllObjects];
                [photographyArray addObjectsFromArray:topics];
                
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelegate.myBBS.photographyArray = photographyArray;
                    
            }
                break;
            case 1:
            {
                NSArray * topics = [BBSAPI picturesTopics:0];
                [picturesArray removeAllObjects];
                [picturesArray addObjectsFromArray:topics];
                
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelegate.myBBS.picturesArray = picturesArray;
            }
            default:
                break;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [customTableView reloadData];
        });
    });
}

- (void)refreshTableFooterDidTriggerRefresh:(UITableView *)tableView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        switch (readModeSeg.selectedSegmentIndex) {
            case 0:
            {
                NSArray * topics = [BBSAPI photographyTopics:[photographyArray count]];
                [photographyArray addObjectsFromArray:topics];
                
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelegate.myBBS.photographyArray = photographyArray;
            }
                break;
            case 1:
            {
                NSArray * topics = [BBSAPI picturesTopics:[picturesArray count]];
                [picturesArray addObjectsFromArray:topics];
                
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelegate.myBBS.picturesArray = picturesArray;
            }
            default:
                break;
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

@end
