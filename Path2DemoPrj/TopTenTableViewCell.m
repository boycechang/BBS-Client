//
//  TopTenTableView.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "TopTenTableViewCell.h"
#import "BBSAPI.h"

@implementation TopTenTableViewCell
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
@synthesize hasAtt;
@synthesize articleTitleLabel;
@synthesize articleDateLabel;
@synthesize boardLabel;
@synthesize readandreplyLabel;
@synthesize authorLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
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
    
    if (unread) {
        [articleTitleLabel setAlpha:1];
    }
    else {
        [articleTitleLabel setAlpha:0.4];
    }
    
    [articleTitleLabel setText:[NSString stringWithFormat:@"%@%@%@  %@", (top ? @"🔝":@""), (mark ? @"💎":@""), (hasAtt ? @"🔗":@""), title]];
    //[authorLabel setText:[NSString stringWithFormat:@"%@  %@%@ %@", author, (top ? @"🔝":@""), (mark ? @"💎":@""), (hasAtt ? @"🔗":@"")]];
    [readandreplyLabel setText:[NSString stringWithFormat:@"%i", replies]];
    if (board != nil) {
        [boardLabel setText:[NSString stringWithFormat:@"%@ 版", board]];
    }
    else {
        [boardLabel setText:@""];
    }
    
    [articleDateLabel setText:[BBSAPI dateToString:time]];
}
@end
