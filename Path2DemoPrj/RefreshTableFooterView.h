
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#ifndef REFRESHENUM
#define REFRESHENUM
typedef enum{
	PullRefreshPulling = 0,
	PullRefreshNormal,
	PullRefreshLoading,	
} PullRefreshState;
#endif

@protocol RefreshTableFooterViewDelegate;
@interface RefreshTableFooterView : UIView
{
    id __unsafe_unretained _delegate;
	PullRefreshState _state;
    
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
    
    CGFloat mSuperContentHeight;
    CGFloat mSuperScollHeight;
    CGFloat mRightToShowOffset;
    CGFloat mPosBetweenNormalAndPullOffset;
}

@property(nonatomic,unsafe_unretained) id <RefreshTableFooterViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame SuperScollHeight:(CGFloat)scollHeight;
- (void)refreshFrameBySuperContetnHeight:(CGFloat)contentHeight;
- (void)refreshLastUpdatedDate;
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end
@protocol RefreshTableFooterViewDelegate
- (void)refreshTableFooterDidTriggerRefresh:(RefreshTableFooterView*)view;
- (BOOL)refreshTableFooterDataSourceIsLoading:(RefreshTableFooterView*)view;
@optional
- (NSDate*)refreshTableFooterDataSourceLastUpdated:(RefreshTableFooterView*)view;

@end
