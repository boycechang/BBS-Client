//
//  SlideImageView.m
//  SlideImageView
//
//  Created by rd on 12-12-17.
//  Copyright (c) 2012年 LXJ_成都. All rights reserved.
//

#import "SlideImageView.h"

@interface SlideScrollView : UIScrollView <SlideScrollViewDelegate>
@property(nonatomic) NSArray* imageViewArr; //拖动的视图数组
@property(nonatomic) float imageWidth; //图片的宽度
@property(nonatomic, assign) NSObject<SlideScrollViewDelegate>* SlideImagedelegate;
@end

@implementation SlideScrollView
@synthesize imageViewArr, imageWidth, SlideImagedelegate;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event //点击开始
{
    if(imageViewArr.count > 0)
    {
        int index = roundf(self.contentOffset.x/imageWidth); //计算索引
        if(index < 0)
            index = 0;
        if(index > imageViewArr.count -1)
            index = imageViewArr.count - 1;
        UIImageView* imageView = [imageViewArr objectAtIndex:index]; //获取点中的图片
        imageView.layer.zPosition = -10;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event //若此事件被触发，则说明没有拖动，发生了点击
{
    if(imageViewArr.count > 0)
    {
        int index = roundf(self.contentOffset.x/imageWidth);
        if(index < 0)
            index = 0;
        if(index > imageViewArr.count -1)
            index = imageViewArr.count - 1;
        UIImageView* imageView = [imageViewArr objectAtIndex:index];
        imageView.layer.zPosition = 0;
        if([SlideImagedelegate respondsToSelector:@selector(SlideScrollViewDidEndClick:)]) //执行点击处理函数
            [SlideImagedelegate SlideScrollViewDidEndClick:index];
    }
}

@end

@implementation SlideImageView
@synthesize _zMarginValue, _xMarginValue, _angleValue, _alphaValue;
@synthesize _imageArray;
@synthesize delegate;


- (id)init //默认初始化为全屏
{
    CGRect frame = {{0,0},{320,460}};
    self = [super initWithFrame:frame];
    if(self)
    {
        _index = -1;
        _imageViewArray = [[NSMutableArray alloc]init ];
        _scrollImageArray = [[NSMutableArray alloc]init ];
        _scrollView = [[SlideScrollView alloc]initWithFrame:frame];
        //_scrollview 添加手势处理
        UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewDidLongTapGesture:)]; //创建点击手势
        [_scrollView addGestureRecognizer:tapGestureRecognizer];
        [self addSubview:_moveView];
        [self addSubview:_scrollView];
        
        _zMarginValue = 10.f;
        _xMarginValue = 10.f;
        _angleValue = 0.f;
        _alphaValue = 1000;
        _shadowAlpha = 0;
        _shadowValueX = 0;
        _shadowValueY = 0;
        _imageArray = [[NSMutableArray alloc]init ];
        delegate = nil;
        //设置子视图透视投影
        CATransform3D sublayerTransform = CATransform3DIdentity; //单位矩阵
        sublayerTransform.m34 = -0.02;
        [_moveView.layer setSublayerTransform:sublayerTransform];
        [_scrollView.layer setSublayerTransform:sublayerTransform];
    }
    return self;
}

#pragma mark - 
#pragma mark interface function

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _index = -1;
        _imageViewArray = [[NSMutableArray alloc]init ];
        _scrollImageArray = [[NSMutableArray alloc]init ];
        frame.origin = CGPointMake(0, 0);
        _moveView = [[UIView alloc]initWithFrame:frame];
        _scrollView = [[SlideScrollView alloc]initWithFrame:frame];
        ///_scrollview 添加手势处理
        UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewDidLongTapGesture:)]; //创建点击手势
        [_scrollView addGestureRecognizer:tapGestureRecognizer];
        [self addSubview:_moveView];
        [self addSubview:_scrollView];
        
        _zMarginValue = 0.f;
        _xMarginValue = 0.f;
        _angleValue = 0.f;
        _alphaValue = 1000;
        _shadowAlpha = 0;
        _shadowValueX = 0;
        _shadowValueY = 0;
        _imageArray = [[NSMutableArray alloc]init ];
        delegate = nil;
        //设置子视图透视投影
        CATransform3D sublayerTransform = CATransform3DIdentity; //单位矩阵
        sublayerTransform.m34 = -0.02;
        [_moveView.layer setSublayerTransform:sublayerTransform];
        [_scrollView.layer setSublayerTransform:sublayerTransform];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame ZMarginValue:(float)zMarginValue 
       XMarginValue:(float)xMarginValue AngleValue:(float)angleValue Alpha:(float)alphaValue
{
    self = [super initWithFrame:frame];
    if (self) {
        _index = -1;
        _imageViewArray = [[NSMutableArray alloc]init ];
        _scrollImageArray = [[NSMutableArray alloc]init ];
        frame.origin = CGPointMake(0, 0);
        _moveView = [[UIView alloc]initWithFrame:frame];
        _scrollView = [[SlideScrollView alloc]initWithFrame:frame];
        //_scrollview 添加手势处理
        //        UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewDidLongTapGesture:)]; //创建点击手势
        //        [_scrollView addGestureRecognizer:tapGestureRecognizer];
        [self addSubview:_moveView];
        [self addSubview:_scrollView];
        
        _zMarginValue = zMarginValue;
        _xMarginValue = xMarginValue;
        _angleValue = angleValue;
        _alphaValue = alphaValue;
        _shadowAlpha = 0;
        _shadowValueX = 0;
        _shadowValueY = 0;
        _imageArray = [[NSMutableArray alloc]init ];
        delegate = nil;
        //设置子视图透视投影
        CATransform3D sublayerTransform = CATransform3DIdentity; //单位矩阵
        sublayerTransform.m34 = -0.002;
        [_moveView.layer setSublayerTransform:sublayerTransform];
        [_scrollView.layer setSublayerTransform:sublayerTransform];
    }
    return self;
}

- (void)setImageShadowsWtihDirectionX:(float)value_X Y:(float)value_Y Alpha:(float)alphaValue//设置图片阴影的x,y方向的值和透明度
{
    _shadowAlpha = alphaValue;
    _shadowValueX = value_X;
    _shadowValueY = value_Y;
}

- (void) addImage:(UIImage *)image //添加图片数据
{
    UIImage* resizeImage = [self ImageWithSize:image toSize:self.frame.size];//调整图片尺寸
    [_imageArray addObject:resizeImage];
}

- (void)reLoadUIview   //重新加载UI
{
    //清理滚动视图数据
    if(_scrollImageArray.count > 0)
    {
        for(UIImageView* imageView in _scrollImageArray)
            [imageView removeFromSuperview];
        [_scrollImageArray removeAllObjects];
    }
    //清理弹压视图数据
    if(_imageViewArray.count > 0) 
    {
        for(UIImageView* imageView in _imageViewArray)
            [imageView removeFromSuperview];
        [_imageViewArray removeAllObjects];
    }
    if(_imageArray.count > 0) //有数据
    {
        _index = 0;
        //加载滚动视图数据
        [self loadScrollView];
        //加载弹压视图数据
        [self loadImageView];
    }
}

#pragma mark - 
#pragma mark private function

- (void)loadScrollView //加载滚动视图数据
{
    CGSize viewSize = self.frame.size;
    float width = viewSize.width; //图宽
    for(int i=0; i<_imageArray.count; i++)
    {
        UIImage* image = [_imageArray objectAtIndex:i];
        CGPoint point = CGPointMake(i*width, 0); //坐标
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(point.x, point.y, viewSize.width, viewSize.height)];
        imageView.image = image;
        imageView.layer.transform = CATransform3DMakeRotation(_angleValue, 0, -1, 0);//设置角度
        if(i != 0 )
            imageView.hidden = YES;
        //设置图片的阴影
        UIBezierPath* shadowPath = [UIBezierPath bezierPathWithRect:imageView.bounds];
        imageView.layer.shadowPath = shadowPath.CGPath;
        imageView.layer.shadowOffset = CGSizeMake(_shadowValueX, _shadowValueY);
        imageView.layer.shadowOpacity = _shadowAlpha;
        //设置边框
        if(self.borderColor)
        {
            imageView.layer.borderColor = self.borderColor.CGColor;
            imageView.layer.borderWidth = 2.f;
        }
        else
            imageView.layer.borderWidth = 0.f;
        
        //添加到视图与数组中
        [_scrollImageArray addObject:imageView];
        [_scrollView addSubview:imageView];
    }
    //设置滚动视图属性
    if(_scrollImageArray.count > 1)
        _scrollView.contentSize = CGSizeMake(width*_scrollImageArray.count, viewSize.height);
    else
        _scrollView.contentSize = CGSizeMake(width*_scrollImageArray.count+20, viewSize.height);
    _scrollView.contentOffset = CGPointMake(0, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.autoresizingMask = YES;
    _scrollView.clipsToBounds = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.SlideImagedelegate = self;
    _scrollView.imageViewArr = _scrollImageArray;
    _scrollView.imageWidth = width;
}

- (void)loadImageView //加载弹压视图数据
{
    float width = self.frame.size.width;
    float height = self.frame.size.height; 
    //加载循环
    for(int i=0; i<_imageArray.count; i++)
    {
        UIImage* image = [_imageArray objectAtIndex:i];
        // 设置每张图片的坐标，z值和透明度
        CGPoint point = CGPointMake(i*width/_xMarginValue, 0); 
        float zPosition = -i*width/_zMarginValue;
        float alpha = 1 - i*width/_alphaValue;
        
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(point.x, point.y, width,height)];
        imageView.image = image;
        imageView.layer.transform = CATransform3DMakeRotation(_angleValue, 0, -1, 0);//设置角度
        imageView.layer.zPosition = zPosition; // Z坐标
        imageView.alpha = alpha;
        //设置图片的阴影
        UIBezierPath* shadowPath = [UIBezierPath bezierPathWithRect:imageView.bounds];
        imageView.layer.shadowPath = shadowPath.CGPath;
        imageView.layer.shadowOffset = CGSizeMake(_shadowValueX, _shadowValueY);
        imageView.layer.shadowOpacity = _shadowAlpha;
        //设置边框
        if(self.borderColor)
        {
            imageView.layer.borderColor = self.borderColor.CGColor;
            imageView.layer.borderWidth = 2.f;
        }
        else
            imageView.layer.borderWidth = 0.f;
        //添加到视图与数组中
        if(i == 0)
            imageView.hidden = YES;
        [_imageViewArray addObject:imageView];
        [_moveView addSubview:imageView];
    }
}

- (UIImage *)ImageWithSize:(UIImage *)image toSize:(CGSize)reSize //按尺寸缩放图片
{
    UIGraphicsBeginImageContext(reSize);
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

#pragma mark - delegate function
#pragma mark UIScrollView delegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView //滚动时处理
{
    float offset_x = scrollView.contentOffset.x;
    float width = scrollView.frame.size.width; //视图宽度
    float height = scrollView.frame.size.height; //高度
    //改变图片角度
    for(int i=0; i<_imageViewArray.count; i++)
    {
        //调整滚动视图图片的角度
        UIImageView* scrollImageView = [_scrollImageArray objectAtIndex:i];
        float currOrigin_x = i * width; //当前图片的x坐标
        float angleValue = (offset_x-currOrigin_x)/width - _angleValue;
        if(angleValue < -_angleValue) //设置偏移极限
            angleValue = -_angleValue;
        if(angleValue > _alphaValue)
            angleValue = _alphaValue;
        scrollImageView.layer.transform = CATransform3DMakeRotation(angleValue, 0, 1, 0); //改变角度
        if(currOrigin_x - offset_x>0)
        {
            if(i != 0)
                scrollImageView.hidden = YES;
        }
        else
            scrollImageView.hidden = NO;
        
        //调整弹压视图图片的角度
        float range_x = (currOrigin_x-offset_x)/_xMarginValue;
        UIImageView* moveImageView = [_imageViewArray objectAtIndex:i];
        moveImageView.frame = CGRectMake(range_x, 0, width, height);
        if(range_x <= 0) // 如果超过当前滑动视图便隐藏
            moveImageView.hidden = YES;
        else
        {
            if(i != 0)
                moveImageView.hidden = NO;
        }
        //调整弹压视图的z值
        float range_z = (offset_x-currOrigin_x)/_zMarginValue;
        moveImageView.layer.zPosition = range_z;
        //调整弹压视图的透明度
        float alpha = 1.f - (currOrigin_x-offset_x)/_alphaValue;
        moveImageView.alpha = alpha;
    }
    _index = roundf(offset_x/width); //得到索引
    //代理滚动时回调函数
    if([delegate respondsToSelector:@selector(SlideImageViewDidScrollWithIndex:)])
        [delegate SlideImageViewDidScrollWithIndex:_index];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    for(UIImageView* imageView in _scrollImageArray)  //调整所有图片的z值
        imageView.layer.zPosition = 0;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView //滚动结束处理
{
    if([delegate respondsToSelector:@selector(SlideImageViewDidEndScorllWithIndex:)])
    {
        [delegate SlideImageViewDidEndScorllWithIndex:_index];
    }
}

#pragma mark Sli SlideScrollViewDelegate
- (void)SlideScrollViewDidEndClick:(int)index
{
    if([delegate respondsToSelector:@selector(SlideImageViewDidClickWithIndex:)])
    {
        [delegate SlideImageViewDidClickWithIndex:_index];
    }
}

@end
