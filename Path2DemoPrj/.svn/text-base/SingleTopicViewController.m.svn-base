//
//  SingleTopicViewController.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "SingleTopicViewController.h"

@implementation SingleTopicViewController
@synthesize rootTopic;
@synthesize isForShowNotification;
@synthesize mDelegate;
@synthesize customTableView;
@synthesize selectedCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isForShowNotification = NO;
        topicsArray = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void)firstTimeLoad
{
    NSArray * topics = [BBSAPI singleTopic:rootTopic.board ID:rootTopic.ID Start:0 Token:myBBS.mySelf.token];
    [topicsArray addObjectsFromArray:topics];
    customTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44) Delegate:self];
    [self.view addSubview:customTableView];
    _timeScroller = [[TimeScroller alloc] initWithDelegate:self];
    [customTableView reloadData];
    [HUD removeFromSuperview];
    [self addQuadCurveMenu];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    [topTitle setText:rootTopic.title];
    // Do any additional setup after loading the view from its nib.
    
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
-(IBAction)back:(id)sender
{
    if (isForShowNotification) {
        [mDelegate refreshNotification];
    }
    selectedCell.unread = FALSE;
    [selectedCell setReadyToShow];
    
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.homeViewController leftBarBtnTapped:nil];
    }
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
    SingleTopicCell * topTenCell = (SingleTopicCell *)cell;
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
    return [topicsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0)
    {
        SingleTopicCell * cell = (SingleTopicCell *)[tableView dequeueReusableCellWithIdentifier:@"SingleTopicCell"];
        if (cell == nil) {
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"SingleTopicCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        Topic * topic = [topicsArray objectAtIndex:indexPath.row];
        cell.ID = topic.ID;
        cell.time = topic.time;
        cell.author = topic.author;
        cell.title = topic.title;
        cell.content = topic.content;
        cell.content = topic.content;
        
        if ([topic.attachments count] != 0) {
            cell.attExist = YES;
        }
        else{
            cell.attExist = NO;
        }
        
        if ([[self getPicList:topic.attachments] count] == 0) {
            cell.attExistPhoto = NO;
        }
        else
        {
            cell.attExistPhoto = YES;
            cell.attachments = topic.attachments;
        }
        
        [cell setReadyToShow];
        return cell;
    }
    else
    {
        SingleTopicCommentCell * cell = (SingleTopicCommentCell *)[tableView dequeueReusableCellWithIdentifier:@"SingleTopicCommentCell"];
        if (cell == nil) {
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"SingleTopicCommentCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        Topic * topic = [topicsArray objectAtIndex:indexPath.row];
        
        cell.ID = topic.ID;
        cell.time = topic.time;
        cell.author = topic.author;
        cell.quote = topic.quote;
        cell.quoter = topic.quoter;
        cell.content = topic.content;
        cell.num = indexPath.row;
        
        cell.content = topic.content;
        if ([topic.attachments count] != 0) {
            cell.attExist = YES;
        }
        else{
            cell.attExist = NO;
        }
        
        if ([[self getPicList:topic.attachments] count] == 0) {
            cell.attExistPhoto = NO;
        }
        else
        {
            cell.attExistPhoto = YES;
            cell.attachments = topic.attachments;
        }

        [cell setReadyToShow];
        return cell;
    }
}

-(NSArray *)getPicList:(NSArray *)attachments
{
    NSMutableArray * picArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [attachments count]; i++) {
        NSString * attUrlString=[[attachments objectAtIndex:i] attUrl];
        if ([attUrlString hasSuffix:@".png"] || [attUrlString hasSuffix:@".jpg"] || [attUrlString hasSuffix:@".jpeg"] || [attUrlString hasSuffix:@".PNG"] || [attUrlString hasSuffix:@".JPG"] || [attUrlString hasSuffix:@".JPEG"])
        {
            [picArray addObject:[MWPhoto photoWithURL:[NSURL URLWithString:attUrlString]]];
        }
    }
    return picArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int returnHeight;
    if (indexPath.row == 0)
    {
        Topic * topic = [topicsArray objectAtIndex:0];
        UIFont *font = [UIFont systemFontOfSize:15.0];
        CGSize size2 = [topic.content sizeWithFont:font constrainedToSize:CGSizeMake(290, 10000) lineBreakMode:UILineBreakModeWordWrap];
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        BOOL ShowAttachments = [defaults boolForKey:@"ShowAttachments"];
        if (ShowAttachments && [[self getPicList:topic.attachments] count] != 0) {
            size2.height = size2.height + 400;
        }
        
        if (indexPath.row == [topicsArray count]-1)
            returnHeight = size2.height+115;
        else
            returnHeight = size2.height+75;
    }
    else {
        Topic * topic = [topicsArray objectAtIndex:indexPath.row];
        
        UIFont *font = [UIFont systemFontOfSize:15.0];
        UIFont *font2 = [UIFont systemFontOfSize:12.0];
        CGSize size1 = [topic.content sizeWithFont:font constrainedToSize:CGSizeMake(290, 10000) lineBreakMode:UILineBreakModeWordWrap];
        
        CGSize size2 = [[NSString stringWithFormat:@"回复:%@\n%@",topic.quoter, topic.quote] sizeWithFont:font2 constrainedToSize:CGSizeMake(290, 10000) lineBreakMode:UILineBreakModeWordWrap];
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        BOOL ShowAttachments = [defaults boolForKey:@"ShowAttachments"];
        if (ShowAttachments && [[self getPicList:topic.attachments] count] != 0) {
            size2.height = size2.height + 400;
        }
        
        if (indexPath.row == [topicsArray count]-1)
            returnHeight =  size1.height+size2.height+90;
        else
            returnHeight =   size1.height+size2.height+50;
    }
    
    if (indexPath.row == 0)
        tableHeight = returnHeight;
    else
        tableHeight += returnHeight;
    
    if (indexPath.row == [topicsArray count] - 1 && tableHeight <= tableView.frame.size.height) {
        return tableView.frame.size.height - tableHeight + returnHeight + 10;
    }
    return returnHeight;
}


// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selectTopic = [topicsArray objectAtIndex:indexPath.row];
    [self showActionSheet];
}

#pragma -
#pragma mark CustomtableView delegate
-(void)refreshTable
{
    @autoreleasepool {
        NSArray * topics = [BBSAPI singleTopic:rootTopic.board ID:rootTopic.ID Start:0 Token:myBBS.mySelf.token];
        [topicsArray removeAllObjects];
        [topicsArray addObjectsFromArray:topics];
        
        [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    }
}
-(void)loadMoreTable
{
    @autoreleasepool {
        NSArray * topics = [BBSAPI singleTopic:rootTopic.board ID:rootTopic.ID Start:[topicsArray count] Token:myBBS.mySelf.token];
        [topicsArray addObjectsFromArray:topics];
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
- (void)refreshTableFooterDidTriggerRefresh:(UITableView *)tableView
{
    [NSThread detachNewThreadSelector:@selector(loadMoreTable) toTarget:self withObject:nil];
}


#pragma mark -
-(void)addQuadCurveMenu
{
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    UIImage *commentImage = [UIImage imageNamed:@"comment.png"];
    UIImage *writenewImage = [UIImage imageNamed:@"writenew.png"];
    UIImage *homeImage = [UIImage imageNamed:@"home.png"];
    UIImage *refreshImage = [UIImage imageNamed:@"refresh.png"];
    
    QuadCurveMenuItem * starMenuItem1 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                highlightedImage:storyMenuItemImagePressed
                                                                    ContentImage:commentImage
                                                         highlightedContentImage:nil];
    QuadCurveMenuItem *starMenuItem2 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:writenewImage
                                                        highlightedContentImage:nil];
    QuadCurveMenuItem *starMenuItem3 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:homeImage
                                                        highlightedContentImage:nil];
    QuadCurveMenuItem *starMenuItem4 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:refreshImage
                                                        highlightedContentImage:nil];
    
    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, nil];
    
    menu = [[QuadCurveMenu alloc] initWithFrame:CGRectMake(10, 10, 200, 200) menus:menus];
    menu.delegate = self;
    [self.view addSubview:menu];
}
- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx
{
    if (idx == 0) {
        if (myBBS.mySelf.ID == nil) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请先登录";
            hud.margin = 30.f;
            hud.yOffset = 0.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
        }
        else{
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            PostTopicViewController * postTopicViewController = [[PostTopicViewController alloc] initWithNibName:@"PostTopicViewController" bundle:nil];
            postTopicViewController.postType = 1;
            postTopicViewController.rootTopic = rootTopic;
            postTopicViewController.mDelegate = appDelegate.homeViewController;
            [appDelegate.homeViewController presentModalViewController:postTopicViewController animated:YES];
        }
    }
    if (idx == 1) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        BOOL * isLoadAvatar = [defaults boolForKey:@"isLoadAvatar"];
        UserInfoViewController * userInfoViewController;
        if (isLoadAvatar) {
            userInfoViewController = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
        }
        else {
            userInfoViewController = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController_noAvatar" bundle:nil];
        }

        userInfoViewController.userString = rootTopic.author;
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        HomeViewController * home = appDelegate.homeViewController;
        [home.navigationController pushViewController:userInfoViewController animated:YES];
    }
    if (idx == 2) {
        Topic * newRootTopic = [topicsArray objectAtIndex:0];
        if (newRootTopic.ID == newRootTopic.gID) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"此帖是主题帖";
            hud.margin = 30.f;
            hud.yOffset = 0.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:0.5];
        }
        else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"同主题展开";
            hud.margin = 30.f;
            hud.yOffset = 0.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:0.5];
            
            [self performSelector:@selector(ShowgID) withObject:nil afterDelay:0.4];
        }
    }
    
    if (idx == 3) {
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

-(void)ShowgID
{
    Topic * newRootTopic = [topicsArray objectAtIndex:0];
    NSArray * topics = [BBSAPI singleTopic:newRootTopic.board ID:newRootTopic.gID Start:0 Token:myBBS.mySelf.token];
    SingleTopicViewController * singleTopicViewController = [[SingleTopicViewController alloc] initWithNibName:@"SingleTopicViewController" bundle:nil];
    singleTopicViewController.rootTopic = [topics objectAtIndex:0];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    HomeViewController * home = appDelegate.homeViewController;
    [home.navigationController pushViewController:singleTopicViewController animated:YES];
}

-(void)showActionSheet
{
    NSMutableString * string = [@"" mutableCopy];
    [string appendString:selectTopic.author];
    [string appendString:@"的帖子"];
    if ([myBBS.mySelf.ID isEqualToString:selectTopic.author]) {
        if ([[selectTopic attachments] count]>=1) {
            UIActionSheet*actionSheet = [[UIActionSheet alloc]
                                         initWithTitle:string
                                         delegate:self
                                         cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                         otherButtonTitles:@"回复", @"查看用户", @"修改文章",@"查看附件", nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            [actionSheet showInView:self.view]; //show from our table view (pops up in the middle of the table)
        }
        else
        {
            UIActionSheet*actionSheet = [[UIActionSheet alloc]
                                         initWithTitle:string
                                         delegate:self
                                         cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                         otherButtonTitles:@"回复", @"查看用户", @"修改文章", nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            [actionSheet showInView:self.view]; //show from our table view (pops up in the middle of the table)
        }
        
    }
    else if([[selectTopic attachments] count]>=1){
        UIActionSheet*actionSheet = [[UIActionSheet alloc]
                                     initWithTitle:string
                                     delegate:self
                                     cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil
                                     otherButtonTitles:@"回复", @"查看用户", @"查看附件",nil];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.view]; //show from our table view (pops up in the middle of the table)
    }
    else{
        UIActionSheet*actionSheet = [[UIActionSheet alloc]
                                     initWithTitle:string
                                     delegate:self
                                     cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil
                                     otherButtonTitles:@"回复", @"查看用户" ,nil];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.view]; //show from our table view (pops up in the middle of the table)
    }
    //////modified by joe//////
}
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[selectTopic attachments] count]>=1) {
        //如果当前topic有附件
        if(buttonIndex == 0)
        {//0号为回复
            if (myBBS.mySelf.ID == nil) {
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
                postTopicViewController.postType = 1;
                postTopicViewController.rootTopic = selectTopic;
                postTopicViewController.mDelegate = appDelegate.homeViewController;
                //[self presentModalViewController:postTopicViewController animated:YES];
                [appDelegate.homeViewController presentModalViewController:postTopicViewController animated:YES];
            }
        }
        if(buttonIndex == 1)
        {//1号为查看用户资料
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            BOOL * isLoadAvatar = [defaults boolForKey:@"isLoadAvatar"];
            UserInfoViewController * userInfoViewController;
            if (isLoadAvatar) {
                userInfoViewController = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
            }
            else {
                userInfoViewController = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController_noAvatar" bundle:nil];
            }

            userInfoViewController.userString = selectTopic.author;
            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            HomeViewController * home = appDelegate.homeViewController;
            [home.navigationController pushViewController:userInfoViewController animated:YES];
        }
        if(buttonIndex == 2 && [myBBS.mySelf.ID isEqualToString:selectTopic.author])
        {//当前话题作者等于自己，2号即为修改文章
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            PostTopicViewController * postTopicViewController = [[PostTopicViewController alloc] initWithNibName:@"PostTopicViewController" bundle:nil];
            postTopicViewController.postType = 2;
            postTopicViewController.rootTopic = selectTopic;
            postTopicViewController.mDelegate = appDelegate.homeViewController;
            //[self presentModalViewController:postTopicViewController animated:YES];
            [appDelegate.homeViewController presentModalViewController:postTopicViewController animated:YES];
        }
    if(buttonIndex == 2 && ![myBBS.mySelf.ID isEqualToString:selectTopic.author])
    {//当前话题作者不是自己，2号即为查看附件
        //查看附件的代码
        //NSLog(@"ViewAtt not for Self");
        AttachmentsViewController* attViewController = [[AttachmentsViewController alloc] initWithNibName:@"AttachmentsViewController" bundle:nil];
        
        attViewController.attList = selectTopic.attachments;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        HomeViewController * home = appDelegate.homeViewController;
        [home.navigationController pushViewController:attViewController animated:YES];
    }
    if (buttonIndex ==3 && [myBBS.mySelf.ID isEqualToString:selectTopic.author]) {
        //NSLog(@"View Att for Self");
        AttachmentsViewController* attViewController = [[AttachmentsViewController alloc] initWithNibName:@"AttachmentsViewController" bundle:nil];
        attViewController.attList = selectTopic.attachments;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        HomeViewController * home = appDelegate.homeViewController;
        [home.navigationController pushViewController:attViewController animated:YES];
    }
}
else{
    if(buttonIndex == 0)
    {//0号为回复
        if (myBBS.mySelf.ID == nil) {
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
            postTopicViewController.postType = 1;
            postTopicViewController.rootTopic = selectTopic;
            postTopicViewController.mDelegate = appDelegate.homeViewController;
            //[self presentModalViewController:postTopicViewController animated:YES];
            [appDelegate.homeViewController presentModalViewController:postTopicViewController animated:YES];
        }
    }
    if(buttonIndex == 1)
    {//1号为查看用户资料
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        BOOL * isLoadAvatar = [defaults boolForKey:@"isLoadAvatar"];
        UserInfoViewController * userInfoViewController;
        if (isLoadAvatar) {
            userInfoViewController = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
        }
        else {
            userInfoViewController = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController_noAvatar" bundle:nil];
        }

        userInfoViewController.userString = selectTopic.author;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        HomeViewController * home = appDelegate.homeViewController;
        [home.navigationController pushViewController:userInfoViewController animated:YES];
    }
    if(buttonIndex == 2 && [myBBS.mySelf.ID isEqualToString:selectTopic.author])
    {//当前话题作者等于自己，2号即为修改文章
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        PostTopicViewController * postTopicViewController = [[PostTopicViewController alloc] initWithNibName:@"PostTopicViewController" bundle:nil];
        postTopicViewController.postType = 2;
        postTopicViewController.rootTopic = selectTopic;
        postTopicViewController.mDelegate = appDelegate.homeViewController;
        //[self presentModalViewController:postTopicViewController animated:YES];
        [appDelegate.homeViewController presentModalViewController:postTopicViewController animated:YES];
    }
    }
} 


-(void)dismissPostTopicView
{
    [self dismissModalViewControllerAnimated:YES];
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
