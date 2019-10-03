//
//  BYRNetworkReponse.h
//  BYR
//
//  Created by Boyce on 10/3/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Topic;

@interface TopicResponse : NSObject

@property (nonatomic, strong) NSArray <Topic *> *topics;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *name;

@end



NS_ASSUME_NONNULL_END