//
//  SingleTopicViewController.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "SingleTopicViewController.h"
#import "CXPhotoBrowser.h"
#import "DemoPhoto.h"
#import "CommonUI.h"
#import "POP.h"

@implementation SingleTopicViewController
@synthesize rootTopic;
@synthesize customTableView;
@synthesize forRetainController;

- (id)initWithRootTopic:(Topic *)topic
{
    self = [super init];
    if (self) {
        topicsArray = [[NSMutableArray alloc] init];
        self.rootTopic = topic;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    
    if (self.navigationController != nil) {
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
            [self setAutomaticallyAdjustsScrollViewInsets:NO];
            customTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) Delegate:self];
            activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 1)];
            
        }
        else {
            customTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) Delegate:self];
            activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
        }
    }
    else {
        customTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) Delegate:self];
        activityView = [[FPActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    }
    
    
    [self.view addSubview:customTableView];
    
    [activityView start];
    [self.view addSubview:activityView];
    
    pageCount = rootTopic.replies / 20 + 1;
    currentLowPage = 1;
    currentHighPage = 1;
    currentShowPage = 1;
    
    pageChangeView = [[ModalViewController alloc] init];
    pageChangeView.delegate = self;
    pageChangeView.pageCount = pageCount;
    [pageChangeView.view setFrame:CGRectMake(self.view.frame.size.width - 130, -300, 90, 300)];
    pageChangeView.view.backgroundColor = self.navigationController.navigationBar.barTintColor;
    [self.view addSubview:pageChangeView.view];
    isPageChangeViewShowing = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray * topics;
        if (rootTopic.ID == rootTopic.gID)
            topics = [BBSAPI singleTopic:rootTopic.board ID:rootTopic.ID Page:1 User:myBBS.mySelf];
        else
            topics = [BBSAPI replyTopic:rootTopic.board ID:rootTopic.ID Start:0 User:myBBS.mySelf];
        
        if (topics == nil) {
            [activityView stop];
            activityView = nil;
            return;
        }
        [topicsArray addObjectsFromArray:topics];

        dispatch_async(dispatch_get_main_queue(), ^{
            UIBarButtonItem *replyButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(reply)];
            pageButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%i/%i页", 1, pageCount] style:UIBarButtonItemStylePlain target:self action:@selector(switchPageChangeView)];
            
            newRootTopic = [topicsArray objectAtIndex:0];
            NSArray * array;
            if (newRootTopic.ID == newRootTopic.gID) {
                array = [NSArray arrayWithObjects:replyButton, pageButton, nil];
            } else{
                UIBarButtonItem *expandButton = [[UIBarButtonItem alloc] initWithTitle:@"同主题展开" style:UIBarButtonItemStylePlain target:self action:@selector(expand)];
                array = [NSArray arrayWithObjects:replyButton, expandButton, nil];
            }
            
            if (self.navigationController != nil) {
                self.navigationItem.rightBarButtonItems = array;
            }
            else{
                self.navigationItem.rightBarButtonItems = array;
            }
            
            [customTableView reloadData];
            [activityView stop];
            activityView = nil;
        });
    });
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    customTableView = nil;
    activityView = nil;
}

#pragma mark -
#pragma mark tableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [topicsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentShowPage != indexPath.row / 20 + currentLowPage) {
        currentShowPage = indexPath.row / 20 + currentLowPage;
        [self refreshPageButton];
    }
    
    if(indexPath.row == 0 && currentLowPage == 1)
    {
        SingleTopicCell * cell = (SingleTopicCell *)[tableView dequeueReusableCellWithIdentifier:@"SingleTopicCell"];
        if (cell == nil) {
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"SingleTopicCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        Topic * topic = [topicsArray objectAtIndex:indexPath.row];
        cell.ID = topic.ID;
        cell.time = topic.time;
        cell.author = topic.author;
        cell.authorFaceURL = topic.authorFaceURL;
        cell.title = topic.title;
        cell.content = topic.content;
        cell.content = topic.content;
        cell.attachments = topic.attachments;
        cell.indexRow = indexPath.row;
        cell.mDelegate = self;
        return cell;
    }
    else
    {
        SingleTopicCommentCell * cell = (SingleTopicCommentCell *)[tableView dequeueReusableCellWithIdentifier:@"SingleTopicCommentCell"];
        if (cell == nil) {
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"SingleTopicCommentCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        Topic * topic = [topicsArray objectAtIndex:indexPath.row];
        cell.ID = topic.ID;
        cell.time = topic.time;
        cell.author = topic.author;
        cell.authorFaceURL = topic.authorFaceURL;
        cell.quote = topic.quote;
        cell.quoter = topic.quoter;
        cell.content = topic.content;
        cell.num = indexPath.row + (currentLowPage - 1) * 20;
        cell.content = topic.content;
        cell.attachments = topic.attachments;
        cell.indexRow = indexPath.row;
        cell.mDelegate = self;
        return cell;
    }
}

-(NSArray *)getPicList:(NSArray *)attachments
{
    NSMutableArray * picArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [attachments count]; i++) {
        NSString * attUrlString=[[[attachments objectAtIndex:i] attFileName] lowercaseString];
        if ([attUrlString hasSuffix:@".png"] || [attUrlString hasSuffix:@".jpeg"] || [attUrlString hasSuffix:@".jpg"] || [attUrlString hasSuffix:@".tiff"] || [attUrlString hasSuffix:@".bmp"])
        {
            [picArray addObject:[attachments objectAtIndex:i]];
        }
    }
    return picArray;
}

-(NSArray *)getDocList:(NSArray *)attachments
{
    NSMutableArray * picArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [attachments count]; i++) {
        NSString * attUrlString=[[[attachments objectAtIndex:i] attFileName] lowercaseString];
        if ([attUrlString hasSuffix:@".png"] || [attUrlString hasSuffix:@".jpeg"] || [attUrlString hasSuffix:@".jpg"] || [attUrlString hasSuffix:@".tiff"] || [attUrlString hasSuffix:@".bmp"])
        {
            //[picArray addObject:[attachments objectAtIndex:i]];
        }
        else
        {
            [picArray addObject:[attachments objectAtIndex:i]];
        }
    }
    return picArray;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int returnHeight;
    if (indexPath.row == 0)
    {
        Topic * topic = [topicsArray objectAtIndex:0];
        
        float tqheught = [TQRichTextView getHeightWithString:topic.content FrameWidth:self.view.frame.size.width - 30];
        CGSize size2 = CGSizeMake(self.view.frame.size.width - 30, tqheught);
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        BOOL ShowAttachments = [defaults boolForKey:@"ShowAttachments"];
        if (ShowAttachments) {
            size2.height = size2.height + (400 * [[self getPicList:topic.attachments] count]);
            size2.height = size2.height + 60 * [[self getDocList:topic.attachments] count];
        }
        else{
            size2.height = size2.height + 60 * [topic.attachments count];
        }
        returnHeight = size2.height + 90;
    }
    else {
        Topic * topic = [topicsArray objectAtIndex:indexPath.row];

        float tqheught = [TQRichTextView getHeightWithString:topic.content FrameWidth:self.view.frame.size.width - 30];
        CGSize size1 = CGSizeMake(self.view.frame.size.width - 30, tqheught);
        CGSize size2 = CGSizeMake(0, 0);
    
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        BOOL ShowAttachments = [defaults boolForKey:@"ShowAttachments"];
        if (ShowAttachments) {
            size2.height = size2.height + (400 * [[self getPicList:topic.attachments] count]);
            size2.height = size2.height + 60 * [[self getDocList:topic.attachments] count];
        }
        else{
            size2.height = size2.height + 60 * [topic.attachments count];
        }
        returnHeight = size1.height + size2.height + 40;
    }
    return returnHeight;
}


// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma -
#pragma mark CustomtableView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isPageChangeViewShowing) {
        POPSpringAnimation *popOutAnimation = [POPSpringAnimation animation];
        popOutAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
        popOutAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(pageChangeView.view.frame.origin.x, -300, pageChangeView.view.frame.size.width, pageChangeView.view.frame.size.height)];
        popOutAnimation.springBounciness = 10.0;
        popOutAnimation.springSpeed = 10;
        [pageChangeView.view pop_addAnimation:popOutAnimation forKey:@"slide"];
        isPageChangeViewShowing = NO;
    }
}

- (void)refreshTableHeaderDidTriggerRefresh:(UITableView *)tableView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray * topics;
        if (rootTopic.ID == rootTopic.gID) {
            if (currentLowPage - 1 >= 1) { //有上一页
                topics = [BBSAPI singleTopic:rootTopic.board ID:rootTopic.ID Page:currentLowPage - 1 User:myBBS.mySelf];
                if (topics != nil) {
                    [topicsArray insertObjects:topics atIndexes:[NSIndexSet indexSetWithIndexesInRange: NSMakeRange(0, [topics count])]];
                    currentLowPage--;
                }
            } else { //无上一页
                topics = [BBSAPI singleTopic:rootTopic.board ID:rootTopic.ID Page:currentLowPage - 1 User:myBBS.mySelf];
                if ([topicsArray count] < 20 && topics != nil) {
                    [topicsArray removeAllObjects];
                    [topicsArray addObjectsFromArray:topics];
                } else {
                    [topicsArray replaceObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange: NSMakeRange(0, [topics count])] withObjects:topics];
                }
            }
            
        } else {
            topics = [BBSAPI replyTopic:rootTopic.board ID:rootTopic.ID Start:0 User:myBBS.mySelf];
            [topicsArray removeAllObjects];
            [topicsArray addObjectsFromArray:topics];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [customTableView reloadData];
        });
    });
}

- (void)refreshTableFooterDidTriggerRefresh:(UITableView *)tableView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray * topics;
        if (rootTopic.ID == rootTopic.gID) {
            if (currentHighPage + 1 <= pageCount) { //有下一页
                topics = [BBSAPI singleTopic:rootTopic.board ID:rootTopic.ID Page:currentHighPage + 1 User:myBBS.mySelf];
                if (topics != nil) {
                    [topicsArray addObjectsFromArray:topics];
                    currentHighPage++;
                }
            } else { //无下一页
                topics = [BBSAPI singleTopic:rootTopic.board ID:rootTopic.ID Page:currentHighPage User:myBBS.mySelf];
                if (topics != nil) {
                    [topicsArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange: NSMakeRange( (currentHighPage - currentLowPage) * 20, [topicsArray count] - (currentHighPage - currentLowPage) * 20)]];
                    [topicsArray addObjectsFromArray:topics];
                }
            }
        } else {
            topics = [BBSAPI replyTopic:rootTopic.board ID:rootTopic.ID Start:[topicsArray count] User:myBBS.mySelf];
            [topicsArray addObjectsFromArray:topics];
        }
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [customTableView reloadData];
        });
    });
}

- (void)reply
{
    if (myBBS.mySelf.ID == nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先登录";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
    }
    else{
        PostTopicViewController * postTopicViewController = [[PostTopicViewController alloc] init];
        postTopicViewController.postType = 1;
        postTopicViewController.rootTopic = newRootTopic;
        postTopicViewController.mDelegate = nil;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postTopicViewController];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

-(void)switchPageChangeView{
    if (isPageChangeViewShowing) {
        POPSpringAnimation *popOutAnimation = [POPSpringAnimation animation];
        popOutAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
        popOutAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(pageChangeView.view.frame.origin.x, -300, pageChangeView.view.frame.size.width, pageChangeView.view.frame.size.height)];
        popOutAnimation.springBounciness = 10.0;
        popOutAnimation.springSpeed = 10;
        [pageChangeView.view pop_addAnimation:popOutAnimation forKey:@"slide"];
        isPageChangeViewShowing = NO;
    } else {
        POPSpringAnimation *popOutAnimation = [POPSpringAnimation animation];
        popOutAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
        popOutAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(pageChangeView.view.frame.origin.x, 70, pageChangeView.view.frame.size.width, pageChangeView.view.frame.size.height)];
        popOutAnimation.springBounciness = 10.0;
        popOutAnimation.springSpeed = 10;
        [pageChangeView.view pop_addAnimation:popOutAnimation forKey:@"slide"];
        isPageChangeViewShowing = YES;
    }
}

-(void)refreshPageButton{
    [pageButton setTitle:[NSString stringWithFormat:@"%i/%i页", currentShowPage, pageCount]];
}

- (void)expand
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"同主题展开";
    hud.margin = 30.f;
    hud.yOffset = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:0.5];
    
    [self performSelector:@selector(ShowgID) withObject:nil afterDelay:0.4];
}

-(void)ShowgID
{
    Topic * oldRootTopic = [topicsArray objectAtIndex:0];
    Topic * topic = [[Topic alloc] init];
    topic.ID = oldRootTopic.gID;
    topic.gID = oldRootTopic.gID;
    topic.board = oldRootTopic.board;
    SingleTopicViewController * singleTopicViewController = [[SingleTopicViewController alloc] initWithRootTopic:topic];
    [self.navigationController pushViewController:singleTopicViewController animated:YES];
}

#pragma - SingleTopicCellDelegate
-(void)imageAttachmentViewInCellTaped:(int)indexRow Index:(int)indexNum
{
    NSMutableArray *photoDataSource = [[NSMutableArray alloc] init];
    Topic * topic = [topicsArray objectAtIndex:indexRow];
    NSArray * picArray = [self getPicList:topic.attachments];
    
    for (int i = 0; i < [picArray count]; i++)
    {
        Attachment * att = [picArray objectAtIndex:i];
        DemoPhoto *photo = [[DemoPhoto alloc] initWithURL:[NSURL URLWithString:att.attUrl]];
        [photoDataSource addObject:photo];
    }
    CXPhotoBrowser * browser = [[CXPhotoBrowser alloc] initWithPhotoArray:photoDataSource];
    [browser setInitialPageIndex:indexNum];
    
    [self presentViewController:browser animated:YES completion:nil];
}

-(void)attachmentViewInCellTaped:(BOOL)isPhoto IndexRow:(int)indexRow IndexNum:(int)indexNum
{
    if (isPhoto) {
        NSMutableArray *photoDataSource = [[NSMutableArray alloc] init];
        Topic * topic = [topicsArray objectAtIndex:indexRow];
        NSArray * picArray = [self getPicList:topic.attachments];
        
        for (int i = 0; i < [picArray count]; i++)
        {
            Attachment * att = [picArray objectAtIndex:i];
            DemoPhoto *photo = [[DemoPhoto alloc] initWithURL:[NSURL URLWithString:att.attUrl]];
            [photoDataSource addObject:photo];
        }
        CXPhotoBrowser * browser = [[CXPhotoBrowser alloc] initWithPhotoArray:photoDataSource];
        [browser setInitialPageIndex:indexNum];
        
        [self presentViewController:browser animated:YES completion:nil];
    }
    else {
        Topic * topic = [topicsArray objectAtIndex:indexRow];
        NSArray * docArray = [self getDocList:topic.attachments];
        Attachment * att = [docArray objectAtIndex:indexNum];
        
        WebViewController * webViewController = [[WebViewController alloc] initWithURL:att.attFileName AttachmentURL:[NSURL URLWithString:att.attUrl]];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:webViewController];

        [self presentViewController:nav animated:YES completion:nil];
    }
}

-(void)userHeadTaped:(int)row
{
    Topic *selectTopic = [topicsArray objectAtIndex:row];
    UserInfoViewController * userInfoViewController;
    userInfoViewController = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
    userInfoViewController.userString = selectTopic.author;
    userInfoViewController.mDelegate = self;
    [self presentPopupViewController:userInfoViewController animationType:MJPopupViewAnimationSlideTopBottom];
}

-(void)replyButtonTaped:(int)row
{
    Topic *selectTopic = [topicsArray objectAtIndex:row];
    if (myBBS.mySelf == nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先登录";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
    } else {
        PostTopicViewController * postTopicViewController = [[PostTopicViewController alloc] init];
        postTopicViewController.postType = 1;
        postTopicViewController.rootTopic = selectTopic;
        postTopicViewController.mDelegate = nil;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postTopicViewController];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:nav animated:YES completion:nil];
    }
}


-(void)editButtonTaped:(int)row;
{
    Topic *selectTopic = [topicsArray objectAtIndex:row];
    PostTopicViewController * postTopicViewController = [[PostTopicViewController alloc] init];
    postTopicViewController.postType = 2;
    postTopicViewController.rootTopic = selectTopic;
    postTopicViewController.mDelegate = nil;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postTopicViewController];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - ModalViewControllerDelegate
- (void)didSelectPage:(int)index
{
    currentLowPage = index + 1;
    currentHighPage = index + 1;
    currentShowPage = index + 1;
    [self switchPageChangeView];
    [self refreshPageButton];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray * topics;
        if (rootTopic.ID == rootTopic.gID) {
            topics = [BBSAPI singleTopic:rootTopic.board ID:rootTopic.ID Page:currentShowPage User:myBBS.mySelf];
        } else {
            topics = [BBSAPI replyTopic:rootTopic.board ID:rootTopic.ID Start:0 User:myBBS.mySelf];
        }
        
        if (topics != nil) {
            [topicsArray removeAllObjects];
            [topicsArray addObjectsFromArray:topics];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [customTableView.mTableView setContentOffset:CGPointMake(0, 0)];
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
