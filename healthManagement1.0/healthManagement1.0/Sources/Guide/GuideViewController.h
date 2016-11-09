//
//  ViewController.h
//  GuideViewController
//
//  Created by 发兵 杨 on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideViewController : UIViewController <UIScrollViewDelegate>
{
    UIButton				*gotoMainViewBtn;
    UIScrollView			*pageScroll;
//    UIView					*viewGO;
	
//	UIImageView				*m_regImage;
//	UIImageView				*m_selfImage;
//	
//	BOOL					m_isUpTouch;
//	AKTabBarController		*m_mainViewController;
	
	int m_nowShowViewTag;
    
//    UIPageControl *pageControl;
}

@end
