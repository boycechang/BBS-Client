//
//  Vote.m
//  北邮人BBS
//
//  Created by Boyce on 10/31/13.
//  Copyright (c) 2013 Ethan. All rights reserved.
//

#import "Vote.h"

@implementation Vote
@synthesize vid;
@synthesize voteTitle;

@synthesize start;
@synthesize end;
@synthesize user_count;
@synthesize vote_count;
@synthesize type;
@synthesize limit;
@synthesize author;
@synthesize authorHeadUrl;

@synthesize is_end;
@synthesize is_deleted;
@synthesize is_result_voted;

@synthesize voted;
@synthesize options;

@synthesize label;
@synthesize viid;
@synthesize num;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
@end
