//
//  MedicineListViewController.h
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-7.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhysicalProjectViewController.h"


@protocol PhysicalPushDelegate;
@interface MedicineListViewController : CommonViewController
<UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray* zimuArr; // abcd字母大全
//    NSMutableArray* noZimuArr; //数据中不存在该字母
    @public
    UITableView* dataTable;
}

@property (nonatomic, assign) id<PhysicalPushDelegate> myDelegate;
@property (nonatomic, retain) NSMutableArray* pingyinArrp;//数据源的拼音数组
@property (nonatomic, retain) NSMutableArray* nameArr;//数据源数组
@property (nonatomic, retain) NSMutableDictionary* nameIndexesDictionary;
@property (nonatomic, retain) NSMutableDictionary* allDataDictionary;
@property (nonatomic, retain) NSMutableArray* nameIndexesArray;
@property (nonatomic, retain) NSMutableArray* finalArray;//最终的列表数据源
@property (nonatomic, retain) NSMutableDictionary* dataDic;

/**
 *  刷新数据列表
 */
- (void)reloadListData;

@end
