//
//  AlertManager.h
//  jiuhaohealth3.0
//
//  Created by jiuhao-yangshuo on 15-1-27.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HealthAlert.h"

@interface AlertManager : NSObject

///  返回血压,血糖的闹钟字典
///
///  @param alertTag suger/blood
///
///  @return dict
+ (NSDictionary *)getAlertWithTag:(NSString *)alertTag;

///  开启某一个通知
///
///  @param clockDictionary 闹钟字典
+ (void)postLocalNotification:(NSDictionary *)clockDictionary;

//开启计步器通知
+ (void)postSteperLocalNotification:(NSDictionary *)clockDictionary;

//打开闹钟
+ (void)startClock:(NSDictionary *)clock;

//关闭
+ (void)shutdownClock:(NSString *)clockID;

//刷新提醒根据用户
+ (void)reStartAllAlert;

//获取账号下闹钟列表
+ (NSArray *)getAllAlertList;

///  开启闹钟
///
///  @param startDate 响应时间  idString 本地标示(凌晨 早前 早后 午前 午后)
+ (void)startNextSugerClockAfterNumMinutes:(NSInteger) afterMinutes withIdString:(NSString *)idString withUserId:(NSString *)userId;

///  根据标示获取相隔时间
///
///  @param idString 标示 序号
///
///  @return 间隔时间
+ (NSTimeInterval)getNextSugerClockWithIdString:(NSString *)idString withUserId:(NSString *)userId;

///  根据标示获取相隔时间
///
///  @param idString  标示 序号
///
///  @return 存在响应的闹钟
+ (BOOL)getHaveSugerClockWithIdString:(NSString *)idString;

//生成自定义的id
+(NSString *)createAlertIdWithDateString:(NSString *)dateString withUserId:(NSString *)userId withCurrunteMainId:(NSString *)curruteMainUserId;

@end
