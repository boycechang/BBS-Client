//
//  Notification.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/7/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject
{
    NSArray * at;
    NSArray * reply;
    int atCount;
    int replyCount;
}
@property(nonatomic, strong)NSArray * at;
@property(nonatomic, strong)NSArray * reply;
@property(nonatomic, assign)int atCount;
@property(nonatomic, assign)int replyCount;
@end
