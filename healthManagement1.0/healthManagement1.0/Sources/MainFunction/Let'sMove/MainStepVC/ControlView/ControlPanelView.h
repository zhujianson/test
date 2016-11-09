//
//  ControlPanelView.h
//  jiuhaohealth4.0
//
//  Created by wangmin on 15-4-21.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void (^ButtonClickBlock) (BOOL start);

typedef void (^TimeCountingBlock)(int count);

typedef void (^CallBackBlock) (void);

@interface ControlPanelView : UIView


@property (nonatomic,retain) UIButton *modelBtn;//模式显示

@property (nonatomic,retain) UILabel *stepLabel;//步数显示

@property (nonatomic,retain) UILabel *timeLabel;//时间显示

@property (nonatomic,retain) UILabel *distanceLabel;//距离显示

@property (nonatomic,retain) UILabel *speedLabel;//速度显示

@property (nonatomic,retain) UILabel *calLabel;//卡路里显示

@property (nonatomic,copy) ButtonClickBlock lockBtnBlock;//开关block

@property (nonatomic,copy) ButtonClickBlock startBtnBlock;//开始暂停block

@property (nonatomic,copy) ButtonClickBlock endBtnBlock;//结束block

@property (nonatomic,assign) int timeCount;//时间计数
//@property (nonatomic,assign) __block MyTimerStatus myTimerStatus;//定时器工作状态

//@property (nonatomic,assign) SteperMode mySteperMode;

@property (nonatomic,copy) TimeCountingBlock myTimerCountingBlock;//计时回调

@property (nonatomic,retain) NSDictionary *modeDic;

@property (nonatomic,assign) BOOL isOutdoorView;

@property (nonatomic,assign) BOOL availableFlag;

@property (nonatomic,copy) CallBackBlock callBackBlock;

- (void)newValueForDistance:(NSString *)distance;
- (void)newValueForSpeed:(NSString *)speed;
- (void)newValueForCal:(NSString *)cal;
- (void)initValueForTime:(int)timeCount;

- (void)newProgress:(NSString *)stepCount;

- (void)startBtnClick:(UIButton *)btn;

- (BOOL)checkLocationEnable;

@end
