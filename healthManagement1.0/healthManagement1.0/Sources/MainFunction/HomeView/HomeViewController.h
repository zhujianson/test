//
//  HomeViewController.h
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-8-16.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "IconOperationQueue.h"
#import "Common.h"
#import "EGORefreshTableHeaderView.h"
#import "EScrollerView.h"

@interface HomeViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, EScrollerViewDelegate>
{
//    UIView *m_headerView;
    
    UITableView *m_tableView;
    NSMutableArray *m_array;
	
	NSMutableArray *m_sequenceArray;//顺序数组
	
//	IconOperationQueue *m_OperationQueue;
    EGORefreshTableHeaderView *m_refreshHeaderView;
    
	float m_lastScrollOfferY;
	float m_lastScrollOfferY2;
    
//	BOOL m_isShow;
//	BOOL m_show;
//	BOOL m_stop;

    UIView *m_record;
    
    BOOL m_reloading;
    
//    NSMutableDictionary *m_msgDic;
	
//    UIView *m_viewu;
    
    long m_lastNewShowVC;
    
    long m_lastShowTime;
    EScrollerView *m_advScroller;
    
}

@end
