//
//  AppDelegate.m
//  jiuhaoHealth2.0
//
//  Created by 徐国洪 on 14-3-4.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import "AppDelegate.h"
#import "Global.h"
#import "LoginViewController.h"
#import "CommonHttpRequest.h"
#import "JPUSHService.h"
#import <AVFoundation/AVAudioPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import "GuideViewController.h"
#import "AdvView.h"
#import "MobClick.h"
#import "SFHFKeychainUtils.h"
#import "HomeModel.h"
#include "NotificationViews.h"
#import "LocationManager.h"
#import "SDImageCache.h"
#import "HMHomeViewController.h"
#import "KXShareManager.h"
#import "KXPayManage.h"
#import "WXApiManager.h"
#import "FirstLogingViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <JSPatchPlatform/JSPatch.h>

@interface AppDelegate()

@end

@implementation AppDelegate
{
    AVAudioPlayer *alarmPlayer;
    long lastTime;
    int count;
    
}
@synthesize navigationVC;

- (void)dealloc
{
    [alarmPlayer release];
    self.tokenID = nil;
    self.channelID = nil;
    self.navigationVC = nil;
//    self.stepCounterObj = nil;
    self.stepShareDic = nil;
    
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (IOS_7) {
//                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UINavigationBar appearance] setBarTintColor:[CommonImage colorWithHexString:@"ffffff"]];
        [[UINavigationBar appearance] setTintColor:[CommonImage colorWithHexString:The_ThemeColor]];
        
        [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
//        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        UIFont* font = [UIFont systemFontOfSize:20];
        NSDictionary* textAttributes = @{NSFontAttributeName:font, NSForegroundColorAttributeName:[CommonImage colorWithHexString:@"333333"]};
        [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    }
    else {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        
        [application setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
        [[UINavigationBar appearance] setTintColor:[CommonImage colorWithHexString:The_ThemeColor]];
    }
    
    [JSPatch testScriptInBundle];
    //    [JSPatch startWithAppKey:@"8a129bd5fa04e25c"];
    //    [JSPatch sync];

    
    [Common addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:DOC_PATH]];
    
    //-----------------start 全局初始化-----------------
    g_winDic = [[NSMutableDictionary alloc] init];
    
    [g_winDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
    
    g_iconArrayLock = [[NSLock alloc] init];
    g_imageArrayDic = [[NSMutableDictionary alloc] init];
    
    //应用注册Push通知
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(networkDidSetup:) name:kJPFNetworkDidSetupNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidClose:) name:kJPFNetworkDidCloseNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidRegister:) name:kJPFNetworkDidRegisterNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    
    [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    
    //设置默认城市
    [LocationManager sharedManager].localStateString = @"北京";
    [LocationManager sharedManager].localSubLocationString = @"北京";
    [LocationManager sharedManager].localCityString = @"北京";
    
    [self umengTrack];
    //----------------------end-----------------------
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR];

    
    UIViewController *view;
    
    //本地标示
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int GuideVersion = [[userDefaults objectForKey:@"GuideVersion"] intValue];
    
    //plist-标示
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    int newGuideVersion = [[infoDic objectForKey:@"GuideVersion"] intValue];
    
    if (0 && newGuideVersion > GuideVersion)
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"checkstatus"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        view = [[GuideViewController alloc] init];
    }
    else
    {
        //申请地理位置权限
//        [[LocationManager sharedManager] requestLocationAuthorization];
//        BOOL isAotuLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"checkstatus"] boolValue];
        UIViewController * view1;
        if ([CommonUser getUserPswd]) {
            view1 = [[LoginViewController alloc] init];
        }else{
            view1 = [[FirstLogingViewController alloc] init];
        }
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        view = [[CommonNavViewController alloc] initWithRootViewController:view1];
        [view1 release];
        
    }
    application.applicationIconBadgeNumber = 0;
    [JPUSHService setupWithOption:launchOptions];
    //本地通知
    UILocalNotification *theNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (theNotification)
    {
        [NotificationViews shareInstance].notifiDic = theNotification.userInfo;
        [self stopSound];
    }
    //远程通知
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo)
    {
        [NotificationViews shareInstance].notifiDic = userInfo;
    }
    
    self.window.rootViewController = view;//view;
    [view release];
    
    [self.window makeKeyAndVisible];
    
    [KXShareManager sharedManager];
    [KXPayManage setUpPayManage];//支付
    [self sendSetUpdateLog];
    [self loadDataBegin];
    
//    self.stepCounterObj = [[StepCounterLogic alloc] init];
    
    //广告
    [self getAdvPic];
    [self loadCallBoard];
    
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onPlayMusic" object:nil];
    self.isActiveFlag = YES;
    application.applicationIconBadgeNumber = 0;
    
//    [self.stepCounterObj stopBackTimer];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"open_Url" object:nil];
    [NotificationViews  handleRemoteNotificationWithUserInfo:nil];
    
    //通知显示支付结果
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showZhifujieguo" object:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    self.isActiveFlag = NO;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onParuseMusic" object:nil];
    
    BOOL isStopCountering = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@isStopCountering",g_nowUserInfo.userid]];
    if(!isStopCountering){
        //正在运行时 推入后台开启定位服务
        [[LocationManager sharedManager] startSignificantChangeUpdates];
//        [self.stepCounterObj sendToBackground];
    }else{
        //否则关闭
        [[LocationManager sharedManager] stopSingificantChangeUpdates];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:kRfreshHome object:nil];
    //进入前台关闭后台服务
//    [self.stepCounterObj stopRuningInBackground];
    
    //    versioncheck_xhtml
    NSDictionary *body = [[NSUserDefaults standardUserDefaults] objectForKey:@"versioncheck_xhtml"];
    if (body) {
        BOOL isCheck = [[body objectForKey:@"is_force_update"] boolValue];
        int version_no = [[body objectForKey:@"version_no"] intValue];
        
        if (isCheck && version_no > (int)CFBundleVersion) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"升级提示",nil) message:body[@"version_desc"] delegate:self cancelButtonTitle:NSLocalizedString(@"确认升级",nil) otherButtonTitles:nil, nil];
            av.tag = 66;
            [av show];
            [av release];
        }
        else {
            //强制升级标签
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"versioncheck_xhtml"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [self stopSound];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    [self.stepCounterObj writeToFileWithCurrentDic];//写入
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //	NSString *str = [NSString stringWithFormat:@"%@", deviceToken];
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

//ios8 之前
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // 取得 APNs 标准信息内容
    //    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    //    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    //    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    //    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    if (!application.applicationState == UIApplicationStateActive)//非正在运行状态
    {
        [NotificationViews shareInstance].notifiDic = userInfo;
    }
    // Required
    [JPUSHService handleRemoteNotification:userInfo];
}

//iOS 8 Remote Notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    switch ([[userInfo objectForKey:@"type"] intValue]) { //1预警 2.系统消息 3.@消息
        case 1:
            //            g_nowUserInfo.warningNotReadNum += 1;
            break;
        case 2:
            g_nowUserInfo.broadcastNotReadNum += 1;
            break;
        case 3:
            g_nowUserInfo.myMessageNoReadNum +=1;
            
            break;
    }
    g_nowUserInfo.totalunreadMsgCount += 1;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayAudio" object:userInfo];
    if (!application.applicationState == UIApplicationStateActive)//非正在运行状态
    {
        [NotificationViews shareInstance].notifiDic = userInfo;
    }
    // Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNoData);
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [self KxHandleUrl:url];
}

-(BOOL)KxHandleUrl:(NSURL *)url
{
    NSString *todayButtonTitle = [url host];
    if ([url.scheme isEqualToString:kWXAppID])
    {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    else if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);//返回的支付结果
        }];
    }
//    [ShareSDK handleOpenURL:url
//          sourceApplication:sourceApplication
//                 annotation:annotation
//                 wxDelegate:nil];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [self KxHandleUrl:url];
}

#pragma mark 接受本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    application.applicationIconBadgeNumber -= 1;
    NSDictionary *NotDict = notification.userInfo;
    
    if (![notification.userInfo[@"ActivityClock"] isEqualToString:@"123456789"])
    {
        if (application.applicationState == UIApplicationStateInactive )
        {
            [NotificationViews shareInstance].notifiDic = notification.userInfo;
            if (alarmPlayer)
            {
                [alarmPlayer stop];
            }
            NSLog(@"app not running");
        }
        else if(application.applicationState == UIApplicationStateActive )
        {
            NSLog(@"didFinishLaunchingWithOptions");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:notification.alertBody delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [self createAudioplyerWithSoundName:notification.soundName];
            alert.tag = 10001;
            [alarmPlayer play];
            [alert show];
            if ([NotDict[@"isShake"] isEqualToString:@"Y"])
            {
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);//震动
            }
            NSLog(@"app running");
        }
    }
    if ([notification.userInfo[@"ActivityClock"] isEqualToString:@"123456789"])
    {
        NSLog(@"消除计步器数目!");
    }
    NSLog(@"Receive Notify: %@", notification.userInfo);
}

#pragma mark Locations API
- (void)startSignificantChangeUpdates
{
    [[LocationManager sharedManager] startSignificantChangeUpdates];
}

- (void)stopSingificantChangeUpdates
{
    [[LocationManager sharedManager] stopSingificantChangeUpdates];
}

#pragma mark - Tools
- (void)umengTrack {
    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
#if DEBUG
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
#endif
    [MobClick setAppVersion:BundleVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:VERSION_CHANNEL_ID];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    });
}

//广告
- (void)loadCallBoard
{
    BOOL isAotuLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"checkstatus"] boolValue];
    
    NSString *callBoardPath = [[NSUserDefaults standardUserDefaults] objectForKey:@"callBoard"];
    
    if (isAotuLogin || callBoardPath)
    {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight+64)];
        imageV.tag = 99;
        imageV.userInteractionEnabled = YES;
        NSString *str = @"Default.png";
        
        if (kDeviceHeight+64 == 568) {
            str = @"LaunchImage-700-568h";
        }
        else if (kDeviceHeight+64 == 667) {
            str = @"LaunchImage-800-667h";
        }
        else if (kDeviceHeight+64 == 736) {
            str = @"LaunchImage-800-Portrait-736h";
        }
        else {
            str = @"LaunchImage-700";
        }
        
        imageV.image = [UIImage imageNamed:str];
        [self.window addSubview:imageV];
        [imageV release];
        
        UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, imageV.height-100)];
        imageV2.tag = 454;
        imageV2.userInteractionEnabled = YES;
        imageV2.clipsToBounds = YES;
        imageV2.contentMode = UIViewContentModeScaleAspectFill;
        imageV2.image = [UIImage imageWithContentsOfFile:[[Common getImagePath] stringByAppendingFormat:@"/%@", callBoardPath]];
        [imageV addSubview:imageV2];
        //        [self.window addSubview:imageV2];
        [imageV2 release];
        
        if (!isAotuLogin || ![CommonUser getUserPswd]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                sleep(3);
                dispatch_async( dispatch_get_main_queue(), ^(void){
                    [UIView animateWithDuration:0.2 animations:^{
                        imageV.alpha = 0;
                        //                    imageV.transform = CGAffineTransformMakeScale(2, 2);
                    } completion:^(BOOL finished) {
                        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
                        [imageV removeFromSuperview];
                    }];
                });
            });
        }
    }
    else {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
}

- (void)setUserID:(NSString *)userID
{
    [JPUSHService setTags:[NSSet setWithObjects:userID,nil] alias:userID callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
}


//网络加载
- (void)loadDataBegin
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:VERSION_APPID forKey:@"appId"];
    [dic setObject:@"0" forKey:@"source"];
    [dic setObject:CFBundleVersion forKey:@"version"];
    [dic setObject:@"0" forKey:@"clientType"];
    [dic setObject:@"zh_CN" forKey:@"clientLanguage"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:URL_getCheck values:dic requestKey:URL_getCheck delegate:self controller:self actiViewFlag:0 title:0];
}

//Log
- (void)sendSetUpdateLog
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"sendSetUpdateLog"]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSNumber numberWithLong:[CommonDate getLongTime]] forKey:@"logTime"];
        [dic setObject:[Common getMacAddress] forKey:@"uniqueNum"];
        [dic setObject:[[UIDevice currentDevice] model] forKey:@"phoneModel"];
        [dic setObject:@"IOS" forKey:@"setupTerminal"];
        [dic setObject:@"app_store" forKey:@"channelId"];
        [dic setObject:@"com.jiuhaohealth.kangxun360.logback.log.app.SetupLogPojo" forKey:@"clazz"];
        NSString *str = [dic KXjSONString];
       
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        [dic2 setObject:str forKey:@"logJson"];
        [[CommonHttpRequest defaultInstance] sendNewPostRequest:Send_Log values:dic2 requestKey:Send_Log delegate:self controller:self actiViewFlag:0 title:0];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"sendSetUpdateLog"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//广告
- (void)getAdvPic
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:URL_getadv values:dic requestKey:URL_getadv delegate:self controller:self actiViewFlag:0 title:nil];
}

#pragma mark - Network Response Delegate

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary * dic = [responseString KXjSONValueObject];
    
    NSDictionary *head = [dic objectForKey:@"head"];
    if (![[head objectForKey:@"state"] intValue]) {
        
        NSDictionary *body = [dic objectForKey:@"body"];
        
        if ([loader.username isEqualToString:URL_getCheck]) {
            
            int is_force_update = [[body objectForKey:@"is_force_update"] intValue];
            if (is_force_update) {
                
                [[NSUserDefaults standardUserDefaults] setObject:body forKey:@"versioncheck_xhtml"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSString *cancle;
                if (is_force_update == 2) {
                    //强制升级标签
                    cancle = nil;
                }
                else {
                    cancle = @"取消";
                }
                
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"升级提示",nil) message:body[@"version_desc"] delegate:self cancelButtonTitle:NSLocalizedString(@"确认升级",nil) otherButtonTitles:cancle, nil];
                [av show];
                [av release];
            }
            else {
                //强制升级标签
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"versioncheck_xhtml"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        else if ([loader.username isEqualToString:URL_getadv]) {
            
            //            NSArray *array = [dic objectForKey:@"rs"];
            if ([body objectForKey:@"id"]) {
                //                NSDictionary *rs = [array objectAtIndex:0];
                
                [[NSUserDefaults standardUserDefaults] setObject:body forKey:@"ADVInfo"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSString *filepath = [[body objectForKey:@"img"] stringByAppendingFormat:@"?imageView2/1/w/%d/h/%d",(int)kDeviceWidth*2, (int)(kDeviceHeight + 64 - 100)*2];
//                NSString* strCon = [filepath stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
                NSString *strPath = [SDImageCache cachedFileNameForKey:filepath];
                
                UIImage *image = [UIImage imageWithContentsOfFile:[[Common getImagePath] stringByAppendingFormat:@"/%@", strPath]];
                if (!image) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                        
                        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:filepath]];
                        
                        [data writeToFile:[[Common getImagePath] stringByAppendingFormat:@"/%@", strPath] atomically:YES];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:strPath forKey:@"callBoard"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    });
                }
                else {
                    [[NSUserDefaults standardUserDefaults] setObject:strPath forKey:@"callBoard"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
            else {
                NSString *callBoardPath = [[NSUserDefaults standardUserDefaults] objectForKey:@"callBoard"];
                NSString *imagePath = [[Common getImagePath] stringByAppendingFormat:@"/%@", callBoardPath];
                [[NSFileManager defaultManager] removeItemAtPath:imagePath error:NULL];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"callBoard"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
    else {
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 785) {
        if (buttonIndex) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:9999] forKey:@"Run"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@?mt=8", VERSION_APPID]]];
        }
        else {
        }
    }
    else if(alertView.tag == 66){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:9999] forKey:@"Run"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@?mt=8", VERSION_APPID]]];
    }
    else if(alertView.tag == 10001)
    {
        NSLog(@"健康提醒处理");
        [self stopSound];
    }
    else {
        if (!buttonIndex) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:9999] forKey:@"Run"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@?mt=8", VERSION_APPID]]];
        }
        [self stopSound];
    }
}

- (void)createAudioplyerWithSoundName:(NSString *)soundName
{
    //    NSString *path = [[NSBundle mainBundle]pathForResource:soundName ofType:@"caf"];
    NSString *mainBundlPath = [[NSBundle mainBundle] bundlePath];
    NSString *path =[mainBundlPath stringByAppendingPathComponent:soundName];
    //    NSString *path = [bundlePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",soundName]];
    NSURL *url = [NSURL fileURLWithPath:path];
    if (!url)
    {
        return;
    }
    alarmPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    //    -1无线循环
    alarmPlayer.numberOfLoops = 5;
}


- (void)stopSound
{
    if (alarmPlayer)
    {
        [alarmPlayer stop];
        [alarmPlayer release];
        alarmPlayer = nil;
    }
}

#pragma mark - NetWork Status

- (void)networkDidSetup:(NSNotification *)notification {
    //    [_infoLabel setText:@"已连接"];
    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    //    [_infoLabel setText:@"未连接。。。"];
    NSLog(@"未连接。。。");
}

- (void)networkDidRegister:(NSNotification *)notification {
    //    [_infoLabel setText:@"已注册"];
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    //    [_infoLabel setText:@"已登录"];
    NSLog(@"已登录");
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reciveMesg" object:userInfo];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    //    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}


-(void)handleTodayButtonClickWithString:(NSString *)todayButtonTitle
{
    [[NSUserDefaults standardUserDefaults] setObject:todayButtonTitle forKey:@"kangxun_goToView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *view = [[touches anyObject] view];
    if (view.tag == 451) {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"ADVInfo"];
        if ([[dic objectForKey:@"islink"] intValue]) {
            AdvView *adv = [[AdvView alloc] init];
            [self.window addSubview:adv];
            [adv release];
        }
    }
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:nil];
}


@end
