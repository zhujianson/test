//
//  TopicDetailsViewController.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-31.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "WebViewController.h"
#import "CommentsInput.h"
#import "AppDelegate.h"
#import <MediaPlayer/MPMoviePlayerController.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AudioPlayer.h"
#import "KXMoviePlayer.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "AudioPlayer.h"
#import "ImagePicker.h"
#import "GetToken.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "KXPayManage.h"
#import "KXPayManageView.h"
#import "UIButton+EnlargeTouchArea.h"
#import "ShowConsultViewController.h"
#import "KXShareManager.h"
#import "ThinPersonalViewController.h"
#import "ThinViewController.h"
#import "VideoDetailViewController.h"

@interface WebViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate, AVAudioPlayerDelegate>
{
    
    KXMoviePlayer* m_moviePlayerView;
    AudioPlayer* m_audioPlayer;
    
    BOOL isHiddenStatusBar;//隐藏状态栏
    BOOL m_isPlay;
    
    //进度条
    NJKWebViewProgressView *m_progressView;
    NJKWebViewProgress *m_progressProxy;
    NSString *payNotiUrl;
    KXBasicBlock m_block;
    
    NSMutableDictionary *m_dic;
}
@property (nonatomic) CGRect defaultFrame;

@end
@implementation WebViewController
@synthesize m_webView;

#pragma mark - Life cycle
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    [self clearCook];
    NSLog(@"dealloc----WebViewController");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [m_moviePlayerView stopMoviePlayer];
    [m_moviePlayerView release];
    [m_webView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onPlayMusic" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onParuseMusic" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showZhifujieguo" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"shearOK" object:nil];
    
    //进度条
    m_progressProxy.webViewProxyDelegate = nil;
    m_progressProxy.progressDelegate = nil;
    [m_progressView removeFromSuperview];
    [m_progressView release];
    [m_progressProxy release];
    [payNotiUrl release];
    if (m_block)
    {
        [m_block release];
        m_block = nil;
    }
    if (m_dic) {
        [m_dic release];
        m_dic = nil;
    }
    [super dealloc];
}

-(void)setKXBlock:(KXBasicBlock)block
{
    if (m_block != block)
    {
        [m_block release];
        m_block = nil;
        m_block = [block copy];
    }
}

- (void)clearCook
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self createBack];

    [self createWebView];
    [self createJindu];
//    if (self.m_isHideNavBar) {
//        [self createNavigation];
        [self createLeft:self.m_isHideNavBar];
//    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPlayMusic) name:@"onPlayMusic" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onParuseMusic) name:@"onParuseMusic" object:nil];
}

//创建webView
- (void)createWebView
{
    m_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight + (self.m_isHideNavBar?(IOS_7?64:44):0))];
    m_webView.delegate = self;
    m_webView.backgroundColor = self.view.backgroundColor;
    m_webView.opaque = NO;
    
    [self.view addSubview:m_webView];
    UIButton * btn = (UIButton*)[self.view viewWithTag:33];
    [self.view bringSubviewToFront:btn];
    
    if (self.m_url) {
        [self showLoadingActiview];
        if (![self.m_url containsString:@"?"])
        {
            self.m_url = [self.m_url stringByAppendingString:@"?"];
        }
        else
        {
            self.m_url = [self.m_url stringByAppendingString:@"&"];
        }
        self.m_url = [self.m_url stringByAppendingFormat:@"token=%@",g_nowUserInfo.userToken];
        
        [m_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.m_url]]];
    }
}

//- (void)setM_url:(NSString *)url
//{
//    _m_url = url;
//    if (m_webView) {
//        [self showLoadingActiview];
//        if (![self.m_url containsString:@"?"])
//        {
//            self.m_url = [self.m_url stringByAppendingString:@"?"];
//        }
//        else
//        {
//            self.m_url = [self.m_url stringByAppendingString:@"&"];
//        }
//        self.m_url = [self.m_url stringByAppendingFormat:@"token=%@",g_nowUserInfo.userToken];
//        [m_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.m_url]]];
//    }
//}

//创建进度条
- (void)createJindu
{
    m_progressProxy = [[NJKWebViewProgress alloc] init];
    m_webView.delegate = m_progressProxy;
    m_progressProxy.webViewProxyDelegate = self;
    m_progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect barFrame = CGRectMake(0, 0, m_webView.width, progressBarHeight);
    m_progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    m_progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self.view addSubview:m_progressView];
}

//- (void)createAudio
//{
//    m_audioPlayer = [[AudioPlayer alloc] init];
//    m_audioPlayer.url = [NSURL URLWithString:@"http://kangxunmedia.qiniudn.com/%E5%B0%8F%E8%8B%B9%E6%9E%9C.mp3"];
//    [m_audioPlayer play];
//}

- (BOOL)closeNowView
{
    if ([m_webView canGoBack]) {
        NSString *url = [m_webView.request.URL absoluteString];
        NSRange ran = [url rangeOfString:@"index.html"];
        if (!ran.length) {
            [m_webView goBack];
            return NO;
        }
        else
        {
            [self closeWebViewItem];
            return YES;
        }
    }
    else
    {
        if (m_block)
        {
            m_block(@"");
        }
        [self closeWebViewItem];
        return YES;
    }
}

-(void)closeWebViewItem
{
    [CommonImage popToNoNavigationView];
    [m_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];//牛牛话匣关闭
    [ m_moviePlayerView  stopMoviePlayer];//关闭视频
    
    [super closeNowView];
}

- (void)onPlayMusic
{
    [m_webView stringByEvaluatingJavaScriptFromString:@"onPlayMusic()"];
}

- (void)onParuseMusic
{
    [m_webView stringByEvaluatingJavaScriptFromString:@"onParuseMusic()"];
}

- (void)createNavigation
{
    UIButton* left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(10, IOS_7?20:0, 44, 44);
    left.tag = 33;
    [left addTarget:self action:@selector(popMySelfNav) forControlEvents:UIControlEventTouchUpInside];
    left.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [left setImage:[UIImage imageNamed:@"common.bundle/nav/icon_back_normal.png"] forState:UIControlStateNormal];
    [left setImage:[UIImage imageNamed:@"common.bundle/nav/icon_back_pressed.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:left];
}

-(void)createLeft:(BOOL)naHider
{
    UIView *navaView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 75, 44)];
    if (navaView)
    {
        UIButton* right1 = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *imageStr = naHider?@"common.bundle/nav/webView_back_h.png":@"common.bundle/nav/nav_back_white.png";
        [right1 setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        right1.frame = CGRectMake(0, 0, 44, 44);
        right1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        right1.tag = 1002;
        [right1 setEnlargeEdgeWithTop:20 right:0 bottom:20
                              left:20];
        [right1 addTarget:self action:@selector(backAndClose:) forControlEvents:UIControlEventTouchUpInside];
        [navaView addSubview:right1];
        
        UIButton* right2 = [UIButton buttonWithType:UIButtonTypeCustom];
        imageStr = naHider?@"common.bundle/nav/webView_close_h.png":@"common.bundle/nav/nav_close_white.png";
        [right2 setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        right2.frame = CGRectMake(53, 0, 44, 44);
        right2.tag = 1003;
        right2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [right2 addTarget:self action:@selector(backAndClose:) forControlEvents:UIControlEventTouchUpInside];
        [navaView addSubview:right2];
        
        UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:navaView];
        if (naHider) {
            [self.view addSubview:navaView];
            navaView.frame = [Common rectWithOrigin:navaView.frame x:10 y:IOS_7?20:0];
        }
        else {
            self.navigationItem.leftBarButtonItem = leftBar;
        }
        [leftBar release];
    }
}

-(void)backAndClose:(UIButton *)btn
{
    switch (btn.tag) {
        case 1002:
            [(CommonNavViewController*)self.navigationController popMySelf];
            break;
        case 1003:
            [self closeWebViewItem];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}
- (void)popMySelfNav
{
    //暂停音频播放
    if (m_webView)
    {
        [m_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//播放视频
- (void)createMovPlay:(NSString*)URL
{
    if (!m_moviePlayerView)
    {
        m_moviePlayerView = [[KXMoviePlayer alloc] init];
        [m_moviePlayerView noEnbleScrollBackView:m_webView];
    }
    [m_moviePlayerView loadMoviePlayerWithUrl:URL inParentViewControler:self];
}

#pragma mark - UIWebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL * url = [request URL];
    
    if ([[url scheme] isEqualToString:@"topic"]) {
        
        NSString *strurl = [url absoluteString];
        strurl = [strurl stringByReplacingOccurrencesOfString:@"topic:" withString:@""];
        
        [self createMovPlay:strurl];
        
        return NO;
    }
    else if ([[url scheme] isEqualToString:@"common"]) {
        
        NSString *strurl = [url absoluteString];
        strurl = [strurl stringByReplacingOccurrencesOfString:@"common:" withString:@""];
        
        //        AudioPlayer *audioPlayer = [[AudioPlayer alloc] init];
        //        audioPlayer.url = [NSURL URLWithString:strurl];
        //        [audioPlayer play];
        
        @try {
            
            NSString* strCon = [strurl stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
            NSData *data = [NSData dataWithContentsOfFile:[[Common getAudioPath] stringByAppendingFormat:@"/%@", strCon]];
            
            if (!data) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                    
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strurl]];
                    
                    [data writeToFile:[[Common getAudioPath] stringByAppendingFormat:@"/%@", strCon] atomically:YES];
                    NSLog(@"123123");
                    dispatch_async( dispatch_get_main_queue(), ^(void){
                        
                        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:nil];
                        player.delegate = self;
                        //                      [player setVolume:1];   //设置音量大小
                        //                      player.numberOfLoops = 1;//设置音乐播放次数  -1为一直循环
                        [player play];
                        //                      [player release];
                    });
                });
            }
            else {
                
                AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:nil];
                player.delegate = self;
                //            [player setVolume:1];   //设置音量大小
                //            player.numberOfLoops = 1;//设置音乐播放次数  -1为一直循环
                [player play];
                //            [player release];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        return NO;
    }
    else if ([[url scheme] isEqualToString:@"uploadnce"]) {
        
        ImagePicker *picker = [[ImagePicker alloc] initWithId:self];
        picker.selectHeadPhoto = NO;
        // 选择图片的最大数
        picker.maxCount =6;
        [picker setPickerViewBlock:^(id content) {
            if ([content isKindOfClass:[NSArray class]])
            {
                [self senPickerImgeGroupAsstes:content isLishi:NO];
            }
            else if ([content isKindOfClass:[UIImage class]]) {
                NSData *data = UIImagePNGRepresentation(content);
                [self sendPicAudioQiniu:data withDic:nil withName:nil];
            }
            [picker release];
            
        }];
        NSLog(@"uploadnce");
        
        return NO;
    }
    else  if ([[url scheme] isEqualToString:@"ordernce"])
    {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showZhifujieguo) name:@"showZhifujieguo" object:nil];
        
        NSString *strurl = [url absoluteString];
        strurl = [strurl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        strurl = [strurl stringByReplacingOccurrencesOfString:@"ordernce:" withString:@""];
        NSMutableDictionary *dictOrder = [strurl KXjSONValueObject];
        NSString *orderId = dictOrder[@"goodId"];
        if ([orderId isKindOfClass:[NSNumber class]])
        {
            orderId = [(NSNumber*)orderId stringValue];
        }
        payNotiUrl = [dictOrder[@"url"] copy];
//        NSString *notifyURL = @"http://kxpay.kangxun360.com/charge/sendGoods";// 转移到aliconfig
        [dictOrder setObject:orderId forKey:kOrderID];
        [dictOrder setObject:dictOrder[@"goodPrice"] forKey:kTotalAmount];
        [dictOrder setObject:dictOrder[@"goodDesc"] forKey:kProductDescription];
        [dictOrder setObject:dictOrder[@"goodName"] forKey:kProductName];
        
        //1支付宝 2微信 3代付
//        KXPayManageType type = [dictOrder[@"payway"] integerValue]-1;

//        [self handlePayContentWithPayDict:dictOrder andWithPayTypeDict:type];
        
        if (!dictOrder[@"payway"] || [dictOrder[@"payway"] isKindOfClass:[NSString class]]) {
            
            WS(weakSelf);
            //支付页面
            [KXPayManageView showKXPayManageViewWithBlock:^(KXPayManageType selecteContent) {
                [weakSelf handlePayContentWithPayDict:dictOrder andWithPayTypeDict:selecteContent];
            }];
        }
        else {
            
            KXPayManageType type = [dictOrder[@"payway"] integerValue]-1;
            [self handlePayContentWithPayDict:dictOrder andWithPayTypeDict:type];
        }
        
        return NO;
    }
    else if ([[url scheme] isEqualToString:@"shareinfo"])
    {
        NSString *strurl = [url absoluteString];
        strurl = [strurl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        strurl = [strurl stringByReplacingOccurrencesOfString:@"shareinfo:" withString:@""];
        NSDictionary *dictOrder = [strurl KXjSONValueObject];
        
        self.shareImage = dictOrder[@"shareImage"];
        self.shareTitle = dictOrder[@"shareTitle"];
        self.shareContentString = dictOrder[@"shareContentString"];
        self.shareURL = dictOrder[@"shareURL"];
        [self goToShare];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shearOK) name:@"shearOK" object:nil];
        
        return NO;
    }
    else if ([[url scheme] isEqualToString:@"chatinfo"])
    {
        NSString *strurl = [url absoluteString];
        strurl = [strurl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        strurl = [strurl stringByReplacingOccurrencesOfString:@"chatinfo:" withString:@""];
        NSDictionary *dic = [strurl KXjSONValueObject];
        
        ShowConsultViewController *show = [[ShowConsultViewController alloc] init];
        FriendModel *friendMo = [[FriendModel alloc] init];
        friendMo.accountId = dic[@"accountId"];
        friendMo.userPhoto = dic[@"userPhoto"];
        friendMo.nickName = dic[@"nickName"];
        show.friendModel = friendMo;
        [self.navigationController pushViewController:show animated:YES];
        
        return NO;
    }
    else if ([[url scheme] isEqualToString:@"closeweb"])
    {
        UINavigationController *nav = (UINavigationController*)APP_DELEGATE2.navigationVC;
        [nav popViewControllerAnimated:YES];
        
        return NO;
    }
    else if ([[url scheme] isEqualToString:@"pushwebview"])
    {
        NSString *strurl = [url absoluteString];
        strurl = [strurl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        strurl = [strurl stringByReplacingOccurrencesOfString:@"pushwebview:" withString:@""];
        NSDictionary *dic = [strurl KXjSONValueObject];
        
        WebViewController *web = [[WebViewController alloc] init];
        web.title = dic[@"title"];
        web.m_url = dic[@"url"];
        
        UINavigationController *nav = (UINavigationController*)APP_DELEGATE2.navigationVC;
        [nav pushViewController:web animated:YES];
        
        return NO;
    }
    else if ([[url scheme] isEqualToString:@"personinfo"])
    {
        UINavigationController *nav = (UINavigationController*)APP_DELEGATE2.navigationVC;
        ThinPersonalViewController *personal = [[ThinPersonalViewController alloc] init];
        [nav pushViewController:personal animated:YES];
        
        return NO;
    }
    else if ([[url scheme] isEqualToString:@"thinchart"])
    {
        UINavigationController *nav = (UINavigationController*)APP_DELEGATE2.navigationVC;
        ThinViewController *thin = [[ThinViewController alloc] init];
        [nav pushViewController:thin animated:YES];
        
        return NO;
    }
    else if ([[url scheme] isEqualToString:@"navrightshowtitle"])
    {
        NSString *strurl = [url absoluteString];
        strurl = [strurl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        strurl = [strurl stringByReplacingOccurrencesOfString:@"navrightshowtitle:" withString:@""];
        m_dic = [[strurl KXjSONValueObject] retain];
        
        UIBarButtonItem *right = [Common CreateNavBarButton:self setEvent:@selector(butNavRight:) setTitle:m_dic[@"titile"]];
        self.navigationItem.rightBarButtonItem = right;

        return NO;
    }
    else if ([[url scheme] isEqualToString:@"videocontent"])
    {
        NSString *strurl = [url absoluteString];
        strurl = [strurl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        strurl = [strurl stringByReplacingOccurrencesOfString:@"videocontent:" withString:@""];
        NSMutableDictionary *dic = [strurl KXjSONValueObject];
        [dic setObject:dic[@"paramid"] forKey:@"id"];
        
        UINavigationController *nav = (UINavigationController*)APP_DELEGATE2.navigationVC;
        
//        AppDelegate *myAppDelegate = [Common getAppDelegate];
        
        
        VideoDetailViewController *detail = [[VideoDetailViewController alloc] init];
        detail.m_superDic = dic;
        [nav pushViewController:detail animated:YES];
        
        return NO;
    }
    //personInfo();
    //thinChart();
    //     return  [self handleWebViewDataWithUrl:url];
    return YES;
}

- (void)butNavRight:(UIButton*)but
{
    WebViewController *web = [[WebViewController alloc] init];
    web.title = m_dic[@"title"];
    web.m_url = m_dic[@"url"];
    UINavigationController *nav = (UINavigationController*)APP_DELEGATE2.navigationVC;
    [nav pushViewController:web animated:YES];
}

#pragma mark 处理支付
///  处理支付
///
///  @param dict        付款内容
///  @param payTypeDict 付款的方式
- (void)handlePayContentWithPayDict:(NSDictionary *)dict andWithPayTypeDict:(KXPayManageType)type
{
    if (KXPayManageTypeAli == type)
    {
        [self sendAliPayWithDict:dict];
    }
    else if (KXPayManageTypeWX == type)
    {
        [self sendWxPayWithDict:dict];
    }
    else
    {
        [self sendWxFriendPayWith:dict];
    }
}
//支付宝
- (void)sendAliPayWithDict:(NSDictionary *)dict
{
    WS(weakSelf);
    [KXPayManage paymentWithInfo:dict result:^(int statusCode, NSString *statusMessage, NSString *resultString, NSError *error, NSData *data) {
        [weakSelf handlerPayResultWithStatusMessage:statusMessage];
        NSLog(@"statusCode=%d \n statusMessage=%@ \n resultString=%@ \n err=%@ \n data=%@",statusCode,statusMessage,resultString,error,data);
    }];
}

//微信
- (void)sendWxPayWithDict:(NSDictionary *)dict
{
    WS(weakSelf);
    [KXPayManage wxPayActionWithInfo:dict result:^(int statusCode, NSString *statusMessage, id resultDict, NSError *error, NSData *data) {        
        [weakSelf handlerPayResultWithStatusMessage:statusMessage];
    }];
}

//微信代付
- (void)sendWxFriendPayWith:(NSDictionary*)dic
{
    WS(weakSelf);
    [[KXShareManager sharedManager] sendWXFriendList:dic withBlock:^(BOOL isOK) {
        if (isOK) {
            [weakSelf.m_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:payNotiUrl]]];//
        }
    }];
}

- (void)handlerPayResultWithStatusMessage:(NSString *)statusMessage
{
    if (![kPaySuccess isEqualToString:statusMessage])
    {
        return;
    }
    if (payNotiUrl.length)
    {
        [m_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:payNotiUrl]]];//刷新
        payNotiUrl = nil;
    }
    else
        [m_webView reload];
    [[KXPayManage sharePayEngine] setUpNilBlock];
}

- (void)showZhifujieguo
{
    [self handlerPayResultWithStatusMessage:@"kPaySuccess"];
}

- (BOOL)handleWebViewDataWithUrl:(NSURL *)url
{
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError");
    [self stopLoadingActiView];
}

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    [self stopLoadingActiView];
}

#pragma mark - NJKWebViewProgressDelegate
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [m_progressView setProgress:progress animated:YES];
    //    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)senPickerImgeGroupAsstes:(NSArray *)assets isLishi:(BOOL)is
{
    for (ALAsset *asset in assets)
    {
        UIImage *image;
        if ([asset isKindOfClass:[ALAsset class]]) {
            CGImageRef ref = [[asset  defaultRepresentation]fullScreenImage];
            image = [UIImage imageWithCGImage:ref];
        }
        NSData *data = UIImagePNGRepresentation(image);
        [self sendPicAudioQiniu:data withDic:nil withName:nil];
    }
}

- (void)sendPicAudioQiniu:(NSData*)data withDic:(NSMutableDictionary*)dic withName:(NSString*)name
{
    [self showLoadingActiview];
    [GetToken submitData:data withBlock:^(BOOL isOK, NSString *path) {
        if (isOK) {
            NSString * jsUrl = [NSString stringWithFormat:@"showNCE(\"%@\")",path];
            [m_webView stringByEvaluatingJavaScriptFromString:jsUrl];
        }
        else {
            [Common TipDialog:@"上传失败"];
        }
        [self stopLoadingActiView];
    } withName:name];
}

- (void)shearOK
{
    [m_webView stringByEvaluatingJavaScriptFromString:@"shareCallBack()"];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [player release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
