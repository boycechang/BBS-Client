//
//  PostTopicViewController.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/5/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "PostMapNewsViewController.h"

@implementation PostMapNewsViewController
@synthesize rootTopic;
@synthesize boardName;
@synthesize postType;
@synthesize keyboardToolbar;
@synthesize photo;
@synthesize videoData;

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
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, rect.size.height)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"发布身边事儿";
    
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    UIBarButtonItem *sendButton =[[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    
    NSArray *array = [NSArray arrayWithObjects:sendButton, nil];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItems = array;
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        postScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    }
    else {
        postScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    }

    postScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 64 + 1);
    postScrollView.delegate = self;
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 21)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor lightGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"标题";
    titleLabel.layer.cornerRadius = 2.0f;
    titleLabel.clipsToBounds = YES;
    
    postTitle = [[UITextField alloc] initWithFrame:CGRectMake(60, 10, self.view.frame.size.width - 115, 21)];
    postTitle.textColor = [UIColor lightGrayColor];
    postTitle.placeholder = @"添加标题";
    [postTitle addTarget:self action:@selector(inputTitle) forControlEvents:UIControlEventEditingChanged];
    
    postTitleCount = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, 10, 30, 21)];
    postTitleCount.textColor = [UIColor lightGrayColor];
    postTitleCount.textAlignment = NSTextAlignmentRight;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, 5, 30, 30)];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    imageView.backgroundColor = [UIColor whiteColor];
    
    postContent = [[UITextView alloc] initWithFrame:CGRectMake(5, 35, self.view.frame.size.width - 10, self.view.frame.size.height - 30 - 64)];
    [postContent setFont:[UIFont systemFontOfSize:17]];
    [postScrollView addSubview:titleLabel];
    [postScrollView addSubview:postTitle];
    [postScrollView addSubview:postTitleCount];
    [postScrollView addSubview:imageView];
    [postScrollView addSubview:postContent];
    [self.view addSubview:postScrollView];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myBBS = appDelegate.myBBS;

    [postTitle setText:@""];
    [postTitle becomeFirstResponder];
    [postContent setText:@""];
    [postTitleCount setText:[NSString stringWithFormat:@"%i", [postTitle.text length]]];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
    keyboardToolbar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    
    UIBarButtonItem *spaceBarItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    UIBarButtonItem *spaceBarItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *spaceBarItem3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *cameraBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera"] style:UIBarButtonItemStylePlain target:self action:@selector(choosePhoto:)];
    cameraBarItem.tag = 0;
    
    UIBarButtonItem *videoBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"video"] style:UIBarButtonItemStylePlain target:self action:@selector(choosePhoto:)];
    videoBarItem.tag = 1;
    
    UIBarButtonItem *albumBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"album"] style:UIBarButtonItemStylePlain target:self action:@selector(choosePhoto:)];
    albumBarItem.tag = 2;
    
    [keyboardToolbar setItems:[NSArray arrayWithObjects:spaceBarItem, cameraBarItem, spaceBarItem1,  videoBarItem, spaceBarItem2, albumBarItem, spaceBarItem3, nil]];
    
    postContent.inputAccessoryView = keyboardToolbar;
    postTitle.inputAccessoryView = keyboardToolbar;
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(switchToDefaultKeyboard)
               name:WUEmoticonsKeyboardDidSwitchToDefaultKeyboardNotification
             object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100;
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [postTitle resignFirstResponder];
    [postContent resignFirstResponder];
}

-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)send
{
    [postTitle resignFirstResponder];
    [postContent resignFirstResponder];
    
    if ([postTitle.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请添加标题";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.8];
    } else if ([postContent.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请添加正文";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.8];
    } else if (self.photo == nil && self.videoData == nil){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请添加图片或视频";
        hud.margin = 30.f;
        hud.yOffset = 0.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:0.8];
    } else {
        AVObject *news = [AVObject objectWithClassName:@"News"];
        [news setObject:postTitle.text forKey:@"title"];
        [news setObject:postContent.text forKey:@"content"];
        
        if (self.videoData != nil) {
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            
            //HUD.delegate = self;
            HUD.minSize = CGSizeMake(135.f, 135.f);
            
            [HUD show:YES];
            //[HUD showWhileExecuting:@selector(myMixedTask) onTarget:self withObject:nil animated:YES];
            
            HUD.mode = MBProgressHUDModeDeterminate;
            HUD.labelText = @"上传中...";

            AVFile *videoFile = [AVFile fileWithName:@"video.mov" data:self.videoData];
            
            [videoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.labelText = @"视频上传完成";
                [HUD hide:YES afterDelay:0.3];
                
                [news setObject:videoFile forKey:@"video"];
                [news setObject:self.geoPoint forKey:@"location"];
                AVUser * currentUser = [AVUser currentUser];
                [news setObject:currentUser forKey:@"user"];
                [news setObject:currentUser.username forKey:@"username"];
                [news setObject:[NSNumber numberWithInt:1] forKey:@"is_published"];
                [self.navigationController showSGProgressWithDuration:10 andTintColor:self.navigationController.navigationBar.tintColor andTitle:@"发送中..." ];
                [news saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [self.navigationController finishSGProgress];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                    else {
                        [self.navigationController finishSGProgress];
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = @"发送失败！";
                        hud.margin = 30.f;
                        hud.yOffset = 0.f;
                        hud.removeFromSuperViewOnHide = YES;
                        [hud hide:YES afterDelay:0.8];
                    }
                }];
                
            } progressBlock:^(NSInteger percentDone) {
                HUD.progress = percentDone / 100.0;
            }];
        }
        else {
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            
            //HUD.delegate = self;
            HUD.minSize = CGSizeMake(135.f, 135.f);
            
            [HUD show:YES];
            //[HUD showWhileExecuting:@selector(myMixedTask) onTarget:self withObject:nil animated:YES];
            
            HUD.mode = MBProgressHUDModeDeterminate;
            HUD.labelText = @"上传中...";
            
            NSData *imageData = UIImagePNGRepresentation(self.photo);
            AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];
            
            [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.labelText = @"图片上传完成";
                [HUD hide:YES afterDelay:0.3];
                
                [news setObject:imageFile forKey:@"image"];
                [news setObject:self.geoPoint forKey:@"location"];
                AVUser * currentUser = [AVUser currentUser];
                [news setObject:currentUser forKey:@"user"];
                [news setObject:currentUser.username forKey:@"username"];
                [news setObject:[NSNumber numberWithInt:1] forKey:@"is_published"];
                [self.navigationController showSGProgressWithDuration:10 andTintColor:self.navigationController.navigationBar.tintColor andTitle:@"发送中..." ];
                [news saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [self.navigationController finishSGProgress];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                    else {
                        [self.navigationController finishSGProgress];
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = @"发送失败！";
                        hud.margin = 30.f;
                        hud.yOffset = 0.f;
                        hud.removeFromSuperViewOnHide = YES;
                        [hud hide:YES afterDelay:0.8];
                    }
                }];
                
            } progressBlock:^(NSInteger percentDone) {
                HUD.progress = percentDone / 100.0;
            }];
            
        }
    }
}

#pragma mark -
#pragma mark textViewDelegate
-(void)inputTitle
{
    int count = [postTitle.text length];
    [postTitleCount setText:[NSString stringWithFormat:@"%i",count]];
    if (count == 0) {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    else {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
}

#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    NSDictionary *userInfo = [notification userInfo];
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    
    [postScrollView setContentOffset:CGPointMake(0, 0)];
    [postContent setFrame:CGRectMake(5, 35, self.view.frame.size.width - 10, self.view.frame.size.height - 64 - 35 - keyboardRect.size.height - 2)];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    if (postContent.contentSize.height < self.view.frame.size.height - 64 - 35) {
        [postContent setFrame:CGRectMake(5, 35, self.view.frame.size.width - 10, self.view.frame.size.height - 64 - 35)];
    }
    else
    {
        [postContent setFrame:CGRectMake(5, 35, self.view.frame.size.width - 10, postContent.contentSize.height)];
        [postScrollView setContentSize:CGSizeMake(postScrollView.contentSize.width, postContent.contentSize.height + 35)];
    }
}

- (void)switchToDefaultKeyboard {
    [postContent resignFirstResponder];
    
    [postContent switchToDefaultKeyboard];
    postContent.inputAccessoryView = keyboardToolbar;
    
    [postContent becomeFirstResponder];
}

- (void)switchToEmotionKeyboard {
    [postContent resignFirstResponder];
    
    [postContent switchToEmoticonsKeyboard:[WUDemoKeyboardBuilder sharedEmoticonsKeyboard]];
    postContent.inputAccessoryView = nil;
    
    [postContent becomeFirstResponder];
}

- (IBAction)choosePhoto:(id)sender
{
    [postTitle resignFirstResponder];
    [postContent resignFirstResponder];
    
    UIBarButtonItem *barButton = (UIBarButtonItem *)sender;
    NSInteger buttonIndex = barButton.tag;
    NSUInteger sourceType = 0;
    switch (buttonIndex) {
        case 0:
        case 1:
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 2:
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        default:
            return;
    }
    
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.delegate = self;
	imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    switch (buttonIndex) {
        case 1:
            imagePickerController.mediaTypes = [NSArray arrayWithObjects:@"public.movie",nil];
            imagePickerController.videoMaximumDuration = 8.0;
            break;
        default:
            break;
    }
    
	[self presentViewController:imagePickerController animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate
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


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        self.photo = [info objectForKey:UIImagePickerControllerEditedImage];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        int uploadImage = [defaults integerForKey:@"uploadImage"];
        UIImage * newImage = [self image:self.photo fillSize:CGSizeMake(self.photo.size.width/(uploadImage+1), self.photo.size.height/(uploadImage+1))];
        self.photo = newImage;
        self.videoData = nil;
        [imageView setImage:self.photo];
    }
    else if ([mediaType isEqualToString:@"public.movie"]){
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        self.videoData = [NSData dataWithContentsOfURL:videoURL];
        self.photo = nil;
        [imageView setImage:[UIImage imageNamed:@"VideoIcon"]];
    }
    [postContent becomeFirstResponder];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:nil];
    [postContent becomeFirstResponder];
}


#pragma mark - CLLocationManagerDelegate
// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.geoPoint = [AVGeoPoint geoPointWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
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
