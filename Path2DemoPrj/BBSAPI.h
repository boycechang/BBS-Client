//
//  BBSAPI.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "WBUtil.h"
#import "JsonParseEngine.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import <netinet/in.h>

@interface BBSAPI : NSObject

+(BOOL)isNetworkReachable;

+(User *)userInfo:(NSString *)userID;  ///
+(NSArray *)topTen;///
+(NSArray *)sectionTopTen:(int)sectionNumber;///
+(NSArray *)hotTopics;  ///

+(NSArray *)getBoards:(User *)user Section:(NSString *)section;   ///section
+(NSArray *)boardTopics:(NSString *)board Start:(NSInteger)start Limit:(NSInteger)limit User:(User *)user Mode:(int)mode UserOnline:(int *)userOnline PostToday:(int *)postToday PostAll:(int *)postAll; ///
+(NSArray *)boardTopics:(NSString *)board Start:(NSInteger)start Limit:(NSInteger)limit User:(User *)user Mode:(int)mode;
+(NSArray *)singleTopic:(NSString *)board ID:(int)ID Page:(NSInteger)page User:(User *)user;///
+(NSArray *)replyTopic:(NSString *)board ID:(int)ID Start:(NSInteger)start User:(User *)user; ///
+(NSArray *)searchTopics:(NSString *)key start:(NSInteger)start User:(User *)user BoardName:(NSString *)board;
+(NSArray *)searchBoards:(NSString *)key User:(User *)user;  ///

+(User *)login:(NSString *)user Pass:(NSString *)pass;   ///
+(BOOL)addNotificationToken:(NSString *)token iToken:(NSString *)iToken;
+(NSArray *)allFavSections:(User *)user;
+(BOOL)addFavBoard:(User *)user BoardName:(NSString *)BoardName;
+(BOOL)deleteFavBoard:(User *)user BoardName:(NSString *)BoardName;

+(NSArray *)onlineFriends:(User *)user;
+(NSArray *)allFriends:(User *)user;
+(BOOL)deletFriend:(User *)user ID:(NSString *)ID;
+(BOOL)addFriend:(User *)user ID:(NSString *)ID;
+(BOOL)isFriend:(User *)user ID:(NSString *)ID;

+(NSArray *)getMails:(User *)user Type:(int)type Start:(int)start;   ///
+(Mail *)getSingleMail:(User *)user Type:(int)type ID:(int)ID;       ///
+(BOOL)deleteSingleMail:(User *)user Type:(int)type ID:(int)ID;      ///
+(BOOL)postMail:(User *)myself User:(NSString *)user Title:(NSString *)title Content:(NSString *)content Reid:(int)reid;
+(BOOL)replyMail:(User *)myself User:(NSString *)user Title:(NSString *)title Content:(NSString *)content Type:(int)type ID:(int)ID;

+(NSArray *)getNotification:(User *)user Type:(NSString *)type Start:(NSInteger)start Limit:(NSInteger)limit;    ///
+(Notification *)getAllNotificationCount:(User *)user;    ///
+(BOOL )deleteNotification:(User *)user Type:(NSString *)type ID:(int)ID; ///
+(BOOL)clearNotification:(User *)user;            ///

+(BOOL)postTopic:(User *)user Board:(NSString *)board Title:(NSString *)title Content:(NSString *)content Reid:(int)reid;
+(BOOL)editTopic:(User *)user Board:(NSString *)board Title:(NSString *)title Content:(NSString *)content Reid:(int)reid;

+(NSArray* )postImage:(User *)user Board:(NSString *)board ID:(int)ID Image:(UIImage *)image ImageName:(NSString *)imageName;  ///
+(NSArray* )getAttachmentsFromTopic:(User *)user Board:(NSString *)board ID:(int)ID;   ///
+(NSArray* )deleteAttachmentsFromTopic:(User *)user Board:(NSString *)board ID:(int)ID Name:(NSString *)name; ///

+ (NSString *)dateToString:(NSDate *)date;

+(NSArray *)photographyTopics:(int)start;  ///
+(NSArray *)picturesTopics:(int)start; ///

+(NSArray *)getVoteList:(User *)user Type:(NSString *)type;   ///type: me|join|list|new|hot|all
+(Vote *)getSingleVote:(User *)user ID:(int)ID;
+(Vote *)doVote:(User *)user ID:(int)ID VoteArray:(NSArray *)voteArray;
@end
