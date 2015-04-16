//
//  BoardsViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/1/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "AllSectionsViewController.h"

@implementation AllSectionsViewController
@synthesize topTenArray;
@synthesize topTitleString;
@synthesize isMenu;
@synthesize isForSectionTopTen;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)firstTimeLoad
{
    if ([topTitleString isEqualToString:@"分类讨论区"] || [topTitleString isEqualToString:@"分区十大"]) {
        [myBBS refreshAllSections];
        self.topTenArray = myBBS.allSections;
    }
    [HUD removeFromSuperview];
    HUD = nil;
    customTableView = [[CustomNoFooterTableView alloc] initWithFrame:CGRectMake(0, 0, 290, self.view.frame.size.height) Delegate:self];
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
    [self.view setFrame:CGRectMake(0, 0, 290, rect.size.height-64)];
    self.view.backgroundColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
    self.title = topTitleString;
    
    if (![topTitleString isEqualToString:@"分类讨论区"] && !isMenu) {
        UIBarButtonItem * addFavButton = [[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self action:@selector(addFavDirect:)];
        UIBarButtonItem * addFavButton2 = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 40)]];
        NSArray * array = [NSArray arrayWithObjects:addFavButton2, addFavButton, nil];
        self.navigationItem.rightBarButtonItems = array;
   }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    if ([myBBS.allSections count] == 0) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view insertSubview:HUD atIndex:0];
        HUD.labelText = @"载入中...";
        [HUD showWhileExecuting:@selector(firstTimeLoad) onTarget:self withObject:nil animated:YES];
    }
    else {
        if ([topTitleString isEqualToString:@"分类讨论区"] || [topTitleString isEqualToString:@"分区十大"]) {
            customTableView = [[CustomNoFooterTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) Delegate:self];
            customTableView.mTableView.backgroundColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
            customTableView.mRefreshTableHeaderView.backgroundColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
            [customTableView.mTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [self.view addSubview:customTableView];
            self.topTenArray = myBBS.allSections;
            [customTableView reloadData];
        }
        else {
            normalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            normalTableView.backgroundColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
            [normalTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            normalTableView.dataSource = self;
            normalTableView.delegate = self;
            normalTableView.directionalLockEnabled = YES;
            normalTableView.decelerationRate = 0;
            [self.view addSubview:normalTableView];
            [normalTableView reloadData];
        }
    }
    
    UISwipeGestureRecognizer* recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizer];
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
-(void)dealloc
{
    customTableView = nil;
    normalTableView = nil;
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
//指定有多少个分区(Section)，默认为1
/*
 -(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
 {
 return 1;
 }
 */
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [topTenArray count];
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    Board * board = [topTenArray objectAtIndex:indexPath.row]; 
    if (isForSectionTopTen) {
        SectionTopTenViewController * sectionTopTenViewController = [[SectionTopTenViewController alloc] initWithNibName:@"SectionTopTenViewController" bundle:nil];
        sectionTopTenViewController.sectionNumber = indexPath.row;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        HomeViewController * home = appDelegate.homeViewController;
        [home restoreViewLocation];
        [home removeOldViewController];
        home.realViewController = sectionTopTenViewController;
        [home showViewController:[NSString stringWithFormat:@"%@ 十大", board.name]];
        return;
    }
    
    if (board.leaf) {
        TopicsViewController * topicsViewController = [[TopicsViewController alloc] initWithNibName:@"TopicsViewController" bundle:nil];
        Board * b = [topTenArray objectAtIndex:indexPath.row];
        topicsViewController.boardName = b.name;
    
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        HomeViewController * home = appDelegate.homeViewController;
        [home restoreViewLocation];
        [home removeOldViewController];
        home.realViewController = topicsViewController;
        [home showViewController:b.name];
    }
    else {
        AllSectionsViewController * allSectionsViewController = [[AllSectionsViewController alloc] initWithNibName:@"AllSectionsViewController" bundle:nil];
        allSectionsViewController.topTenArray= board.sectionBoards;
        allSectionsViewController.topTitleString = board.name;
        if ([topTitleString isEqualToString:@"分类讨论区"])
        {
            allSectionsViewController.isMenu = TRUE;
        }
        [self.navigationController pushViewController:allSectionsViewController animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BoardsCellView * cell = (BoardsCellView *)[tableView dequeueReusableCellWithIdentifier:@"BoardsCellView"];
    if (cell == nil) {
        cell = [[BoardsCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BoardsCellView"];
    }
    
    Board * b = [topTenArray objectAtIndex:indexPath.row];
    cell.name = b.name;
    cell.description = b.description;
    cell.section = b.section;
    cell.leaf = b.leaf;
    [cell setReadyToShow];
    
    if (!b.leaf) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    if (isForSectionTopTen) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
	return cell;
}

#pragma -
#pragma mark CustomtableView delegate
-(void)refreshTable
{
    @autoreleasepool {
        [myBBS refreshAllSections];
        self.topTenArray = myBBS.allSections;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   
{
    return 44;
}

-(IBAction)addFavDirect:(id)sender
{
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
    else if([BBSAPI addFavBoard:appDelegate.myBBS.mySelf.token BoardName:topTitleString]){
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


@end
