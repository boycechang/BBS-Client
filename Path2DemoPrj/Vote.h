//
//  Vote.h
//  北邮人BBS
//
//  Created by Boyce on 10/31/13.
//  Copyright (c) 2013 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Vote : NSObject
{
    
}


@property(nonatomic, assign)int vid;
@property(nonatomic, strong)NSString *voteTitle;

@property(nonatomic, strong)NSDate *start;
@property(nonatomic, strong)NSDate *end;
@property(nonatomic, assign)int user_count;
@property(nonatomic, assign)int vote_count;
@property(nonatomic, assign)int type;
@property(nonatomic, assign)int limit;
@property(nonatomic, strong)NSString *author;
@property(nonatomic, strong)NSURL *authorHeadUrl;

@property(nonatomic, assign)BOOL is_end;
@property(nonatomic, assign)BOOL is_deleted;
@property(nonatomic, assign)BOOL is_result_voted;

@property(nonatomic, strong)NSArray *voted;
@property(nonatomic, strong)NSArray *options;

///options使用
@property(nonatomic, strong)NSString *label;
@property(nonatomic, assign)int viid;
@property(nonatomic, assign)int num;

@end
