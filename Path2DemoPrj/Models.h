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

@interface User : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *astro;
@property (nonatomic, strong) NSString *home_page;
@property (nonatomic, strong) NSURL *face_url;

@property (nonatomic, assign) NSTimeInterval last_login_time;
@property (nonatomic, strong) NSString *last_login_ip;

@property (nonatomic, assign) BOOL is_hide;
@property (nonatomic, assign) BOOL is_online;
@property (nonatomic, assign) BOOL is_register;
@property (nonatomic, assign) BOOL is_follow;

@property (nonatomic, assign) NSUInteger life;
@property (nonatomic, assign) NSUInteger score;
@property (nonatomic, assign) NSUInteger follow_num;
@property (nonatomic, assign) NSUInteger post_count;

@end

@interface Attachment : NSObject

@property(nonatomic, assign) int attId;
@property(nonatomic, strong) NSString *attFileName;
@property(nonatomic, assign) int attPos;
@property(nonatomic, assign) int attSize;
@property(nonatomic, strong) NSString *attUrl;

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
@property (nonatomic, assign) BOOL unread;
@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, assign) NSUInteger reply_count;
@property (nonatomic, strong) NSDate *last_reply_time;
@property (nonatomic, strong) NSString *last_reply_user_id;
@property (nonatomic, strong) NSString *reply_id;

@property (nonatomic, strong) NSString *board_name;
@property (nonatomic, strong) NSString *board_description;

@end

NS_ASSUME_NONNULL_END
