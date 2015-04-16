//
//  User.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/27/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize ID;
@synthesize name;
@synthesize username;
@synthesize password;
@synthesize token;
@synthesize avatar;
@synthesize lastlogin;
@synthesize level;
@synthesize posts;
@synthesize perform;
@synthesize experience;
@synthesize medals;
@synthesize logins;
@synthesize life;
@synthesize gender;
@synthesize astro;
@synthesize mode;

@synthesize isOnline;
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
