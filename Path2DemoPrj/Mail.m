//
//  Mail.m
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/6/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "Mail.h"

@implementation Mail
@synthesize ID;
@synthesize type;
@synthesize size;
@synthesize unread;

@synthesize time;
@synthesize author;

@synthesize title;
@synthesize content;
@synthesize quote;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end
