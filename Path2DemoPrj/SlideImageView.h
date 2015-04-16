//
//  SlideImageView.h
//  SlideImageView
//
//  Created by rd on 12-12-17.
//  Copyright (c) 2012年 LXJ_成都. All rights reserved.
//
//如果锯齿明显需要抗锯齿效果，不在太高性能要求情况下可以在项目plist文件中加入项目
//Renders with edge antialisasing   YES
// 需要往项目中添加 QuartzCore.framework 框架， 才能正确运行

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol SlideImageViewDelegate<NSObject>
@optional 
- (void)SlideImageViewDidClickWithIndex:(int)index; //对点击图片后的处理
- (void)SlideImageViewDidScrollWithIndex:(int)index; //滚动时的处理
- (void)SlideImageViewDidEndScorllWithIndex:(int)index;//结束滚动后的处理
@end

@protocol SlideScrollViewDelegate <NSObject>
@optional
- (void)SlideScrollViewDidEndClick:(int)index;
@end

@class SlideScrollView;
@interface SlideImageView : UIView <UIScrollViewDelegate, SlideScrollViewDelegate>
{
    int _index; //当前图片的索引
    NSMutableArray* _scrollImageArray; //滚动视图图片数组
    NSMutableArray* _imageViewArray;   //弹压视图图片数组
    SlideScrollView* _scrollView; 
    UIView* _moveView;
    float _shadowValueX,_shadowValueY;//阴影的x,y方向的值
    float _shadowAlpha; //阴影透明度
}
@property (nonatomic, assign) NSObject<SlideImageViewDelegate>* delegate;
@property(nonatomic) float _zMarginValue;//图片之间z方向的间距值，越小间距越大
@property(nonatomic) float _xMarginValue;//图片之间x方向的间距值，越小间距越大
@property(nonatomic) float _alphaValue;  //图片的透明比率值
@property(nonatomic) float _angleValue;  //偏移角度
@property(nonatomic, strong) UIColor* borderColor; //边框颜色，可以为空
@property(nonatomic,readonly) NSMutableArray* _imageArray; //图片数组

- (id)initWithFrame:(CGRect)frame;
//通过参数进行初始化，注:ZMarginValue与XMarginValue的值越接近，效果越佳,透明比率值建议设置在1000左右
- (id)initWithFrame:(CGRect)frame ZMarginValue:(float)zMarginValue 
       XMarginValue:(float)xMarginValue AngleValue:(float)angleValue Alpha:(float)alphaValue;
- (void)addImage:(UIImage*)image; //添加图片数据
- (void)setImageShadowsWtihDirectionX:(float)value_X Y:(float)value_Y Alpha:(float)alphaValue;//设置图片阴影的x,y方向的值和透明度
- (void)reLoadUIview;   //重新加载UI
@end
