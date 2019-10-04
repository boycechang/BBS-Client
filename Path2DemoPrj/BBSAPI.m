//
//  BBSAPI.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "BBSAPI.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
#import "AppDelegate.h"
#import <AFNetworking.h>

#define APIADDR @"http://api.byr.cn"

#define APPKEY @"ff7504fa9d6a4975"
//#define AllBoards @"Advice|Announce|BBShelp|Bet|BM_Market|BYR10|Cooperation|ForumCommittee|ID|Progress|Score|sysop|test|BYR|BYRStar|Showcase|AimBUPT|ACETeam|BuptAssociation|BUPTMSTC|BUPTStudentUnion|BUPTSTV|BuptWeekly|ChineseOrchestra|GraduateUnion|OracleClub|Orchestra|Philharmonic|Redcross|SCDA|SICA|WOWBuptGuild|BUPT|BUPTNet|BUPTPost|BYR_Bulletin|CampusCard|daonian|EID|Focus|Graduation|Library|Recommend|School|Selfsupport|StudentAffairs|StudentQuery|BUPTNU|DMDA|GraduateSch|HongFu|INTR|IPOC|IS|SA|SCS|SEE|SEM|SH|SICE|SL|SIE|SS|SPM|SSE|STE|ACM_ICPC|BBSMan_Dev|Circuit|Communications|CPP|Database|dotNET|Economics|Embedded_System|HardWare|Innovation|Java|Linux|MathModel|Matlab|ML_DM|MobileInternet|MobileTerminalAT|Notebook|OfficeTool|Paper|SearchEngine|Security|SoftDesign|Windows|WWWTechnology|Ad_Agent|Advertising|BookTrade|BUPTDiscount|Co_Buying|ComputerTrade|Group_Buying|House|House_Agent|Ticket|AimGraduate|BNU|BUPT_Internet_Club|BYRatSH|BYRatSZ|Certification|CivilServant|Consulting|Entrepreneurship|Financial|FamilyLife|GoAbroad|Home|IT|Job|JobInfo|NetResources|Overseas|ParttimeJob|PMatBUPT|StudyShare|Weather|WorkLife|Astronomy|Debate|DV|EnglishBar|Ghost|Guitar|Humanity|Japanese|KoreanWind|Music|Photo|Poetry|PsyHealthOnline|Quyi|Reading|ScienceFiction|Tshirt|Beauty|Blessing|Clothing|Constellations|DigiLife|Environment|DIYLife|Feeling|Food|Friends|Health|LostandFound|Talking|AutoMotor|BoardGame|Comic|Flash|Hero|Joke|KaraOK|KillBar|Movie|NetLiterature|Pet|Picture|Plant|RadioOnline|Requirement|SuperStar|Travel|TV|VideoCool|Athletics|Badminton|Billiards|Basketball|Chess|Cycling|Dancing|Football|GSpeed|Gymnasium|Kungfu|Rugby|Shuttlecock|Sk8|Skating|Swim|Taekwondo|Tabletennis|Tennis|Volleyball|BUPTDNF|CStrike|Diablo|FootballManager|LOL|OnlineGame|PCGame|PopKart|StarCraft|TVGame|War3RPG|WarCraft|WE|WOW|Xyq"


@implementation BBSAPI

+ (NSArray *)searchTopics:(NSString *)key start:(NSInteger)start User:(User *)user BoardName:(NSString *)board {
    if (![BBSAPI isNetworkReachable] || start%50 != 0) {
        return nil;
    }
    
    NSMutableString * baseurl = [APIADDR mutableCopy];
    [baseurl appendString:@"/search/threads.json?"];
    [baseurl appendFormat:@"appkey=%@", APPKEY];
    [baseurl appendFormat:@"&board=%@", board];
    [baseurl appendFormat:@"&count=50&page=%i", start/50 + 1];
    [baseurl appendFormat:@"&title1=%@", [key URLEncodedString]];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:[MyBBS sharedInstance].username];
    [request setPassword:[MyBBS sharedInstance].password];
    [request setAllowCompressedResponse:YES];
    [request startSynchronous];
    NSData *feedback = [request responseData];
    if (feedback == nil) {
        return nil;
    }
    
    NSDictionary *topTenTopics = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    NSArray * Status = [JsonParseEngine parseSearchTopics:topTenTopics];
    if (Status == nil) {
        return nil;
    } else {
        return Status;
    }
}

+ (NSArray *)searchBoards:(NSString *)key User:(User *)user {
    if (![BBSAPI isNetworkReachable]) {
        return nil;
    }
    
    NSMutableString * baseurl = [APIADDR mutableCopy];
    [baseurl appendString:@"/search/board.json?"];
    [baseurl appendFormat:@"appkey=%@", APPKEY];
    [baseurl appendFormat:@"&board=%@", [key URLEncodedString]];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:[MyBBS sharedInstance].username];
[request setUsername:[MyBBS sharedInstance].username];
        [request setPassword:[MyBBS sharedInstance].password];
    [request setAllowCompressedResponse:YES];
    [request startSynchronous];
    
    NSData *feedback = [request responseData];
    if (feedback == nil) {
        return nil;
    }
    NSDictionary *topTenTopics = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    
    NSArray * Status = [JsonParseEngine parseBoards:topTenTopics];
    if (Status == nil) {
        return nil;
    } else {
        return Status;
    }
}

+ (User *)login:(NSString *)user Pass:(NSString *)pass {
    if (![BBSAPI isNetworkReachable]) {
        return nil;
    }
    
    NSMutableString * baseurl = [APIADDR mutableCopy];
    [baseurl appendString:@"/user/login.json?"];
    [baseurl appendFormat:@"appkey=%@", APPKEY];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:user];
    [request setPassword:pass];
    [request setAllowCompressedResponse:YES];
    [request startSynchronous];
    NSData *feedback = [request responseData];
    
    if (feedback == nil) {
        return nil;
    }
    NSDictionary *userDictionary = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    User * myself = [JsonParseEngine parseLogin:userDictionary];
    if (myself == nil) {
        return nil;
    } else {
        [MyBBS sharedInstance].username = user;
        [MyBBS sharedInstance].password = pass;
        return myself;
    }
}

+ (NSArray *)hotTopics {
    if(![BBSAPI isNetworkReachable]) {
        return nil;
    }
    
    NSMutableString * baseurl = [APIADDR mutableCopy];
    [baseurl appendString:@"/widget/recommend.json?"];
    [baseurl appendFormat:@"appkey=%@", APPKEY];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:[MyBBS sharedInstance].username];
    [request setPassword:[MyBBS sharedInstance].password];
    [request setAllowCompressedResponse:YES];
    [request startSynchronous];
    NSData *feedback = [request responseData];
    if (feedback == nil) {
        return nil;
    }
    
    NSDictionary *hotTopics = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    
    NSArray * Status = [JsonParseEngine parseTopics:hotTopics];
    if (Status == nil) {
        return nil;
    } else {
        return Status;
    }
}


+ (NSArray *)getBoards:(User *)user Section:(NSString *)section {
    if (![BBSAPI isNetworkReachable]) {
        return nil;
    }
    
    NSMutableString * baseurl = [APIADDR mutableCopy];
    if (section == nil) {
        [baseurl appendString:@"/section.json?"];
    } else {
        [baseurl appendFormat:@"/section/%@.json?", section];
    }
    [baseurl appendFormat:@"appkey=%@", APPKEY];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:[MyBBS sharedInstance].username];
    [request setPassword:[MyBBS sharedInstance].password];
    [request setAllowCompressedResponse:YES];
    [request startSynchronous];
    
    NSData *feedback = [request responseData];
    if (feedback == nil) {
        return nil;
    }
    
    NSDictionary *topTenTopics = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    NSArray * Status = [JsonParseEngine parseBoards:topTenTopics];
    if (Status == nil) {
        return nil;
    } else {
        return Status;
    }
    return nil;
}


+(BOOL)isFriend:(NSString *)token ID:(NSString *)ID
{
    if(![BBSAPI isNetworkReachable])
    {
        return false;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/friends/add.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",token];
    [baseurl appendFormat:@"&id=%@",ID];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    if (feedback == nil) {
        return FALSE;
    }
    NSDictionary *topTenTopics = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    
    
    int result = [[topTenTopics objectForKey:@"result"] intValue];
    if (result == -2) {
        return TRUE;
    }
    else {
        [BBSAPI deletFriend:nil ID:ID];
        return FALSE;
    }
    return FALSE;
}

+ (NSArray *)getMails:(User *)user Type:(int)type Start:(int)start {
    if (![BBSAPI isNetworkReachable] || start%50 != 0) {
        return nil;
    }
    
    NSString *typeString;
    switch (type) {
        case 0:
            typeString = @"inbox";
            break;
        case 1:
            typeString = @"outbox";
            break;
        case 2:
            typeString = @"deleted";
            break;
        default:
            break;
    }
    
    NSMutableString * baseurl = [APIADDR mutableCopy];
    [baseurl appendFormat:@"/mail/%@.json?", typeString];
    [baseurl appendFormat:@"appkey=%@", APPKEY];
    [baseurl appendFormat:@"&count=50&page=%i",start/50 + 1];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:[MyBBS sharedInstance].username];
    [request setPassword:[MyBBS sharedInstance].password];
    [request setAllowCompressedResponse:YES];
    [request startSynchronous];
    NSData *feedback = [request responseData];
    if (feedback == nil) {
        return nil;
    }
    NSDictionary *topTenTopics = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    
    
    NSArray * Status = [JsonParseEngine parseMails:topTenTopics Type:type];
    if (Status == nil) {
        return nil;
    }
    else {
        return Status;
    }
}

+ (Mail *)getSingleMail:(User *)user Type:(int)type ID:(int)ID {
    if(![BBSAPI isNetworkReachable])
    {
        return nil;
    }
    
    NSString *typeString;
    switch (type) {
        case 0:
            typeString = @"inbox";
            break;
        case 1:
            typeString = @"outbox";
            break;
        case 2:
            typeString = @"deleted";
            break;
        default:
            break;
    }
    
    NSMutableString * baseurl = [APIADDR mutableCopy];
    [baseurl appendFormat:@"/mail/%@/%i.json?", typeString, ID];
    [baseurl appendFormat:@"appkey=%@", APPKEY];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:[MyBBS sharedInstance].username];
    [request setPassword:[MyBBS sharedInstance].password];
    [request setAllowCompressedResponse:YES];
    [request startSynchronous];
    NSData *feedback = [request responseData];
    if (feedback == nil) {
        return nil;
    }
    
    NSDictionary *topTenTopics = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    Mail * Status = [JsonParseEngine parseSingleMail:topTenTopics Type:type];
    if (Status == nil) {
        return nil;
    } else {
        return Status;
    }
}

+ (BOOL)deleteSingleMail:(User *)user Type:(int)type ID:(int)ID {
    if (![BBSAPI isNetworkReachable]) {
        return false;
    }
    
    NSString *typeString;
    switch (type) {
        case 0:
            typeString = @"inbox";
            break;
        case 1:
            typeString = @"outbox";
            break;
        case 2:
            typeString = @"deleted";
            break;
        default:
            break;
    }
    
    NSMutableString * baseurl = [APIADDR mutableCopy];
    [baseurl appendFormat:@"/mail/%@/delete/%i.json?", typeString, ID];
    [baseurl appendFormat:@"appkey=%@", APPKEY];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:[MyBBS sharedInstance].username];
    [request setPassword:[MyBBS sharedInstance].password];
    [request setAllowCompressedResponse:YES];
    [request setRequestMethod:@"POST"];
    [request startSynchronous];
    NSData *feedback = [request responseData];
    
    if (feedback == nil) {
        return NO;
    }
    
    NSDictionary *topTenTopics = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    NSString * code = [topTenTopics objectForKey:@"code"];
    if (!code) {
        return true;
    }
    
    return false;
}

+(BOOL)postMail:(User *)myself User:(NSString *)user Title:(NSString *)title Content:(NSString *)content Reid:(int)reid
{
    if(![BBSAPI isNetworkReachable])
    {
        return false;
    }
    
    NSMutableString * baseurl = [APIADDR mutableCopy];
    [baseurl appendFormat:@"/mail/send.json?"];
    [baseurl appendFormat:@"appkey=%@", APPKEY];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUsername:[MyBBS sharedInstance].username];
    [request setPassword:[MyBBS sharedInstance].password];
    [request setAllowCompressedResponse:YES];
    [request setRequestMethod:@"POST"];

    [request setPostValue:user forKey:@"id"];
    [request setPostValue:[title URLEncodedString] forKey:@"title"];
    [request setPostValue:[content URLEncodedString] forKey:@"content"];
    [request setPostValue:@"1" forKey:@"backup"];
    [request startSynchronous];
    
    NSData *feedback = [request responseData];
    if (feedback == nil) {
        return NO;
    }
    NSDictionary *topTenTopics = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    BOOL success = [[topTenTopics objectForKey:@"status"] boolValue];
    if (success) {
        return YES;
    }
    return NO;
}
+(BOOL)replyMail:(User *)myself User:(NSString *)user Title:(NSString *)title Content:(NSString *)content Type:(int)type ID:(int)ID
{
    if(![BBSAPI isNetworkReachable])
    {
        return false;
    }
    
    NSString *typeString;
    switch (type) {
        case 0:
            typeString = @"inbox";
            break;
        case 1:
            typeString = @"outbox";
            break;
        case 2:
            typeString = @"deleted";
            break;
        default:
            break;
    }
    
    
    NSMutableString * baseurl = [APIADDR mutableCopy];
    [baseurl appendFormat:@"/mail/%@/reply/%i.json?", typeString, ID];
    [baseurl appendFormat:@"appkey=%@", APPKEY];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUsername:[MyBBS sharedInstance].username];
    [request setPassword:[MyBBS sharedInstance].password];
    [request setAllowCompressedResponse:YES];
    [request setRequestMethod:@"POST"];
    
    [request setPostValue:user forKey:@"id"];
    [request setPostValue:[title URLEncodedString] forKey:@"title"];
    [request setPostValue:[content URLEncodedString] forKey:@"content"];
    [request setPostValue:@"1" forKey:@"backup"];
    [request startSynchronous];
    
    NSData *feedback = [request responseData];
    if (feedback == nil) {
        return NO;
    }
    NSDictionary *topTenTopics = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    NSString * code = [topTenTopics objectForKey:@"code"];
    if (!code)
        return YES;

    return NO;
}

+(int)getNotificationCount:(User *)user Type:(NSString *)type
{
    NSMutableString * baseurl = [APIADDR mutableCopy];
    [baseurl appendFormat:@"/refer/%@/info.json?", type];
    [baseurl appendFormat:@"appkey=%@", APPKEY];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:[MyBBS sharedInstance].username];
    [request setPassword:[MyBBS sharedInstance].password];
    [request setAllowCompressedResponse:YES];
    [request startSynchronous];
    NSData *feedback = [request responseData];
    
    if (feedback == nil) {
        return 0;
    }
    NSDictionary *topTenTopics = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    
    return [[topTenTopics objectForKey:@"new_count"] intValue];
}

+(Notification *)getAllNotificationCount:(User *)user
{
    int at = [BBSAPI getNotificationCount:user Type:@"at"];
    int reply = [BBSAPI getNotificationCount:user Type:@"reply"];
    Notification *notification = [[Notification alloc] init];
    notification.atCount = at;
    notification.replyCount = reply;
    return notification;
}

+(NSArray *)getNotification:(User *)user Type:(NSString *)type Start:(NSInteger)start Limit:(NSInteger)limit;
{
    if(![BBSAPI isNetworkReachable] || start%limit != 0)
    {
        return nil;
    }
    
    NSMutableString * baseurl = [APIADDR mutableCopy];
    [baseurl appendFormat:@"/refer/%@.json?", type];
    [baseurl appendFormat:@"appkey=%@", APPKEY];
    [baseurl appendFormat:@"&count=%i", limit];
    [baseurl appendFormat:@"&page=%i", start/limit + 1];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:[MyBBS sharedInstance].username];
    [request setPassword:[MyBBS sharedInstance].password];
    [request setAllowCompressedResponse:YES];
    [request startSynchronous];
    NSData *feedback = [request responseData];
    if (feedback == nil) {
        return nil;
    }
    NSDictionary *topTenTopics = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    
    NSArray * Status = [JsonParseEngine parseTopics:topTenTopics];
    if (Status == nil) {
        return nil;
    }
    else {
        return Status;
    }
}

+(BOOL)deleteNotification:(User *)user Type:(NSString *)type ID:(int)ID
{
    NSMutableString * baseurl = [APIADDR mutableCopy];
    [baseurl appendFormat:@"/refer/%@/setRead/%i.json?", type, ID];
    [baseurl appendFormat:@"appkey=%@", APPKEY];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:[MyBBS sharedInstance].username];
    [request setPassword:[MyBBS sharedInstance].password];
    [request setAllowCompressedResponse:YES];
    [request setRequestMethod:@"POST"];
    [request startSynchronous];
    NSData *feedback = [request responseData];
    NSDictionary *topTenTopics = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    return [[topTenTopics objectForKey:@"status"] boolValue];
}


+(BOOL)clearNotificationForType:(NSString *)type User:(User *)user
{
    NSMutableString * baseurl = [APIADDR mutableCopy];
    [baseurl appendFormat:@"/refer/%@/setRead.json?", type];
    [baseurl appendFormat:@"appkey=%@", APPKEY];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:[MyBBS sharedInstance].username];
    [request setPassword:[MyBBS sharedInstance].password];
    [request setAllowCompressedResponse:YES];
    [request setRequestMethod:@"POST"];
    [request startSynchronous];
    NSData *feedback = [request responseData];

    NSDictionary *topTenTopics = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    return [[topTenTopics objectForKey:@"status"] boolValue];
}

+(BOOL)clearNotification:(User *)user
{
    BOOL at = [BBSAPI clearNotificationForType:@"at" User:user];
    BOOL reply = [BBSAPI clearNotificationForType:@"reply" User:user];

    return at&&reply;
}

+(NSArray *)replyTopic:(NSString *)board ID:(int)ID Start:(NSInteger)start User:(User *)user
{
    if(![BBSAPI isNetworkReachable])
    {
        return nil;
    }
    
    NSMutableString * baseurl = [APIADDR mutableCopy];
    [baseurl appendFormat:@"/article/%@/%i.json?", board, ID];
    [baseurl appendFormat:@"appkey=%@", APPKEY];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:[MyBBS sharedInstance].username];
    [request setPassword:[MyBBS sharedInstance].password];
    [request setAllowCompressedResponse:YES];
    [request startSynchronous];
    NSData *feedback = [request responseData];

    if (feedback == nil) {
        return nil;
    }
    NSDictionary *singleTopic = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    NSArray * Status = [JsonParseEngine parseReplyTopic:singleTopic];
    if (Status == nil) {
        return nil;
    }
    else {
        return Status;
    }
}


+(NSArray *)singleTopic:(NSString *)board ID:(int)ID Page:(NSInteger)page User:(User *)user
{
    if(![BBSAPI isNetworkReachable])
    {
        return nil;
    }
    
    NSMutableString * baseurl = [APIADDR mutableCopy];
    [baseurl appendFormat:@"/threads/%@/%i.json?", board, ID];
    [baseurl appendFormat:@"appkey=%@", APPKEY];
    [baseurl appendFormat:@"&page=%i&count=20", page];

    NSURL *url = [NSURL URLWithString:baseurl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:[MyBBS sharedInstance].username];
    [request setPassword:[MyBBS sharedInstance].password];
    [request setAllowCompressedResponse:YES];
    [request startSynchronous];
    NSData *feedback = [request responseData];
    
    if (feedback == nil) {
        return nil;
    }
    NSDictionary *singleTopic = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    NSArray * Status = [JsonParseEngine parseSingleTopic:singleTopic];
    if (Status == nil) {
        return nil;
    }
    else {
        return Status;
    }
}


+ (User *)userInfo:(NSString *)userID {
    if (![BBSAPI isNetworkReachable]) {
        return nil;
    }
    
    NSMutableString * baseurl = [APIADDR mutableCopy];
    [baseurl appendFormat:@"/user/query/%@.json?", userID];
    [baseurl appendFormat:@"appkey=%@", APPKEY];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [request setUsername:[MyBBS sharedInstance].username];
        [request setPassword:[MyBBS sharedInstance].password];
    
    [request setAllowCompressedResponse:YES];
    [request startSynchronous];
    NSData *feedback = [request responseData];

    if (feedback == nil) {
        return nil;
    }
    NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    User * Status = [JsonParseEngine parseUserInfo:userInfo];
    if (Status == nil) {
        return nil;
    } else {
        return Status;
    }
}


+ (BOOL)editTopic:(User *)user Board:(NSString *)board Title:(NSString *)title Content:(NSString *)content Reid:(int)reid
{
    if (![BBSAPI isNetworkReachable]) {
        return false;
    }
    
    NSMutableString * baseurl = [APIADDR mutableCopy];
    [baseurl appendFormat:@"/article/%@/update/%i.json?", board, reid];
    [baseurl appendFormat:@"appkey=%@", APPKEY];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUsername:[MyBBS sharedInstance].username];
[request setUsername:[MyBBS sharedInstance].username];
        [request setPassword:[MyBBS sharedInstance].password];
    [request setAllowCompressedResponse:YES];
    [request setRequestMethod:@"POST"];
    [request setPostValue:[NSString stringWithFormat:@"%i", reid] forKey:@"reid"];
    [request setPostValue:[title URLEncodedString] forKey:@"title"];
    [request setPostValue:[content URLEncodedString] forKey:@"content"];
    [request startSynchronous];
    
    NSData *feedback = [request responseData];
    if (feedback == nil) {
        return NO;
    }
    NSDictionary *topTenTopics = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    NSString * code = [topTenTopics objectForKey:@"code"];
    if (!code)
        return YES;
    
    return NO;
}

+(BOOL)postTopic:(User *)user Board:(NSString *)board Title:(NSString *)title Content:(NSString *)content Reid:(int)reid
{
    if(![BBSAPI isNetworkReachable])
    {
        return false;
    }
    
    NSMutableString * baseurl = [APIADDR mutableCopy];
    [baseurl appendFormat:@"/article/%@/post.json?", board];
    [baseurl appendFormat:@"appkey=%@", APPKEY];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if (user == nil) {
        [request setUsername:@"guest"];
        [request setPassword:@""];
    }
    else {
        [request setUsername:[MyBBS sharedInstance].username];
        [request setPassword:[MyBBS sharedInstance].password];
    }
    [request setAllowCompressedResponse:YES];
    [request setRequestMethod:@"POST"];
    
    if (reid != 0) {
        [request setPostValue:[NSString stringWithFormat:@"%i", reid] forKey:@"reid"];
    }
    [request setPostValue:[title URLEncodedString] forKey:@"title"];
    [request setPostValue:[content URLEncodedString] forKey:@"content"];
    [request startSynchronous];
    
    NSData *feedback = [request responseData];
    if (feedback == nil) {
        return NO;
    }
    NSDictionary *topTenTopics = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    NSString * code = [topTenTopics objectForKey:@"code"];
    if (!code)
        return YES;
    
    return NO;
}


+(NSArray* )postImage:(User *)user Board:(NSString *)board ID:(int)ID Image:(UIImage *)image ImageName:(NSString *)imageName
{
    if(![BBSAPI isNetworkReachable])
    {
        return nil;
    }
    
    NSMutableString * baseurl = [APIADDR mutableCopy];
    if (ID != 0) {
        [baseurl appendFormat:@"/attachment/%@/add/%i.json?", board, ID];
    }
    else {
        [baseurl appendFormat:@"/attachment/%@/add.json?", board];
    }

    [baseurl appendFormat:@"appkey=%@", APPKEY];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [request setUsername:[MyBBS sharedInstance].username];
        [request setPassword:[MyBBS sharedInstance].password];
    
    [request setAllowCompressedResponse:YES];
    [request setRequestMethod:@"POST"];
    NSData *data =UIImageJPEGRepresentation(image, 0.5);
    [request addData:data withFileName:imageName andContentType:@"image/jpeg" forKey:@"file"];
    [request startSynchronous];
    
    NSData *feedback = [request responseData];
    if (feedback == nil) {
        return nil;
    }
    NSDictionary *attDic = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    NSArray *attArray=[JsonParseEngine parseAttachments:attDic];
    if (attArray!=nil) {
        return attArray;
    } else {
        return nil;
    }
}


+ (void)utfAppendBody:(NSMutableData *)body data:(NSString *)data {
	[body appendData:[data dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSArray* )deleteAttachmentsFromTopic:(User *)user Board:(NSString *)board ID:(int)ID Name:(NSString *)name
{
    if (![BBSAPI isNetworkReachable]) {
        return nil;
    }
    
    NSMutableString * baseurl = [APIADDR mutableCopy];
    if (ID != 0) {
        [baseurl appendFormat:@"/attachment/%@/delete/%i.json?", board, ID];
    } else {
        [baseurl appendFormat:@"/attachment/%@/delete.json?", board];
    }
    
    [baseurl appendFormat:@"appkey=%@", APPKEY];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUsername:[MyBBS sharedInstance].username];
[request setUsername:[MyBBS sharedInstance].username];
        [request setPassword:[MyBBS sharedInstance].password];
    [request setAllowCompressedResponse:YES];
    [request setRequestMethod:@"POST"];
    [request setPostValue:[name URLEncodedString] forKey:@"name"];
    [request startSynchronous];
    
    NSData *feedback = [request responseData];
    if (feedback == nil) {
        return nil;
    }
    
    NSDictionary *attDic = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    NSArray *attArray=[JsonParseEngine parseAttachments:attDic];
    if (attArray!=nil) {
        return attArray;
    } else {
        return nil;
    }
}

+ (NSArray* )getAttachmentsFromTopic:(User *)user Board:(NSString *)board ID:(int)ID
{
    if (![BBSAPI isNetworkReachable]) {
        return nil;
    }
    
    NSMutableString * baseurl = [APIADDR mutableCopy];
    if (ID != 0) {
        [baseurl appendFormat:@"/attachment/%@/%i.json?", board, ID];
    } else {
       [baseurl appendFormat:@"/attachment/%@.json?", board];
    }

    [baseurl appendFormat:@"appkey=%@", APPKEY];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUsername:[MyBBS sharedInstance].username];
[request setUsername:[MyBBS sharedInstance].username];
        [request setPassword:[MyBBS sharedInstance].password];
    [request setAllowCompressedResponse:YES];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    
    NSData *feedback = [request responseData];
    if (feedback == nil) {
        return nil;
    }
    NSDictionary *attDic = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    NSArray *attArray=[JsonParseEngine parseAttachments:attDic];
    if (attArray!=nil) {
        return attArray;
    } else {
        return nil;
    }
}

+(BOOL)isNetworkReachable{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    
    if (!(isReachable && !needsConnection)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        });
    }
    return (isReachable && !needsConnection) ? YES : NO;
}

+ (NSString *)dateToString:(NSDate *)date;
{
    NSMutableString * dateString = [[NSMutableString alloc] init];
    
    
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents;
    dateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    
    NSDateComponents *todayComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:today];
    
    if (dateComponents.year == todayComponents.year && dateComponents.month == todayComponents.month && dateComponents.day == todayComponents.day) {
        
        [dateString  appendString:@""];
        
    } else if ((dateComponents.year == todayComponents.year) && (dateComponents.month == todayComponents.month) && (dateComponents.day == todayComponents.day - 1)) {
        
        [dateString  appendString:@"昨天  "];
        
    } else if ((dateComponents.year == todayComponents.year) && (dateComponents.weekOfYear == todayComponents.weekOfYear)) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"cccc";
        NSArray * array = [NSArray arrayWithObjects:@"开始", @"天", @"一", @"二", @"三", @"四", @"五", @"六", nil];
        [dateString  appendString:[NSString stringWithFormat:@"星期%@  ", [array objectAtIndex:dateComponents.weekday]]];
        
    } else if (dateComponents.year == todayComponents.year) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM-dd";
        if ([dateFormatter stringFromDate:date] != nil) {
            [dateString  appendString:[NSString stringWithFormat:@"%@  ", [dateFormatter stringFromDate:date]]];
        }
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        if ([dateFormatter stringFromDate:date] != nil) {
            [dateString  appendString:[NSString stringWithFormat:@"%@  ", [dateFormatter stringFromDate:date]]];
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    if ([dateFormatter stringFromDate:date] != nil) {
        [dateString  appendString:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]]];
    }
    
    return dateString;
}

+(NSArray *)singleTopic:(NSString *)board ID:(int)ID
{
    if(![BBSAPI isNetworkReachable])
    {
        return nil;
    }
    
    NSMutableString * baseurl = [APIADDR mutableCopy];
    [baseurl appendFormat:@"/threads/%@/%i.json?", board, ID];
    [baseurl appendFormat:@"appkey=%@", APPKEY];
    [baseurl appendFormat:@"&page=1&count=1"];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:[MyBBS sharedInstance].username];
    [request setPassword:[MyBBS sharedInstance].password];
    [request setAllowCompressedResponse:YES];
    [request startSynchronous];
    NSData *feedback = [request responseData];

    if (feedback == nil) {
        return nil;
    }
    NSDictionary *singleTopic = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    NSArray * Status = [JsonParseEngine parseSingleTopic:singleTopic];
    if (Status == nil) {
        return nil;
    }
    else {
        return Status;
    }
}

+(NSArray *)getVoteList:(User *)user Type:(NSString *)type   ///type: me|join|list|new|hot|all
{
    if (![BBSAPI isNetworkReachable]) {
        return nil;
    }
    
    NSMutableString * baseurl = [APIADDR mutableCopy];
    [baseurl appendFormat:@"/vote/category/%@.json?", type];
    [baseurl appendFormat:@"appkey=%@", APPKEY];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:[MyBBS sharedInstance].username];
    [request setPassword:[MyBBS sharedInstance].password];
    [request setAllowCompressedResponse:YES];
    [request startSynchronous];
    
    NSData *feedback = [request responseData];
    
    if (feedback == nil) {
        return nil;
    }
    
    NSDictionary *singleTopic = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    NSArray * Status = [JsonParseEngine parseVoteList:singleTopic];
    if (Status == nil) {
        return nil;
    } else {
        return Status;
    }
}


+ (Vote *)getSingleVote:(User *)user ID:(int)ID {
    if (![BBSAPI isNetworkReachable]) {
        return nil;
    }
    
    NSMutableString * baseurl = [APIADDR mutableCopy];
    [baseurl appendFormat:@"/vote/%i.json?", ID];
    [baseurl appendFormat:@"appkey=%@", APPKEY];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:[MyBBS sharedInstance].username];
    [request setPassword:[MyBBS sharedInstance].password];
    [request setAllowCompressedResponse:YES];
    [request startSynchronous];
    NSData *feedback = [request responseData];
    
    if (feedback == nil) {
        return nil;
    }
    NSDictionary *singleVote = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    Vote *vote = [JsonParseEngine parseSingleVote:singleVote];
    if (vote == nil) {
        return nil;
    }
    else {
        return vote;
    }
}

+(Vote *)doVote:(User *)user ID:(int)ID VoteArray:(NSArray *)voteArray
{
    if(![BBSAPI isNetworkReachable])
    {
        return nil;
    }
    
    NSMutableString * baseurl = [APIADDR mutableCopy];
    [baseurl appendFormat:@"/vote/%i.json?", ID];
    [baseurl appendFormat:@"appkey=%@", APPKEY];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUsername:[MyBBS sharedInstance].username];
    [request setPassword:[MyBBS sharedInstance].password];
    [request setAllowCompressedResponse:YES];
    [request setRequestMethod:@"POST"];
    
    if ([voteArray count] == 1) {
        NSString *vote = [voteArray objectAtIndex:0];
        [request setPostValue:[vote URLEncodedString] forKey:@"vote"];
    }
    else if ([voteArray count] > 1){
        for (NSString *vote in voteArray)
            [request addPostValue:vote forKey:@"vote[]"];
    }
    
    [request startSynchronous];
    NSData *feedback = [request responseData];
    
    if (feedback == nil) {
        return nil;
    }
    NSDictionary *singleVote = [NSJSONSerialization JSONObjectWithData:feedback options:kNilOptions error:nil];
    Vote *returnVote = [JsonParseEngine parseSingleVote:singleVote];
    if (returnVote == nil) {
        return nil;
    }
    else {
        return returnVote;
    }
}
@end





