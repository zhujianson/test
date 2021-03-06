//
//  RedPacketViewController.m
//  jiuhaohealth4.2
//
//  Created by jiuhao-yangshuo on 15/12/11.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "RedPacketViewController.h"
#import "KXSlideView.h"
#import "RedPacketDetailViewController.h"

@interface RedPacketViewController ()<SlideViewDelegate>
{
    KXSlideView *slideView;
    NSArray *viewArray;
}
@end

@implementation RedPacketViewController
@synthesize pageIndex;

-(id)init
{
    self = [super init];
    if (self)
    {
        pageIndex = 0;
    }
    return self;
}

-(void)dealloc
{
    NSLog(@"dealloc---RedPacketViewController");
    slideView.delegate = nil;
    if(viewArray)
    {
        [viewArray release];
        viewArray = nil;
    }
    [super dealloc];
}

- (BOOL)closeNowView
{
    for (CommonViewController *vc in viewArray)
    {
        [g_winDic removeObjectForKey:[NSString stringWithFormat:@"%x", (unsigned int)vc]];
    }
    return [super closeNowView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"红包";
    
    [self getViewArray];
    NSArray *titleArray = @[@"未使用",@"已过期",@"已使用"];
    
    slideView =  [[KXSlideView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) titleScrollViewFrame:
                  CGRectMake(0, 0, kDeviceWidth, 40)];
    slideView.delegate = self;
    slideView.theSlideType = NormalType;
    slideView.itemWidth = kDeviceWidth/titleArray.count;
    slideView.width_titleBackImageView = slideView.itemWidth;
    [slideView setTitleArray:titleArray SourcesArray:viewArray SetDefault:pageIndex];
    [self.view addSubview:slideView];
    [slideView release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self hiddenNavigationBarLine];
}

- (void)getViewArray
{
    RedPacketDetailViewController *post = [[RedPacketDetailViewController alloc] init];
    post.m_redPacketUseType = RedPacketUseTypeNoUse;
    
    RedPacketDetailViewController *hpvc = [[RedPacketDetailViewController alloc] init];
    hpvc.m_redPacketUseType = RedPacketUseTypeExpire;
    
    RedPacketDetailViewController *collection = [[RedPacketDetailViewController alloc] init];
    collection.m_redPacketUseType = RedPacketUseTypeUse;
    viewArray = [@[post,hpvc,collection] retain];
    [post release];
    [hpvc release];
    [collection release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -slideViewDelegate
- (void)selPageScrollView:(int)page
{
    NSLog(@"---page:%d,comefromDailyPageFlag",page);
    RedPacketDetailViewController *hpvc = viewArray[page];
    if (!hpvc.isShow)
    {
        [hpvc getDataSource];
    }
}

@end
