//
//  Models.m
//  BYR
//
//  Created by Boyce on 10/3/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "Models.h"
#import "NSString+BYRTool.h"

@implementation Pagination

@end


@implementation Board

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"board_description" : @"description"};
}

@end


@implementation User

MJCodingImplementation

@end


@implementation Attachment

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"thumbnail_small"] ||
        [property.name isEqualToString:@"thumbnail_middle"] ||
        [property.name isEqualToString:@"url"]) {
        
        NSString *oldURL = oldValue;
        if (oldURL.length >= 28) {
            return [NSString stringWithFormat:@"%@%@", @"http://bbs.byr.cn/att", [oldURL substringFromIndex:28]];
        }
    }

    return oldValue;
}

@end


@implementation Topic

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"articles" : [Topic class],
             @"attachments" : [Attachment class]
    };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"articles" : @"article",
             @"attachments" : @"attachment.file"};
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"content"]) {
        NSString *content = oldValue;
        if ([content hasSuffix:@"\n--\n\n"]) {
            content = [[content substringToIndex:content.length - 5] trimedWhitespaceString];
        }
        content = [content trimedWhitespaceString];
        return content;
    }

    return oldValue;
}

@end

@implementation Mail

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"attachments" : [Attachment class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"articles" : @"article",
             @"attachments" : @"attachment"};
}

@end
