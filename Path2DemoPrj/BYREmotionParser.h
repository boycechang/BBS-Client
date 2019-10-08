//
//  BYREmotionParser.h
//  BYR
//
//  Created by Boyce on 10/9/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "YYTextParser.h"

NS_ASSUME_NONNULL_BEGIN

@interface BYREmotionParser : YYTextSimpleEmoticonParser

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
