
#import "RefreshTableFooterView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

@interface RefreshTableFooterView (Private)
- (void)setState:(PullRefreshState)aState;
@end

@implementation RefreshTableFooterView 

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame SuperScollHeight:(CGFloat)scollHeight{
    if (self = [super initWithFrame:frame]) {
		
        mSuperContentHeight = frame.origin.y;
        mSuperScollHeight = scollHeight;
        mRightToShowOffset = mSuperContentHeight - mSuperScollHeight;
        mPosBetweenNormalAndPullOffset = mRightToShowOffset + 30;
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		//self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        //self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paperbackground2.png"]];
        /*
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 42.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		[label release];
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,24.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		*/
        
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(frame.size.width/2-10, 5.0f, 20.0f, 20.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"blueArrowForFooter.png"].CGImage;
        
         /*
         #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
         if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
         layer.contentsScale = [[UIScreen mainScreen] scale];
         }
         #endif
         */
         
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(frame.size.width/2-10,5.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		
		
		[self setState:PullRefreshNormal];
		
    }
	
    return self;
	
}

#pragma mark -
#pragma mark Setters

- (void) refreshFrameBySuperContetnHeight:(CGFloat)contentHeight
{
    mSuperContentHeight = MAX(contentHeight,mSuperScollHeight);
    [self setFrame:CGRectMake(self.frame.origin.x,mSuperContentHeight,self.frame.size.width,self.frame.size.height)];
    mRightToShowOffset = mSuperContentHeight - mSuperScollHeight;
    mPosBetweenNormalAndPullOffset = mRightToShowOffset + 30;
}
- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(refreshTableFooterDataSourceLastUpdated:)]) {		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"AM"];
		[formatter setPMSymbol:@"PM"];
		[formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
		//_lastUpdatedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [formatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"RefreshFooterTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}
    
}

- (void)setState:(PullRefreshState)aState{
	
	switch (aState) {
		case PullRefreshPulling:
			
			_statusLabel.text = NSLocalizedString(@"释放加载...", @"Release to refresh status");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case PullRefreshNormal:
			
			if (_state == PullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = NSLocalizedString(@"上拉加载...", @"Pull down to refresh status");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case PullRefreshLoading:
			
			_statusLabel.text = NSLocalizedString(@"载入中...", @"Loading Status");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	_state = aState;
}

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == PullRefreshLoading) 
    {
        
        CGFloat offset = MAX(scrollView.contentOffset.y - mRightToShowOffset, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, offset, 0.0f);
		
	} 
    else if (scrollView.isDragging) 
    {
        //NSLog(@"%f",scrollView.contentOffset.y);
        BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(refreshTableFooterDataSourceIsLoading:)]) 
        {
			_loading = [_delegate refreshTableFooterDataSourceIsLoading:self];
		}
		
		if (_state == PullRefreshPulling && scrollView.contentOffset.y <mPosBetweenNormalAndPullOffset && scrollView.contentOffset.y > mRightToShowOffset && !_loading) 
        {
			[self setState:PullRefreshNormal];
		} 
        else if (_state == PullRefreshNormal && scrollView.contentOffset.y >=mPosBetweenNormalAndPullOffset && !_loading) 
        {
			[self setState:PullRefreshPulling];
		}
		
		if (scrollView.contentInset.bottom != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(refreshTableFooterDataSourceIsLoading:)]) {
		_loading = [_delegate refreshTableFooterDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y >= mPosBetweenNormalAndPullOffset && !_loading) {
        [self setState:PullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
		[UIView commitAnimations];
		
		if ([_delegate respondsToSelector:@selector(refreshTableFooterDidTriggerRefresh:)]) {
			[_delegate refreshTableFooterDidTriggerRefresh:self];
		}
	}
}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	[self setState:PullRefreshNormal];
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
}


@end

