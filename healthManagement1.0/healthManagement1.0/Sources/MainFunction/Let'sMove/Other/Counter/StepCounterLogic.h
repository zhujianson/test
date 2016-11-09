//
//  StepCounterLogic.h
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-9-25.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RuningInBackground.h"

typedef void (^CallBackWithTimeCount)(int currentTimeCount);

typedef void (^CallBackWithUpNum)(NSInteger upNum);

typedef enum _MyTimerStatus
{
    notWork = 0,
    working = 1,
    pauseWorking = 2,
    endWorkingAuto = 3
}MyTimerStatus;

typedef enum _SteperMode
{
    normalMode = 0,
    TimingMode = 1,
    DistanceMode = 2
}SteperMode;


typedef enum _SteperStatus
{
    notWorkStatus = 0,
    indoorStatus = 1,
    outdoorStatus = 2
}SteperStatus;



@interface StepCounterLogic : NSObject

@property (nonatomic,assign) BOOL switchFlag;//开关

@property (nonatomic,retain) NSString *stepCount;//运动步数

@property (nonatomic,retain) NSString *speedString;//实时速度

@property (nonatomic,retain) NSString *costTimeString;//运动耗时

@property (nonatomic,retain) NSString *allCllString;//总卡路里

@property (nonatomic,assign) CGFloat weight;//体重

@property (nonatomic,assign) int targetStep;//目标步数

@property (nonatomic,assign) BOOL inBackGroundFlag;//是否在后台标志位

@property (nonatomic,assign) BOOL  notShowFailView;//是否显示上传失败提示 no 显示 yes 不显示


@property (nonatomic,assign) __block MyTimerStatus myTimerStatus;//定时器工作状态

@property (nonatomic,assign) int timeStepCount;//废弃

@property (nonatomic,copy) CallBackWithTimeCount callBackBlock;

@property (nonatomic,assign) BOOL isAutoClickPauseOnHistoryFlag;//查看历史时是否是自动设为暂停

@property (nonatomic,assign) BOOL isCheckHistoryFlag;//查看历史标识

@property (nonatomic,assign) BOOL isLoginFlag;//登录进去的标志位，防止计步数据混淆


@property (nonatomic,retain) NSString *modeStepCount;//模式步数
@property (nonatomic,retain) NSString *modeCllString;//模式卡路里
@property (nonatomic,assign) int timeCount;//模式时间计数
@property (nonatomic,assign) int allTimeCount;//起始计时时间

@property (nonatomic,assign) SteperStatus mySteperStatus;//计步器状态- 无模式 室内 室外

@property (nonatomic,assign) SteperMode mySteperMode; //计时器状态 无工作初始状态 工作状态 暂停 自动结束
//每次点击开始进入后需要对该属性进行初始化设置

@property (nonatomic,retain) NSMutableArray *locPointsArray;//位置点

@property (nonatomic,retain) NSMutableArray *dashPointsArray;//虚线点

@property (nonatomic,assign) BOOL lastPointIsDashFlag;//最后一条线是虚线

@property (nonatomic,assign) BOOL dashFirstFlag;//虚线作为起点

@property (nonatomic,assign) BOOL localFirstFlag;//实线作为起点

@property (nonatomic,assign) int targetModeDistance;//目标距离

@property (nonatomic,assign) int targetModeStepCount;//目标步数


@property (nonatomic,retain) RuningInBackground *runingInBack;

@property (nonatomic,assign) BOOL isSendLocalNotificationFlag;//是否发送了本地通知

@property (nonatomic,assign) BOOL isSendFinishNotificationFlag;//发送完成任务本地通知


@property (nonatomic,retain) NSArray *timePointArray;//8个时间监测点

@property (nonatomic,assign) NSUInteger localHistoryItemCount;

@property (nonatomic,copy) CallBackWithUpNum theCallBackWithUpNum;


@property (nonatomic,assign) int scoreValue;//步数得分

@property (nonatomic,assign) BOOL disableVoiceFlage;//语音播报有效


- (void)beginTimer;
- (void)pauseTimer;
- (void)resetTimer;


- (void)refreshData;

- (void)writeToFileWithCurrentDic;

- (void)sendToBackground;
- (void)stopBackTimer;


- (void)getCurrentDic;
- (void)uploadDataRequest;

- (void)startRuningInBackground;
- (void)stopRuningInBackground;

- (void)addOutdoorDataWithDistance:(double) distance speed:(double) speed;

- (void)loadServerDataWithDic:(NSDictionary *)dic;




@end