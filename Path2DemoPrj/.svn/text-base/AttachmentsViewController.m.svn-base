//
//  AttachmentsViewController.m
//  虎踞龙蟠
//
//  Created by Huang Feiqiao on 13-1-29.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "AttachmentsViewController.h"

@implementation AttachmentsViewController
@synthesize attList;
@synthesize picList;
@synthesize otherList;
@synthesize openString;

@synthesize photos = _photos;


@synthesize saveController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.picList = [self getPicList:attList];
    self.otherList = [self getOtherList:attList];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    attTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    
    UISwipeGestureRecognizer* recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSArray *)getPicList:(NSArray *)attArray
{
    NSMutableArray * picArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [attList count]; i++) {
        NSString * attUrlString=[[attList objectAtIndex:i] attUrl];
        if ([attUrlString hasSuffix:@".png"] || [attUrlString hasSuffix:@".jpg"] || [attUrlString hasSuffix:@".jpeg"] || [attUrlString hasSuffix:@".PNG"] || [attUrlString hasSuffix:@".JPG"] || [attUrlString hasSuffix:@".JPEG"])
        {
            [picArray addObject:[attList objectAtIndex:i]];
        }
    }
    return picArray;
}
-(NSArray *)getOtherList:(NSArray *)attArray
{
    NSMutableArray * otherArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [attList count]; i++) {
        NSString * attUrlString=[[attList objectAtIndex:i] attUrl];
        if (![attUrlString hasSuffix:@".png"] && ![attUrlString hasSuffix:@".jpg"] && ![attUrlString hasSuffix:@".jpeg"] && ![attUrlString hasSuffix:@".PNG"] && ![attUrlString hasSuffix:@".JPG"] && ![attUrlString hasSuffix:@".JPEG"])
        {
            [otherArray addObject:[attList objectAtIndex:i]];
        }
    }
    return otherArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        if ([picList count] != 0) {
            return [NSString stringWithFormat:@"图片附件(共%i张)", [picList count]];
        }
        else
            return @"无图片附件";
    }
    if(section == 1){
        if ([otherList count] != 0) {
            return [NSString stringWithFormat:@"其他附件(共%i个)", [otherList count]];
        }
        else
            return @"无其他附件";
    }
    return @"";
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return [picList count];
    if(section == 1)
        return [otherList count];
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        UITableViewCell * cell=[[UITableViewCell alloc] init];
        cell.textLabel.text=[[picList objectAtIndex:indexPath.row] attFileName];
        [cell.textLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
        [cell.textLabel setShadowOffset:CGSizeMake(0, 1)];
        [cell.textLabel setShadowColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
        return cell;
    }
    if(indexPath.section == 1){
        UITableViewCell * cell=[[UITableViewCell alloc] init];
        cell.textLabel.text=[[otherList objectAtIndex:indexPath.row] attFileName];
        [cell.textLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
        [cell.textLabel setShadowOffset:CGSizeMake(0, 1)];
        [cell.textLabel setShadowColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0){
        NSMutableArray * photosArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [picList count]; i++) {
            NSString * attUrlString=[[picList objectAtIndex:i] attUrl];
            [photosArray addObject:[MWPhoto photoWithURL:[NSURL URLWithString:attUrlString]]];
        }
        self.photos = photosArray;

        // Create browser
        MWPhotoBrowser * browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = YES;
        [browser setInitialPageIndex:indexPath.row];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        nc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [appDelegate.homeViewController presentViewController:nc animated:YES completion:nil];
    }
    else
    {
        NSString * curAttUrlString=[[otherList objectAtIndex:indexPath.row] attUrl];
        if ([curAttUrlString hasSuffix:@".gif"] || [curAttUrlString hasSuffix:@".GIF"]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        ImageData * imageData = [[ImageData alloc] init];
        imageData.url = curAttUrlString;
        imageData.title = [[otherList objectAtIndex:indexPath.row] attFileName];
        
        SingleImageWithScrollViewController * singleImageWithScrollViewController = [[SingleImageWithScrollViewController alloc] initWithNibName:@"SingleImageWithScrollViewController" bundle:nil];
        singleImageWithScrollViewController.mDelegate = nil;
        singleImageWithScrollViewController.imageData = imageData;
        singleImageWithScrollViewController.isGIF = TRUE;
        [singleImageWithScrollViewController loadBigImageView];
        [appDelegate.homeViewController presentViewController:singleImageWithScrollViewController animated:YES completion:nil];
        }
        else
        {
            openString = curAttUrlString;
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用Safari打开此附件" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好",nil];
            [alert show];
        }
    }
}

-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller{
    return self.view;
}

- (BOOL)documentInteractionController:(UIDocumentInteractionController *)controller canPerformAction:(SEL)action{
    BOOL canPerform = NO;
    if (action == @selector(copy:))
        canPerform = YES;
    return canPerform;
}

- (BOOL)documentInteractionController:(UIDocumentInteractionController *)controller performAction:(SEL)action{
    BOOL handled = NO;
    if (action == @selector(copy:)){
        handled = YES;
    }
    return handled;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller{
    return self.view.frame;
}

- (void)documentInteractionControllerWillBeginPreview:(UIDocumentInteractionController *)controller{
    //_isShowing = YES;
}

#pragma mark -
#pragma mark UIAlertView
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch(buttonIndex){
        case 0:
            break;
        case 1:
        {
            NSURL* url = [[NSURL alloc] initWithString:openString];
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
    }
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
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
