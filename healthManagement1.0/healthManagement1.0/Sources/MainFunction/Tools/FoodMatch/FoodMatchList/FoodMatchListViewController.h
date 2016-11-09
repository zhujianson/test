//
//  FoodMatchListViewController.h
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-8-6.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodMatchListViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
{
    UITableView *m_tableView;
    UISearchDisplayController *m_searchDisplay;
    
    NSMutableArray *m_array;
//    NSMutableArray *m_searchArray;
    NSMutableArray *m_nowArray;
    NSMutableArray *m_selArray;
    
    int m_SearchNum;
    
    UIScrollView *m_footerView;
    
    float m_butWidht;
    
    int m_maxTag;
}

@property (nonatomic, retain) NSMutableDictionary *m_dicInfo;

@end
