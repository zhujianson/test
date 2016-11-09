//
//  StepCounterLogic.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-9-25.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "StepCounterLogic.h"
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"
#import "CommonHttpRequest.h"
#import <CoreLocation/CLLocationManager.h>
#import "AlertManager.h"
#import "Mealtime.h"


#define StepCounterDataPlist  @"StepCounterData"
#define StepCounterLocationDataPlist @"StepCounterLocationData"
#define LocalLogDeleteFlag   YES



@interface StepCounterLogic ()
<AVAudioPlayerDelegate>
{
    CADisplayLink *displayLink;
    CMMotionManager *motionManager;
    BOOL valiadCountStep; // 用于控制开关步数的控制
    NSTimeInterval beginTimeInterval;//开始时间
    NSTimeInterval endTimeInterval;//结束时间
    CGFloat stepNum;//步子长度---单位为m
    
    BOOL  isWriting;//正在写入标志位
    
    BOOL hasStepLengthFlag;//是否算入有效计数
    
    BOOL isCheckNextDayFlag;//检查是否是明天
    
    BOOL isUploadingDataFlag;//是否正在上传数据
    BOOL hasUnUploadDataFlag;//是否有未上传成功的数据
    int  backToZeroCount;//回归到0的计数;
    
    NSTimeInterval beginSpeedTimeInterval;
    NSTimeInterval beginSpeedInBackgroundTimeInterval;
    NSTimeInterval beginSendDataToServerTimeInterval;
    NSTimer *backTimer;//后台定时器
    
    NSTimer *myTimer;
    
    NSTimer *speedTimer;

    int  lastStepCount;//记录上一次步数，用于比较15s内是否发生变化
    
    
    int lastDistanceNumber;//上一次
    int hasplayed;//是否已播放
    BOOL hasFinishedFlag;//是否已经完成了
    
}

@property (nonatomic,retain) NSMutableDictionary *oneDayDic;

@property (nonatomic,retain) NSMutableArray *timeBarrierArray;//时间分界点，根据

@property (nonatomic,retain) NSMutableArray *uploadTimePointArray;

@property (nonatomic,retain) NSString *currentModeStartDate;//开始计步的时间
@property (nonatomic,retain) NSMutableArray *numberArray;//波音数字
@end
@implementation StepCounterLogic

@synthesize timeCount,numberArray;

- (void)dealloc
{
    [numberArray release];
    [g_winDic removeObjectForKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
    [_oneDayDic release];
    [_allCllString release];
    [_speedString release];
    [_callBackBlock release];
    [_locPointsArray release];
    [_dashPointsArray release];
    [_runingInBack release];
    [_theCallBackWithUpNum release];
    if(myTimer){
        [myTimer release];
        myTimer = nil;
    }
    [_timePointArray release];
    [_timeBarrierArray release];
    [_currentModeStartDate release];
    [super dealloc];
}


- (void)startRuningInBackground
{
    [self.runingInBack startBackgroundTasks];
}

- (void)stopRuningInBackground
{
    [self.runingInBack stopBackgroundTask];
}


/**
 *  获得本地计步plist
 *
 */
- (NSMutableDictionary *)getDataPList
{
    //    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    //    NSString * path = [paths  objectAtIndex:0];
    NSString * path =  [Common datePath];
    NSString * filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.plist",g_nowUserInfo.userid,StepCounterDataPlist]];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if(!isExist){
        //不存在创建
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        if(g_nowUserInfo.userid.length)
            [dic writeToFile:filePath atomically:YES];
        return dic;
    }
    //存在直接返回
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
    
}

/**
 *  把最新一天的数据更新到本地
 */
- (void)writeToFileWithCurrentDic
{
    if(isWriting == YES){
        return;
    }
    if(!self.oneDayDic){
        return;
    }
    isWriting = YES;
    //更新目标
    [self.oneDayDic setObject:[NSString stringWithFormat:@"%d",self.targetStep] forKey:@"targetStepCnt"];
    [self.oneDayDic setObject:[NSString stringWithFormat:@"%d",self.timeCount] forKey:@"mode_time_count"];
    [self.oneDayDic setObject:[NSString stringWithFormat:@"%d",self.mySteperStatus] forKey:@"mode_steper_status"];//计步器工作模式
    [self.oneDayDic setObject:[NSString stringWithFormat:@"%d",self.mySteperMode] forKey:@"mode_steper_mode"];//计步器模式
    [self.oneDayDic setObject:[NSString stringWithFormat:@"%d",self.myTimerStatus] forKey:@"mode_timer_status"];//计步器状态
    NSData *locPointString = [NSKeyedArchiver  archivedDataWithRootObject:self.locPointsArray];
    NSData *locDashPointString = [NSKeyedArchiver  archivedDataWithRootObject:self.dashPointsArray];
    [self.oneDayDic setObject:locPointString forKey:@"mode_local_points"];//序列化
    [self.oneDayDic setObject:locDashPointString forKey:@"mode_local_dash_points"];//序列化
    [self.oneDayDic setObject:@(self.lastPointIsDashFlag) forKey:@"lastPointIsDashFlag"];//最后一条是不是虚线
    [self.oneDayDic setObject:@(self.localFirstFlag) forKey:@"localFirstFlag"];//实线开始
    [self.oneDayDic setObject:@(self.dashFirstFlag) forKey:@"dashFirstFlag"];//虚线开始
    
    [self.oneDayDic setObject:@(self.targetModeDistance) forKey:@"mode_target_distance"];
    [self.oneDayDic setObject:@(self.targetModeStepCount) forKey:@"mode_target_stepCount"];
    if(self.currentModeStartDate){
        [self.oneDayDic setObject:self.currentModeStartDate forKey:@"lastestModeDate"];//保存日期
    }
    
    
    NSMutableDictionary *localDic = [self getDataPList];
    NSString *dateString = self.oneDayDic[@"Date"];
    [localDic setObject:self.oneDayDic forKey:dateString];
    
    NSString * path =  [Common datePath];
    NSString * filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.plist",g_nowUserInfo.userid,StepCounterDataPlist]];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if(isExist){
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    BOOL ok = [localDic writeToFile:filePath atomically:YES];
    NSLog(@"-----ok:%d",ok);
    isWriting = NO;
    
}

/**
 *  初始化
 */
- (id)init
{
    self = [super init];
    if(self){
        [g_winDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
        
        [self startDeviceMotion];
        [self startUpdateAccelerometer];
        [self startDisplayLink];
        self.switchFlag = NO;//默认关闭
        valiadCountStep = YES;
        NSString *stepLength = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"stepLength%@",g_nowUserInfo.userid]];
        NSString *weight = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weight%@",g_nowUserInfo.userid]];
        //如果本地没有保存过步子长，则不计入有效
        if(!stepLength){
            hasStepLengthFlag = NO;
        }else{
            hasStepLengthFlag = YES;
        }
        stepNum = [stepLength floatValue];//m
        self.weight = [weight floatValue];//kg
        //   [self getCurrentDic];//----不做获取处理,当登录成功后才获取当前的Dic
        //目标步数
        NSString *targetNum = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"targetStepNum%@",g_nowUserInfo.userid]];
        if(targetNum.length){
            self.targetStep = [targetNum intValue];
        }else{
            self.targetStep = 10000;//设置默认目标步数
        }
        
        self.locPointsArray = [NSMutableArray arrayWithCapacity:0];
        self.dashPointsArray = [NSMutableArray arrayWithCapacity:0];
        self.runingInBack = [[[RuningInBackground alloc] init] autorelease];
    }
    return self;
}

/**
 *  获取当前天的字典
 */
- (void)getCurrentDic
{
    if(g_nowUserInfo.userid.length == 0){
        
        return ;
    }
    //获取本地本次的数据记录--根据日期获得，如果没有创建临时创建
    //包含为24个时间的点数和，总的卡路里 总的速度 总的步数
    //结构为stepList，
    NSDictionary *allDic = [self getDataPList];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    NSLog(@"------%@", date);
    [formatter release];
    NSDictionary *currentDic = allDic[date];
    if(currentDic.allKeys){
        //存在
        self.oneDayDic = [NSMutableDictionary dictionaryWithDictionary:currentDic];
        self.stepCount = [NSString stringWithFormat:@"%@",currentDic[@"all_step_count"]];
        lastStepCount = self.stepCount.intValue;
        self.allCllString = currentDic[@"all_cll"];
        self.costTimeString = currentDic[@"costTime"];
        self.speedString = @"0";
        
        self.modeStepCount = currentDic[@"mode_step_count"];
        self.modeCllString = [currentDic[@"mode_cll"] length]? currentDic[@"mode_cll"] :@"0";
        self.timeCount = [currentDic[@"mode_time_count"] intValue];
        
        self.targetModeDistance = [currentDic[@"mode_target_distance"] intValue];
        self.targetModeStepCount = [currentDic[@"mode_target_stepCount"] intValue];
        
        
        self.mySteperStatus = [currentDic[@"mode_steper_status"] intValue];
        self.mySteperMode = [currentDic[@"mode_steper_mode"] intValue];
        self.myTimerStatus = [currentDic[@"mode_timer_status"] intValue];
        NSData *pointData = currentDic[@"mode_local_points"];
        NSData *dashPointData = currentDic[@"mode_local_dash_points"];
        NSArray *pointsArray = [NSKeyedUnarchiver unarchiveObjectWithData:pointData];
        NSArray *dashPointsArray = [NSKeyedUnarchiver unarchiveObjectWithData:dashPointData];
        //本地存储后添加旧数据
        self.locPointsArray = [NSMutableArray arrayWithArray:pointsArray];
        self.dashPointsArray = [NSMutableArray arrayWithArray:dashPointsArray];
        self.lastPointIsDashFlag = [currentDic[@"lastPointIsDashFlag"] boolValue];
        self.localFirstFlag = [currentDic[@"localFirstFlag"] boolValue];
        self.dashFirstFlag = [currentDic[@"dashFirstFlag"] boolValue];
    
        
        if(self.mySteperStatus== working){
            
            self.switchFlag = YES;
        }
        
        
    }else{
        //不存在时
        self.oneDayDic = [NSMutableDictionary dictionaryWithCapacity:0];
        NSMutableArray *stepCountHourArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *timePonitStepArray = [NSMutableArray arrayWithCapacity:0];
        for(int i = 0; i < 24;i++){
            [stepCountHourArray addObject:@"0"];
            if(i < 8){
                [timePonitStepArray addObject:@"0"];
            }
        }
        [self.oneDayDic setObject:stepCountHourArray forKey:@"hourCounter"];//各小时的步数统计
        [self.oneDayDic setObject:timePonitStepArray forKey:@"timePoints"];//8个时间段的初始化步数
        [self.oneDayDic setObject:@"0" forKey:@"all_ave_v"];//所有的平均速度之和
        [self.oneDayDic setObject:@"0" forKey:@"all_cll"];//所有的卡路里
        [self.oneDayDic setObject:@"0" forKey:@"all_step_count"];//所有的步数
        [self.oneDayDic setObject:date forKey:@"Date"];//当前日期
        [self.oneDayDic setObject:@"0" forKey:@"isUpdateSuccess"];//默认上传不成功
        [self.oneDayDic setObject:[NSString stringWithFormat:@"%d",self.targetStep] forKey:@"targetStepCnt"];
        [self.oneDayDic setObject:@"0" forKey:@"costTime"];
        [self.oneDayDic setObject:@"0" forKey:@"mode_step_count"];//模式步数
        self.stepCount = @"0";
        lastStepCount = 0;
        self.allCllString = @"0";
        self.speedString = @"0";
        self.costTimeString = @"0";
        
        self.timeCount = 0;
        self.targetModeStepCount = 500;//步数
        self.targetModeDistance = 5;//公里
        self.modeStepCount = @"0";
        self.modeCllString = @"0";
        if(self.callBackBlock){
            self.callBackBlock(timeCount);
        }
        //        self.mySteperStatus = notWorkStatus;
        //        self.mySteperMode = normalMode;
        //如果本地没有保存则建一个空数组
        [_locPointsArray removeAllObjects];
        [_locPointsArray addObject:[NSMutableArray arrayWithCapacity:0]];
        [_dashPointsArray removeAllObjects];
        [_dashPointsArray addObject:[NSMutableArray arrayWithCapacity:0]];
        self.lastPointIsDashFlag = NO;
        self.localFirstFlag = NO;
        self.dashFirstFlag = NO;
        
        
    }
}


//服务器数据填充本地
- (void)loadServerDataWithDic:(NSDictionary *)currentDic
{
    NSArray *pointsArray = currentDic[@"pointItems"];
    //服务器返回空数组 不替换本地
    NSArray *stepCountHourArray = currentDic[@"dataItems"];
    if(stepCountHourArray.count){
        [self.oneDayDic setObject:stepCountHourArray forKey:@"hourCounter"];//各小时的步数统计
    }
    if(pointsArray.count){
        [self.oneDayDic setObject:pointsArray forKey:@"timePoints"];//8个时间段的初始化步数
    }
    [self.oneDayDic setObject:@"0" forKey:@"all_ave_v"];//所有的平均速度之和
    [self.oneDayDic setObject:currentDic[@"kilCalorie"] forKey:@"all_cll"];//所有的卡路里
    [self.oneDayDic setObject:currentDic[@"realStepCnt"] forKey:@"all_step_count"];//所有的步数
    [self.oneDayDic setObject:@"0" forKey:@"isUpdateSuccess"];//默认上传不成功
    [self.oneDayDic setObject:currentDic[@"targetStepCnt"] forKey:@"targetStepCnt"];
    [self.oneDayDic setObject:[Common isNULLString7:currentDic[@"costTime"]] forKey:@"costTime"];
    [self.oneDayDic setObject:@"0" forKey:@"mode_step_count"];//模式步数
    
    self.stepCount = [NSString stringWithFormat:@"%@",currentDic[@"realStepCnt"]];
     lastStepCount = self.stepCount.intValue;
    self.allCllString = currentDic[@"kilCalorie"];
    self.costTimeString = currentDic[@"costTime"];
    self.speedString = @"0";
    
}


/**
 *  获得小时
 *
 */
- (NSString *)getHourWithTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *hourAndMin = [formatter stringFromDate:[NSDate date]];
    NSLog(@"------%@", hourAndMin);
    [formatter release];
    return hourAndMin;
}


//更新室外数据
/**
 * distace 米   speed m/s
 */
- (void)addOutdoorDataWithDistance:(double) distance speed:(double) speed
{
    if(self.mySteperStatus == notWorkStatus){
        return;
    }
    
    beginSendDataToServerTimeInterval = [[NSDate date] timeIntervalSince1970];
    
    NSString *stepLength = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"stepLength%@",g_nowUserInfo.userid]];
    stepNum = [stepLength floatValue];//m
    
    
    
    NSTimeInterval betweenInterval = distance / speed; //s
    if(speed == 0){
        betweenInterval = 0;
    }
    self.costTimeString = [NSString stringWithFormat:@"%f",[self.costTimeString floatValue]+betweenInterval/3600];//单位为h
    
    int stepCount = distance/stepNum;
    self.stepCount = [NSString stringWithFormat:@"%d",[self.stepCount intValue]+stepCount];//更新步数
    lastStepCount = self.stepCount.intValue;
    //获得当前的小时
    NSString *hourAndMinute = [self getHourWithTime];
    int hour = [[hourAndMinute substringToIndex:2] intValue];
    
    NSArray *timeComArray = [hourAndMinute componentsSeparatedByString:@":"];
    NSString *hourS =  timeComArray[0];
    NSString *minuteS = timeComArray[1];
    int toMinuteValue = hourS.intValue*60+minuteS.intValue;
    
    if(self.mySteperStatus != notWorkStatus){
        [self dispatchStepWithCurrentMinute:toMinuteValue stepCount:stepCount];
    }
    //模式 更新步数
    
    if(self.mySteperStatus != notWorkStatus){
        self.modeStepCount = [NSString stringWithFormat:@"%d",[self.modeStepCount intValue]+stepCount];
        [self.oneDayDic setObject:[NSString stringWithFormat:@"%@",self.modeStepCount] forKey:@"mode_step_count"];
        [self checkSendLocalNotification];
    }
    //获得速度
    self.speedString = [NSString stringWithFormat:@"%.2f",3.6 * speed];//单位km/h
    
    if(speedTimer){
        [speedTimer invalidate];
    }
    speedTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(backToZero) userInfo:nil repeats:NO];
    
    //更新每个时段的步数
    NSMutableArray *hourStepArray = [NSMutableArray arrayWithArray:self.oneDayDic[@"hourCounter"]];
    NSString *oldNum = hourStepArray[hour];
    [hourStepArray replaceObjectAtIndex:hour withObject:[NSString stringWithFormat:@"%d",oldNum.intValue+stepCount]];
    [self.oneDayDic setObject:hourStepArray forKey:@"hourCounter"];
    //更新速度总和
    NSString *allVString = self.oneDayDic[@"all_ave_v"];
    [self.oneDayDic setObject:[NSString stringWithFormat:@"%f",[allVString floatValue]+[self.speedString floatValue]] forKey:@"all_ave_v"];
    //更新卡路里总和
    NSString *currentCLLString = [self getKllWithSpeed:self.speedString timeInterval:betweenInterval];
    self.allCllString = [NSString stringWithFormat:@"%f",[self.allCllString floatValue]+[currentCLLString floatValue]];
    if(self.mySteperStatus != notWorkStatus){
        //室内模式 更新卡路里
        self.modeCllString = [NSString stringWithFormat:@"%f",[self.modeCllString floatValue]+[currentCLLString floatValue]];
        [self.oneDayDic setObject:[NSString stringWithFormat:@"%@",self.modeCllString] forKey:@"mode_cll"];
    }
    
    [self.oneDayDic setObject:[NSString stringWithFormat:@"%@",self.allCllString] forKey:@"all_cll"];
    //更新总步数
    [self.oneDayDic setObject:[NSString stringWithFormat:@"%@",self.stepCount] forKey:@"all_step_count"];
    //更新目标
    [self.oneDayDic setObject:[NSString stringWithFormat:@"%d",self.targetStep] forKey:@"targetStepCnt"];
    //更新耗时
    [self.oneDayDic setObject:self.costTimeString forKey:@"costTime"];
    
}

//速度恢复到零
- (void)backToZero
{
    self.speedString = @"0";
    [speedTimer invalidate];
    speedTimer = nil;
}

/**
 *  计算卡路里
 *  @return
 */
- (NSString *)getKllWithSpeed:(NSString *)speed timeInterval:(NSTimeInterval)timeInterval
{
    CGFloat speedFloat = speed.floatValue;
    if(speedFloat < 0){
        return @"0";
    }
    if(speedFloat >= 0 && speedFloat <= 1.4){
        return [NSString stringWithFormat:@"%f",2.0*[speed floatValue]/1.4*3.5*self.weight/200*timeInterval/60];//千卡
    }else if (speedFloat >= 1.4 && speedFloat <=6.7){
        return [NSString stringWithFormat:@"%f",(2.0+4.7*([speed floatValue]-1.5)/5.2)*3.5*self.weight/200*timeInterval/60];//千卡
    }else{
        
        return [NSString stringWithFormat:@"%f",6.8*3.5*self.weight/200*timeInterval/60];//千卡
    }
    
    return @"0";
}

//分配步数
- (void)dispatchStepWithCurrentMinute:(int)minute stepCount:(int)stepCount
{
    
    for (int i = 0; i < self.timeBarrierArray.count; i++) {
        int firstPoint = [self.timeBarrierArray[i] intValue];
        
        int j = i+1;
        if(j == self.timeBarrierArray.count){
            j = 0;
        }
        
        int secondPoint = [self.timeBarrierArray[j] intValue];
        
        if(firstPoint < secondPoint){
            //A < B
            if(minute > firstPoint && minute <= secondPoint){
                //存放在下标为i的数组中
                //更新每个时段的步数
                NSMutableArray *hourStepArray = [NSMutableArray arrayWithArray:self.oneDayDic[@"timePoints"]];
                NSString *oldNum = hourStepArray[i];
                [hourStepArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",oldNum.intValue+stepCount]];
                [self.oneDayDic setObject:hourStepArray forKey:@"timePoints"];
                break;
            }else{
                continue;
            }
            
        }else{
            
            if(minute > firstPoint || minute <= secondPoint){
                NSMutableArray *hourStepArray = [NSMutableArray arrayWithArray:self.oneDayDic[@"timePoints"]];
                NSString *oldNum = hourStepArray[i];
                [hourStepArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",oldNum.intValue+stepCount]];
                [self.oneDayDic setObject:hourStepArray forKey:@"timePoints"];
                break;
            }
            
        }
        
    }
}

//本地检测提交数据
- (void)checkToSendLocalDataRequest
{
    //获得当前的小时
    NSString *hourAndMinute = [self getHourWithTime];
    NSArray *timeComArray = [hourAndMinute componentsSeparatedByString:@":"];
    NSString *hourS =  timeComArray[0];
    NSString *minuteS = timeComArray[1];
    int curMinuteValue = hourS.intValue*60+minuteS.intValue;
    for (int i = 0; i < self.uploadTimePointArray.count; i++) {
        int firstPoint = [self.uploadTimePointArray[i] intValue];
        if( isUploadingDataFlag == NO && curMinuteValue == firstPoint){
            if(isWriting == NO){
                [self writeToFileWithCurrentDic];
            }
            isUploadingDataFlag = YES;
            [self.uploadTimePointArray removeObjectAtIndex:i];
            [self  uploadDataRequest];
            break;
        }
    }
}


/**
 *  更新当前天的实时数据
 */
- (void)getData
{
    if(self.mySteperStatus == notWorkStatus){
        return;
    }
    
    NSString *stepLength = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"stepLength%@",g_nowUserInfo.userid]];
    stepNum = [stepLength floatValue];//m
    
    //获得当前的小时
    NSString *hourAndMinute = [self getHourWithTime];
    int hour = [[hourAndMinute substringToIndex:2] intValue];
    
    NSArray *timeComArray = [hourAndMinute componentsSeparatedByString:@":"];
    NSString *hourS =  timeComArray[0];
    NSString *minuteS = timeComArray[1];
    int toMinuteValue = hourS.intValue*60+minuteS.intValue;
    
    
    if(beginTimeInterval == 0){
        beginTimeInterval = [[NSDate date] timeIntervalSince1970];
        self.stepCount = [NSString stringWithFormat:@"%d",[self.stepCount intValue]+1];
        lastStepCount = self.stepCount.intValue;
        if(self.mySteperStatus != notWorkStatus){
            //室内模式 更新步数
            self.modeStepCount = [NSString stringWithFormat:@"%d",[self.modeStepCount intValue]+1];
            [self.oneDayDic setObject:[NSString stringWithFormat:@"%@",self.modeStepCount] forKey:@"mode_step_count"];
        }
        //更新每个时段的步数
        NSMutableArray *hourStepArray = [NSMutableArray arrayWithArray:self.oneDayDic[@"hourCounter"]];
        NSString *oldNum = hourStepArray[hour];
        [hourStepArray replaceObjectAtIndex:hour withObject:[NSString stringWithFormat:@"%d",oldNum.intValue+1]];
        [self.oneDayDic setObject:hourStepArray forKey:@"hourCounter"];
        
        if(self.mySteperStatus != notWorkStatus){
            [self dispatchStepWithCurrentMinute:toMinuteValue stepCount:1];
        }
        
        return;
    }else{
        endTimeInterval = [[NSDate date] timeIntervalSince1970];
    }
    
    NSTimeInterval betweenInterval = endTimeInterval - beginTimeInterval;
    
    if(betweenInterval < 0.35){
        //无效计数 跳过，灵敏度修改在此处
        return;
    }
    
    //获得速度
    self.speedString = [NSString stringWithFormat:@"%.2f",3.6 * stepNum / betweenInterval];//单位km/h
    NSLog(@"----speed_%@km/h,time:%f",self.speedString,betweenInterval);
    
    speedTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(backToZero) userInfo:nil repeats:NO];
    
    if(stepNum / betweenInterval > g_nowUserInfo.maxSpeed){
        //超过最大值
        return;
    }
    
    self.costTimeString = [NSString stringWithFormat:@"%f",[self.costTimeString floatValue]+betweenInterval/3600];//单位为h
    
    NSLog(@"begin--:%f,end:--%f,between:%f",beginTimeInterval,endTimeInterval,betweenInterval);
    beginTimeInterval = endTimeInterval;//更新begin
    self.stepCount = [NSString stringWithFormat:@"%d",[self.stepCount intValue]+1];
    lastStepCount = self.stepCount.intValue;
    if(self.mySteperStatus !=  notWorkStatus){
        //室内模式 更新步数
        self.modeStepCount = [NSString stringWithFormat:@"%d",[self.modeStepCount intValue]+1];
        [self.oneDayDic setObject:[NSString stringWithFormat:@"%@",self.modeStepCount] forKey:@"mode_step_count"];
        [self checkSendLocalNotification];
        
        if(self.mySteperStatus != notWorkStatus){
            [self dispatchStepWithCurrentMinute:toMinuteValue stepCount:1];
        }
    }
    
    //更新每个时段的步数
    NSMutableArray *hourStepArray = [NSMutableArray arrayWithArray:self.oneDayDic[@"hourCounter"]];
    NSString *oldNum = hourStepArray[hour];
    [hourStepArray replaceObjectAtIndex:hour withObject:[NSString stringWithFormat:@"%d",oldNum.intValue+1]];
    [self.oneDayDic setObject:hourStepArray forKey:@"hourCounter"];
    //更新速度总和
    NSString *allVString = self.oneDayDic[@"all_ave_v"];
    [self.oneDayDic setObject:[NSString stringWithFormat:@"%f",[allVString floatValue]+[self.speedString floatValue]] forKey:@"all_ave_v"];
    //更新卡路里总和
    NSString *currentCLLString = [self getKllWithSpeed:self.speedString timeInterval:betweenInterval];
    self.allCllString = [NSString stringWithFormat:@"%f",[self.allCllString floatValue]+[currentCLLString floatValue]];
    if(self.mySteperStatus != notWorkStatus){
        //室内模式 更新卡路里
        self.modeCllString = [NSString stringWithFormat:@"%f",[self.modeCllString floatValue]+[currentCLLString floatValue]];
        [self.oneDayDic setObject:[NSString stringWithFormat:@"%@",self.modeCllString] forKey:@"mode_cll"];
    }

    [self.oneDayDic setObject:[NSString stringWithFormat:@"%@",self.allCllString] forKey:@"all_cll"];
    //更新总步数
    [self.oneDayDic setObject:[NSString stringWithFormat:@"%@",self.stepCount] forKey:@"all_step_count"];
    //更新目标
    [self.oneDayDic setObject:[NSString stringWithFormat:@"%d",self.targetStep] forKey:@"targetStepCnt"];
    //更新耗时
    [self.oneDayDic setObject:self.costTimeString forKey:@"costTime"];
    
    //满2000主动上传
    if(self.stepCount.intValue%2000 == 0){
        
        [self uploadDataRequest];
    }
    
   }

//检测发送通知
- (void)checkSendLocalNotification
{
    NSString *stepLength = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"stepLength%@",g_nowUserInfo.userid]];
    stepNum = [stepLength floatValue];//m
    
    if(self.mySteperStatus == indoorStatus || self.mySteperStatus == outdoorStatus){
        //室内室外模式
        
        int currentStepCount = self.stepCount.intValue;
        
        
        CGFloat distance = currentStepCount*stepNum/1000;//km
        
        int a = floor(distance);
    
        if(a > 0 && a != lastDistanceNumber && hasFinishedFlag == NO){
            //播放
            lastDistanceNumber = a;
            NSString *distanceString = [NSString stringWithFormat:@"%d",a];
            
            self.numberArray = [NSMutableArray arrayWithCapacity:0];
            [numberArray addObject:@"m_already_done.mp3"];
            
            
            if(distanceString.length == 2 ){
            //10 20 90
                NSString *nameString = nil;
                
                int ten = a/10;
                int ge  = a%10;
                
                
                if(ten == 1 && ge == 0){
                     [numberArray addObject:@"m_10.mp3"];//直接是10公里
                    
                }else if (ten == 1 && ge != 0){
                    
                   [numberArray addObject:@"m_10.mp3"];//直接是10公里
                    nameString = [NSString stringWithFormat:@"m_%d.mp3",ge];
                    [numberArray addObject:nameString];
                
                }else {
                    
                    nameString = [NSString stringWithFormat:@"m_%d.mp3",ten];
                    [numberArray addObject:nameString];
                    [numberArray addObject:@"m_10.mp3"];//直接是10公里

                    if(ge != 0){
                      nameString = [NSString stringWithFormat:@"m_%d.mp3",ge];
                      [numberArray addObject:nameString];
                    }

                }
            }else if(distanceString.length == 1 ){
                
                NSString *nameString = nil;
                nameString = [NSString stringWithFormat:@"m_%d.mp3",a];
                [numberArray addObject:nameString];
            
            }

            [numberArray addObject:@"m_kilometer.mp3"];
            
            [self playAudioWithName:numberArray[0]];
            [numberArray removeObjectAtIndex:0];
            
        }
        
        
        CGFloat progress = (CGFloat)currentStepCount/ self.targetStep;
        
        
        NSString *message = @"离目标越来越近了\n加油！";
       
        
        if(progress >= 1){
            
            message = @"今日计步达标，过量运动易出现低血糖，合理安排坚持锻炼，稳步控糖更健康!";
            if(self.isSendFinishNotificationFlag == YES){
                
                return;
            }
            [self playAudioWithName:@"m_goal_done.mp3"];//运动已完成
            hasFinishedFlag = YES;
            self.isSendFinishNotificationFlag = YES;
            [AlertManager  shutdownClock:@"7801"];
            [AlertManager  postSteperLocalNotification:@{@"id":@"7801",@"isShake":@"Y",@"title":message}];
            
        }
        
        
        if(progress >= 3/5.0f){
            //正常检测 目标步数
            if(self.isSendLocalNotificationFlag == YES){
                return;
            }
            self.isSendLocalNotificationFlag = YES;
            [AlertManager  shutdownClock:@"7801"];
            [AlertManager  postSteperLocalNotification:@{@"id":@"7801",@"isShake":@"Y",@"title":message}];
            
        }
    }
}

/**
 *  播放提示音
 *
 *  @param audioName
 */
- (void)playAudioWithName:(NSString *)audioName
{
    
    
    if(self.disableVoiceFlage){
        return;
    }

    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"common.bundle/mp3/step/%@",audioName] ofType:nil];
    NSURL *soundFileURL = [NSURL fileURLWithPath:filePath];
    NSError * error;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&error];
    player.delegate = self;
    player.volume = 0.5;
    [player prepareToPlay];
    [player play];

}

/**
 *  代理播放完成
 *
 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if(self.numberArray.count){
        [self playAudioWithName:numberArray[0]];
        [numberArray removeObjectAtIndex:0];
    }
}


/**
 *  刷新数据
 */
- (void)refreshData
{
    
    //    //默认计时器时间为1小时 = 3600s
    //    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",3600] forKey:@"timeCount"];
    //    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"timerWorking"];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self  resetTimer];//重置定时器
    self.timeCount = 3600;//时间恢复为一小时
    //废弃
    //    self.timeStepCount = 0;//步数恢复为0
    
    self.notShowFailView = NO;
    NSString *stepLength = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"stepLength%@",g_nowUserInfo.userid]];//m
    NSString *weight = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weight%@",g_nowUserInfo.userid]]; //kg
    if(!stepLength){
        hasStepLengthFlag = NO;
    }else{
        hasStepLengthFlag = YES;
    }
    
    NSString *targetNum = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"targetStepNum%@",g_nowUserInfo.userid]];
    if(targetNum.length){
        self.targetStep = [targetNum intValue];
    }else{
        self.targetStep = 10000;//设置默认目标步数
    }
    
    stepNum = [stepLength floatValue];//m
    self.weight = [weight floatValue];//kg
    [self getCurrentDic];
    hasStepLengthFlag = YES;
    hasUnUploadDataFlag = YES;
    
    
    self.isLoginFlag = YES;//重新获得数据了
    //    [self uploadDataRequest];
    //    [self forceUploadFlag];
    //可以添加一些初始化信息 比如是否需要开启定位
    
    [self getMealTime];
    //初始化
    BOOL closeVoiceFlag = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"closeVoiceFlag_%@",g_nowUserInfo.userid]];
    self.disableVoiceFlage = closeVoiceFlag;
}

//获得用餐时间
- (void)getMealTime
{
    
    __block typeof(self) wself = self;
    
    [[Mealtime alloc] initWithBlock:^(id timeBucket)  {
        NSLog(@"--%@",timeBucket);
        
        NSArray *keyArray = @[@"one",@"two",@"three",@"four",@"five",@"six",@"seven",@"eight"];
        
        NSMutableArray *timeArray = [NSMutableArray arrayWithCapacity:0];
        for(NSString *key in keyArray){
            [timeArray addObject:timeBucket[key]];
        }
        
        wself.timePointArray = timeArray;//@[@"23:15 - 05:15",@"05:15 - 07:00",@"07:00 - 10:00",@"10:00 - 12:00",@"12:00 - 15:00",@"15:00 - 18:00",@"18:00 - 21:00",@"21:00 - 23:15"];
        
        wself.timeBarrierArray = [NSMutableArray arrayWithCapacity:0];
        for(NSString *timeString in wself.timePointArray){
            
            NSString *beginString = [timeString substringToIndex:5];
            //将A:B格式按照 A*60+B 转成分钟书 然后比较方便
            NSArray *timeComArray = [beginString componentsSeparatedByString:@":"];
            NSString *hour =  timeComArray[0];
            NSString *minutes = timeComArray[1];
            NSNumber *toMinutesNum = [NSNumber numberWithInt:hour.intValue*60+minutes.intValue];
            [self.timeBarrierArray addObject:toMinutesNum];
        }
        
        wself.uploadTimePointArray = [NSMutableArray arrayWithArray:wself.timeBarrierArray];
        
    } withType:todayMealtime withView:nil];
    
}

//开启传感器
- (void)startDeviceMotion
{
    motionManager = [[CMMotionManager alloc] init];
    //	motionManager.showsDeviceMovementDisplay = YES;
    motionManager.deviceMotionUpdateInterval = 1.0 / 60.0;
    [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical];
}

//开始更新
- (void)startUpdateAccelerometer
{
    /* 设置采样的频率，单位是秒 */
    NSTimeInterval updateInterval = 0.05; // 每秒采样20次
    
    //    CGSize size = [self superview].frame.size;
    //	__block CGRect f = [self frame];
    //    __block int stepCount = 0; // 步数
    //在block中，只能使用weakSelf。
    /* 判断是否加速度传感器可用，如果可用则继续 */
    if ([motionManager isAccelerometerAvailable] == YES) {
        /* 给采样频率赋值，单位是秒 */
        [motionManager setAccelerometerUpdateInterval:updateInterval];
        /* 加速度传感器开始采样，每次采样结果在block中处理 */
        [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
         {
             CGFloat sqrtValue =sqrt(accelerometerData.acceleration.x*accelerometerData.acceleration.x+accelerometerData.acceleration.y*accelerometerData.acceleration.y+accelerometerData.acceleration.z*accelerometerData.acceleration.z);
             //每次计步时，判断是否是下一天了
             if(isCheckNextDayFlag == NO){
                 [self isNextDay];
             }
             if (self.switchFlag)
             {
                 if(g_nowUserInfo.userid.length == 0 || self.isLoginFlag == NO){
                     return ;
                 }
                 
                 // 走路产生的震动率
//                 if (sqrtValue > 1.552188 && valiadCountStep)
                 if (sqrtValue > 1.352188 && valiadCountStep)
                 {
                     if(!hasStepLengthFlag){
                         //无步子长度，无效，返回
                         NSLog(@"未获取步子长度");
                         return ;
                     }
                     if(g_nowUserInfo.userid.length == 0){
                         //没有id无效
                         return;
                     }
                     displayLink.paused = NO;
                     NSLog(@"-----addStep---%@",self.stepCount);
                     valiadCountStep = NO;
                     beginSpeedTimeInterval = [[NSDate date] timeIntervalSince1970];
                     beginSpeedInBackgroundTimeInterval = beginSpeedTimeInterval;
                     beginSendDataToServerTimeInterval = beginSpeedTimeInterval;
                     //更新当前天的实时数据
                     [self getData];
                     
                 }else{
                     
                     NSTimeInterval newTimeInterVal = [[NSDate date] timeIntervalSince1970];
                     
                     //速度2s后归零
                     if(beginSpeedTimeInterval != 0 ){
                         if(newTimeInterVal - beginSpeedTimeInterval >= 2){
                             self.speedString = @"0";
                             beginSpeedTimeInterval = 0;
                         }
                     }
                     
                     if(self.inBackGroundFlag){
                         //在后台--每隔0.35秒置为Yes可以接受新的计数值
                         if(beginSpeedInBackgroundTimeInterval != 0){
                             if(newTimeInterVal - beginSpeedInBackgroundTimeInterval >=0.35){
                                 valiadCountStep = YES;
                                 beginSpeedInBackgroundTimeInterval = 0;
                             }
                         }
                     }
                     
                     if(beginSendDataToServerTimeInterval != 0){
                         if(newTimeInterVal - beginSendDataToServerTimeInterval >= 30){
                             //大于60s,判定为停止运动
                             beginTimeInterval = 0;//置为0下次再计算
                             if(isWriting == NO){
                                 [self writeToFileWithCurrentDic];
                             }
                             if(isUploadingDataFlag == NO){
                                 //上传
                                 [self uploadDataRequest];
                                 beginSendDataToServerTimeInterval = 0;
                             }
                         }
                     }
                 }
             }
             
             if(self.mySteperStatus == indoorStatus){
                 NSTimeInterval newTimeInterVal = [[NSDate date] timeIntervalSince1970];
                 if(beginSendDataToServerTimeInterval != 0){
                     if(newTimeInterVal - beginSendDataToServerTimeInterval >= 5){
                         //大于60s,判定为停止运动
                         beginTimeInterval = 0;//置为0下次再计算
                         if(isWriting == NO){
                             [self writeToFileWithCurrentDic];
                         }
                         if(isUploadingDataFlag == NO){
                             //上传
                             beginSendDataToServerTimeInterval = 0;
                             [self uploadDataRequest];
                         }
                     }
                 }
             }
             
         }];
    }
}

//上传数据
- (void)uploadDataRequest
{
    //无网络 直接返回
    NetWorkType type = [Common checkNetworkIsValidType];
    if(type == NetWorkType_None)
    {
        return;
    }
    
    if(g_nowUserInfo.userid.length == 0){
        return;
    }
    
    NSString *stepLength = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"stepLength%@",g_nowUserInfo.userid]];
    stepNum = [stepLength floatValue];//m
    
    isUploadingDataFlag = YES;
    NSMutableDictionary *dic = [self getDataPList];
    //获取日期数组
    NSMutableArray *dateArray = [NSMutableArray arrayWithArray:dic.allKeys];
    //得到除当前天外的本地数据
    NSMutableArray *allUploadArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    BOOL hasLocalRecordToDeleteFlag = NO;
    for(NSString *dateString in dateArray){
        NSDictionary *theDic = dic[dateString];
        //是否上传成功
        NSString *isUploadSuccess = theDic[@"isUpdateSuccess"];
        if([isUploadSuccess intValue] == 1){
            //上传成功---删除本地记录
            [dic removeObjectForKey:dateString];
            hasLocalRecordToDeleteFlag = YES;
            continue;
        }
        NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithCapacity:0];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSDate *newDate = [formatter dateFromString:theDic[@"Date"]];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *newDateString = [formatter stringFromDate:newDate];
        [formatter release];
        
        [newDic setObject:[NSString stringWithFormat:@"%@",newDateString] forKey:@"measuringDate"];//日期
        if([theDic[@"all_step_count"] intValue] == 0){
            [newDic setObject:@"0" forKey:@"avgSpeed"];
        }else{
            [newDic setObject:[NSString stringWithFormat:@"%f",[theDic[@"all_ave_v"] floatValue]/[theDic[@"all_step_count"] intValue]] forKey:@"avgSpeed"];//平均速度km/h
        }
        [newDic setObject:[NSString stringWithFormat:@"%f",[theDic[@"all_step_count"] intValue]*stepNum] forKey:@"distance"];//距离m,需要时除1000得到km
        
        [newDic setObject:theDic[@"all_step_count"] forKey:@"realStepCnt"];//步数
        [newDic setObject:[NSString stringWithFormat:@"%@",theDic[@"targetStepCnt"]] forKey:@"targetStepCnt"];//目标
        [newDic setObject:theDic[@"all_cll"] forKey:@"kilCalorie"];//消耗的卡路里
        NSArray *hourCounterArray = theDic[@"hourCounter"];
        [newDic setObject:hourCounterArray forKey:@"dataItems"];//24小时数据
        NSArray *timePointArray = theDic[@"timePoints"];
        
        if(timePointArray){
            [newDic setObject:timePointArray forKey:@"pointItems"];//8个时间段数据
        }
        if(theDic[@"costTime"]){
            [newDic setObject:theDic[@"costTime"] forKey:@"costTime"];//耗时
        }
        [allUploadArray addObject:newDic];
    }
    
    if(hasLocalRecordToDeleteFlag && LocalLogDeleteFlag){
        //更新本地数组
        [self refreshLocalData:dic];
    }
    
    if(allUploadArray.count){
        hasUnUploadDataFlag = YES;
    }else{
        hasUnUploadDataFlag = NO;
        isUploadingDataFlag = NO;
        return;//没有要上传数据返回
    }
    
    if(g_nowUserInfo.userid.length == 0){
        isUploadingDataFlag = NO;
        return;
    }
    
    NSMutableDictionary *requestDic =  [[NSMutableDictionary alloc] initWithCapacity:0];
    NSData *data = [NSJSONSerialization  dataWithJSONObject:allUploadArray options:NSJSONWritingPrettyPrinted error:nil];
    //    NSString *allDataJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //替换掉\n 空格
    NSMutableString *allDataJsonString = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [allDataJsonString replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, allDataJsonString.length)];
    
    [allDataJsonString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, allDataJsonString.length)];
    //    [requestDic setValue:g_nowUserInfo.userid forKey:@"uid"];
    [requestDic setValue:allDataJsonString forKey:@"dataList"];
    [requestDic setValue:[Common getMacAddress] forKey:@"deviceNo"];
    //    [requestDic setValue:@"3" forKey:@"appVersion"];
    
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:StepDataUploadRequest values:requestDic requestKey:StepDataUploadRequest delegate:self controller:self actiViewFlag:0 title:nil];
    if(LocalLogDeleteFlag){
        //删除本地记录
        //        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        //        NSString * path = [paths  objectAtIndex:0];
        NSString * path =  [Common datePath];
        NSString * filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.plist",g_nowUserInfo.userid,@"StepCounterDataPlistLocalLog"]];
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        if(isExist){
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
        
    }else{
        NSMutableDictionary *logDic = [NSMutableDictionary dictionaryWithCapacity:0];
        [logDic setObject:allUploadArray forKey:@"uploadDataArray"];
        [self uploadLogDoc:logDic url:StepDataUploadRequest localKey:@"StepCounterDataPlistLocalLog"];
        [allUploadArray release];
    }
    
    
    [requestDic release];
    
}

//获得本地日志记录
- (NSMutableArray *)getLocalLogArray:(NSString *)localKey
{
    //    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    //    NSString * path = [paths  objectAtIndex:0];
    NSString * path =  [Common datePath];
    NSString * filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.plist",g_nowUserInfo.userid,localKey]];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if(!isExist){
        //不存在创建
        NSMutableArray *localLogArray = [NSMutableArray arrayWithCapacity:0];
        if(g_nowUserInfo.userid.length)
            [localLogArray writeToFile:filePath atomically:YES];
        return localLogArray;
    }
    //存在直接返回
    NSMutableArray *myLocalLogArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    return myLocalLogArray;
    
}
- (void)writeLocalLogArray:(NSMutableArray *)array localKey:(NSString *)localKey
{
    NSString * path =  [Common datePath];
    NSString * filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.plist",g_nowUserInfo.userid,localKey]];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if(isExist){
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    [array writeToFile:filePath atomically:YES];
    
}

- (void)uploadLogDoc:(NSDictionary *)requestDic url:(NSString *)url localKey:(NSString *)localKey
{
    return;//关闭调log
    NSMutableDictionary *logdic = [NSMutableDictionary dictionaryWithDictionary:requestDic];
    [logdic setObject:[NSDate date] forKey:@"uploadDate"];
    [logdic setObject:url forKey:@"URL"];
    
    NSMutableArray *localArray = [NSMutableArray arrayWithArray:[self getLocalLogArray:localKey]];
    [localArray addObject:logdic];
    [self writeLocalLogArray:localArray localKey:localKey];
}


- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    //    NSDictionary *resultDic = dic[@"rs"];
    if ([dic[@"head"][@"state"] isEqualToString:@"0000"])
    {
        if ([loader.username isEqualToString:StepDataUploadRequest]) {
            NSLog(@"success upload");
            
            
            NSDictionary *bodyDic = dic[@"body"];
            NSString *surpass = bodyDic[@"info"][@"surpass"];
            surpass = !surpass ? @"0" : surpass;
            
            self.scoreValue = [bodyDic[@"info"][@"scores"] intValue];
            self.stepCount = self.stepCount;
            if(self.theCallBackWithUpNum){
                
                self.theCallBackWithUpNum(surpass.integerValue);
            }
            
            if(LocalLogDeleteFlag){
                //删除本地记录
                NSString * path =  [Common datePath];
                NSString * filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.plist",g_nowUserInfo.userid,@"StepCounterDataPlistLocalLogResult"]];
                BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
                if(isExist){
                    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
                }
            }else{
                [self uploadLogDoc:dic url:[NSString stringWithFormat:@"%@",loader.url] localKey:@"StepCounterDataPlistLocalLogResult"];
            }
            
            
            NSMutableDictionary *locDic = [self getDataPList];
            NSArray *dateArray = locDic.allKeys;
            BOOL needRefreshLocalData = NO;
            
            NSMutableArray *myDateArray = [NSMutableArray arrayWithArray:dateArray];
            //当前天
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy年MM月dd日"];
            NSString  *currentDateString = [formatter stringFromDate:[NSDate date]];
            [formatter release];
            [myDateArray removeObject:currentDateString];
            //除了当前天 其余的标志位置为1
            for(NSString *dateString in myDateArray){
                //之前逻辑成功的置为1 现在修改为成功的直接删除该条记录
                if(LocalLogDeleteFlag){
                    //删除本地记录
                    [locDic removeObjectForKey:dateString];
                }else{
                    NSDictionary *theDic = locDic[dateString];
                    [theDic setValue:@"1" forKey:@"isUpdateSuccess"];
                }
                needRefreshLocalData = YES;
            }
            if(needRefreshLocalData){
                [self refreshLocalData:locDic];
            }
            hasUnUploadDataFlag = YES;
            isUploadingDataFlag = NO;
            
        }
    }else{
        //失败
        if ([loader.username isEqualToString:StepDataUploadRequest]){
            isUploadingDataFlag = NO;
            if(!self.notShowFailView){
                //                [Common TipDialog2:@"数据上传失败,请在绑定设备上计步！"];
                [Common TipDialog:dic[@"head"][@"msg"]];
            }
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseStepCounterNotification" object:nil];
        }
    }
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    NSLog(@"fail");
    isUploadingDataFlag = NO;
    if ([loader.username isEqualToString:StepDataUploadRequest]){
        isUploadingDataFlag = NO;
        NSString *responseString = [loader responseString];
        NSDictionary *dic = [responseString KXjSONValueObject];
        [self uploadLogDoc:dic url:[NSString stringWithFormat:@"%@",loader.url] localKey:@"StepCounterDataPlistLocalLogResult"];
    }
    
}

- (void)refreshLocalData:(NSDictionary *)newDic
{
    if(!self.oneDayDic){
        return;
    }
    isWriting = YES;
    NSMutableDictionary *localDic = [NSMutableDictionary dictionaryWithDictionary:newDic];
    NSString *dateString = self.oneDayDic[@"Date"];
    [localDic setObject:self.oneDayDic forKey:dateString];
    
    //    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    //    NSString * path = [paths  objectAtIndex:0];
    NSString * path =  [Common datePath];
    NSString * filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.plist",g_nowUserInfo.userid,StepCounterDataPlist]];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if(isExist){
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    [localDic writeToFile:filePath atomically:YES];
    isWriting = NO;
    
}

/**
 *  判断是否是下一天了
 */
- (void)isNextDay
{
    if(g_nowUserInfo.userid.length == 0){
        return;
    }
    isCheckNextDayFlag = YES;
    //当前数据的时间戳
    NSString *dateString = self.oneDayDic[@"Date"];
    //现在的时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    
    if([date isEqualToString:dateString]){
        //一致，不清零
    }else{
        //不一致，表示第二天了，保存清零
        //不等于当前的日期时，保存到本地
        [self writeToFileWithCurrentDic];
        //重新获取新一天的字典
        [self getCurrentDic];
        hasUnUploadDataFlag = YES;
        [self getMealTime];
        self.uploadTimePointArray = [NSMutableArray arrayWithArray:_timeBarrierArray];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveRouteLineNotification" object:nil];
        
        self.isSendLocalNotificationFlag = NO;
        self.isSendFinishNotificationFlag = NO;

    }
    isCheckNextDayFlag = NO;
}


- (void)startDisplayLink
{
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayLink:)];
    //    对于iOS设备来说那刷新频率就是60HZ也就是每秒60次，设为2时，代表2帧调用一次，每秒调用30次
    [displayLink setFrameInterval:60];//间隔多少帧调用一次
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    displayLink.paused = YES;
}

- (void)onDisplayLink:(id)sender
{
    NSLog(@"onDisplayLink-----");
    displayLink.paused = YES;
    valiadCountStep = YES;
}

//后台显示
- (void)sendToBackground
{
    valiadCountStep = YES;
    beginSpeedTimeInterval = [[NSDate date] timeIntervalSince1970];
    beginSpeedInBackgroundTimeInterval = beginSpeedTimeInterval;
    beginSendDataToServerTimeInterval = beginSpeedTimeInterval;
    self.inBackGroundFlag = YES;
}
//停止后台
- (void)stopBackTimer
{
    self.inBackGroundFlag = NO;
}

#pragma mark Timer Related

- (void)prepAudio
{
    SystemSoundID soundID = 0;
    // NSURL* fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"4004" ofType:@"mp3"]];//
    NSURL* fileURL = [[NSBundle mainBundle] URLForResource:@"common.bundle/mp3/step.mp3" withExtension:nil];
    if (fileURL != nil) {
        SystemSoundID theSoundID;
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &theSoundID);
        if (error == kAudioServicesNoError) {
            soundID = theSoundID;
        } else {
            NSLog(@"Failed to create sound ");
        }
    }
    AudioServicesPlaySystemSound(soundID);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
}

- (void)beginTimer
{
    if(!myTimer){
        myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addTimeFunc) userInfo:nil repeats:YES];
    }
    
    self.myTimerStatus = working;
    
}

- (void)addTimeFunc
{
    
    if(self.mySteperMode == normalMode || self.mySteperMode == DistanceMode || self.mySteperMode == TimingMode){
        timeCount++;
    }else if (self.mySteperMode == TimingMode){
        timeCount--;
    }
    if(self.callBackBlock){
        self.callBackBlock(timeCount);
    }
    
    if(timeCount == self.allTimeCount){

        if(self.mySteperMode == TimingMode){
            //定时模式
            
            if(self.isSendLocalNotificationFlag == YES){
                return;
            }
            self.isSendLocalNotificationFlag = YES;
            [AlertManager  shutdownClock:@"7801"];
            [AlertManager  postSteperLocalNotification:@{@"id":@"7801",@"isShake":@"Y",@"title":@"定时时间到啦"}];
            
        }
    }
}

- (void)pauseTimer
{
    if(myTimer){
        [myTimer invalidate];
        myTimer = nil;
    }
    self.myTimerStatus = pauseWorking;
}

- (void)resetTimer
{
    //关闭定时器
    if(myTimer){
        [myTimer invalidate];
        myTimer = nil;
    }
    self.myTimerStatus = notWork;
    self.mySteperStatus = notWorkStatus;
    //废弃
    //    self.timeStepCount = 0;
}

@end