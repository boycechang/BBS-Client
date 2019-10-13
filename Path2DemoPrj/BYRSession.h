//
//  BYRSession.h
//  BYR
//
//  Created by Boyce on 10/5/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class User;

@interface BYRSession : NSObject

@property (readonly) User *currentUser;

+ (instancetype)sharedInstance;

- (void)logInWithUsername:(NSString *)username
                 password:(NSString *)password
               completion:(nullable void (^)(BOOL success, NSError *error))completion;

- (void)logOut;

- (void)refreshCurrentUser:(nullable void (^)(BOOL success, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
