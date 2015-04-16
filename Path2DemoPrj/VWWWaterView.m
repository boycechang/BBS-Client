//
//  VWWWaterView.m
//  Water Waves
//
//  Created by Veari_mac02 on 14-5-23.
//  Copyright (c) 2014年 Veari. All rights reserved.
//

#import "VWWWaterView.h"
#import "CommonUI.h"

#define degreeTOradians(x) (M_PI * (x)/180)
#define HIGH 3
#define LOW 1

@interface VWWWaterView ()
{
    UIColor *_currentWaterColor;
    
    float _currentLinePointY;
    
    float a;
    float b;
    float c;
    BOOL jia;
}
@end


@implementation VWWWaterView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        a = HIGH;
        b = 0;
        c = 1;
        _currentWaterColor = NAVBARCOLORBLUE;
        _currentLinePointY = 30;
        
    }
    return self;
}

- (void) startWave
{
    self.transform = CGAffineTransformMakeRotation(degreeTOradians(180));
    jia = NO;
    timerStart = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
}

- (void) stopWave
{
    self.transform = CGAffineTransformMakeRotation(degreeTOradians(180));
    //[timerStart invalidate];
    timerStop = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(disanimateWave) userInfo:nil repeats:YES];
}

-(void)disanimateWave
{
    if (abs(a) <= 0.06) {
        [timerStop invalidate];
        
        [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [timerStop invalidate];
        }];
    }
    
    if (a < 0) {
        a += 0.06;
    } else {
        a -= 0.06;
    }
    
    b += 0.1;
    
    [self setNeedsDisplay];
}

-(void)animateWave
{
    if (jia) {
        a += 0.01;
    }else{
        a -= 0.01;
    }
    
    
    if (a <= LOW) {
        jia = YES;
    }
    
    if (a >= HIGH) {
        jia = NO;
    }
    
    
    b += 0.1;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    //画水
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, [_currentWaterColor CGColor]);
    
    float y = _currentLinePointY;
    CGPathMoveToPoint(path, NULL, 0, y);
    for(float x = 0; x <= self.frame.size.width; x++){
        y= a * sin( x / 180 * M_PI + 4 * b / M_PI ) * 5 + _currentLinePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, self.frame.size.width, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, _currentLinePointY);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
}


@end
