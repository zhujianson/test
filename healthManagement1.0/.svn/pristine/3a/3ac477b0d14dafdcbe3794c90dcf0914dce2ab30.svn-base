//
//  DoctorViewController.m
//  healthManagement1.0
//
//  Created by 徐国洪 on 16/1/19.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "DoctorViewController.h"
#import "HealthManagerViewController.h"
#import "DoctorListViewController.h"
#import "SelectedView.h"
@interface DoctorViewController ()
{
    HealthManagerViewController *m_healthManager;
    DoctorListViewController *m_doctorList;
}

@end

@implementation DoctorViewController
{
    SelectedView *selectedView;
    
}
- (id)init
{
    self = [super init];
    if (self) {
        [self createNavTitle];

    }
    return self;
}

- (void)dealloc
{
    m_healthManager = nil;
    m_doctorList = nil;
    selectedView = nil;
}

- (void)createNavTitle
{
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"健康管家", @"免费问诊", nil];
    //初始化UISegmentedControl
//    CGFloat w = 190*kDeviceWidth/375;
    
    selectedView = [[SelectedView alloc] initWithFrame:CGRectMake(0, 0, 190, 27)];
    selectedView.backgroundColor = [UIColor clearColor];
    selectedView.theStyle = SegmentStyle;
    //    selectedView.
    WSS(weak);
    [selectedView setSelectedBtnBlock:^(int index){
        [weak segmented:index-100];
    }];
    [selectedView initwithArray:segmentedArray];
    self.navigationItem.titleView = selectedView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_healthManager = [[HealthManagerViewController alloc] init];
    m_healthManager.m_superClass = self;
    [self.view addSubview:m_healthManager.view];
//    m_healthManager
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (m_healthManager) {
        [m_healthManager viewWillAppear:animated];
    }
    if (m_doctorList) {
        [m_doctorList viewWillAppear:animated];
    }
}

- (void)segmented:(int)index
{
    if (!m_doctorList) {
        m_doctorList = [[DoctorListViewController alloc] init];
        m_doctorList.m_superClass = self;
        m_doctorList.view.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight+64);
        [self.view addSubview:m_doctorList.view];
    }
    if (!index) {
        m_doctorList.view.hidden = YES;
        m_healthManager.view.hidden = NO;
    }else{
        m_doctorList.view.hidden = NO;
        m_healthManager.view.hidden = YES;
    }
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
