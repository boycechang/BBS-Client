//
//  ScenicVO.h
//  ScenicGuide
//
//  Created by xf.lai on 13-8-5.
//  Copyright (c) 2013年 xf.lai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapItemInfoVO : NSObject{
    NSString *strId;
    NSString *strTitle;
    NSString *strDetails;
    NSString *strLat;//纬度
    NSString *strLon;//经度
   
    NSMutableArray *aryChild;
    
    UIImage  *image;
}
@property (nonatomic, copy) NSString *strId;
@property (nonatomic, copy) NSString *strTitle;
@property (nonatomic, copy) NSString *strDetails;
@property (nonatomic, copy) NSString *strLat;//纬度
@property (nonatomic, copy) NSString *strLon;//经度
@property (nonatomic, copy) NSMutableArray *aryChild;

@property (nonatomic, copy) UIImage  *image;

@end
