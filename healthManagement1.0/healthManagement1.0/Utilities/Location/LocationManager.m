//
//  LocationManager.m
//  jiuhaohealth4.0
//
//  Created by wangmin on 15/9/10.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "LocationManager.h"
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
//#import "CSqlite.h"


@interface LocationManager ()
<CLLocationManagerDelegate>
{
    BOOL isDashPointFlag;//是否是虚线点
    
    NSTimer *restartTimer;
    
    int dashCount;//进入虚线次数 满足5次后 切换精度
    
    int lineCount;//进入实线次数 满足5次后 切换精度 未用

    
}

@property (nonatomic,retain) CLLocation *getSpeedLocation;

@property (nonatomic,retain) NSMutableArray *speedArray;
@property (nonatomic,retain) NSMutableArray *backSpeddrray;

@property (nonatomic,retain) NSMutableArray *countArray;

@end

@implementation LocationManager
{
    
    CLLocationManager *locationManager;
    CLLocation* _currentLocation;

//    CSqlite *m_sqlite;
}


- (void)dealloc
{
    [_getSpeedLocation release];
    self.localCityString = nil;
    self.localStateString = nil;
    self.localSubLocationString = nil;
    self.gpsAccuracyString = nil;
    if(locationManager){
        [locationManager release];
        locationManager = nil;
    }
    [super dealloc];
}

+ (LocationManager *)sharedManager
{
    static LocationManager *class;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        class = [[LocationManager alloc] init];
    });
    
    return class;
}


//请求权限
- (void)requestLocationAuthorization
{
    if (!locationManager)
    {
        locationManager = [[CLLocationManager alloc] init];
    }
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy =  kCLLocationAccuracyNearestTenMeters;
    locationManager.pausesLocationUpdatesAutomatically = NO;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        locationManager.allowsBackgroundLocationUpdates = YES;
    }
    
    if(IS_OS_8_OR_LATER) {
        [locationManager requestAlwaysAuthorization];
    }
    
    [locationManager startUpdatingLocation];
//    [locationManager startMonitoringSignificantLocationChanges];
}

- (void)startSignificantChangeUpdates
{
    if([UIApplication sharedApplication].applicationState != UIApplicationStateActive){
//        [[Common getAppDelegate].stepCounterObj startRuningInBackground];
    }
    
    BOOL battery_saveFlag = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"battery_saveFlag"]];
    if(battery_saveFlag){
        //省电模式 直接返回
        return;
    }
    
    [locationManager startUpdatingLocation];
    
}


- (void)stopSingificantChangeUpdates
{
    
//    [[Common getAppDelegate].stepCounterObj stopRuningInBackground];
    
    if(locationManager){
        [locationManager stopUpdatingLocation];
    }

    self.getSpeedLocation = nil;//归零
}


//-(CLLocationCoordinate2D)zzTransGPS:(CLLocationCoordinate2D)yGps
//{
//    
//    if(!m_sqlite){
//        m_sqlite = [[CSqlite alloc]init];
//        [m_sqlite openSqlite];
//    }
//    
//    int TenLat=0;
//    int TenLog=0;
//    TenLat = (int)(yGps.latitude*10);
//    TenLog = (int)(yGps.longitude*10);
//    NSString *sql = [[NSString alloc]initWithFormat:@"select offLat,offLog from gpsT where lat=%d and log = %d",TenLat,TenLog];
//    sqlite3_stmt* stmtL = [m_sqlite NSRunSql:sql];
//    int offLat=0;
//    int offLog=0;
//    while (sqlite3_step(stmtL)==SQLITE_ROW)
//    {
//        offLat = sqlite3_column_int(stmtL, 0);
//        offLog = sqlite3_column_int(stmtL, 1);
//        
//    }
//    
//    yGps.latitude = yGps.latitude+offLat*0.0001;
//    yGps.longitude = yGps.longitude + offLog*0.0001;
//    return yGps;
//    
//    
//}

/*
 * 重启定位
 */
- (void)checkRestartLocation
{
    BOOL isStopCountering = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@isStopCountering",g_nowUserInfo.userid]];
//    if(!isStopCountering && [Common getAppDelegate].stepCounterObj.myTimerStatus == working){
//        [self startSignificantChangeUpdates];//重新开启定位
//    }
    
    [restartTimer invalidate];
     restartTimer = nil;
}


+ (NSString *)getCurrentDayStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    return dateString;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    self.gpsAccuracyString = [NSString stringWithFormat:@"%f",newLocation.horizontalAccuracy];
    
    
    
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    CLGeocodeCompletionHandler handle = ^(NSArray *placemarks,NSError *error)
    {
        for (CLPlacemark * placeMark in placemarks)
        {
            
            NSDictionary *addressDic=placeMark.addressDictionary;
            NSString *state=[addressDic objectForKey:@"State"];
            NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
            NSString *city = [addressDic objectForKey:@"City"];
            
            if(!city){
                city = state;
            }
            self.localStateString = state;
            self.localSubLocationString = subLocality;
            self.localCityString = city;
            
            
            BOOL isStopCountering = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@isStopCountering",g_nowUserInfo.userid]];
//            if(isStopCountering || [Common getAppDelegate].stepCounterObj.myTimerStatus != working){
//
//                [locationManager stopUpdatingLocation];
//            }
        }
    };
    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler:handle];
    [clGeoCoder release];
    
    //改为室内模式
//    if([Common getAppDelegate].stepCounterObj.mySteperStatus != indoorStatus || [Common getAppDelegate].stepCounterObj.myTimerStatus != working){
//        return;
//    }
    
    // check the zero point
    if(newLocation.coordinate.latitude == 0.0f || newLocation.coordinate.longitude == 0.0f)
        return;

    
    CGFloat newSpeed = newLocation.speed;//初始化为新的位置的速度

//    if(!_getSpeedLocation){
//        
//        self.getSpeedLocation = newLocation;
//    
//    }else{
//        //计算速度
//        NSTimeInterval timeSpace = [newLocation.timestamp timeIntervalSinceDate:_getSpeedLocation.timestamp];//s
//        CLLocationDistance distance = [newLocation distanceFromLocation:_getSpeedLocation];//m
//        CGFloat speed = distance/timeSpace;//distance
//        
//        self.getSpeedLocation = newLocation;
//        if (timeSpace < 0.05) {//连续两次回调时间间隔太短忽略
//            return;
//        }
//        if(newSpeed == -1){//赋予自己计算的速度
//            newSpeed = speed;
//        }
//    }

    
    if(newSpeed == -1){//无效的速度过滤
        return;
    }
    
    CLLocationCoordinate2D mylocation = newLocation.coordinate;//手机GPS
    //    mylocation = CLLocationCoordinate2DMake(40.005614618970277, 116.48354328368657);//test
    
//    mylocation = [self zzTransGPS:mylocation];///火星GPS
//    CLLocation * newLoc = [[CLLocation alloc] initWithLatitude:mylocation.latitude longitude:mylocation.longitude];
    
    // check the move distance
    //    关闭gps速度检测
  if(newSpeed > g_nowUserInfo.maxSpeedOfPatient){//收集虚线点
    
//    if(newSpeed > 1.5){
    
        dashCount++;
    }else{
        dashCount = 0;
    }
    
//  if(dashCount > 1){//收集虚线点 连续八次速度超过才回进行画虚线 因为精度比较高的情况下5次很容易达到
//      
////    //降低精度
////      if(locationManager.distanceFilter != 50 ){
////          locationManager.distanceFilter = 50;
////          locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;//100米
////      }
//      
//      //获取最后一个坐标点的集合
//        NSArray *lastLocPointsArray = [[Common getAppDelegate].stepCounterObj.dashPointsArray lastObject];
//        if(lastLocPointsArray.count){
//            if(_currentLocation){
//                [_currentLocation release];
//            }
//            _currentLocation = [lastLocPointsArray.lastObject retain];
//        }else{
//            _currentLocation = nil;
//        }
//        
//        if (_currentLocation) {
//            CLLocationDistance distance = [newLoc distanceFromLocation:_currentLocation];
//            if (distance < 5){
//                [newLoc release];
//                return;
//            }
//            NSMutableArray *lastArray = [[Common getAppDelegate].stepCounterObj.dashPointsArray lastObject];
//            if(distance <= 500 && isDashPointFlag){//500以内加到同一个
//                [lastArray addObject:newLoc];
//            }else {
//
//                isDashPointFlag = YES;
//                NSMutableArray *newLocArray = [NSMutableArray arrayWithCapacity:0];
//                [newLocArray addObject:newLoc];
//                [[Common getAppDelegate].stepCounterObj.dashPointsArray addObject:newLocArray];
//            }
//        }else{
//            //添加第一个点
//            if([Common getAppDelegate].stepCounterObj.localFirstFlag == NO){
//                [Common getAppDelegate].stepCounterObj.dashFirstFlag = YES;
//            }
//             isDashPointFlag = YES;
//            NSMutableArray *lastArray = [[Common getAppDelegate].stepCounterObj.dashPointsArray lastObject];
//            [lastArray addObject:newLoc];
//        }
//        [newLoc release];
//        [Common getAppDelegate].stepCounterObj.lastPointIsDashFlag  = YES;
//    
//    }else{
//        //提高精度
////        if(locationManager.distanceFilter != 5 ){
////            locationManager.distanceFilter = 5;
////            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
////        }
//        
//        //获取最后一个坐标点的集合
//        NSArray *lastLocPointsArray = [[Common getAppDelegate].stepCounterObj.locPointsArray lastObject];
//        if(lastLocPointsArray.count){
//            if(_currentLocation){
//                [_currentLocation release];
//            }
//            _currentLocation = [lastLocPointsArray.lastObject retain];
//        }else{
//            _currentLocation = nil;
//        }
//        
//        if (_currentLocation) {
//            CLLocationDistance distance = [newLoc distanceFromLocation:_currentLocation];
//            if (distance < 5){
//                [newLoc release];
//                return;
//            }
//            NSMutableArray *lastArray = [[Common getAppDelegate].stepCounterObj.locPointsArray lastObject];
//            if(distance <= 500 && isDashPointFlag == NO){
//                [lastArray addObject:newLoc];
//            }else {
//              
//                isDashPointFlag = NO;
//                NSMutableArray *newLocArray = [NSMutableArray arrayWithCapacity:0];
//                [newLocArray addObject:newLoc];
//                [[Common getAppDelegate].stepCounterObj.locPointsArray addObject:newLocArray];
//            }
//        }else{
//            //添加第一个点
//            
//            if([Common getAppDelegate].stepCounterObj.dashFirstFlag == NO){
//                [Common getAppDelegate].stepCounterObj.localFirstFlag = YES;
//            }
//            isDashPointFlag = NO;
//            NSMutableArray *lastArray = [[Common getAppDelegate].stepCounterObj.locPointsArray lastObject];
//            [lastArray addObject:newLoc];
//        }
//        [newLoc release];
//        
//       [Common getAppDelegate].stepCounterObj.lastPointIsDashFlag = NO;
//    }
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshRouteLineNotification" object:nil];
//        
//    });
    
}

/*
- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
    BOOL isStopCountering = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@isStopCountering",g_nowUserInfo.userid]];
    if(!isStopCountering && [UIApplication sharedApplication].applicationState != UIApplicationStateActive){
        //正在运行时 推入后台开启定位服务
        [self startSignificantChangeUpdates];
        [[Common getAppDelegate].stepCounterObj sendToBackground];
    }
    
//    NSLog(@"------pause----auto-pause");
}
*/

@end
