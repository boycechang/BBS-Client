//
//  BYRNetworkManager.h
//  BYR
//
//  Created by Boyce on 10/3/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BYRNetworkManager : NSObject

+ (instancetype)sharedInstance;

- (void)updateUsername:(NSString *)username password:(NSString *)password;


#pragma mark - HTTP Method

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
parameters:(nullable NSDictionary *)parameters
  reponseClass:(Class)reponseClass
   success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
   failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;


@end

NS_ASSUME_NONNULL_END
