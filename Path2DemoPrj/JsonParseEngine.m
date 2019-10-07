//
//  JsonParseEngine.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "JsonParseEngine.h"
#import "WBUtil.h"
#import <MJExtension.h>

@implementation JsonParseEngine

+(User *)parseLogin:(NSDictionary *)loginDictionary
{
    NSString * code = [loginDictionary objectForKey:@"code"];
    if (!code) {
        User * myself = [[User alloc] init];
        myself.id = [loginDictionary objectForKey:@"id"];
        myself.user_name = [loginDictionary objectForKey:@"user_name"];
        return myself;
    } else {
        return nil;
    }
}

+(NSArray *)parseMails:(NSDictionary *)friendsDictionary Type:(int)type
{
    NSString * code = [friendsDictionary objectForKey:@"code"];
    if (!code)
    {
        NSMutableArray * mails = [[NSMutableArray alloc] init];
        NSArray * temp = [friendsDictionary objectForKey:@"mail"];
        NSUInteger count = [temp count];
        for (int i=0; i<count; i++) {
            Mail * mail = [[Mail alloc] init];
            
//            mail.ID = [[[[friendsDictionary objectForKey:@"mail"] objectAtIndex:i] objectForKey:@"index"] intValue];
//            mail.size = [[[[friendsDictionary objectForKey:@"mail"] objectAtIndex:i] objectForKey:@"size"] intValue];
//            mail.unread = ![[[[friendsDictionary objectForKey:@"mail"] objectAtIndex:i] objectForKey:@"is_read"] boolValue];
//            
//            NSString * author;
//            NSObject * authortest = [[[friendsDictionary objectForKey:@"mail"] objectAtIndex:i] objectForKey:@"user"];
//            if ([authortest isKindOfClass:[NSDictionary class]]) {
//                author = [[[[friendsDictionary objectForKey:@"mail"] objectAtIndex:i] objectForKey:@"user"] objectForKey:@"id"];
//            }
//            else
//                author = [[[friendsDictionary objectForKey:@"mail"] objectAtIndex:i] objectForKey:@"user"];
//            
//            
//            mail.author = author;
//            mail.title = [[[friendsDictionary objectForKey:@"mail"] objectAtIndex:i] objectForKey:@"title"];
//            
//            NSTimeInterval interval = [[[[friendsDictionary objectForKey:@"mail"] objectAtIndex:i] objectForKey:@"post_time"] doubleValue];
//            mail.time = [NSDate dateWithTimeIntervalSince1970:interval];
//            mail.type = type;
//            
//            [mails addObject:mail];
        }
        return mails;
    }
    else {
        return nil;
    }
}


+(Mail *)parseSingleMail:(NSDictionary *)friendsDictionary  Type:(int)type
{
    NSString * code = [friendsDictionary objectForKey:@"code"];
    if (!code)
    {
        Mail * mail = [[Mail alloc] init];
        
//        mail.ID = [[friendsDictionary objectForKey:@"index"] intValue];
//        mail.size = [[friendsDictionary objectForKey:@"size"] intValue];
//        mail.unread = ![[friendsDictionary objectForKey:@"is_read"] boolValue];
//        
//        NSString * author;
//        NSObject * authortest = [friendsDictionary objectForKey:@"user"];
//        if ([authortest isKindOfClass:[NSDictionary class]]) {
//            author = [[friendsDictionary objectForKey:@"user"] objectForKey:@"id"];
//        }
//        else
//            author = [friendsDictionary objectForKey:@"user"];
//        
//        
//        mail.author = author;
//        mail.title = [friendsDictionary objectForKey:@"title"];
//        
//        NSTimeInterval interval = [[friendsDictionary objectForKey:@"post_time"] doubleValue];
//        mail.time = [NSDate dateWithTimeIntervalSince1970:interval];
//        mail.type = type;
//        mail.content = [JsonParseEngine trimText:(NSString *)[friendsDictionary objectForKey:@"content"]];

        return mail;
    }
    else {
        return nil;
    }
}

+(NSArray *)parseBoards:(NSDictionary *)boardsDictionary
{
//    NSString * code = [boardsDictionary objectForKey:@"code"];
//    if (!code)
//    {
//        NSMutableArray * boards = [[NSMutableArray alloc] init];
//        NSArray * temp;
//        
//        temp = [boardsDictionary objectForKey:@"section"];
//        for (int i = 0; i < [temp count]; i++) {
//            
//            if (![[[boardsDictionary objectForKey:@"section"] objectAtIndex:i] isKindOfClass:[NSDictionary class]])
//                continue;   //应对搜索
//            
//            Board * board = [[Board alloc] init];
//            NSString * name = [[[boardsDictionary objectForKey:@"section"] objectAtIndex:i] objectForKey:@"name"];
//            int section = [[[[boardsDictionary objectForKey:@"section"] objectAtIndex:i] objectForKey:@"id"] intValue];
//            NSString * description = [[[boardsDictionary objectForKey:@"section"] objectAtIndex:i] objectForKey:@"description"];
//            int users = [[[[boardsDictionary objectForKey:@"section"] objectAtIndex:i] objectForKey:@"user_online_count"] intValue];
//            int count = [[[[boardsDictionary objectForKey:@"section"] objectAtIndex:i] objectForKey:@"post_today_count"] intValue];
//            
//            board.name = name;
//            board.section = section;
//            board.leaf = NO;
//            board.description = description;
//            board.users = users;
//            board.count = count;
//            
//            [boards addObject:board];
//        }
//        
//        temp = [boardsDictionary objectForKey:@"board"];
//        for (int i = 0; i < [temp count]; i++) {
//            Board * board = [[Board alloc] init];
//            
//            NSString * name = [[[boardsDictionary objectForKey:@"board"] objectAtIndex:i] objectForKey:@"name"];
//            int section = [[[[boardsDictionary objectForKey:@"board"] objectAtIndex:i] objectForKey:@"id"] intValue];
//            NSString * description = [[[boardsDictionary objectForKey:@"board"] objectAtIndex:i] objectForKey:@"description"];
//            int users = [[[[boardsDictionary objectForKey:@"board"] objectAtIndex:i] objectForKey:@"user_online_count"] intValue];
//            int count = [[[[boardsDictionary objectForKey:@"board"] objectAtIndex:i] objectForKey:@"post_today_count"] intValue];
//            
//            board.name = name;
//            board.section = section;
//            board.leaf = YES;
//            board.description = description;
//            board.users = users;
//            board.count = count;
//            
//            [boards addObject:board];
//        }
//        
//        temp = [boardsDictionary objectForKey:@"sub_section"];
//        if ([temp count] != 0) {
//            for (int j = 0; j < [temp count]; j++) {
//                Board * board = [[Board alloc] init];
//                board.name = [[boardsDictionary objectForKey:@"sub_section"] objectAtIndex:j];
//                board.leaf = NO;
//                [boards addObject:board];
//            }
//        }
//        return boards;
//    }
//    else {
//        return nil;
//    }
}

+ (NSArray *)parseTopics:(NSDictionary *)topicsDictionary {
    return [Topic mj_objectArrayWithKeyValuesArray:[topicsDictionary objectForKey:@"article"]];
}

+ (NSArray *)parseSearchTopics:(NSDictionary *)topicsDictionary {
    return [Topic mj_objectArrayWithKeyValuesArray:[topicsDictionary objectForKey:@"threads"]];
}

+ (NSArray *)parseReplyTopic:(NSDictionary *)topicsDictionary {
    Topic *topic = [Topic mj_objectWithKeyValues:topicsDictionary];
    return @[topic];
}

+ (NSString *)trimText:(NSString *)originalText {
    NSString *oldText = [originalText stringByReplacingOccurrencesOfString:@"\n--\n\n" withString:@""];
    NSString *oldText1 = [oldText stringByReplacingOccurrencesOfString:@"\n--\n" withString:@""];
    NSString *oldText2 = [oldText1 stringByReplacingOccurrencesOfString:@"\n--" withString:@""];
    NSError *error = nil;
    
    //NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[.*?[^]]\\]" options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[^em].*?[^]]\\]" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *text = [regex stringByReplacingMatchesInString:oldText2 options:0 range:NSMakeRange(0, oldText2.length) withTemplate:@""];

    return text;
}

+ (NSArray *)parseSingleTopic:(NSDictionary *)topicsDictionary {
    return [Topic mj_objectArrayWithKeyValuesArray:[topicsDictionary objectForKey:@"article"]];
}

+ (User *)parseUserInfo:(NSDictionary *)loginDictionary {
    return [User mj_objectWithKeyValues:loginDictionary];
}

+(NSArray *)parseAttachments:(NSDictionary *)attDic
{
    NSString * code = [attDic objectForKey:@"code"];
    if (!code)
    {
        NSMutableArray *attArray = [[NSMutableArray alloc] init];
//        NSArray * temp = [attDic objectForKey:@"file"];
//        NSUInteger count = [temp count];
//        for (int j=0;  j<count;j++) {
//            Attachment *attElement=[[Attachment alloc]init];
//            [attElement setAttFileName:[[[attDic objectForKey:@"file"] objectAtIndex:j] objectForKey:@"name"]];
//            NSMutableString * urlString = [[[[attDic objectForKey:@"file"] objectAtIndex:j] objectForKey:@"url"] mutableCopy];
//            if (urlString.length >= 28) {
//                [urlString replaceCharactersInRange:NSMakeRange(0, 28) withString:@"http://bbs.byr.cn/att"];
//            }
//            
//            [attArray addObject:attElement];
//        }
        return attArray;
    }
    else {
        return nil;
    }
}

+(NSArray *)parseVoteList:(NSDictionary *)votesDictionary
{
    NSString * code = [votesDictionary objectForKey:@"code"];
    if (!code)
    {
        NSMutableArray *votesArray = [[NSMutableArray alloc] init];
        NSArray * temp = [votesDictionary objectForKey:@"votes"];
        NSUInteger count = [temp count];
        for (int j=0;  j<count;j++) {
            Vote *vote = [[Vote alloc]init];
            
            vote.vid = [[[[votesDictionary objectForKey:@"votes"] objectAtIndex:j] objectForKey:@"vid"] intValue];
            vote.voteTitle = [[[votesDictionary objectForKey:@"votes"] objectAtIndex:j] objectForKey:@"title"];
            
            NSTimeInterval interval = [[[[votesDictionary objectForKey:@"votes"] objectAtIndex:j] objectForKey:@"start"] intValue];
            NSDate *start = [NSDate dateWithTimeIntervalSince1970:interval];
            
            interval = [[[[votesDictionary objectForKey:@"votes"] objectAtIndex:j] objectForKey:@"end"] intValue];
            NSDate *end = [NSDate dateWithTimeIntervalSince1970:interval];
            
            vote.start = start;
            vote.end = end;
            
            vote.user_count = [[[[votesDictionary objectForKey:@"votes"] objectAtIndex:j] objectForKey:@"user_count"] intValue];
            vote.vote_count = [[[[votesDictionary objectForKey:@"votes"] objectAtIndex:j] objectForKey:@"vote_count"] intValue];
            vote.type = [[[[votesDictionary objectForKey:@"votes"] objectAtIndex:j] objectForKey:@"type"] intValue];
            vote.limit = [[[[votesDictionary objectForKey:@"votes"] objectAtIndex:j] objectForKey:@"limit"] intValue];
            
            
            vote.is_end = [[[[votesDictionary objectForKey:@"votes"] objectAtIndex:j] objectForKey:@"is_end"] boolValue];
            vote.is_deleted = [[[[votesDictionary objectForKey:@"votes"] objectAtIndex:j] objectForKey:@"is_deleted"] boolValue];
            vote.is_result_voted = [[[[votesDictionary objectForKey:@"votes"] objectAtIndex:j] objectForKey:@"is_result_voted"] boolValue];
            
            
            NSObject * authortest = [[[votesDictionary objectForKey:@"votes"] objectAtIndex:j] objectForKey:@"user"];
            NSString *author = NULL;
            NSURL *authorHeadUrl = NULL;
            
            if ([authortest isKindOfClass:[NSDictionary class]]) {
                author = [[[[votesDictionary objectForKey:@"votes"] objectAtIndex:j] objectForKey:@"user"] objectForKey:@"id"];
                authorHeadUrl = [NSURL URLWithString:[[[[votesDictionary objectForKey:@"votes"] objectAtIndex:j] objectForKey:@"user"] objectForKey:@"face_url"]];
            }
            else {
                author = [[[votesDictionary objectForKey:@"votes"] objectAtIndex:j] objectForKey:@"user"];
                authorHeadUrl = nil;
            }
            
            vote.author = author;
            vote.authorHeadUrl = authorHeadUrl;
            
            NSMutableArray *voted = [[NSMutableArray alloc] init];
            NSObject * votedtest = [[[votesDictionary objectForKey:@"votes"] objectAtIndex:j] objectForKey:@"voted"];
            if ([votedtest isKindOfClass:[NSDictionary class]]) {
                NSArray *myVotes = [[[[votesDictionary objectForKey:@"votes"] objectAtIndex:j] objectForKey:@"voted"] objectForKey:@"viid"];
                [voted addObjectsFromArray:myVotes];
            }
            else
                voted = nil;
            
            vote.voted = voted;
            [votesArray addObject:vote];
        }
        return votesArray;
    }
    else {
        return nil;
    }
}

+(Vote *)parseSingleVote:(NSDictionary *)voteDictionary
{
    NSString * code = [voteDictionary objectForKey:@"code"];
    if (!code)
    {
        Vote *vote = [[Vote alloc]init];
        
        vote.vid = [[[voteDictionary objectForKey:@"vote"] objectForKey:@"vid"] intValue];
        vote.voteTitle = [[voteDictionary objectForKey:@"vote"] objectForKey:@"title"];
        
        NSTimeInterval interval = [[[voteDictionary objectForKey:@"vote"] objectForKey:@"start"] intValue];
        NSDate *start = [NSDate dateWithTimeIntervalSince1970:interval];
        
        interval = [[[voteDictionary objectForKey:@"vote"] objectForKey:@"end"] intValue];
        NSDate *end = [NSDate dateWithTimeIntervalSince1970:interval];
        
        vote.start = start;
        vote.end = end;
        
        vote.user_count = [[[voteDictionary objectForKey:@"vote"] objectForKey:@"user_count"] intValue];
        vote.vote_count = [[[voteDictionary objectForKey:@"vote"] objectForKey:@"vote_count"] intValue];
        vote.type = [[[voteDictionary objectForKey:@"vote"] objectForKey:@"type"] intValue];
        vote.limit = [[[voteDictionary objectForKey:@"vote"] objectForKey:@"limit"] intValue];
        
        
        vote.is_end = [[[voteDictionary objectForKey:@"vote"] objectForKey:@"is_end"] boolValue];
        vote.is_deleted = [[[voteDictionary objectForKey:@"vote"] objectForKey:@"is_deleted"] boolValue];
        vote.is_result_voted = [[[voteDictionary objectForKey:@"vote"] objectForKey:@"is_result_voted"] boolValue];
        
        
        NSObject * authortest = [[voteDictionary objectForKey:@"vote"] objectForKey:@"user"];
        NSString *author = NULL;
        NSURL *authorHeadUrl = NULL;
        
        if ([authortest isKindOfClass:[NSDictionary class]]) {
            author = [[[voteDictionary objectForKey:@"vote"] objectForKey:@"user"] objectForKey:@"id"];
            authorHeadUrl = [NSURL URLWithString:[[[voteDictionary objectForKey:@"vote"] objectForKey:@"user"] objectForKey:@"face_url"]];
        }
        else {
            author = [[voteDictionary objectForKey:@"vote"] objectForKey:@"user"];
            authorHeadUrl = nil;
        }
        
        vote.author = author;
        vote.authorHeadUrl = authorHeadUrl;
        
        NSMutableArray *voted = [[NSMutableArray alloc] init];
        NSObject * votedtest = [[voteDictionary objectForKey:@"vote"] objectForKey:@"voted"];
        if ([votedtest isKindOfClass:[NSDictionary class]]) {
            NSArray *myVotes = [[[voteDictionary objectForKey:@"vote"] objectForKey:@"voted"] objectForKey:@"viid"];
            [voted addObjectsFromArray:myVotes];
        }
        else {
            voted = nil;
        }
        vote.voted = voted;
        
        
        NSArray *options = [[voteDictionary objectForKey:@"vote"] objectForKey:@"options"];
        NSMutableArray *optionsArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [options count]; i++) {
            Vote *option = [[Vote alloc] init];
            option.viid = [[[options objectAtIndex:i] objectForKey:@"viid"] intValue];
            option.num = [[[options objectAtIndex:i] objectForKey:@"num"] intValue];
            option.label = [[options objectAtIndex:i] objectForKey:@"label"];
            [optionsArray addObject:option];
        }
        vote.options = optionsArray;
        
        return vote;
    }
    else {
        return nil;
    }

}
@end


