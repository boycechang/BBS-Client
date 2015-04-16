//
//  SingleTopicCommentCell.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleTopicCommentCell : UITableViewCell
{
    IBOutlet UILabel * authorLabel;
    IBOutlet UILabel * contentTextView;
    IBOutlet UILabel * commentToTextView;
    IBOutlet UILabel * loushu;
    IBOutlet UIImageView * attNotifier;
    int ID;
    NSDate * time;
    
    NSString * content;
    NSString * author;
    NSString * quoter;
    NSString * quote;
    BOOL attExist;
    BOOL attExistPhoto;
    int read;
    
    int num;
    
    NSArray * attachments;
    UIViewController * attachmentsViewController;
}
@property(nonatomic, assign)BOOL attExist;
@property(nonatomic, assign)BOOL attExistPhoto;
@property(nonatomic, assign)int ID;
@property(nonatomic, strong)NSDate * time;
@property(nonatomic, strong)NSString * author;
@property(nonatomic, strong)NSString * content;
@property(nonatomic, strong)NSString * quoter;
@property(nonatomic, strong)NSString * quote;
@property(nonatomic, strong)NSArray * attachments;
@property(nonatomic, strong)UIViewController * attachmentsViewController;
@property(nonatomic, assign)int read;
@property(nonatomic, assign)int num;
-(void)setReadyToShow;
@end
