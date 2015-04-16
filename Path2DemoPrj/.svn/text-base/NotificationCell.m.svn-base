//
//  TopTenTableView.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell
@synthesize notification;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        self.clipsToBounds = YES;
		
		UIView *bgView = [[UIView alloc] init];
		bgView.backgroundColor = [UIColor colorWithRed:(38.0f/255.0f) green:(44.0f/255.0f) blue:(58.0f/255.0f) alpha:1.0f];
		self.selectedBackgroundView = bgView;
		
		self.imageView.contentMode = UIViewContentModeCenter;
		
        self.textLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize] * 1.3f];
		self.textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		self.textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
		self.textLabel.textColor = [UIColor colorWithRed:(196.0f/255.0f) green:(204.0f/255.0f) blue:(218.0f/255.0f) alpha:1.0f];
		
		UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		topLine.backgroundColor = [UIColor colorWithRed:(54.0f/255.0f) green:(61.0f/255.0f) blue:(76.0f/255.0f) alpha:1.0f];
		[self.textLabel.superview addSubview:topLine];
		
		UIView *topLine2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 1.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		topLine2.backgroundColor = [UIColor colorWithRed:(54.0f/255.0f) green:(61.0f/255.0f) blue:(77.0f/255.0f) alpha:1.0f];
		[self.textLabel.superview addSubview:topLine2];
		
		UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 43.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		bottomLine.backgroundColor = [UIColor colorWithRed:(40.0f/255.0f) green:(47.0f/255.0f) blue:(61.0f/255.0f) alpha:1.0f];
		[self.textLabel.superview addSubview:bottomLine];
        
        notificationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(258, 8, 28, 28)];
        [notificationImageView setImage:[UIImage imageNamed:@"notification.png"]];
        [self addSubview:notificationImageView];
        
        notificationCount = [[UILabel alloc] initWithFrame:CGRectMake(143, 11, 108, 21)];
        notificationCount.backgroundColor = [UIColor clearColor];
        notificationCount.font = [UIFont fontWithName:@"Helvetica" size:14.f];
		notificationCount.shadowOffset = CGSizeMake(0.0f, 1.0f);
		notificationCount.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
		notificationCount.textColor = [UIColor colorWithRed:(196.0f/255.0f) green:(204.0f/255.0f) blue:(218.0f/255.0f) alpha:1.0f];
        notificationCount.textAlignment = UITextAlignmentRight;
        [self addSubview:notificationCount];
    }
    return self;
}

-(void)dealloc
{
    notificationCount = nil;
    notificationImageView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)refreshCell
{
    //[self fadeOut];
    if (notification.count == 0) {
        [notificationImageView setHidden:YES];
        [notificationCount setText:@"无新消息"];
    }
    else {
        [notificationImageView setHidden:NO];
        [notificationCount setText:[NSString stringWithFormat:@"%i 条新消息", notification.count]];
    }
}


-(void)fadeOut
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(fadeIn)];
    [notificationImageView setAlpha:0];
	[UIView commitAnimations];
}

-(void)fadeIn
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(fadeOut)];
    [notificationImageView setAlpha:1];
    [UIView commitAnimations];
}

#pragma mark UIView
- (void)layoutSubviews {
	[super layoutSubviews];
	//self.textLabel.frame = CGRectMake(50.0f, 0.0f, 200.0f, 43.0f);
	//self.imageView.frame = CGRectMake(0.0f, 0.0f, 50.0f, 43.0f);
}
@end
