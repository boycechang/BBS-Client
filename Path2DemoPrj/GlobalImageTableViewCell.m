//
//  TopTenTableView.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "GlobalImageTableViewCell.h"
#import "BBSAPI.h"

@implementation GlobalImageTableViewCell
@synthesize ID;
@synthesize title;
@synthesize author;
@synthesize board;
@synthesize time;
@synthesize replies;
@synthesize read;
@synthesize unread;
@synthesize top;
@synthesize mark;
@synthesize imageURL;
@synthesize articleTitleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        self.layer.cornerRadius = 10.0;
        self.clipsToBounds = YES;
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UIView
- (void)layoutSubviews {
	[super layoutSubviews];
    backView.layer.cornerRadius = 10.0;
    backView.clipsToBounds = YES;
    
    if (unread) {
        [articleTitleLabel setAlpha:1];
    }
    else {
        [articleTitleLabel setAlpha:0.4];
    }
    
    if (top) {
        [isTop setHidden:NO];
        [isTop setText:@"置顶"];
        isTop.layer.cornerRadius = 2.0f;
        isTop.clipsToBounds = YES;
    }
    else if (mark) {
        [isTop setHidden:NO];
        [isTop setText:@"标记"];
        isTop.layer.cornerRadius = 2.0f;
        isTop.clipsToBounds = YES;
    }
    else
        [isTop setHidden:YES];
    
    
    [articleTitleLabel setText:[NSString stringWithFormat:@"%@", title]];
    [authorLabel setText:[NSString stringWithFormat:@"%@", author]];
    [readandreplyLabel setText:[NSString stringWithFormat:@"%i/%i", replies, read]];
    if (board != nil) {
        [boardLabel setText:[NSString stringWithFormat:@"%@ 版", board]];
    }
    else {
        [boardLabel setText:@""];
    }
    [articleDateLabel setText:[BBSAPI dateToString:time]];
    
    if (imageURL == nil) {
        [attImageView setImage:[UIImage imageNamed:@"leftbackground"]];
    }
    else
        [attImageView setImageWithURL:imageURL];
}
@end





