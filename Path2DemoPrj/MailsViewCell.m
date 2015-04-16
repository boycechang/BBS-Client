//
//  TopTenTableView.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "MailsViewCell.h"

@implementation MailsViewCell
@synthesize mail;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        // Initialization code
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
    notificationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 6, 65)];
    [self addSubview:notificationImageView];
    if (mail.unread) {
        [notificationImageView setBackgroundColor:[UIColor redColor]];
    }
    else
    {
        [notificationImageView setBackgroundColor:[UIColor whiteColor]];
    }
    
    if (mail.type == 0)
        [authorLabel setText:[NSString stringWithFormat:@"%@", mail.author]];
    if (mail.type == 1)
        [authorLabel setText:[NSString stringWithFormat:@"%@", mail.author]];
    if (mail.type == 2)
        [authorLabel setText:[NSString stringWithFormat:@"%@", mail.author]];
    
    [titleLabel setText:[NSString stringWithFormat:@"%@", mail.title]];
    [timeLabel setText:[NSString stringWithFormat:@"%@", [BBSAPI dateToString:mail.time]]];
}
@end
