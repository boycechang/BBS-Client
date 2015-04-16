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
@synthesize users;
@synthesize count;
@synthesize section;
@synthesize leaf;

@synthesize nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.clipsToBounds = YES;

        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 11, 155, 21)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:16.0f];
        nameLabel.textAlignment = NSTextAlignmentRight;
        
        usersLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 33, 155, 10)];
        usersLabel.backgroundColor = [UIColor clearColor];
        usersLabel.font = [UIFont boldSystemFontOfSize:11.0f];
        usersLabel.textAlignment = NSTextAlignmentRight;
        usersLabel.textColor = [UIColor lightGrayColor];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [nameLabel setFrame:CGRectMake(0, 11, 370, 21)];
            [usersLabel setFrame:CGRectMake(0, 33, 370, 21)];
        }
        [self addSubview:nameLabel];
        [self addSubview:usersLabel];
        
        descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 11, 155, 21)];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.font = [UIFont systemFontOfSize:16.0f];
        descriptionLabel.adjustsFontSizeToFitWidth = YES;
		descriptionLabel.textColor = [UIColor lightGrayColor];
        
        countLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 33, 155, 10)];
        countLabel.backgroundColor = [UIColor clearColor];
        countLabel.font = [UIFont boldSystemFontOfSize:11.0f];
        countLabel.adjustsFontSizeToFitWidth = YES;
		countLabel.textColor = [UIColor lightGrayColor];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [descriptionLabel setFrame:CGRectMake(398, 11, 370, 21)];
            [countLabel setFrame:CGRectMake(398, 33, 370, 10)];
        }
        [self addSubview:descriptionLabel];
        [self addSubview:countLabel];
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
    if (description == nil || [description isEqualToString:@""]) {
        [descriptionLabel setText:name];
        [nameLabel setText:@"目录"];
    } else {
        [nameLabel setText:name];
        [descriptionLabel setText:description];
    }
    
    if (leaf) {
        [usersLabel setText:[NSString stringWithFormat:@"%i", users]];
        [countLabel setText:[NSString stringWithFormat:@"%i", count]];
    } else {
        [usersLabel setText:@""];
        [countLabel setText:@""];
    }
}

@end
