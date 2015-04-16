//
//  SingleTopicCell.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
#import "DataModel.h"
#import "AttachmentView.h"
#import "ImageAttachmentView.h"
#import "TQRichTextView.h"
#import "UIImageView+WebCache.h"
#import <MediaPlayer/MediaPlayer.h>

@protocol SingleTopicCellVideoDelegate <NSObject>
-(void)imageAttachmentViewInCellTaped:(int)indexRow Index:(int)indexNum;
-(void)attachmentViewInCellTaped:(BOOL)isPhoto IndexRow:(int)indexRow IndexNum:(int)indexNum;
-(void)userHeadTaped:(int)index;
-(void)replyButtonTaped:(int)index;
-(void)editButtonTaped:(int)index;
@end

@interface SingleTopicCellVideo : UITableViewCell<ImageAttachmentViewDelegate, AttachmentViewDelegate>
{
    IBOutlet UILabel * articleTitleLabel;
    IBOutlet UILabel * authorLabel;
    IBOutlet UILabel * loushu;
    IBOutlet TQRichTextView * contentLabel;
    IBOutlet UILabel * articleDateLabel;
    IBOutlet UIImageView * authorFaceImageView;
    IBOutlet UIButton * editButton;
    
    IBOutlet UILabel * likeLabel;
    IBOutlet UIImageView * newsImageView;
    AVObject *news;
    
    int ID;
    int read;
    NSDate * time;
    NSString * title;
    NSString * content;
    NSString * author;
    NSURL * authorFaceURL;
    NSArray * attachments;
    
    NSMutableArray * attachmentsViewArray;
    
    MPMoviePlayerController *playerController;
}

@property(nonatomic, assign)int ID;
@property(nonatomic, assign)int read;
@property(nonatomic, strong)NSDate * time;
@property(nonatomic, strong)NSString * title;
@property(nonatomic, strong)NSString * author;
@property(nonatomic, strong)NSURL * authorFaceURL;
@property(nonatomic, strong)NSString * content;
@property(nonatomic, strong)NSArray * attachments;
@property(nonatomic, strong)NSArray * attachmentsViewArray;
@property(nonatomic, strong)MPMoviePlayerController *playerController;
@property(nonatomic, assign)int indexRow;
@property(nonatomic, assign)id mDelegate;

@property(nonatomic, strong)AVObject *news;

-(IBAction)reply:(id)sender;
-(IBAction)edit:(id)sender;
@end
