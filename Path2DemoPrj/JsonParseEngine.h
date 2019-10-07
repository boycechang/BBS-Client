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

+(User *)parseLogin:(NSDictionary *)loginDictionary;                       ///
+(NSArray *)parseMails:(NSDictionary *)friendsDictionary Type:(int)type;  ///
+(Mail *)parseSingleMail:(NSDictionary *)friendsDictionary Type:(int)type; ///

+(NSArray *)parseBoards:(NSDictionary *)boardsDictionary;         ///
+(NSArray *)parseTopics:(NSDictionary *)topicsDictionary;         ///
+(NSArray *)parseSearchTopics:(NSDictionary *)topicsDictionary;   ///

+(NSArray *)parseAttachments:(NSDictionary *)attDic;
+(NSArray *)parseSingleTopic:(NSDictionary *)topicsDictionary;  ///
+(NSArray *)parseReplyTopic:(NSDictionary *)topicsDictionary;     ///
+(User *)parseUserInfo:(NSDictionary *)topicsDictionary;        ///

+(NSArray *)parseVoteList:(NSDictionary *)votesDictionary;        ///
+(Vote *)parseSingleVote:(NSDictionary *)voteDictionary;        ///

@end
