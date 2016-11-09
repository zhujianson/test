//
//  MyStepCounterHistoryViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-11-28.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "MyStepCounterHistoryViewController.h"
#import "SelectedView.h"
#import "DrawLineView.h"
#import "StepUserInfoViewController.h"
#import "PickerView.h"
#import "ChartDataTableViewCell.h"
#import "AppDelegate.h"

static const CGFloat movieBackgroundPadding = 20.f;

@interface MyStepCounterHistoryViewController () <UITableViewDataSource,UITableViewDelegate>
{
    DrawLineView *drawLineView;
    UIView *myScrollView;
    NSTimer* timer;
    int index;
    
    TimeType currentTimeType;
    NSMutableDictionary *m_chartValueDic;
    int timeType;//时间类型 7天-4 30天-5 90天-6 最近-3 全部- -1
    UITableView *stepDetailTableView;
    UILabel *noDateLabel;
    
    UILabel *m_TheyLab;
    
    UIView *LandView;//横屏view
    UIView *m_moveBackgroundView;
    __block int selectedViewDefaultIndex;//选中默认
    
    __block UIView *blackView;
}

@property (nonatomic,retain) UIImageView *photoImageView;//头像
@property (nonatomic, retain) NSMutableArray* chartValueArray; //表格数据数组
@property (nonatomic, retain) NSMutableArray* dateArray; //日期数组
@property (nonatomic, retain) NSMutableArray* addChartValueArray;
@property (nonatomic, retain) NSMutableArray* addDateArray;

@property (nonatomic,retain) NSMutableArray *dataArray;

//@property (nonatomic, retain) UIView *moveBackgroundView;


@property (nonatomic,retain) NSArray *headKeyArray;//头信息数组

@end

@implementation MyStepCounterHistoryViewController

- (void)dealloc
{
    self.chartValueArray = nil;
    self.dateArray = nil;
    self.photoImageView = nil;
    self.addChartValueArray = nil;
    self.addDateArray = nil;
    if(stepDetailTableView){
        [stepDetailTableView release];
        stepDetailTableView = nil;
    }
    
    if(noDateLabel){
        [noDateLabel release];
        noDateLabel = nil;
    }
    self.dataArray = nil;
    
    self.headKeyArray = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"计步信息";
        
        m_chartValueDic = [[NSMutableDictionary alloc] init];
        
        self.dataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
         self.log_pageID = 117;
    }
    return self;
}

- (void)getMyInfo
{
    StepUserInfoViewController *memberInfotVC = [[StepUserInfoViewController alloc] init];
    memberInfotVC.userId =  g_nowUserInfo.userid;
    [self.navigationController pushViewController:memberInfotVC animated:YES];
    [memberInfotVC release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
    
    //日期分布
    SelectedView *selectedView = [[SelectedView alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 40)];
    selectedView.isSteperView = YES;
    selectedView.backgroundColor = self.view.backgroundColor;// [CommonImage colorWithHexString:Color_fafafa];
    [selectedView setSelectedBtnBlock:^(int aindex){
        selectedViewDefaultIndex = index;
        NSLog(@"----index:%d",aindex);
        if(aindex == 1){
            [self getDataSource:@"30"];
        }else if(aindex == 0){
             [self getDataSource:@"7"];
        }else {
             [self getDataSource:@"90"];
        }
        [self justSynLandSelectedView:index];
    }];
    NSArray *selectionArray = @[@"7天",@"30天",@"90天"];
    [selectedView initwithArray:selectionArray];
    [self.view addSubview:selectedView];
    [selectedView release];
    
    UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5,kDeviceWidth, 0.5)];
    lineView.backgroundColor =  [CommonImage colorWithHexString:@"dcdcdc"];
    [selectedView addSubview:lineView];
    [lineView release];

    myScrollView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 210)];
    myScrollView.backgroundColor = [UIColor clearColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 200)];
    view.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:view];
    [view release];
//    [self.view addSubview:myScrollView];
//    [myScrollView release];
    //计步图表
    [self getChartView];
    
    self.chartValueArray = [NSMutableArray arrayWithObjects:@[ @"0", @"0"], nil];
    self.dateArray = [NSMutableArray arrayWithObjects:@"", @"", nil];
    [self reloadChartView];

    
    //步数统计列表
    self.headKeyArray = @[@"日期",@"步数",@"里程",@"卡路里"];
    stepDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, selectedView.bottom, kDeviceWidth, kDeviceHeight - selectedView.bottom) style:UITableViewStyleGrouped];
    stepDetailTableView.backgroundColor = self.view.backgroundColor;
    stepDetailTableView.dataSource = self;
    stepDetailTableView.delegate = self;
    stepDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:stepDetailTableView];
    stepDetailTableView.tableHeaderView = myScrollView;
    [myScrollView release];
    
    [Common setExtraCellLineHidden:stepDetailTableView];
    
    noDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, myScrollView.size.height+ 40, kDeviceWidth, 40)];
    noDateLabel.backgroundColor = [UIColor clearColor];
    noDateLabel.textAlignment = NSTextAlignmentCenter;
    noDateLabel.textColor = [CommonImage colorWithHexString:@"666666"];
    noDateLabel.text = @"暂无数据";
    [stepDetailTableView addSubview:noDateLabel];
    noDateLabel.alpha = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performSelector:@selector(hiddenNavigationBarLine) withObject:nil afterDelay:0];

}

//- (void)hiddenNavigationBarLine
//{
//    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
//        
//        NSArray *list = self.navigationController.navigationBar.subviews;
//        
//        for (id obj in list) {
//            
//            if ([obj isKindOfClass:[UIImageView class]]) {
//                
//                UIImageView *imageView=(UIImageView *)obj;
//                
//                NSArray *list2=imageView.subviews;
//                
//                for (id obj2 in list2) {
//                    
//                    if ([obj2 isKindOfClass:[UIImageView class]]) {
//                        
//                        UIImageView *imageView2=(UIImageView *)obj2;
//                        
//                        imageView2.hidden=YES;
//                    }
//                }
//            }
//        }
//    }
//}

#pragma mark -- UITableViewDataSource And Delegate
//Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//获取数据条数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    float height = 10;
//    if (section == m_array.count-1) {
//        return height = 10;
//    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSLog(@"keyarray:%@",self.headKeyArray);

    CGFloat itemWidth = kDeviceWidth/self.headKeyArray.count;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0.5)];
    topLineView.backgroundColor = [CommonImage colorWithHexString:@"e5e5e5"];
    [headView addSubview:topLineView];
    [topLineView release];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, kDeviceWidth, 0.5)];
    lineView.backgroundColor = [CommonImage colorWithHexString:@"e5e5e5"];
    [headView addSubview:lineView];
    [lineView release];
    for (int i = 0; i < self.headKeyArray.count; i++) {
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*itemWidth, 0, itemWidth, 40)];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont systemFontOfSize:15.0f];
        contentLabel.textColor = [CommonImage colorWithHexString:@"999999"];
        contentLabel.text = self.headKeyArray[i];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        [headView addSubview:contentLabel];
        [contentLabel release];
    }
    return [headView autorelease];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"chartDataCell";
    
    
    ChartDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[[ChartDataTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellWidth = kDeviceWidth;
        cell.numberOfRowInOneCell = 4;
        cell.numberOfOneCell = 1;
        [cell healthStepDataView];
    }
    
    NSString *key = self.dateArray[indexPath.row];
    NSArray *valuesArray = [NSArray arrayWithObjects:self.dataArray[indexPath.row], nil];
    
    NSLog(@"key:%@---valuesArray:%@",key,valuesArray);
    cell.numberOfOneCell = 4;
    cell.numberOfRowInOneCell = (int)valuesArray.count;
    [cell setStepKey:key valueArray:valuesArray];
    if(indexPath.row%2 == 1){
        cell.contentView.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];
    }else{
        cell.contentView.backgroundColor = [CommonImage colorWithHexString:@"f8f8f8"];
    }
    
    return cell;
}

//根据日期获得计步数据
- (void)getDataSource:(NSString *)day
{
        NSMutableDictionary *requestDic =  [[NSMutableDictionary alloc] initWithCapacity:0];
//        [requestDic setValue:g_nowUserInfo.userid forKey:@"uid"];
        [requestDic setValue:day forKey:@"days"];
        
        [[CommonHttpRequest defaultInstance] sendNewPostRequest:GetPedometerItem values:requestDic requestKey:GetPedometerItem  delegate:self controller:self actiViewFlag:1 title:nil];
        [requestDic release];
}

//获取数据接口
- (void)getDataSource
{
    
    NSMutableDictionary *requestDic =  [[NSMutableDictionary alloc] initWithCapacity:0];
    [requestDic setValue:@"1" forKey:@"pageNo"];
    [requestDic setValue:@"1000" forKey:@"pageSize"];
    [requestDic setValue:g_nowUserInfo.userid forKey:@"userid"];
    [requestDic setObject:[NSString stringWithFormat:@"%d",0] forKey:@"type"];//用户类型
    [requestDic setObject:[NSString stringWithFormat:@"%d",timeType] forKey:@"timetype"];//时间类型
    [requestDic setObject:@"CD00010003" forKey:@"dataType"];
    
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GetDiaryHistory values:requestDic requestKey:GetDiaryHistory  delegate:self controller:self actiViewFlag:1 title:nil];
    [requestDic release];
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    if ([dic[@"head"][@"state"] isEqualToString:@"0000"])
    {
        NSDictionary *bodyDic = dic[@"body"];

        if ([loader.username isEqualToString:GetPedometerItem]){
            NSDictionary *dataDic = bodyDic[@"data"];
            NSArray *resultArray = dataDic[@"resultSet"];
            
            NSString *aveStepCnt= dataDic[@"avgStepCnt"];
            NSString *sumStepCnt = dataDic[@"sumStepCnt"];
            
            UILabel *aveLabel = (UILabel *)[myScrollView viewWithTag:111];
            aveLabel.attributedText = [self replaceWithNSString:[NSString stringWithFormat:@"平均步数:%@步      总计步数:%@步",aveStepCnt,sumStepCnt] andUseKeyWord:aveStepCnt andWithFontSize:12 keywordColor:COLOR_FF5351 andText:sumStepCnt];
            
            if(resultArray.count == 0){
            
                self.chartValueArray = [NSMutableArray arrayWithObjects:@[ @"0", @"0"], nil];
                self.dateArray = [NSMutableArray arrayWithObjects:@"", @"", nil];
                [self reloadChartView];
                [self.dataArray removeAllObjects];
                [stepDetailTableView reloadData];
                [UIView animateWithDuration:1 animations:^{
                    noDateLabel.alpha = 1;
                }];
                return;
            }
            
            noDateLabel.alpha = 0;
            self.chartValueArray = [NSMutableArray arrayWithCapacity:0];//[NSMutableArray arrayWithObjects:@[ @"12", @"224",@"102", @"1224",@"12", @"24",@"12", @"24",@"12", @"24",@"12", @"24" ], nil];
            self.dateArray = [NSMutableArray arrayWithCapacity:0];
            [self.dataArray removeAllObjects];
            NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:0];
            for(NSDictionary *measDic in resultArray){
                
                NSString *stepCount = measDic[@"realStepCnt"];
                if(stepCount.intValue == 0){
                    continue;
                }
                
                [valueArray addObject:measDic[@"realStepCnt"]];
                
                NSString *measureDate = measDic[@"measuringDate"];
                
                [self.dateArray addObject:[measureDate substringFromIndex:5]];
                [self.dataArray addObject:[NSString stringWithFormat:@"%@|%.2f|%.0f",measDic[@"realStepCnt"],[measDic[@"distance"] floatValue]/1000,[measDic[@"kilCalorie"] floatValue]]];
            }
            [self.chartValueArray addObject:valueArray];
            if(valueArray.count == 0){
                [UIView animateWithDuration:1 animations:^{
                    noDateLabel.alpha = 1;
                }];
            }
            [self reloadChartView];
            [stepDetailTableView reloadData];
        
    }else {
        
        
        }
    }
}


/**
 *  计步器图标绘制
 */
- (void)getChartView
{
    drawLineView = [[DrawLineView alloc] initWithFrame:CGRectMake(10, -10, (kDeviceWidth-20), 200)];
    drawLineView.tag = 8887;
    drawLineView.currentTimeType = OneDayType; //设置类型
    drawLineView.backgroundColor = [UIColor clearColor];
    drawLineView.isYClipTo5 = YES;
    self.chartValueArray = [NSMutableArray arrayWithObjects:@[ @"12", @"24" ], nil];
    self.dateArray = [NSMutableArray arrayWithObjects:@"12", @"24", nil];
    self.chartValueArray = nil;
    self.dateArray = nil;
    [drawLineView setLineDataArray:self.chartValueArray andTimeArray:self.dateArray normalValueArray:@[ @[ [NSString stringWithFormat:@"%d", 1000], @"0" ] ] lineMeansArray:nil aboutMultiLocaInOriginalArray:nil];
    [myScrollView addSubview:drawLineView];
    [drawLineView release];
    

    UILabel * TheyLab = [Common createLabel:CGRectMake(40, 12, 230, 20) TextColor:@"666666" Font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft labTitle:nil];
//    TheyLab.backgroundColor = [UIColor redColor];
    TheyLab.tag = 111;
    TheyLab.attributedText = [self replaceWithNSString:[NSString stringWithFormat:@"平均步数:%@      总计步数:%@",@"111",@"222"] andUseKeyWord:@"111" andWithFontSize:12 keywordColor:COLOR_FF5351 andText:@"222"];
    [myScrollView addSubview:TheyLab];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kDeviceWidth-53, TheyLab.origin.y-2, 45, 25);
//    [btn setTitleColor:[CommonImage colorWithHexString:COLOR_FF5351] forState:UIControlStateNormal];
//    [btn setTitle:NSLocalizedString(@"横屏", nil) forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:13];
//    btn.layer.cornerRadius = 2;
//    btn.layer.borderWidth = 0.5;
//    btn.clipsToBounds = YES;
//    btn.layer.borderColor = [CommonImage colorWithHexString:COLOR_FF5351].CGColor;
    [btn setImage:[UIImage imageNamed:@"common.bundle/diary/V4.0/landView.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(butEventHengping:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:btn];
    
}


//描红
- (NSMutableAttributedString *)replaceWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )size keywordColor:(NSString *)colorString andText:(NSString*)key
{
    NSMutableAttributedString *attrituteString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
    if(!keyWord){
        return attrituteString;
    }
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:colorString], NSFontAttributeName : [UIFont systemFontOfSize:size]} range:range];
    range = [str rangeOfString:key];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:colorString], NSFontAttributeName : [UIFont systemFontOfSize:size]} range:range];

    return attrituteString;
}

/**
 *  重新加载图标
 */
- (void)reloadChartView
{
    index = 0;
    //    self.chartValueArray = [NSMutableArray arrayWithObjects:@[@"12",@"24"],nil];
    //    self.dateArray = [NSMutableArray arrayWithObjects:@"12",@"24",nil];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(addDataAnimation) userInfo:nil repeats:YES];
    
    self.addChartValueArray = [NSMutableArray arrayWithCapacity:0];
    self.addDateArray = [NSMutableArray arrayWithCapacity:0];
    
    //    drawLineView.backgroundColor = [UIColor clearColor];
    //    [drawLineView setLineDataArray:self.chartValueArray andTimeArray:self.dateArray normalValueArray:@[@[[NSString stringWithFormat:@"%d",50],@"0"]] lineMeansArray:nil aboutMultiLocaInOriginalArray:nil];
    //    [drawLineView reloadSubViews];
}

/**
 *  速度为0时 更新图标
 */
- (void)reloadChartViewWithNoAnimation
{
    drawLineView.backgroundColor = [UIColor clearColor];
    [drawLineView setLineDataArray:self.chartValueArray andTimeArray:self.dateArray normalValueArray:@[ @[ [NSString stringWithFormat:@"%d", 1000], @"0" ] ] lineMeansArray:nil aboutMultiLocaInOriginalArray:nil];
    [drawLineView reloadSubViews];
}

- (void)addDataAnimation
{
    if (index >= [(NSArray*)self.chartValueArray[0] count]) {
        
        return;
    }
    [self.addChartValueArray addObject:self.chartValueArray[0][index]];
    [self.addDateArray addObject:self.dateArray[index]];
    if (self.addChartValueArray.count == [self.chartValueArray[0] count]) {
        
        [timer invalidate];
        timer = nil;
    }
    drawLineView.backgroundColor = [UIColor clearColor];
    [drawLineView setLineDataArray:@[ self.addChartValueArray ] andTimeArray:self.addDateArray normalValueArray:@[ @[ [NSString stringWithFormat:@"%d", 1000], @"0" ] ] lineMeansArray:nil aboutMultiLocaInOriginalArray:nil];
    [drawLineView reloadSubViews];
    
    if (m_moveBackgroundView.alpha) {
        DrawLineView *drawLineView1 = (DrawLineView*)[LandView viewWithTag:8888];
        [drawLineView1 setLineDataArray:@[ self.addChartValueArray ] andTimeArray:self.addDateArray normalValueArray:@[ @[ [NSString stringWithFormat:@"%d", 1000], @"0" ] ] lineMeansArray:nil aboutMultiLocaInOriginalArray:nil];
        [drawLineView1 reloadSubViews];
    }
    index++;
}

- (void)butEventHengping:(UIButton*)but
{
    AppDelegate *myApp = [Common getAppDelegate];
    myApp.isShowAlertViewFlag = NO;
    
//    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    [self RotationWithOriention:UIInterfaceOrientationLandscapeRight];
}

#pragma mark - 横屏相关

/**
 *  获得横屏图表数据
 */
- (DrawLineView  *)getChatViewOFLandRight
{
    DrawLineView  *drawLineView1 = [[DrawLineView alloc] initWithFrame:CGRectMake(10, (kDeviceWidth-240)/2.0f+10 , SCREEN_HEIGHT-20, 240)];
    drawLineView1.tag = 8888;
    drawLineView1.currentTimeType = OneDayType;//设置类型
    drawLineView1.backgroundColor = [UIColor clearColor];
    drawLineView1.isYClipTo5 = YES;
    [drawLineView1 setLineDataArray:self.chartValueArray andTimeArray:self.dateArray normalValueArray:@[ @[ [NSString stringWithFormat:@"%d", 1000], @"0" ] ] lineMeansArray:nil aboutMultiLocaInOriginalArray:nil];
//    [myScrollView addSubview:drawLineView1];
    
    return [drawLineView1 autorelease];
}


//屏幕旋转出入需要的方向
- (void)RotationWithOriention:(UIInterfaceOrientation)orientation
{
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        {
            [self rotateMoviePlayerForOrientation:UIInterfaceOrientationPortrait animated:YES
                                       completion:^{
                                           NSLog(@"finish");
                                           [Common getAppDelegate].isLandView = NO;
                                           m_moveBackgroundView.alpha = 0;
                                           [blackView removeFromSuperview];
                                           blackView = nil;
                                       }];
            
        }
            break;
        case UIInterfaceOrientationLandscapeRight:
        {
            UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
            
            if (!m_moveBackgroundView) {
                m_moveBackgroundView = [[UIView alloc] init];
                m_moveBackgroundView.alpha = 0.f;
                [m_moveBackgroundView setBackgroundColor:[UIColor blackColor]];
                [m_moveBackgroundView addSubview:[self getLandRightView]];
                
                [keyWindow addSubview:m_moveBackgroundView];
            }
            
            if(!blackView){
                blackView = [[UIView alloc] initWithFrame:keyWindow.bounds];
                blackView.backgroundColor = [UIColor blackColor];
                [keyWindow insertSubview:blackView belowSubview:m_moveBackgroundView];
                [blackView release];
            }

                if (CGRectEqualToRect(m_moveBackgroundView.frame, CGRectZero)) {
                [m_moveBackgroundView setFrame:keyWindow.bounds];
            }
            m_moveBackgroundView.alpha = 1.f;
            [Common getAppDelegate].isLandView = YES;
            [self rotateMoviePlayerForOrientation:UIInterfaceOrientationLandscapeRight animated:YES
                                       completion:^{
                                           NSLog(@"finish");
                                       }];
            
        }
            break;
        default:
            break;
    }
}

- (CGFloat)statusBarHeightInOrientation:(UIInterfaceOrientation)orientation {
    if ([UIDevice iOSVersion] >= 7.0)
        return 0.f;
    else if ([UIApplication sharedApplication].statusBarHidden)
        return 0.f;
    return 20.f;
}

- (void)setFrame:(CGRect)frame {
    [LandView setFrame:frame];//要旋转的view设定frame
}

- (void)rotateMoviePlayerForOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated completion:(void (^)(void))completion {
    CGFloat angle = 0.0;
    CGSize windowSize = [UIApplication sizeInOrientation:orientation];
    CGRect backgroundFrame;
    CGRect movieFrame;
    switch (orientation) {

        case UIInterfaceOrientationLandscapeRight:
            
            angle = M_PI_2;
            backgroundFrame = CGRectMake(-movieBackgroundPadding, -movieBackgroundPadding, windowSize.height + movieBackgroundPadding*2, windowSize.width + movieBackgroundPadding*2);
            movieFrame = CGRectMake(movieBackgroundPadding, movieBackgroundPadding, backgroundFrame.size.height - movieBackgroundPadding*2, backgroundFrame.size.width - movieBackgroundPadding*2);
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            break;
            
        case UIInterfaceOrientationPortrait:
            
            angle = 0.f;
            backgroundFrame = CGRectMake(-movieBackgroundPadding, [self statusBarHeightInOrientation:orientation] - movieBackgroundPadding, windowSize.width + movieBackgroundPadding*2, windowSize.height + movieBackgroundPadding*2);
            movieFrame = CGRectMake(movieBackgroundPadding, movieBackgroundPadding, backgroundFrame.size.width - movieBackgroundPadding*2, backgroundFrame.size.height - movieBackgroundPadding*2);
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            
            break;
        default:
            break;
    }
    
    
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            m_moveBackgroundView.transform = CGAffineTransformMakeRotation(angle);
            m_moveBackgroundView.frame = backgroundFrame;
            [self setFrame:movieFrame];
            [[UIApplication sharedApplication]setStatusBarOrientation:orientation animated:YES ];
        } completion:^(BOOL finished) {
            if (completion)
                completion();
        }];
    } else {
        m_moveBackgroundView.backgroundColor = [UIColor blackColor];
        m_moveBackgroundView.transform = CGAffineTransformMakeRotation(angle);
        m_moveBackgroundView.frame = backgroundFrame;
        [self setFrame:movieFrame];
        if (completion)
            completion();
    }
}


//获取横屏的View视图
- (UIView *)getLandRightView
{
    if(LandView){
        return LandView;
    }
    
    LandView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, SCREEN_HEIGHT)];
    LandView.backgroundColor = [UIColor whiteColor];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 10, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"common.bundle/nav/icon_back_normal.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"common.bundle/nav/icon_back_pressed.png"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backToPortrait) forControlEvents:UIControlEventTouchUpInside];
    [LandView addSubview:backBtn];
    
    //此处添加 时间选项卡 --- 关联下竖屏的UI效果
    SelectedView *selectedView = [[SelectedView alloc] initWithFrame:CGRectMake(50, 10, SCREEN_HEIGHT+20-50, 50)];
    selectedView.backgroundColor = [UIColor clearColor];
    
    selectedView.offsetX = (SCREEN_HEIGHT+20-75*3-15*3)/2.0f;
    selectedView.spaceWidth = 15;
    
    selectedView.theStyle = SingleStyle;
    __block BOOL initSelectedIndex = YES;
    
    [selectedView setSelectedBtnBlock:^(int index){
        if(initSelectedIndex){
            initSelectedIndex = NO;
            return;
        }
    
        [self justSynSelectedView:index];
        if(index == 1){
            [self getDataSource:@"30"];
        }else if(index == 0){
            [self getDataSource:@"7"];
        }else {
            [self getDataSource:@"90"];
        }
    }];
    NSArray *selectionArray = @[@"7天",@"30天",@"90天"];
    [selectedView initwithArray:selectionArray];
    selectedView.tag = 2345;
    [LandView addSubview:selectedView];
    [selectedView release];
    if(selectedViewDefaultIndex != 0){//非第一个时 默认同步选中
        [selectedView justShowSelectedViewAtIndex:selectedViewDefaultIndex];
    }
    
    //图表
    DrawLineView *landRightLineView = [self getChatViewOFLandRight];
    [LandView addSubview:landRightLineView];
    
    return LandView;
}

//同步横屏选中
- (void)justSynSelectedView:(int)index
{
    SelectedView *landSelectedView = (SelectedView *)[self.view viewWithTag:2345];
    [landSelectedView justShowSelectedViewAtIndex:index];
    
}

//同步竖屏选中
- (void)justSynLandSelectedView:(int)index
{
    SelectedView *landSelectedView = (SelectedView *)[LandView viewWithTag:2345];
    [landSelectedView justShowSelectedViewAtIndex:index];
}

//恢复到竖屏
- (void)backToPortrait
{
    AppDelegate *myApp = [Common getAppDelegate];
    myApp.isShowAlertViewFlag = YES;
    [self RotationWithOriention:UIInterfaceOrientationPortrait];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end