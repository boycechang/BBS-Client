//
//  ItemButton.h
//  XQSearchPlaces
//
//  Created by xf.lai on 13-7-24.
//  Copyright (c) 2013年 iObitLXF. All rights reserved.
//

/*

 A view that includes a button and a line

*/

#import <UIKit/UIKit.h>

typedef enum {
    ItemButtonType_Main = 0,
    ItemButtonType_Left,
    ItemButtonType_right,
    
}ItemButtonType;

typedef void (^ClickItemViewBlock)(id btn);

@interface ItemView : UIView
@property(nonatomic,strong) UIButton *button;
@property(nonatomic,strong) UILabel *labelBottom;
@property(nonatomic,strong) UILabel *labelTitle_Main;
@property(nonatomic,strong) UIImageView *backGroundImageView;
@property(nonatomic,strong) UIImageView *mask;
@property(nonatomic,assign) CGFloat angleStart;
@property(nonatomic,assign) CGFloat angleEnd;
@property(nonatomic,assign) CGPoint lineStartP;
@property(nonatomic,assign) CGPoint lineEndP;
@property(nonatomic,assign) CGPoint startCenter;
@property(nonatomic,assign) CGPoint endCenter;
@property(nonatomic,assign) CGPoint farCenter;

@property (nonatomic,strong)ClickItemViewBlock    blockButton;

- (id)initWithFrame:(CGRect)frame buttonFrame:(CGRect)frameBtn lineStart:(CGPoint)p1 lineEnd:(CGPoint)p2 block:(ClickItemViewBlock)aBlock;
@end
