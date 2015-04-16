//
//  TopTenTableView.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopTenTableViewCell : UITableViewCell
{
    IBOutlet UILabel * articleTitleLabel;
    IBOutlet UILabel * authorLabel;
    IBOutlet UILabel * readandreplyLabel;
    IBOutlet UILabel * boardLabel;
    IBOutlet UILabel * isTop;
    int ID;
    NSDate * time;
    NSString * title;
    NSString * author;
    NSString * board;
    int replies;
    int read;
    BOOL unread;
    BOOL top;
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
-(void)setReadyToShow;
-(void)showAinmationWhenSeleceted;
@end
