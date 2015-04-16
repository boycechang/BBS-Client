//
//  TopTenTableView.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface GlobalImageTableViewCell : UITableViewCell
{
    IBOutlet UIView * backView;
    IBOutlet UILabel * articleTitleLabel;
    IBOutlet UILabel * authorLabel;
    IBOutlet UILabel * readandreplyLabel;
    IBOutlet UILabel * boardLabel;
    IBOutlet UILabel * isTop;
    IBOutlet UILabel * articleDateLabel;
    IBOutlet UIImageView * attImageView;
    int ID;
    NSDate * time;
    NSString * title;
    NSString * author;
    NSString * board;
    int replies;
    int read;
    BOOL unread;
    BOOL top;
    BOOL mark;
    NSURL * imageURL;
}
@property(nonatomic, assign)int ID;
@property(nonatomic, strong)NSDate * time;
@property(nonatomic, strong)NSString * title;
@property(nonatomic, strong)NSString * author;
@property(nonatomic, strong)NSString * board;
@property(nonatomic, assign)int replies;
@property(nonatomic, assign)int read;
@property(nonatomic, assign)BOOL unread;
@property(nonatomic, assign)BOOL top;
@property(nonatomic, assign)BOOL mark;
@property(nonatomic, strong)NSURL * imageURL;
@property(nonatomic, strong)UILabel * articleTitleLabel;
@end
