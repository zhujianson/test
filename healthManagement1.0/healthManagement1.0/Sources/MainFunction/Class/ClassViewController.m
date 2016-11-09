//
//  ClassViewController.m
//  healthManagement1.0
//
//  Created by xuguohong on 16/7/1.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "ClassViewController.h"
#import "KXSlideView.h"
#import "VideoListCollectionVC.h"
#import "AudioListTableViewC.h"
#import "SearchViewController.h"
#import "SoundListViewController.h"

@interface ClassViewController () <UIScrollViewDelegate>
{
    UIScrollView *m_scrollView;
    
    UIButton *m_lastBut;
    
    VideoListCollectionVC *m_videoVC;
    SoundListViewController *m_audioVC;
}

@end

@implementation ClassViewController

//- (id)init
//{
//    self = [super init];
//    if (self) {
//        self.title = @"微视频";
//    }
//    
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"微课堂";
    
    UIView *header = [self createHeaderView];
    [self.view addSubview:header];
    
    m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, header.bottom, kDeviceWidth, kDeviceHeight-header.bottom)];
    m_scrollView.backgroundColor = [UIColor clearColor];
    m_scrollView.pagingEnabled = YES;
    m_scrollView.delegate = self;
    m_scrollView.contentSize = CGSizeMake(m_scrollView.width*2, m_scrollView.height);
    [self.view addSubview:m_scrollView];
    [self createTab:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (m_videoVC) {
        [m_videoVC viewWillAppear:animated];
    }
    
    if (m_audioVC) {
        [m_audioVC viewWillAppear:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (m_videoVC) {
        [m_videoVC viewWillDisappear:animated];
    }
    
    if (m_audioVC) {
        [m_audioVC viewWillDisappear:animated];
    }
}

- (UIView*)createHeaderView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 45)];
    
    UIButton *butV = [self createBut:@"视频"];
    butV.top = (view.height-butV.height)/2.f;
    butV.left = 10;
    butV.tag = 100;
    butV.selected = YES;
    m_lastBut = butV;
    [view addSubview:butV];
    
    UIButton *butA = [self createBut:@"话题"];
    butA.top = butV.top;
    butA.left = butV.right+10;
    butA.tag = 101;
    [view addSubview:butA];
    
    UIButton *butSearch = [self createBut:@" 搜视频"];
    butSearch.tag = 102;
    butSearch.frame = CGRectMake(butA.right+10, butA.top, view.width-(butA.right+20), 30);
    [butSearch setImage:[UIImage imageNamed:@"common.bundle/class/video_search.png"] forState:UIControlStateNormal];
    [butSearch setTitleColor:[CommonImage colorWithHexString:@"999999"] forState:UIControlStateHighlighted];
    [butSearch setTitleColor:[CommonImage colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    [butSearch setBackgroundImage:[CommonImage createImageWithColor:[CommonImage colorWithHexString:@"ffffff"]] forState:UIControlStateNormal];
    butSearch.layer.borderWidth = 0;
    [view addSubview:butSearch];
    
    return view;
}

- (UIButton*)createBut:(NSString*)title
{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.clipsToBounds = YES;
    but.frame = CGRectMake(0, 0, 70, 30);
    [but setTitle:title forState:UIControlStateNormal];
    [but setTitleColor:[CommonImage colorWithHexString:@"000000"] forState:UIControlStateNormal];
    [but setTitleColor:[CommonImage colorWithHexString:The_ThemeColor] forState:UIControlStateHighlighted];
    [but setTitleColor:[CommonImage colorWithHexString:The_ThemeColor] forState:UIControlStateSelected];
    [but setBackgroundImage:[CommonImage createImageWithColor:[CommonImage colorWithHexString:@"f2f2f2"]] forState:UIControlStateNormal];
    [but setBackgroundImage:[CommonImage createImageWithColor:[CommonImage colorWithHexString:@"ffffff"]] forState:UIControlStateHighlighted];
    [but setBackgroundImage:[CommonImage createImageWithColor:[CommonImage colorWithHexString:@"ffffff"]] forState:UIControlStateSelected];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    but.layer.cornerRadius = but.height/2;
    but.layer.borderColor = [CommonImage colorWithHexString:@"dcdcdc"].CGColor;
    but.layer.borderWidth = 0.5;
    [but addTarget:self action:@selector(butEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    return but;
}

- (void)butEvent:(UIButton*)but
{
    if (but.tag == 102) {
        
        SearchViewController *searchView = [[SearchViewController alloc] init];
        [self.navigationController pushViewController:searchView animated:NO];
        return;
    }
    
    if ([m_lastBut isEqual:but]) {
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        m_scrollView.contentOffset = CGPointMake(but.tag-100 ? kDeviceWidth : 0, 0);
    }];
    
    [self setButSelect:but];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = (int)(floor((offset.x - pageWidth / 2) / pageWidth) + 1 );
    
    UIButton *but = [self.view viewWithTag:100+page];
    [self setButSelect:but];
}

- (void)setButSelect:(UIButton*)but
{
    if (but.selected) {
        return;
    }
    but.selected = YES;
    but.layer.borderWidth = 0;
    
    m_lastBut.selected = NO;
    m_lastBut.layer.borderWidth = 0.5;
    m_lastBut = but;
    
    UIButton *buts = [self.view viewWithTag:102];
    buts.enabled = !(but.tag - 100);
//    buts.layer.borderWidth = buts.enabled ? 0 : 0.5;
}

- (void)createTab:(NSDictionary*)dic
{
    m_videoVC = [[VideoListCollectionVC alloc] init];
    m_videoVC.m_superClass = self;
//    videoVC.view.backgroundColor = self.view.backgroundColor;
    m_videoVC.view.frame = CGRectMake(0, 0, kDeviceWidth, m_scrollView.height);
    [m_scrollView addSubview:m_videoVC.view];
    
    m_audioVC = [[SoundListViewController alloc] init];
    m_audioVC.m_superClass = self;
//        audioVC.view.backgroundColor = [UIColor blueColor];
    m_audioVC.view.frame = CGRectMake(m_audioVC.view.right, 0, kDeviceWidth, m_scrollView.height);
    [m_scrollView addSubview:m_audioVC.view];
}


- (void)didReceiveMemoryWarning {
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
