//
//  NoticeDetailViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-5-10.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "NoticeDetailViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "AudioPlayer.h"
#import "ImagePicker.h"
#import "GetToken.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface NoticeDetailViewController ()
<UIWebViewDelegate,NJKWebViewProgressDelegate, AVAudioPlayerDelegate>
{
//	UIWebView *newsWebView;
	BOOL _isCollection;//是否收藏
	BOOL _isPraise;//是否点赞
	UIView * m_view;
//	NJKWebViewProgressView *_progressView;
//	NJKWebViewProgress *_progressProxy;
	
}
@end

@implementation NoticeDetailViewController
@synthesize m_dicInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
		self.title = @"详情";
	}
	return self;
}

- (void)dealloc
{
//    _progressProxy.webViewProxyDelegate = nil;
//    _progressProxy.progressDelegate = nil;
    m_dicInfo = nil;
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
//    [_progressView removeFromSuperview];
//    [_progressProxy release];
//    [_progressView release];
//    [newsWebView release];
//    [m_view release];
    [super dealloc];
}

//- (BOOL)closeNowView
//{
//	if ([newsWebView canGoBack]) {
//		NSString *url = [newsWebView.request.URL absoluteString];
//		NSRange ran = [url rangeOfString:@"index.html"];
//		if (!ran.length) {
//			[newsWebView goBack];
//			return NO;
//		}
//		else
//		{
//			return YES;
//		}
//	}
//	else
//	{
//		return YES;
//	}
//}

- (void)shareFunc
{
    self.shareTitle = self.titleName;
    self.shareImage = nil;//置为空，现在分享固定图片
//    self.shareContentString = self.titleName;
//    self.subTitle = self.subTitle;
    self.shareContentString = self.subTitle;
//    self.shareURL = @"http://admin.kangxun360.com/operation/activity/share.html";

	NSString *requestURL = [NSString stringWithFormat:@"%@operation/activity/share_%@.html?id=%@&code=%@&token=%@",NOTICE_DETAIL_URL, self.newsId, g_nowUserInfo.userid, g_nowUserInfo.userid,g_nowUserInfo.userToken];

    if (![self.shareURL length]) {
        self.shareURL = requestURL;
    }
    [self goToShare];
}

- (void)setM_dicInfo:(NSDictionary*)dicInfo
{
	m_dicInfo = dicInfo;
	if ([[dicInfo objectForKey:@"isShare"] boolValue]) {
//		UIBarButtonItem *rightButtonItem = [Common createNavBarButton:self setEvent:@selector(shareFunc) withNormalImge:@"common.bundle/nav/top_share_icon_nor.png" andHighlightImge:@"common.bundle/nav/top_share_icon_pre.png"];
//        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享 " style:UIBarButtonItemStylePlain target:self action:@selector(shareFunc)];
//		self.navigationItem.rightBarButtonItem = rightButtonItem;
        self.navigationItem.rightBarButtonItem = [Common CreateNavBarButton3:self setEvent:@selector(shareFunc) setTitle:@"分享"];

    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR2];
    // Do any additional setup after loading the view.
    //	[self getHtmlView];
    if (self.m_isHideNavBar)
    {
      [self createCustomNavigation];
    }
}

- (void)createCustomNavigation
{
//    UIButton* left = [UIButton buttonWithType:UIButtonTypeCustom];
//    left.frame = CGRectMake(10, IOS_7?20:0, 44, 44);
//    [left addTarget:self action:@selector(popMySelf) forControlEvents:UIControlEventTouchUpInside];
//    left.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [left setImage:[UIImage imageNamed:@"common.bundle/nav/icon_back_normal.png"] forState:UIControlStateNormal];
//    [left setImage:[UIImage imageNamed:@"common.bundle/nav/icon_back_pressed.png"] forState:UIControlStateHighlighted];
////    [left setContentMode:UIViewContentModeCenter];
//    [self.view addSubview:left];
    
    if ([[m_dicInfo objectForKey:@"isShare"] boolValue]) {
        UIButton* but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(kDeviceWidth-40, IOS_7?20:0, 44, 44);
        [but addTarget:self action:@selector(shareFunc) forControlEvents:UIControlEventTouchUpInside];
        but.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [but setTitleColor:[CommonImage colorWithHexString:VERSION_ERROR_TEXT_COLOR] forState:UIControlStateNormal];
        [but setTitle:@"分享" forState:UIControlStateNormal];
//        [but setImage:[UIImage imageNamed:@"common.bundle/nav/nav_share.png"] forState:UIControlStateNormal];
//        [but setImage:[UIImage imageNamed:@"common.bundle/nav/navigationbar_icon_share_pressed.png"] forState:UIControlStateHighlighted];
//        [but setContentMode:UIViewContentModeCenter];
        [self.view addSubview:but];
    }
    self.m_webView.frameHeight = kDeviceHeight+64;
}

//- (void)popMySelf
//{
////    [Common popToNoNavigationView];
//	if ([newsWebView canGoBack]) {
//		NSString *url = [newsWebView.request.URL absoluteString];
//		NSRange ran = [url rangeOfString:@"index.html"];
//		if (!ran.length) {
//			[newsWebView goBack];
//		}
//		else
//		{
//			[self.navigationController popViewControllerAnimated:YES];
//		}
//    }
//    else
//    {
//       [self.navigationController popViewControllerAnimated:YES];
//    }
//}

//- (void)getHtmlView
//{
//	newsWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, SCREEN_HEIGHT-44)];
//	NSLog(@"---frame:%@",NSStringFromCGRect(self.view.bounds));
//	//    newsWebView.delegate = self;
//    
//	newsWebView.backgroundColor = self.view.backgroundColor;
//	newsWebView.opaque = NO;
//    newsWebView.scalesPageToFit = YES;
//	[self.view addSubview:newsWebView];
//	
//	_progressProxy = [[NJKWebViewProgress alloc] init];
//	newsWebView.delegate = _progressProxy;
//	_progressProxy.webViewProxyDelegate = self;
//	_progressProxy.progressDelegate = self;
//	
//	CGFloat progressBarHeight = 2.f;
//	CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
//	CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
//	_progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
//	_progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//	
////	NSString *requestURL = [NSString stringWithFormat:@"%@operation/activity/index.html?id=%@",NOTICE_DETAIL_URL, g_nowUserInfo.userid];
////	[newsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]]];
//	
//	[newsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[m_dicInfo objectForKey:@"url"]]]];
//    [self.navigationController.navigationBar addSubview:_progressView];
//
//}

//- (void)viewWillAppear:(BOOL)animated
//{
//	[super viewWillAppear:animated];
//    _progressProxy.webViewProxyDelegate = self;
//    _progressProxy.progressDelegate = self;
//}

//-(void)viewWillDisappear:(BOOL)animated
//{
//	[super viewWillDisappear:animated];
//    _progressProxy.webViewProxyDelegate = nil;
//    _progressProxy.progressDelegate = nil;
//	// Remove progress view
//	// because UINavigationBar is shared with other ViewControllers
//	[_progressView removeFromSuperview];
//}


//#pragma mark - NJKWebViewProgressDelegate
//-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
//{
//	[_progressView setProgress:progress animated:YES];
//	//    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//}
//
//#pragma mark - UIWebView Delegate
//
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    NSURL * url = [request URL];
//    
//    if ([[url scheme] isEqualToString:@"common"]) {
//        
//        NSString *strurl = [url absoluteString];
//        strurl = [strurl stringByReplacingOccurrencesOfString:@"common:" withString:@""];
//        
////        AudioPlayer *audioPlayer = [[AudioPlayer alloc] init];
////        audioPlayer.url = [NSURL URLWithString:strurl];
////        [audioPlayer play];
//        
//        @try {
//            
//            NSString* strCon = [strurl stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
//            NSData *data = [NSData dataWithContentsOfFile:[[Common getAudioPath] stringByAppendingFormat:@"/%@", strCon]];
//            
//            if (!data) {
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
//                    
//                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strurl]];
//                    
//                    [data writeToFile:[[Common getAudioPath] stringByAppendingFormat:@"/%@", strCon] atomically:YES];
//                    NSLog(@"123123");
//                    dispatch_async( dispatch_get_main_queue(), ^(void){
//                        
//                        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:nil];
//                        player.delegate = self;
//                        //                    [player setVolume:1];   //设置音量大小
//                        //                    player.numberOfLoops = 1;//设置音乐播放次数  -1为一直循环
//                        [player play];
//                        //                    [player release];
//                    });
//                });
//            }
//            else {
//                
//                AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:nil];
//                player.delegate = self;
//                //            [player setVolume:1];   //设置音量大小
//                //            player.numberOfLoops = 1;//设置音乐播放次数  -1为一直循环
//                [player play];
//                //            [player release];
//            }
//        }
//        @catch (NSException *exception) {
//            
//        }
//        @finally {
//            
//        }
//
//        return NO;
//    }
//    else if ([[url scheme] isEqualToString:@"uploadnce"]) {
//        
//        ImagePicker *picker = [[ImagePicker alloc] initWithId:self];
//        picker.selectHeadPhoto = NO;
//        // 选择图片的最大数
//        picker.maxCount =6;
//        [picker setPickerViewBlock:^(id content) {
//            if ([content isKindOfClass:[NSArray class]])
//            {
//                [self senPickerImgeGroupAsstes:content isLishi:NO];
//            }
//            else if ([content isKindOfClass:[UIImage class]]) {
//                NSData *data = UIImagePNGRepresentation(content);
//                [self sendPicAudioQiniu:data withDic:nil withName:nil];
//            }
//            [picker release];
//            
//        }];
//        NSLog(@"uploadnce");
//        return NO;
//    }
//    
//    return YES;
//}
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//    NSLog(@"didFailLoadWithError");
//}
//
//- (void)senPickerImgeGroupAsstes:(NSArray *)assets isLishi:(BOOL)is
//{
//    for (ALAsset *asset in assets)
//    {
//        UIImage *image;
//        if ([asset isKindOfClass:[ALAsset class]]) {
//            CGImageRef ref = [[asset  defaultRepresentation]fullScreenImage];
//            image = [UIImage imageWithCGImage:ref];
//        }
//        NSData *data = UIImagePNGRepresentation(image);
//        [self sendPicAudioQiniu:data withDic:nil withName:nil];
//    }
//}
//
////
//- (void)sendPicAudioQiniu:(NSData*)data withDic:(NSMutableDictionary*)dic withName:(NSString*)name
//{
//    [self showLoadingActiview];
//    [GetToken submitData:data withBlock:^(BOOL isOK, NSString *path) {
//        if (isOK) {
//            NSString * jsUrl = [NSString stringWithFormat:@"showNCE(\"%@\")",path];
//            [newsWebView stringByEvaluatingJavaScriptFromString:jsUrl];
//        }
//        else {
//            [Common TipDialog:@"上传失败"];
//        }
//        [self stopLoadingActiView];
//    } withName:name];
//}

//- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
//{
//    [player release];
//}
//
//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//    [self showLoadingActiview];
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    [self stopLoadingActiView];
//}
//
//- (void)didReceiveMemoryWarning
//{
//	[super didReceiveMemoryWarning];
//	// Dispose of any resources that can be recreated.
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end