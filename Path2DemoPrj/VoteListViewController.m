//
//  NotificationViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/7/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "VoteListViewController.h"
#import <Masonry.h>

@interface VoteListViewController () {
    UITableView *customTableView;
}
@end

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

- (void)viewDidDisappear:(BOOL)animated {
    [customTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"投票";
    
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
    
    NSArray * itemArray = [NSArray arrayWithObjects:@"最新投票", @"热门投票", @"全部投票", nil];
    self.seg = [[UISegmentedControl alloc] initWithItems:itemArray];
    [seg setSelectedSegmentIndex:0];
    [seg setFrame:CGRectMake(70, 27, 80 * 3, 30)];
    [seg addTarget:self action:@selector(segmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = seg;
    
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
        });
    });
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 
#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

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


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

#pragma -
#pragma mark CustomtableView delegate
- (void)refresh {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.mailsArray0 = [BBSAPI getVoteList:myBBS.mySelf Type:@"new"];
        self.mailsArray1 = [BBSAPI getVoteList:myBBS.mySelf Type:@"hot"];
        self.mailsArray2 = [BBSAPI getVoteList:myBBS.mySelf Type:@"all"];
            
        appDelegate.myBBS.voteListNew = self.mailsArray0;
        appDelegate.myBBS.voteListHot = self.mailsArray1;
        appDelegate.myBBS.voteListAll = self.mailsArray2;
        
        [customTableView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [customTableView.refreshControl endRefreshing];
        });
    });
}

- (IBAction)segmentControlValueChanged:(id)sender {
    [customTableView setContentOffset:CGPointMake(0, 0)];
    [customTableView reloadData];
}

@end
