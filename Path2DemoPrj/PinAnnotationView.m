//
//  PinAnnotationView.m
//  ScenicGuide
//
//  Created by xf.lai on 13-8-13.
//  Copyright (c) 2013年 xf.lai. All rights reserved.
//

#import "PinAnnotationView.h"

@implementation PinAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
//        self.centerOffset = CGPointMake(0, -15);
        self.frame = CGRectMake(0, 0, 30, 30);
        
        self.imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dot.png"]];
        self.imgView.frame = self.bounds;
        [self addSubview:self.imgView];
        
    }
    return self;
    
}



@end
