//
//  Board.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/27/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "Board.h"

@implementation Board

@synthesize name; //版面英文名
@synthesize description; //版面中文名
@synthesize section;
@synthesize count; //帖子数目
@synthesize users; //在线用户数
@synthesize bm; //版主

//分区和收藏夹额外说明
@synthesize sectionName; //分区中文名
@synthesize sectionDescription; //显示[目录]或者[上级目录]
@synthesize sectionBoards; //分区包含的版面
@synthesize leaf; //是否为叶子节点

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
@end
