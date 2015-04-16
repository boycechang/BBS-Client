//
//  User.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/27/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
{
    NSString * ID; //用户ID
    NSString * name; //用户中文昵称
    NSString * username; //用户名
    NSString * password; //用户密码
    NSString * token;
    
    NSURL * avatar; //用户头像地址
    NSDate * lastlogin; //上次登录时间
    NSString * level; //等级称谓
    int posts; //发文数
    int perform; //表现值
    int experience; //经验值
    int medals; //勋章数
    int logins; //上站次数
    int life; //生命值
    NSString * gender; //性别，M为男性，F为女性（用户相关设置允许后显示）
    NSString * astro; //星座（用户相关设置允许后显示)
    NSString * mode; //在线状态
    
    BOOL isOnline;
}
@property(nonatomic, strong)NSString * ID;
@property(nonatomic, strong)NSString * name;
@property(nonatomic, strong)NSString * username;
@property(nonatomic, strong)NSString * password;
@property(nonatomic, strong)NSString * token;

@property(nonatomic, strong)NSURL * avatar;
@property(nonatomic, strong)NSDate * lastlogin;
@property(nonatomic, strong)NSString * level;
@property(nonatomic, assign)int posts;
@property(nonatomic, assign)int perform;
@property(nonatomic, assign)int experience;
@property(nonatomic, assign)int medals;
@property(nonatomic, assign)int logins;
@property(nonatomic, assign)int life;
@property(nonatomic, strong)NSString * gender;
@property(nonatomic, strong)NSString * astro;
@property(nonatomic, strong)NSString * mode;

@property(nonatomic, assign)BOOL isOnline;
@end
