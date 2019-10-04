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


@end

NS_ASSUME_NONNULL_END
