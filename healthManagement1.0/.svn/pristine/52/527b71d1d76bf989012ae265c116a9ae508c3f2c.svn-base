//
//  LocationManager.h
//  jiuhaohealth4.0
//
//  Created by wangmin on 15/9/10.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationManager : NSObject


@property (nonatomic,retain) NSString *localStateString;//第一位置//xx省 北京市
@property (nonatomic,retain) NSString *localSubLocationString;//第二位置 朝阳区
@property (nonatomic,retain) NSString *localCityString;//城市名称

@property (nonatomic,retain) NSString *gpsAccuracyString;//002731


+ (LocationManager *)sharedManager;

- (void)requestLocationAuthorization;

- (void)startSignificantChangeUpdates;

- (void)stopSingificantChangeUpdates;

@end
