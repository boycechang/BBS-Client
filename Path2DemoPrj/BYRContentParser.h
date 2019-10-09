//
//  BYRContentParser.h
//  BYR
//
//  Created by Boyce on 10/9/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const BYRContentParserQuoteAttributedName;

@class YYTextHighlight;

@interface BYRContentParser : NSObject

+ (instancetype)sharedInstance;

- (void)parseQuote:(NSMutableAttributedString *)text attributes:(NSDictionary *)attributes;
- (void)parseLink:(NSMutableAttributedString *)text highlight:(YYTextHighlight *)highlight;

@end

NS_ASSUME_NONNULL_END
