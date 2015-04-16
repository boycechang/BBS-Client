//
//  UploadAttachmentsViewController.m
//  虎踞龙蟠
//
//  Created by Huang Feiqiao on 13-2-3.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "UploadAttachmentsViewController.h"


@implementation UploadAttachmentsViewController
@synthesize mDelegate;
@synthesize postType;
@synthesize attList;
@synthesize board;
@synthesize image;
@synthesize postId;
@synthesize photos = _photos;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) refreshAttlist
{
    if (postType==0 || postType==1) {//新帖或回复
        //attList=[[NSArray alloc] init];
        attList=[BBSAPI getAttachmentsFromTopic:-1 andBoard:nil token:myBBS.mySelf.token];
    }
    else
    {//修改
        attList=[BBSAPI getAttachmentsFromTopic:postId andBoard:board token:myBBS.mySelf.token];
    }
    [HUD removeFromSuperview];
    HUD = nil;
    [attTable reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    attTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view insertSubview:HUD atIndex:0];
	HUD.labelText = @"载入中...";
	[HUD showWhileExecuting:@selector(refreshAttlist) onTarget:self withObject:nil animated:YES];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancel:(id)sender
{
    //[mDelegate passValue:attList];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)pickImageFromAlbum:(id)sender
{
    DLCImagePickerController *picker = [[DLCImagePickerController alloc] init];
    picker.delegate = self;
    [self presentModalViewController:picker animated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [attList count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] init];
    cell.textLabel.text=[[attList objectAtIndex:indexPath.row] attFileName];
    [cell.textLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
    [cell.textLabel setShadowOffset:CGSizeMake(0, 1)];
    [cell.textLabel setShadowColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    curRow=indexPath.row;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"附件选项"
                                  delegate:self //actionSheet的代理，按钮被按下时收到通知，然后回调协议中的相关方法
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"删除"
                                  otherButtonTitles:@"预览",nil];
    //展示actionSheet
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIAlertView *alert = nil;
    if(buttonIndex == [actionSheet destructiveButtonIndex]){//确定
        //NSLog(@"确定");
        //执行删除操作
        [self doDelete];
    }else if(buttonIndex == [actionSheet cancelButtonIndex]){//取消
        
    }
    else{
        //预览附件
        [self previewAtt];
    }
}

//预览附件
-(void) previewAtt
{
    NSString * curAttUrlString=[[attList objectAtIndex:curRow] attUrl];
    
    if ([curAttUrlString hasSuffix:@".png"] || [curAttUrlString hasSuffix:@".jpg"] || [curAttUrlString hasSuffix:@".jpeg"] || [curAttUrlString hasSuffix:@".JPEG"] || [curAttUrlString hasSuffix:@".PNG"] || [curAttUrlString hasSuffix:@".JPG"]) {
        
        NSMutableArray * photosArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [attList count]; i++) {
            NSString * attUrlString=[[attList objectAtIndex:i] attUrl];
            if ([attUrlString hasSuffix:@".png"] || [attUrlString hasSuffix:@".jpg"] || [attUrlString hasSuffix:@".jpeg"] || [attUrlString hasSuffix:@".JPEG"] || [attUrlString hasSuffix:@".PNG"] || [attUrlString hasSuffix:@".JPG"])
            [photosArray addObject:[MWPhoto photoWithURL:[NSURL URLWithString:attUrlString]]];
        }
        self.photos = photosArray;
        
        MWPhotoBrowser * browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = YES;
        [browser setInitialPageIndex:curRow];
        //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        nc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:nc animated:YES completion:nil];
    }
    else if ([curAttUrlString hasSuffix:@".gif"] || [curAttUrlString hasSuffix:@".GIF"]) {
        ImageData * imageData = [[ImageData alloc] init];
        imageData.url = curAttUrlString;
        imageData.title = [[attList objectAtIndex:curRow] attFileName];
        
        SingleImageWithScrollViewController * singleImageWithScrollViewController = [[SingleImageWithScrollViewController alloc] initWithNibName:@"SingleImageWithScrollViewController" bundle:nil];
        singleImageWithScrollViewController.mDelegate = nil;
        singleImageWithScrollViewController.imageData = imageData;
        singleImageWithScrollViewController.isGIF = TRUE;
        [singleImageWithScrollViewController loadBigImageView];
        [self presentViewController:singleImageWithScrollViewController animated:YES completion:nil];
    }
    else{
        openString = curAttUrlString;
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用Safari打开此附件" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好",nil];
        [alert show];
    }

}

//处理safari打开附件
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

-(void)doDelete
{
    int attid=[[attList objectAtIndex:curRow] attId];
    NSString * delUrlString;
    if (postType==0 || postType==1) {//新帖或者回复
        delUrlString=[NSString stringWithFormat:@"http://bbs.seu.edu.cn/api/attachment/delete.js?token=%@&attid=%d",myBBS.mySelf.token,attid];
    }
    else{
        
        delUrlString=[NSString stringWithFormat:@"http://bbs.seu.edu.cn/api/attachment/delete.js?token=%@&board=%@&id=%d&attid=%d",myBBS.mySelf.token,board,postId,attid];
    }
    NSURL *delUrl=[NSURL URLWithString:delUrlString];
    attList=[BBSAPI delImg:delUrl];
    [attTable reloadData];
}


-(NSString *)stringWithUUID
{
    CFUUIDRef uuidObj = CFUUIDCreate(kCFAllocatorDefault);
    //NSString* uuidString = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, uuidObj);
    CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidObj);
    NSString* uuidString = [NSString stringWithString:(__bridge NSString*)strRef];
    CFRelease(strRef);
    CFRelease(uuidObj);
    return uuidString;
}


-(void) imagePickerControllerDidCancel:(DLCImagePickerController *)picker{
    [self dismissModalViewControllerAnimated:YES];
}


- (void) imagePickerController:(DLCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [self dismissModalViewControllerAnimated:YES];

    self.image = [UIImage imageWithData:[info objectForKey:@"data"]];
    imageFileName=[NSString stringWithFormat:@"%@.%@",[self stringWithUUID],@"JPG"];
    
    NSString *urlString;
    
    if (postType==0 || postType==1) {//新帖或者回复
        urlString=[NSString stringWithFormat:@"http://bbs.seu.edu.cn/api/attachment/add.js?token=%@",myBBS.mySelf.token];
    }
    else{
        urlString=[NSString stringWithFormat:@"http://bbs.seu.edu.cn/api/attachment/add.js?token=%@&board=%@&id=%d",myBBS.mySelf.token,board,postId];
    }
    theUrl=[NSURL URLWithString:urlString];
    
    //NSArray *a=[[BBSAPI postImageto:theUrl withImage:image andToken:myBBS.mySelf.token] retain];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view insertSubview:HUD atIndex:5];
	HUD.labelText = @"上传中...";
    [HUD showWhileExecuting:@selector(uploadImage) onTarget:self withObject:nil animated:YES];
}

- (UIImage *)image: (UIImage *)oldimage fillSize: (CGSize) viewsize

{
    CGSize size = oldimage.size;
    
    CGFloat scalex = viewsize.width / size.width;
    CGFloat scaley = viewsize.height / size.height;
    CGFloat scale = MAX(scalex, scaley);
    
    UIGraphicsBeginImageContext(viewsize);
    
    CGFloat width = size.width * scale;
    CGFloat height = size.height * scale;
    
    float dwidth = ((viewsize.width - width) / 2.0f);
    float dheight = ((viewsize.height - height) / 2.0f);
    
    CGRect rect = CGRectMake(dwidth, dheight, size.width * scale, size.height * scale);
    [oldimage drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

-(void)uploadImage
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    int uploadImage = [defaults integerForKey:@"uploadImage"];
    UIImage * newImage = [self image:self.image fillSize:CGSizeMake(self.image.size.width/(uploadImage+1), self.image.size.height/(uploadImage+1))];
    
    attList=[BBSAPI postImg:imageFileName Image:newImage toUrl:theUrl];
    
    [HUD removeFromSuperview];
    [attTable reloadData];
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

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}
@end
