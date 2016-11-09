//
//  DiaryModelView.h
//  jiuhaohealth4.0
//
//  Created by jiuhao-yangshuo on 15-6-15.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.

// 处理VC里面业务逻辑不强的业务

#import <UIKit/UIKit.h>
#import "DiraryHistoryType.h"

@protocol reFreshTableViewDelegate <NSObject>

@optional
-(void)refrehTableView;

@end

static NSString  *const kIdKeyString = @"user_no";

@interface DiaryModelView : NSObject

//根据预警状态改变 控件颜色
+ (void)changeButtonValueColorWithWarning:(NSString *)warning withButton:(UIView *)targetView;

//进餐时间段数组
+ (NSArray *)obtainTimeSectionArray;

//获取索引
+ (int)obtainIndexTimeSectionArray:( DiraryTimeType )m_DiraryTimeType;

//获得当前时间上个月
+ (long)getLongTimeWithOff:(int)offMonth;

//获得当前时间上个月
+ (long)getLongTimeWithOffDay:(int)offDay;

//2014-
+ (unsigned long)getLongTimeWithDate1:(NSString*)dateString;

//得到部位对照表
+ (NSDictionary *)getPartFile;

//得到对应时间
+(NSString *)mixtureTimeString:(NSNumber*)timeSelect;

//去掉重复
+(NSArray *)obtainArrayWithoutDuplicates:(NSArray *)origelArray;

+ (NSMutableAttributedString *)replaceRedColorWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )s TextColor:(NSString*)coler andThreeNSString:(NSString*)three andThreeColor:(NSString*)tColor;

//预警标示
+ (void)changeUIViewNumerColorWithView:(UIView *)targetView  andWithDataType:(DiraryHistoryType)m_diaryType andWithDict:(NSDictionary *)dict withTwoLine:(BOOL)twoLine withWarning:(NSString *)warning;

+(int)getMonthDaysWithDate:(NSDate *)selectedDate;

+(NSString *)getTimeWithKey:(NSString *)keyStr;

+(void)saveTimeWithKey:(NSString *)keyStr withTimeStr:(NSString *)timeStr;

@end
