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

@implementation TopicResponse

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"topics" : [Topic class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"topics" : @"article"};
}

@end
