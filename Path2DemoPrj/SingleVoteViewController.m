//
//  UserInfoViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/5/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "SingleVoteViewController.h"

@implementation SingleVoteViewController
@synthesize rootVote;
@synthesize mDelegate;
@synthesize myVoted;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)refresh
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        Vote *cache = [BBSAPI getSingleVote:appDelegate.myBBS.mySelf ID:rootVote.vid];
        if (cache != nil) {
            self.rootVote = cache;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (rootVote.voted != nil) {
                [voteButton setTitle:@"已投票"];
            }
            else if (rootVote.type == 0)
            {
                [voteButton setTitle:@"投票 (单选)"];
            }
            else {
                [voteButton setTitle:[NSString stringWithFormat:@"投票 (可选%i项)", rootVote.limit]];
            }
            
            if (rootVote.is_end || rootVote.is_deleted || rootVote.voted != nil) {
                [voteButton setEnabled:NO];
            }
            
            [optionsTableView reloadData];
        });
    });

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.layer.cornerRadius = 10;
    self.view.clipsToBounds = YES;
    
    optionsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44)];
    optionsTableView.dataSource = self;
    optionsTableView.delegate = self;
    [self.view addSubview:optionsTableView];
    
    
    activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    [activityView start];
    [self.view addSubview:activityView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.rootVote = [BBSAPI getSingleVote:appDelegate.myBBS.mySelf ID:rootVote.vid];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (rootVote.voted != nil) {
                [voteButton setTitle:@"已投票"];
            }
            else if (rootVote.type == 0)
            {
                [voteButton setTitle:@"投票 (单选)"];
            }
            else {
                [voteButton setTitle:[NSString stringWithFormat:@"投票 (可选%i项)", rootVote.limit]];
            }
            
            if (rootVote.is_end || rootVote.is_deleted || rootVote.voted != nil) {
                [voteButton setEnabled:NO];
            }
            
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:optionsTableView selector:@selector(reloadData) userInfo:nil repeats:NO];
            //[optionsTableView reloadData];
            [activityView stop];
            activityView = nil;
        });
    });
    
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
        [self registerEffectForView:self.view depth:20];
    }
}

-(void)dealloc
{
    [activityView stop];
    activityView = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [activityView stop];
    activityView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark tableViewDelegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    VoteCellView * cell = (VoteCellView *)[tableView dequeueReusableCellWithIdentifier:@"VoteCellView"];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"VoteCellView" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.vote = rootVote;
    cell.backgroundColor = [UIColor whiteColor];
    [cell.backImageView setFrame:CGRectMake(0, 0, cell.frame.size.width + 20, cell.frame.size.height)];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 120;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [rootVote.options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OptionCellView * cell = (OptionCellView *)[tableView dequeueReusableCellWithIdentifier:@"OptionCellView"];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"OptionCellView" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    cell.rootVote = rootVote;
    cell.option = [rootVote.options objectAtIndex:indexPath.row];
    cell.isSelect = NO;
    if (rootVote.voted != nil) {
        NSString *vote;
        for (vote in rootVote.voted) {
            if([vote intValue] == cell.option.viid)
                cell.isSelect = YES;
        }
    }
    
    if(voteButton.enabled)
    {
        NSString *vote;
        for (vote in myVoted) {
            if([vote intValue] == cell.option.viid)
                cell.isSelect = YES;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (voteButton.enabled) {
        if (rootVote.type == 0)
        {
            Vote *option = [rootVote.options objectAtIndex:indexPath.row];
            self.myVoted = [NSArray arrayWithObject:[NSString stringWithFormat:@"%i", option.viid]];
        }
        else {
            Vote *option = [rootVote.options objectAtIndex:indexPath.row];
            
            BOOL inmyVoted = FALSE;
            NSString *myVotedString;
            for (myVotedString in myVoted){
                if ([myVotedString isEqualToString:[NSString stringWithFormat:@"%i",option.viid]]) {
                    inmyVoted = TRUE;
                }
            }
            
            if (inmyVoted) {
                NSMutableArray *newMyVoted = [[NSMutableArray alloc] init];
                for (int i = 0; i < [myVoted count]; i++){
                    NSString *vote = [myVoted objectAtIndex:i];
                    if ([vote isEqualToString:[NSString stringWithFormat:@"%i",option.viid]])
                        continue;
                    else
                        [newMyVoted addObject:vote];
                }
                self.myVoted = newMyVoted;
            }
            else if ([myVoted count] == rootVote.limit)
            {
                hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [NSString stringWithFormat:@"最多可选%i项", rootVote.limit];
                hud.margin = 30.f;
                hud.yOffset = 0.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:0.7];
            }
            else {
                NSMutableArray *newMyVoted = [[NSMutableArray alloc] init];
                [newMyVoted addObjectsFromArray:myVoted];
                [newMyVoted addObject:[NSString stringWithFormat:@"%i", option.viid]];
                self.myVoted = newMyVoted;
            }
        }
    }
    
    [tableView reloadData];
}

-(IBAction)vote:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.myBBS.mySelf == nil) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先登录";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        return;
    }
    
    if (myVoted == nil || [myVoted count] == 0) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请勾选投票项";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.7];
    }
    else {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"投票中";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            backVote = [BBSAPI doVote:appDelegate.myBBS.mySelf ID:rootVote.vid VoteArray:myVoted];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (backVote != nil) {
                    self.rootVote = backVote;
                    hud.labelText = @"投票成功";
                    [hud hide:YES afterDelay:0.3];
                    [self refresh];
                }
                else {
                    hud.labelText = @"投票失败";
                    [hud hide:YES afterDelay:0.3];
                }
                
            });
        });

    }
}


- (void)registerEffectForView:(UIView *)aView depth:(CGFloat)depth;
{
	UIInterpolatingMotionEffect *effectX;
	UIInterpolatingMotionEffect *effectY;
    effectX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                              type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    effectY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                              type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
	
	effectX.maximumRelativeValue = @(depth);
	effectX.minimumRelativeValue = @(-depth);
	effectY.maximumRelativeValue = @(depth);
	effectY.minimumRelativeValue = @(-depth);
	
	[aView addMotionEffect:effectX];
	[aView addMotionEffect:effectY];
}

@end
