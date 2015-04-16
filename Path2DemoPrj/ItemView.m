//
//  ItemButton.m
//  XQSearchPlaces
//
//  Created by xf.lai on 13-7-24.
//  Copyright (c) 2013年 iObitLXF. All rights reserved.
//

#import "ItemView.h"
#import "Utils.h"
#import <QuartzCore/QuartzCore.h>

#define aScale_Main 3./5.
#define aScale_Other 4./5.

@implementation ItemView

- (id)initWithFrame:(CGRect)frame buttonFrame:(CGRect)frameBtn lineStart:(CGPoint)p1 lineEnd:(CGPoint)p2 block:(ClickItemViewBlock)aBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.blockButton = aBlock;
        
        self.backgroundColor = [UIColor clearColor];
        self.lineStartP = p1;
        self.lineEndP = p2;
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.backgroundColor = [UIColor clearColor];
        self.button.frame = frameBtn;
        self.button.center = self.center;
        self.button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview: self.button];
        [self.button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        self.backGroundImageView = [[UIImageView alloc] init];
        self.backGroundImageView.frame = frameBtn;
        self.backGroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.button addSubview: self.backGroundImageView];
        
        self.mask = [[UIImageView alloc] init];
        self.mask.frame = frameBtn;
        self.mask.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //[self.mask setImage:[UIImage imageNamed:@"mask"]];
        [self.button addSubview:self.mask];

        if (CGRectGetHeight(frame) == 260) {
            self.labelBottom.hidden = YES;
            self.labelTitle_Main = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.button.bounds) - 40, CGRectGetHeight(self.button.bounds) - 40)];

            self.labelTitle_Main.center  = CGPointMake(CGRectGetWidth(self.button.bounds)/2., CGRectGetHeight(self.button.bounds)/2.);//center1;
            //self.labelTitle_Main.textColor = [Utils getColorByTag:self.tag];
            self.labelTitle_Main.textColor = [UIColor whiteColor];
            self.labelTitle_Main.textAlignment = NSTextAlignmentCenter;
            self.labelTitle_Main.font = [UIFont boldSystemFontOfSize:15.];
            [self.labelTitle_Main setNumberOfLines:2];
            self.labelTitle_Main.backgroundColor = [UIColor clearColor];
            [self.button addSubview:self.labelTitle_Main];
        } else {
            self.labelBottom = [[UILabel alloc]init];
            CGRect labelFrame = CGRectMake(0, 0, CGRectGetWidth(frameBtn), 30);//
            self.labelBottom.frame = labelFrame;
            self.labelBottom.center  = CGPointMake(CGRectGetWidth(self.button.bounds)/2.0, CGRectGetHeight(self.button.bounds)/2.0);
            self.labelBottom.textAlignment = NSTextAlignmentCenter;
            self.labelBottom.font = [UIFont systemFontOfSize:10];
            self.labelBottom.textColor = [UIColor whiteColor];
            [self.labelTitle_Main setNumberOfLines:2];
            self.labelBottom.backgroundColor = [UIColor clearColor];
            [self.button addSubview:self.labelBottom];
        }
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    
    if (self.lineEndP.x == self.lineStartP.x && self.lineStartP.y == self.lineEndP.y) {
        return;
    }
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
}
-(void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context,1.);
    CGContextMoveToPoint(context, self.lineStartP.x, self.lineStartP.y);//起点
    CGContextAddLineToPoint(context, self.lineEndP.x, self.lineEndP.y);//终点
//    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);//设置线的颜色
    CGContextStrokePath(context);
    
   
}

-(IBAction)clickButton:(id)sender
{
    self.blockButton(self);
}
@end
