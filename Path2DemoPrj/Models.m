//
//  Models.m
//  BYR
//
//  Created by Boyce on 10/3/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "Models.h"

@implementation User
@end

@implementation Attachment
@end

@implementation Topic

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"articles" : [Topic class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"articles" : @"article",
             @"attachments" : @"attachment"};
}

@end
