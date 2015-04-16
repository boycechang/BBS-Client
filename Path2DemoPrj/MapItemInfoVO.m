//
//  ScenicVO.m
//  ScenicGuide
//
//  Created by xf.lai on 13-8-5.
//  Copyright (c) 2013年 xf.lai. All rights reserved.
//

#import "MapItemInfoVO.h"

@implementation MapItemInfoVO
@synthesize strDetails,strTitle,strId,strLat,strLon;
@synthesize image;
@synthesize aryChild;


//===========================================================
// dealloc
//===========================================================
- (void)dealloc
{
    self.strId = nil;
    self.strTitle = nil;
    self.strDetails = nil;
   
    self.image = nil;
    self.aryChild = nil;

    self.strLon = nil;
    self.strLat = nil;

}


@end
