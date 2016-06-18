//
//  FTPagingViewController.m
//  FTAPP
//
//  Created by Boyce on 7/8/15.
//  Copyright (c) 2015 XSpace. All rights reserved.
//

#import "FTPagingViewController.h"
#import "UIView+FTAdditions.h"
#import "FTScrollView.h"
 

#define TOP_BAR_HEIGHT  64.0
#define ITEM_BUTTON_FIXED_WIDTH     80.0

@interface FTPagingViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UINavigationController *navigationVC;

@property (nonatomic, strong) UIScrollView *bodyScrollView;

@property (nonatomic, assign) NSUInteger continueDraggingNumber;
@property (nonatomic, assign) CGFloat startOffsetX;
@property (nonatomic, assign) NSUInteger currentTabSelected;

@property (nonatomic, assign) BOOL isBuildUI;
@property (nonatomic, assign) BOOL isUseDragging; //是否使用手拖动的，自动的就设置为NO
@property (nonatomic, assign) BOOL isEndDecelerating;

@property (nonatomic, strong) UIView *tabView;
@property (nonatomic, strong) UIView *tabSelectedLine;
@property (nonatomic, strong) NSMutableArray *tabButtons;
@property (nonatomic, strong) NSMutableArray *badgeViews; //按钮上的红点
@property (nonatomic, strong) UIView *selectedLine;
@property (nonatomic, assign) CGFloat selectedLineOffsetXBeforeMoving;

@property (nonatomic, strong) NSArray *badges;

@end


@implementation FTPagingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSAssert([self.viewControllers count] == [self.titles count], @"The count of titles and viewControllers should be equal");
    
    [self buildUI];
    [self selectTabWithIndex:0 animate:NO withType:FTPagingViewSelectionTypeClick];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (instancetype)initWithViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles {
    self = [super init];
    if (self) {
        self.viewControllers = viewControllers;
        self.titles = titles;
        
        for (int i = 0; i < [self.viewControllers count]; i++) {
            UIViewController *vc = [self.viewControllers objectAtIndex:i];
            [vc setAutomaticallyAdjustsScrollViewInsets:NO];
            [self addChildViewController:vc];
            [vc didMoveToParentViewController:self];
        }
        
    }
    return self;
}

- (CGSize)titleSize:(NSString *)title {
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:self.tabButtonFontSize]} context:nil].size;
    return titleSize;
}

- (void)buildUI {
    _isBuildUI = NO;
    _isUseDragging = NO;
    _isEndDecelerating = YES;
    _startOffsetX = 0;
    _continueDraggingNumber = 0;
    
    for (int i = 0; i < [self.viewControllers count]; i++) {
        //ScrollView部分
        UIViewController *vc = [self.viewControllers objectAtIndex:i];
        vc.view.frame = self.view.frame;
        [self.bodyScrollView addSubview:vc.view];
        
        // tab 上按钮
        UIButton* itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton setFrame:CGRectMake(self.tabMargin + ITEM_BUTTON_FIXED_WIDTH * i, 0, ITEM_BUTTON_FIXED_WIDTH, 44.0)];
        [itemButton.titleLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [itemButton.titleLabel setFont:[UIFont boldSystemFontOfSize:self.tabButtonFontSize]];
        [itemButton setTitle:[self.titles objectAtIndex:i] forState:UIControlStateNormal];
        [itemButton setTitleColor:self.tabButtonTitleColorForNormal forState:UIControlStateNormal];
        [itemButton setTitleColor:self.tabButtonTitleColorForSelected forState:UIControlStateSelected];
        [itemButton addTarget:self action:@selector(onTabButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.tag = i;
        [self.tabButtons addObject:itemButton];
        [self.tabView addSubview:itemButton];
    }
    
    //tabView
    [self.tabView setBackgroundColor:[UIColor clearColor]];
    _isBuildUI = YES;
    [self layoutSubviews];
}

- (CGSize)buttonTitleRealSize:(UIButton *)button {
    CGSize size = CGSizeZero;
    size = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    return size;
}

- (void)layoutSubviews {
    if (_isBuildUI) {
        self.bodyScrollView.contentSize = CGSizeMake(self.view.width * [self.viewControllers count], self.bodyScrollView.height - TOP_BAR_HEIGHT);
        for (int i = 0; i < [self.viewControllers count]; i++) {
            UIViewController *vc = self.viewControllers[i];
            vc.view.frame = CGRectMake(self.bodyScrollView.width * i, TOP_BAR_HEIGHT, self.bodyScrollView.width, self.bodyScrollView.height - TOP_BAR_HEIGHT);
            [vc.view layoutIfNeeded];
        }
    }
}

#pragma mark - Tab

- (void)onTabButtonSelected:(UIButton *)button {
    [self selectTabWithIndex:button.tag animate:YES withType:FTPagingViewSelectionTypeClick];
}

- (void)selectTabWithIndex:(NSUInteger)index animate:(BOOL)isAnimate withType:(FTPagingViewSelectionType)type{
    if (index >= self.tabButtons.count) {
        return;
    }
    
    UIButton *preButton = self.tabButtons[self.currentTabSelected];
    preButton.selected = NO;
    UIButton *currentButton = self.tabButtons[index];
    currentButton.selected = YES;
    
    _currentTabSelected = index;
    
    void(^moveSelectedLine)(void) = ^(void) {
        self.selectedLine.center = CGPointMake(currentButton.center.x, self.selectedLine.center.y);
        self.selectedLineOffsetXBeforeMoving = self.selectedLine.origin.x;
    };
    
    //移动select line
    if (isAnimate) {
        [UIView animateWithDuration:0.3 animations:^{
            moveSelectedLine();
        }];
    } else {
        moveSelectedLine();
    }
    
    [self switchWithIndex:index animate:isAnimate];
    
    UIViewController <FTPagingViewControllerProtocol> *vc = self.viewControllers[index];
    self.title = vc.title;
    
    if ([vc respondsToSelector:@selector(leftNavigationBarItemsInPagingViewController:)]) {
        self.navigationItem.leftBarButtonItems = [vc leftNavigationBarItemsInPagingViewController:self];
    } else {
        self.navigationItem.leftBarButtonItems = nil;
    }
    
    if ([vc respondsToSelector:@selector(rightNavigationBarItemsInPagingViewController:)]) {
        self.navigationItem.rightBarButtonItems = [vc rightNavigationBarItemsInPagingViewController:self];
    } else {
        self.navigationItem.rightBarButtonItems = nil;
    }
    
    if ([vc respondsToSelector:@selector(didSelectedByPagingViewController:withSelectionType:)]) {
        [vc didSelectedByPagingViewController:self withSelectionType:type];
    }
    
    // 处理 Scroll To Top 属性
    for (int i = 0; i < [self.viewControllers count]; i++) {
        UIViewController *otherVC = self.viewControllers[i];
        if (i == index) {
            for (UIScrollView *view in otherVC.view.subviews) {
                if ([view isKindOfClass:[UITableView class]] || [view isKindOfClass:[UICollectionView class]]) {
                    view.scrollsToTop = YES;
                    continue;
                }
            }
        } else {
            for (UIScrollView *view in otherVC.view.subviews) {
                if ([view isKindOfClass:[UITableView class]] || [view isKindOfClass:[UICollectionView class]] || [view isKindOfClass:[UIScrollView class]]) {
                    view.scrollsToTop = NO;
                }
            }
        }
    }
}

/*!
 * @brief Selected Line跟随移动
 */
- (void)moveSelectedLineByScrollWithOffsetX:(CGFloat)offsetX {
    CGFloat textGap = (self.view.width / 2 - self.tabMargin * 2 - self.selectedLine.width * self.tabButtons.count) / (self.tabButtons.count * 2);
    CGFloat speed = 50;
    //移动的距离
    CGFloat movedFloat = self.selectedLineOffsetXBeforeMoving + (offsetX * (textGap + self.selectedLine.width + speed)) / [UIScreen mainScreen].bounds.size.width;
    //最大右移值
    CGFloat selectedLineRightBarrier = _selectedLineOffsetXBeforeMoving + textGap * 2 + self.selectedLine.width;
    //最大左移值
    CGFloat selectedLineLeftBarrier = _selectedLineOffsetXBeforeMoving - textGap * 2 - self.selectedLine.width;
    CGFloat selectedLineNewX = 0;
    
    //连续拖动时的处理
    BOOL isContinueDragging = NO;
    if (_continueDraggingNumber > 1) {
        isContinueDragging = YES;
    }
    
    if (movedFloat > selectedLineRightBarrier && !isContinueDragging) {
        //右慢拖动设置拦截
        selectedLineNewX = selectedLineRightBarrier;
    } else if (movedFloat < selectedLineLeftBarrier && !isContinueDragging) {
        //左慢拖动设置的拦截
        selectedLineNewX = selectedLineLeftBarrier;
    } else {
        //连续拖动可能超过总长的情况需要拦截
        if (isContinueDragging) {
            if (movedFloat > self.view.width - (self.tabMargin + textGap + self.selectedLine.width)) {
                selectedLineNewX = self.view.width - (self.tabMargin + textGap + self.selectedLine.width);
            } else if (movedFloat < self.tabMargin + textGap) {
                selectedLineNewX = self.tabMargin + textGap;
            } else {
                selectedLineNewX = movedFloat;
            }
        } else {
            //无拦截移动
            selectedLineNewX = movedFloat;
        }
    }
    [self.selectedLine setFrame:CGRectMake(selectedLineNewX, self.selectedLine.frame.origin.y, self.selectedLine.frame.size.width, self.selectedLine.frame.size.height)];
}


#pragma mark - BodyScrollView

- (void)switchWithIndex:(NSUInteger)index animate:(BOOL)isAnimate {
    [self.bodyScrollView setContentOffset:CGPointMake(index*self.view.width, 0) animated:isAnimate];
    _isUseDragging = NO;
}


#pragma mark - ScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.bodyScrollView) {
        _continueDraggingNumber += 1;
        if (_isEndDecelerating) {
            _startOffsetX = scrollView.contentOffset.x;
        }
        _isUseDragging = YES;
        _isEndDecelerating = NO;
    }
}

/*!
 * @brief 对拖动过程中的处理
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.bodyScrollView) {
        CGFloat movingOffsetX = scrollView.contentOffset.x - _startOffsetX;
        if (_isUseDragging) {
            //tab处理事件待完成
            [self moveSelectedLineByScrollWithOffsetX:movingOffsetX];
        }
    }
}

/*!
 * @brief 手释放后pager归位后的处理
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.bodyScrollView) {
        [self selectTabWithIndex:(int)scrollView.contentOffset.x / self.view.bounds.size.width animate:YES withType:FTPagingViewSelectionTypeScroll];
        _isUseDragging = YES;
        _isEndDecelerating = YES;
        _continueDraggingNumber = 0;
    }
}

/*!
 * @brief 自动停止
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.bodyScrollView) {
        //tab处理事件待完成
        [self selectTabWithIndex:(int)scrollView.contentOffset.x / self.view.bounds.size.width animate:YES withType:FTPagingViewSelectionTypeScroll];
    }
}


#pragma mark - Setter/Getter

- (UIView *)tabView {
    if (!_tabView) {
        self.tabView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width/2, 44.0)];
        self.navigationItem.titleView = _tabView;
        _tabView.backgroundColor = [UIColor blackColor];
    }
    return _tabView;
}
- (NSMutableArray *)tabButtons {
    if (!_tabButtons) {
        self.tabButtons = [[NSMutableArray alloc] init];
    }
    return _tabButtons;
}

- (NSMutableArray *)badgeViews {
    if (!_badgeViews) {
        self.badgeViews = [[NSMutableArray alloc] init];
    }
    return _badgeViews;
}

- (CGFloat)tabMargin {
    if (!_tabMargin) {
        self.tabMargin = (self.tabView.width - self.viewControllers.count * ITEM_BUTTON_FIXED_WIDTH) / 2;
    }
    return _tabMargin;
}
- (NSUInteger)currentTabSelected {
    if (!_currentTabSelected) {
        self.currentTabSelected = 0;
    }
    return _currentTabSelected;
}

- (CGFloat)tabButtonFontSize {
    if (!_tabButtonFontSize) {
        self.tabButtonFontSize = 16;
    }
    return _tabButtonFontSize;
}
- (UIColor *)tabButtonTitleColorForNormal {
    if (!_tabButtonTitleColorForNormal) {
        self.tabButtonTitleColorForNormal = [UIColor whiteColor];
    }
    return _tabButtonTitleColorForNormal;
}
- (UIColor *)tabButtonTitleColorForSelected {
    if (!_tabButtonTitleColorForSelected) {
        self.tabButtonTitleColorForSelected = [UIColor whiteColor];
    }
    return _tabButtonTitleColorForSelected;
}
- (UIView *)selectedLine {
    if (!_selectedLine) {
        self.selectedLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.tabView.height - 2, self.selectedLineWidth, 2)];
        _selectedLine.backgroundColor = [UIColor whiteColor];
        [self.tabView addSubview:_selectedLine];
    }
    return _selectedLine;
}
- (CGFloat)selectedLineWidth {
    if (!_selectedLineWidth) {
        self.selectedLineWidth = 42;
    }
    return _selectedLineWidth;
}
- (CGFloat)selectedLineOffsetXBeforeMoving {
    if (!_selectedLineOffsetXBeforeMoving) {
        self.selectedLineOffsetXBeforeMoving = 0;
    }
    return _selectedLineOffsetXBeforeMoving;
}

- (UIScrollView*)bodyScrollView {
    if (!_bodyScrollView) {
        self.bodyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _bodyScrollView.delegate = self;
        _bodyScrollView.pagingEnabled = YES;
        _bodyScrollView.userInteractionEnabled = YES;
        _bodyScrollView.bounces = YES;
        _bodyScrollView.showsHorizontalScrollIndicator = NO;
        _bodyScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        _bodyScrollView.scrollsToTop = NO;
        
        [self.view addSubview:_bodyScrollView];
    }
    return _bodyScrollView;
}

#pragma mark - Autorotate

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
