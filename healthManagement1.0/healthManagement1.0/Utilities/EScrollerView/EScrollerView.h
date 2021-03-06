//
//  EScrollerView.h
//  icoiniPad
//
//  Created by Ethan on 12-11-24.
//
//

#import <UIKit/UIKit.h>
#import "MyPageViewController.h"

@protocol EScrollerViewDelegate <NSObject>

@optional

- (void)touchAdvertising:(NSDictionary*)dic;

- (void)changeViewDataWith:(int)page;//改变页面赋值

@end

@interface EScrollerView : UIView<UIScrollViewDelegate>
{
	CGRect viewSize;
	UIScrollView *scrollView;
	NSMutableArray *imageArray;
    MyPageViewController *pageControl;
    UILabel *noteTitle;
	
	int pageNum;
	
	int cpage;
	
	long m_lastTime;
	
	NSTimer *m_playPicTimer;
    
    NSString *m_imagePath;
    
    BOOL m_isAuto;
}

@property (nonatomic, assign)id<EScrollerViewDelegate> delegate;

@property(nonatomic,assign)BOOL showPageControl;

@property(nonatomic,assign)int pageNum;

- (id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr isAutoPlay:(BOOL)isAuto setImageKey:(NSString*)imageKey;// pathSuffix:(NSString*)path;

- (int)getCpage;

- (void)startPlayAdv;

- (void)pausePlayAdv;

- (void)setShowImageViewIndex:(int)index;

- (void)setCreatBackViewStr:(NSMutableArray*)str;

- (void)setUpPageControlCenterX;

@end
