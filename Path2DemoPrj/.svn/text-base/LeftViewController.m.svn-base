//
//  AboutViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/3/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "LeftViewController.h"

@implementation LeftViewController
@synthesize mainTableView;

- (void)viewDidLoad {
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    UIColor *bgColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
    self.view.backgroundColor = bgColor;
    self.mainTableView.backgroundColor = bgColor;
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:(30.0f/255.0f) green:(37.0f/255.0f) blue:(54.0f/255.0f) alpha:1.0f];
    
    UIBarButtonItem * addFavButton = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 40)]];
    self.navigationItem.rightBarButtonItem = addFavButton;

    self.navigationItem.titleView = search;
    
    searchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    [searchViewController.view setFrame:CGRectMake(0, 0, 320, rect.size.height - 44)];
    [searchViewController.view setAlpha:0];
    [self.view insertSubview:searchViewController.view atIndex:2];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    tableTitles1 = [NSArray arrayWithObjects:@"今日十大",@"分区十大",@"人气版面",@"分类讨论区",nil];
    if(myBBS.mySelf.ID != nil)
    {
        tableTitles2 = [NSArray arrayWithObjects:@"收藏",@"好友",@"站内信", @"新消息", @"设置",nil];
        tableTitles3 = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",myBBS.mySelf.ID], nil];
    }
    else
    {
        tableTitles2 = [NSArray arrayWithObjects:@"登录",nil];
        tableTitles3 = [NSArray arrayWithObjects:@"未登录", nil];
    }
    search.delegate = self;
    search.keyboardType = UIKeyboardTypeDefault;
    search.autocapitalizationType = UITextAutocapitalizationTypeNone;
	search.autocorrectionType = UITextAutocorrectionTypeNo;
    search.tintColor = [UIColor colorWithRed:(30.0f/255.0f) green:(37.0f/255.0f) blue:(54.0f/255.0f) alpha:1.0f];
	search.placeholder = @"搜索";
	for (UIView *subview in search.subviews) {
		if ([subview isKindOfClass:[UITextField class]]) {
			UITextField *searchTextField = (UITextField *) subview;
			searchTextField.textColor = [UIColor colorWithRed:(154.0f/255.0f) green:(162.0f/255.0f) blue:(176.0f/255.0f) alpha:1.0f];
		}
	}
	[search setSearchFieldBackgroundImage:[[UIImage imageNamed:@"searchTextBG.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(16.0f, 17.0f, 16.0f, 17.0f)]
                                                    forState:UIControlStateNormal];
	[search setImage:[UIImage imageNamed:@"searchBarIcon.png"]
							 forSearchBarIcon:UISearchBarIconSearch
										state:UIControlStateNormal];
    [super viewDidLoad];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    tableTitles1 = nil;
    tableTitles2 = nil;
    tableTitles3 = nil;
    searchViewController = nil;
    search = nil;
    myBBS = nil;
}


#pragma mark - UITableView delegate
// Section Titles
//每个section显示的标题

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return @"全站";
    if(section == 1)
        return [tableTitles3 objectAtIndex:0];
    return @"";
}


//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


#pragma mark - UITableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [tableTitles1 count];
    }
    if (section == 1) {
        return [tableTitles2 count];
    }
    if (section == 2) {
        return [tableTitles3 count];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSObject *headerText;
    if(section == 0)
        headerText = @"全站";
    if(section == 1)
        headerText = [tableTitles3 objectAtIndex:0];
	UIView *headerView = nil;
	if (headerText != [NSNull null]) {
		headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 21.0f)];
		CAGradientLayer *gradient = [CAGradientLayer layer];
		gradient.frame = headerView.bounds;
		gradient.colors = @[
                      (id)[UIColor colorWithRed:(67.0f/255.0f) green:(74.0f/255.0f) blue:(94.0f/255.0f) alpha:1.0f].CGColor,
                      (id)[UIColor colorWithRed:(57.0f/255.0f) green:(64.0f/255.0f) blue:(82.0f/255.0f) alpha:1.0f].CGColor,
                      ];
		[headerView.layer insertSublayer:gradient atIndex:0];
		
		UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 12.0f, 5.0f)];
		textLabel.text = (NSString *) headerText;
		textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:([UIFont systemFontSize] * 0.9f)];
		textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
		textLabel.textColor = [UIColor colorWithRed:(125.0f/255.0f) green:(129.0f/255.0f) blue:(146.0f/255.0f) alpha:1.0f];
		textLabel.backgroundColor = [UIColor clearColor];
		[headerView addSubview:textLabel];
		
		UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		topLine.backgroundColor = [UIColor colorWithRed:(78.0f/255.0f) green:(86.0f/255.0f) blue:(103.0f/255.0f) alpha:1.0f];
		[headerView addSubview:topLine];
		
		UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 21.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		bottomLine.backgroundColor = [UIColor colorWithRed:(36.0f/255.0f) green:(42.0f/255.0f) blue:(5.0f/255.0f) alpha:1.0f];
		[headerView addSubview:bottomLine];
	}
	return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 3)
    {
        NotificationCell * cell = (NotificationCell *)[tableView dequeueReusableCellWithIdentifier:@"NotificationCell"];
        if (cell == nil) {
            cell = [[NotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NotificationCell"];
            [cell.textLabel setText:@"新消息"];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        cell.notification = myBBS.notification;
        [cell refreshCell];
        return cell;
    }
    
    static NSString *CellIdentifier = @"GHMenuCell";
	GHMenuCell *cell = (GHMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GHMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}

    if (indexPath.section == 0) {
        cell.textLabel.text = [tableTitles1 objectAtIndex:indexPath.row];
        if (indexPath.row != 0) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = [tableTitles2 objectAtIndex:indexPath.row];
        if (myBBS.mySelf.ID == nil) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        else {
            if (indexPath.row != 3 && indexPath.row != 4) {
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            else {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
        }
    }
    if (indexPath.section == 2) {
        cell.textLabel.text = [tableTitles3 objectAtIndex:indexPath.row];
    }
	return cell;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        TopTenViewController * topicsViewController = [[TopTenViewController alloc] initWithNibName:@"TopTenViewController" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        HomeViewController * home = appDelegate.homeViewController;
        [home restoreViewLocation];
        [home removeOldViewController];
        home.realViewController = topicsViewController;
        [home showViewController:@"今日十大"];
    }
    if (indexPath.row == 1 && indexPath.section == 0) {
        AllSectionsViewController * allSectionsViewController = [[AllSectionsViewController alloc] initWithNibName:@"AllSectionsViewController" bundle:nil];
        allSectionsViewController.topTitleString = @"分区十大";
        allSectionsViewController.isMenu = TRUE;
        allSectionsViewController.isForSectionTopTen = TRUE;
        [self.navigationController pushViewController:allSectionsViewController animated:YES];
    }
    if (indexPath.row == 2 && indexPath.section == 0) {
        BoardsViewController * boardsViewController = [[BoardsViewController alloc] initWithNibName:@"BoardsViewController" bundle:nil];
        [self.navigationController pushViewController:boardsViewController animated:YES];
    }
    if (indexPath.row == 3 && indexPath.section == 0) {
        AllSectionsViewController * allSectionsViewController = [[AllSectionsViewController alloc] initWithNibName:@"AllSectionsViewController" bundle:nil];
        allSectionsViewController.topTitleString = @"分类讨论区";
        [self.navigationController pushViewController:allSectionsViewController animated:YES];
    }
    
    if (myBBS.mySelf.ID == nil) {
        if (indexPath.row == 0 && indexPath.section == 1) {
            LoginViewController * loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            loginViewController.mDelegate = self;
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate showLeftViewTotaly];
            [self presentModalViewController:loginViewController animated:YES];
        }
    }
    if (myBBS.mySelf.ID != nil) {
        if (indexPath.row == -1 && indexPath.section == 1) {
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            BOOL * isLoadAvatar = [defaults boolForKey:@"isLoadAvatar"];
            UserInfoViewController * userInfoViewController;
            if (isLoadAvatar) {
                userInfoViewController = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
            }
            else {
                userInfoViewController = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController_noAvatar" bundle:nil];
            }

            userInfoViewController.userString = myBBS.mySelf.ID;
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            HomeViewController * home = appDelegate.homeViewController;
            [home restoreViewLocation];
            [home removeOldViewController];
            home.realViewController = userInfoViewController;
            [home showViewController:@"我的信息"];
        }
        if (indexPath.row == 0 && indexPath.section == 1) {
            AllFavViewController * allFavViewController = [[AllFavViewController alloc] initWithNibName:@"AllFavViewController" bundle:nil];
            allFavViewController.topTitleString = @"收藏";
            [self.navigationController pushViewController:allFavViewController animated:YES];
        }
        if (indexPath.row == 1 && indexPath.section == 1) {
            FriendsViewController * friendsViewController = [[FriendsViewController alloc] initWithNibName:@"FriendsViewController" bundle:nil];
            [self.navigationController pushViewController:friendsViewController animated:YES];
        }
        if (indexPath.row == 2 && indexPath.section == 1) {
            MailBoxViewController * mailBoxViewController = [[MailBoxViewController alloc] initWithNibName:@"MailBoxViewController" bundle:nil];
            [self.navigationController pushViewController:mailBoxViewController animated:YES];
        }
        if (indexPath.row == 3 && indexPath.section == 1) {
            [self showNotification];
        }
        if (indexPath.row == 4 && indexPath.section == 1) {
            
            AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appdelegate showLeftViewTotaly];
            
            AboutViewController * aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
            aboutViewController.mDelegate = self;
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
            nc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [nc.navigationBar setHidden:YES];
            [self presentModalViewController:nc animated:YES];
        }
    }
}

#pragma mark - UIsearchBarDelegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{    
    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegate.isSearching = YES;
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    [mainTableView setAlpha:0];
    [searchViewController.view setAlpha:0];
    searchBar.showsCancelButton = YES;
	[UIView commitAnimations];
    
    [appdelegate showLeftViewTotaly];

    self.navigationItem.rightBarButtonItem = nil;
    
    for(id cc in [searchBar subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *sbtn = (UIButton *)cc;
            [sbtn setTitle:@"取消"  forState:UIControlStateNormal];
            [sbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sbtn setTintColor:[UIColor clearColor]];
        }
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)sBar
{ 
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    [searchViewController.view setAlpha:1];
	[UIView commitAnimations];
    
    //点击搜索时的响应事件
    searchViewController.searchString = sBar.text;
    [searchViewController refreshSearching];
    [search resignFirstResponder];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setText:@""];
    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegate.isSearching = NO;
    //点击取消响应事件
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    searchBar.showsCancelButton = NO;
    [mainTableView setAlpha:1];
	[UIView commitAnimations];
    
    UIBarButtonItem * addFavButton = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 40)]];
    self.navigationItem.rightBarButtonItem = addFavButton;
    
    [searchBar resignFirstResponder];
    [appdelegate showLeftView];
}


#pragma mark - LoginViewDelegate
-(void)LoginSuccess
{
    NSArray * new = [NSArray arrayWithObjects:@"收藏",@"好友",@"站内信", @"新消息",@"设置",nil];
    if (tableTitles2 != new) {
        tableTitles2 = new;
    }
    
    NSArray * new2 = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",myBBS.mySelf.ID], nil];
    if (tableTitles3 != new2) {
        tableTitles3 = new2;
    }
    
    [mainTableView reloadData];
}

#pragma mark - Rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return NO;
}
- (BOOL)shouldAutorotate{
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - AboutViewDelegate
-(void)dismissAboutView
{
    [self dismissModalViewControllerAnimated:YES];
    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelegate showLeftView];
}

-(void)logout{
    [myBBS userLogout];
    NSArray * new = [NSArray arrayWithObjects:@"登录",nil];
    if (tableTitles2 != new) {
        tableTitles2 = new;
    }
    NSArray * new2 = [NSArray arrayWithObjects:@"未登录", nil];
    if (tableTitles3 != new2) {
        tableTitles3 = new2;
    }
    ////modified by joe//////
    [mainTableView reloadData];
}

-(void)showNotification
{
    NotificationViewController * notificationViewController = [[NotificationViewController alloc] initWithNibName:@"NotificationViewController" bundle:nil];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    HomeViewController * home = appDelegate.homeViewController;
    [home restoreViewLocation];
    [home removeOldViewController];
    home.realViewController = notificationViewController;
    [home showViewController:@"新消息"];
}
@end
