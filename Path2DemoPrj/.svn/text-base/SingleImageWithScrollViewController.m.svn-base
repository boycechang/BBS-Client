//
//  SingleImageWithScrollViewController.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 1/5/13.
//  Copyright (c) 2012 SEU. All rights reserved.
//

#import "SingleImageWithScrollViewController.h"

@implementation SingleImageWithScrollViewController
@synthesize mDelegate;
@synthesize imageData;
@synthesize imageRealView;
@synthesize isGIF;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isGIF = NO;
        CGRect rect = [[UIScreen mainScreen] bounds];
        imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, rect.size.height-64)];
        imageScrollView.directionalLockEnabled = NO;
        imageScrollView.decelerationRate = 0.0;
        imageScrollView.backgroundColor = [UIColor clearColor]; 
        imageScrollView.showsVerticalScrollIndicator = NO; 
        imageScrollView.showsHorizontalScrollIndicator = NO; 
        imageScrollView.delegate = self;
        
        //最多放大到3倍
        [imageScrollView setMinimumZoomScale:1.0];
        [imageScrollView setMaximumZoomScale:3.0];
        [self.view addSubview:imageScrollView];
        imageRealView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, rect.size.height-64)];
        [imageRealView setContentMode:UIViewContentModeScaleAspectFit];
        [imageScrollView addSubview:imageRealView];
        
        //spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        //[spinner setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)];
        //[imageRealView addSubview:spinner];
    }
    return self;
}
-(void)loadBigImageView
{
    //[imageLabel setText:imageData.title];
    [imageLabel setText:@"正在载入"];
    if (isGIF) {
        CGRect rect = [[UIScreen mainScreen] bounds];
        UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, rect.size.height - 64)];
        [self.view addSubview:webView];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageData.url]]];
        [imageLabel setText:imageData.title];
    }
    ////////////mine////////////
    else
    {
        if (!networkQueue) {
            networkQueue = [[ASINetworkQueue alloc] init];
        }
        failed = NO;
        [networkQueue reset];
        [networkQueue setDownloadProgressDelegate:progressIndicator];
        [networkQueue setRequestDidFinishSelector:@selector(imageFetchComplete:)];
        [networkQueue setRequestDidFailSelector:@selector(imageFetchFailed:)];
        [networkQueue setShowAccurateProgress:YES];
        [networkQueue setDelegate:self];
        
        ASIHTTPRequest *request;
        request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:imageData.url]];
        [request setDownloadDestinationPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageData.title]];
        [request setDownloadProgressDelegate:progressIndicator];
        //[request setUserInfo:[NSDictionary dictionaryWithObject:@"request1" forKey:@"name"]];
        [networkQueue addOperation:request];
        [networkQueue go];
    }
    ////////////////////////////
    //[spinner startAnimating];
//    if (imageData.image == nil) {
//        //[imageRealView setImage:imageData.waitImage];
//        ImageDownloader * imageDownloader = [[ImageDownloader alloc] init];
//        imageDownloader.imageData = imageData;
//        imageDownloader.imageView = imageRealView;
//        [imageDownloader startDownload];
//    }
//    else {
//        //for(UIView *indicatorview in [imageRealView subviews])
//        //    [indicatorview stopAnimation];
//        [imageRealView setImage:imageData.image];
//    }
}

- (void)imageFetchComplete:(ASIHTTPRequest *)request
{
	UIImage *img = [UIImage imageWithContentsOfFile:[request downloadDestinationPath]];
	if (img) {
        imageData.image=img;
		[imageRealView setImage:img];
        [imageLabel setText:imageData.title];
	}
    [progressIndicator setHidden:YES];
}

- (void)imageFetchFailed:(ASIHTTPRequest *)request
{
	if (!failed) {
		if ([[request error] domain] != NetworkRequestErrorDomain || [[request error] code] != ASIRequestCancelledErrorType) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"图片下载失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
			[alertView show];
            
		}
        [imageLabel setText:@">_<"];
		failed = YES;
	}
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

 #pragma mark -
 #pragma mark UIScrollViewDelegate
 - (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
 {
     return imageRealView;
 }
 - (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
 {
     if (scale < 1) {
         [scrollView setZoomScale:1 animated:YES];
     }
 }

-(IBAction)back:(id)sender
{
    NSFileManager *fm=[[NSFileManager alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fm contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while (filename = [e nextObject])
    {
        //NSLog(@"filename:%@",filename);
        [fm removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
    }
    [networkQueue reset];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)save:(id)sender
{
    //UIImage *img = [UIImage imageWithContentsOfFile:[request downloadDestinationPath]];
    if (imageData.image != nil) {
        UIImageWriteToSavedPhotosAlbum(imageData.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"图片还未加载好，再等一等吧～" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark -
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error
 contextInfo:(void*)contextInfo
{// Was there an error?
    if(error !=NULL){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"图片保存失败" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"图片保存成功" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
    }
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
