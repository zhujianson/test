//
//  TimeFrameView.h
//  jiuhaohealth4.0
//
//  Created by wangmin on 15-4-30.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TimeFrameViewTag 12322

@interface TimeFrameView : UIView

typedef void  (^SelectedTimeBlock)(long index);

typedef void  (^MultiSelectedBlock)(NSArray *selecedArray);


@property (nonatomic, assign) int selBut;//名字数组

@property (nonatomic,copy) SelectedTimeBlock selectedTimeBlock;

//多选用
@property (nonatomic,copy) MultiSelectedBlock selectedArrayBlock;//选中下标的数组

@property (nonatomic,retain) NSMutableArray  *selectedIndexArray;//初始化的选中数组

@property (nonatomic,assign) BOOL  multiSelectedFlag;//多选

@property (nonatomic,assign,setter=ishaveRandomButton:) BOOL haveRandomButton;//有随机按钮
//- (void)getViews;
- (id)initWithFrame:(CGRect)frame withArray:(NSArray*)array;

@end
