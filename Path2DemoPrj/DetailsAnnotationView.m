//
//  DetailsAnnotationView.m
//  Match3Draft
//
//  Created by iObitLXF on 2/21/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//

#import "DetailsAnnotationView.h"
#import <QuartzCore/QuartzCore.h>


#define  Arror_height 15

@interface DetailsAnnotationView()
@end
@implementation DetailsAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.canShowCallout = NO;
        self.frame = CGRectMake(0, 0, 260, 260);
        self.cell = [DetailsView getInstanceWithNib];
        [self addSubview:self.cell];
    }
    return self;

}
-(void)setCellUI:(MapItemInfoVO *)vo
{
    self.cell.tag = self.tag;
    [self.cell setUI:vo];
}

@end
