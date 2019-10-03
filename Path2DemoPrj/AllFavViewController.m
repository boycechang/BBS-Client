//
//  BoardsViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/1/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "AllFavViewController.h"
 

@implementation AllFavViewController
@synthesize topTenArray;
@synthesize topTitleString;

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
    self.title = @"收藏";
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorNamed:@"MainTheme"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;

    if (topTenArray == nil) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        customTableView = [[CustomNoFooterWithDeleteTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) Delegate:self];
        activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
        
        [self.view addSubview:customTableView];
        
        [activityView start];
        [self.view addSubview:activityView];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            if (appDelegate.myBBS.myFavorites != nil) {
                self.topTenArray = appDelegate.myBBS.myFavorites;
            }
            else {
                self.topTenArray = [BBSAPI allFavSections:myBBS.mySelf];
                appDelegate.myBBS.myFavorites = self.topTenArray;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                UIBarButtonItem *editFavButton=[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editFav:)];
                self.navigationItem.rightBarButtonItem = editFavButton;

                [customTableView reloadData];
                [activityView stop];
                activityView = nil;
            });
        });
    }
    else {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        normalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
        normalTableView.tableFooterView = [UIView new];
        normalTableView.dataSource = self;
        normalTableView.delegate = self;
        [self.view addSubview:normalTableView];
        [normalTableView reloadData];
    }
    
    UIBarButtonItem *menuBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menuiconwhite.png"] style:UIBarButtonItemStyleDone target:appDelegate.leftViewController action:@selector(showLeftView:)];
    self.navigationItem.leftBarButtonItem = menuBarItem;
}

-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    customTableView = nil;
    normalTableView = nil;
    [activityView stop];
    activityView = nil;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Board * board = [topTenArray objectAtIndex:indexPath.row];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        BOOL success = [BBSAPI deleteFavBoard:appDelegate.myBBS.mySelf BoardName:board.name];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                NSMutableArray * newTopTen = [[NSMutableArray alloc] init];
                for (int i = 0; i < [self.topTenArray count]; i++) {
                    if (i != indexPath.row) {
                        Board * board = [self.topTenArray objectAtIndex:i];
                        [newTopTen addObject:board];
                    }
                }
                self.topTenArray = newTopTen;
                [customTableView.mTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            } else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"版面删除失败";
                hud.margin = 30.f;
                hud.yOffset = 0.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:0.5];
            }
        });
    });
}

-(IBAction)editFav:(id)sender
{
    UIBarButtonItem *doneFavButton=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishEdit:)];
    self.navigationItem.rightBarButtonItem = doneFavButton;
    [customTableView.mTableView setEditing:YES animated:YES];
}

-(IBAction)finishEdit:(id)sender{
    UIBarButtonItem *editFavButton=[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editFav:)];
    self.navigationItem.rightBarButtonItem = editFavButton;
    [customTableView.mTableView setEditing:NO animated:YES];
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
    }
    else {
        BoardsViewController * boardsViewController = [[BoardsViewController alloc] init];
        boardsViewController.rootSection = board.name;
        [self.navigationController pushViewController:boardsViewController animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BoardsCellView * cell = (BoardsCellView *)[tableView dequeueReusableCellWithIdentifier:@"BoardsCellView"];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"BoardsCellView" owner:self options:nil];
        cell = [array objectAtIndex:0];
        
        //cell = [[BoardsCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BoardsCellView"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    Board * b = [topTenArray objectAtIndex:indexPath.row];
    cell.name = b.name;
    cell.description = b.description;
    cell.section = b.section;
    cell.leaf = NO;
    cell.users = b.users;
    cell.count = b.count;
    
    if (!b.leaf) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    } else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
	return cell;
}

#pragma -
#pragma mark CustomtableView delegate
- (void)refreshTableHeaderDidTriggerRefresh:(UITableView *)tableView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.topTenArray = [BBSAPI allFavSections:myBBS.mySelf];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.myBBS.myFavorites = self.topTenArray;
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
@end
