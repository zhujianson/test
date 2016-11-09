//
//  DiaryModelSuperViewController.h
//  jiuhaohealth4.0
//
//  Created by 徐国洪 on 15-5-12.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "Common.h"
#import "DiaryHistoryViewController.h"
#import "DiaryAddCellTableViewCell.h"

@interface DiaryModelSuperViewController : CommonViewController
{
    NSMutableDictionary *m_nowAddDic;
}

@property (nonatomic, assign) UITableView *m_tableView;
@property (nonatomic, assign) NSMutableArray *m_array;
@property (nonatomic, retain) NSIndexPath *m_lastIndexPath;
@property (nonatomic, retain) UIView *m_openView;
@property (nonatomic, assign) float m_rowHeight;
@property (nonatomic, assign) float m_rowOpenHeight;
//@property (nonatomic, assign) NSMutableDictionary *m_nowAddDic;

@property (nonatomic, assign) DiraryHistoryType m_diraryType;//类型    血压, 血糖 ...
@property (nonatomic, assign) DiraryTimeType m_DiraryTimeType;

- (void)getDataSource;

- (void)adjustCellSetSeparatorInsetWithCell:(UITableViewCell *)cell;

//处理删除 更新 添加数据逻辑
- (void)handleDataWithCell:(UITableViewCell *)cell;

- (void)handleDataUpdateAndAdjustUiWithDiaryEventType:(DiaryEventType)eventState andWithDict:(NSDictionary *)dict;

- (void)handleDataWithDataResult:(NSMutableArray *)dataArray;

- (void)delCell:(NSDictionary*)dic;

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
