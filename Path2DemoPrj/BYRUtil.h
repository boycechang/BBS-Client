//
//  BYRUtil.h
//  BYR
//
//  Created by Boyce on 10/6/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BYRUtil : NSObject

+ (NSString *)dateDescriptionFromTimestamp:(NSTimeInterval)timestamp;
+ (NSString *)fullDateDescriptionFromTimestamp:(NSTimeInterval)timestamp;

@end

NS_ASSUME_NONNULL_END
