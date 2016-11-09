//
//  FoodDetailViewController.m
//  jiuhaohealth3.0
//
//  Created by jiuhao-yangshuo on 15-1-19.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "FoodDetailViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface FoodDetailViewController ()
<UIWebViewDelegate,NJKWebViewProgressDelegate>
{
    UIWebView *newsWebView;
}
@end

@implementation FoodDetailViewController
@synthesize  dictInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        self.log_pageID = 123;
//        self.title = @"膳食推荐";
        UIBarButtonItem *rightButtonItem = [Common createNavBarButton:self setEvent:@selector(shareFunc) withNormalImge:@"common.bundle/nav/top_share_icon_nor.png" andHighlightImge:@"common.bundle/nav/top_share_icon_pre.png"];
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    return self;
}

-(void)dealloc
{
     newsWebView.delegate = nil;
    [newsWebView release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.title;
    // Do any additional setup after loading the view.
    
    newsWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    NSLog(@"---frame:%@",NSStringFromCGRect(self.view.bounds));
    //    newsWebView.delegate = self;
    newsWebView.backgroundColor = self.view.backgroundColor;
//	newsWebView.opaque = NO;
    [self.view addSubview:newsWebView];
    
    [self getServerData];
}

- (void)shareFunc
{
//    self.shareTitle = [dictInfo[@"title"] length]?dictInfo[@"title"]:dictInfo[@"name"];
    
    NSString *test = dictInfo[@"scheduling_date"];
    NSString *date = [test stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    self.shareTitle = [NSString stringWithFormat:@"%@的每日膳食精品推荐 %@", g_nowUserInfo.nickName, date];

    self.shareImage = nil;//置为空，现在分享固定图片
    self.shareContentString = [NSString stringWithFormat:@"%@的每日膳食精品推荐 %@", g_nowUserInfo.nickName, date];
    NSString * requestURL = [NSString stringWithFormat:@"%@caipu/index.html?time=%@&userid=%@",Share_Server_URL,dictInfo[@"scheduling_date"],g_nowUserInfo.userid];
    self.shareURL = requestURL;
    [self goToShare];
}

- (void)getServerData
{
     NSString * requestURL = [NSString stringWithFormat:@"%@caipu/index.html?time=%@&userid=%@&hug=%@",Share_Server_URL,dictInfo[@"scheduling_date"],g_nowUserInfo.userid,dictInfo[@"hug_count"]];
      [newsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]]];
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}


- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    if (![[dic objectForKey:@"state"] intValue])
    {
        if ([loader.username isEqualToString:GET_FOODHOME_DETAIl]) {
            NSDictionary *rs = dic[@"rs"];
            [newsWebView loadHTMLString:[rs objectForKey:@"pointObtain"] baseURL:nil];
        }
    } else {
        [Common TipDialog:dic[@"msg"]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
