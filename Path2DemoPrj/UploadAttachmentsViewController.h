//
//  UploadAttachmentsViewController.h
//  虎踞龙蟠
//
//  Created by Huang Feiqiao on 13-2-3.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSAPI.h"
#import "AppDelegate.h"
#import "PostTopicViewController.h"
#import "FPActivityView.h"
#import <MBProgressHUD.h>

@interface UploadAttachmentsViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource>
{
    UIImagePickerController *imagePicker;
    int postType;
    NSArray *attList;
    UITableView *attTable;
    NSString *board;
    int postId;
    FPActivityView *activityView;
    MBProgressHUD *HUD;
    UIImage *image;
    NSString *imageFileName;
    NSURL *theUrl;
    NSString *openString;
    int curRow;

    NSArray *_photos;
}
@property(nonatomic, assign)int postId;
@property(nonatomic, strong)NSString *board;
@property(nonatomic, strong)NSArray *attList;
@property(nonatomic, strong)UIImage *image;
@property(nonatomic, assign)int postType;
@property (nonatomic, strong) NSArray *photos;

- (IBAction)pickImageFromAlbum:(id)sender;
- (IBAction)pickImageFromCamera:(id)sender;
- (IBAction)cancel:(id)sender;
@end
