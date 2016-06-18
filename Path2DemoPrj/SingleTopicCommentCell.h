//
//  SingleTopicCommentCell.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "AttachmentView.h"
#import "ImageAttachmentView.h"
#import "TQRichTextView.h"
#import "UIImageView+AFNetworking.h"

@protocol SingleTopicCommentCellDelegate <NSObject>
-(void)imageAttachmentViewInCellTaped:(int)indexRow Index:(int)indexNum;
-(void)attachmentViewInCellTaped:(BOOL)isPhoto IndexRow:(int)indexRow IndexNum:(int)indexNum;
-(void)userHeadTaped:(int)index;
-(void)replyButtonTaped:(int)index;
-(void)editButtonTaped:(int)index;
@end

@interface SingleTopicCommentCell : UITableViewCell<ImageAttachmentViewDelegate, AttachmentViewDelegate>
{
    IBOutlet UILabel * authorLabel;
    IBOutlet TQRichTextView * contentTextView;
    IBOutlet UILabel * loushu;
    IBOutlet UILabel * articleDateLabel;
    IBOutlet UIImageView * authorFaceImageView;
    IBOutlet UIButton * editButton;
    
    int ID;
    NSDate * time;
    
    NSString * content;
    NSString * author;
    NSURL * authorFaceURL;
    NSString * quoter;
    NSString * quote;
    int read;
    
    int num;
    
    NSArray * attachments;
    NSMutableArray * attachmentsViewArray;
}

@property(nonatomic, assign)int ID;
@property(nonatomic, assign)int read;
@property(nonatomic, assign)int num;
@property(nonatomic, strong)NSDate * time;
@property(nonatomic, strong)NSString * author;
@property(nonatomic, strong)NSURL * authorFaceURL;
@property(nonatomic, strong)NSString * content;
@property(nonatomic, strong)NSString * quoter;
@property(nonatomic, strong)NSString * quote;
@property(nonatomic, strong)NSArray * attachments;
@property(nonatomic, strong)NSMutableArray * attachmentsViewArray;

@property(nonatomic, assign)int indexRow;
@property(nonatomic, assign)id mDelegate;

-(IBAction)reply:(id)sender;
-(IBAction)edit:(id)sender;
@end
