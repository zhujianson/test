//
//  DefauleViewController.m
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-7-26.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "DefauleViewController.h"
#import "Common.h"
#import "Global.h"
#import "Global_Url.h"
#import "DiaryModelView.h"
#import "HMHomeViewController.h"
#import "AppDelegate.h"
#import "DBOperate.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "ShowConsultViewController.h"
#import "LoginViewController.h"
#import "NotificationViews.h"
#import "PerfectInformation.h"
#import "Mealtime.h"
#import "PersonalCenterViewController.h"
#import "MsgDBOperate.h"
#import "ClassViewController.h"
#import "ReportViewController.h"
#import "DoctorViewController.h"
#import "FastLoginViewController.h"

@interface DefauleViewController () <UINavigationControllerDelegate>
{
//    FloatView * floatView;

	long m_lastNewShowVC;
    long longTime;
    
    NSMutableDictionary *m_lastMsgDic;
}

@end

@implementation DefauleViewController
@synthesize customBarView ,m_selectedViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        g_tabbarHeight = 49;
		m_prevViewControllersnum = -1;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveMesg:) name:@"reciveMesg" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickOpenURL) name:@"open_Url" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTabbarTip) name:@"setTabbarTip" object:nil];
    }
    return self;
}

//将视图控制器的实例添加到标签栏中
- (void)creatViewControolers
{
    HMHomeViewController *homeVC = [[HMHomeViewController alloc] init];
    CommonNavViewController *nav1 = [[CommonNavViewController alloc] initWithRootViewController:homeVC];
    [homeVC release];
    nav1.m_DefalutViewCon = self;
    nav1.view.backgroundColor = [UIColor redColor];
    nav1.delegate = self;
    m_selectedViewController = nav1;
	
    AppDelegate *myAppDelegate = [Common getAppDelegate];
    myAppDelegate.navigationVC = (CommonNavViewController*)m_selectedViewController;
    
    //微课堂
    ClassViewController *diart = [[ClassViewController alloc] init];
    diart.log_pageID = 3;
    CommonNavViewController *nav2 = [[CommonNavViewController alloc] initWithRootViewController:diart];
    [diart release];
    nav2.m_DefalutViewCon = self;
    nav2.delegate = self;
    
    //健康小屋检查项目
    ReportViewController *com = [[ReportViewController alloc] init];
    CommonNavViewController *nav3 = [[CommonNavViewController alloc] initWithRootViewController:com];
    [com release];
    nav3.m_DefalutViewCon = self;
    nav3.delegate = self;
    
    //钱包
    PersonalCenterViewController *Personal = [[PersonalCenterViewController alloc] init];
    CommonNavViewController *nav5 = [[CommonNavViewController alloc] initWithRootViewController:Personal];
    [Personal release];
    nav5.m_DefalutViewCon = self;
    nav5.delegate = self;
    
//    if (!IOS_7) {
//        nav1.view.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight + 44);
//        nav2.view.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight + 44);
//        nav3.view.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight + 44);
//        nav4.view.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight + 44);
//        nav5.view.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight + 44);
//    }
    
    m_viewArray = [[NSArray alloc] initWithObjects:nav1, nav2, nav3, nav5, nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self creatHomeView];
//    [self clickOpenURL];
    //获取个人信息
    NSMutableDictionary* dic1 = [NSMutableDictionary dictionary];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GETMYINFO_API_URL values:dic1 requestKey:GETMYINFO_API_URL delegate:self controller:self actiViewFlag:0 title:NSLocalizedString(@"登录中...", nil)];
//    float value = [@"5.76" floatValue];
//    NSString *str = [NSString stringWithFormat:@"%0.1f", value];
//
//    if (value > [str floatValue]) {
//        NSLog(@"123");
//    }
    
//    NSString *str = [NSString stringWithFormat:@"%.0f", 4.6];
//    NSLog(@"%.1f", 4.1);
    // Do any additional setup after loading the view.
}

- (void)getMyDinnerTime
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GET_TIME_CONF values:dic requestKey:GET_TIME_CONF delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"加载中...", nil)];
}

- (void)tipComment
{
    //ios8 以上出现键盘消失又出来的问题,sdk变化引起
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BOOL is = [[[NSUserDefaults standardUserDefaults] objectForKey:@"istip"] boolValue];
        if (!is) {
            NSString *titlt = [NSString stringWithFormat:@"康迅360-V%@版本上线啦! 给个好评, 我们会继续加油的!", BundleVersion];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:titlt message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"残忍拒绝", @"大力支持", @"下次再说", nil];
            av.tag = 908;
            [av show];
            [av release];
        }
    });
}

- (void)creatHomeView
{
	[self creatViewControolers];
    //获取未读消息
    [self getMsg];

    m_selectViewIndex = 0;
    m_selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - g_tabbarHeight)];
    m_selectedView = m_selectedViewController.view;
    [self.view addSubview:m_selectedView];
    
    m_selectedView.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR];
    [APP_DELEGATE2 setUserID:g_nowUserInfo.userid];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTabbarShowHiddle:) name:@"setTabbarShowHiddle" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setShowView:) name:@"setShowView" object:nil];
    
    [self creatCusetumBar];
//    [self updateDB];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)updateDB
{
	//本地标示®
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *build = [userDefaults objectForKey:@"DBversionNum"];
	
	//plist-标示
	NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
	NSString *newKangxunDBVersion = [infoDic objectForKey:@"DBversionNum"];
	
	if (!build) {
		build = newKangxunDBVersion;
        [userDefaults setObject:newKangxunDBVersion forKey:@"DBversionNum"];
	}
	
	
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    NSString *build = [[NSUserDefaults standardUserDefaults] objectForKey:@"versionNum"];
//    build = !build ? @"0" : build;
    [dic setObject:build forKey:@"DBversionNum"];
    NSLog(@"versionNum==%@",build);
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:UPDATE_DATA_DB values:dic requestKey:UPDATE_DATA_DB delegate:self controller:self actiViewFlag:0 title:0];
}

//获取未读消息
- (void)getMsg
{
    NSString *time = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@boxLastRowTime%d", g_nowUserInfo.userid, 1]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:time?time:@"-1" forKey:@"time"];
    
    [dic setObject:[DiaryModelView getTimeWithKey:@"kLastPostTime"] forKey:@"postTime"];
    [dic setObject:[DiaryModelView getTimeWithKey:@"kLastTime"]  forKey:@"replyTime"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GET_MSG_NOT_READ_COUNT values:dic requestKey:GET_MSG_NOT_READ_COUNT delegate:self controller:self actiViewFlag:0 title:NSLocalizedString(@"加载中...", nil)];
    
    [dic removeAllObjects];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GET_MONEY_INDEX values:dic requestKey:GET_MONEY_INDEX delegate:self controller:self actiViewFlag:0 title:NSLocalizedString(@"加载中...", nil)];
}

- (void)creatCusetumBar
{
    //获取七牛token
    [self getQiniuToken];
    
    // 创建一个自定义的imgeView ,作为底图
    customBarView = [[UIImageView alloc] init];
    customBarView.frame = CGRectMake(0,self.view.frame.size.height-49, kDeviceWidth, 49);
    customBarView.backgroundColor = [CommonImage colorWithHexString:@"ffffff" alpha:0.9];
    customBarView.userInteractionEnabled = YES;
    customBarView.tag = 999;
    [self.view addSubview:customBarView];
    
//    UILabel *lineLabel =  [Common createLineLabelWithHeight:0.5];
//    lineLabel.backgroundColor = [CommonImage colorWithHexString:@"cccccc"];
//    [customBarView addSubview:lineLabel];
    
    NSArray *arrayTabBarImage = [NSArray arrayWithObjects:
                                 [NSArray arrayWithObjects:@"common.bundle/tab/tab_home_nor.png", @"common.bundle/tab/tab_home_pre.png", @"首页", nil],
                                 [NSArray arrayWithObjects:@"common.bundle/tab/tab_class_nor.png", @"common.bundle/tab/tab_class_pre.png", @"记录", nil],
								 [NSArray arrayWithObjects:@"common.bundle/tab/tab_pub_nor.png", @"common.bundle/tab/tab_pub_pre.png", @"糖圈", nil],
                                 [NSArray arrayWithObjects:@"common.bundle/tab/tab_me_nor.png", @"common.bundle/tab/tab_me_pre.png", @"我", nil],
                                 nil];
    int widht = kDeviceWidth/arrayTabBarImage.count;
    UIButton *btn;
//    UILabel *labTip;
    NSArray *array;
    CGRect rect;
    NSString *title;
    for (int i = 0; i < [arrayTabBarImage count]; i++)
    {
        array = [arrayTabBarImage objectAtIndex:i];
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(widht*i, 1, widht, 48);
        title = [array objectAtIndex:2];
        [btn setImage:[UIImage imageNamed:[array objectAtIndex:0]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[array objectAtIndex:1]] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:[array objectAtIndex:1]] forState:UIControlStateSelected];

        btn.tag = i+100;
        if (i==0)
        {
            btn.selected = YES;
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
//        [btn addTarget:self action:@selector(setButSel:) forControlEvents:UIControlEventTouchDragExit];
//        [btn addTarget:self action:@selector(setButSel:) forControlEvents:UIControlEventTouchUpInside];
        [customBarView addSubview:btn];
        
        if (i == arrayTabBarImage.count-1 || i == arrayTabBarImage.count-2) {
            UIImage *redHeartImageContent = [UIImage imageNamed:@"common.bundle/topic/conversation_icon_redpoint.png"];
            UIImage *btnImage = [UIImage imageNamed:[array objectAtIndex:0]];
//            btnImage.size.height/2+redHeartImageContent.size.height/2
            rect = CGRectMake(btn.width/2+btnImage.size.width/2-redHeartImageContent.size.width/2+1, btn.height/2-btnImage.size.height/2-2, redHeartImageContent.size.width, redHeartImageContent.size.height);
            UIImageView *redHeartImage = [[UIImageView alloc]initWithFrame:rect];
            redHeartImage.tag = i+200;
            redHeartImage.image = redHeartImageContent;
//            redHeartImage.contentMode = UIViewContentModeCenter;
            redHeartImage.hidden = YES;
            [btn addSubview:redHeartImage];
            [redHeartImage release];
        }
    }
    
//    [APP_DELEGATE2 setUserID:g_nowUserInfo.userid setMainID:g_nowUserInfo.userid];
}


//start
- (void)reciveMesg:(NSNotification*)aNotification
{
    NSDictionary *dicc = [aNotification.object objectForKey:@"extras"];
    if (m_lastMsgDic) {
        if (([dicc[@"createTime"] longLongValue] - [m_lastMsgDic[@"createTime"] longLongValue]) >= 3000) {
            if ([dicc[@"content"] isEqualToString:m_lastMsgDic[@"content"]]) {
                return;
            }
        }
        m_lastMsgDic = nil;
    }
    
    m_lastMsgDic = [[NSMutableDictionary alloc] initWithDictionary:dicc];
    
    if (!g_nowUserInfo) {
        return;
    }
    
    [m_lastMsgDic setObject:@"1" forKey:@"forSelf"];
    NSString *fromId = [NSString stringWithFormat:@"%@", [m_lastMsgDic objectForKey:@"fromId"]];
    [m_lastMsgDic setObject:fromId forKey:@"friendId"];
    [m_lastMsgDic setObject:fromId forKey:@"toId"];
    [m_lastMsgDic setObject:@"0" forKey:@"isSendOK"];
    [m_lastMsgDic setObject:@"0" forKey:@"isInsertDB"];
    
    id vc = ((CommonNavViewController*)m_selectedViewController).nowViewController;
    int is = 0;
    ShowConsultViewController *m_showView = nil;
    
    NSString *ff;
    if ([vc isKindOfClass:[ShowConsultViewController class]]) {
        m_showView = vc;
        ff = [NSString stringWithFormat:@"%@", m_showView.friendModel.accountId];
        if ([ff isEqualToString:fromId]) {
            is = 1;
        }
    }
    else if ([vc isKindOfClass:[DoctorViewController class]]) {
        is = 2;
    }
    
    if (is == 1) {
        [m_showView addMessage:m_lastMsgDic isLishi:NO];
    } else {
        
        if (is == 2) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFriendList" object:nil];
        }

        //未读红点
        g_nowUserInfo.doctorMsgCount += 1;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"setTabbarTip" object:nil];
        
        [vc refleshTip];
        
        SystemSoundID soundID = 0;
        NSString *mainBundlPath = [[NSBundle mainBundle] bundlePath];
        NSString *filePath =[mainBundlPath stringByAppendingPathComponent:@"common.bundle/mp3/newdatatoast.wav"];
        
        NSURL* fileURL =  [NSURL fileURLWithPath:filePath];
        
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
        
        m_lastMsgDic = nil;
    }
    
//    [self refreshNoReadRedImage];
}

- (void)setTabbarTip
{
    UILabel *labTip = (UILabel*)[customBarView viewWithTag:3+200];
    int count = [[DBOperate shareInstance] getNoReadCount];
    labTip.hidden = !MAX(count + g_nowUserInfo.broadcastNotReadNum, 0);
    
    
//    UILabel *commuitylabTip = (UILabel*)[customBarView viewWithTag:2+200];
//    commuitylabTip.hidden = !MAX(g_nowUserInfo.friendMsgCount + g_nowUserInfo.myPostNotRead + g_nowUserInfo.myThreadNotRead, 0);
}

- (void)btnClick:(UIButton*)but
{
    if (but.tag == 102 && !g_nowUserInfo.mobilePhone.length) {
        FastLoginViewController *fast = [[FastLoginViewController alloc] init];
        fast.title = @"绑定手机号";
        CommonNavViewController *nav = [[CommonNavViewController alloc] initWithRootViewController:fast];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    but.selected = YES;
    int selectindex = (int)but.tag;
    [self gotoSelectViewControllerWithSelectIndex:selectindex];
}

- (void)gotoSelectViewControllerWithSelectIndex:(int)selectIndex
{
//    if (m_lock) {
//        return;
//    }
//    m_lock = YES;
    
    if (m_selectViewIndex == selectIndex-100) {
        return;
    }
    //获取未读消息
    [self getMsg];

    UIButton *lastSelBut = (UIButton*)[customBarView viewWithTag:m_selectViewIndex+100];
    lastSelBut.selected = NO;
    [((CommonNavViewController*)m_selectedViewController).nowViewController viewWillDisappear:YES];
    [m_selectedView removeFromSuperview];
    
    m_selectedViewController = [m_viewArray objectAtIndex:selectIndex-100];
    NSLog(@"%@", ((CommonNavViewController*)m_selectedViewController).nowViewController.view);
    m_selectedView = m_selectedViewController.view;
    [((CommonNavViewController*)m_selectedViewController).nowViewController viewWillAppear:YES];
    
    AppDelegate *myAppDelegate = [Common getAppDelegate];
    myAppDelegate.navigationVC = (CommonNavViewController*)m_selectedViewController;
//    [[UIApplication sharedApplication] delegate];
    
    [self.view addSubview:m_selectedView];
    [self.view bringSubviewToFront:customBarView];
    m_selectViewIndex = (int)selectIndex-100;
//    [self setLoadingCore];
    //获取七牛token
//    [self getQiniuToken];

}

- (void)setButSel:(UIButton*)but
{
    but.selected = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setTabbarTip];
}

#pragma - UINavigationControllerDelegate

- (int)setNav:(UINavigationController *)navigationController
{
    //	NSLog(@"as---------------------------------------start");
    if (m_prevViewControllersnum == -1) {
        m_prevViewControllersnum = (int)[[navigationController viewControllers] count];
        return -1;
    }
    
    BOOL pushed;
    
    if (m_prevViewControllersnum <= (int)[[navigationController viewControllers] count])
    {
        pushed = YES;
        m_lock = NO;
    }
    else
    {
        pushed = NO;
    }
    m_prevViewControllersnum = (int)[[navigationController viewControllers] count];
    
    return pushed;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //	NSLog(@"as---------------------------------------start");
    int pushed = [self setNav:navigationController];
    if (pushed == -1) {
        return;
    }
    CommonViewController *vc = [navigationController.viewControllers objectAtIndex:0];
    if (pushed && m_prevViewControllersnum == 2 ) {
        if (!customBarView.hidden) {
            [self createImage:vc];
            customBarView.hidden = YES;
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //	NSLog(@"as---------------------------------------start");
    int pushed = [self setNav:navigationController];
    if (pushed == -1) {
        return;
    }
    UIViewController *vc = [navigationController.viewControllers objectAtIndex:0];

    if (pushed && m_prevViewControllersnum == 1){
        [self removeImage:vc.view];
//        [self performSelector:@selector(removeImage:) withObject:vc.view afterDelay:0.4];
        [self viewWillAppear:NO];
    }
}

- (void)removeImage:(UIView*)vc
{
    UIView *imageV = [vc viewWithTag:900];
    if (imageV) {
        customBarView.hidden = NO;
        [imageV removeFromSuperview];
    }
}

- (void)createImage:(CommonViewController*)view
{
    float height = view.m_isHideNavBar;
    UIImage *image = [CommonImage imageFromView:APP_DELEGATE atFrame:CGRectMake(0, kDeviceHeight+64-g_tabbarHeight, kDeviceWidth, g_tabbarHeight)];
    UIImageView *imagV = [[UIImageView alloc] initWithFrame:CGRectMake(0, kDeviceHeight - g_tabbarHeight + height, kDeviceWidth, g_tabbarHeight)];
    imagV.tag = 900;
    imagV.image = image;
    [view.view addSubview:imagV];
    [imagV release];
}

//start
//- (void)reciveMesg:(NSNotification*)aNotification
//{
//    NSDictionary *dicc = [aNotification.object objectForKey:@"extras"];
//    if (m_lastMsgDic) {
//        if (([dicc[@"createTime"] longLongValue] - [m_lastMsgDic[@"createTime"] longLongValue]) >= 3000) {
//            if ([dicc[@"content"] isEqualToString:m_lastMsgDic[@"content"]]) {
//                return;
//            }
//        }
//        [m_lastMsgDic release];
//        m_lastMsgDic = nil;
//    }
//    
//    m_lastMsgDic = [[[NSMutableDictionary alloc] initWithDictionary:dicc] retain];
//	
//    if (!g_nowUserInfo) {
//        return;
//    }
//    
//    [m_lastMsgDic setObject:@"1" forKey:@"forSelf"];
//    NSString *fromId = [NSString stringWithFormat:@"%@", [m_lastMsgDic objectForKey:@"fromId"]];
//    [m_lastMsgDic setObject:fromId forKey:@"friendId"];
//    [m_lastMsgDic setObject:fromId forKey:@"toId"];
//    [m_lastMsgDic setObject:@"0" forKey:@"isSendOK"];
//    [m_lastMsgDic setObject:@"1" forKey:@"isInsertDB"];
//    
//
//    id vc = ((CommonNavViewController*)m_selectedViewController).nowViewController;
//    int is = 0;
//    ShowConsultViewController *m_showView = nil;
//    
//    NSString *ff;
//    if ([vc isKindOfClass:[ShowConsultViewController class]]) {
//        m_showView = vc;
//        ff = [NSString stringWithFormat:@"%@", [m_showView.m_dicInfo objectForKey:@"friendId"]];
//        if ([ff isEqualToString:fromId]) {
//            is = 1;
//        }
//    }
////    else if ([vc isKindOfClass:[FriendListTableView class]]) {
////        is = 2;
////    }
//	
//	[[DBOperate shareInstance] insertChatRecordToDBWithData:m_lastMsgDic];
//
//    if (is == 1) {
//        [m_showView addMessage:m_lastMsgDic isLishi:NO];
//    } else {
//        
//        if (is == 2) {
//            NSString *onlyId = [NSString stringWithFormat:@"%@_%@", g_nowUserInfo.userid, fromId];
//            
//            NSString *sql = [NSString stringWithFormat:@"UPDATE friendList SET createTime = '%@', content = '%@', contentType = '%@' WHERE onlyId = '%@'", m_lastMsgDic[@"createTime"], m_lastMsgDic[@"content"], m_lastMsgDic[@"contentType"], onlyId];
//            
//            [[MsgDBOperate shareInstance] updateFriendInfoRow:sql];
//        }
//        
//        //未读红点
//        if ([m_lastMsgDic[@"accountType"] intValue] == 2) { //1 患者 2 医师
//            g_nowUserInfo.doctorMsgCount += 1;
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refleshTip" object:nil];
//        }
//        else {
//            g_nowUserInfo.friendMsgCount += 1;
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refleshFriendListTip" object:nil];
//        }
//        
//        m_lastNewShowVC = 1;
//        NSString *msg = nil;
//        switch ([[m_lastMsgDic objectForKey:@"contentType"] intValue]) {
//            case 0:
//                msg = [m_lastMsgDic objectForKey:@"content"];
//                break;
//            case 1:
//                msg = @"您收到一张图片";
//                break;
//            case 2:
//                msg = @"您收到一条语音消息";
//                break;
//            case 3:
//                msg = @"您收到一个图片表情";
//                break;
//            default:
//                msg = @"您收到一条新的消息";
//                break;
//        }
//        SystemSoundID soundID = 0;
//        NSString *mainBundlPath = [[NSBundle mainBundle] bundlePath];
//        NSString *filePath =[mainBundlPath stringByAppendingPathComponent:@"common.bundle/mp3/newdatatoast.wav"];
//        
//        NSURL* fileURL =  [NSURL fileURLWithPath:filePath];
//        
//        if (fileURL != nil) {
//            SystemSoundID theSoundID;
//            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &theSoundID);
//            if (error == kAudioServicesNoError) {
//                soundID = theSoundID;
//            } else {
//                NSLog(@"Failed to create sound ");
//            }
//        }
//        AudioServicesPlaySystemSound(soundID);
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//        
//        [m_lastMsgDic release];
//    }
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	m_lastNewShowVC = 0;
	if (alertView.tag == 120) {
		if (buttonIndex) {
//			[[NSNotificationCenter defaultCenter] postNotificationName:@"setShowView" object:[NSNumber numberWithInt:0]];
			
			ShowConsultViewController *show = [[ShowConsultViewController alloc] init];
			[((CommonNavViewController*)m_selectedViewController).nowViewController.navigationController pushViewController:show animated:YES];
			[show release];
		}
	}
    else if (alertView.tag == 908) {
        
        switch (buttonIndex) {
            case 0:
                [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"istip"];
                break;
            case 1:
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@?mt=8", VERSION_APPID]]];
                [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"istip"];
                break;
            case 2:
                
                break;
                
            default:
                break;
        }
    }
}

#pragma mark 点击对应
- (void)clickOpenURL
{
//    [self gotoSelectViewControllerWithSelectIndex:100];
    if (!g_nowUserInfo.userid.length)
    {
        return;
    }
    [self performSelector:@selector(gotoSelectViewController) withObject:nil afterDelay:0.4];
}

#pragma mark 跳转
- (void)gotoSelectViewController
{
    NSString *todayButtonTitle = [[NSUserDefaults standardUserDefaults] objectForKey:@"kangxun_goToView"];
    if ([todayButtonTitle isEqualToString:kTodayWidget_ONE] || [todayButtonTitle isEqualToString:kTodayWidget_TWO]  || [todayButtonTitle isEqualToString:kTodayWidget_THREE]  ||[todayButtonTitle isEqualToString:kTodayWidget_FOUR] )
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kangxun_goToView"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIViewController *newViewController = [[NSClassFromString(todayButtonTitle) alloc] init];
        if ([todayButtonTitle isEqualToString:kTodayWidget_ONE])//血糖
        {
//            BoolSugarVC *sugar = (BoolSugarVC *)newViewController;
//            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//            NSDictionary *family = [FamilyListView getSelectFamilyInfoByUserid];
//            [dic setObject:family[@"user_no"] forKey:@"accountId"];
//            [dic setObject:family[@"nickName"] forKey:@"nickName"];
//            [dic setObject:[NSNumber numberWithLong:[CommonDate getLongTime]] forKey:@"recordDate"];
//            [[Mealtime alloc] initWithBlock:^(id timeBucket){
//                [dic setObject:timeBucket forKey:@"timeBucket"];
//                [sugar setM_superDic:dic];
//                 [((CommonNavViewController*)m_selectedViewController) pushViewController:sugar animated:YES];
//                [sugar release];
//            }  withType:nowMealtimeConf withView:self];
//            return;
        }
        else if ([todayButtonTitle isEqualToString:kTodayWidget_TWO])//运动
        {
//            AppDelegate *myDelegate = [Common getAppDelegate];
//            if(newViewController){
//                [newViewController release];
//                newViewController = nil;
//            }
//            newViewController = [[SteperHomeViewController alloc] init];
        }
        UINavigationController *myNavCOntroller = ((CommonNavViewController*)m_selectedViewController).nowViewController.navigationController;
        if ([myNavCOntroller.topViewController isKindOfClass:[newViewController class]])
        {
            return;
        }
        
        [((CommonNavViewController*)m_selectedViewController) pushViewController:newViewController animated:YES];
        [newViewController release];
    }
}

//end
- (void)setShowView:(NSNotification*)aNotification
{
    int is = [aNotification.object boolValue];
    customBarView.transform = CGAffineTransformIdentity;
    customBarView.hidden = NO;
    UIButton *but = (UIButton*)[self.view viewWithTag:100+is];
    [self btnClick:but];
}

- (void)setTabbarShowHiddle:(NSNotification*)aNotification
{
    BOOL is = [aNotification.object boolValue];
    customBarView.hidden = NO;
    if (!is) {
        customBarView.transform = CGAffineTransformMakeTranslation(0, customBarView.height);
    }
    [UIView animateWithDuration:0.2 animations:^{
        if (is) {
            customBarView.transform = CGAffineTransformMakeTranslation(0, customBarView.height);
        } else {
            customBarView.transform = CGAffineTransformMakeTranslation(0, 0);
        }
    } completion:^(BOOL finished) {
//		if (is) {
            customBarView.hidden = is;
//        }
        customBarView.transform = CGAffineTransformIdentity;
    }];
}

- (void)didFinishFail:(ASIHTTPRequest*)loader
{
	if ([loader.username isEqualToString:LOGIN_API_URL])
    {
        [self removeAdvView];
		[self qweqwe];
		[Common TipDialog:@"网络异常"];
	}
}

- (void)didFinishSuccess:(ASIHTTPRequest*)loader
{
    NSString* responseString = [loader responseString];
    NSDictionary* dict = [responseString KXjSONValueObject];
    NSDictionary * dic = dict[@"head"];

	if([loader.username isEqualToString:UPDATE_DATA_DB])
	{
        NSArray *rs = [dic objectForKey:@"rs"];
        NSDictionary *dicItem = [rs objectAtIndex:rs.count-1];
        if ([dicItem objectForKey:@"versionNum"]) {
            [NSThread detachNewThreadSelector:@selector(updateDB2:) toTarget:self withObject:rs];
        }
	}
//	else if ([loader.username isEqualToString:LOGIN_API_URL])
//	{
//        g_nowUserInfo = [Common initWithUserInfoDict:[dict objectForKey:@"body"]];
//        //获取个人信息
////        [self removeAdvView];
//
//        if ([dict[@"body"][@"need_info"] integerValue] == 1) {
//            PerfectInformation* retrieve = [[PerfectInformation alloc] init];
//            retrieve.m_token = [dict objectForKey:@"body"][@"token"];
//            CommonNavViewController *view1 = [[CommonNavViewController alloc] initWithRootViewController:retrieve];
//            APP_DELEGATE.rootViewController = view1;
//            [view1 release];
//            [retrieve release];
//            return;
//        }
//        //获取个人信息
//        NSMutableDictionary* dic1 = [NSMutableDictionary dictionary];
//        [[CommonHttpRequest defaultInstance] sendNewPostRequest:GETMYINFO_API_URL values:dic1 requestKey:GETMYINFO_API_URL delegate:self controller:self actiViewFlag:0 title:NSLocalizedString(@"登录中...", nil)];
//    }
    else if ([loader.username isEqualToString:GET_QINIU_TOKEN]) {
        g_nowUserInfo.qiniuToken = dict[@"body"][@"token"];
        g_longTime = [CommonDate getLongTime];
    }
    else if ([loader.username isEqualToString:GETMYINFO_API_URL])
    {
        
        [g_nowUserInfo setMyBasicInformation:[dic objectForKey:@"body"][@"user_info"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getWallet" object:nil];
        
//        [g_nowUserInfo setMyBasicInformation:[dict objectForKey:@"body"][@"user_info"]];
//        [NotificationViews handleRemoteNotificationWithUserInfo:nil];
//        [self creatHomeView];
        [self clickOpenURL];
        [APP_DELEGATE2 setUserID:g_nowUserInfo.userid];
    }
    else if ([loader.username isEqualToString:GET_MSG_NOT_READ_COUNT])
    {
        NSDictionary * body = dict[@"body"];
        g_nowUserInfo.broadcastNotReadNum = [[body objectForKey:@"unread_msg"] intValue]; //信箱未读数
        g_nowUserInfo.myMessageNoReadNum = [[body objectForKey:@"unread_comment"] intValue]; //评论未读数
        g_nowUserInfo.totalunreadMsgCount = [[body objectForKey:@"unread_friend"] intValue]; //总未读数
        g_nowUserInfo.doctorMsgCount = [[body objectForKey:@"unread_doctor"] intValue]; //医生未读数
        g_nowUserInfo.friendMsgCount = [[body objectForKey:@"friendMsgCount"] intValue]; //糖友未读数
        g_nowUserInfo.myPostNotRead = [[body objectForKey:@"my_post_not_read"] intValue]; //我的帖子未读总数量
        g_nowUserInfo.myThreadNotRead = [[body objectForKey:@"my_thread_not_read"] intValue]; //我的跟帖未读总数量
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"personReadNum" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refleshTip" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setTabbarTip" object:nil];
        g_nowUserInfo.integral = [body[@"points_available"] intValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setChangeText" object:nil];
    }else if ([loader.username isEqualToString:GET_MONEY_INDEX])
    {
        NSDictionary * body = dict[@"body"];
        g_nowUserInfo.money = [NSString stringWithFormat:@"%.2f",[body[@"cash"][@"available"] floatValue]/100];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setChangeText" object:nil];
    }
}

- (void)removeAdvView
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
	AppDelegate* myDelegate = [Common getAppDelegate];
	UIImageView *imageV = (UIImageView*)[myDelegate.window viewWithTag:99];
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            dispatch_async( dispatch_get_main_queue(), ^(void){
				[UIView animateWithDuration:0.2 animations:^{
					imageV.alpha = 0;
                } completion:^(BOOL finished) {
                    [imageV removeFromSuperview];
				}];
			});
		});
}

/**
 *  返回登录界面
 */
- (void)qweqwe
{
    LoginViewController* LoginViewCon = [[LoginViewController alloc] init];
    UIImage* loginViewImage = [CommonImage imageWithView:LoginViewCon.view];
    UIImageView* loginView = [[UIImageView alloc] initWithImage:loginViewImage];
    loginView.frame = CGRectMake(0, kDeviceHeight + 64, kDeviceWidth, kDeviceHeight + 64);
    [self.navigationController.view addSubview:loginView];

    CGRect rect = loginView.frame;
    rect.origin.y = 0;
    loginView.frame = rect;
    CommonNavViewController *view1 = [[CommonNavViewController alloc] initWithRootViewController:LoginViewCon];
    [LoginViewCon release];
    APP_DELEGATE.rootViewController = view1;
    [view1 release];
     [loginView release];
}

- (void)updateDB2:(NSArray*)array
{
	@try {
		for (NSDictionary *dic in array) {
			[[DBOperate shareInstance] updateDataForServer:[dic objectForKey:@"changeSql"]];
		}
		[[DBOperate shareInstance] closeDB];
		
		NSDictionary *dicItem = [array objectAtIndex:array.count-1];
		[[NSUserDefaults standardUserDefaults] setObject:[dicItem objectForKey:@"versionNum"] forKey:@"DBversionNum"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	@catch (NSException *exception) {
	}
	@finally {
	}
}

- (void)getQiniuToken
{
    long time = [CommonDate getLongTime];
    if (time - g_longTime > 11 * 60 * 60) {
        [[CommonHttpRequest defaultInstance] sendNewPostRequest:GET_QINIU_TOKEN values:[NSDictionary dictionary] requestKey:GET_QINIU_TOKEN delegate:self controller:self actiViewFlag:0 title:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:@"reciveMesg" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"FloatViewClickNotification" object:nil];

    for (id nv in m_viewArray) {
        [nv release];
    }
    [customBarView release];
    
    if (m_lastMsgDic) {
        [m_lastMsgDic release];
        m_lastMsgDic = nil;
    }
    
    [super dealloc];
}

@end
