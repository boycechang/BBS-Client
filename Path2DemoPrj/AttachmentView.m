//
//  AttachmentView.m
//  虎踞龙蟠
//
//  Created by Boyce on 8/16/13.
//  Copyright (c) 2013 Ethan. All rights reserved.
//

#import "AttachmentView.h"

@implementation AttachmentView
@synthesize isPhoto;
@synthesize mDelegate;
@synthesize indexNum;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
        self.layer.cornerRadius = 6.0f;
        self.clipsToBounds = YES;
        
        typeView = [[UIView alloc] initWithFrame:CGRectMake(50, 5, 1, 40)];
        typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 220, 50)];
        
        [typeView setBackgroundColor:[UIColor whiteColor]];
        
        [typeLabel setTextColor:[UIColor whiteColor]];
        [typeLabel setTextAlignment:NSTextAlignmentCenter];
        [typeLabel setHighlightedTextColor:[UIColor whiteColor]];
        [typeLabel setBackgroundColor:[UIColor clearColor]];
        
        //[nameLabel setFont:[UIFont systemFontOfSize:15]];
        [nameLabel setTextColor:[UIColor whiteColor]];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setLineBreakMode:NSLineBreakByWordWrapping];
        nameLabel.numberOfLines = 0;
        [nameLabel setHighlightedTextColor:[UIColor whiteColor]];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:typeView];
        [self addSubview:typeLabel];
        [self addSubview:nameLabel];
    }
    return self;
}

-(void)setAttachment:(NSString *)typeText NameText:(NSString *)nameText
{
    NSArray *array = [typeText componentsSeparatedByString:@"."];
    NSString *type = [array objectAtIndex:[array count] - 1];
    [typeLabel setText:[type uppercaseString]];
    [nameLabel setText:nameText];
    
    UITapGestureRecognizer* recognizer;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped)];
    [self addGestureRecognizer:recognizer];
}

-(void)taped
{
    [mDelegate attachmentViewTaped:isPhoto IndexNum:indexNum];
}
@end
