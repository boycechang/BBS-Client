//
//  Topic.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/27/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Topic : NSObject
{
    int ID;//帖子ID
    int gID; //帖子所在主题的主ID
    NSString * board; //帖子所在版面
    int size; //帖子大小
    int read; //文章阅读数
    int replies; //文章回复数
    int reid; //回复帖子的id
    BOOL unread; //是否未读
    BOOL top; //是否置顶
    BOOL  mark; //标记
    BOOL norep; //文章设有’不可RE’标记
    BOOL hasAtt; //有没有附件
    NSString * author; //发贴人
    NSURL * authorFaceURL; //发帖人头像
    NSDate * time; //发贴时间戳
    NSString * title; //标题
    NSString * content; //内容
    NSString * quote; //帖子引用的内容
    NSString * quoter; //引用内容的作者
    NSString * last_author; //最后回复用户
    NSDate * last_time; //最后恢复时间
    NSArray * attachments;//附件
    
    int index;  //notification使用
}

@property(nonatomic, assign)int ID;//帖子ID
@property(nonatomic, assign)int gID; //帖子所在主题的主ID
@property(nonatomic, strong)NSString * board; //帖子所在版面
@property(nonatomic, assign)int size; //帖子大小
@property(nonatomic, assign)int read; //文章阅读数
@property(nonatomic, assign)int replies; //文章回复数
@property(nonatomic, assign)int reid; //回复帖子的id
@property(nonatomic, assign)BOOL unread; //是否未读
@property(nonatomic, assign)BOOL top; //是否置顶
@property(nonatomic, assign)BOOL  mark; //标记
@property(nonatomic, assign)BOOL norep; //文章设有’不可RE’标记
@property(nonatomic, assign)BOOL hasAtt;
@property(nonatomic, strong)NSString * author; //发贴人
@property(nonatomic, strong)NSURL * authorFaceURL; //发帖人头像
@property(nonatomic, strong)NSDate * time; //发贴时间戳
@property(nonatomic, strong)NSString * title; //标题
@property(nonatomic, strong)NSString * content; //内容
@property(nonatomic, strong)NSString * quote; //帖子引用的内容
@property(nonatomic, strong)NSString * quoter; //引用内容的作者
@property(nonatomic, strong)NSString * last_author; //最后回复用户
@property(nonatomic, strong)NSDate * last_time; //最后恢复时间
@property(nonatomic, strong)NSArray * attachments;//附件

@property(nonatomic, assign)int index;  //notification使用

@end
