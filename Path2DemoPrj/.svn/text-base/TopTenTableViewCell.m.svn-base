//
//  TopTenTableView.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "TopTenTableViewCell.h"

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

-(void)setReadyToShow
{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor lightTextColor];
    self.selectedBackgroundView = bgView;
    
    if (unread) {
        [articleTitleLabel setAlpha:1];
    }
    else
    {
        [articleTitleLabel setAlpha:0.4];
    }
    
    [isTop setHidden:!top];
    [articleTitleLabel setText:title];
    [authorLabel setText:[NSString stringWithFormat:@"作者:%@", author]];
    [readandreplyLabel setText:[NSString stringWithFormat:@"人气:%i/%i", replies, read]];
    [boardLabel setText:[NSString stringWithFormat:@"讨论区:%@", board]];
}

- (void)bounce1AnimationStopped
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    self.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
}

-(void)showAinmationWhenSeleceted
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.98, 0.98);
    [UIView commitAnimations];
}
@end
