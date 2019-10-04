//
//  BYRNetworkManager.m
//  BYR
//
//  Created by Boyce on 10/3/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "BYRNetworkManager.h"
#import <AFNetworking.h>
#import <MJExtension.h>

static const NSString *AppKey = @"ff7504fa9d6a4975";

@interface BYRNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *networkManager;

@end

@implementation BYRNetworkManager


+ (instancetype)sharedInstance {
    static BYRNetworkManager *_session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _session = [[self alloc] init];
    });
    return _session;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _networkManager  = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.byr.cn"]];
        [_networkManager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"yyjing" password:@"1989128"];
    }
    return self;
}

- (void)updateUsername:(NSString *)username password:(NSString *)password {
    [_networkManager.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
}

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
parameters:(nullable NSDictionary *)parameters
  responseClass:(nullable Class)responseClass
   success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
   failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    return [_networkManager GET:[NSString stringWithFormat:@"%@?appkey=%@", URLString, AppKey] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] &&
            [[responseObject objectForKey:@"code"] length] == 0) {
            if (success) {
                if (responseClass) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        id response = [responseClass mj_objectWithKeyValues:responseObject];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            success(task, response);
                        });
                    });
                } else {
                    success(task, responseObject);
                }
            }
        } else if (failure) {
            failure(task, nil);
        }
    } failure:failure];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
parameters:(nullable NSDictionary *)parameters
responseClass:(nullable Class)responseClass
 success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
 failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    return [_networkManager POST:[NSString stringWithFormat:@"%@?appkey=%@", URLString, AppKey] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] &&
            [[responseObject objectForKey:@"code"] length] == 0) {
            if (success) {
                if (responseClass) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        id response = [responseClass mj_objectWithKeyValues:responseObject];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            success(task, response);
                        });
                    });
                } else {
                    success(task, responseObject);
                }
            }
        } else if (failure) {
            failure(task, nil);
        }
    } failure:failure];
}

@end
