//
//  FTScrollView.m
//  FTAPP
//
//  Created by Boyce on 7/8/15.
//  Copyright (c) 2015 XSpace. All rights reserved.
//

#import "FTScrollView.h"

@implementation FTScrollView

- (void)setContentOffset:(CGPoint)contentOffset
{
    contentOffset.y = -64.0f;
    [super setContentOffset:contentOffset];
}

@end
