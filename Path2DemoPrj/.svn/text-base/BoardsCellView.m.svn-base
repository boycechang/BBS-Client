//
//  BoardsCellView.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/2/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "BoardsCellView.h"

@implementation BoardsCellView

@synthesize name;
@synthesize description;
@synthesize section;
@synthesize leaf;

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
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 11, 139, 21)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:17.0f];
		nameLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		nameLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
		nameLabel.textColor = [UIColor colorWithRed:(196.0f/255.0f) green:(204.0f/255.0f) blue:(218.0f/255.0f) alpha:1.0f];
        nameLabel.textAlignment = UITextAlignmentRight;
        [self addSubview:nameLabel];
        
        descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(154, 11, 116, 21)];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.font = [UIFont boldSystemFontOfSize:17.0f];
		descriptionLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		descriptionLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
		descriptionLabel.textColor = [UIColor lightGrayColor];
        nameLabel.textAlignment = UITextAlignmentRight;
        
        [self addSubview:descriptionLabel];
    }
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)setReadyToShow
{
   // [nameLabel setText:[NSString stringWithFormat:@"%@(%@)",description,name]];
    [nameLabel setText:name];
    [descriptionLabel setText:description];
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
