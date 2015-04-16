//
//  MailBoxViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/4/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "MailBoxViewController.h"

@interface MailBoxViewController ()

@end

@implementation MailBoxViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        tableTitles = [NSArray arrayWithObjects:@"收件箱",@"发件箱",@"废件箱",nil];
        imageNameArray = [NSArray arrayWithObjects:@"inbox.png", @"sentbox.png", @"trashbox.png", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, 290, rect.size.height - 64)];
    self.view.backgroundColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
    self.title = @"站内信";
    
    mainTableView.backgroundColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
    
    UIBarButtonItem * addFavButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(newMail:)];
    
    UIBarButtonItem * addFavButton2 = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 40)]];
    NSArray * array = [NSArray arrayWithObjects:addFavButton2, addFavButton, nil];
    self.navigationItem.rightBarButtonItems = array;
    
    
    UISwipeGestureRecognizer* recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizer];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
-(void)dealloc
{
    tableTitles = nil;
    imageNameArray = nil;
    mainTableView = nil;
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

-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"GHMenuCell";
	GHMenuCell *cell = (GHMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GHMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    cell.imageView.image = [UIImage imageNamed:[imageNameArray objectAtIndex:indexPath.row]];
    cell.textLabel.text = [tableTitles objectAtIndex:indexPath.row];
    
	return cell;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    MailsViewController * mailsViewController = [[MailsViewController alloc] initWithNibName:@"MailsViewController" bundle:nil];
    mailsViewController.mailBoxType = indexPath.row;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    HomeViewController * home = appDelegate.homeViewController;
    [home restoreViewLocation];
    [home removeOldViewController];
    home.realViewController = mailsViewController;
    [home showViewController:[tableTitles objectAtIndex:indexPath.row]];
}
-(IBAction)newMail:(id)sender
{
    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelegate showLeftViewTotaly];
    
    PostMailViewController * postMailViewController = [[PostMailViewController alloc] initWithNibName:@"PostMailViewController" bundle:nil];
    postMailViewController.postType = 0;
    postMailViewController.mDelegate = self;
    [self presentModalViewController:postMailViewController animated:YES];
}

-(void)dismissPostMailView
{
    [self dismissModalViewControllerAnimated:YES];
    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelegate showLeftView];
}
@end
