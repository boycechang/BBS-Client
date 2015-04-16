//
//  Utils.m
//  ScenicGuide
//
//  Created by xf.lai on 13-7-31.
//  Copyright (c) 2013年 xf.lai. All rights reserved.
//

#import "Utils.h"
#import <QuartzCore/QuartzCore.h>

@implementation Utils

/*
 * 射线p1->p0相对于Y轴正向逆时针旋转角度(以p1为原点，以p0为终点)
 */

float calculateRotateDegree(CGPoint p1,CGPoint p0)
{
    
    //printf("......p1.x=%.2f, p1.y=%.2f, p0.x=%.2f, p0.y=%.2f ......\n", p1.x, p1.y, p0.x, p0.y);
    
    double rotateDegree = atan2(fabs(p1.x-p0.x),fabs(p1.y-p0.y)) * 180.0 / M_PI;
    
//    DLog(@"###>>>>> %f",rotateDegree);
    
    //printf("......rorate degree=%.2f......\n", rotateDegree);
    
    //如果p0纵坐标小于原点p1纵坐标(p0在第一和第二象限)（y是向下增长的）
    if (p0.y<=p1.y)
    {
        if (p0.x<=p1.x) //第一象限
        {
            rotateDegree = rotateDegree;
        }
        else //第二象限
        {
            rotateDegree = - rotateDegree;
        }
    }
    else //第三和第四象限
    {
        if (p0.x<=p1.x) //第三象限，不做任何处理
        {
            rotateDegree = 180.0- rotateDegree;
        }
        else //第四象限
        {
            rotateDegree =  rotateDegree - 180.;
        }
    }
    return rotateDegree*M_PI/180.;
}


+(CGFloat)getAngleByPoint:(CGPoint)nowPoint center:(CGPoint)center
{
    
    CGFloat angle = calculateRotateDegree(nowPoint,center);
    
//    DLog(@"(%f,%f) --> (160,230) == %f",nowPoint.x,nowPoint.y,angle*180./M_PI);
    
    return angle;
    
}


+ (CGFloat)heightOfText:(NSString *)text theWidth:(float)width theFont:(UIFont*)aFont {
	CGFloat result;
	CGSize textSize = { width, 20000.0f };
	CGSize size = [text sizeWithFont:aFont constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
	result = size.height;
	return result;
}

//切成圆脚
+ (void)dealViewRoundCorners:(UIView *)aView radius:(CGFloat)aRadius borderWidth:(CGFloat)aWidth
{
    [aView.layer setMasksToBounds:YES];
    [aView.layer setCornerRadius:aRadius];
    if (aWidth>0) {
        aView.layer.borderColor = [[UIColor blackColor] CGColor];
        aView.layer.borderWidth = aWidth;
        aView.backgroundColor=[UIColor whiteColor];

    }
    
}

//等比例缩放
+(void)dealScaleView:(UIView *)aView scale:(CGFloat)aScale
{
    //进行缩放
    CGAffineTransform currentTransform = aView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, aScale,aScale);
    [aView setTransform:newTransform];
    
}

+(UIImage *)getColorImage:(CGSize )size color:(UIColor *)color
{
    CGFloat glowSpread = 60.0f;
    
    UIImage *image = nil;
    CGSize imageSize = size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetAllowsAntialiasing(context, true);
        CGContextSetShouldAntialias(context, true);
        
        CGContextSaveGState(context);
        
        CGGradientRef gradient = [Utils __newGlowGradientWithColor:color];
        
        CGPoint gradCenter = CGPointMake(floorf(imageSize.width / 2.0f), floorf(imageSize.height / 2.0f));
        CGFloat gradRadius = MAX(imageSize.width, imageSize.height) / 2.0f;
        
        CGContextDrawRadialGradient(context, gradient, gradCenter, 0.0f, gradCenter, gradRadius, kCGGradientDrawsBeforeStartLocation);
        
        CGGradientRelease(gradient), gradient = NULL;
        CGContextRestoreGState(context);
        
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, glowSpread / 2.0f, glowSpread / 2.0f);
        
//        [self.layer renderInContext:context];
        
        CGContextRestoreGState(context);
        
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return image;
}

+(CGGradientRef)__newGlowGradientWithColor:(UIColor*)color
{
    CGColorRef cgColor = [color CGColor];
    
    const CGFloat *sourceColorComponents = CGColorGetComponents(cgColor);
    
    CGFloat sourceRed;
    CGFloat sourceGreen;
    CGFloat sourceBlue;
    CGFloat sourceAlpha;
    if (CGColorGetNumberOfComponents(cgColor) == 2)
    {
        sourceRed = sourceColorComponents[0];
        sourceGreen = sourceColorComponents[0];
        sourceBlue = sourceColorComponents[0];
        sourceAlpha = sourceColorComponents[1];
    }
    else
    {
        sourceRed = sourceColorComponents[0];
        sourceGreen = sourceColorComponents[1];
        sourceBlue = sourceColorComponents[2];
        sourceAlpha = sourceColorComponents[3];
    }
    
    size_t locationsCount = 20;
    CGFloat step = 1.0f / locationsCount;
    
    CGFloat colorComponents[4 * locationsCount];
    CGFloat locations[locationsCount];
    
    NSUInteger componentsIndex = 0;
    for (NSUInteger index = 0; index < locationsCount; index++)
    {
        CGFloat point = index * step;
        locations[index] = point;
        
        CGFloat alpha = sourceAlpha * (1 - 0.5 * (1 - cos(point * M_PI)));
        
        colorComponents[componentsIndex] = sourceRed;
        colorComponents[componentsIndex + 1] = sourceGreen;
        colorComponents[componentsIndex + 2] = sourceBlue;
        colorComponents[componentsIndex + 3] = alpha;
        componentsIndex += 4;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colorComponents, locations, locationsCount);
    
    CGColorSpaceRelease(colorSpace), colorSpace = NULL;
    
    return gradient;
}

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString]; //去掉前后空格换行符
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor redColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor redColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];  //扫描16进制到int
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


+ (UIColor *) getColorByTag: (NSUInteger) tag
{
    UIColor *color = nil;
    switch (tag) {
        case 0:
        {
            color= [Utils colorWithHexString:@"a72ee0"];
        }
            break;
        case 1:
        {
            color= [Utils colorWithHexString:@"6445fc"];
        }
            break;
        case 2:
        {
            color= [Utils colorWithHexString:@"295ed6"];
        }
            break;
        case 3:
        {
            color= [Utils colorWithHexString:@"29a9de"];
        }
            break;
        case 4:
        {
            color= [Utils colorWithHexString:@"2acadd"];
        }
            break;
        case 5:
        {
            color= [Utils colorWithHexString:@"34dfbc"];
        }
            break;
            
        default:
            break;
    }
    return color;
}


+(NSURL *)getUrlByPathStr:(NSString *)aStr
{
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath],aStr];
    NSURL *url = [NSURL fileURLWithPath:path];
    return url;
}

+(BOOL)judgeUrlString:(NSString *)aStr
{
    BOOL isUrl = YES;
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http+:[^\\s]*" options:0 error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:aStr options:0 range:NSMakeRange(0, [aStr length])];
        if (firstMatch) {
            isUrl = YES;
        }else {
            isUrl = NO;
            
        }
    }
    return isUrl;
}




@end
