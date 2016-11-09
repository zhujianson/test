//
//  ThinViewController.m
//  jiuhaohealth4.2
//
//  Created by xjs on 16/6/1.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "ThinViewController.h"
#import "DrawLineView.h"
#import "EnterWeightView.h"
#import "ThinPlanView.h"
#import "ThinViewPlanViewController.h"
#import "CycleViewController.h"
#import "ThinViewPlanViewController.h"
#import "ThinPersonalViewController.h"


@interface ThinViewController ()
{
    UIScrollView *m_scrollView;
    
    UIView *m_stateView; //我的状态
    UIView *m_chartView; //图标
    UIView *m_bateView; //
}

@property (nonatomic, strong) ThinPlanView *m_thinPlanView;
@property (nonatomic, strong) NSMutableDictionary *m_dicInfo;
@property (nonatomic, copy) NSString *m_currentTargetWeight;//当前周目标体重
@end

@implementation ThinViewController
@synthesize m_dicInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"享瘦派";
    self.log_pageID = 18;

    self.navigationItem.rightBarButtonItem = [Common CreateNavBarButton3:self setEvent:@selector(again) setTitle:@"重新定制"];
    
    m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    m_scrollView.backgroundColor = [CommonImage colorWithHexString:@"f2f2f2"];
    [self.view addSubview:m_scrollView];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(0, kDeviceHeight-50, kDeviceWidth, 50);
    [but setTitle:@"进入享瘦任务" forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:18];
    UIImage *image = [CommonImage createImageWithColor:[CommonImage colorWithHexString:The_ThemeColor]];
    [but setBackgroundImage:image forState:UIControlStateNormal];
    [but addTarget:self action:@selector(gotoPlanDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refleshThin" object:nil];
    
    [self getDataForServer];
//    [self getMyInfo];
}

-(NSString *)m_currentTargetWeight
{
    // 获取当前周目标体重
    float currentWight =  [m_dicInfo[@"current_weight"] floatValue]-0.5;
//    NSDictionary *chartDto = m_dicInfo[@"chartDto"];
//    NSMutableArray *nowArray = chartDto[@"ideal_list_strengthening"];
//    currentWeek = MIN(currentWeek, nowArray.count-1);
//    _m_currentTargetWeight = nowArray[currentWeek];
    _m_currentTargetWeight = [@(currentWight) stringValue];
    return _m_currentTargetWeight;
}

- (BOOL)closeNowView
{
    [super closeNowView];
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

- (void)getMyInfo
{
    if (!g_nowUserInfo.m_sex) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [[CommonHttpRequest defaultInstance] sendNewPostRequest:URL_GETINFO values:dic requestKey:URL_GETINFO delegate:self controller:self actiViewFlag:0 title:nil];
    }

}
- (void)getDataForServer
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:<#(nonnull id)#> forKey:<#(nonnull id<NSCopying>)#>]
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:URL_get_reduce_chart_home_msg values:dic requestKey:URL_get_reduce_chart_home_msg delegate:self controller:self actiViewFlag:1 title:nil];
}

- (void)createView
{
    m_stateView = [self createHeaderView];
    [m_scrollView addSubview:m_stateView];
    
    m_chartView = [self getChatView];
    [m_scrollView addSubview:m_chartView];
    
    m_bateView = [self createBateData];
    [m_scrollView addSubview:m_bateView];
    
    // Do any additional setup after loading the view.
    
    //    self.m_thinPlanView.top = 0;
    WSS(weakSelf);
    [self.m_thinPlanView setThinPlanViewBlock:^(id content){
        NSLog(@"点击事件");
        [weakSelf pushCycleView];
    }];
}

- (void)pushCycleView
{
    CycleViewController * cyc = [[CycleViewController alloc]init];
    [self.navigationController pushViewController:cyc animated:YES];
}

- (void)gotoPlanDetail
{
    NSArray *array = self.navigationController.viewControllers;
    for (id vc in array) {
        if ([vc isKindOfClass:[ThinViewPlanViewController class]]) {
            
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    ThinViewPlanViewController * plan = [[ThinViewPlanViewController alloc] init];
    plan.m_week = m_dicInfo[@"weeks"];
    //    plan.m_weekTargetWeight = self.m_currentTargetWeight;
    [self.navigationController pushViewController:plan animated:YES];

}

- (UIView *)m_thinPlanView
{
    if (_m_thinPlanView) {
        return _m_thinPlanView;
    }
    self.log_pageID = 19;

    _m_thinPlanView = [[ThinPlanView alloc] initWithFrame:CGRectMake(0, m_bateView.bottom+8, kDeviceWidth, 30)];
    _m_thinPlanView.infoDict = m_dicInfo;
    [m_scrollView addSubview:_m_thinPlanView];
    
    m_scrollView.contentSize = CGSizeMake(kDeviceWidth, _m_thinPlanView.bottom+58);
    return _m_thinPlanView;
}

- (void)again
{
    ThinPersonalViewController * thin = [[ThinPersonalViewController alloc]init];
    [self.navigationController pushViewController:thin animated:YES];
}

- (UIView*)createHeaderView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 125)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel * lab = [Common createLabel:CGRectMake(15, 0, 200, 40) TextColor:@"666666" Font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft labTitle:@"Hey，朋友，看这里！"];
    [view addSubview:lab];
    
    lab = [Common createLabel:CGRectMake(15, 40, kDeviceWidth-30, 60) TextColor:@"333333" Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentCenter labTitle:nil];
    float fwidth = [m_dicInfo[@"current_weight"] floatValue] - [m_dicInfo[@"target_kg"] floatValue];
    
    NSString *day = m_dicInfo[@"surplus_days"];
    NSString *title;
    if (fwidth <= 0) {
        title = [NSString stringWithFormat:@"崭新的自己已到来，继续保持哦！"];
        lab.attributedText = [Common replaceWithNSString:title andUseKeyWord:day andWithFont:[UIFont fontWithName:@"Arial-BoldMT" size:18] TextColor:@"00c5ff"];
    }
    else {
        NSString *width = [NSString stringWithFormat:@"%.1f", fwidth];
        NSString *title = [NSString stringWithFormat:@"减掉 %@ 公斤你就是享瘦派！\n坚持 %@ 天，遇见崭新的自己！", width, day];
        lab.attributedText = [self replaceRedColorWithNSString:title andUseKeyWord:width andWithFontSize:[UIFont fontWithName:@"Arial-BoldMT" size:18] TextColor:@"ff5232" andThreeNSString:day andThreeColor:@"00c5ff"];
    }
    
    lab.numberOfLines = 0;
    lab.backgroundColor =[CommonImage colorWithHexString:@"fafafa"];
    lab.layer.borderWidth = 0.5;
    lab.clipsToBounds = YES;
    lab.layer.cornerRadius = 4;
    lab.layer.borderColor = [CommonImage colorWithHexString:LINE_COLOR].CGColor;
    [view addSubview:lab];
    
    return view;
}

//描红
- (NSMutableAttributedString *)replaceRedColorWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(UIFont *)font TextColor:(NSString*)coler andThreeNSString:(NSString*)three andThreeColor:(NSString*)tColor
{
    NSMutableAttributedString *attrituteString = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:coler], NSFontAttributeName : font} range:range];
    
    NSRange range2 = [str rangeOfString:three];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:tColor], NSFontAttributeName : font} range:range2];
    return attrituteString;
}


/**
 *  获得图标数据
 */
- (UIView*)getChatView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, m_stateView.bottom+8, kDeviceWidth, 290)];
    view.backgroundColor = [UIColor whiteColor];
     
    //
    UIView *headeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 50)];
    [view addSubview:headeView];
    
    UILabel *labTitle = [Common createLabel];
    labTitle.frame = CGRectMake(15, 0, headeView.width, headeView.height);
    labTitle.font = [UIFont systemFontOfSize:16];
    labTitle.text = [NSString stringWithFormat:@"当前体重: %@kg", m_dicInfo[@"current_weight"]];
    labTitle.textColor = [CommonImage colorWithHexString:@"333333"];
    [headeView addSubview:labTitle];
    
    UILabel *labWidthState = [Common createLabel];
    labWidthState.frame = CGRectMake(headeView.width - 60, 14, 45, 20);
    labWidthState.font = [UIFont systemFontOfSize:13];
    labWidthState.layer.cornerRadius = 2;
    labWidthState.textAlignment = NSTextAlignmentCenter;
    labWidthState.clipsToBounds = YES;
    labWidthState.text = [CommonUser getColorForTizhong2:m_dicInfo[@"weight_state"]];
    labWidthState.textColor = [CommonImage colorWithHexString:@"ffffff"];
    labWidthState.backgroundColor = [CommonImage colorWithHexString:[CommonUser getColorForTizhong:m_dicInfo[@"weight_state"]]];
    [headeView addSubview:labWidthState];
    
    UIView *line = [Common getHLineForY:50];
    [headeView addSubview:line];
    
    UILabel *labHT = [Common createLabel];
    labHT.frame = CGRectMake(15, headeView.bottom+ 10, 100, 20);
    labHT.text = @"目标体重趋势";
    labHT.font = [UIFont systemFontOfSize:14];
    labHT.textColor = [CommonImage colorWithHexString:@"666666"];
    [view addSubview:labHT];
    
    UIImageView *imageDV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common.bundle/thin/tudibao.jpg"]];
    imageDV.frame = CGRectMake(kDeviceWidth - 130, headeView.bottom+10, 120, 20);
    imageDV.contentMode = UIViewContentModeRight;
    imageDV.clipsToBounds = YES;
    [view addSubview:imageDV];
    
    //图表
    DrawLineView *drawLineView = [[DrawLineView alloc] initWithFrame:CGRectMake(0, headeView.bottom-10, kDeviceWidth, 240)];
    drawLineView.tag = 888;
//    drawLineView.currentTimeType = OneDayType;//设置类型
    drawLineView.backgroundColor = [UIColor clearColor];
    drawLineView.m_strType = @"享瘦派";
//    drawLineView.isNewSugarTrend = YES;
    drawLineView.isThin = YES;
    [view addSubview:drawLineView];
    
    NSArray *array = [NSArray array];
    NSMutableArray *chartArray = [NSMutableArray array];
    NSMutableArray *dateArray = [NSMutableArray array];
    
    NSDictionary *chartDto = m_dicInfo[@"chartDto"];
    NSMutableArray *nowArray = chartDto[@"history_weight_list"];
    
    for (NSString *value in chartDto[@"ideal_list_preparation"]) {
        [chartArray addObject:value];
        [dateArray addObject:@"准备瘦"];
    }
    
    for (NSString *value in chartDto[@"ideal_list_strengthening"]) {
        [chartArray addObject:value];
        [dateArray addObject:@"正在瘦"];
    }
    
    for (NSString *value in chartDto[@"ideal_list_consolidation"]) {
        [chartArray addObject:value];
        [dateArray addObject:@"一直瘦"];
    }
    
    int count = (int)chartArray.count - (int)nowArray.count;
    if (count > 0) {
        for (int i = 0; i < count; i++) {
            [nowArray addObject:@"0"];
        }
    }
    else {
        for (int i = 0; i > count; i--) {
            [chartArray addObject:@"0"];
        }
    }
    
//    dateArray = @[@"准备期",@"准备期",@"准备期",@"强化期",@"强化期",@"强化期",@"巩固期",@"巩固期",@"巩固期"];
    
    array = @[chartArray, nowArray];
    NSString *initial_value = [NSString stringWithFormat:@"%.1f", [chartDto[@"initial_value"] floatValue]];
    NSString *target_value = [NSString stringWithFormat:@"%.1f",[chartDto[@"target_value"] floatValue]];
    [drawLineView setLineDataArray:array andTimeArray:dateArray normalValueArray:@[@[chartDto[@"initial_value"], chartDto[@"target_value"]]] lineMeansArray:nil  aboutMultiLocaInOriginalArray:nil];

    return view;
}

- (UIView*)createBateData
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, m_chartView.bottom+8, kDeviceWidth, 223)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel * lab = [Common createLabel:CGRectMake(15, 0, 200, 43) TextColor:@"666666" Font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft labTitle:@"基础数据"];
    [view addSubview:lab];
    
    float width = (kDeviceWidth-40)/2.f;
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    [dic1 setObject:@"BMI" forKey:@"title2"];
    [dic1 setObject:m_dicInfo[@"base_bmi"] forKey:@"title"];
    [dic1 setObject:@"2bd45b" forKey:@"color"];
    [dic1 setObject:@"e9fbee" forKey:@"color2"];
    
    UILabel *labLeft = [self createItem:CGRectMake(15, lab.bottom, width, 85) withDic:dic1];
    [view addSubview:labLeft];

    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    [dic2 setObject:@"体脂%" forKey:@"title2"];
    [dic2 setObject:m_dicInfo[@"constitution"] forKey:@"title"];
    [dic2 setObject:@"00c5ff" forKey:@"color"];
    [dic2 setObject:@"e5f9ff" forKey:@"color2"];
    
    UILabel *labRight = [self createItem:CGRectMake(labLeft.right + 10, lab.bottom, width, labLeft.height) withDic:dic2];
    [view addSubview:labRight];
    
    //
    UIImage *iamge = [[UIImage imageNamed:@"common.bundle/thin/beijing.png"] stretchableImageWithLeftCapWidth:65 topCapHeight:30];
    UIImageView *imageV = [[UIImageView alloc] initWithImage:iamge];
    imageV.frame = CGRectMake(15, labRight.bottom+10, kDeviceWidth-30, 60);
    [view addSubview:imageV];
    
    UIImageView *imageDV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common.bundle/thin/dengpao.png"]];
    imageDV.frame = CGRectMake(0, 0, 60, 60);
    imageDV.contentMode = UIViewContentModeCenter;
    [imageV addSubview:imageDV];
    
    UILabel *labTitle = [Common createLabel];
    labTitle.frame = CGRectMake(imageDV.right, 10, imageV.width-imageDV.right-20, 40);
    labTitle.font = [UIFont systemFontOfSize:14];
    labTitle.textColor = [CommonImage colorWithHexString:@"333333"];
    labTitle.numberOfLines = 0;
    labTitle.text = m_dicInfo[@"base_prompt_text"];//@"BMI是指身体质量指数，是衡量是否肥胖喝标准体重的重要指标。";
    [imageV addSubview:labTitle];
    
    float height = [Common sizeForAllString:labTitle.text andUIFont:labTitle.font andWight:labTitle.width].height+20;
    labTitle.height = height;
    imageV.height = height+20;
    imageDV.height = imageV.height;
    view.height = imageV.bottom + 25;
    
    return view;
}

- (UILabel*)createItem:(CGRect)frame withDic:(NSDictionary*)dic
{
    UILabel *labLeft = [Common createLabel];
    labLeft.frame = frame;
    labLeft.font = [UIFont systemFontOfSize:30 weight:0.2];
    labLeft.textAlignment = NSTextAlignmentCenter;
    labLeft.layer.cornerRadius = 3;
    labLeft.clipsToBounds = YES;
    labLeft.textColor = [CommonImage colorWithHexString:dic[@"color"]];
    labLeft.backgroundColor = [CommonImage colorWithHexString:dic[@"color2"]];
    labLeft.text = [NSString stringWithFormat:@"%.1f", [dic[@"title"] floatValue]];
    
    UILabel *labTop = [Common createLabel];
    labTop.frame = CGRectMake(15, 5, 50, 20);
    labTop.font = [UIFont systemFontOfSize:13];
    labTop.textColor = labLeft.textColor;
    labTop.text = dic[@"title2"];
    [labLeft addSubview:labTop];
    
    return labLeft;
}

- (void)didFinishSuccess:(ASIHTTPRequest*)loader
{
    NSString* responseString = [loader responseString];
    NSDictionary* dic = [responseString KXjSONValueObject];
    
    NSDictionary *head = dic[@"head"];
    if (![head[@"state"] intValue]) {
        if ([loader.username isEqualToString:URL_get_reduce_chart_home_msg])
        {
            self.m_dicInfo = dic[@"body"];
            
            [self createView];
//            private String surplus_days;//剩余天数
//            
//            private String target_kg;//目标公斤数
//            
//            private String current_weight;//当前体重
//            
//            private String weight_state;//当前体重状态
//            
//            private ChartDto chartDto;//图表（初始值，目标值，理想走势list，目标走势list）
//            
//            private String base_bmi;//基础bmi
//            
//            private String constitution;//体质
//            
//            private String base_prompt_text;//基础提示文字
//            
//            private String current_stage;//当前阶段
//            
//            private String current_prompt_text;//当前提示文字
//            
//            private String weeks;//第几周
        } 
    }
    else
    {
        [Common TipDialog2:head[@"msg"]];
    }
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    if ([loader.username isEqualToString:GETMYINFO_API_URL])
    {
        [g_nowUserInfo setMyBasicInformation:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_Info"]];
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
