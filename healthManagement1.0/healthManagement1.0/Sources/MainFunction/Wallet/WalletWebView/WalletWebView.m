//
//  WalletWebView.m
//  jiuhaohealth4.0
//
//  Created by xjs on 15/5/22.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "WalletWebView.h"
//#import "KXPayManage.h"

#define LK_THIRD @"7lk_third"

@interface WalletWebView ()

@end

@implementation WalletWebView
@synthesize m_dicInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"详情";
        m_dicInfo = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)dealloc
{
    m_dicInfo = nil;
    [super dealloc];
}

- (BOOL)closeNowView
{
    [super closeNowView];
    
    if ([self.m_webView canGoBack]) {
        NSString *url = [self.m_webView.request.URL absoluteString];
        NSRange ran = [url rangeOfString:@"index.html"];
        if (!ran.length) {
            [self.m_webView goBack];
//            self.navigationController.navigationItem.backBarButtonItem
            
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return YES;
    }
}

- (void)requestUrl
{
    self.m_webView.hidden = YES;
    [[CommonHttpRequest defaultInstance] sendNewWebPostRequest:LK_THIRD values:nil requestKey:LK_THIRD delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"请求中...", nil)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR2];
    
    // Do any additional setup after loading the view.
    if (!m_dicInfo[@"url"])
    {
        [self requestUrl];
    }
//    //test yangshuo
//    [self test];
//    //testyangshuo
}

-(void)test
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//              测试
        self.m_url = @"http://wx.kangxun360.com/static/app/order/list.html";
        self.m_webView.hidden = NO;
        [self.m_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.m_url]]];
    });
}


- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    NSLog(@"%@",dic);
    if ([dic[@"err_code"] intValue]) {
        [Common TipDialog2:@"err_msg"];
        return;
    }
    if ([loader.username isEqualToString:LK_THIRD]) {
        //获取详情
        [m_dicInfo setValue:dic[@"data"][@"url"] forKey:@"url"];
        self.m_url = dic[@"data"][@"url"];
        self.m_webView.hidden = NO;
        [self.m_webView reload];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
