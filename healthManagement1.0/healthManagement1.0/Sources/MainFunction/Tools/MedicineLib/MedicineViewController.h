//
//  MedicineViewController.h
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-7.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedicineListViewController.h"

typedef void (^IsSearchingBlock)(BOOL yes);

@interface MedicineViewController : CommonViewController
<UISearchBarDelegate, UISearchDisplayDelegate,
UITableViewDataSource, UITableViewDelegate,
PhysicalPushDelegate> {
    UISearchDisplayController* _displayController; //搜索table
    NSMutableArray* physicalNameArr; //体检名称
    NSMutableArray* searchResults; //搜索数据
    NSMutableArray* pingyinArr; //体检拼音
    NSMutableDictionary* dataDic; //体检名称和体检简介
    
    MedicineListViewController* medicineVC;
    MBProgressHUD *m_progress_;
}

@property (nonatomic, retain) UISearchBar* searchBar; //搜索框
@property (nonatomic, copy) IsSearchingBlock isSearchingBlock;//是否正在搜索

@end
