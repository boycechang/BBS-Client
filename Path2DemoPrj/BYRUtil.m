//
//  BYRUtil.m
//  BYR
//
//  Created by Boyce on 10/6/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "BYRUtil.h"

@implementation BYRUtil

+ (NSString *)dateDescriptionFromTimestamp:(NSTimeInterval)timestamp {
    double ti = [[NSDate date] timeIntervalSince1970] - timestamp;
    if (ti < 60) {
        return @"刚刚";
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%d分钟前", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return [NSString stringWithFormat:@"%d小时前", diff];
    } else if (ti < 259200) {
        int diff = round(ti / 60 / 60 / 24);
        return [NSString stringWithFormat:@"%d天前", diff];
    } else if (ti < 15552000) {
        time_t time = timestamp;
        struct tm timeStruct;
        localtime_r(&time, &timeStruct);
        char buffer[80];
        strftime(buffer, 80, "%Y/%-m/%-d", &timeStruct);
        return [NSString stringWithCString:buffer encoding:NSASCIIStringEncoding];
    } else {
        time_t time = timestamp;
        struct tm timeStruct;
        localtime_r(&time, &timeStruct);
        char buffer[80];
        strftime(buffer, 80, "%Y/%-m/%-d", &timeStruct);
        return [NSString stringWithCString:buffer encoding:NSASCIIStringEncoding];
    }
}

+ (NSString *)fullDateDescriptionFromTimestamp:(NSTimeInterval)timestamp {
    time_t time = timestamp;
    struct tm timeStruct;
    localtime_r(&time, &timeStruct);
    char buffer[80];
    strftime(buffer, 80, "%Y/%-m/%-d  %H:%S", &timeStruct);
    return [NSString stringWithCString:buffer encoding:NSASCIIStringEncoding];
}

@end
