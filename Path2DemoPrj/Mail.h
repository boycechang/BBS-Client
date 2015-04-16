//
//  Mail.h
//  虎踞龙蟠
//
//  Created by 张晓波 on 6/6/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mail : NSObject
{
    int ID; //邮件ID
    int type; //int 信箱类型 0 收件箱 1 发件箱 2 垃圾箱
    int size; //邮件大小
    BOOL unread; //未读标记
    
    NSDate * time; //时间
    NSString * author; //作者
    
    NSString * title;
    NSString * content;
    NSString * quote;
}
@property(nonatomic, assign)int ID;
@property(nonatomic, assign)int type;
@property(nonatomic, assign)int size;
@property(nonatomic, assign)BOOL unread;

@property(nonatomic, strong)NSDate * time;
@property(nonatomic, strong)NSString * author;

@property(nonatomic, strong)NSString * title;
@property(nonatomic, strong)NSString * content;
@property(nonatomic, strong)NSString * quote;
@end
