//
//  SteperHomeViewController.m
//  jiuhaohealth4.0
//
//  Created by wangmin on 15/8/17.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "SteperHomeViewController.h"
#import "ControlPanelView.h"
#import "AppDelegate.h"
#import <MapKit/MapKit.h>
#import "MyStepCounterHistoryViewController.h"
#import "BasicMapAnnotation.h"
#import "GetToken.h"
//#import "PostingViewController.h"
#import "LocationManager.h"

@interface SteperHomeViewController ()
<MKMapViewDelegate>
{
    CGFloat  mapHeight;
    UIView *fastShowView;
    UILabel *stepLabel;

    __block BOOL  expendingFlag;//展开
    __block  BOOL  isShowOverSpeedView;
    
    NSMutableArray *testLocals;
    BOOL hasAddAnnotation;
    UIView *backView;
    BOOL isShowShareView;
    UILabel *progressLabel;
    
    UIButton *saveBtn;
    BOOL availableFlag;
}

@property (nonatomic,retain) ControlPanelView *panelView;
@property (nonatomic, retain) MKMapView* mapView;
@property (nonatomic,retain) UILabel *timeLabel;

@property (nonatomic, retain) NSMutableArray* points;
@property (nonatomic, retain) MKPolyline* routeLine;
@property (nonatomic, retain) MKPolylineView* routeLineView;

@property (nonatomic, retain) BasicMapAnnotation *endAnnotation;

@property (nonatomic,retain) UIImage *mapViewImage;

@property (nonatomic,retain) NSMutableDictionary *publishPostsDic;

@end

@implementation SteperHomeViewController

@synthesize panelView,timeLabel;

- (void)dealloc
{
    self.panelView = nil;
    [self setMapView:nil];
    self.mapViewImage = nil;
    self.endAnnotation = nil;
    self.publishPostsDic = nil;
     [backView release];
    [Common getAppDelegate].customShareDelegate = nil;
    [self removeObserver];
    
    [super dealloc];
}

- (void)removeObserver
{
    AppDelegate* myDelegate = [Common getAppDelegate];
    
    [myDelegate.stepCounterObj removeObserver:self
                                   forKeyPath:@"speedString"];
    [myDelegate.stepCounterObj removeObserver:self
                                   forKeyPath:@"stepCount"];
    
    [myDelegate.stepCounterObj removeObserver:self
                                   forKeyPath:@"allCllString"];
    [[LocationManager sharedManager] removeObserver:self
                                   forKeyPath:@"gpsAccuracyString"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)goToUserInfo
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([Common getAppDelegate].stepCounterObj.stepCount.intValue > 0 && availableFlag){
            [[Common getAppDelegate].stepCounterObj writeToFileWithCurrentDic];
            [[Common getAppDelegate].stepCounterObj uploadDataRequest];
        }
    });
    
//    StepUserInfoViewController *memberInfotVC = [[StepUserInfoViewController alloc] init];
//    memberInfotVC.publishPostsDic = self.publishPostsDic;
//    memberInfotVC.isMeFlag = YES;
//    [self.navigationController pushViewController:memberInfotVC animated:YES];
//    [memberInfotVC release];

    MyStepCounterHistoryViewController *modeHisoryVC = [[MyStepCounterHistoryViewController alloc] init];
    //                    modeHisoryVC.publishPostsDic = self.publishPostsDic;
    [self.navigationController pushViewController:modeHisoryVC animated:YES];
    [modeHisoryVC release];
    
}

- (void)getRightNavView
{
//    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithTitle:@"计步历史 " style:UIBarButtonItemStylePlain target:self action:@selector(goToUserInfo)];
//    self.navigationItem.rightBarButtonItem = sendItem;
//    [sendItem release];
    self.navigationItem.rightBarButtonItem = [Common CreateNavBarButton3:self setEvent:@selector(goToUserInfo) setTitle:@"计步信息"];

//    UIView* navaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
//    UIBarButtonItem* rightBar = [[UIBarButtonItem alloc] initWithCustomView:navaView];
//    [navaView release];
//    self.navigationItem.rightBarButtonItem = rightBar;
//    [rightBar release];
//    
//    UIButton *right2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [right2 setImage:[UIImage imageNamed:@"common.bundle/nav/mySelf.png"] forState:UIControlStateNormal];
//    right2.frame = CGRectMake(40, 7, 30, 30);
//    [right2 addTarget:self action:@selector(goToUserInfo) forControlEvents:UIControlEventTouchUpInside];
//    [navaView addSubview:right2];
}


static int numberOfShakes = 3;//震动次数
static float durationOfShake = 0.5f;//震动时间
static float vigourOfShake = 0.2f;//震动幅度

- (CAKeyframeAnimation *)shakeAnimation:(CGRect)frame
{
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGMutablePathRef shakePath = CGPathCreateMutable();
    CGPathMoveToPoint(shakePath, NULL, CGRectGetMidX(frame), CGRectGetMidY(frame) );
    for (int index = 0; index < numberOfShakes; ++index)
    {
        CGPathAddLineToPoint(shakePath, NULL, CGRectGetMidX(frame) - frame.size.width * vigourOfShake,CGRectGetMidY(frame));
        CGPathAddLineToPoint(shakePath, NULL,  CGRectGetMidX(frame) + frame.size.width * vigourOfShake,CGRectGetMidY(frame));
    }
    CGPathCloseSubpath(shakePath);
    shakeAnimation.path = shakePath;
    shakeAnimation.duration = durationOfShake;
    CFRelease(shakePath);
    
    return shakeAnimation;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self getRightNavView];
    self.title = @"爱运动";
    
    [Common getAppDelegate].stepCounterObj.mySteperMode =  normalMode;//正常模式下
   
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, SCREEN_HEIGHT-44)];
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    [scrollView release];
    
    mapHeight = 200;
    mapHeight = kDeviceWidth * 250 / 375;
    if(IS_Small_INCH_SCREEN)
    {
        mapHeight = 150;
    }
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, mapHeight)];
    self.mapView.delegate = self;
    self.mapView.userInteractionEnabled = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeNone;
    [scrollView addSubview:self.mapView];
    [self.mapView release];
    
    UIButton *_modelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _modelBtn.frame = CGRectMake(kDeviceWidth-30-15, _mapView.size.height-15-30, 30, 30);
    [_modelBtn  setImage:[UIImage imageNamed:@"common.bundle/move/New/zoom_out.png"] forState:UIControlStateNormal];
    [_modelBtn setTitle:@"变" forState:UIControlStateNormal];
    [_modelBtn setTitleColor:[CommonImage colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [_modelBtn addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
    _modelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [scrollView addSubview:_modelBtn];
    
    //默认为No
     BOOL battery_saveFlag = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"battery_saveFlag"]];
    
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(kDeviceWidth-35-17, _mapView.size.height-15-30-57, 45, 57);
    [saveBtn setImage:[UIImage imageNamed:@"common.bundle/move/power_saving.png"] forState:UIControlStateNormal];
    [saveBtn setTitleColor:[CommonImage colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveFunc:) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [scrollView addSubview:saveBtn];
    saveBtn.transform = CGAffineTransformMakeScale(0.8, 0.8);

    backView = [[UIView alloc] initWithFrame:CGRectMake(15+22, 17, 0, 10)];
    backView.backgroundColor = [CommonImage colorWithHexString:@"91d000"];
    backView.tag = 109;
    [scrollView addSubview:backView];
   
    UIImage *gpsImage = [UIImage imageNamed:@"common.bundle/move/GPSSignal.png"];
    UIImageView *gpsSignalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, gpsImage.size.width, gpsImage.size.height)];
    gpsSignalImageView.image = gpsImage;
    [scrollView addSubview:gpsSignalImageView];
    [gpsSignalImageView release];
    
    //省点模式
    UIView *backViews = [[UIView alloc] initWithFrame:CGRectMake(0, -mapHeight, kDeviceWidth, mapHeight)];
    backViews.backgroundColor = [UIColor clearColor];
    backViews.tag = 1234;
    [scrollView addSubview:backViews];
    [backViews release];
    
    UIView *graybackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, mapHeight)];
    graybackView.backgroundColor = [UIColor blackColor];
    graybackView.alpha = 0.7;
    [backViews addSubview:graybackView];
    [graybackView release];
    

    UIImage *closeImage = [UIImage imageNamed:@"common.bundle/move/white_close.png"];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.tag = 1991;
    closeBtn.frame = CGRectMake(kDeviceWidth-closeImage.size.width-10-12, 15, closeImage.size.width+10, closeImage.size.height+10);
    [closeBtn addTarget:self action:@selector(closeSaveView:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:closeImage forState:UIControlStateNormal];
    [backViews addSubview:closeBtn];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToClose:)];
    [backViews addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    
    UIImage *openSaveModeImage = [UIImage imageNamed:@"common.bundle/move/save_img.png"];
    UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-openSaveModeImage.size.width)/2.0f, (mapHeight-openSaveModeImage.size.height)/2.0f, openSaveModeImage.size.width, openSaveModeImage.size.height)];
    saveImageView.image = openSaveModeImage;
    [backViews addSubview:saveImageView];
    [saveImageView release];
    if(IS_Small_INCH_SCREEN){
        
        saveImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    }
    
    
    if(battery_saveFlag){
        
        self.mapView.showsUserLocation = NO;
         self.mapView.userTrackingMode = MKUserTrackingModeNone;
        [[Common getAppDelegate] stopSingificantChangeUpdates];

        [UIView animateWithDuration:0.5 animations:^{
            backViews.transform = CGAffineTransformMakeTranslation(0, backViews.height);
        }];
    }else{
        self.mapView.showsUserLocation = YES;
        self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    }
    
    expendingFlag = NO;
    
    //全屏view
    fastShowView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44-50, kDeviceWidth, 50)];
    fastShowView.backgroundColor = [UIColor blackColor];
    fastShowView.alpha  = 0;
    [self.view addSubview:fastShowView];
    [fastShowView release];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44-50, kDeviceWidth, 50)];
    [self.view addSubview:view];
    view.tag = 1888;
    view.alpha = 0;
    [view release];

//    UILabel *progressBackLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, kDeviceWidth, 5)];
//    progressBackLabel.backgroundColor = [UIColor clearColor];//[CommonImage colorWithHexString:@"f2f2f2"];
//    [view addSubview:progressBackLabel];
//    [progressBackLabel release];
    
    progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, kDeviceWidth/2.0f, 5)];
    progressLabel.backgroundColor = [CommonImage colorWithHexString:@"ff5232"];
    [view addSubview:progressLabel];
    [progressLabel release];

    
    //步数
    stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth/2.0f, 50)];
    stepLabel.backgroundColor = [UIColor clearColor];
    stepLabel.textColor= [CommonImage colorWithHexString:@"ffffff"];
    stepLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    stepLabel.textAlignment = NSTextAlignmentCenter;
    stepLabel.numberOfLines = 0;
    stepLabel.attributedText = [self replaceRedColorWithNSString:[NSString stringWithFormat:@"%@ 步",[Common getAppDelegate].stepCounterObj.stepCount] andUseKeyWord:@"步" andWithFontSize:12];
    [fastShowView addSubview:stepLabel];
    [stepLabel release];

    //分割线
    UIView *alineView = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth/2.0-0.5,15, 0.5, 20)];
    alineView.backgroundColor = [CommonImage colorWithHexString:@"e5e5e5"];
    [fastShowView addSubview:alineView];
    [alineView release];
    //倒计时
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth/2.0f, 0, kDeviceWidth/2.0f, 50)];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor= [CommonImage colorWithHexString:@"ffffff"];
    timeLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.numberOfLines = 0.6;
    timeLabel.text = @"0:00:00";
    [fastShowView addSubview:timeLabel];
    [self.timeLabel release];


    self.panelView = [[ControlPanelView alloc] initWithFrame:CGRectMake(0, self.mapView.bottom, kDeviceWidth,kDeviceHeight-_mapView.bottom)];
    self.panelView.isOutdoorView = NO;
    [scrollView addSubview:panelView];
    [panelView release];

    
    availableFlag = YES;
    self.panelView.availableFlag  = YES;
    
    __block typeof(self) wself = self;
    self.panelView.callBackBlock = ^(void){
        [wself shouldShowAlertDevice];
    };
    
    scrollView.contentSize = CGSizeMake(kDeviceWidth, panelView.bottom);
    
    
    AppDelegate *myDelegate = [Common getAppDelegate];
    //    myDelegate.stepCounterObj.mySteperStatus = indoorStatus;
    
    //初始化各个View的值
    //步数
    panelView.stepLabel.text = myDelegate.stepCounterObj.stepCount;
    [panelView newProgress:myDelegate.stepCounterObj.stepCount];
    //时间
    int timeCount = myDelegate.stepCounterObj.timeCount;//时间
    [panelView initValueForTime:timeCount];
    //速度
    [panelView newValueForSpeed:myDelegate.stepCounterObj.speedString];//速度-一进入为0
    //距离
    NSString *userStepLength = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"stepLength%@",g_nowUserInfo.userid]];
    float  stepNum = [userStepLength floatValue];//m
    NSString *newDistanceString = [NSString stringWithFormat:@"%.2f",[myDelegate.stepCounterObj.stepCount intValue]*stepNum/1000];//km
    [panelView newValueForDistance:newDistanceString];
    //卡路里
    NSString *newCalString = [NSString stringWithFormat:@"%.0f", [myDelegate.stepCounterObj.allCllString floatValue]];
    [panelView newValueForCal:newCalString];
    
    __block typeof(self) weakSelf = self;
    
    panelView.endBtnBlock = ^(BOOL index){
        //关闭定位
        [weakSelf toResultView];
    };

    panelView.startBtnBlock = ^(BOOL index){
        //当index为1时定义为点击了开始需要设置计步器模式为室内模式，如果不点击开始退出后仍可以返回到选择模式页面
        if(index == YES){
            myDelegate.stepCounterObj.mySteperStatus = indoorStatus;
            
            if(weakSelf.endAnnotation){
                [weakSelf.mapView removeAnnotation:weakSelf.endAnnotation];
                weakSelf.endAnnotation = nil;
            }
            
        }else{
            //点击暂停时添加结束的大头针
            if(weakSelf.endAnnotation){
                [weakSelf.mapView removeAnnotation:weakSelf.endAnnotation];
                weakSelf.endAnnotation = nil;
            }
            NSArray *lastArray = nil;//[weakSelf.points lastObject];
            
            if([Common getAppDelegate].stepCounterObj.lastPointIsDashFlag){
                
                lastArray = [[Common getAppDelegate].stepCounterObj.dashPointsArray lastObject];
            }else{
                
                lastArray = [[Common getAppDelegate].stepCounterObj.locPointsArray lastObject];
            }
            
            if(lastArray.count){
                CLLocation *location = [lastArray lastObject];
                weakSelf.endAnnotation = [[BasicMapAnnotation alloc] initWithLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude tag:110];
                weakSelf.endAnnotation.title = @"终点";
                [weakSelf.mapView addAnnotation:weakSelf.endAnnotation];
                [weakSelf.endAnnotation release];
            }
        }
    };

    [myDelegate.stepCounterObj addObserver:self forKeyPath:@"speedString" options:NSKeyValueObservingOptionNew  context:NULL];
    [myDelegate.stepCounterObj addObserver:self forKeyPath:@"stepCount" options:NSKeyValueObservingOptionNew  context:NULL];
    [myDelegate.stepCounterObj addObserver:self forKeyPath:@"allCllString" options:NSKeyValueObservingOptionNew  context:NULL];
    [[LocationManager sharedManager] addObserver:self forKeyPath:@"gpsAccuracyString" options:NSKeyValueObservingOptionNew context:NULL];
    
    
    panelView.myTimerCountingBlock = ^(int currectCount ){
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
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshRouteLine) name:@"RefreshRouteLineNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RemoveRouteLine) name:@"RemoveRouteLineNotification" object:nil];

    [self performSelector:@selector(setDelegate) withObject:nil afterDelay:2];
    //填充分享数据
    [Common getAppDelegate].stepCounterObj.stepCount = [Common getAppDelegate].stepCounterObj.stepCount;
    [Common getAppDelegate].customShareDelegate = self;
    [self getCircleList];
    [self checkDeviceNo];
    [self performSelector:@selector(showUserLocationWithOutAnimation) withObject:nil afterDelay:1];
    
    
    NSInteger  countFlag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"NewhelpSFlagOfIndoor"] intValue];
    if(countFlag < 3){
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = [CommonImage colorWithHexString:@"000000" alpha:0.8];
        [self.view addSubview:view];
        
        UIImage *image = [UIImage imageNamed:@"common.bundle/move/move_help.png"];
        UIImageView *helpImv = [[UIImageView alloc] initWithImage:image];
        helpImv.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(0.8, 0.8), 0, -40);
        [view addSubview:helpImv];
        [helpImv release];
        helpImv.center = view.center;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(hiddenView:)];
        [view addGestureRecognizer:tapGesture];
        [tapGesture release];
    }

    
    
}

//显示用户位置信息
- (void)showUserLocationWithOutAnimation
{
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 1000, 1000)];
}

//清除用户线路
- (void)RemoveRouteLine
{
    NSArray *overLayers = self.mapView.overlays;
   
    for(id overLayer in overLayers){
        
        [self.mapView removeOverlay:overLayer];
    }
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.endAnnotation = nil;
    hasAddAnnotation = NO;
    
}

//检测设备
- (void)checkDeviceNo
{
    NSMutableDictionary* requestDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [requestDic setValue:[Common getMacAddress] forKey:@"deviceNo"];
    [requestDic setValue:[Common getAppDelegate].stepCounterObj.stepCount forKey:@"currentSteps"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:CheckExceptionPedometer values:requestDic requestKey:CheckExceptionPedometer delegate:self controller:self actiViewFlag:1 title:nil];
    [requestDic release];
}

//切换设备
- (void)alertDeviceRequest
{
    NSMutableDictionary* requestDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [requestDic setValue:[Common getMacAddress] forKey:@"deviceNo"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:AlterDeviceNo values:requestDic requestKey:AlterDeviceNo delegate:self controller:self actiViewFlag:0 title:nil];
    [requestDic release];
}

//点击关闭响应函数
-(void)tapToClose:(UITapGestureRecognizer *)tap
{
    UIButton *closeBtn = (UIButton *)[self.view viewWithTag:1991];
    [closeBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)closeSaveView:(UIButton *)btn
{
    CAKeyframeAnimation *ani=[self shakeAnimation:saveBtn.frame];
    [saveBtn.layer addAnimation:ani forKey:kCATransition];
    
    UIView *backViews = [btn.superview viewWithTag:1234];
    [UIView animateWithDuration:0.5 animations:^{
        saveBtn.alpha = 1.f;
        backViews.transform = CGAffineTransformIdentity;
    }];
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"battery_saveFlag"]];

    [[Common getAppDelegate] startSignificantChangeUpdates];
    [self.panelView checkLocationEnable];
}

//开启省电模式
- (void)saveFunc:(UIButton *)btn
{
    
    UIView *backViews = [btn.superview viewWithTag:1234];
        //为YES 开启省电模式 关闭 地图
    
    [[Common getAppDelegate] stopSingificantChangeUpdates];
    [LocationManager sharedManager].gpsAccuracyString = @"-3";
    self.mapView.showsUserLocation = NO;
    self.mapView.userTrackingMode = MKUserTrackingModeNone;
    
    [UIView animateWithDuration:0.5 animations:^{
        saveBtn.alpha = 0.f;
        backViews.transform = CGAffineTransformMakeTranslation(0, backViews.height);
    }];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"battery_saveFlag"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [panelView newProgress:[Common getAppDelegate].stepCounterObj.stepCount];
}

//获取圈子数据
- (void)getCircleList
{
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GetPublishedGroupList values:[NSDictionary dictionary] requestKey:GetPublishedGroupList delegate:self controller:self actiViewFlag:0 title:nil];
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    if ([dic[@"head"][@"state"] isEqualToString:@"0000"])
    {
        if ([loader.username isEqualToString:GetPublishedGroupList]) {
            NSArray *circlesArray = dic[@"body"][@"list"];
            self.publishPostsDic = [NSMutableDictionary dictionaryWithCapacity:0];
            for(NSDictionary *dic in circlesArray){
                NSString *groupId = dic[@"id"];
                NSString *groupName = dic[@"title"];
                [self.publishPostsDic setObject:groupId forKey:groupName];
            }
            
        }else if ([loader.username isEqualToString:CheckExceptionPedometer]) {
            NSDictionary *bodyDic = dic[@"body"];
            availableFlag = [[NSString stringWithFormat:@"%@",bodyDic[@"info"][@"isAvailable"]] boolValue];
            self.panelView.availableFlag = availableFlag;
            
        }else if ([loader.username isEqualToString:AlterDeviceNo]) {
            NSDictionary *bodyDic = dic[@"body"];
            availableFlag = YES;
            self.panelView.availableFlag = YES;
            NSDictionary *infoDic = bodyDic[@"info"];
            
            [[[Common getAppDelegate] stepCounterObj] loadServerDataWithDic:infoDic];
            
            [self.panelView  startBtnClick:nil];
        }

    }else{
        [Common TipDialog:dic[@"head"][@"msg"]];
    }
}

//刷新路线
- (void)RefreshRouteLine
{
    //先移除线路
    [self RemoveRouteLine];
    [self getNormalRouteLine];
    [self getDashRouteLine];
}


- (void)getNormalRouteLine
{
    self.points =  [Common getAppDelegate].stepCounterObj.locPointsArray;
    if(((NSArray *)[self.points lastObject]).count % 10 == 0){
        [[Common getAppDelegate].stepCounterObj writeToFileWithCurrentDic];
    }
    for(NSArray *points in self.points){
        if(points.count == 0){
            continue;
        }
        [self configureRoutes:points normal:YES];
        if(points.count && !hasAddAnnotation  && [Common getAppDelegate].stepCounterObj.localFirstFlag){
            hasAddAnnotation = YES;
            CLLocation *location = [points objectAtIndex:0];
            
            BasicMapAnnotation *startAnnotation = [[BasicMapAnnotation alloc] initWithLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude tag:111];
            startAnnotation.title = @"起点";
            self.mapView.delegate = self;
            [self.mapView addAnnotation:startAnnotation];
            [startAnnotation release];
        }
    }
    
    
    
}

- (void)getDashRouteLine
{
    
    self.points =  [Common getAppDelegate].stepCounterObj.dashPointsArray;
    if(((NSArray *)[self.points lastObject]).count % 10 == 0){
        [[Common getAppDelegate].stepCounterObj writeToFileWithCurrentDic];
    }
    for(NSArray *points in self.points){
        if(points.count == 0){
            continue;
        }
        [self configureRoutes:points normal:NO];
        if(points.count && !hasAddAnnotation && [Common getAppDelegate].stepCounterObj.dashFirstFlag){
            hasAddAnnotation = YES;
            CLLocation *location = [points objectAtIndex:0];
            
            BasicMapAnnotation *startAnnotation = [[BasicMapAnnotation alloc] initWithLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude tag:111];
            startAnnotation.title = @"起点";
            self.mapView.delegate = self;
            [self.mapView addAnnotation:startAnnotation];
            [startAnnotation release];
        }
    }
    
}


#pragma mark -- Map View
- (void)configureRoutes:(NSArray *)pointsArray normal:(BOOL)normal
{
    // define minimum, maximum points
    MKMapPoint northEastPoint = MKMapPointMake(0.f, 0.f);
    MKMapPoint southWestPoint = MKMapPointMake(0.f, 0.f);
    
    // create a c array of points.
    MKMapPoint* pointArray = malloc(sizeof(CLLocationCoordinate2D) * pointsArray.count);
    
    // for(int idx = 0; idx < pointStrings.count; idx++)
    for(int idx = 0; idx < pointsArray.count; idx++)
    {
        CLLocation *location = [pointsArray objectAtIndex:idx];
        CLLocationDegrees latitude  = location.coordinate.latitude;
        CLLocationDegrees longitude = location.coordinate.longitude;
        
        // create our coordinate and add it to the correct spot in the array
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        MKMapPoint point = MKMapPointForCoordinate(coordinate);
        
        // if it is the first point, just use them, since we have nothing to compare to yet.
        if (idx == 0) {
            northEastPoint = point;
            southWestPoint = point;
        } else {
            if (point.x > northEastPoint.x)
                northEastPoint.x = point.x;
            if(point.y > northEastPoint.y)
                northEastPoint.y = point.y;
            if (point.x < southWestPoint.x)
                southWestPoint.x = point.x;
            if (point.y < southWestPoint.y)
                southWestPoint.y = point.y;
        }
        
        pointArray[idx] = point;
    }
    
    //    if (self.routeLine) {
    //        [self.mapView removeOverlay:self.routeLine];
    //    }
    
    self.routeLine = [MKPolyline polylineWithPoints:pointArray count:pointsArray.count];
    // add the overlay to the map
    self.routeLine.title = normal?@"0":@"1";
    if (nil != self.routeLine) {
        [self.mapView addOverlay:self.routeLine];
    }
    
    // clear the memory allocated earlier for the points
    free(pointArray);
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.mapView = nil;
    self.routeLine = nil;
    self.routeLineView = nil;
}

#pragma mark MKMapViewDelegate

- (void)setDelegate
{
    self.mapView.delegate = self;
    [self RefreshRouteLine];
    
}

- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews
{
    NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
    NSLog(@"overlayViews: %@", overlayViews);
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
    
    MKOverlayView* overlayView = nil;
    //    if(overlay == self.routeLine)
    if([overlay isKindOfClass:[MKPolyline class]])
    {
        //if we have not yet created an overlay view for this overlay, create it now.
        //        if (self.routeLineView) {
        //            [self.routeLineView removeFromSuperview];
        //        }
        
        //        self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
        self.routeLineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        self.routeLineView.fillColor = [CommonImage colorWithHexString:@"057dff"];
        self.routeLineView.strokeColor = [CommonImage colorWithHexString:@"057dff"];
        self.routeLineView.lineWidth = 8;
        
        //虚线开关
        MKPolyline *lineoverlay = (MKPolyline *)overlay;
        if([lineoverlay.title isEqualToString:@"1"]){
            lineoverlay.title = nil;
            self.routeLineView.lineDashPhase = 20;
            NSArray* array = [NSArray arrayWithObjects:[NSNumber numberWithInt:20],[NSNumber numberWithInt:20],nil];
            self.routeLineView.lineDashPattern = array;
            
        }else{
            lineoverlay.title = nil;
            self.routeLineView.lineDashPhase = 0;
            self.routeLineView.lineDashPattern = nil;
        }
        
        overlayView = self.routeLineView;
    }
    
    return [overlayView autorelease];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BasicMapAnnotation class]])
    {
        BasicMapAnnotation *basicMapAnnotation = (BasicMapAnnotation *)annotation;
        MKAnnotationView *annotationView =[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView)
        {
            annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:@"CustomAnnotation"] autorelease];
            annotationView.canShowCallout = YES;
        }
        
        if(basicMapAnnotation.tag == 111){
            annotationView.image = [UIImage imageNamed:@"common.bundle/move/startPoint.png"];
        }else if(basicMapAnnotation.tag == 110){
            annotationView.image = [UIImage imageNamed:@"common.bundle/move/endPoint.png"];
        }
        
        return annotationView;//[annotationView autorelease];
    }else{
        
        
        
        
    }
    
    return nil;
}


- (NSMutableAttributedString *)replaceRedColorWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )size
{
    NSMutableAttributedString *attrituteString = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:@"ffffff"], NSFontAttributeName : [UIFont systemFontOfSize:size]} range:range];
    return attrituteString;
}

//改变大小
- (void)changeBtn:(UIButton *)btn
{
    UIScrollView *scrollView = (UIScrollView *)btn.superview;
    expendingFlag = !expendingFlag;
    if(!expendingFlag){
        fastShowView.alpha = 0;
        [btn  setImage:[UIImage imageNamed:@"common.bundle/move/New/zoom_out.png"] forState:UIControlStateNormal];
    }else{
        scrollView.contentOffset = CGPointMake(0, 0);
        [btn  setImage:[UIImage imageNamed:@"common.bundle/move/New/zoom_in.png"] forState:UIControlStateNormal];
    }
    
    __block typeof(self) wself = self;
    UIView *view = [self.view viewWithTag:1888];
    view.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        wself.mapView.frame = CGRectMake(0, 0, kDeviceWidth, expendingFlag == YES?SCREEN_HEIGHT-44:mapHeight);
        wself.panelView.transform = CGAffineTransformMakeTranslation(0, expendingFlag == YES? SCREEN_HEIGHT-44-mapHeight:0);
        btn.transform = CGAffineTransformMakeTranslation(0, expendingFlag == YES? _mapView.size.height-mapHeight-50:0);
        
        saveBtn.alpha = expendingFlag == YES? 0 : 1;

        
    } completion:^(BOOL finished) {
        if(expendingFlag){
            [UIView animateWithDuration:1 animations:^{
                
                UIView *view = [self.view viewWithTag:1888];
                 view.alpha = 1;
                
                fastShowView.alpha = 0.6;
            }];
        }else {
            fastShowView.alpha = 0;
            UIView *view = [self.view viewWithTag:1888];
            view.alpha = 0;
        }
    }];
}

- (void)hiddenView:(UITapGestureRecognizer *)tap
{
    NSInteger  countFlag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"NewhelpSFlagOfIndoor"] intValue];
    countFlag++;
    NSString *str = [NSString stringWithFormat:@"%d",(int)countFlag];
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"NewhelpSFlagOfIndoor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    countFlag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"NewhelpSFlagOfIndoor"] intValue];


    UIView *view = tap.view;
    [UIView animateWithDuration:0.6 animations:^{
        view.transform = CGAffineTransformMakeScale(1.5, 1.5);
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        
    }];
}


#pragma mark - 分享相关

- (void)toResultView
{
    
    [self shareFunc];
}

- (void)shareFunc
{
    if(isShowShareView == YES){
        return;
    }
    isShowShareView = YES;
    [self scollMapView];
    [self performSelector:@selector(resetShowShareViewFlag) withObject:nil afterDelay:1];
    
}

- (void)resetShowShareViewFlag
{
    isShowShareView = NO;
}

// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
//    NSString *msg = nil ;
//    if(error != NULL){
//        msg = @"保存图片失败" ;
//    }else{
//        msg = @"保存图片成功" ;
//    }

}

- (void)scollMapView
{
   
    MKCoordinateSpan span=MKCoordinateSpanMake(0.2, 0.2);
    MKCoordinateRegion region=MKCoordinateRegionMake(self.mapView.userLocation.location.coordinate, span);
    [_mapView setRegion:region animated:true];
    [self performSelector:@selector(getCurrentMapView) withObject:nil afterDelay:0.6];
}

- (void)getCurrentMapView
{
   
    UIImage *mapImage = [CommonImage  imageWithView:self.view forSize:CGSizeMake(kDeviceWidth, IS_Small_INCH_SCREEN?_mapView.bottom+200:_mapView.bottom+220)];
    [self showLoadingActiview];
    self.mapViewImage = mapImage;
//    UIImageWriteToSavedPhotosAlbum(mapImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    __block typeof(self) weakSelf = self;
   
    NSData *data = UIImageJPEGRepresentation(mapImage, Define_picScale);
    [GetToken submitData:data withBlock:^(BOOL isOK,NSString*st) {
        NSLog(@"--%@",st);
         [weakSelf stopLoadingActiView];
        if (!isOK) {
            [Common TipDialog2:@"图片上传失败，请检查网络是否正常!"];
        }
        else
        {
            AppDelegate *myAppDelegate = [Common getAppDelegate];
            NSMutableDictionary *shareDic = [NSMutableDictionary dictionaryWithDictionary:
                                             myAppDelegate.stepShareDic];
            [shareDic setObject:g_nowUserInfo.filePath forKey:@"img"];
            [shareDic setObject:g_nowUserInfo.nickName forKey:@"name"];
            if(!myAppDelegate.stepCounterObj.timeCount){
                myAppDelegate.stepCounterObj.timeCount = 0;
            }
            
            NSLog(@"%@",myAppDelegate.stepCounterObj.allCllString);
            
            [shareDic setObject:[NSString stringWithFormat:@"%.0f",myAppDelegate.stepCounterObj.timeCount / 60.0f] forKey:@"time"];
            float costTime = [myAppDelegate.stepCounterObj.costTimeString floatValue];//h
            
            NSString *distance = shareDic[@"distance"];//km
            NSString *speed = [NSString stringWithFormat:@"%.2f",distance.floatValue/(costTime)];
            if(costTime == 0){
                speed = @"0";
            }
            [shareDic setObject:speed forKey:@"speed"];//速度km/h
            [shareDic setObject:st forKey:@"trailimg"];//地图
            [shareDic setObject:[NSString stringWithFormat:@"%.0f",myAppDelegate.stepCounterObj.allCllString.floatValue] forKey:@"cal"];//卡路里

            myAppDelegate.stepShareDic = shareDic;
            weakSelf.shareCustomItem = YES;
            //组织url
            weakSelf.shareTitle = @"【康迅360】- 动起来";
            weakSelf.shareContentString = [NSString stringWithFormat:@"走走更健康，我走了%@步敢来挑战么？",myAppDelegate.stepShareDic[@"step"]];
            
            NSMutableString *myshareURL = [NSMutableString stringWithFormat:@"%@sport.html?",Share_Server_URL];
            NSArray *allKeys = myAppDelegate.stepShareDic.allKeys;
            for(NSString *key in allKeys){
                
                [myshareURL  appendFormat:@"%@=%@&",key,myAppDelegate.stepShareDic[key]];
            }
            NSString  *lastshareURL = [myshareURL substringToIndex:myshareURL.length-1];
            lastshareURL = [lastshareURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            weakSelf.shareURL = lastshareURL;
            [weakSelf goToShare];
        }
    } withName:nil];
    
}

- (void)sendPostToCircle
{
//    //发帖
//    PostingViewController * posting = [[PostingViewController alloc]init];
//    posting.isFromSteperView = YES;
//    posting.groupIdsDic = self.publishPostsDic;
//    NSMutableDictionary *dict = [@{@"groupId":@""} mutableCopy];
//    posting.m_superDic = dict;
//    
//    CommonNavViewController *nav = [[CommonNavViewController alloc] initWithRootViewController:posting];
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
//    
//    [posting release];
//    [dict release];
//    [posting initImageCount];
//    [posting setImageWithDate:self.mapViewImage];
}

#pragma mark 超速提醒相关

- (void)getOverSpeedView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -mapHeight, kDeviceWidth, mapHeight)];
    view.tag = 999;
    view.backgroundColor = [CommonImage colorWithHexString:@"000000" alpha:0.8];
    [self.view addSubview:view];
    [view release];
    
    UIImage *image = [UIImage imageNamed:@"common.bundle/move/overspeedpic.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-image.size.width)/2.0, (mapHeight-image.size.height)/2.0-8, image.size.width, image.size.height)];
    imageView.tag = 997;
    imageView.image = image;
    [view addSubview:imageView];
    [imageView release];
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom-25, kDeviceWidth, 30)];
    labTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:13];
    labTitle.numberOfLines = 2;
    labTitle.text = @"速度太快，要变超人啦(＞﹏＜)";
    labTitle.textColor = [UIColor whiteColor];
    labTitle.tag = 998;
    labTitle.textAlignment = NSTextAlignmentCenter;
    [view addSubview:labTitle];
    [labTitle release];
    
}

//显示超速view
- (void)showOverSpeedView:(BOOL)senderForTy
{
    UIView *view = [self.view viewWithTag:999];
    if(view == nil){
        [self getOverSpeedView];
    }
    view = [self.view viewWithTag:999];
    UILabel *labTitle = (UILabel *)[view viewWithTag:998];
    UIImageView *imageView = (UIImageView *)[view viewWithTag:997];
    if(senderForTy){
        UIImage *image = [UIImage imageNamed:@"common.bundle/move/tyoverspeed.png"];
        imageView.image = image;
        labTitle.text = @"超出糖友的正常行走速度啦! 要注意您的血糖";
    }else{
        UIImage *image = [UIImage imageNamed:@"common.bundle/move/overspeedpic.png"];
        imageView.image = image;
        labTitle.text  = @"速度太快，要变超人啦(＞﹏＜)";
    }
    if(isShowOverSpeedView){
        return;
    }
    isShowOverSpeedView = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        view.transform = CGAffineTransformMakeTranslation(0, view.height);
    } completion:^(BOOL f) {
        //        [UIView animateWithDuration:0.3 delay:3 options:UIViewAnimationOptionCurveLinear animations:^{
        //            labTitle.transform = CGAffineTransformIdentity;
        //        } completion:^(BOOL f) {
        //            [view removeFromSuperview];
        //        }];
    }];
}

- (void)hiddenOverSpeedView
{
    UIView *view = [self.view viewWithTag:999];
    
    if(!view)
    {
        return;
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL f) {
        [view removeFromSuperview];
        isShowOverSpeedView = NO;
        
    }];
    
}

/**
 *  观察属性变化
 *
 *  @param keyPath
 *  @param object
 *  @param change
 *  @param context
 */
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    
    NSLog(@"---KEYPATH:%@,OBJECT:%@,CHANGE:%@", keyPath, object, change);
    
    //获得新值
    NSString* newString = [NSString stringWithFormat:@"%@",[change objectForKey:@"new"]];
    
    if([newString isKindOfClass:[NSNull class]]){
        return;
    }
    if ([keyPath isEqualToString:@"speedString"]) {
        NSString *newSpeedString = [NSString stringWithFormat:@"%@", newString];
        [panelView newValueForSpeed:newSpeedString];
        if((newSpeedString.floatValue != 0 && g_nowUserInfo.maxSpeed != 0 ) && (newSpeedString.floatValue > g_nowUserInfo.maxSpeed * 3.6)){
            [self showOverSpeedView:NO];
        }else if( (newSpeedString.floatValue != 0 && g_nowUserInfo.maxSpeedOfPatient != 0 ) && (newSpeedString.floatValue > g_nowUserInfo.maxSpeedOfPatient * 3.6)){
            [self showOverSpeedView:YES];
        }else{
            [self hiddenOverSpeedView];
        }
    }
    else if ([keyPath isEqualToString:@"stepCount"]) {
            //总步数
            NSString *newStepCount = [NSString stringWithFormat:@"%@", newString];
            self.panelView.stepLabel.text = newStepCount;
            //更新总距离
            NSString *userStepLength = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"stepLength%@",g_nowUserInfo.userid]];
            float  stepNum = [userStepLength floatValue];//m
            stepLabel.attributedText = [self replaceRedColorWithNSString:[NSString stringWithFormat:@"%@ 步",newStepCount] andUseKeyWord:@"步" andWithFontSize:12];
            NSString *newDistanceString = [NSString stringWithFormat:@"%.2f",[newStepCount intValue]*stepNum/1000];//km
            [panelView newValueForDistance:newDistanceString];
            [panelView  newProgress:newStepCount];
        
        CGRect rect = progressLabel.frame;
        CGFloat width = kDeviceWidth * newStepCount.floatValue / [Common getAppDelegate].stepCounterObj.targetStep;
        if (width < 0.01){
            width = 0.01;
        }
        if(width > kDeviceWidth){
            width = kDeviceWidth;
        }

        rect.size.width = width;
        progressLabel.frame = rect;
            //更新分享数据---步数
                AppDelegate *myAppDelegate = [Common getAppDelegate];
                NSMutableDictionary *shareDic = [NSMutableDictionary dictionaryWithDictionary:myAppDelegate.stepShareDic];
                [shareDic setObject:newStepCount forKey:@"step"];//步
                [shareDic setObject:newDistanceString forKey:@"distance"];//km
                myAppDelegate.stepShareDic = shareDic;
        }else if ([keyPath isEqualToString:@"allCllString"]) {
            //总卡路里
            NSString *newCalString = [NSString stringWithFormat:@"%.0f", [newString floatValue]];
            //        self.panelView.calLabel.text = newCalString;
            [panelView newValueForCal:newCalString];
        }else if ([keyPath isEqualToString:@"gpsAccuracyString"]) {
            //信号强度
            if (newString.intValue < 0)
            {
                // No Signal
               backView.frame = CGRectMake(15+22, 17, 0, 10);
            }
            else if (newString.intValue > 163)
            {
                // Poor Signal
                 backView.frame = CGRectMake(15+22, 17, 12, 10);
            }
            else if (newString.intValue > 48)
            {
                // Average Signal
                if(newString.intValue < 48+(163-48)/2.0f){
                //更强点
                    backView.frame = CGRectMake(15+22, 17, 24, 10);

                }else{
                //更弱点
                    backView.frame = CGRectMake(15+22, 17, 18, 10);
                }
            }
            else
            {
                // Full Signal
                 backView.frame = CGRectMake(15+22, 17, 30, 10);
            }
        }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//提示切换设备
- (void)shouldShowAlertDevice
{
    NSString  *message = @"检测到今日您已用过其它设备计步，确认要切换设备进行计步么？";
    NSString  *okMes = @"切换";
    NSString  *cancelMes = @"不切换";
    
    //提示是否更换
    UIAlertView* av = [[UIAlertView alloc]
                       initWithTitle:NSLocalizedString(@"提示", nil)
                       message:NSLocalizedString(message,
                                                 nil)
                       delegate:self
                       cancelButtonTitle:NSLocalizedString(cancelMes, nil)
                       otherButtonTitles:NSLocalizedString(okMes, nil), nil];
    
    av.tag = 110;
    [av show];
    [av release];
    
    
}

- (void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 110 && buttonIndex == 1){
        [self alertDeviceRequest];
    }
}


#pragma mark - 测试代码
- (void)addPoint
{
    NSMutableArray *group2 = [NSMutableArray arrayWithCapacity:0];
    for(int i = 0 ; i < 100; i++){
        
        CLLocation *location;
        if(i == 0){
            location  = [[CLLocation alloc] initWithLatitude:+40.01899976 longitude:+116.48611856];
        }else {
            location = [group2 objectAtIndex:i-1];
            location = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude+0.0001];
        }
        
        [group2 addObject:location];
    }
    [testLocals addObject:group2];
    [Common getAppDelegate].stepCounterObj.locPointsArray = testLocals;
    [self RefreshRouteLine];
    
}

- (void)centerBtn
{
    [[Common getAppDelegate] startSignificantChangeUpdates];
    return;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.location.coordinate, 1000, 1000);
    [self.mapView setRegion:region animated:YES];
    
}

@end