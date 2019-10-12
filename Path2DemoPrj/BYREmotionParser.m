//
//  BYREmotionParser.m
//  BYR
//
//  Created by Boyce on 10/9/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "BYREmotionParser.h"
#import <YYImage/YYImage.h>

@implementation BYREmotionParser

+ (instancetype)sharedInstance {
    static BYREmotionParser *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSMutableDictionary *mapper = [NSMutableDictionary new];
        
        for (int i = 1; i <= 73; i++) {
            [mapper setObject:[YYImage imageNamed:[NSString stringWithFormat:@"[em%i].gif", i]] forKey:[NSString stringWithFormat:@"[em%i]", i]];
        }
        
        for (int i = 0; i <= 41; i++) {
            [mapper setObject:[YYImage imageNamed:[NSString stringWithFormat:@"[ema%i].gif", i]] forKey:[NSString stringWithFormat:@"[ema%i]", i]];
        }
        
        for (int i = 0; i <= 24; i++) {
            [mapper setObject:[YYImage imageNamed:[NSString stringWithFormat:@"[emb%i].gif", i]] forKey:[NSString stringWithFormat:@"[emb%i]", i]];
        }
        
        for (int i = 0; i <= 58; i++) {
            [mapper setObject:[YYImage imageNamed:[NSString stringWithFormat:@"[emc%i].gif", i]] forKey:[NSString stringWithFormat:@"[emc%i]", i]];
        }
        
        self.emoticonMapper = mapper;
    }
    return self;
}

@end
