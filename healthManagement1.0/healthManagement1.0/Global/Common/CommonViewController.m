//
//  CommonViewController.m
//  jiuhaohealth4.1
//
//  Created by 徐国洪 on 15-9-1.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "CommonViewController.h"
#import "MobClick.h"
#import "AppDelegate.h"
#import "KXShareManager.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface CommonViewController ()

@end


@implementation CommonViewController
@synthesize autoSize, autoV, height, statusBarHeight, width, customTitle,m_isPopAndPushing,m_superDic;
@synthesize m_nowPage;

/**
 *  显示加载中
 */
- (void)showLoadingActiview
{
    if(!loadView){
        loadView = [[LoadingAnimation alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.view.frame.size.height)];
        [self.view addSubview:loadView];
        [loadView release];
    }
}

/**
 *  移除加载中view
 */
- (void)stopLoadingActiView
{
    if ( loadView && [loadView isKindOfClass:[LoadingAnimation class]]) {
        [loadView stopAnimating];
        //    load.hidden = YES;
        [loadView removeFromSuperview];
        loadView = nil;
    }
    
}

- (BOOL)closeNowView
{
    NSString *add = [NSString stringWithFormat:@"%x", (unsigned int)self];
    NSMutableArray* array = [g_winDic objectForKey:add];
    for (ASIHTTPRequest* asi in array) {
        if (!asi.winCloseIsNoCancle) {
            [asi cancel];
        }
    }
    [g_winDic removeObjectForKey:add];
    NSLog(@"closeNowView");
    
    m_isClose = YES;
    return YES;
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [g_winDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
//        UIButton* but = [UIButton buttonWithType:UIButtonTypeCustom];
//        but.frame = CGRectMake(0, 0, 44, 44);
//        [but setTitle:@"返回" forState:UIControlStateNormal];
//        [but setTitleColor:[CommonImage colorWithHexString:The_ThemeColor] forState:UIControlStateNormal];
//        [but setImage:[UIImage imageNamed:@"common.bundle/nav/back_nor.png"] forState:UIControlStateNormal];
        //
        UIBarButtonItem* backBar = [[UIBarButtonItem alloc] init];
        backBar.title = @"返回";
//        backBar.tintColor = [CommonImage colorWithHexString:The_ThemeColor];
        self.navigationItem.backBarButtonItem = backBar;
        [self.navigationItem.backBarButtonItem setTintColor:[CommonImage colorWithHexString:The_ThemeColor]];
        [backBar release];
    }
    return self;
}

- (void)butEventBack
{
    NSLog(@"123123123123123123123");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_isInNav = [self.navigationController.viewControllers containsObject:self];
    self.navigationController.navigationBar.translucent = NO;
    m_nowPage = 1;
    hasMoreFlag = YES;
    
    self.view.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR2];
    // Do any additional setup after loading the view.
    height = self.view.frame.size.height;
    width = self.view.frame.size.width;
    if (iOS_Version >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = YES;
        
        self.autoSize = height / 416;
        self.autoV = height - 480;
        statusBarHeight = 20;
    } else {
        self.autoSize = height / 416;
        self.autoV = height - 460;
        statusBarHeight = 0;
    }
   
    [self sendStatisticsLog];
    self.fd_prefersNavigationBarHidden = self.m_isHideNavBar;
//     self.fd_interactivePopDisabled = YES;
}

- (void)showNavigationBarLine
{
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        
        NSArray *list = self.navigationController.navigationBar.subviews;
//        NSArray *list1 = self.navigationController.navigationBar.
        
        for (id obj in list) {
            
            if ([obj isKindOfClass:[UIImageView class]]) {
                
                UIImageView *imageView=(UIImageView *)obj;
                
                NSArray *list2=imageView.subviews;
                
                for (id obj2 in list2) {
                    
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        
                        UIImageView *imageView2=(UIImageView *)obj2;
//                        imageView2.hidden = YES;
//                        imageView2.backgroundColor = [CommonImage colorWithHexString:@"ff0000"];
//                        imageView2.height = 0.5;
                        imageView2.alpha = 0.5;
//                        imageView2.image = [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"ff0000"]];
                    }
                }
            }
        }
    }
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)hiddenNavigationBarLine
{
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        
        NSArray *list = self.navigationController.navigationBar.subviews;
        
        for (id obj in list) {
            
            if ([obj isKindOfClass:[UIImageView class]]) {
                
                UIImageView *imageView=(UIImageView *)obj;
                
                NSArray *list2=imageView.subviews;
                
                for (id obj2 in list2) {
                    
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        
                        UIImageView *imageView2=(UIImageView *)obj2;
                        
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
//    if (IOS_7) {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    }
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBar.hidden = self.m_isHideNavBar;
    [self showNavigationBarLine];
//    [self hiddenNavigationBarLine];
    [MobClick beginLogPageView:self.title];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //	[MobClick beginLogPageView:[NSString stringWithFormat:@"%d", self.log_pageID]];//开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //只有在二级页面生效
        //        if ([self.navigationController.viewControllers count] == 2) {
        //            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        ////            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        //        }
    }
    self.m_isPopAndPushing = NO;
    
//    UIView *image = [self.view viewWithTag:6546];
//    if (image) {
//        [image removeFromSuperview];
//    }
}

- (void)viewWillDisappear:(BOOL)animated {
//    self.navigationController.navigationBar.hidden = NO;
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
//    self.navigationController.navigationBar.hidden = NO;
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:self.title];
    
    //    if (m_isInNav) {
    //        if (![self.navigationController.viewControllers containsObject:self])
    //        {
    //            [g_winDic removeObjectForKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
    //        }
    //    }
    
    if (![self.navigationController.viewControllers containsObject:self])
    {
        if (loadView) {
            [self stopLoadingActiView];
        }
    }
    //代理置空，否则会闪退
    //    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    //        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    ////        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    //    }
    //	[MobClick endLogPageView:[NSString stringWithFormat:@"%d", self.log_pageID]];
    self.m_isPopAndPushing = NO;
}

- (void)sendStatisticsLog
{
    if (!g_nowUserInfo.userid || ![Common checkNetworkIsValid]) {
        return;
    }
}

- (void)setLog_pageID:(int)log_pageID
{
    [MobClick event:[NSString stringWithFormat:@"_%d", log_pageID]];
}

- (void)setLog_pageIDs:(NSString*)log_pageID
{
    [MobClick event:[NSString stringWithFormat:@"_%@", log_pageID] label:self.title];
}

- (void)removeAllSubClassFromNetDic
{
}

/**
 *  分享功能
 */
- (void)goToShare
{
    [[KXShareManager  sharedManager] noneUIShareAllButtonClickHandler:self.view Content:self.shareContentString ImagePath:self.shareImage AndTitle:self.shareTitle Url:self.shareURL haveCustomItem:self.shareCustomItem];
}

- (NSString*)getShareURLType:(NSString*)type andId:(NSString*)idString
{
    NSString* shareURL = [NSString stringWithFormat:@"%@%@.html", Share_Server_URL,idString];
    return shareURL;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    [super preferredStatusBarStyle];
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    [super prefersStatusBarHidden];
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"--- dealloc called");
    self.customTitle = nil;
    if (m_superDic)
    {
        [m_superDic release];
    }
    self.shareTitle = nil; //分享的title
    self.shareContentString = nil; //分享的内容
    self.shareImage = nil; //分享的图片
    self.shareURL = nil; //分享的URL
    
    [super dealloc];
}

@end
