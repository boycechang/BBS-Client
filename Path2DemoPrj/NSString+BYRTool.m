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
