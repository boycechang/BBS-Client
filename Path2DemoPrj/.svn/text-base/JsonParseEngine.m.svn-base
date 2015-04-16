//
//  JsonParseEngine.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "JsonParseEngine.h"
#import "WBUtil.h"
@implementation JsonParseEngine

+(User *)parseLogin:(NSDictionary *)loginDictionary
{
    BOOL success = [[loginDictionary objectForKey:@"success"] boolValue];
    if (success)
    {
        User * myself = [[User alloc] init];
        myself.ID = [loginDictionary objectForKey:@"id"];
        myself.name = [loginDictionary objectForKey:@"name"];
        
        NSString * urlEncode = [loginDictionary objectForKey:@"token"];
        myself.token = [urlEncode URLEncodedString];
        return myself;
    }
    else {
        return nil;
    }
}
+(NSArray *)parseFriends:(NSDictionary *)friendsDictionary
{
    BOOL success = [[friendsDictionary objectForKey:@"success"] boolValue];
    if (success)
    {
        NSMutableArray * friends = [[NSMutableArray alloc] init];
        for (int i=0; i<[[friendsDictionary objectForKey:@"friends"] count]; i++) {
            User * user = [[User alloc] init];
            
            NSString * name = [[[friendsDictionary objectForKey:@"friends"] objectAtIndex:i] objectForKey:@"name"];
            NSString * ID = [[[friendsDictionary objectForKey:@"friends"] objectAtIndex:i] objectForKey:@"id"];
            NSString * mode = [[[friendsDictionary objectForKey:@"friends"] objectAtIndex:i] objectForKey:@"mode"];
            
            user.name = name;
            user.ID = ID;
            user.mode = mode;
            
            [friends addObject:user];
        }
        return friends;
    }
    else {
        return nil;
    }
}
+(NSArray *)parseMails:(NSDictionary *)friendsDictionary Type:(int)type
{
    BOOL success = [[friendsDictionary objectForKey:@"success"] boolValue];
    if (success)
    {
        NSMutableArray * mails = [[NSMutableArray alloc] init];
        for (int i=0; i<[[friendsDictionary objectForKey:@"mails"] count]; i++) {
            Mail * mail = [[Mail alloc] init];
            
            mail.ID = [[[[friendsDictionary objectForKey:@"mails"] objectAtIndex:i] objectForKey:@"id"] intValue];
            mail.size = [[[[friendsDictionary objectForKey:@"mails"] objectAtIndex:i] objectForKey:@"size"] intValue];
            mail.unread = [[[[friendsDictionary objectForKey:@"mails"] objectAtIndex:i] objectForKey:@"unread"] boolValue];
            mail.author = [[[friendsDictionary objectForKey:@"mails"] objectAtIndex:i] objectForKey:@"author"];
            mail.title = [[[friendsDictionary objectForKey:@"mails"] objectAtIndex:i] objectForKey:@"title"];
            
            NSTimeInterval interval = [[[[friendsDictionary objectForKey:@"mails"] objectAtIndex:i] objectForKey:@"time"] doubleValue];            
            mail.time = [NSDate dateWithTimeIntervalSince1970:interval];
            mail.type = type;
            
            [mails addObject:mail];
        }
        return mails;
    }
    else {
        return nil;
    }
}
+(Mail *)parseSingleMail:(NSDictionary *)friendsDictionary  Type:(int)type
{
    BOOL success = [[friendsDictionary objectForKey:@"success"] boolValue];
    if (success)
    {
        Mail * mail = [[Mail alloc] init];
            
        mail.ID = [[[friendsDictionary objectForKey:@"mail"] objectForKey:@"id"] intValue];
        mail.size = [[[friendsDictionary objectForKey:@"mail"] objectForKey:@"size"] intValue];
        mail.unread = [[[friendsDictionary objectForKey:@"mail"] objectForKey:@"unread"] boolValue];
        mail.author = [[friendsDictionary objectForKey:@"mail"] objectForKey:@"author"];
        mail.title = [[friendsDictionary objectForKey:@"mail"] objectForKey:@"title"];
        mail.content = [[friendsDictionary objectForKey:@"mail"] objectForKey:@"content"];
        
        NSTimeInterval interval = [[[friendsDictionary objectForKey:@"mail"] objectForKey:@"time"] doubleValue];            
        mail.time = [NSDate dateWithTimeIntervalSince1970:interval];
        mail.type = type;
        
        return mail;
    }
    else {
        return nil;
    }
}

+(void)parseSingleSection:(Board *)board BoardsDictionary:(NSArray *)boardsArray
{
    for (int i=0; i<[boardsArray count]; i++) {
        Board * boardcach = [[Board alloc] init];
        BOOL leaf = [[[boardsArray objectAtIndex:i] objectForKey:@"leaf"] boolValue];
        NSString * name = [[boardsArray objectAtIndex:i] objectForKey:@"name"];
        NSString * description = [[boardsArray objectAtIndex:i] objectForKey:@"description"];
        int count = [[[boardsArray objectAtIndex:i] objectForKey:@"count"] intValue];
        int users = [[[boardsArray objectAtIndex:i] objectForKey:@"users"] intValue];
        NSArray * bm = [[boardsArray objectAtIndex:i] objectForKey:@"bm"];
        
        boardcach.leaf = leaf;
        boardcach.name = name;
        boardcach.description = description;
        boardcach.count = count;
        boardcach.users = users;
        boardcach.bm = bm;
        
        if (!leaf) {
            [JsonParseEngine parseSingleSection:boardcach BoardsDictionary:[[boardsArray objectAtIndex:i] objectForKey:@"boards"]];
        }
        
        [board.sectionBoards addObject:boardcach];
    }
}

+(NSArray *)parseSections:(NSDictionary *)sectionsDictionary
{
    BOOL success = [[sectionsDictionary objectForKey:@"success"] boolValue];
    if (success)
    {
        NSMutableArray * boards = [[NSMutableArray alloc] init];
        for (int i=0; i<[[sectionsDictionary objectForKey:@"boards"] count]; i++) {
            Board * board = [[Board alloc] init];
            
            BOOL leaf = [[[[sectionsDictionary objectForKey:@"boards"] objectAtIndex:i] objectForKey:@"leaf"] boolValue];
            NSString * name = [[[sectionsDictionary objectForKey:@"boards"] objectAtIndex:i] objectForKey:@"name"];
            NSString * description = [[[sectionsDictionary objectForKey:@"boards"] objectAtIndex:i] objectForKey:@"description"];
            int count = [[[[sectionsDictionary objectForKey:@"boards"] objectAtIndex:i] objectForKey:@"count"] intValue];
            int users = [[[[sectionsDictionary objectForKey:@"boards"] objectAtIndex:i] objectForKey:@"users"] intValue];
            NSArray * bm = [[[sectionsDictionary objectForKey:@"boards"] objectAtIndex:i] objectForKey:@"bm"];
            
            board.leaf = leaf;
            board.name = name;
            board.description = description;
            board.count = count;
            board.users = users;
            board.bm = bm;
            
            if (!leaf) {
                [JsonParseEngine parseSingleSection:board BoardsDictionary:[[[sectionsDictionary objectForKey:@"boards"] objectAtIndex:i] objectForKey:@"boards"]];
                
            }
            [boards addObject:board];
        }
        return boards;
    }
    else {
        return nil;
    }
}

+(NSArray *)parseBoards:(NSDictionary *)boardsDictionary
{
    BOOL success = [[boardsDictionary objectForKey:@"success"] boolValue];
    if (success)
    {
        NSMutableArray * boards = [[NSMutableArray alloc] init];
        for (int i=0; i<[[boardsDictionary objectForKey:@"boards"] count]; i++) {
            Board * board = [[Board alloc] init];
            
            NSString * name = [[[boardsDictionary objectForKey:@"boards"] objectAtIndex:i] objectForKey:@"name"];
            int section = [[[[boardsDictionary objectForKey:@"boards"] objectAtIndex:i] objectForKey:@"id"] intValue];
            BOOL leaf = [[[[boardsDictionary objectForKey:@"boards"] objectAtIndex:i] objectForKey:@"leaf"] boolValue];
            NSString * description = [[[boardsDictionary objectForKey:@"boards"] objectAtIndex:i] objectForKey:@"description"];
            
            board.name = name;
            board.section = section;
            board.leaf = leaf;
            board.description = description;
            
            [boards addObject:board];
        }
        return boards;
    }
    else {
        return nil;
    }
}

+(NSArray *)parseTopics:(NSDictionary *)topicsDictionary
{
    BOOL success = [[topicsDictionary objectForKey:@"success"] boolValue];
    if (success)
    {
        NSMutableArray * topTen = [[NSMutableArray alloc] init];
        for (int i=0; i<[[topicsDictionary objectForKey:@"topics"] count]; i++) {
            Topic * topic = [[Topic alloc] init];
            
            int ID = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"id"] intValue];
            NSString * title = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"title"];
            NSString * author = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"author"];
            NSString * board = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"board"];

            NSTimeInterval interval = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"time"] doubleValue];            
            NSDate *time = [NSDate dateWithTimeIntervalSince1970:interval];
            
            int replies = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"replies"] intValue];
            int read = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"read"] intValue];
            BOOL unread = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i]objectForKey:@"unread"]boolValue];
            BOOL marked = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i]objectForKey:@"mark"] boolValue];
            BOOL top = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i]objectForKey:@"top"] boolValue];
            
            topic.unread = unread;
            topic.ID = ID;
            topic.title = title;
            topic.author = author;
            topic.board = board;
            topic.time = time;
            topic.replies = replies;
            topic.read = read;
            topic.mark = marked;
            topic.top = top;
            
            [topTen addObject:topic];
        }
        return topTen;
    }
    else {
        return nil;
    }
}

+(NSArray *)parseSearchTopics:(NSDictionary *)topicsDictionary
{
    BOOL success = [[topicsDictionary objectForKey:@"success"] boolValue];
    if (success)
    {
        NSMutableArray * topTen = [[NSMutableArray alloc] init];
        for (int i=0; i<[[topicsDictionary objectForKey:@"topics"] count]; i++) {
            Topic * topic = [[Topic alloc] init];
            
            int ID = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"id"] intValue];
            NSString * title = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"title"];
            NSString * author = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"author"];
            NSString * board = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"board"];
            
            NSString *  timeString = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"time"];
            //NSLog(@"%@",timeString);
            NSDateFormatter *inputFormat = [[NSDateFormatter alloc] init];
            [inputFormat setDateFormat:@"yyyyMMdd"]; //20101208
            //将NSString转换为NSDate
            NSDate *time = [inputFormat dateFromString:timeString];
            
            int replies = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"replies"] intValue];
            int read = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"read"] intValue];
            
            topic.ID = ID;
            topic.title = title;
            topic.author = author;
            topic.board = board;
            topic.time = time;
            topic.replies = replies;
            topic.read = read;
            
            [topTen addObject:topic];
        }
        return topTen;
    }
    else {
        return nil;
    }
}

+(NSArray *)parseSingleTopic:(NSDictionary *)topicsDictionary
{
    BOOL success = [[topicsDictionary objectForKey:@"success"] boolValue];
    if (success)
    {
        NSMutableArray * topTen = [[NSMutableArray alloc] init];
        for (int i=0; i<[[topicsDictionary objectForKey:@"topics"] count]; i++) {
            Topic * topic = [[Topic alloc] init];
            
            int ID = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"id"] intValue];
            int gID = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"gid"] intValue];
            int reid = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"reid"] intValue];
            
            NSString * title = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"title"];
            NSString * content = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"content"];
            NSString * author = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"author"];
            NSString * board = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"board"];
            
            NSTimeInterval interval = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"time"] doubleValue];            
            NSDate *time = [NSDate dateWithTimeIntervalSince1970:interval];
            
            int read = [[[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"read"] intValue];
            
            NSString * quote = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"quote"];
            NSString * quoter = [[[topicsDictionary objectForKey:@"topics"] objectAtIndex:i] objectForKey:@"quoter"];
            /////////附件///////
            NSMutableArray * attArray=[[NSMutableArray alloc] init];
            NSDictionary * attDic=[[topicsDictionary objectForKey:@"topics"] objectAtIndex: i];
            for (int j=0;  j<[[attDic objectForKey:@"attachments"]count];j++) {
                Attachment *attElement=[[Attachment alloc]init];
                [attElement setAttFileName:[[[attDic objectForKey:@"attachments"] objectAtIndex:j] objectForKey:@"filename"]];
                
                [attElement setAttId:[[[[attDic objectForKey:@"attachments"] objectAtIndex:j] objectForKey:@"id"] intValue]];
                
                [attElement setAttPos:[[[[attDic objectForKey:@"attachments"] objectAtIndex:j] objectForKey:@"pos"] intValue]];
                
                [attElement setAttSize:[[[[attDic objectForKey:@"attachments"] objectAtIndex:j] objectForKey:@"size"] intValue]];
                
                [attElement setAttUrl:[[[attDic objectForKey:@"attachments"] objectAtIndex:j] objectForKey:@"url"]];
                
                [attArray addObject:attElement];
            }
            ///////////////////
            topic.attachments = attArray;
            ////////modified by joe//////
            topic.ID = ID;
            topic.gID = gID;
            topic.reid = reid;
            
            topic.title = title;
            topic.content = content;
            topic.author = author;
            topic.board = board;
            
            topic.time = time;
            topic.read = read;
            
            if ([quote length] > 20)
                topic.quote = [quote substringToIndex:20];
            else 
                topic.quote = quote;
            topic.quoter =quoter;
            [topTen addObject:topic];
        }
        return topTen;
    }
    else {
        return nil;
    }
}
+(User *)parseUserInfo:(NSDictionary *)loginDictionary2
{
    BOOL success = [[loginDictionary2 objectForKey:@"success"] boolValue];
    NSDictionary * loginDictionary = [loginDictionary2 objectForKey:@"user"];
    if (success)
    {
        User * user = [[User alloc] init];
        user.ID = [loginDictionary objectForKey:@"id"];
        user.name = [loginDictionary objectForKey:@"name"];
        user.avatar = [NSURL URLWithString:[loginDictionary objectForKey:@"avatar"]];
                       
        NSTimeInterval interval = [[loginDictionary objectForKey:@"lastlogin"] doubleValue];            
        NSDate *time = [NSDate dateWithTimeIntervalSince1970:interval];
        user.lastlogin = time;
        
        user.level = [loginDictionary objectForKey:@"level"];
        
        user.posts = [[loginDictionary objectForKey:@"posts"] intValue];
        user.perform = [[loginDictionary objectForKey:@"perform"] intValue];
        user.experience = [[loginDictionary objectForKey:@"experience"] intValue];
        user.medals = [[loginDictionary objectForKey:@"medals"] intValue];
        user.logins = [[loginDictionary objectForKey:@"logins"] intValue];
        user.life = [[loginDictionary objectForKey:@"life"] intValue];
        
        user.gender = [loginDictionary objectForKey:@"gender"];
        user.astro = [loginDictionary objectForKey:@"astro"];
        user.mode = [loginDictionary objectForKey:@"mode"];
        
        return user;
    }
    else {
        return nil;
    }
}

+(Notification *)parseNotification:(NSDictionary *)notificationDictionary
{
    BOOL success = [[notificationDictionary objectForKey:@"success"] boolValue];

    Notification * notification = [[Notification alloc] init];
    if (success)
    {
        NSMutableArray * mails = [[NSMutableArray alloc] init];
        for (int i=0; i<[[notificationDictionary objectForKey:@"mails"] count]; i++) {
            Mail * mail = [[Mail alloc] init];
            
            int ID = [[[[notificationDictionary objectForKey:@"mails"] objectAtIndex:i] objectForKey:@"id"] intValue];
            NSString * title = [[[notificationDictionary objectForKey:@"mails"] objectAtIndex:i] objectForKey:@"title"];
            NSString * author = [[[notificationDictionary objectForKey:@"mails"] objectAtIndex:i] objectForKey:@"sender"];
            mail.ID = ID;
            mail.title = title;
            mail.author = author;
            mail.type = 0;
            mail.unread = YES;
            [mails addObject:mail];
        }
        
        NSMutableArray * ats = [[NSMutableArray alloc] init];
        for (int i=0; i<[[notificationDictionary objectForKey:@"ats"] count]; i++) {
            Topic * topic = [[Topic alloc] init];
            
            int ID = [[[[notificationDictionary objectForKey:@"ats"] objectAtIndex:i] objectForKey:@"id"] intValue];
            NSString * board = [[[notificationDictionary objectForKey:@"ats"] objectAtIndex:i] objectForKey:@"board"];
            NSString * title = [[[notificationDictionary objectForKey:@"ats"] objectAtIndex:i] objectForKey:@"title"];
            NSString * user = [[[notificationDictionary objectForKey:@"ats"] objectAtIndex:i] objectForKey:@"user"];
            
            topic.ID = ID;
            topic.board = board;
            topic.author = user;
            topic.title = title;
            
            [ats addObject:topic];
        }
        
        NSMutableArray * replies = [[NSMutableArray alloc] init];
        for (int i=0; i<[[notificationDictionary objectForKey:@"replies"] count]; i++) {
            Topic * topic = [[Topic alloc] init];
            
            int ID = [[[[notificationDictionary objectForKey:@"replies"] objectAtIndex:i] objectForKey:@"id"] intValue];
            NSString * board = [[[notificationDictionary objectForKey:@"replies"] objectAtIndex:i] objectForKey:@"board"];
            NSString * title = [[[notificationDictionary objectForKey:@"replies"] objectAtIndex:i] objectForKey:@"title"];
            NSString * user = [[[notificationDictionary objectForKey:@"replies"] objectAtIndex:i] objectForKey:@"user"];
            
            topic.ID = ID;
            topic.board = board;
            topic.author = user;
            topic.title = title;
            
            [replies addObject:topic];
        }
        
        notification.mails = mails;
        notification.ats = ats;
        notification.replies = replies;
        
        return notification;
    }
    else {
        return nil;
    }
    return nil;
}

+(NSArray *)parseAttachments:(NSDictionary *)attDic
{
    BOOL success = [[attDic objectForKey:@"success"] boolValue];
    NSMutableArray *attArray=[[NSMutableArray alloc] init];
    if (success) {
    
        for (int j=0;  j<[[attDic objectForKey:@"attachments"]count];j++) {
            Attachment *attElement=[[Attachment alloc]init];
            [attElement setAttFileName:[[[attDic objectForKey:@"attachments"] objectAtIndex:j] objectForKey:@"filename"]];
            
            [attElement setAttId:[[[[attDic objectForKey:@"attachments"] objectAtIndex:j] objectForKey:@"id"] intValue]];
            
            [attElement setAttPos:[[[[attDic objectForKey:@"attachments"] objectAtIndex:j] objectForKey:@"pos"] intValue]];
            
            [attElement setAttSize:[[[[attDic objectForKey:@"attachments"] objectAtIndex:j] objectForKey:@"size"] intValue]];
            
            [attElement setAttUrl:[[[attDic objectForKey:@"attachments"] objectAtIndex:j] objectForKey:@"url"]];
            
            [attArray addObject:attElement];
        }
        
        return attArray;

    }
    else
    {
        return nil;
    }
    
    
}
@end


