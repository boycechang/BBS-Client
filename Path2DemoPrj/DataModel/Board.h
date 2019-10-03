//
//  Board.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/27/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Board : NSObject
{
    NSString * name; //版面英文名
    NSString * description; //版面中文名
    int section; //版面所在分区
    int count; //帖子数目
    int users; //在线用户数
    NSArray * bm; //版主
    
    //分区和收藏夹额外说明
    NSString * sectionName; //分区中文名
    NSString * sectionDescription; //显示[目录]或者[上级目录]
    NSArray * sectionBoards; //分区包含的版面
    BOOL leaf; //是否为叶子节点
}

@property(nonatomic, strong) NSString * name; //版面英文名
@property(nonatomic, strong) NSString * description; //版面中文名
@property(nonatomic, assign) int section; //版面所在分区
@property(nonatomic, assign) int count; //帖子数目
@property(nonatomic, assign) int users; //在线用户数
@property(nonatomic, strong) NSArray * bm; //版主

//分区和收藏夹额外说明
@property(nonatomic, strong) NSString * sectionName; //分区中文名
@property(nonatomic, strong) NSString * sectionDescription; //显示[目录]或者[上级目录]
@property(nonatomic, strong) NSArray * sectionBoards; //分区包含的版面
@property(nonatomic, assign) BOOL leaf; //是否为叶子节点
@end
