//
//  Utils.h
//  ScenicGuide
//
//  Created by xf.lai on 13-7-31.
//  Copyright (c) 2013年 xf.lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"MapItemInfoVO.h"

typedef enum {
    ButtonType_Main = 0,
    ButtonType_LeftDown,
    ButtonType_RightDown,
    ButtonType_LeftMid,
    ButtonType_RightMid,
    ButtonType_LeftUp,
    ButtonType_RightUp,
    ButtonType_MidUp,
    
}ButtonType;


@interface Utils : NSObject

+ (CGFloat)heightOfText:(NSString *)text theWidth:(float)width theFont:(UIFont*)aFont;

+ (void)dealViewRoundCorners:(UIView *)aView radius:(CGFloat)aRadius borderWidth:(CGFloat)aWidth;
+(void)dealScaleView:(UIView *)aView scale:(CGFloat)aScale;
+(CGFloat)getAngleByPoint:(CGPoint)nowPoint center:(CGPoint)center;
+(UIImage *)getColorImage:(CGSize )size color:(UIColor *)color;
+ (UIColor *)colorWithHexString: (NSString *) stringToConvert;
+ (UIColor *) getColorByTag: (NSUInteger) tag;


@end
