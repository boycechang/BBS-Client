//
//  Models.h
//  BYR
//
//  Created by Boyce on 10/3/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

NS_ASSUME_NONNULL_BEGIN


@interface Pagination : NSObject

@property (nonatomic, assign) NSInteger page_all_count; //总页数
@property (nonatomic, assign) NSInteger page_current_count; //当前页数

@property (nonatomic, assign) NSInteger item_page_count; //每页元素个数
@property (nonatomic, assign) NSInteger item_all_count; //所有元素个数

@end


@interface Board : NSObject

@property (nonatomic, strong) NSString *name; //版面英文名
@property (nonatomic, strong) NSString *board_description; //版面中文名
@property (nonatomic, assign) BOOL is_root; //是否为根节点
@property (nonatomic, strong) NSString *section; //版面所在分区

@property (nonatomic, assign) BOOL is_favorite;
@property (nonatomic, assign) NSInteger post_today_count; //帖子数目
@property (nonatomic, assign) NSInteger user_online_count; //在线用户数

//分区和收藏夹额外说明
@property (nonatomic, strong) NSString * sectionName; //分区中文名
@property (nonatomic, strong) NSString * sectionDescription; //显示[目录]或者[上级目录]
@property (nonatomic, strong) NSArray * sectionBoards; //分区包含的版面

@end


@interface User : NSObject <NSCoding>

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *astro;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *home_page;
@property (nonatomic, strong) NSURL *face_url;

@property (nonatomic, assign) NSTimeInterval last_login_time;
@property (nonatomic, strong) NSString *last_login_ip;

@property (nonatomic, assign) BOOL is_hide;
@property (nonatomic, assign) BOOL is_online;
@property (nonatomic, assign) BOOL is_register;
@property (nonatomic, assign) BOOL is_follow;

@property (nonatomic, assign) NSInteger life;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger follow_num;
@property (nonatomic, assign) NSInteger post_count;

@end


@interface Attachment : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *thumbnail_small;
@property (nonatomic, strong) NSString *thumbnail_middle;
@property (nonatomic, strong) NSString *url;

@end


@interface Topic : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *group_id;
@property (nonatomic, strong) User *user;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *flag;

@property (nonatomic, assign) NSTimeInterval post_time;

@property (nonatomic, strong) NSArray <Topic *> *articles;

@property (nonatomic, assign) BOOL has_attachment;
@property (nonatomic, strong) NSArray <Attachment *> *attachments;

@property (nonatomic, assign) BOOL is_subject;
@property (nonatomic, assign) BOOL is_top;
@property (nonatomic, assign) BOOL is_admin;
@property (nonatomic, assign) NSUInteger position;

@property (nonatomic, assign) NSInteger reply_count;
@property (nonatomic, strong) NSDate *last_reply_time;
@property (nonatomic, strong) NSString *last_reply_user_id;
@property (nonatomic, strong) NSString *reply_id;

@property (nonatomic, strong) NSString *board_name;
@property (nonatomic, strong) NSString *board_description;


// 提醒
@property (nonatomic, assign) BOOL is_read;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger pos;
@property (nonatomic, assign) NSTimeInterval time;

// 富文本解析缓存
@property (nonatomic, strong) NSAttributedString *attributedContentCache;

@end



@interface Mail : NSObject

@property (nonatomic, strong) NSString *index;
@property (nonatomic, strong) User *user;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;

@property (nonatomic, assign) NSTimeInterval post_time;

@property (nonatomic, assign) BOOL is_read;

@property (nonatomic, assign) BOOL has_attachment;
@property (nonatomic, strong) NSArray <Attachment *> *attachments;

// 富文本解析缓存
@property (nonatomic, strong) NSAttributedString *attributedContentCache;

@end





NS_ASSUME_NONNULL_END
