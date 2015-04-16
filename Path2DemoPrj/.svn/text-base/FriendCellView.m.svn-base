//
//  TopTenTableView.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "FriendCellView.h"

@implementation FriendCellView
@synthesize user;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
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
        
        IDandName = [[UILabel alloc] initWithFrame:CGRectMake(20, 11, 250, 21)];
        IDandName.backgroundColor = [UIColor clearColor];
        IDandName.font = [UIFont fontWithName:@"Helvetica" size:18.f];
		IDandName.shadowOffset = CGSizeMake(0.0f, 1.0f);
		IDandName.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
		IDandName.textColor = [UIColor colorWithRed:(196.0f/255.0f) green:(204.0f/255.0f) blue:(218.0f/255.0f) alpha:1.0f];
        IDandName.textAlignment = UITextAlignmentLeft;
        [self addSubview:IDandName];
        
        mode = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 250, 12)];
        mode.backgroundColor = [UIColor clearColor];
        mode.font = [UIFont fontWithName:@"Helvetica" size:10.f];
		mode.shadowOffset = CGSizeMake(0.0f, 1.0f);
		mode.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
		mode.textColor = [UIColor lightGrayColor];
        mode.textAlignment = UITextAlignmentLeft;
        [self addSubview:mode];
    }
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)setReadyToShow
{
    [IDandName setText:[NSString stringWithFormat:@"%@(%@)", user.ID, user.name]];
    [mode setText:user.mode];
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
