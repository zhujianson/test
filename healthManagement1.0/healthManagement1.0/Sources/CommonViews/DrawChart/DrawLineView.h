//
//  DrawLineView.h
//  Adviser
//
//  Created by wangmin on 14-4-17.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDGraphView.h"

@interface DrawLineView : UIView

@property (nonatomic,retain) NSString *lineTitleString;//图标标题

@property (nonatomic,retain) NSMutableArray *lineMeansArray;//线条说明

@property (nonatomic,assign) TimeType currentTimeType;//时间类型
@property (nonatomic,assign) BOOL  isYClipTo5;//y轴是否切成5段
@property (nonatomic,assign) int minAndMaxOffset;//最大值-最小值偏移
@property (nonatomic,assign) BOOL oneValueAndRange;//只有一组数据
@property (nonatomic,assign) NSString *m_strType;//类型

@property (nonatomic,assign) BOOL  isNewSugarTrend;//新加 血糖趋势图

@property (nonatomic,assign) BOOL  isThin;//新加 享瘦派

- (void)setDataPoints:(NSArray *)dataPoints dataPoints2:(NSArray *)dataPoint2 timeArray:(NSArray *)timeArray;


//多条折线数据源传 multiDataArray 结构为 NSArray *array = @[@[@"",@""],@[@"",@""]];
//timeArray 时间轴 @[@"",@""]
//normalValueArray 正常值---个数对应于折线种类
//lineMeansArray 各折线意义
//multiLocalArray  血糖时，传递 不同类型数据在时间轴的位置 --- 同一时间测量不同值时 传nil
- (void)setLineDataArray:(NSArray *)multiDataArray andTimeArray:(NSArray *)timeArray normalValueArray:(NSArray *)normalValueArray lineMeansArray:(NSArray *)lineMeansArray  aboutMultiLocaInOriginalArray:(NSArray *)multiLocalArray;

- (void)reloadSubViews;
@end
