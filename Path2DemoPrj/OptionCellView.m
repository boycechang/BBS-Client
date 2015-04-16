//
//  TopTenTableView.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "OptionCellView.h"

@implementation OptionCellView
@synthesize rootVote;
@synthesize option;
@synthesize isSelect;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(10, 38, 150, 15)];
        //progressView.color = [UIColor colorWithRed:0.00f green:0.64f blue:0.00f alpha:1.00f];
        progressView.animate = @NO;
        progressView.progress = 0.40;
        progressView.borderRadius = @5;
        progressView.type = LDProgressSolid;
        [self addSubview:progressView];
    }
    return self;
}

-(void)awakeFromNib
{
    progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(10, 38, 150, 15)];
    //progressView.color = [UIColor colorWithRed:0.00f green:0.64f blue:0.00f alpha:1.00f];
    progressView.animate = @NO;
    progressView.progress = 0.40;
    progressView.borderRadius = @5;
    progressView.type = LDProgressSolid;
    [self addSubview:progressView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UIView
- (void)layoutSubviews {
    [super layoutSubviews];
    
	[optionLabel setText:option.label];
    if (option.num == -1) {
        [numLabel setText:@"投票看结果"];
        [progressView setProgress:0.0];
    }
    else {
        [numLabel setText:[NSString stringWithFormat:@"%i", option.num]];
        [progressView setProgress:(float)option.num/(float)rootVote.vote_count];
    }
    
    if (isSelect) {
        [checkLabel setHidden:NO];
    }
    else {
        [checkLabel setHidden:YES];
    }
}
@end
