
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

@protocol RefreshTableHeaderViewDelegate;

@interface RefreshTableHeaderView : UIView {
	
	id __unsafe_unretained _delegate;
	PullRefreshState _state;
    
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
}

@property(nonatomic,unsafe_unretained) id <RefreshTableHeaderViewDelegate> delegate;

- (void)refreshLastUpdatedDate;
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end

@protocol RefreshTableHeaderViewDelegate
- (void)refreshTableHeaderDidTriggerRefresh:(RefreshTableHeaderView*)view;
- (BOOL)refreshTableHeaderDataSourceIsLoading:(RefreshTableHeaderView*)view;
@optional
- (NSDate*)refreshTableHeaderDataSourceLastUpdated:(RefreshTableHeaderView*)view;
@end
