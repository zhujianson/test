//
//  ControlPanelView.m
//  jiuhaohealth4.0
//
//  Created by wangmin on 15-4-21.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "ControlPanelView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface ControlPanelView ()

{
    
    UILabel *progressLabel;
    UILabel *percentLabel;
    UILabel *targetLabel;
    
    UIButton *leftBtn;
    UIButton *rightBtn;
    
    BOOL  tipsEnableLocation;
    
}

@property (nonatomic,retain) NSString *distanceString;

@end

@implementation ControlPanelView
@synthesize timeCount;

- (void)dealloc
{
    [Common getAppDelegate].stepCounterObj.callBackBlock = nil;
    self.modelBtn = nil;//模式显示
    self.stepLabel = nil;//步数显示
    self.timeLabel = nil;//时间显示
    self.distanceLabel = nil;//距离显示
    self.distanceString = nil;
    
    self.speedLabel = nil;//速度显示
    self. calLabel = nil;//卡路里显示
    self.lockBtnBlock = nil;//锁block
    self.startBtnBlock = nil;//开始暂停block
    self.endBtnBlock = nil;//分享block
    self.myTimerCountingBlock = nil;
    self.modeDic = nil;
    self.callBackBlock = nil;
    [super dealloc];
}




- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        self.backgroundColor = [UIColor whiteColor];
        [self getViews];
        
    }
    return self;
}

//全部定义为普通模式
- (void)getViews
{
    AppDelegate *myDelegate = [Common getAppDelegate];
     //添加进度条 完成度 目标
    UILabel *progressBackLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 5)];
    progressBackLabel.backgroundColor = [CommonImage colorWithHexString:@"f2f2f2"];
    [self addSubview:progressBackLabel];
    [progressBackLabel release];
    
    progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth/2.0f, 5)];
    progressLabel.backgroundColor = [CommonImage colorWithHexString:@"ff5232"];
    [self addSubview:progressLabel];
    [progressLabel release];
    //目标完成
    percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, progressLabel.bottom+2, kDeviceWidth/2.0f, 15)];
    percentLabel.textAlignment = NSTextAlignmentLeft;
    percentLabel.font = [UIFont systemFontOfSize:14.0f];
    percentLabel.textColor = [CommonImage colorWithHexString:@"999999"];
    [self addSubview:percentLabel];
    [percentLabel release];
    //目标数
    targetLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth/2.0f, progressLabel.bottom+2, kDeviceWidth/2.0f-5, 15)];
    targetLabel.textAlignment = NSTextAlignmentRight;
    targetLabel.font = [UIFont systemFontOfSize:14.0f];
    targetLabel.textColor = [CommonImage colorWithHexString:@"999999"];
    [self addSubview:targetLabel];
    [targetLabel release];
    
    CGFloat smallOffsetY = 0;
    if(IS_Small_INCH_SCREEN){
        smallOffsetY = -10;
    }
    //步数
    self.stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50+smallOffsetY, kDeviceWidth/2.0f, 58)];
    _stepLabel.backgroundColor = [UIColor clearColor];
    _stepLabel.text = @"1618";
    _stepLabel.textColor = [CommonImage colorWithHexString:@"333333"];
    _stepLabel.textAlignment = NSTextAlignmentCenter;
    //    _stepLabel.font = [UIFont boldSystemFontOfSize:39];
    _stepLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:40];
    [self  addSubview:_stepLabel];
    [_stepLabel release];
    //步数说明
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _stepLabel.bottom+3, kDeviceWidth/2.0, 15)];
    textLabel.text = @"步数";
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:14.0f];
    textLabel.textColor = [CommonImage colorWithHexString:@"999999"];
    [self addSubview:textLabel];
    [textLabel release];
    //时间
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth/2.0f, 50+smallOffsetY, kDeviceWidth/2.0f, 58)];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:40];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = [CommonImage colorWithHexString:@"333333"];
    [self addSubview:_timeLabel];
    [_timeLabel release];
    _timeLabel.text = @"00:00";
    //时间说明
    UILabel *timesLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth/2.0f, _stepLabel.bottom+3, kDeviceWidth/2.0, 15)];
    timesLabel.text = @"时间";
    timesLabel.textAlignment = NSTextAlignmentCenter;
    timesLabel.font = [UIFont systemFontOfSize:14.0f];
    timesLabel.textColor = [CommonImage colorWithHexString:@"999999"];
    [self addSubview:timesLabel];
    [timesLabel release];
    //分割线
    UIView *alineView = [[UIView alloc] initWithFrame:CGRectMake(25,_timeLabel.bottom+40, kDeviceWidth-25*2, 0.5)];
    alineView.backgroundColor =  [CommonImage colorWithHexString:@"dcdcdc"];
    [self addSubview:alineView];
    [alineView release];
    
    CGFloat offsetY = alineView.bottom + 10;
    CGFloat offsetX = 25;
    
    CGFloat width = (kDeviceWidth - 25*2)/3;
    
    
    //实时速度
    self.speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX+width, offsetY, width, 40)];
    _speedLabel.backgroundColor = [UIColor clearColor];
    _speedLabel.textColor= [CommonImage colorWithHexString:@"91d000"];
    //    _speedLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    _speedLabel.font = [UIFont systemFontOfSize:22.0f];//[UIFont fontWithName:@"STHeitiTC-Medium" size:22];
    _speedLabel.textAlignment = NSTextAlignmentCenter;
    _speedLabel.numberOfLines = 2;
    _speedLabel.adjustsFontSizeToFitWidth = YES;
    _speedLabel.attributedText = [self replaceRedColorWithNSString:@"00'00''\n配速(min/km)" andUseKeyWord:@"配速(min/km)" andWithFontSize:13];
    [self addSubview:_speedLabel];
    [_speedLabel release];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(offsetX+width-1, offsetY+5, 0.5, 30)];
    lineView.backgroundColor = [CommonImage colorWithHexString:@"dcdcdc"];
    [self addSubview:lineView];
    [lineView release];
    //总距离
    self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, offsetY, width, 40)];
    _distanceLabel.backgroundColor = [UIColor clearColor];
    _distanceLabel.textColor= [CommonImage colorWithHexString:@"57b2ff"];
    //    _distanceLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    _distanceLabel.font = [UIFont systemFontOfSize:22.0f];//[UIFont fontWithName:@"STHeitiTC-Medium" size:22];
    _distanceLabel.textAlignment = NSTextAlignmentCenter;
    _distanceLabel.numberOfLines = 2;
    _distanceLabel.text = @"12\n距离(km)";
    _distanceLabel.adjustsFontSizeToFitWidth = YES;
    _distanceLabel.attributedText = [self replaceRedColorWithNSString:@"12\n距离(km)" andUseKeyWord:@"距离(km)" andWithFontSize:13];
    [self addSubview:_distanceLabel];
    [_distanceLabel release];
    lineView = [[UIView alloc] initWithFrame:CGRectMake(offsetX+width*2-1, offsetY+5, 0.5, 30)];
    lineView.backgroundColor = [CommonImage colorWithHexString:@"dcdcdc"];
    [self addSubview:lineView];
    [lineView release];
    //总卡路里
    self.calLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX+width*2, offsetY, width, 40)];
    _calLabel.backgroundColor = [UIColor clearColor];
    _calLabel.textColor= [CommonImage colorWithHexString:@"ff6d3a"];
    _calLabel.font = [UIFont systemFontOfSize:22.0f];//[UIFont fontWithName:@"STHeitiTC-Medium" size:22];
    _calLabel.textAlignment = NSTextAlignmentCenter;
    _calLabel.numberOfLines = 2;
    _calLabel.adjustsFontSizeToFitWidth = YES;
    //    _calLabel.text = @"129\n卡路里(kcal)";
    _calLabel.attributedText = [self replaceRedColorWithNSString:@"129\n消耗(kcal)" andUseKeyWord:@"消耗(kcal)" andWithFontSize:13];
    [self addSubview:_calLabel];
    [_calLabel release];
    
    CGFloat btnOffsetY = offsetY + 40;
    
    CGFloat margin = (self.frame.size.height - btnOffsetY - 44)/2.0f;
    
    
    //暂停 开始
    leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(15, btnOffsetY+margin, kDeviceWidth/2.0f-15-7.5, 44);
    UIImage *image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"ff5232"]];
    [leftBtn setBackgroundImage:image forState:UIControlStateNormal];
    [leftBtn setTitle:NSLocalizedString(@"开始", nil) forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    leftBtn.layer.cornerRadius = 4;
    leftBtn.layer.masksToBounds = YES;
    [leftBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftBtn];
    
    //分享
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(kDeviceWidth/2.0+7.5, btnOffsetY+margin, kDeviceWidth/2.0f-15-7.5, 44);
    image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"69d136"]];
    [rightBtn setBackgroundImage:image forState:UIControlStateNormal];
    [rightBtn setTitle:NSLocalizedString(@"分享", nil) forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    rightBtn.layer.cornerRadius = 4;
    rightBtn.layer.masksToBounds = YES;
    [rightBtn addTarget:self action:@selector(endBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    
    
    if( myDelegate.stepCounterObj.myTimerStatus == pauseWorking){
        myDelegate.stepCounterObj.switchFlag = NO;

        [leftBtn setTitle:@"开始" forState:UIControlStateNormal];
        [rightBtn setTitle:@"分享" forState:UIControlStateNormal];
        UIImage *image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"ff5232"]];
        [leftBtn setBackgroundImage:image forState:UIControlStateNormal];
        
    }else if( myDelegate.stepCounterObj.myTimerStatus == notWork){
        myDelegate.stepCounterObj.switchFlag = NO;

   
    }else if( myDelegate.stepCounterObj.myTimerStatus == working){
        [leftBtn setTitle:@"暂停" forState:UIControlStateNormal];
        [rightBtn setTitle:@"分享" forState:UIControlStateNormal];
        UIImage *image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"ffba27"]];
        [leftBtn setBackgroundImage:image forState:UIControlStateNormal];
        myDelegate.stepCounterObj.switchFlag = YES;
        [myDelegate performSelector:@selector(startSignificantChangeUpdates) withObject:nil afterDelay:1];
        [myDelegate.stepCounterObj beginTimer];
    }

    __block typeof(self) weakSelf = self;
    
    [Common getAppDelegate].stepCounterObj.callBackBlock = ^(int currectCount ){
        //实时回调
//            if(currectCount == 0){
//                [weakSelf endBtnClick:nil];
//            }
            //更新界面
            int allTime = currectCount;//content为分钟
            int hour = allTime/3600;
            int min = (allTime%3600)/60;
            int second = (allTime%3600)%60;
            if(hour > 0){
                weakSelf.timeLabel.text = [NSString stringWithFormat:@"%d:%02d:%02d",hour,min,second];
            }else{
                weakSelf.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",min,second];
            }
            int peisuToSecond = 0;
            if(weakSelf.distanceString.floatValue == 0){
                peisuToSecond = 0;
            }else {
              peisuToSecond =  allTime/weakSelf.distanceString.floatValue;
            }
            
            if(peisuToSecond > 99*60+59){
                peisuToSecond = 99*60+59;
            }
            
            int minValue = peisuToSecond/60;
            int secondValue = peisuToSecond%60;
            
            weakSelf.speedLabel.attributedText = [weakSelf replaceRedColorWithNSString:[NSString stringWithFormat:@"%02d'%02d''\n配速(min/km)",minValue,secondValue] andUseKeyWord:@"配速(min/km)" andWithFontSize:13];
            
            
            if(weakSelf.myTimerCountingBlock){
                weakSelf.myTimerCountingBlock(currectCount);
            }
    };
}

- (void)endBtnClick:(UIButton *)theEndBtn
{
    if([theEndBtn.titleLabel.text isEqualToString:@"分享"]){
        NSLog(@"分享");
        if(self.endBtnBlock){
            self.endBtnBlock(YES);
        }
    }
}

- (void)startBtnClick:(UIButton *)btn
{
    BOOL flag = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"battery_saveFlag"]];

    //通知更改状态
    if([leftBtn.titleLabel.text isEqualToString:@"开始"] && !flag) {
        
            BOOL enable = [self checkLocationEnable];
            if(!enable)
            {
                return;
            }
        }
    
    AppDelegate *myDelegate = [Common getAppDelegate];
    if(myDelegate.stepCounterObj.myTimerStatus == notWork || myDelegate.stepCounterObj.myTimerStatus == pauseWorking){//为工作--开始工作
        if(!self.availableFlag){
            if(self.callBackBlock){
                self.callBackBlock();
            }
            //提示切换设备
            return;
        }
        if(self.startBtnBlock){
            self.startBtnBlock(YES);
        }
        //先全部开启
        myDelegate.stepCounterObj.switchFlag = YES;//开启计步器
        [myDelegate.stepCounterObj beginTimer];
        [myDelegate startSignificantChangeUpdates];
 
        [leftBtn setTitle:@"暂停" forState:UIControlStateNormal];
        UIImage *image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"ffba27"]];
        [leftBtn setBackgroundImage:image forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"%@isStopCountering",g_nowUserInfo.userid]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else if(myDelegate.stepCounterObj.myTimerStatus == working){

        if(self.startBtnBlock){
            self.startBtnBlock(NO);
        }
        
        myDelegate.stepCounterObj.switchFlag = NO;//关闭计步器
        [myDelegate.stepCounterObj  pauseTimer];
        [myDelegate stopSingificantChangeUpdates];
        [leftBtn setTitle:@"开始" forState:UIControlStateNormal];
        UIImage *image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"ff5232"]];
        [leftBtn setBackgroundImage:image forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@isStopCountering",g_nowUserInfo.userid]];
        [[NSUserDefaults standardUserDefaults] synchronize];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [myDelegate.stepCounterObj writeToFileWithCurrentDic];
            [myDelegate.stepCounterObj uploadDataRequest];
        });
    }
    
}

- (BOOL)checkLocationEnable
{
    
    if([CLLocationManager locationServicesEnabled]&&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        //...Location service is enabled
        return YES;
    }
    else
    {
        if(tipsEnableLocation){
            
            return YES;
        }
        
        
        if([[[UIDevice currentDevice] systemVersion] floatValue]<8.0)
        {
            UIAlertView* curr1=[[UIAlertView alloc] initWithTitle:@"爱运动需要定位服务" message:@"您可以到设置->隐私->定位服务中开启康迅360的定位服务" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            curr1.tag = 112;
            [curr1 show];
        }
        else
        {
            UIAlertView* curr2=[[UIAlertView alloc] initWithTitle:@"爱运动需要定位服务" message:@"您可以到设置->隐私->定位服务中开启康迅360的定位服务" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
            curr2.tag=121;
            [curr2 show];
        }
        
        return NO;
    }
    
}

- (void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 121 && buttonIndex == 1)
    {
        //code for opening settings app in iOS 8
        [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
        return;
    }else if ((alertView.tag == 121 && buttonIndex == 0) || alertView.tag == 112)
    {
//        点击了取消
        tipsEnableLocation = YES;//显示后就可以跳过开始了
        [self startBtnClick:leftBtn];
        return;
    }
}


- (void)newValueForDistance:(NSString *)distance
{
    self.distanceString = distance;
    if([Common getAppDelegate].stepCounterObj.myTimerStatus != working){
        int peisuToSecond = 0;
        int allTime = [Common getAppDelegate].stepCounterObj.timeCount;
        if(_distanceString.floatValue == 0){
            peisuToSecond = 0;
        }else {
            peisuToSecond =  allTime/_distanceString.floatValue;
        }
        
        if(peisuToSecond > 99*60+59){
            peisuToSecond = 99*60+59;
        }
        
        int minValue = peisuToSecond/60;
        int secondValue = peisuToSecond%60;
        
        self.speedLabel.attributedText = [self replaceRedColorWithNSString:[NSString stringWithFormat:@"%02d'%02d''\n配速(min/km)",minValue,secondValue] andUseKeyWord:@"配速(min/km)" andWithFontSize:13];
        
    }
    _distanceLabel.attributedText = [self replaceRedColorWithNSString:[NSString stringWithFormat:@"%@\n距离(km)",distance] andUseKeyWord:@"距离(km)" andWithFontSize:12];
    
}

- (void)newValueForSpeed:(NSString *)speed
{
//    _speedLabel.attributedText = [self replaceRedColorWithNSString:[NSString stringWithFormat:@"%@\n速度(km/h)",speed] andUseKeyWord:@"速度(km/h)" andWithFontSize:12];
//   _speedLabel.attributedText = [self replaceRedColorWithNSString:@"12\n配速(min/km)" andUseKeyWord:@"配速(min/km)" andWithFontSize:13]
}

- (void)newValueForCal:(NSString *)cal
{
    _calLabel.attributedText = [self replaceRedColorWithNSString:[NSString stringWithFormat:@"%@\n消耗(kcal)",cal] andUseKeyWord:@"消耗(kcal)" andWithFontSize:12];
    
}

- (void)initValueForTime:(int)time
{
    timeCount = time;
    //更新界面
    int allTime = time;//content为分钟
    int hour = allTime/3600;
    int min = (allTime%3600)/60;
    int second = (allTime%3600)%60;
    
    if(hour > 0){
        _timeLabel.text = [NSString stringWithFormat:@"%d:%02d:%02d",hour,min,second];
    }else{
        _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",min,second];
    }

}

- (void)newProgress:(NSString *)stepCount
{
    CGRect rect = progressLabel.frame;
    CGFloat width = kDeviceWidth * stepCount.floatValue / [Common getAppDelegate].stepCounterObj.targetStep;
    if (width < 0.01){
        
        width = 0.01;
    }
    if(width > kDeviceWidth){
        width = kDeviceWidth;
    }
    
    rect.size.width = width;
    progressLabel.frame = rect;
    
    if(stepCount.intValue >= [Common getAppDelegate].stepCounterObj.targetStep){
       percentLabel.text = [NSString stringWithFormat:@"已完成%d%%",100];
    }else{
        percentLabel.text = [NSString stringWithFormat:@"已完成%.1f%%",stepCount.floatValue / [Common getAppDelegate].stepCounterObj.targetStep * 100];
    }
    targetLabel.text = [NSString stringWithFormat:@"目标：%d",[Common getAppDelegate].stepCounterObj.targetStep];
}

- (NSMutableAttributedString *)replaceRedColorWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )size
{
    NSMutableAttributedString *attrituteString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Arial" size:size]} range:range];
    return attrituteString;
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

@end
