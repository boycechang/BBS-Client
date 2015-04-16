//
//  TopTenViewController.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "TopicsViewController.h"

@implementation TopicsViewController
@synthesize boardName;
@synthesize topTenArray;
@synthesize customTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        topTenArray = [[NSMutableArray alloc] init];
        readModeSegIsShowing = FALSE;
    }
    return self;
}
-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.homeViewController leftBarBtnTapped:nil];
}

-(void)firstTimeLoad
{
    curMode = 2;
    modeContent=[[NSArray alloc] initWithObjects:@"全部帖子",@"主题帖",@"论坛模式",@"置顶帖",@"文摘区",@"保留区", nil];// 0 全部帖子（默认） 1 主题贴 2 论坛模式 3 置顶帖 4 文摘区 5 保留区
    NSArray * topics = [BBSAPI boardTopics:boardName Start:0 Token:myBBS.mySelf.token Mode:curMode];
    [topTenArray addObjectsFromArray:topics];
    customTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44) Delegate:self];
    //[self.view addSubview:customTableView];
    [self.view insertSubview:customTableView atIndex:0];
    _timeScroller = [[TimeScroller alloc] initWithDelegate:self];
    [self addQuadCurveMenu];
    [customTableView reloadData];
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [readModeSeg setFrame:CGRectMake(20, 0, 280, 35)];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    [topTitle setText:boardName];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view insertSubview:HUD atIndex:0];
	HUD.labelText = @"载入中...";
	[HUD showWhileExecuting:@selector(firstTimeLoad) onTarget:self withObject:nil animated:YES];
    
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
    _timeScroller = nil;
}

#pragma mark UIScrollViewDelegateMethods
//The TimeScroller needs to know what's happening with the UITableView (UIScrollView)
- (void)scrollViewDidScroll{
    [_timeScroller scrollViewDidScroll];
}

- (void)scrollViewDidEndDecelerating{
    [_timeScroller scrollViewDidEndDecelerating];
}

- (void)scrollViewWillBeginDragging{
    [_timeScroller scrollViewWillBeginDragging];
}

- (void)scrollViewDidEndDragging:(BOOL)decelerate{
    if (!decelerate) {
        [_timeScroller scrollViewDidEndDecelerating];
    }
}
//You should return an NSDate related to the UITableViewCell given. This will be
//the date displayed when the TimeScroller is above that cell.
- (UITableView *)tableViewForTimeScroller:(TimeScroller *)timeScroller {
    return customTableView.mTableView;
}
- (NSDate *)dateForCell:(UITableViewCell *)cell {
    TopTenTableViewCell * topTenCell = (TopTenTableViewCell *)cell;
    return topTenCell.time;
}



#pragma mark - 
#pragma mark tableViewDelegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    
    Topic * topic = [topTenArray objectAtIndex:indexPath.row];
    cell.ID = topic.ID;
    cell.title = topic.title;
    cell.time = topic.time;
    cell.author = topic.author;
    cell.replies = topic.replies;
    cell.read = topic.read;
    cell.board = topic.board;
    cell.top = topic.top;
    if (curMode != 2) {
        cell.unread = YES;
    }
    else
    {
        cell.unread = topic.unread;
    }
    
    [cell setReadyToShow];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   
{
    if (indexPath.row == [topTenArray count]-1) {
        if (([topTenArray count]-1)*80 + 130 <= tableView.frame.size.height) {
            return tableView.frame.size.height - ([topTenArray count]-1)*80 + 10;
        }
        return 130;
    }
    return 80;
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
    
    Topic * topic = [topTenArray objectAtIndex:indexPath.row];
    topic.unread = FALSE;
    
    SingleTopicViewController * singleTopicViewController = [[SingleTopicViewController alloc] initWithNibName:@"SingleTopicViewController" bundle:nil];
    singleTopicViewController.rootTopic = [topTenArray objectAtIndex:indexPath.row];
    singleTopicViewController.mDelegate = self;
    if (curMode == 2) {
        singleTopicViewController.selectedCell = (TopTenTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    HomeViewController * home = appDelegate.homeViewController;
    [home.navigationController pushViewController:singleTopicViewController animated:YES];
}

#pragma -
#pragma mark CustomtableView delegate
-(void)refreshTable
{
    @autoreleasepool {
        NSArray * topics = [BBSAPI boardTopics:boardName Start:0 Token:myBBS.mySelf.token Mode:curMode];
        [topTenArray removeAllObjects];
        [topTenArray addObjectsFromArray:topics];
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

-(void)loadMoreTable
{
    @autoreleasepool {
        NSArray * topics = [BBSAPI boardTopics:boardName Start:[topTenArray count] Token:myBBS.mySelf.token Mode:curMode];
        [topTenArray addObjectsFromArray:topics];
        [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    }
}

- (void)refreshTableFooterDidTriggerRefresh:(UITableView *)tableView
{
    [NSThread detachNewThreadSelector:@selector(loadMoreTable) toTarget:self withObject:nil];
}



#pragma mark -
-(void)addQuadCurveMenu
{
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    UIImage *postnewImage = [UIImage imageNamed:@"postnew.png"];
    UIImage *heartImage = [UIImage imageNamed:@"heart.png"];
    UIImage *refreshImage = [UIImage imageNamed:@"refresh.png"];
    
    QuadCurveMenuItem * starMenuItem1 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                highlightedImage:storyMenuItemImagePressed 
                                                                    ContentImage:postnewImage 
                                                         highlightedContentImage:nil];
    
    QuadCurveMenuItem *starMenuItem2 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed 
                                                                   ContentImage:heartImage 
                                                        highlightedContentImage:nil];
    
    QuadCurveMenuItem *starMenuItem7 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed 
                                                                   ContentImage:refreshImage 
                                                        highlightedContentImage:nil];
    
    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem7, nil];
    
    menu = [[QuadCurveMenu alloc] initWithFrame:CGRectMake(10, 10, 200, 200) menus:menus];
    menu.delegate = self;
    //[self.navigationController.view addSubview:menu];
    [self.view addSubview:menu];
}
- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx
{
    if (idx == 0) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (appDelegate.myBBS.mySelf.ID == nil) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请先登录";
            hud.margin = 30.f;
            hud.yOffset = 0.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
        }
        else {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            PostTopicViewController * postTopicViewController = [[PostTopicViewController alloc] initWithNibName:@"PostTopicViewController" bundle:nil];
            postTopicViewController.postType = 0;
            postTopicViewController.boardName = boardName;
            postTopicViewController.mDelegate = appDelegate.homeViewController;
            [appDelegate.homeViewController presentModalViewController:postTopicViewController animated:YES];
        }
    }
    if (idx == 1) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if([BBSAPI addFavBoard:appDelegate.myBBS.mySelf.token BoardName:boardName]){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"收藏版面成功";
            hud.margin = 30.f;
            hud.yOffset = 0.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:0.5];
        }
        else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"收藏版面失败";
            hud.margin = 30.f;
            hud.yOffset = 0.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:0.5];
        }
    }
    if (idx == 2) {
        [customTableView.mTableView setContentOffset:CGPointMake(0, 0) animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"回到顶部";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.5];
    }
}


-(IBAction)readModeSegChanged:(id)sender
{
    UISegmentedControl *myUISegmentedControl=(UISegmentedControl *)sender;
    curMode = myUISegmentedControl.selectedSegmentIndex;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [readModeSeg setFrame:CGRectMake(20, 0, 280, 35)];
    [UIView commitAnimations];
    readModeSegIsShowing = FALSE;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = [modeContent objectAtIndex:curMode];
    hud.margin = 30.f;
    hud.yOffset = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:0.8];
    [self refreshTable];
    [customTableView.mTableView setContentOffset:CGPointMake(0, 0)];
}


-(void)changeReadMode
{
    if (readModeSegIsShowing) {
        [UIView beginAnimations:nil context:nil];
        
        [UIView setAnimationCurve:UIViewAnimationOptionCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
        [readModeSeg setFrame:CGRectMake(20, 0, 280, 35)];
        [UIView commitAnimations];
        readModeSegIsShowing = FALSE;
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationOptionCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
        [readModeSeg setFrame:CGRectMake(20, 50, 280, 35)];
        [UIView commitAnimations];
        readModeSegIsShowing = TRUE;
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
