//
//  Attachment.h
//  SBBS-OS-X-Client
//
//  Created by Huang Feiqiao on 13-1-24.
//  Copyright (c) 2013年 Huang Feiqiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Attachment : NSObject
{
    int attId;
    NSString * attFileName;
    int attPos;
    int attSize;
    NSString * attUrl;
}

@property(nonatomic, assign)int attId;
@property(nonatomic, strong)NSString *attFileName;
@property(nonatomic, assign)int attPos;
@property(nonatomic, assign)int attSize;
@property(nonatomic, strong)NSString *attUrl;
@end
