//
//  BYRSession.m
//  BYR
//
//  Created by Boyce on 10/5/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "BYRSession.h"
#import "Models.h"

@implementation BYRSession

+ (instancetype)sharedInstance {
    static BYRSession *_session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _session = [[self alloc] init];
    });
    return _session;
}

- (id)init {
    self = [super init];
    if (self) {
        _currentUser = [
    }
    return self;
}
@end
