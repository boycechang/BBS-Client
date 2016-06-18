;//
//  TopTenViewController.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "TopTenViewController.h"
#import "CommonUI.h"
#import "FTPagingViewController.h"

@implementation TopTenViewController
@synthesize topTenArray;
@synthesize customTableView;

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
    self.title = @"十大";
    
    self.navigationController.navigationBar.barTintColor = NAVBARCOLORBLUE;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    customTableView = [[CustomNoFooterViewSectionHeaderTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) Delegate:self];
    activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    [self.view addSubview:customTableView];
    
    [activityView start];
    [self.view addSubview:activityView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (appDelegate.myBBS.hotTopics != nil) {
            self.topTenArray = appDelegate.myBBS.hotTopics;
        }
        else {
            NSMutableArray * allArray = [[NSMutableArray alloc] init];
            NSArray *array;
            array = [BBSAPI topTen];
            if (array != nil)
                [allArray addObject:array];

            for (int i = 0; i < 9; i++) {
                array = [BBSAPI sectionTopTen:i];
                if (array != nil)
                    [allArray addObject:array];
            }
            self.topTenArray = allArray;
            appDelegate.myBBS.hotTopics = self.topTenArray;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [customTableView reloadData];
            [activityView stop];
            activityView = nil;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* myView = [[UIView alloc] init];
    myView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 22)];
    titleLabel.font = [UIFont boldSystemFontOfSize:12];
    titleLabel.textColor = [UIColor colorWithRed:0 green:0.5 blue:1 alpha:1];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    NSArray *nameArray = [NSArray arrayWithObjects:@"今日十大", @"本站站务 十大", @"北邮校园 十大", @"学术科技 十大", @"信息社会 十大", @"人文艺术 十大", @"生活时尚 十大", @"休闲娱乐 十大", @"体育健身 十大", @"游戏对战 十大", nil];
    titleLabel.text = [nameArray objectAtIndex:section];
    [myView addSubview:titleLabel];
    return myView;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *nameArray = [NSArray arrayWithObjects:@"今日十大", @"本站站务 十大", @"北邮校园 十大", @"学术科技 十大", @"信息社会 十大", @"人文艺术 十大", @"生活时尚 十大", @"休闲娱乐 十大", @"体育健身 十大", @"游戏对战 十大", nil];
    return [nameArray objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSArray *nameArray = [NSArray arrayWithObjects:
                          @"今", @"", @"本", @"", @"北", @"", @"学", @"",
                          @"信", @"", @"人", @"", @"生", @"", @"休", @"",
                          @"体", @"", @"游", nil];
    return nameArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSArray *nameArray = [NSArray arrayWithObjects:@"今", @"本", @"北", @"学", @"信", @"人", @"生", @"休", @"体", @"游", nil];
    for(int i = 0; i < [nameArray count]; i++) {
        if([title isEqualToString:[nameArray objectAtIndex:i]]) {
            return i;
        }
    }
    return -1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [topTenArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray * array = [topTenArray objectAtIndex:section];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identi = @"TopTenTableViewCell";
    TopTenTableViewCell * cell = (TopTenTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identi];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"TopTenTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    Topic * topic = [[topTenArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.ID = topic.ID;
    cell.title = topic.title;
    cell.time = topic.time;
    cell.author = topic.author;
    cell.replies = topic.replies;
    cell.read = topic.read;
    cell.board = topic.board;
    cell.unread = YES;
    cell.top = topic.top;
    cell.time = topic.time;
    cell.hasAtt = topic.hasAtt;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath    {
    return 70;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Topic * topic = [[topTenArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    SingleTopicViewController * singleTopicViewController = [[SingleTopicViewController alloc] initWithRootTopic:topic];
    [self.navigationController pushViewController:singleTopicViewController animated:YES];
}

#pragma -
#pragma mark CustomtableView delegate
- (void)refreshTableHeaderDidTriggerRefresh:(UITableView *)tableView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            NSMutableArray * allArray = [[NSMutableArray alloc] init];
            NSArray *array;
            array = [BBSAPI topTen];
            if (array != nil)
                [allArray addObject:array];
            
            for (int i = 0; i < 9; i++) {
                array = [BBSAPI sectionTopTen:i];
                if (array != nil)
                    [allArray addObject:array];
            }
            self.topTenArray = allArray;
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.myBBS.hotTopics = self.topTenArray;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [customTableView reloadData];
        });
    });
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

- (NSArray *)leftNavigationBarItemsInPagingViewController:(FTPagingViewController *)controller {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIBarButtonItem *menuBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menuiconwhite.png"] style:UIBarButtonItemStyleDone target:appDelegate.leftViewController action:@selector(showLeftView:)];
    return @[menuBarItem];
}
@end
