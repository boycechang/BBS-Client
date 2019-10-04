//
//  NotificationViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/7/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "MailBoxViewController.h"
 

@implementation MailBoxViewController
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

-(void)viewDidDisappear:(BOOL)animated
{
    [customTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"邮件";
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorNamed:@"MainTheme"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    customTableView = [[CustomTableWithDeleteView alloc] initWithFrame:CGRectMake(0, 108, self.view.frame.size.width, self.view.frame.size.height - 108) Delegate:self];
    activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 108, self.view.frame.size.width, 1)];
    
    [self.view addSubview:customTableView];
    [activityView start];
    [self.view addSubview:activityView];
    
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)];
    NSArray * itemArray = [NSArray arrayWithObjects:@"收件箱", @"发件箱", @"废件箱", nil];
    self.seg = [[UISegmentedControl alloc] initWithItems:itemArray];
    [seg setSelectedSegmentIndex:0];
    [seg setFrame:CGRectMake(6, 7, self.view.frame.size.width - 10, 30)];
    [seg addTarget:self action:@selector(segmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [toolbar addSubview:seg];
    [self.view addSubview:toolbar];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0) {
        [seg setSegmentedControlStyle:UISegmentedControlStyleBar];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (appDelegate.myBBS.myMails0 != nil) {
            self.mailsArray0 = appDelegate.myBBS.myMails0;
            self.mailsArray1 = appDelegate.myBBS.myMails1;
            self.mailsArray2 = appDelegate.myBBS.myMails2;
        }
        else {
            self.mailsArray0 = [BBSAPI getMails:myBBS.mySelf Type:0 Start:0];
            self.mailsArray1 = [BBSAPI getMails:myBBS.mySelf Type:1 Start:0];
            self.mailsArray2 = [BBSAPI getMails:myBBS.mySelf Type:2 Start:0];
   
            appDelegate.myBBS.myMails0 = self.mailsArray0;
            appDelegate.myBBS.myMails1 = self.mailsArray1;
            appDelegate.myBBS.myMails2 = self.mailsArray2;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIBarButtonItem *newMailButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(newMail:)];
            UIBarButtonItem *editMailButton=[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editMail:)];
            NSArray * rightButtonarray = [NSArray arrayWithObjects:newMailButton, editMailButton, nil];
            self.navigationItem.rightBarButtonItems = rightButtonarray;
            
            [customTableView reloadData];
            [activityView removeFromSuperview];
            activityView = nil;
        });
    });
}

-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    customTableView = nil;
    activityView = nil;
}

#pragma mark - 
#pragma mark tableViewDelegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MailsViewCell * cell = (MailsViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MailsViewCell"];
    if (cell == nil) {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"MailsViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    switch (seg.selectedSegmentIndex) {
        case 0:
            cell.mail = [mailsArray0 objectAtIndex:indexPath.row];
            break;
        case 1:
            cell.mail = [mailsArray1 objectAtIndex:indexPath.row];
            break;
        case 2:
            cell.mail = [mailsArray2 objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SingleMailViewController * singleMailViewController = [[SingleMailViewController alloc] initWithNibName:@"SingleMailViewController" bundle:nil];
    
    
    switch (seg.selectedSegmentIndex) {
        case 0:
            singleMailViewController.rootMail = [mailsArray0 objectAtIndex:indexPath.row];
            break;
        case 1:
            singleMailViewController.rootMail = [mailsArray1 objectAtIndex:indexPath.row];
            break;
        case 2:
            singleMailViewController.rootMail = [mailsArray2 objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    singleMailViewController.rootMail.unread = NO;
    [self.navigationController pushViewController:singleMailViewController animated:YES];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * editArray;
    switch (seg.selectedSegmentIndex) {
        case 0:
            editArray = mailsArray0;
            break;
        case 1:
            editArray = mailsArray1;
            break;
        case 2:
            editArray = mailsArray2;
            break;
        default:
            break;
    }
    
    
    Mail * mail = [editArray objectAtIndex:indexPath.row];
    BOOL success = [BBSAPI deleteSingleMail:myBBS.mySelf Type:mail.type ID:mail.ID];
    if (success) {
        NSMutableArray * newTopTen = [[NSMutableArray alloc] init];
        for (int i = 0; i < [editArray count]; i++) {
            if (i != indexPath.row) {
                Mail * newMail = [editArray objectAtIndex:i];
                if (i < indexPath.row) {
                    //newMail.ID--;
                }
                [newTopTen addObject:newMail];
            }
        }
        
        switch (seg.selectedSegmentIndex) {
            case 0:
                self.mailsArray0 = newTopTen;
                break;
            case 1:
                self.mailsArray1 = newTopTen;
                break;
            case 2:
                self.mailsArray2 = newTopTen;
                break;
            default:
                break;
        }
        [customTableView.mTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

-(IBAction)editMail:(id)sender
{
    UIBarButtonItem *newMailButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(newMail:)];
    [newMailButton setEnabled:NO];
    UIBarButtonItem *editMailButton=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishEditMail:)];
    NSArray * rightButtonarray = [NSArray arrayWithObjects:newMailButton, editMailButton, nil];
    
    self.navigationItem.rightBarButtonItems = rightButtonarray;
    
    [customTableView.mTableView setEditing:YES animated:YES];
}

-(IBAction)finishEditMail:(id)sender{
    UIBarButtonItem *newMailButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(newMail:)];
    UIBarButtonItem *editMailButton=[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editMail:)];
    NSArray * rightButtonarray = [NSArray arrayWithObjects:newMailButton, editMailButton, nil];
    
    self.navigationItem.rightBarButtonItems = rightButtonarray;
    
    [customTableView.mTableView setEditing:NO animated:YES];
}

-(IBAction)newMail:(id)sender
{
    PostMailViewController * postMailViewController = [[PostMailViewController alloc] init];
    postMailViewController.postType = 0;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postMailViewController];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma -
#pragma mark CustomtableView delegate
- (void)refreshTableHeaderDidTriggerRefresh:(UITableView *)tableView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.mailsArray0 = [BBSAPI getMails:myBBS.mySelf Type:0 Start:0];
        self.mailsArray1 = [BBSAPI getMails:myBBS.mySelf Type:1 Start:0];
        self.mailsArray2 = [BBSAPI getMails:myBBS.mySelf Type:2 Start:0];
            
        appDelegate.myBBS.myMails0 = self.mailsArray0;
        appDelegate.myBBS.myMails1 = self.mailsArray1;
        appDelegate.myBBS.myMails2 = self.mailsArray2;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [customTableView reloadData];
        });
    });
}

- (void)refreshTableFooterDidTriggerRefresh:(UITableView *)tableView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray * loadMoreArray;
        switch (seg.selectedSegmentIndex) {
            case 0:
                loadMoreArray = mailsArray0;
                break;
            case 1:
                loadMoreArray = mailsArray1;
                break;
            case 2:
                loadMoreArray = mailsArray2;
                break;
            default:
                break;
        }
        NSArray * topics = [BBSAPI getMails:myBBS.mySelf Type:seg.selectedSegmentIndex Start:[loadMoreArray count]];
        NSMutableArray * moreArray = [NSMutableArray arrayWithArray:loadMoreArray];
        [moreArray addObjectsFromArray:topics];
        
        switch (seg.selectedSegmentIndex) {
            case 0:
                self.mailsArray0 = moreArray;
                break;
            case 1:
                self.mailsArray1 = moreArray;
                break;
            case 2:
                self.mailsArray2 = moreArray;
                break;
            default:
                break;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [customTableView reloadData];
        });
    });
}

-(IBAction)segmentControlValueChanged:(id)sender
{
    [customTableView reloadData];
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
