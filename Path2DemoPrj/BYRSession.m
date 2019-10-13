//
//  BYRSession.m
//  BYR
//
//  Created by Boyce on 10/5/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "BYRSession.h"
#import "Models.h"
#import <YYDiskCache.h>
#import <MJExtension.h>
#import "BYRNetworkManager.h"

static const NSString *kBYRCachePath = @"cn.byr.bbs";

static const NSString *kBYRUserKey = @"kBYRUserKey";
static const NSString *kBYRUserTokenKey = @"kBYRUserTokenKey";

@interface UserToken : NSObject <NSCoding>

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@end

@implementation UserToken

MJCodingImplementation

@end



@interface BYRSession ()

@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) UserToken *currentUserToken;

@property (nonatomic, strong) YYDiskCache *diskCache;

@end


@implementation BYRSession

+ (instancetype)sharedInstance {
    static BYRSession *_session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _session = [[self alloc] init];
    });
    return _session;
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *basePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:(NSString *)kBYRCachePath];
        _diskCache = [[YYDiskCache alloc] initWithPath:basePath];
        
        User *user = (User *)[_diskCache objectForKey:(NSString *)kBYRUserKey];
        UserToken *userToken = (UserToken *)[_diskCache objectForKey:(NSString *)kBYRUserTokenKey];
        
        if (user &&
            userToken &&
            [user.id isEqualToString:userToken.id]) {
            _currentUser = user;
            _currentUserToken = userToken;
            [[BYRNetworkManager sharedInstance] updateUsername:userToken.username password:userToken.password];
        }
    }
    return self;
}

- (void)logInWithUsername:(NSString *)username
                 password:(NSString *)password
               completion:(nullable void (^)(BOOL success, NSError *error))completion {
    [[BYRNetworkManager sharedInstance] updateUsername:username password:password];
    
    [[BYRNetworkManager sharedInstance] GET:@"/user/login.json" parameters:nil responseClass:User.class success:^(NSURLSessionDataTask * _Nonnull task, User * _Nullable responseObject) {
        UserToken *userToken = [UserToken new];
        userToken.username = username;
        userToken.password = password;
        userToken.id = responseObject.id;
        
        self.currentUser = responseObject;
        self.currentUserToken = userToken;
        
        [self.diskCache setObject:self.currentUser forKey:(NSString *)kBYRUserKey];
        [self.diskCache setObject:self.currentUserToken forKey:(NSString *)kBYRUserTokenKey];
        
        if (completion) {
            completion(YES, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(NO, error);
        }
    }];
}

- (void)logOut {
    self.currentUser = nil;
    self.currentUserToken = nil;
    [self.diskCache removeObjectForKey:(NSString *)kBYRUserKey];
    [self.diskCache removeObjectForKey:(NSString *)kBYRUserTokenKey];
    [[BYRNetworkManager sharedInstance] updateUsername:@"" password:@""];
}

- (void)refreshCurrentUser:(nullable void (^)(BOOL success, NSError *error))completion {
    [[BYRNetworkManager sharedInstance] GET:[NSString stringWithFormat:@"/user/query/%@.json", self.currentUser.id] parameters:nil responseClass:User.class success:^(NSURLSessionDataTask * _Nonnull task, User * _Nullable responseObject) {
        self.currentUser = responseObject;
        
        if (completion) {
            completion(YES, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(NO, error);
        }
    }];
}
                        
@end
