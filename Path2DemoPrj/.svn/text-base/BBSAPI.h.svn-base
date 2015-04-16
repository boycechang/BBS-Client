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
@protocol UIViewPassValueDelegate

- (void)passValue:(NSArray *)value;

@end

@interface BBSAPI : NSObject

+(BOOL)isNetworkReachable;

+(User *)userInfo:(NSString *)userID;


+(NSArray *)topTen;
+(NSArray *)sectionTopTen:(int)sectionNumber;
+(NSArray *)hotBoards;
+(NSArray *)offlineDataToAllSections:(NSData *)data;

//有token可以查看内部版面
+(NSData *)allSectionsData:(NSString*)token;
+(NSArray *)boardTopics:(NSString *)board Start:(int)start Token:(NSString*)token Mode:(int)mode;//参数版面名，start为下标
+(NSArray *)singleTopic:(NSString *)board ID:(int)ID Start:(int)start Token:(NSString*)token;//参数帖子版面、及帖子ID，start为帖子下标
+(NSArray *)searchTopics:(NSString *)key start:(NSString *)start  Token:(NSString*)token;
+(NSArray *)searchBoards:(NSString *)key  Token:(NSString*)token;



+(User *)login:(NSString *)user Pass:(NSString *)pass;
+(NSArray *)allFavSections:(NSString *)token;
+(NSArray *)onlineFriends:(NSString *)token;


//+(NSArray *)postImageto:(NSURL *)url withImage:(UIImage *)img andToken:(NSString*)token;
+(NSArray* )postImg:(NSString *)string Image:(UIImage *)image toUrl:(NSURL *)url;
+(NSArray *)delImg:(NSURL*)url;

+(NSArray *)allFriends:(NSString *)token;
+(BOOL)deletFriend:(NSString *)token ID:(NSString *)ID;
+(BOOL)addFriend:(NSString *)token ID:(NSString *)ID;
+(BOOL)isFriend:(NSString *)token ID:(NSString *)ID;
+(BOOL)addFavBoard:(NSString *)token BoardName:(NSString *)BoardName;
+(BOOL)addFavDirect:(NSString *)token DirectName:(NSString *)DirectName;


+(NSArray *)getMails:(NSString *)token Type:(int)type Start:(int)start;
+(Mail *)getSingleMail:(NSString *)token Type:(int)type ID:(int)ID;
+(BOOL)deleteSingleMail:(NSString *)token Type:(int)type ID:(int)ID;
+(BOOL)postMail:(NSString *)token User:(NSString *)user Title:(NSString *)title Content:(NSString *)content Reid:(int)reid;

+(Notification *)getNotification:(NSString *)token;
+(BOOL)clearNotification:(NSString *)token;

+(BOOL)postTopic:(NSString *)token Board:(NSString *)board Title:(NSString *)title Content:(NSString *)content Reid:(int)reid;
+(BOOL)editTopic:(NSString *)token Board:(NSString *)board Title:(NSString *)title Content:(NSString *)content Reid:(int)reid;
+(NSArray*)getAttachmentsFromTopic:(int)topicId andBoard:(NSString*)boardId token:(NSString *)token;
@end
