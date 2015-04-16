//
//  TopTenViewController.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "TopicsViewController.h"

@implementation TopicsViewController
@synthesize board;
@synthesize topTenArray;
@synthesize searchArray;
@synthesize customTableView;
@synthesize readModeSeg;

- (id)init
{
    self = [super init];
    if (self) {
        topTenArray = [[NSMutableArray alloc] init];
        searchArray = [[NSMutableArray alloc] init];
        readModeSegIsShowing = NO;
        isSearching = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [customTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = board.debugDescription;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    UIBarButtonItem *composeButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(postNewTopic)];
    UIBarButtonItem *changeButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"eye"] style:UIBarButtonItemStylePlain target:self action:@selector(changeReadMode)];
    NSArray * array = [NSArray arrayWithObjects:composeButton, changeButton, nil];
    self.navigationItem.rightBarButtonItems = array;
    
    
    if (self.navigationController != nil) {
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
            [self setAutomaticallyAdjustsScrollViewInsets:NO];
            self.customTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) Delegate:self];
            activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 1)];
        }
        else {
            self.customTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) Delegate:self];
            activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
        }
    }
    else {
        self.customTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) Delegate:self];
        activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    }
    
    [self.view addSubview:customTableView];

    [activityView start];
    [self.view addSubview:activityView];

    NSArray * itemArray = [NSArray arrayWithObjects:@"全部帖", @"文摘区", @"同主题", @"精华区", nil];
    self.readModeSeg = [[UISegmentedControl alloc] initWithItems:itemArray];
    [readModeSeg setSelectedSegmentIndex:2];
    [readModeSeg setFrame:CGRectMake(0, 0, self.view.frame.size.width - 110, 30)];
    [readModeSeg addTarget:self action:@selector(readModeSegChanged:) forControlEvents:UIControlEventValueChanged];
    
    NSArray * viewArray = [[NSBundle mainBundle] loadNibNamed:@"BFNavigationBarDrawer" owner:self options:nil];
    self.drawer = [viewArray objectAtIndex:0];
    self.drawer.customView = self.customTableView;
	
	// Add some buttons to the drawer.
    UIBarButtonItem *button0 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"star"] style:UIBarButtonItemStylePlain target:self action:@selector(addFavBoard)];
	UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithCustomView:readModeSeg];
	UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:0];
    UIBarButtonItem *button3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearch)];
    
	self.drawer.toolbar.items = @[button0, button1, button2, button3];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        curMode = 2;
        modeContent = [[NSArray alloc] initWithObjects:@"全部帖",@"文摘区",@"同主题",@"精华区", nil];
        NSArray * topics = [BBSAPI boardTopics:board.name Start:0 Limit:50 User:myBBS.mySelf Mode:curMode UserOnline:&userOnline PostToday:&postToday PostAll:&postAll];
        [topTenArray addObjectsFromArray:topics];
        dispatch_async(dispatch_get_main_queue(), ^{
            [customTableView reloadData];
            [activityView stop];
            activityView = nil;
            
            self.drawer.userOnline.text = [NSString stringWithFormat:@"%i", userOnline];
            self.drawer.postToday.text = [NSString stringWithFormat:@"%i", postToday];
            self.drawer.postAll.text = [NSString stringWithFormat:@"%i", postAll];
        });
    });
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
    if (isSearching) {
        return [searchArray count];
    }
    
    return [topTenArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identi = @"TopTenTableViewCell";
    TopTenTableViewCell * cell = (TopTenTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identi];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"TopTenTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    Topic * topic;
    if (isSearching) {
        topic = [searchArray objectAtIndex:indexPath.row];
    } else {
        topic = [topTenArray objectAtIndex:indexPath.row];
    }
    
    cell.ID = topic.ID;
    cell.title = topic.title;
    cell.time = topic.time;
    cell.author = topic.author;
    cell.replies = topic.replies;
    cell.read = topic.read;
    cell.board = topic.board;
    cell.board = nil;
    cell.top = topic.top;
    
    if (topic.top) {
        cell.articleTitleLabel.textColor = [UIColor redColor];
    } else {
        cell.articleTitleLabel.textColor = [UIColor blackColor];
    }
    cell.mark = topic.mark;
    cell.hasAtt = topic.hasAtt;
    cell.unread = YES;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   
{
    return 70;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    Topic * topic;
    if (isSearching) {
        topic = [searchArray objectAtIndex:indexPath.row];
    } else {
        topic = [topTenArray objectAtIndex:indexPath.row];
    }
    
    SingleTopicViewController * singleTopicViewController = [[SingleTopicViewController alloc] initWithRootTopic:topic];
    [self.navigationController pushViewController:singleTopicViewController animated:YES];
}

#pragma -
#pragma mark CustomtableView delegate
- (void)refreshTableHeaderDidTriggerRefresh:(UITableView *)tableView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (isSearching) {
            NSArray * topics = [BBSAPI searchTopics:searchString start:0 User:myBBS.mySelf BoardName:board.name];
            [searchArray removeAllObjects];
            [searchArray addObjectsFromArray:topics];
        } else {
            NSArray * topics = [BBSAPI boardTopics:board.name Start:0 Limit:50 User:myBBS.mySelf Mode:curMode UserOnline:&userOnline PostToday:&postToday PostAll:&postAll];
            [topTenArray removeAllObjects];
            [topTenArray addObjectsFromArray:topics];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [customTableView reloadData];
        });
    });
}

- (void)refreshTableFooterDidTriggerRefresh:(UITableView *)tableView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (isSearching) {
            NSArray * topics = [BBSAPI searchTopics:searchString start:[searchArray count] User:myBBS.mySelf BoardName:board.name];
            [searchArray addObjectsFromArray:topics];
        } else {
            NSArray * topics = [BBSAPI boardTopics:board.name Start:[topTenArray count] Limit:50 User:myBBS.mySelf Mode:curMode UserOnline:&userOnline PostToday:&postToday PostAll:&postAll];
            [topTenArray addObjectsFromArray:topics];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [customTableView reloadData];
        });
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (readModeSegIsShowing) {
        [self.drawer hideAnimated:YES];
        readModeSegIsShowing = NO;
    }
}

- (void)postNewTopic
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.myBBS.mySelf == nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先登录";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
    }
    else {
        PostTopicViewController * postTopicViewController = [[PostTopicViewController alloc] init];
        postTopicViewController.postType = 0;
        postTopicViewController.boardName = board.name;
        postTopicViewController.mDelegate = nil;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postTopicViewController];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)addFavBoard
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.myBBS.mySelf == nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先登录";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL success = [BBSAPI addFavBoard:appDelegate.myBBS.mySelf BoardName:board.name];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(success){
                    if (readModeSegIsShowing) {
                        [self.drawer hideAnimated:YES];
                        readModeSegIsShowing = NO;
                    }
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"收藏版面成功";
                    hud.margin = 30.f;
                    hud.yOffset = 0.f;
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:0.5];
                } else{
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"收藏版面失败";
                    hud.margin = 30.f;
                    hud.yOffset = 0.f;
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:0.5];
                }
            });
        });
    }
}

-(IBAction)readModeSegChanged:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = [modeContent objectAtIndex:readModeSeg.selectedSegmentIndex];
    hud.margin = 30.f;
    hud.yOffset = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:0.5];
    
    UISegmentedControl *myUISegmentedControl=(UISegmentedControl *)sender;
    curMode = myUISegmentedControl.selectedSegmentIndex;
    
    [self.drawer hideAnimated:YES];
    
    readModeSegIsShowing = FALSE;
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
        activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 1)];
    }
    else {
        activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    }

    [activityView start];
    [self.view addSubview:activityView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray * topics = [BBSAPI boardTopics:board.name Start:0 Limit:50 User:myBBS.mySelf Mode:curMode UserOnline:&userOnline PostToday:&postToday PostAll:&postAll];
        [topTenArray removeAllObjects];
        [topTenArray addObjectsFromArray:topics];
        dispatch_async(dispatch_get_main_queue(), ^{
            [customTableView reloadData];
            [customTableView.mTableView setContentOffset:CGPointMake(0, 0)];
            [activityView stop];
            activityView = nil;
        });
    });
}


#pragma mark - UIsearchBarDelegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [customTableView setHidden:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchArray removeAllObjects];
    [searchBar resignFirstResponder];
    searchString = searchBar.text;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray * topics = [BBSAPI searchTopics:searchString start:0 User:myBBS.mySelf BoardName:board.name];
        [searchArray addObjectsFromArray:topics];
        dispatch_async(dispatch_get_main_queue(), ^{
            [customTableView reloadData];
            [customTableView setHidden:NO];
        });
    });
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [customTableView setHidden:NO];
    
    UIBarButtonItem *composeButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(postNewTopic)];
    UIBarButtonItem *changeButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"eye"] style:UIBarButtonItemStylePlain target:self action:@selector(changeReadMode)];
    NSArray * array = [NSArray arrayWithObjects:composeButton, changeButton, nil];
    self.navigationItem.rightBarButtonItems = array;
    
    isSearching = NO;
    self.navigationItem.titleView = nil;
    self.navigationItem.title = board.description;
    [customTableView reloadData];
}


- (void)showSearch
{
    if (readModeSegIsShowing) {
        [self.drawer hideAnimated:YES];
        readModeSegIsShowing = NO;
    }
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [searchBar setShowsCancelButton:YES];
    [searchBar setTintColor:[UIColor blackColor]];
    [searchBar becomeFirstResponder];
    searchBar.delegate = self;
    
    isSearching = YES;
    self.navigationItem.titleView = searchBar;
    self.navigationItem.rightBarButtonItems = nil;
}

-(void)changeReadMode
{
    if (!readModeSegIsShowing) {
		[self.drawer showFromNavigationBar:self.navigationController.navigationBar onView:self.view animated:YES];
        readModeSegIsShowing = YES;
	} else {
		[self.drawer hideAnimated:YES];
        readModeSegIsShowing = NO;
	}
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
