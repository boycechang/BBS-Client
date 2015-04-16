//
//  JsonParseEngine.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"


@interface JsonParseEngine : NSObject

+(void)parseSingleSection:(Board *)board BoardsDictionary:(NSArray *)boardsArray;


+(User *)parseLogin:(NSDictionary *)loginDictionary;
+(NSArray *)parseFriends:(NSDictionary *)friendsDictionary;
+(NSArray *)parseMails:(NSDictionary *)friendsDictionary Type:(int)type;
+(Mail *)parseSingleMail:(NSDictionary *)friendsDictionary Type:(int)type;
+(Notification *)parseNotification:(NSDictionary *)notificationDictionary;

+(NSArray *)parseSections:(NSDictionary *)sectionsDictionary;
+(NSArray *)parseBoards:(NSDictionary *)boardsDictionary;
+(NSArray *)parseTopics:(NSDictionary *)topicsDictionary;
+(NSArray *)parseSearchTopics:(NSDictionary *)topicsDictionary;

+(NSArray *)parseAttachments:(NSDictionary *)attDic;
+(NSArray *)parseSingleTopic:(NSDictionary *)topicsDictionary;
+(User *)parseUserInfo:(NSDictionary *)topicsDictionary;

@end
