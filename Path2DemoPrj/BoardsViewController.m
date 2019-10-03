//
//  BoardsViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/1/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "BoardsViewController.h"
#import <Masonry.h>
#import "AppDelegate.h"

@interface BoardsViewController () {
    UITableView *customTableView;
}
@end


@implementation BoardsViewController
@synthesize topTenArray;
@synthesize rootSection;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([rootSection isEqualToString:@"0"]) {
        self.title = @"本站站务";
    }
    else if ([rootSection isEqualToString:@"1"]) {
        self.title = @"北邮校园";
    }
    else if ([rootSection isEqualToString:@"2"]) {
        self.title = @"学术科技";
    }
    else if ([rootSection isEqualToString:@"3"]) {
        self.title = @"信息社会";
    }
    else if ([rootSection isEqualToString:@"4"]) {
        self.title = @"人文艺术";
    }
    else if ([rootSection isEqualToString:@"5"]) {
        self.title = @"生活时尚";
    }
    else if ([rootSection isEqualToString:@"6"]) {
        self.title = @"休闲娱乐";
    }
    else if ([rootSection isEqualToString:@"7"]) {
        self.title = @"体育健身";
    }
    else if ([rootSection isEqualToString:@"8"]) {
        self.title = @"游戏对战";
    }
    else {
        self.title = rootSection;
    }
    
    if (rootSection == nil) {
        self.title = @"版面";
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    customTableView = [[UITableView alloc] init];
    customTableView.refreshControl = [UIRefreshControl new];
    [customTableView.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:customTableView];
    [customTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    customTableView.delegate = self;
    customTableView.dataSource = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (appDelegate.myBBS.allSections != nil && rootSection == nil) {
            self.topTenArray = appDelegate.myBBS.allSections;
        }
        else {
            self.topTenArray = [BBSAPI getBoards:appDelegate.myBBS.mySelf Section:rootSection];
            if (rootSection == nil)
                appDelegate.myBBS.allSections = self.topTenArray;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [customTableView reloadData];
        });
    });
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    customTableView = nil;
    normalTableView = nil;
    [activityView stop];
    activityView = nil;
}

#pragma mark - UITableView delegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [topTenArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Board * board = [topTenArray objectAtIndex:indexPath.row];
    if (board.leaf) {
        TopicsViewController * topicsViewController = [[TopicsViewController alloc] init];
        Board * b = [topTenArray objectAtIndex:indexPath.row];
        topicsViewController.board = b;
        [self.navigationController pushViewController:topicsViewController animated:YES];
    } else {
        BoardsViewController * boardsViewController = [[BoardsViewController alloc] init];
        boardsViewController.rootSection = board.name;
        [self.navigationController pushViewController:boardsViewController animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BoardsCellView * cell = (BoardsCellView *)[tableView dequeueReusableCellWithIdentifier:@"BoardsCellView"];
    if (cell == nil) {
        //cell = [[BoardsCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BoardsCellView"];
        
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"BoardsCellView" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    Board * b = [topTenArray objectAtIndex:indexPath.row];
    cell.name = b.name;
    cell.description = b.description;
    cell.section = b.section;
    cell.leaf = b.leaf;
    cell.users = b.users;
    cell.count = b.count;
    
    if (!b.leaf) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
	return cell;
}

#pragma -
#pragma mark CustomtableView delegate
- (void)refresh {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.topTenArray = [BBSAPI getBoards:appDelegate.myBBS.mySelf Section:rootSection];
        if (rootSection == nil) {
            appDelegate.myBBS.allSections = self.topTenArray;
        }
        
        [customTableView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [customTableView.refreshControl endRefreshing];
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
@end
