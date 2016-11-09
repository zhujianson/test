//
//  NewsViewCon.h
//  News
//
//  Created by xgh on 12-4-6.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	EGOOPullRefreshPulling = 0,
	EGOOPullRefreshNormal,
	EGOOPullRefreshLoading,	
} EGOPullRefreshState;

@protocol EGORefreshTableHeaderDelegate;
@interface EGORefreshTableHeaderView : UIView {	
	id _delegate;
	EGOPullRefreshState _state;
	
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIImageView *_imageView;
	UIActivityIndicatorView *_activityView;
    NSTimer * _Timer;

}

@property(nonatomic,assign) id <EGORefreshTableHeaderDelegate> delegate;

- (void)refreshLastUpdatedDate;
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
- (void)refreshHeaderView:(id)sender;

@end
@protocol EGORefreshTableHeaderDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view;
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view;
@optional
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view;
@end