//
//  SingleTopicCell.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/29/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleTopicCell : UITableViewCell
{
    IBOutlet UILabel * articleTitleLabel;
    IBOutlet UILabel * authorLabel;
    IBOutlet UITextView * __unsafe_unretained contentTextView;
    IBOutlet UILabel * contentLabel;
    IBOutlet UIImageView * attNotifier;
    int ID;
    NSDate * time;
    NSString * title;
    NSString * content;
    NSString * author;
    BOOL attExist;
    BOOL attExistPhoto;
    int read;
    
    NSArray * attachments;
    UIViewController * attachmentsViewController;
}
@property(nonatomic, assign)BOOL attExist;
@property(nonatomic, assign)BOOL attExistPhoto;
@property(nonatomic, assign)int ID;
@property(nonatomic, strong)NSDate * time;
@property(nonatomic, strong)NSString * title;
@property(nonatomic, strong)NSString * author;
@property(nonatomic, strong)NSString * content;
@property(nonatomic, strong)NSArray * attachments;
@property(nonatomic, strong)UIViewController * attachmentsViewController;
@property(nonatomic, unsafe_unretained)IBOutlet UITextView * contentTextView;
@property(nonatomic, assign)int read;
-(void)setReadyToShow;
@end
