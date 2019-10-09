//
//  NSString+BYRTool.m
//  BYR
//
//  Created by Boyce on 10/6/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "NSString+BYRTool.h"

@implementation NSString (BYRTool)

- (NSString *)trimedWhitespaceString {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end


@implementation NSMutableAttributedString (BYRTool)

- (NSMutableAttributedString *)trimedWhitespaceString {
    NSCharacterSet *set = [[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet];
    
    NSRange range = [self.string rangeOfCharacterFromSet:set];
    NSInteger loc = range.length > 0 ? range.location : 0;
    
    range = [self.string rangeOfCharacterFromSet:set options:NSBackwardsSearch];
    NSInteger len = (range.length > 0 ? NSMaxRange(range) : self.string.length) - loc;
    
    return [[NSMutableAttributedString alloc] initWithAttributedString:[self attributedSubstringFromRange:NSMakeRange(loc, len)]];
}

@end
