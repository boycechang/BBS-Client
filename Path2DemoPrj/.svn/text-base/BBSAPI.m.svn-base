//
//  BBSAPI.m
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 4/28/12.
//  Copyright (c) 2012 Ethan. All rights reserved.
//

#import "BBSAPI.h"

@implementation BBSAPI

+(NSArray *)searchTopics:(NSString *)key start:(NSString *)start Token:(NSString*)token
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/search/topics.json?" mutableCopy];
    [baseurl appendFormat:@"keys=%@",[key URLEncodedString]];
    [baseurl appendFormat:@"&limit=30&start=%@", start];
    if (token != nil) {
        [baseurl appendFormat:@"&token=%@", token];
    }
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    
    
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    NSArray * Status = [JsonParseEngine parseSearchTopics:topTenTopics];
    if (Status == nil) {
        return nil;
    }
    else {
        return Status;
    }
}

+(NSArray *)searchBoards:(NSString *)key Token:(NSString*)token
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/search/boards.json?" mutableCopy];
    [baseurl appendFormat:@"name=%@", [key URLEncodedString]];
    if (token != nil) {
        [baseurl appendFormat:@"&token=%@", token];
    }
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    
    NSArray * Status = [JsonParseEngine parseBoards:topTenTopics];
    if (Status == nil) {
        return nil;
    }
    else {
        return Status;
    }
}


+(User *)login:(NSString *)user Pass:(NSString *)pass
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/token.json?" mutableCopy];
    [baseurl appendFormat:@"user=%@", user];
    [baseurl appendFormat:@"&pass=%@",pass];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    
    User * Status = [JsonParseEngine parseLogin:topTenTopics];
    if (Status == nil) {
        return nil;
    }
    else {
        return Status;
    }
}


+(NSArray *)topTen
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
    
    NSString *baseurl= @"http://bbs.seu.edu.cn/api/hot/topten.json";
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    NSArray * Status = [JsonParseEngine parseTopics:topTenTopics];
    if (Status == nil) {
        return nil;
    }
    else {
        return Status;
    }
}

+(NSArray *)sectionTopTen:(int)sectionNumber
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
    
    NSMutableString *baseurl= [@"http://bbs.seu.edu.cn/api/hot/section.json?" mutableCopy];
    [baseurl appendFormat:@"section=%i", sectionNumber];
    
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    NSArray * Status = [JsonParseEngine parseTopics:topTenTopics];
    if (Status == nil) {
        return nil;
    }
    else {
        return Status;
    }
}

+(NSArray *)hotBoards
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
    
    NSString *baseurl= @"http://bbs.seu.edu.cn/api/hot/boards.json";
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    NSArray * Status = [JsonParseEngine parseBoards:topTenTopics];
    if (Status == nil) {
        return nil;
    }
    else {
        return Status;
    }
}

+(NSArray *)offlineDataToAllSections:(NSData *)data
{
    NSDictionary *topTenTopics = [data objectFromJSONData];
    NSArray * Status = [JsonParseEngine parseSections:topTenTopics];
    if (Status == nil) {
        return nil;
    }
    else {
        return Status;
    }
}

+(NSData *)allSectionsData:(NSString*)token;
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/sections.json?" mutableCopy];
    if (token != nil) {
        [baseurl appendFormat:@"token=%@", token];
    }
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    return feedback;
}

+(NSArray *)allFavSections:(NSString *)token
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/fav/get.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@", token];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    
    NSArray * Status = [JsonParseEngine parseSections:topTenTopics];
    if (Status == nil) {
        return nil;
    }
    else {
        return Status;
    }
}

+(NSArray *)onlineFriends:(NSString *)token
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/friends.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@", token];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    
    NSArray * Status = [JsonParseEngine parseFriends:topTenTopics];
    if (Status == nil) {
        return nil;
    }
    else {
        return Status;
    }
}

+(NSArray *)allFriends:(NSString *)token
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/friends/all.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@", token];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    NSLog(@"%@",[[NSString alloc] initWithData:feedback encoding:NSUTF8StringEncoding]);
    NSArray * Status = [JsonParseEngine parseFriends:topTenTopics];
    if (Status == nil) {
        return nil;
    }
    else {
        return Status;
    }
}

+(BOOL)deletFriend:(NSString *)token ID:(NSString *)ID
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/friends/delete.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",token];
    [baseurl appendFormat:@"&id=%@",ID];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    
    BOOL success = [[topTenTopics objectForKey:@"success"] boolValue];
    return success;
}
+(BOOL)addFriend:(NSString *)token ID:(NSString *)ID
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/friends/add.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@", token];
    [baseurl appendFormat:@"&id=%@",ID];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    
    int result = [[topTenTopics objectForKey:@"result"] intValue];
    BOOL success = NO;
    if (result == 0) {
        success = YES;
    }
    return success;
}
+(BOOL)addFavBoard:(NSString *)token BoardName:(NSString *)BoardName
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/fav/add.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@", token];
    [baseurl appendFormat:@"&bname=%@",BoardName];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    if ([topTenTopics objectForKey:@"result"] == [NSNull null]) {
        return YES;
    }
    
    int result = [[topTenTopics objectForKey:@"result"] intValue];
    BOOL success = NO;
    if (result == 0) {
        success = YES;
    }
    return success;
}
+(BOOL)addFavDirect:(NSString *)token DirectName:(NSString *)DirectName
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/fav/add.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@", token];
    [baseurl appendFormat:@"&dname=%@",DirectName];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    int result = [[topTenTopics objectForKey:@"result"] intValue];
    BOOL success = NO;
    if (result == 0) {
        success = YES;
    }
    return success;
}

+(BOOL)isFriend:(NSString *)token ID:(NSString *)ID
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/friends/add.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",token];
    [baseurl appendFormat:@"&id=%@",ID];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    
    int result = [[topTenTopics objectForKey:@"result"] intValue];
    if (result == -2) {
        return TRUE;
    }
    else {
        [BBSAPI deletFriend:token ID:ID];
        return FALSE;
    }
    return FALSE;
}
+(NSArray *)getMails:(NSString *)token Type:(int)type Start:(int)start
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/mailbox/get.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",token];
    [baseurl appendFormat:@"&type=%i",type];
    [baseurl appendFormat:@"&limit=30&start=%i",start];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    
    NSArray * Status = [JsonParseEngine parseMails:topTenTopics Type:type];
    if (Status == nil) {
        return nil;
    }
    else {
        return Status;
    }
}

+(Mail *)getSingleMail:(NSString *)token Type:(int)type ID:(int)ID
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/mail/get.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",token];
    [baseurl appendFormat:@"&type=%i",type];
    [baseurl appendFormat:@"&id=%i",ID];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    
    Mail * Status = [JsonParseEngine parseSingleMail:topTenTopics Type:type];
    if (Status == nil) {
        return nil;
    }
    else {
        return Status;
    }
}
+(BOOL)deleteSingleMail:(NSString *)token Type:(int)type ID:(int)ID
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/mail/delete.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",token];
    [baseurl appendFormat:@"&type=%i",type];
    [baseurl appendFormat:@"&id=%i",ID];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    
    
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    BOOL success = [[topTenTopics objectForKey:@"success"] boolValue];
    return success;
}
+(BOOL)postMail:(NSString *)token User:(NSString *)user Title:(NSString *)title Content:(NSString *)content Reid:(int)reid
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/mail/send.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",token];
    [baseurl appendFormat:@"&user=%@",user];
    [baseurl appendFormat:@"&title=%@",[title URLEncodedString]];
    [baseurl appendFormat:@"&content=%@",[content URLEncodedString]];
    [baseurl appendFormat:@"&reid=%i",reid];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    
    
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    BOOL success = [[topTenTopics objectForKey:@"success"] boolValue];
    if (success) {
        int result = [[topTenTopics objectForKey:@"result"] intValue];
        if (result == 0) {
            return YES;
        }
        else {
            return NO;
        }
    }
    return NO;
}


+(Notification *)getNotification:(NSString *)token
{
    /*
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
     */
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/notifications.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",token];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    
    Notification * Status = [JsonParseEngine parseNotification:topTenTopics];
    if (Status == nil) {
        return nil;
    }
    else {
        return Status;
    }
}
+(BOOL)clearNotification:(NSString *)token
{
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/clear_notifications.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",token];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    
    
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    BOOL success = [[topTenTopics objectForKey:@"success"] boolValue];
    return success;
}

+(NSArray *)boardTopics:(NSString *)board Start:(int)start Token:(NSString*)token Mode:(int)mode
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/" mutableCopy];
    [baseurl appendFormat:@"board/%@.json?", board];
    [baseurl appendFormat:@"mode=%d&limit=30&start=%i", mode,start];
    if (token != nil) {
        [baseurl appendFormat:@"&token=%@", token];
    }
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    
    NSArray * Status = [JsonParseEngine parseTopics:topTenTopics];
    if (Status == nil) {
        return nil;
    }
    else {
        return Status;
    }
}

+(NSArray *)singleTopic:(NSString *)board ID:(int)ID Start:(int)start Token:(NSString*)token
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/topic/" mutableCopy];
    [baseurl appendFormat:@"/%@",board];
    [baseurl appendFormat:@"/%i.json?start=%i&limit=30",ID,start];
    if (token != nil) {
        [baseurl appendFormat:@"&token=%@", token];
    }
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    

    NSDictionary *singleTopic = [feedback objectFromJSONData];
    NSArray * Status = [JsonParseEngine parseSingleTopic:singleTopic];
    if (Status == nil) {
        return nil;
    }
    else {
        return Status;
    }
}
+(User *)userInfo:(NSString *)userID
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/user/" mutableCopy];
    [baseurl appendFormat:@"%@.json",userID];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    
    
    NSDictionary *singleTopic = [feedback objectFromJSONData];
    User * Status = [JsonParseEngine parseUserInfo:singleTopic];
    if (Status == nil) {
        return nil;
    }
    else {
        return Status;
    }
}




+(BOOL)editTopic:(NSString *)token Board:(NSString *)board Title:(NSString *)title Content:(NSString *)content Reid:(int)reid
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/topic/edit.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",token];
    [baseurl appendFormat:@"&board=%@",board];
    [baseurl appendFormat:@"&title=%@",[title URLEncodedString]];
    [baseurl appendFormat:@"&content=%@",[content URLEncodedString]];
    [baseurl appendFormat:@"&id=%i",reid];
    [baseurl appendFormat:@"&type=%i",3];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    
    BOOL success = [[topTenTopics objectForKey:@"success"] boolValue];
    return success;
}

+(BOOL)postTopic:(NSString *)token Board:(NSString *)board Title:(NSString *)title Content:(NSString *)content Reid:(int)reid
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/topic/post.json?" mutableCopy];
    [baseurl appendFormat:@"token=%@",token];
    [baseurl appendFormat:@"&board=%@",board];
    [baseurl appendFormat:@"&title=%@",[title URLEncodedString]];
    [baseurl appendFormat:@"&content=%@",[content URLEncodedString]];
    [baseurl appendFormat:@"&reid=%i",reid];
    [baseurl appendFormat:@"&type=%i",3];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *topTenTopics = [feedback objectFromJSONData];
    
    NSLog(@"%@",[[NSString alloc] initWithData:feedback encoding:NSUTF8StringEncoding]);
    BOOL success = [[topTenTopics objectForKey:@"success"] boolValue];
    return success;
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
    return (isReachable && !needsConnection) ? YES : NO;
}

//+(NSArray *)postImageto:(NSURL *)url withImage:(UIImage *)img andToken:(NSString *)token
//{
//    if(![BBSAPI isNetworkReachable])
//    {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
//        [alert show];
//        return nil;
//    }
//    
//    //NSMutableURLRequest *myRequest=[NSMutableURLRequest requestWithURL:url];//创建一个指向目的网站的请求
//    NSData *imageData=UIImageJPEGRepresentation(img, 90);//一个图片数据
//    
//    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] init];//创建请求
//    [request setURL:url];
//    
//    NSString *boundary=@"0xKhTmLbOuNdArY";
//    NSString *contentType=[NSString stringWithFormat:@"multipart/form-data;boundary=%@",boundary];//定义表格数据
//    
//    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];//定义内容类型
//    
//    [request setHTTPMethod:@"POST"];//方法为post
//    
//    NSMutableData *body=[NSMutableData data];
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];//字段开始
//    
//    [body appendData:[@"Content-Disposition:form-data; name=\"file\"\r\n\r\n\"up.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];//定义名称<input type="file" name="file">
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"Content-Disposition:form-data; name=\"file\" filename=\"up.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"Content-Type:image/jpeg\r\nContent-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    //这一句很重要，说明了我们接下来要上传的是图片
//    [body appendData:imageData];//将图片数据加载进去
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary]dataUsingEncoding:NSUTF8StringEncoding]];//结束
//    
//    [request setHTTPBody:body];
//    
//    NSURLResponse *response;
//    
//    NSData *returnData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
//    //NSString *returnString=[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//    NSDictionary *attDic = [returnData objectFromJSONData];
//    NSArray * attArray=[JsonParseEngine parseAttachments:attDic];
//    //NSLog(@"%@",[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding]);
//    if (attArray!=nil) {
//        return attArray;
//    }
//    else
//    {
//        return nil;
//    }
//
//}



+(NSArray* )postImg:(NSString *)string Image:(UIImage *)image toUrl:(NSURL *)url
{
 
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
    NSString *kStringBoundary=@"0xKhTmLbOuNdArY";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:2000];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", kStringBoundary] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    NSString *bodyPrefixString   = [NSString stringWithFormat:@"--%@\r\n", kStringBoundary];
    NSString *bodySuffixString   = [NSString stringWithFormat:@"\r\n--%@--\r\n", kStringBoundary];
    
    [self utfAppendBody:body data:bodyPrefixString];
    
    [self utfAppendBody:body data:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",@"status",string]];
    
	[self utfAppendBody:body data:bodyPrefixString];
    
    [self utfAppendBody:body data:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",@"file",@"pic.png"]];
    
	[self utfAppendBody:body data:bodyPrefixString];
    NSData* imageData;
    if ([[[string substringFromIndex:37] lowercaseString]isEqual:@"png"]) {
        NSLog(@"png");
        imageData = UIImagePNGRepresentation((UIImage*)image);
    }
    else if ([[[string substringFromIndex:37] lowercaseString]isEqual:@"jpg"])
    {
        NSLog(@"jpg");
        imageData = UIImageJPEGRepresentation(image, 0.8);
    }
    else if ([[[string substringFromIndex:37] lowercaseString]isEqual:@"jpeg"])
    {
        NSLog(@"jpeg");
        imageData = UIImageJPEGRepresentation(image, 0.8);
    }
    else
    {//其他图片会转换为png
        NSLog(@"else as png");
        imageData = UIImagePNGRepresentation((UIImage*)image);
    }
    
    
    
    [self utfAppendBody:body data:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", @"file", string]];
    if ([[[string substringFromIndex:37] lowercaseString]isEqual:@"png"]) {
        [self utfAppendBody:body data:@"Content-Type: image/png\r\nContent-Transfer-Encoding: binary\r\n\r\n"];
    }
    else if ([[[string substringFromIndex:37] lowercaseString]isEqual:@"jpg"])
    {
        [self utfAppendBody:body data:@"Content-Type: image/jpeg\r\nContent-Transfer-Encoding: binary\r\n\r\n"];
    }
    else
    {
        [self utfAppendBody:body data:@"Content-Type: image/gif\r\nContent-Transfer-Encoding: binary\r\n\r\n"];
    }
    
    [body appendData:imageData];
    
    [self utfAppendBody:body data:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", @"status"]];
    [self utfAppendBody:body data:@"Content-Type: content/unknown\r\nContent-Transfer-Encoding: binary\r\n\r\n"];
    [body appendData:(NSData*)[string dataUsingEncoding:NSUTF8StringEncoding]];
    [self utfAppendBody:body data:bodySuffixString];
    
    [request setHTTPBody:body];
    NSData* returnData =  [NSURLConnection sendSynchronousRequest:request
                                              returningResponse:nil error:nil];
    NSDictionary *attDic = [returnData objectFromJSONData];
    NSArray * attArray=[JsonParseEngine parseAttachments:attDic];
    
    if (attArray!=nil) {
        return attArray;
    }
    else
    {
        return nil;
    }

}


+(void)utfAppendBody:(NSMutableData *)body data:(NSString *)data {
	[body appendData:[data dataUsingEncoding:NSUTF8StringEncoding]];
}

+(NSArray*)delImg:(NSURL *)url
{
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *attDic = [feedback objectFromJSONData];
    NSArray *attArray=[JsonParseEngine parseAttachments:attDic];
    if (attArray!=nil) {
        return attArray;
    }
    else
    {
        return nil;
    }
}

+(NSArray *)getAttachmentsFromTopic:(int)topicId andBoard:(NSString *)boardId token:(NSString *)token
{//topicId<=-1 means new post!!!
    if(![BBSAPI isNetworkReachable])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
    NSMutableString * baseurl = [@"http://bbs.seu.edu.cn/api/" mutableCopy];
    [baseurl appendFormat:@"attachments.js"];
    if (boardId!=nil && topicId>-1 && token!=nil) {
        [baseurl appendFormat:@"?board=%@&id=%d&token=%@",boardId,topicId,token];
    }
    else if(boardId==nil)
    {//new post
        [baseurl appendFormat:@"?token=%@",token];
    }
    else
    {
        return nil;
    }
    NSURL *url = [NSURL URLWithString:baseurl];
    NSData * feedback = [NSData dataWithContentsOfURL:url];
    NSDictionary *attDic = [feedback objectFromJSONData];
    NSArray *attArray=[JsonParseEngine parseAttachments:attDic];
    if (attArray!=nil) {
        return attArray;
    }
    else
    {
        return nil;
    }
}

@end
