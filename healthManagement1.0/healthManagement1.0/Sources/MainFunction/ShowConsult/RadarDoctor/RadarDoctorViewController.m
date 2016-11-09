//
//  RadarDoctorViewController.m
//  jiuhaohealth4.0
//
//  Created by xjs on 15/5/12.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "RadarDoctorViewController.h"
#import "RadarDoctorList.h"
#import "LookingDoctorViewController.h"


#define LINE_LEFT kDeviceWidth/6
@interface RadarDoctorViewController ()<UIScrollViewDelegate>

@end

@implementation RadarDoctorViewController
{
    UIScrollView*m_scrollView;
    NSArray *m_viewArray;
    UIView * m_redView;
    
}

- (void)dealloc{
    [m_redView release];
    [m_scrollView release];
    
    for (id object in m_viewArray) {
        [object release];
    }
    [m_viewArray release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenNavigationBarLine];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"雷达推荐";
    NSArray *titleArray = @[@"医生",@"糖友"];

    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 36)];
    view.backgroundColor = [CommonImage colorWithHexString:Color_fafafa];
    [self.view addSubview:view];
    
    UIView * lineView  = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-0.25,kDeviceWidth, 0.5)];
    lineView.backgroundColor =  [CommonImage colorWithHexString:LINE_COLOR];
    [view addSubview:lineView];
    [lineView release];

    m_redView = [[UIView alloc]initWithFrame:CGRectMake(LINE_LEFT, view.bottom-2, kDeviceWidth/6, 2)];
    m_redView.backgroundColor = [CommonImage colorWithHexString:VERSION_TEXT_COLOR];
    [self.view addSubview:m_redView];
    
    UIButton * btn;
    for (int i = 0; i<2; i++) {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*kDeviceWidth/2, 0, kDeviceWidth/2, view.height-2);
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [btn setTitleColor:[CommonImage colorWithHexString:VERSION_TEXT_COLOR] forState:UIControlStateSelected];
        if (!i) {
            btn.selected = YES;
        }
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(setDocAndSugar:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    
    m_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, view.bottom, kDeviceWidth, kDeviceHeight-view.bottom)];
    m_scrollView.delegate = self;
    m_scrollView.backgroundColor = [UIColor clearColor];
    m_scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:m_scrollView];
    m_scrollView.contentSize = CGSizeMake(kDeviceWidth*2, 0);
    m_scrollView.pagingEnabled = YES;
    m_scrollView.bounces = NO;
    
    LookingDoctorViewController * Looking = [[LookingDoctorViewController alloc]init];
    //    radar.type = 2;
    Looking.view.frame = CGRectMake(0, 0, kDeviceWidth, m_scrollView.height);
    [m_scrollView addSubview:Looking.view];
    
    RadarDoctorList * radar = [[RadarDoctorList alloc]init];
    radar.type = 1;
    radar.view.frame = CGRectMake(kDeviceWidth, 0, kDeviceWidth, m_scrollView.height);
    [m_scrollView addSubview:radar.view];


    m_viewArray = [@[Looking,radar] retain];
    // Do any additional setup after loading the view.
}

- (void)setDocAndSugar:(UIButton*)seg
{
//    if (seg.selected) {
//        return;
//    }
    UIButton * btn;
    if (seg.tag == 100) {
        btn = (UIButton*)[self.view viewWithTag:seg.tag+1];
    }else{
        btn = (UIButton*)[self.view viewWithTag:seg.tag-1];
    }
    btn.selected = NO;
    seg.selected = YES;

    m_scrollView.contentOffset = CGPointMake(seg.frame.origin.x*2, 0);

    [UIView animateWithDuration:0.3 animations:^{
        m_redView.frame = [Common rectWithOrigin:m_redView.frame x:seg.origin.x+LINE_LEFT y:0];
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.3 animations:^{
        m_redView.frame = [Common rectWithOrigin:m_redView.frame x:scrollView.contentOffset.x/2+LINE_LEFT y:0];
    }];

    UIButton * btn,*seg;
    if (!scrollView.contentOffset.x) {
        btn = (UIButton*)[self.view viewWithTag:101];
        btn.selected = NO;
        seg = (UIButton*)[self.view viewWithTag:100];
        seg.selected = YES;

    }else{
        btn = (UIButton*)[self.view viewWithTag:101];
        btn.selected = YES;
        seg = (UIButton*)[self.view viewWithTag:100];
        seg.selected = NO;
    }

    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

//- (void)segmented:(UISegmentedControl*)seg
//{
//    [UIView animateWithDuration:0.3f animations:^{
//        m_scrollView.contentOffset = CGPointMake(seg.selectedSegmentIndex*kDeviceWidth, 0);
//    }];
//}

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
