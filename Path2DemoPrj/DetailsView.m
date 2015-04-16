
//
//  DetailsView.m
//  XQTest
//
//  Created by xf.lai on 13-7-26.
//  Copyright (c) 2013年 xf.lai. All rights reserved.
//

#import "DetailsView.h"
#import <QuartzCore/QuartzCore.h>
#import "Utils.h"

#define ANGLE_TO_PI M_PI/180
#define SPEEDTIME_TO_PI M_PI/180

#define SpaceX  5.
#define SpaceY  5.

#define scaleNum    0.01
#define animationTime 0.4


#define fSmallCircleD  50.//小圆直径
#define fSmallCircleD_Shadow  50//带阴影的小圆直径(==fSmallCircleD 则不考虑阴影)
#define fBigCircleD 140    //大圆直径
#define fBigCircleD_Shadow  140//带阴影的大圆直径(==fBigCircleD 则不考虑阴影)

#define fSmallRectD_UD 70      //上下小正方形边长
#define fSmallRectD_Mid (fSmallRectD_UD)/sinf(M_PI_4)   //正左右上的中正方形边长

#define fBigRectD1 260  //正中大正方形边长


#define pStartCenter CGPointMake(self.center.x, CGRectGetHeight(self.bounds)-fBigRectD1/2.);    //小中正方形起始中心点
#define fSpaceCenterY CGRectGetHeight(self.bounds)-fBigRectD1/2. - self.center.y    //界面中心点和起始中心点差距

#define standRect   CGRectMake(0, 0, 200, 200)  //作为参照的界面尺寸，用于计算小中正方形的位置
#define spaceH     (CGRectGetHeight(self.bounds) -  CGRectGetHeight(standRect))/2. +fSpaceCenterY
#define spaceW     (CGRectGetWidth(self.bounds) -  CGRectGetWidth(standRect))/2.

#define spaceFar  2.5
@implementation DetailsView

@synthesize itemsAry = _itemsAry;
@synthesize itemsNum = _itemsNum;

+(DetailsView*)getInstanceWithNib
{
    DetailsView *aView = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"DetailsView" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[DetailsView class]]){
            
            aView = (DetailsView *)obj;
            break;
        }
    }
    return aView;
}

-(void)setUI:(MapItemInfoVO *)vo
{
    NSMutableArray *childAray = vo.aryChild;
    _itemsNum = [childAray count] + 1;//小泡泡数量 + 1个大泡泡
   
    if (!self.itemsAry) {
        self.itemsAry = [[NSMutableArray alloc]init];
    }
    
    [self.itemsAry removeAllObjects];
    
    /*
     (N为任意数字)
     frameN：ItemView 的 rect
     psN：画线的起点
     peN：画线的终点
     
     startCenter：动画前 ItemView 的center
     endCenter：动画结束 ItemView 的center
     farCenter：动画跳跃 ItemView 的center
     
     labelTitle_Main：大泡泡的label
     labelBottom：小泡泡的label
     
     */
    
    /********** main button **************/
    CGRect frame0 = CGRectMake(0, 0, fBigRectD1, fBigRectD1);
    CGPoint ps0 = CGPointMake(CGRectGetWidth(frame0)/2., fBigRectD1 - (fBigRectD1 - fBigCircleD)/2. - (fBigCircleD_Shadow - fBigCircleD)) ;
    CGPoint pe0 = CGPointMake(CGRectGetWidth(frame0)/2., CGRectGetHeight(frame0));
    ItemView * buttonItem0 = [[ItemView alloc]initWithFrame:frame0
                                                buttonFrame:CGRectMake(0, 0, fBigCircleD_Shadow, fBigCircleD_Shadow)
                                                  lineStart:ps0
                                                    lineEnd:pe0
                                                      block:^(id btn) {
                                                          [self clickButton:(ItemView *)btn];
                                                      }];
    
    [Utils dealViewRoundCorners:buttonItem0.button radius:CGRectGetHeight(buttonItem0.button.bounds)/2 borderWidth:2.];
    
    buttonItem0.superview.backgroundColor = [UIColor yellowColor];
    buttonItem0.superview.superview.backgroundColor = [UIColor grayColor];
    
    buttonItem0.labelTitle_Main.text = vo.strTitle;
    buttonItem0.labelTitle_Main.textColor = [UIColor whiteColor];
   
    buttonItem0.startCenter = CGPointMake(CGRectGetWidth(self.bounds)/2., CGRectGetHeight(self.bounds));
    buttonItem0.endCenter = pStartCenter;
    buttonItem0.farCenter = CGPointMake(buttonItem0.endCenter.x, buttonItem0.endCenter.y - spaceFar*2);
    buttonItem0.center = buttonItem0.startCenter;
    
    buttonItem0.backGroundImageView.image = vo.image;
    buttonItem0.mask.image = [UIImage imageNamed:@"mask"];
    [self addSubview:buttonItem0];
    buttonItem0.tag = self.tag;

    [self.itemsAry addObject:buttonItem0];
    
    
    /**************************************** leftDown button ******************************************************/
    if (_itemsNum > 1) {
        CGRect frameUD = CGRectMake(0, 0, fSmallRectD_UD, fSmallRectD_UD);
        CGPoint ps1 = CGPointMake(CGRectGetWidth(frameUD)/2.+cosf(M_PI_4)*fSmallCircleD/2., CGRectGetHeight(frameUD)/2.-sinf(M_PI_4)*fSmallCircleD/2.) ;
        CGPoint pe1 = CGPointMake(CGRectGetWidth(frameUD), 0);
        ItemView * buttonItem1= [[ItemView alloc]initWithFrame:frameUD
                                                   buttonFrame:CGRectMake(0, 0, fSmallCircleD_Shadow, fSmallCircleD_Shadow)
                                                     lineStart:ps1
                                                       lineEnd:pe1
                                                         block:^(id btn) {
                                                             [self clickButton:(ItemView *)btn];
                                                         }];
        buttonItem1.startCenter = pStartCenter;
        
        buttonItem1.endCenter = CGPointMake(CGRectGetWidth(buttonItem1.button.bounds)/2.+spaceW, CGRectGetHeight(self.bounds)-CGRectGetHeight(buttonItem1.button.bounds)/2.-spaceH);
        buttonItem1.farCenter = CGPointMake(buttonItem1.endCenter.x - cosf(M_PI_4)*spaceFar, buttonItem1.endCenter.y + sinf(M_PI_4)*spaceFar);
        buttonItem1.center = buttonItem1.startCenter;
        [self insertSubview:buttonItem1 belowSubview:buttonItem0];
        buttonItem1.hidden = YES;
        buttonItem1.tag = self.tag;
        [self.itemsAry addObject:buttonItem1];
        
        
      
        /**************************************** rightDown button ******************************************************/
        if (_itemsNum > 2) {
            CGPoint ps2 = CGPointMake(CGRectGetWidth(frameUD)/2.-cosf(M_PI_4)*fSmallCircleD/2., CGRectGetHeight(frameUD)/2.-sinf(M_PI_4)*fSmallCircleD/2.) ;
            CGPoint pe2 = CGPointMake(0, 0);
            ItemView * buttonItem2= [[ItemView alloc]initWithFrame:frameUD
                                                       buttonFrame:CGRectMake(0, 0, fSmallCircleD_Shadow, fSmallCircleD_Shadow)
                                                         lineStart:ps2
                                                           lineEnd:pe2
                                                             block:^(id btn) {
                                                                 [self clickButton:(ItemView *)btn];
                                                             }];
            buttonItem2.startCenter = pStartCenter;
            buttonItem2.endCenter = CGPointMake(CGRectGetWidth(self.bounds)-spaceW - CGRectGetWidth(buttonItem2.button.bounds)/2., CGRectGetHeight(self.bounds)-CGRectGetHeight(buttonItem2.button.bounds)/2.-spaceH);
            buttonItem2.farCenter = CGPointMake(buttonItem2.endCenter.x + cosf(M_PI_4)*spaceFar, buttonItem2.endCenter.y + sinf(M_PI_4)*spaceFar);
            buttonItem2.center = buttonItem2.startCenter;
            [self insertSubview:buttonItem2 belowSubview:buttonItem0];
            buttonItem2.hidden = YES;
            buttonItem2.tag = self.tag;
            [self.itemsAry addObject:buttonItem2];
        

            /**************************************** leftMid button ******************************************************/
            if (_itemsNum > 3) {
                CGRect frameMid = CGRectMake(0, 0, fSmallRectD_Mid, fSmallRectD_Mid);
                CGPoint ps3 = CGPointMake((CGRectGetWidth(frameMid)+fSmallCircleD)/2., CGRectGetHeight(frameMid)/2.) ;
                CGPoint pe3 = CGPointMake(CGRectGetWidth(frameMid), CGRectGetHeight(frameMid)/2.);
                ItemView * buttonItem3= [[ItemView alloc]initWithFrame:frameMid
                                                           buttonFrame:CGRectMake(0, 0, fSmallCircleD_Shadow, fSmallCircleD_Shadow)
                                                             lineStart:ps3
                                                               lineEnd:pe3
                                                                 block:^(id btn) {
                                                                     [self clickButton:(ItemView *)btn];
                                                                 }];
                buttonItem3.startCenter = pStartCenter;
                buttonItem3.endCenter = CGPointMake(buttonItem3.startCenter.x - (fBigCircleD/2. + fSmallRectD_Mid/2.), buttonItem3.startCenter.y);
                buttonItem3.farCenter = CGPointMake(buttonItem3.endCenter.x - spaceFar, buttonItem3.endCenter.y) ;
                
                buttonItem3.center = buttonItem3.startCenter;
                
                [self insertSubview:buttonItem3 belowSubview:buttonItem0];
                buttonItem3.hidden = YES;
                buttonItem3.tag = self.tag;
                [self.itemsAry addObject:buttonItem3];
            
            
                /**************************************** rightMid button ******************************************************/
                if (_itemsNum > 4) {
                    CGPoint ps4 = CGPointMake((CGRectGetWidth(frameMid)-fSmallCircleD)/2., CGRectGetHeight(frameMid)/2.) ;
                    CGPoint pe4 = CGPointMake(0., CGRectGetHeight(frameMid)/2.);
                    ItemView * buttonItem4= [[ItemView alloc]initWithFrame:frameMid
                                                               buttonFrame:CGRectMake(0, 0, fSmallCircleD_Shadow, fSmallCircleD_Shadow)
                                                                 lineStart:ps4
                                                                   lineEnd:pe4
                                                                     block:^(id btn) {
                                                                         [self clickButton:(ItemView *)btn];
                                                                     }];
                    buttonItem4.startCenter = pStartCenter;
                    buttonItem4.endCenter =CGPointMake(buttonItem4.startCenter.x + (fBigCircleD/2. + fSmallRectD_Mid/2.), buttonItem4.startCenter.y);
                    buttonItem4.farCenter = CGPointMake(buttonItem4.endCenter.x + spaceFar, buttonItem4.endCenter.y) ;
                    buttonItem4.center = buttonItem4.startCenter;
                    [self insertSubview:buttonItem4 belowSubview:buttonItem0];
                    buttonItem4.hidden = YES;
                    buttonItem4.tag = self.tag;
                    
                    [self.itemsAry addObject:buttonItem4];
                    
                    /**************************************** leftUp button ******************************************************/
                    if (_itemsNum > 5) {
                        
                        //leftup button
                        CGPoint ps5 = CGPointMake(CGRectGetWidth(frameUD)/2.+cosf(M_PI_4)*fSmallCircleD/2., CGRectGetHeight(frameUD)/2.+sinf(M_PI_4)*fSmallCircleD/2.) ;
                        CGPoint pe5 = CGPointMake(CGRectGetWidth(frameUD), CGRectGetHeight(frameUD));
                        ItemView * buttonItem5= [[ItemView alloc]initWithFrame:frameUD
                                                                   buttonFrame:CGRectMake(0, 0, fSmallCircleD_Shadow, fSmallCircleD_Shadow)
                                                                     lineStart:ps5
                                                                       lineEnd:pe5
                                                                         block:^(id btn) {
                                                                             [self clickButton:(ItemView *)btn];
                                                                         }];
                        buttonItem5.startCenter = pStartCenter;
                        buttonItem5.endCenter = CGPointMake((CGRectGetWidth(buttonItem5.button.bounds)/2.+spaceW), CGRectGetHeight(buttonItem5.button.bounds)/2.+spaceH);
                        buttonItem5.farCenter = CGPointMake(buttonItem5.endCenter.x - cosf(M_PI_4)*spaceFar, buttonItem5.endCenter.y - sinf(M_PI_4)*spaceFar);
                        buttonItem5.center = buttonItem5.startCenter;
                        [self insertSubview:buttonItem5 belowSubview:buttonItem0];
                        buttonItem5.hidden = YES;
                        buttonItem5.tag = self.tag;
                        [self.itemsAry addObject:buttonItem5];
                        
                        /**************************************** rightup button ******************************************************/
                        if (_itemsNum > 6) {
                            CGPoint ps6 = CGPointMake(CGRectGetWidth(frameUD)/2.-cosf(M_PI_4)*fSmallCircleD/2., CGRectGetHeight(frameUD)/2.+sinf(M_PI_4)*fSmallCircleD/2.) ;
                            CGPoint pe6 = CGPointMake(0, CGRectGetHeight(frameUD));
                            ItemView * buttonItem6= [[ItemView alloc]initWithFrame:frameUD
                                                                       buttonFrame:CGRectMake(0, 0, fSmallCircleD_Shadow, fSmallCircleD_Shadow)
                                                                         lineStart:ps6
                                                                           lineEnd:pe6
                                                                             block:^(id btn) {
                                                                                 [self clickButton:(ItemView *)btn];
                                                                             }];
                            buttonItem6.startCenter = pStartCenter;
                            buttonItem6.endCenter = CGPointMake((CGRectGetWidth(self.bounds) -spaceW- CGRectGetWidth(buttonItem6.button.bounds)/2.),CGRectGetHeight(buttonItem6.button.bounds)/2.+spaceH);
                            buttonItem6.farCenter = CGPointMake(buttonItem6.endCenter.x + cosf(M_PI_4)*spaceFar, buttonItem6.endCenter.y - sinf(M_PI_4)*spaceFar);
                            buttonItem6.center = buttonItem6.startCenter;
                            [self insertSubview:buttonItem6 belowSubview:buttonItem0];
                            buttonItem6.hidden = YES;
                            buttonItem6.tag = self.tag;
                            
                            [self.itemsAry addObject:buttonItem6];
                            
                            
                            /**************************************** midUp button ******************************************************/
                            if (_itemsNum > 7) {
                                //midUp button
                                CGPoint ps7 = CGPointMake(CGRectGetWidth(frameMid)/2., (CGRectGetHeight(frameMid) - fSmallCircleD)/2.+fSmallCircleD);
                                CGPoint pe7 = CGPointMake(CGRectGetWidth(frameMid)/2., CGRectGetHeight(frameMid));
                                ItemView * buttonItem7= [[ItemView alloc]initWithFrame:frameMid
                                                                           buttonFrame:CGRectMake(0, 0, fSmallCircleD_Shadow, fSmallCircleD_Shadow)
                                                                             lineStart:ps7
                                                                               lineEnd:pe7
                                                                                 block:^(id btn) {
                                                                                     [self clickButton:(ItemView *)btn];
                                                                                 }];
                                buttonItem7.startCenter = pStartCenter;
                                buttonItem7.endCenter = CGPointMake(buttonItem7.startCenter.x, buttonItem7.startCenter.y - (fBigCircleD/2. + fSmallRectD_Mid/2.));
                                buttonItem7.farCenter = CGPointMake(buttonItem7.endCenter.x, buttonItem7.endCenter.y - spaceFar);
                                buttonItem7.center = buttonItem4.startCenter;
                                [self insertSubview:buttonItem7 belowSubview:buttonItem0];
                                buttonItem7.hidden = YES;
                                buttonItem7.tag = self.tag;
                                
                                [self.itemsAry addObject:buttonItem7];
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    for (int i = 0; i < _itemsNum; i++) {
        ItemView *item = [_itemsAry objectAtIndex:i];
        if (i != 0) {
            MapItemInfoVO * info = [childAray objectAtIndex:i-1];
            item.labelBottom.text = info.strTitle;
             [Utils dealViewRoundCorners:item.button radius:CGRectGetHeight(item.button.bounds)/2 borderWidth:2.];//切成圆
            item.labelBottom.textColor = [UIColor blackColor];
            item.labelBottom.font = [UIFont systemFontOfSize:10];
            item.labelBottom.numberOfLines = 3;
        }
        [Utils dealScaleView:item scale:scaleNum];
    }
}

-(void)setDetailsViewBlock:(ClickButtonBlock)aBlock
{
    self.blockButton = aBlock;
}

-(void)setItemsTransform:(CGAffineTransform)transf
{
    for (int i =0; i<_itemsNum; i++) {
        ItemView *item = [_itemsAry objectAtIndex:i];
        item.button.transform = transf;
    }
}

#pragma mark - methods
//rotation view&buttons by angle
-(void)rotationViews:(CGFloat)aAngle                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
{
    //动画时间
    CGFloat time = animationTime/2.;
    
    CGFloat spaceNum = fabs(self.startAngle)+fabs(aAngle);
    if (spaceNum>M_PI) {
        spaceNum = M_2_PI - spaceNum;
    }
    if (spaceNum>M_PI_2) {
        time =animationTime;
        if (spaceNum>M_PI_2+M_PI_4) {
            time =animationTime*3./2.;
        }
    }
    
    self.startAngle = aAngle;
    
    [UIView animateWithDuration:time
                     animations:^{
                         CGAffineTransform transform =CGAffineTransformMakeRotation(-aAngle);
                         self.superview.layer.anchorPoint = CGPointMake(0.5, 1.0);
                         self.superview.transform = transform;
                         
                         CGAffineTransform transformItem =CGAffineTransformMakeRotation(aAngle);
                         [self setItemsTransform:transformItem];
                         
                         
                     }];
}

-(void)animationOfRotationByTime:(CGFloat)time angle:(CGFloat)aAngle delay:(CGFloat)delayTime
{
    [UIView animateWithDuration:time
                          delay:delayTime
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGAffineTransform transform =CGAffineTransformMakeRotation(-aAngle);
                         self.superview.layer.anchorPoint = CGPointMake(0.5, 1.0);
                         self.superview.transform = transform;
                         
                         CGAffineTransform transformItem =CGAffineTransformMakeRotation(aAngle);
                         [self setItemsTransform:transformItem];
                     } completion:^(BOOL finished) {
                         
                     }];
    
    
}


-(void)toAppearItemsView:(CGPoint)aPoint angle:(CGFloat)aAngle
{
    self.startAngle = aAngle;
    
    self.superview.transform = CGAffineTransformIdentity;
    CGAffineTransform transform =CGAffineTransformMakeRotation(-aAngle);
    self.superview.layer.anchorPoint = CGPointMake(0.5, 1.0);
    self.superview.transform = transform;
    [self setItemsTransform:CGAffineTransformIdentity];
   
    CGAffineTransform transformItem =CGAffineTransformMakeRotation(aAngle);
    [self setItemsTransform:transformItem];

    [self appearItems];

    
}
-(void)appearItems
{
    ItemView * buttonItem0 = [_itemsAry objectAtIndex:0];
    [self appearItem:buttonItem0 delay:0 ToFrontWhenCompletion:NO];
    
    for (int i =1; i<_itemsNum; i++) {
        ItemView *item = [_itemsAry objectAtIndex:i];
        item.hidden =NO;
        [self appearItem:item delay:0.2+(i-1)*0.1 ToFrontWhenCompletion:YES];
    }
             
}
-(void)appearItem:(ItemView *)item delay:(CGFloat)delay ToFrontWhenCompletion:(BOOL)bFont
{
    
    [UIView animateWithDuration:0.2
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        item.center = item.farCenter;
        [Utils dealScaleView:item scale:1/scaleNum];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            item.center = item.endCenter;
        }completion:^(BOOL finished) {
            if (bFont) {
                 [self bringSubviewToFront:item];
            }
         
        }];
    }];


}
-(void)disappearItems:(disappearBlock )aBlock
{
    if (self.selectItem) {
        self.selectItem = nil;
        
        [self.flickerTimer invalidate];
        UIView *imgView = [self viewWithTag:1000];
        [imgView removeFromSuperview];
    }

    ItemView *buttonItem0 = [_itemsAry objectAtIndex:0];
    if (buttonItem0.center.x == buttonItem0.startCenter.x
        && buttonItem0.center.y == buttonItem0.startCenter.y) {
        return;
    }
    [self bringSubviewToFront:buttonItem0];
    if (_itemsNum==1) {
        [UIView animateWithDuration:0.2 animations:^{
            buttonItem0.center = buttonItem0.startCenter;
            [Utils dealScaleView:buttonItem0 scale:scaleNum];
            
        }completion:^(BOOL finished) {
            aBlock();
        }];

    }
    else
    {
        [UIView animateWithDuration:0.2
                         animations:^{
                             for (int i =1; i<_itemsNum; i++) {
                                 ItemView *item = [_itemsAry objectAtIndex:i];
                                 item.center = item.startCenter;
                                 [Utils dealScaleView:item scale:scaleNum];
                             }
                             
                             
                         } completion:^(BOOL finished) {
                             for (int i =1; i<_itemsNum; i++) {
                                 ItemView *item = [_itemsAry objectAtIndex:i];
                                 item.hidden = YES;
                             }
                             [UIView animateWithDuration:0.2 animations:^{
                                 buttonItem0.center = buttonItem0.startCenter;
                                 [Utils dealScaleView:buttonItem0 scale:scaleNum];
                                 
                             }completion:^(BOOL finished) {
                                 aBlock();
                             }];
                             
                         }];
    }
    
   
    
}

#pragma mark - action
- (void)clickButton:(ItemView * )btn {
    self.selectItem = btn;
    if (self.blockButton) {
        self.blockButton( self.selectItem );
    }
}

@end
