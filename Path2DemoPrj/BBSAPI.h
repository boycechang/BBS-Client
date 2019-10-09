//
//  BBSAPI.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBUtil.h"
#import "JsonParseEngine.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import <netinet/in.h>

@interface BBSAPI : NSObject

+(BOOL)isNetworkReachable;

+(User *)userInfo:(NSString *)userID;  ///

+(NSArray *)singleTopic:(NSString *)board ID:(int)ID Page:(NSInteger)page User:(User *)user;///
+(NSArray *)replyTopic:(NSString *)board ID:(int)ID Start:(NSInteger)start User:(User *)user; ///

+(NSArray *)searchTopics:(NSString *)key start:(NSInteger)start User:(User *)user BoardName:(NSString *)board;
+(NSArray *)searchBoards:(NSString *)key User:(User *)user;  ///

+(BOOL)postMail:(User *)myself User:(NSString *)user Title:(NSString *)title Content:(NSString *)content Reid:(int)reid;
+(BOOL)replyMail:(User *)myself User:(NSString *)user Title:(NSString *)title Content:(NSString *)content Type:(int)type ID:(int)ID;

+(Notification *)getAllNotificationCount:(User *)user;    ///
+(BOOL)deleteNotification:(User *)user Type:(NSString *)type ID:(int)ID; ///
+(BOOL)clearNotification:(User *)user;            ///

+(BOOL)postTopic:(User *)user Board:(NSString *)board Title:(NSString *)title Content:(NSString *)content Reid:(int)reid;
+(BOOL)editTopic:(User *)user Board:(NSString *)board Title:(NSString *)title Content:(NSString *)content Reid:(int)reid;

+(NSArray* )postImage:(User *)user Board:(NSString *)board ID:(int)ID Image:(UIImage *)image ImageName:(NSString *)imageName;  ///
+(NSArray* )getAttachmentsFromTopic:(User *)user Board:(NSString *)board ID:(int)ID;   ///
+(NSArray* )deleteAttachmentsFromTopic:(User *)user Board:(NSString *)board ID:(int)ID Name:(NSString *)name; ///

+ (NSString *)dateToString:(NSDate *)date;





+(NSArray *)getVoteList:(User *)user Type:(NSString *)type;   ///type: me|join|list|new|hot|all
+(Vote *)getSingleVote:(User *)user ID:(int)ID;
+(Vote *)doVote:(User *)user ID:(int)ID VoteArray:(NSArray *)voteArray;

@end
