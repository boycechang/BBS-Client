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

-(void)setReadyToShow
{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor lightTextColor];
    self.selectedBackgroundView = bgView;
    
    if (mail.type == 0)
        [authorLabel setText:[NSString stringWithFormat:@"发件人：%@", mail.author]];
    if (mail.type == 1)
        [authorLabel setText:[NSString stringWithFormat:@"收件人：%@", mail.author]];
    if (mail.type == 2)
        [authorLabel setText:[NSString stringWithFormat:@"发件人：%@", mail.author]];
    [titleLabel setText:mail.title];
    if (!mail.unread) {
        [unreadImage setHidden:YES];
    }
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
