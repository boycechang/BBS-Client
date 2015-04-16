//
//  SingleTopicViewController.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "SingleMapNewsViewController.h"
#import "CXPhotoBrowser.h"
#import "DemoPhoto.h"

@implementation SingleMapNewsViewController
@synthesize rootTopic;
@synthesize customTableView;
@synthesize forRetainController;
@synthesize rootNews;
@synthesize memo;

- (id)initWithRootTopic:(Topic *)topic
{
    self = [super init];
    if (self) {
        topicsArray = [[NSMutableArray alloc] init];
        self.rootTopic = topic;
    }
    return self;
}

- (id)initWithRootNews:(AVObject *)news
{
    self = [super init];
    if (self) {
        self.rootNews = news;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.view.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    customTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    customTableView.delegate = self;
    customTableView.dataSource = self;
    
    [self.view addSubview:customTableView];
    
    [activityView start];
    [self.view addSubview:activityView];
    
    [customTableView reloadData];
    
    customTableView.backgroundColor = [UIColor clearColor];
    customTableView.separatorColor = [UIColor clearColor];
    
    UIBarButtonItem *reportButton=[[UIBarButtonItem alloc] initWithTitle:@"举报" style:UIBarButtonItemStyleBordered target:self action:@selector(report)];
    UIBarButtonItem *likeButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LikeIcon"] style:UIBarButtonItemStyleBordered target:self action:@selector(like)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:likeButton, reportButton, nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    customTableView = nil;
    activityView = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    SingleTopicCellVideo * cell = (SingleTopicCellVideo *)[customTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if ([cell isKindOfClass:[SingleTopicCellVideo class]]) {
        cell = (SingleTopicCellVideo *)cell;
        [cell.playerController pause];
    }
}

-(IBAction)back:(id)sender
{
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)report {
    [rootNews incrementKey:@"report"];
    [rootNews saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"举报成功";
            hud.margin = 30.f;
            hud.yOffset = 0.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:0.8];
        }
    }];
}

-(void)like {
    [rootNews incrementKey:@"like"];
    [rootNews saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"赞";
            hud.margin = 30.f;
            hud.yOffset = 0.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:0.8];
        }
    }];
}

#pragma mark -
#pragma mark tableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([rootNews objectForKey:@"image"] != nil) {
        SingleTopicCellImage * cell = (SingleTopicCellImage *)[tableView dequeueReusableCellWithIdentifier:@"SingleTopicCellImage"];
        if (cell == nil) {
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"SingleTopicCellImage" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.news = rootNews;
        cell.mDelegate = self;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else if ([rootNews objectForKey:@"video"] != nil) {
        SingleTopicCellVideo * cell = (SingleTopicCellVideo *)[tableView dequeueReusableCellWithIdentifier:@"SingleTopicCellVideo"];
        if (cell == nil) {
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"SingleTopicCellVideo" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.news = rootNews;
        cell.mDelegate = self;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    } else {
        SingleTopicCellImage * cell = (SingleTopicCellImage *)[tableView dequeueReusableCellWithIdentifier:@"SingleTopicCellImage"];
        if (cell == nil) {
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"SingleTopicCellImage" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.news = rootNews;
        cell.mDelegate = self;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float tqheught = [TQRichTextView getHeightWithString:[NSString stringWithFormat:@"%@", (NSString *)[rootNews objectForKey:@"content"]] FrameWidth:self.view.frame.size.width - 30];
    CGSize size2 = CGSizeMake(self.view.frame.size.width - 30, tqheught);
    return size2.height + 520;
}


// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma -
#pragma mark CustomtableView delegate
-(void)refreshTable
{
    return;
}
-(void)loadMoreTable
{
}
-(void)refreshTableView
{
    [customTableView reloadData];
}

- (void)refreshTableHeaderDidTriggerRefresh:(UITableView *)tableView
{
    [customTableView reloadData];
    //[NSThread detachNewThreadSelector:@selector(refreshTable) toTarget:self withObject:nil];
}
- (void)refreshTableFooterDidTriggerRefresh:(UITableView *)tableView
{
    [customTableView reloadData];
    //[NSThread detachNewThreadSelector:@selector(loadMoreTable) toTarget:self withObject:nil];
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
