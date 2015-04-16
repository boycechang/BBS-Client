//
//  UploadAttachmentsViewController.h
//  虎踞龙蟠
//
//  Created by Huang Feiqiao on 13-2-3.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSAPI.h"
#import "MyBBS.h"
#import "AppDelegate.h"
#import "PostTopicViewController.h"
#import "ImageData.h"
#import "SingleImageWithScrollViewController.h"
#import "MWPhotoBrowser.h"
#import "DLCImagePickerController.h"

@interface UploadAttachmentsViewController : UIViewController<UIImagePickerControllerDelegate, MWPhotoBrowserDelegate, DLCImagePickerDelegate>
{
    UIImagePickerController *imagePicker;
    NSObject<UIViewPassValueDelegate> * __unsafe_unretained mDelegate;
    MyBBS * myBBS;
    int postType;
    NSArray *attList;
    IBOutlet UITableView *attTable;
    NSString *board;
    int postId;
    MBProgressHUD * HUD;
    UIImage *image;
    NSString *imageFileName;
    NSURL *theUrl;
    NSString *openString;
    int curRow;

    NSArray *_photos;
}
@property(nonatomic, assign)int postId;
@property(nonatomic, strong)NSString *board;
@property(nonatomic, strong)UIImage *image;
@property(nonatomic, assign)int postType;
@property(nonatomic, unsafe_unretained)NSObject<UIViewPassValueDelegate> * mDelegate;
@property(nonatomic, strong)NSArray *attList;
@property (nonatomic, strong) NSArray *photos;
- (IBAction)pickImageFromAlbum:(id)sender;
-(IBAction)cancel:(id)sender;
@end
