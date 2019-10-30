//
//  BYRNetworkReponse.m
//  BYR
//
//  Created by Boyce on 10/3/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "BYRNetworkReponse.h"
#import <MJExtension.h>
#import "Models.h"

@implementation BoardResponse

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"boards"   : Board.class,
        @"sections" : Board.class,
    };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"boards"       : @"board",
        @"sub_sections" : @"sub_section",
        @"sections"     : @"section",
    };
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"sub_sections"]) {
        NSArray *sectionNames = oldValue;
        NSMutableArray *borads = [NSMutableArray new];
        for (NSString *subSectionName in sectionNames) {
            Board *board = [Board new];
            board.name = subSectionName;
            [borads addObject:board];
        }
        return borads;
    }
    
    return oldValue;
}

@end


@implementation TopicResponse

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"topics" : Topic.class};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"topics" : @"article"};
}

@end


@implementation MailResponse

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"mails" : Mail.class};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"mails" : @"mail"};
}

@end


@implementation VoteResponse

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"votes" : Vote.class};
}

@end


@implementation SingleVoteResponse
@end
