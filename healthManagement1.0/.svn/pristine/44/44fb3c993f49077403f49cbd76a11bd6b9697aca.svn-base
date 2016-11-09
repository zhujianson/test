//
//  AlertManager.m
//  jiuhaohealth3.0
//
//  Created by jiuhao-yangshuo on 15-1-27.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "AlertManager.h"
#import "HealthAlert.h"
#import "DBOperate.h"
#import "DiaryModelView.h"
#import "NotificationViews.h"

@implementation AlertManager

+(NSDictionary *)getAlertWithTag:(NSString *)alertTag
{
    NSArray *dic_dataOrigel =  [[[DBOperate shareInstance] getAllAlertsFromDB] retain];
    NSDictionary *returnDict = [[[NSDictionary alloc]init] autorelease];
    
    for (NSDictionary * dict in dic_dataOrigel)
    {
        if ([dict[@"alertTag"] isEqualToString:alertTag])
        {
            returnDict = [dict retain];
        }
    }
    [dic_dataOrigel release];
    return returnDict;
}


-(void)startClockZeroMorning
{
    //    NSDictionary *zeroDict = @{@"frequency":@"0",@"id":@"123456789",@"sendtime":@"00:01"};
    //    [self postLocalNotification:zeroDict];
}

+(void)postLocalNotification:(NSDictionary *)clockDictionary
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [clockDictionary retain];
    //-----获取闹钟数据---------------------------------------------------------
    NSString *clockTime = [clockDictionary objectForKey:@"sendtime"];
    
    NSArray *sendTimesArray = [clockTime componentsSeparatedByString:@","];
    //	NSString *clockMode = [clockDictionary objectForKey:@"frequency"];
    NSString *clockMode =  [self convertFrequencyWithDictionnary:clockDictionary];
    BOOL repeatState = clockMode.length ?YES:NO;//是否重复
    //NSString *clockScene = [clockDictionary objectForKey:@"ClockScene"];
    //    添加对应的音乐
    //	NSString *clockMusic = [clockDictionary objectForKey:@"ClockMusic"];
    //    NSString *clockMusic =  @"123";
    //	NSString *clockRemember = [clockDictionary objectForKey:@"ClockRemember"];
    NSString *clockRemember = [NSString stringWithFormat:@"%@,时间到了！",clockDictionary[@"med_name"]];
    BOOL isZero = [clockDictionary[@"id"] isEqualToString:@"123456789" ];
    //-----组建本地通知的fireDate-----------------------------------------------
    //-----------------------------------------------------------------------
    for (NSString *clockSendTime in sendTimesArray)
    {
        NSArray *clockTimeArray = [clockSendTime componentsSeparatedByString:@":"];
        NSDate *dateNow = [NSDate date];
        NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
        NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
        //[calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        //[comps setTimeZone:[NSTimeZone timeZoneWithName:@"CMT"]];
        NSInteger unitFlags = NSEraCalendarUnit |
        NSYearCalendarUnit |
        NSMonthCalendarUnit |
        NSDayCalendarUnit |
        NSHourCalendarUnit |
        NSMinuteCalendarUnit |
        NSSecondCalendarUnit |
        NSWeekCalendarUnit |
        NSWeekdayCalendarUnit |
        NSWeekdayOrdinalCalendarUnit |
        NSQuarterCalendarUnit;
        
        comps = [calendar components:unitFlags fromDate:dateNow];
        [comps setHour:[[clockTimeArray objectAtIndex:0] intValue]];
        [comps setMinute:[[clockTimeArray objectAtIndex:1] intValue]];
        [comps setSecond:0];
        
        //------------------------------------------------------------------------
        Byte weekday = [comps weekday];
        //	NSArray *array = [[clockMode substringFromIndex:1] componentsSeparatedByString:@"、"];
        if (repeatState)
        {
            NSArray *array = [clockMode componentsSeparatedByString:@","];
            Byte i = 0;
            Byte j = 0;
            int days = 0;
            int	temp = 0;
            Byte count = [array count];
            Byte clockDays[7];
            
            NSArray *tempWeekdays = [NSArray arrayWithObjects:@"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
            //查找设定的周期模式
            for (i = 0; i < count; i++) {
                for (j = 0; j < 7; j++) {
                    if ([[array objectAtIndex:i] isEqualToString:[tempWeekdays objectAtIndex:j]]) {
                        clockDays[i] = j + 1;
                        break;
                    }
                }
            }
            
            for (i = 0; i < count; i++) {
                temp = clockDays[i] - weekday;
                days = (temp >= 0 ? temp : temp + 7);
                NSDate *newFireDate = [[calendar dateFromComponents:comps] dateByAddingTimeInterval:3600 * 24 * days];
                
                UILocalNotification *newNotification = [[UILocalNotification alloc] init];
                if (newNotification) {
                    newNotification.fireDate = newFireDate;
                    if (!isZero)
                    {
                        newNotification.alertBody = clockRemember;
                        //                newNotification.soundName = [NSString stringWithFormat:@"%@.caf", clockMusic];
                        //                    newNotification.soundName = @"123.caf";
                        newNotification.soundName = [NSString stringWithFormat:@"common.bundle/mp3/%@.caf",clockDictionary[@"soundName"]];
                        newNotification.alertAction = @"查看闹钟";
                        //               newNotification.soundName = UILocalNotificationDefaultSoundName;
                        newNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber]+1;
                    }
                    newNotification.repeatInterval = NSWeekCalendarUnit;
                    NSDictionary *userInfo = @{@"ActivityClock": clockDictionary[@"id"],@"isShake":clockDictionary[@"isShake"],@"type":kAlertType};
                    newNotification.userInfo = userInfo;
                    [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
                }
                NSLog(@"Post new localNotification:%@", [newNotification fireDate]);
                [newNotification release];
            }
        }
        else//不重复
        {
            //            NSDate *newFireDate = [calendar dateFromComponents:comps] ;
            //重新读取时对不重复的时间进行校验
            NSDate *newFireDate = [self alertTimeStringToDateWithString:clockDictionary[@"updateTime"] withHourTime:clockSendTime];
            if ([newFireDate compare:[NSDate date]] == NSOrderedAscending )
            {
                continue;//时间大于现在时间跳出
            }
            
            UILocalNotification *newNotification = [[UILocalNotification alloc] init];
            if (newNotification) {
                newNotification.fireDate = newFireDate;
                newNotification.alertBody = clockRemember;
                newNotification.soundName = [NSString stringWithFormat:@"common.bundle/mp3/%@.caf",clockDictionary[@"soundName"]];
                //                newNotification.alertAction = @"查看闹钟";
                //                newNotification.soundName = UILocalNotificationDefaultSoundName;
                newNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber]+1;
                //                newNotification.repeatInterval = NSWeekCalendarUnit;
                NSDictionary *userInfo = @{@"ActivityClock": clockDictionary[@"id"],@"isShake":clockDictionary[@"isShake"],@"type":kAlertType};
                newNotification.userInfo = userInfo;
                [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
            }
            NSLog(@"Post new localNotification:%@", [newNotification fireDate]);
            [newNotification release];
            
        }
    }
    [pool release];
}


//dicKey:title id用同一个就可以 isShake
+ (void)postSteperLocalNotification:(NSDictionary *)clockDictionary
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UILocalNotification *newNotification = [[UILocalNotification alloc] init];
    if (newNotification) {
        newNotification.fireDate = [NSDate date];
        newNotification.alertBody = clockDictionary[@"title"];//@"运动目标完成啦";
        newNotification.soundName = [NSString stringWithFormat:@"common.bundle/mp3/%@.caf",clockDictionary[@"soundName"]];
        //                newNotification.alertAction = @"查看闹钟";
        //                newNotification.soundName = UILocalNotificationDefaultSoundName;
        newNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber]+1;
        //                newNotification.repeatInterval = NSWeekCalendarUnit;
        NSDictionary *userInfo = @{@"type":@"1000",@"ActivityClock": clockDictionary[@"id"],@"isShake":clockDictionary[@"isShake"]};
        newNotification.userInfo = userInfo;
        [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
    }
    NSLog(@"Post new localNotification:%@", [newNotification fireDate]);
    [newNotification release];
    
    [pool release];
}


//判断时间更新时间之前的 时间不让响应
+(NSDate *)alertTimeStringToDateWithString:(NSString *)timeString withHourTime:(NSString *)sendtime
{
    //    id20141020163148
    NSRange rangeY = {0,4};
    NSRange rangeM = {5,2};
    NSRange rangeD = {8,2};
    NSString *strY = [timeString substringWithRange:rangeY];
    NSString *strM = [timeString substringWithRange:rangeM];
    NSString *strD = [timeString substringWithRange:rangeD];
    NSString *newTimeStr = [NSString stringWithFormat:@"%@-%@-%@ %@",strY,strM,strD,sendtime];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:(@"yyyy-MM-dd HH:mm")];
    NSDate *dateTime = [formatter dateFromString:newTimeStr];
    [formatter release];
    return dateTime;
}

//打开闹钟
+ (void)startClock:(NSDictionary *)clock
{
    //首先查找以前是否存在此本地通知,若存在,则删除以前的该本地通知,
    //再重新发出新的本地通知
    [AlertManager shutdownClock:clock[@"id"]];
    [AlertManager postLocalNotification:clock];
}

//关闭闹钟
+ (void)shutdownClock:(NSString *)clockID
{
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for(UILocalNotification *notification in localNotifications)
    {
        if ([[[notification userInfo] objectForKey:@"ActivityClock"] isEqualToString:clockID]) {
            NSLog(@"Shutdown localNotification:%@", [notification fireDate]);
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

-(void)cancelAllLocation
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];//取消所有的通知
}

#pragma mark 本地通知

//把001转为对应星期
+(NSString *)convertFrequencyWithDictionnary:(NSDictionary *)dict
{
    @try {
        //    不存在
        if ([dict[@"frequency"] isEqualToString:REPEARTTEXT])
        {
            return nil;
        }
        NSArray *array = [[dict objectForKey:@"frequency"] componentsSeparatedByString:@","];
        NSArray *weekArray = [[NSArray alloc] initWithObjects:@"一",@"二",@"三",@"四",@"五",@"六",@"日",nil];
        //    001 002 003 004 005 006 007
        NSString *returnStr = nil;
        
        //    针对零进行处理
        if ([dict[@"frequency"] isEqualToString:@"0"] || [dict[@"frequency"] isEqualToString:@"000"])
        {
            [weekArray release];
            return @"日,一,二,三,四,五,六";
        }
        //    针对其他进行处理
        for (NSString *str in array)
        {
            if (!returnStr)
            {
                returnStr = [weekArray objectAtIndex:str.intValue-1];
            }
            else
            {
                returnStr  = [NSString stringWithFormat:@"%@,%@",returnStr,[weekArray objectAtIndex:str.intValue-1]];
            }
        }
        [weekArray release];
        return returnStr;
    }
    @catch (NSException *exception) {
        NSLog(@"ENCRYPT_GET_USER_ADDRESS");
        return @"";
    }
}

//刷新提醒根据用户
+ (void)reStartAllAlert
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSArray *dic_data =  [[[DBOperate shareInstance] getAllAlertsFromDB] retain];
    //    HealthAlertListTableViewController *hvc = [[HealthAlertListTableViewController alloc]init];
    for (NSDictionary *dict in dic_data)
    {
        if ([dict[@"use_yn"] isEqualToString:@"Y"])
        {
            [self postLocalNotification:dict];
        }
    }
    [dic_data release];
}

+(NSArray* )getAllAlertList
{
    NSMutableArray *m_alertList = [NSMutableArray array];
    NSArray *dic_dataOrigel =  [[[DBOperate shareInstance] getAllAlertsFromDB] retain];
    NSMutableArray *filterArray = [NSMutableArray array];
    for (NSDictionary *dict in dic_dataOrigel)
    {
        NSString *alertTag = dict[@"alertTag"];
        if ([alertTag hasPrefix:kMealAlert])//是早餐前 后记录提醒
        {
            [filterArray addObject:dict];
        }
    }
    [m_alertList addObjectsFromArray:dic_dataOrigel];
    [m_alertList removeObjectsInArray:filterArray];//过滤时间段记录的数据不进行添加
    [dic_dataOrigel release];
    return m_alertList;
}
#pragma mark - newSuger event response
+ (NSString *)timeStringAfterNumMinutes:(NSInteger)afterMinutes
{
    NSDate *timeDate = [NSDate dateWithTimeIntervalSinceNow:afterMinutes*60];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:(@"HH:mm")];
    NSString *timeString = [formatter stringFromDate:timeDate];
    [formatter release];
    return timeString;
}

// 有idstring 为修改 无为add
+(void)startNextSugerClockAfterNumMinutes:(NSInteger)afterMinutes withIdString:(NSString *)idString withUserId:(NSString *)userId
{
//    (0-7)
    //idString+1 做数据偏移到下一个位置
    if (!(idString.intValue >= TimeBeforeBreakfastType && idString.intValue <= TimeRandomType))
    {
        NSLog(@"错误!");
        return;
    }
     NSString *alertTag = @"";
    if (afterMinutes == 0)//关闭当前id
    {
         alertTag = [NSString stringWithFormat:@"%@%@",kMealAlert,idString];
    }
    else//id 推后一个
    {
        int idIndex =  [DiaryModelView obtainIndexTimeSectionArray:[idString intValue]] + 1;
        idIndex = idIndex >=[[DiaryModelView obtainTimeSectionArray] count]-1 ?0:idIndex;//去掉随机-1
        alertTag = [NSString stringWithFormat:@"%@%d",kMealAlert,[[DiaryModelView obtainTimeSectionArray][idIndex] intValue]];
    }
    NSMutableDictionary *dict =  [[DBOperate shareInstance] getAllAlertsFromDBWithSelectAlertTag:alertTag withUserId:userId];
    NSString *alertTagId = dict[@"id"];
    if (afterMinutes == 0)
    {
        if (dict.count > 0)
        {
            if ([dict[@"use_yn"] isEqualToString:@"Y"])//关闭
            {
                [dict setObject:@"N" forKey:@"use_yn"];
                [dict setObject:@"_isUpdate" forKey:@"_isUpdate"];
                [[DBOperate shareInstance] upadteMyAlertFromDBByAlertId:dict];
                [AlertManager shutdownClock:alertTagId];
            }
        }
    }
    else
    {
        //修改
        if (dict.count > 0 )
        {
            [dict setObject:alertTag forKey:@"alertTag"];
            [self updateAlertWithAfterNumMinutes:afterMinutes withAlertDict:dict];
        }
        //新加
        else
        {
            [self addNewAlertWithAfterNumMinutes:afterMinutes withAlertTagString:alertTag withUserId:userId];
        }
    }
}

//更新之前的
+(void)updateAlertWithAfterNumMinutes:(NSInteger)afterMinutes withAlertDict:(NSMutableDictionary *)alertDict
{
    NSString *sendTime = [self timeStringAfterNumMinutes:afterMinutes];
//    NSMutableDictionary * dic = [[[DBOperate shareInstance] getAllAlertsFromDBWithSelectAlertTag:idString] retain];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSinceNow:afterMinutes*60];
    NSString * updateTime = [CommonDate formatCreatetTimeTwo:timeDate];
    [alertDict setObject:updateTime forKey:@"updateTime"];
    [alertDict setObject:sendTime forKey:@"sendtime"];
    [[DBOperate shareInstance] upadteMyAlertFromDBByAlertId:alertDict];
    [AlertManager startClock:alertDict];
    
    if ([alertDict[@"use_yn"] isEqualToString:@"N"])
    {
        NSMutableDictionary *updateDict = [[NSMutableDictionary alloc] init];
        [updateDict setValue:alertDict[@"id"] forKey:@"id"];
        [updateDict setValue:@"Y" forKey:@"use_yn"];
        [updateDict setObject:@"_isUpdate" forKey:@"_isUpdate"];
        [[DBOperate shareInstance] upadteMyAlertFromDBByAlertId:updateDict];
        [updateDict release];
    }
}

//+新得
+(void)addNewAlertWithAfterNumMinutes:(NSInteger)afterMinutes withAlertTagString:(NSString *)alertTagString withUserId:(NSString *)userId
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSString *sendTime = [self timeStringAfterNumMinutes:afterMinutes];
    [dic setObject:sendTime forKey:@"sendtime"] ;
    [dic setObject:REPEARTTEXT forKey:@"frequency"];//频率,
    [dic setObject:@"Y" forKey:@"use_yn"];
    
    NSString *alertType = [alertTagString substringFromIndex:[kMealAlert length]];
    NSString *alertName = [NSString stringWithFormat:@"%@血糖测量提醒",[CommonUser getBloodSugarType:alertType]];
    if(!alertName.length)
        alertName = @"血糖测量";
    [dic setObject:alertName forKey:@"med_name"];
    [dic setObject:@"Y" forKey:@"isShake"];
    [dic setObject:@"alert1" forKey:@"soundName"];
    [dic setObject:[[self class] defautUserIdStringWithIdString:userId] forKey:@"userId"];
    [dic setObject:alertTagString forKey:@"alertTag"];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSinceNow:afterMinutes*60];
    NSString * updateTime = [CommonDate formatCreatetTimeTwo:timeDate];
    
    [dic setObject:updateTime forKey:@"updateTime"];
    //idString  = 当前用户 + id + 家庭用户
//    NSString *idString = [g_nowUserInfo.userid stringByAppendingString:[self createCodeStringWithDateString:[CommonDate formatCreatetTimeTwo:[NSDate new]] withUserId:userId]];
   NSString *idString = [[self class] createAlertIdWithDateString:[CommonDate formatCreatetTimeTwo:[NSDate new]] withUserId:userId withCurrunteMainId:g_nowUserInfo.userid];
    [dic setObject: idString forKey:@"id"];
    [dic setObject:@"N" forKey:@"repeatFlag"];
    [[DBOperate shareInstance] insertMyAlertToDBWithData:dic];
    [AlertManager startClock:dic];
    [dic release];
}

+(NSTimeInterval)getNextSugerClockWithIdString:(NSString *)idString withUserId:(NSString *)userId
{
    NSTimeInterval distanceTimeInterval = 0;
   if (!(idString.intValue >= TimeBeforeBreakfastType && idString.intValue <= TimeRandomType))
//    if (idString.intValue == TimeRandomType)
    {
        NSLog(@"错误!");
        return distanceTimeInterval;
    }
    NSString *alertTag = [NSString stringWithFormat:@"%@%@",kMealAlert,idString];
    NSMutableDictionary *dict =  [[DBOperate shareInstance] getAllAlertsFromDBWithSelectAlertTag:alertTag withUserId:userId];
    
    if (!dict.count || [dict[@"use_yn"] isEqualToString:@"N"])//被关闭
    {
        return distanceTimeInterval;
    }
    NSString *clockSendTime = dict[@"sendtime"];
    NSDate *newFireDate = [self alertTimeStringToDateWithString:dict[@"updateTime"] withHourTime:clockSendTime];
    if ([newFireDate compare:[NSDate date]] == NSOrderedAscending )
    {
        return distanceTimeInterval;//时间早于现在时间跳出
    }
    distanceTimeInterval = [newFireDate timeIntervalSinceNow];
    if (distanceTimeInterval < 0)
    {
        return 0;
    }
//    else
    int temp = 0;
    NSString * result = nil;
    if((temp = distanceTimeInterval/60) <60){
        result = [NSString stringWithFormat:@"%d分前",temp];
    }
    return distanceTimeInterval;//  返回一个响铃的具体时间 distanceTimeInterval
}

+ (BOOL)getHaveSugerClockWithIdString:(NSString *)idString
{
  if (!(idString.intValue >= TimeBeforeBreakfastType && idString.intValue <= TimeRandomType))
  {
        NSLog(@"错误!");
        return NO;
    }
    NSString *alertTag = [NSString stringWithFormat:@"%@%@",kMealAlert,idString];
    NSMutableDictionary *dict =  [[DBOperate shareInstance] getAllAlertsFromDBWithSelectAlertTag:alertTag withUserId:nil];
    if (dict.count)
    {
         return YES;
    }
    return NO;
}

+ (NSString *)lessSecondToDay:(NSUInteger)seconds
{
    NSUInteger day  = (NSUInteger)seconds/(24*3600);
    NSUInteger hour = (NSUInteger)(seconds%(24*3600))/3600;
    NSUInteger min  = (NSUInteger)(seconds%(3600))/60;
    NSUInteger second = (NSUInteger)(seconds%60);
    
    NSString *time = [NSString stringWithFormat:@"%lu日%lu小时%lu分钟%lu秒",(unsigned long)day,(unsigned long)hour,(unsigned long)min,(unsigned long)second];
    return time;
}

+(NSString *)createCodeStringWithDateString:(NSString *)dateString withUserId:(NSString *)userId
{
    NSString *codeString = nil;
    codeString = [dateString stringByReplacingOccurrencesOfString:@" " withString:@""];
    codeString = [codeString stringByReplacingOccurrencesOfString:@":" withString:@""];
    codeString = [codeString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    codeString = [NSString stringWithFormat:@"id%@%@",[[self class] defautUserIdStringWithIdString:userId],codeString];
    return codeString;
}

+(NSString *)createAlertIdWithDateString:(NSString *)dateString withUserId:(NSString *)userId withCurrunteMainId:(NSString *)curruteMainUserId
{
    NSString *idString = [g_nowUserInfo.userid stringByAppendingString:[[self class]createCodeStringWithDateString:dateString withUserId:userId]];
    return idString;
}
//设置默认值
+(NSString *)defautUserIdStringWithIdString:(NSString *)idString
{
    NSString *userIdString = idString;
    if (!userIdString.length)
    {
        userIdString = g_nowUserInfo.userid;
    }
    return userIdString;
}
@end
