//
//  Memo.m
//  MapMemo
//
//  Created by Boyce on 3/2/14.
//  Copyright (c) 2014 Ethan. All rights reserved.
//

#import "Memo.h"


@implementation Memo

@synthesize title;
@synthesize content;
@synthesize latitude;
@synthesize longtitude;
@synthesize like;
@synthesize createdAt;
@synthesize image;
@synthesize videoData;
@synthesize username;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    return self;
}

@end
