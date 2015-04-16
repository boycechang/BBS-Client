//
//  TopTenTableView.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "MapNewsTableViewCell.h"
#import <AVOSCloud/AVOSCloud.h>
#import "BBSAPI.h"

@implementation MapNewsTableViewCell
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
@synthesize memo;

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
    
    [articleTitleLabel setText:[NSString stringWithFormat:@"%@", memo.title]];
    [articleContentLabel setText:[NSString stringWithFormat:@"%@", memo.content]];
    [articleDateLabel setText:[NSString stringWithFormat:@"%@", [BBSAPI dateToString:memo.createdAt]]];
    [likeLabel setText:[NSString stringWithFormat:@"%i", [memo.like intValue]]];
    
    newsImageView.clipsToBounds = YES;
    newsImageView.layer.cornerRadius = 40.0;
    backImageView.clipsToBounds = YES;
    backImageView.layer.cornerRadius = 40.0;
    
    if (memo.image != nil) {
        [newsImageView setImage:memo.image];
    }
    else {
        [newsImageView setImage:[UIImage imageNamed:@"VideoIcon"]];
    }
    
    myPost.clipsToBounds = YES;
    myPost.layer.cornerRadius = 10.0;
    if ([[AVUser currentUser].username isEqualToString:memo.username]) {
        myPost.hidden = NO;
    } else {
        myPost.hidden = YES;
    }
}

@end
