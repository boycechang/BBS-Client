//
//  PostTopicViewController.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/5/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BBSAPI.h"
#import "UploadAttachmentsViewController.h"
#import "UINavigationController+SGProgress.h"
#import "WUDemoKeyboardBuilder.h"
#import "Memo.h"

@interface PostMapNewsViewController : UIViewController<UITextFieldDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate>
{
    MBProgressHUD *HUD;
    
    UITextField * postTitle;
    UILabel * postTitleCount;
    UITextView * postContent;
    UIScrollView * postScrollView;
    UIToolbar *keyboardToolbar;
    UIImageView *imageView;
    
    NSData *videoData;
    UIImage *photo;
    
    Topic * rootTopic;
    NSString * boardName;
    
    int postType; // 发表类型，0发表新文章，1回帖，2修改文章
    MyBBS * myBBS;
    id __unsafe_unretained mDelegate;
}
@property(nonatomic, strong)Topic * rootTopic;
@property(nonatomic, strong)NSString * boardName;
@property(nonatomic, assign)int postType;
@property(nonatomic, strong)UIToolbar *keyboardToolbar;
@property(nonatomic, strong)UIImage *photo;
@property(nonatomic, strong)NSData *videoData;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) AVGeoPoint *geoPoint;

- (UIImage *)image: (UIImage *)oldimage fillSize: (CGSize) viewsize;
-(void)cancel;
-(void)send;

@end
