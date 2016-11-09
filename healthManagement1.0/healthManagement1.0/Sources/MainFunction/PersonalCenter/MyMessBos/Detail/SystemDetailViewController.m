//
//  SystemDetailViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-17.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "SystemDetailViewController.h"

@interface SystemDetailViewController ()

@end

@implementation SystemDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"系统信息";
    }
    return self;
}

- (void)dealloc
{
    self.contentDic = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getHeadView];
    [self getContentView];
    
}

- (void)getHeadView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 105)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    [headView release];
    //题目
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, kDeviceWidth-40, 16)];
    titleLabel.text = [NSString stringWithFormat:@"题目:%@",self.contentDic[@"title"]];
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [headView addSubview:titleLabel];
    [titleLabel release];
    //发件人
    UILabel *sendLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, kDeviceWidth-40, 15)];
    sendLabel.text = [NSString stringWithFormat:@"发件人:%@",self.contentDic[@"createUserName"]];
    sendLabel.textColor = [CommonImage colorWithHexString:@"666666"];
    sendLabel.font = [UIFont systemFontOfSize:14.0f];
    [headView addSubview:sendLabel];
    [sendLabel release];
    //发送时间
    UILabel *sendTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, kDeviceWidth-40, 15)];
    sendTimeLabel.text = [NSString stringWithFormat:@"发送时间:%@", [CommonDate getServerTime:(long)([self.contentDic[@"createTime"] longLongValue]/1000) type:11]];
    sendTimeLabel.textColor = [CommonImage colorWithHexString:@"666666"];
    sendTimeLabel.font = [UIFont systemFontOfSize:14.0f];
    [headView addSubview:sendTimeLabel];
    [sendTimeLabel release];
    
    UIView *viewXian = [[UIView alloc] initWithFrame:CGRectMake(0, 105, kDeviceWidth, 0.5)];
    viewXian.backgroundColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
//    viewXian.alpha = 0.3;
    [headView addSubview:viewXian];
    [viewXian release];
}

- (void)getContentView
{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 105, kDeviceWidth, SCREEN_HEIGHT-44-125)];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    [scrollView release];
    
    NSString *contentString = self.contentDic[@"content"];
    CGFloat height = [Common heightForString:contentString Width:kDeviceWidth-40 Font:[UIFont systemFontOfSize:14]].height;
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, kDeviceWidth-40, height)];
    contentLabel.textColor = [CommonImage colorWithHexString:@"333333"];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:contentLabel];
    [contentLabel release];
    
    scrollView.contentSize = CGSizeMake(kDeviceWidth, height +40);
    contentLabel.text = contentString;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
