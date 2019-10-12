//
//  BYRContentParser.m
//  BYR
//
//  Created by Boyce on 10/9/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "BYRContentParser.h"
#import <YYText/YYText.h>
#import "NSString+BYRTool.h"

NSString *const BYRContentParserQuoteAttributedName = @"BYRCPQuoteAttributedName";

@implementation BYRContentParser

+ (instancetype)sharedInstance {
    static BYRContentParser *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
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
    
    YYTextBorder *border = [YYTextBorder new];
    border.lineStyle = YYTextLineStyleSingle;
    border.fillColor = [UIColor tertiarySystemFillColor];
    border.insets = UIEdgeInsetsMake(-3, 0, 0, 0);
    border.cornerRadius = 2;
    border.strokeWidth = YYTextCGFloatFromPixel(2);
    
    [text enumerateAttribute:BYRContentParserQuoteAttributedName inRange:NSMakeRange(0, text.length) options:kNilOptions usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value) {
            [text yy_setTextBlockBorder:border.copy range:range];
        }
    }];
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
