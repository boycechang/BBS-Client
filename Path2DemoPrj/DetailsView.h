//
//  DetailsView.h
//  XQTest
//
//  Created by xf.lai on 13-7-26.
//  Copyright (c) 2013年 xf.lai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemView.h"
#import "MapItemInfoVO.h"

typedef void (^ClickButtonBlock)(ItemView *btn);
typedef void (^disappearBlock)();

@interface DetailsView : UIView


@property (strong, nonatomic)  ItemView *selectItem;
@property (strong, nonatomic) ClickButtonBlock    blockButton;

@property (assign, nonatomic) CGFloat    startAngle;

@property (assign, nonatomic) NSUInteger itemsNum;
@property (strong, nonatomic) NSMutableArray    *itemsAry;

@property (nonatomic, strong)NSTimer *flickerTimer;

+(DetailsView*)getInstanceWithNib;

-(void)setUI:(MapItemInfoVO *)vo;
-(void)toAppearItemsView:(CGPoint)aPoint angle:(CGFloat)aAngle;

-(void)disappearItems:(disappearBlock )aBlock;
-(void)rotationViews:(CGFloat)aAngle;
-(void)setDetailsViewBlock:(ClickButtonBlock)aBlock;
@end
