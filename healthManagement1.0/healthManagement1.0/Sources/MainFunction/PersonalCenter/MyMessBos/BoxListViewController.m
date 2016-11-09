//
//  BoxListViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-17.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "BoxListViewController.h"
#import "SystemDetailViewController.h"
#import "AppDelegate.h"
#import "CommonHttpRequest.h"
#import "DBOperate.h"
//#import "BookChallengeViewController.h"
#import "SelectedView.h"
#import "BoxListTableView.h"

@interface BoxListViewController ()<UIScrollViewDelegate>
{
    UIScrollView * m_scroll;
    int m_index;
    BoxListTableView * m_healthBox;
    BoxListTableView * m_systemBox;
    SelectedView*selectedView;
    
}

@end

@implementation BoxListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
//        self.title = @"我的信箱";
        self.navigationItem.rightBarButtonItem = [Common CreateNavBarButton3:self setEvent:@selector(butEventClear) setTitle:@"清空"];

//        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"清空 " style:UIBarButtonItemStylePlain target:self action:@selector(butEventClear)];
//        self.navigationItem.rightBarButtonItem = right;
//        [right release];
        
    }
    return self;
}

- (void)dealloc
{
    [m_scroll release];
    [m_healthBox release];
    [m_systemBox release];
    [selectedView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    m_scroll.contentSize = CGSizeMake(kDeviceWidth*2, 0);
    m_scroll.showsHorizontalScrollIndicator = NO;
    m_scroll.pagingEnabled = YES;
    m_scroll.scrollEnabled = NO;
    m_scroll.delegate = self;
    [self.view addSubview:m_scroll];
    
    selectedView = [[SelectedView alloc] initWithFrame:CGRectMake(0, 0, 190, 27)];
    selectedView.backgroundColor = [UIColor clearColor];
    selectedView.theStyle = SegmentStyle;
//    selectedView.
    __block UIScrollView *weakScrollView = m_scroll;
    [selectedView setSelectedBtnBlock:^(int index){
        m_index = index-100;
        [UIView animateWithDuration:0.30 animations:^{
            [weakScrollView setContentOffset:CGPointMake((index-100)*kDeviceWidth, 0)];
        }];
    }];
    [selectedView initwithArray:@[@"健康提醒",@"系统消息"]];
    self.navigationItem.titleView = selectedView;
    
    m_healthBox = [[BoxListTableView alloc]init];
    m_healthBox.log_pageID = 39;

    m_healthBox.m_mail = HEALTH_REMIND;
    m_healthBox.view.frame = CGRectMake(0, 0, m_scroll.width, m_scroll.height);
    [m_scroll addSubview:m_healthBox.view];
    
    m_systemBox = [[BoxListTableView alloc]init];
    m_systemBox.m_mail = SYSTEM_MESSAGE;
    m_systemBox.log_pageID = 40;
    m_systemBox.view.frame = CGRectMake(kDeviceWidth, 0, m_scroll.width, m_scroll.height);
    [m_scroll addSubview:m_systemBox.view];
    g_nowUserInfo.broadcastNotReadNum = 0;

}

- (void)butEventClear
{
    NSString * text = @"健康提醒";
    if (m_index) {
        text = @"系统消息";
    }
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"确定清空%@吗?",text] message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [av show];
    [av release];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        int tem = 1;
        if (m_index) {
            tem = 0;
        }
        g_nowUserInfo.broadcastNotReadNum = 0;
        [[DBOperate shareInstance] ClearMegToDBType:tem];
        [Common MBProgressTishi:@"清空成功" forHeight:kDeviceHeight];
        if (m_index) {
            [m_systemBox removeData];
        }else{
            [m_healthBox removeData];
        }
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int T = (int)scrollView.contentOffset.x/kDeviceWidth;
    if (m_index!=T) {
        [selectedView setChooseView];
    }
}
@end
