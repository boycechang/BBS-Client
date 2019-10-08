//
//  BYRContentParser.m
//  BYR
//
//  Created by Boyce on 10/9/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "BYRContentParser.h"
#import <YYText.h>

@implementation BYRContentParser

+ (instancetype)sharedInstance {
    static BYRContentParser *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)parseQuote:(NSMutableAttributedString *)text attributes:(NSDictionary *)attributes {
    NSArray <NSTextCheckingResult *> *results;
    
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"【 在.*的(?:大作|邮件)中提到: 】.*\\s*" options:NSRegularExpressionCaseInsensitive error:nil];
    results = [expression matchesInString:text.string options:NSMatchingReportCompletion range:NSMakeRange(0, text.string.length)];
    for (NSTextCheckingResult *result in results) {
        [text addAttributes:attributes range:result.range];
    }
    
    expression = [NSRegularExpression regularExpressionWithPattern:@"^:.*\\s*" options:NSRegularExpressionCaseInsensitive | NSRegularExpressionAnchorsMatchLines error:nil];
    results = [expression matchesInString:text.string options:NSMatchingReportCompletion range:NSMakeRange(0, text.string.length)];
    for (NSTextCheckingResult *result in results) {
        [text addAttributes:attributes range:result.range];
    }
}

- (void)parseLink:(NSMutableAttributedString *)text highlight:(YYTextHighlight *)highlight {
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray <NSTextCheckingResult *> *results = [detector matchesInString:text.string options:NSMatchingReportCompletion range:NSMakeRange(0, text.string.length)];

    for (NSTextCheckingResult *result in results) {
        [text yy_setTextHighlight:highlight range:result.range];
        [text yy_setColor:[UIColor systemBlueColor] range:result.range];
        [text yy_setLink:[text.string substringWithRange:result.range] range:result.range];
    }
}

@end
