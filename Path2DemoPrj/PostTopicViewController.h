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

@interface PostTopicViewController : UIViewController<UITextFieldDelegate, UIScrollViewDelegate> {
    UITextField * postTitle;
    UILabel * postTitleCount;
    UITextView * postContent;
    UIScrollView * postScrollView;
    
    int postType; // 发表类型，0发表新文章，1回帖，2修改文章
    id __unsafe_unretained mDelegate;
}

@property(nonatomic, strong)Topic * rootTopic;
@property(nonatomic, strong)NSString * boardName;
@property(nonatomic, assign)int postType;
@property(nonatomic, unsafe_unretained)id mDelegate;
@property(nonatomic, strong)UIToolbar *keyboardToolbar;

-(void)cancel;
-(void)send;
-(IBAction)operateAtt:(id)sender;

@end
