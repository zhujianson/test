//
//  YRilView.h
//  jiuhaohealth3.0
//
//  Created by jiuhao-yangshuo on 15-1-12.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRGCalendarView.h"

//isDayOrMonth 是日期选择 还是月份选择
typedef void (^YRilViewBlock)(NSDate *selectDate,BOOL isDayOrMonth);

@interface YRilView : UIView

@property(nonatomic,retain)NSDate *selectedDate;
@property(nonatomic,retain) UIView *m_view;
-(void)setYRilViewBlockBlock:(YRilViewBlock)handler ;

//移除页面
- (void)removeView;

-(void)updateRillViewWithArray:(NSArray*)array;

- (void)selectDate:(NSDate *)date;

@end
