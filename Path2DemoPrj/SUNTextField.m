//
//  SUNTextField.m
//  SUNCommonComponent
//
//  Created by 麦志泉 on 13-8-21.
//  Copyright (c) 2013年 中山市新联医疗科技有限公司. All rights reserved.
//

#import "SUNTextField.h"

@implementation SUNTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// 自定义绘制
- (void)drawRect:(CGRect)rect
{
    CGMutablePathRef roundedRect = [self drawRoundedRectForRect:rect];
    [self drawLeftViewForRect:rect];
    [self drawBorderForRect:roundedRect];
}

/*!
 * @method 剪辑一个圆角的矩形
 * @abstract
 * @discussion
 * @param
 * @result 圆角矩形
 */
- (CGMutablePathRef)drawRoundedRectForRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //创建圆角矩形路径
    CGMutablePathRef roundedRect = CGPathCreateMutableCopy([UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:_cornerRadius].CGPath);
    CGContextAddPath(context, roundedRect);
    
    //剪切区域
    CGContextClip(context);
    CGContextSaveGState(context);
    
    //填充矩形背景色
    CGContextSetFillColorWithColor(context, _backgroundColor.CGColor);
    CGContextBeginPath(context);
    CGContextAddPath(context, roundedRect);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    return roundedRect;
}

//绘制左侧视图
- (void)drawLeftViewForRect:(CGRect)rect
{
    if (_customerLeftView) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        
        //绘制左侧视图
        CGRect leftViewRect = CGRectMake(0, 0, _customerLeftView.bounds.size.width, rect.size.height);
        CGPathRef leftViewPath = [UIBezierPath bezierPathWithRect:leftViewRect].CGPath;
        CGContextAddPath(context, leftViewPath);
        
        //填充左侧视图背景
        CGContextSetFillColorWithColor(context, _customerLeftView.backgroundColor.CGColor);
        CGContextBeginPath(context);
        CGContextAddPath(context, leftViewPath);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFill);
        
        CGContextRestoreGState(context);
        CGContextSetFillColorWithColor(context, _customerLeftView.textColor.CGColor);
        
        //计算文字尺寸
        CGSize textSize;
        textSize = [_customerLeftView.text sizeWithFont:_customerLeftView.font
                                      constrainedToSize:CGSizeMake(_customerLeftView.bounds.size.width, rect.size.height)
                                          lineBreakMode:NSLineBreakByTruncatingTail];
        CGRect textRect = CGRectMake(0, (CGRectGetMaxY(rect) - textSize.height) / 2, _customerLeftView.bounds.size.width, rect.size.height);
        
        //绘制左侧视图文字
        [_customerLeftView.text drawInRect:textRect
                                  withFont:_customerLeftView.font
                             lineBreakMode:NSLineBreakByTruncatingTail
                                 alignment:_customerLeftView.textAlignment];
    }
}

//绘制边框加内阴影
- (void)drawBorderForRect:(CGMutablePathRef)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //绘制边框加内阴影
    CGContextAddPath(context, rect);
    CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(0, 1), 3, [UIColor colorWithWhite:0.5 alpha:1].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.6 alpha:1].CGColor);
    CGContextStrokePath(context);
}

//控制placeHolder的位置
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(_customerLeftView.frame.size.width+5, bounds.origin.y, bounds.size.width - _customerLeftView.frame.size.width - 30, bounds.size.height);
    return inset;
}

//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(_customerLeftView.frame.size.width+5, bounds.origin.y, bounds.size.width - _customerLeftView.frame.size.width - 30, bounds.size.height);
    
    return inset;
    
}

//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(_customerLeftView.frame.size.width+5, bounds.origin.y, bounds.size.width - _customerLeftView.frame.size.width - 30, bounds.size.height);
    return inset;
}

//控制placeHolder的颜色、字体
- (void)drawPlaceholderInRect:(CGRect)rect
{
    if (self.placeHolderColor) {
        [self.placeHolderColor setFill];
        [[self placeholder] drawInRect:rect withFont:self.font];
    } else {
        [super drawPlaceholderInRect:rect];
    }
    
}

@end
