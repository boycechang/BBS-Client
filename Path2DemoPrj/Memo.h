//
//  Memo.h
//  MapMemo
//
//  Created by Boyce on 3/2/14.
//  Copyright (c) 2014 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Memo : NSObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longtitude;
@property (nonatomic, retain) NSNumber * like;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) UIImage * image;
@property (nonatomic, retain) NSData * videoData;
@property (nonatomic, retain) NSString * username;
@end
