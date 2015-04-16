//
//  Hmacsha1.h
//  GatherSNS
//
//  Created by 张晓波 on 11/19/11.
//  Copyright 2011 SEU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hmacsha1 : NSObject


+ (NSString *)hmac_sha1:(NSString *)key text:(NSString *)text;
+ (NSString *)generateTimeStamp;
+ (NSString *)generateNonce;

@end
