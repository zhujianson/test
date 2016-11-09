//
//  ThinViewPlanViewController.m
//  healthManagement1.0
//
//  Created by jiuhao-yangshuo on 16/6/3.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "ThinViewPlanViewController.h"
#import "WeekActivityView.h"
#import "ThinPlanViewCell.h"
#import "EnterWeightView.h"
#import "ThinPersonalViewController.h"
#import "ThinViewController.h"

static float const kHeaderHeight = 240/2.0;
extern  float kLeftw;

@interface ThinViewPlanViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *m_tableView;
    NSMutableArray *m_arrayList;
    UIButton *punchCard;
    WeekActivityView *m_headerView;
    NSInteger indexDay;
    NSDictionary *m_indexDayDict;
    NSDictionary *m_bodyDict;
}
@end

@implementation ThinViewPlanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"享瘦派";
    self.log_pageID = 17;

    m_arrayList = [[NSMutableArray alloc] init];
    self.navigationItem.rightBarButtonItem = [Common CreateNavBarButton3:self setEvent:@selector(butEventShowEmail) setTitle:@"我"];
    // Do any additional setup after loading the view.
    [self createTablewView];
    [self getDataSource];
}

-(BOOL)closeNowView
{
    [m_headerView closeWebViewItem];
    return [super closeNowView];
}

-(void)dealloc
{
    [m_headerView closeWebViewItem];
}

-(void)butEventShowEmail
{
//    [self showEnterView];
    [self goToSpecifyViewControllerWithClass:[ThinViewController class]];
}

-(void)goToSpecifyViewControllerWithClass:(Class)className
{
    for (CommonViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:className])
        {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    CommonViewController * thin = [[className alloc]init];
    [self.navigationController pushViewController:thin animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createTablewView
{
    float bottomBtnH = 50.0;
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-bottomBtnH) style:UITableViewStyleGrouped];
    m_tableView.dataSource = self;
    m_tableView.delegate = self;
    m_tableView.backgroundColor = [UIColor whiteColor];
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:m_tableView];
    [Common setExtraCellLineHidden:m_tableView];
    
    UIView *headerView = [self createHeaderView];
    m_tableView.tableHeaderView = headerView;
    
    punchCard = [UIButton buttonWithType:UIButtonTypeCustom];
    punchCard.frame = CGRectMake(0, kDeviceHeight - bottomBtnH, kDeviceWidth,bottomBtnH);
    [punchCard setTitle:@"打卡" forState:UIControlStateNormal];
    [punchCard setTitleColor:[CommonImage colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    punchCard.titleLabel.font = [UIFont systemFontOfSize:18.0];
    UIImage *backImage = [CommonImage createImageWithColor: [CommonImage colorWithHexString:@"42dc83"] ];
    punchCard.titleLabel.numberOfLines = 0;
    [punchCard setBackgroundImage:backImage forState:UIControlStateNormal];
    UIImage *backImageDisable = [CommonImage createImageWithColor: [CommonImage colorWithHexString:@"dcdcdc"]];
    [punchCard setBackgroundImage:backImageDisable forState:UIControlStateDisabled];
    [punchCard addTarget:self action:@selector(punchCardEven:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:punchCard];
}

-(void)setUpPunchCardState:(NSDictionary *)body
{
    //    is_clock;//0已经打卡，1未打卡
    BOOL is_clock = [body[@"is_clock"] boolValue];
    [self changePunchCardState:is_clock];
}

-(void)changePunchCardState:(BOOL)is_clock
{
    NSString *clockStr = is_clock ?@"打卡":@"已打卡";
    punchCard.enabled = is_clock;
    [punchCard setTitle:clockStr forState:UIControlStateNormal];
}

-(void)punchCardEven:(UIButton *)btn
{
    [self showEnterView];
}

-(UIView *)createHeaderView
{
    WS(weakSelf);
    WeekActivityView *headerView = [[WeekActivityView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 450/2+60)];
    headerView.backgroundColor = [UIColor whiteColor];
    m_headerView = headerView;
    [headerView setThinPlanViewBlock:^(NSNumber *content){
        [weakSelf refreshDataWithIndexDay:content.integerValue];
    }];
    headerView.infoDict = nil;
    return headerView ;
}

-(void)showEnterView
{
    if (6 == indexDay)
    {
        WS(weakSelf);
        if (0==_m_weekTargetWeight.intValue)
        {
            _m_weekTargetWeight = @"63.0";
        }
        NSDictionary *dict = @{kWeight:_m_weekTargetWeight};
        [EnterWeightView showEnterWeightViewWithBlock:^(NSString *content) {
            NSLog(@"-------%@",content);
            [weakSelf uploadDataSourceWithWeight:content];
        } withDict:dict];
    }
    else
    {
        [self uploadDataSourceWithWeight:@""];
    }
}

- (void)uploadDataSourceWithWeight:(NSString *)weight
{
    NSMutableDictionary *requestDic = [[NSMutableDictionary alloc] init];
    [requestDic setValue:weight forKey:@"weight"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:k_PUNCH_THE_CLOCK values:requestDic requestKey:k_PUNCH_THE_CLOCK delegate:self controller:self actiViewFlag:1 title:nil];
}

- (void)getDataSource
{
    NSMutableDictionary *requestDic = [[NSMutableDictionary alloc] init];
    if (0 == _m_week.length)
    {
        _m_week = @"";
    }
    [requestDic setValue:@(_m_week.integerValue) forKey:@"weeks"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:k_GET_REDUCE_DETAIL values:requestDic requestKey:k_GET_REDUCE_DETAIL delegate:self controller:self actiViewFlag:1 title:nil];
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}

-(void)refreshDataWithIndexDay:(NSInteger)indexD
{
    if (0 == m_bodyDict.count)
    {
        return;
    }
    NSArray *array = [m_bodyDict objectForKey:@"list"];
    if (array.count) {
        NSDictionary *infoDict = array[indexD];
        m_indexDayDict = infoDict;
        NSArray *arrayDto = infoDict[@"dtos"];
        [m_arrayList removeAllObjects];
        [m_arrayList addObjectsFromArray:arrayDto];
        [m_tableView reloadData];
        m_tableView.tableHeaderView = m_headerView;
    }
}

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    NSDictionary *head = [dic objectForKey:@"head"];
    if (![[head objectForKey:@"state"] intValue])
    {
        NSDictionary *body = [dic objectForKey:@"body"];
        if ([loader.username isEqualToString:k_GET_REDUCE_DETAIL]){
            m_bodyDict = body;
            NSArray *array = [body objectForKey:@"list"];
            if (array.count) {
                indexDay = array.count-1;
            }
            m_headerView.infoDict = body;
            [self refreshDataWithIndexDay:indexDay];
            [self setUpPunchCardState:body];
            _m_weekTargetWeight = body[@"current_weight"];
        }
        else if ([loader.username isEqualToString:k_PUNCH_THE_CLOCK]){
            [self changePunchCardState:NO];
            [Common MBProgressTishi:@"打卡成功!" forHeight:kDeviceHeight];
            [m_headerView  setUpWeekPuchState];
        }
        else {
            if (!dic) {
                [Common TipDialog:NSLocalizedString(@"网络异常", nil)];
                return;
            }
        }
    }
    else
        [Common TipDialog:[head objectForKey:@"msg"]];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kHeaderHeight)];
    sectionView.backgroundColor =[UIColor whiteColor];
    //    NSDictionary *dataDic = m_arrayList.lastObject;
    //    int temp = [dataDic[@"completion"] intValue];
    //    if ([dataDic[@"completion"] intValue] == [dataDic[@"unfinished"] intValue]) {
    //        temp = (int)m_arrayList.count;
    //    }
    UILabel *planName = [Common createLabel:CGRectMake(kLeftw, 0, kDeviceWidth - 2*kLeftw, 45) TextColor:@"666666" Font:[UIFont systemFontOfSize:14.0] textAlignment:NSTextAlignmentLeft labTitle:@"饮食方案"];
    [sectionView addSubview:planName];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(planName.left, planName.bottom, planName.width, 60)];
    backView.layer.cornerRadius = 4.0;
    backView.backgroundColor =[CommonImage colorWithHexString:@"fafafa"];
    backView.layer.borderWidth = 0.5;
    backView.clipsToBounds = YES;
    backView.layer.borderColor = [CommonImage colorWithHexString:LINE_COLOR].CGColor;
    [sectionView addSubview:backView];
    
    UILabel *budgetLabel = [Common createLabel:CGRectMake(10, 0,110, backView.height) TextColor:@"333333" Font:[UIFont systemFontOfSize:16.0] textAlignment:NSTextAlignmentLeft labTitle:@"预算热量(千卡)"];
    budgetLabel.backgroundColor = backView.backgroundColor;
    [backView addSubview:budgetLabel];
    
    UILabel *energyLabel = [Common createLabel:CGRectMake(0, 0,110, backView.height) TextColor:@"ffb525" Font:[UIFont systemFontOfSize:25.0] textAlignment:NSTextAlignmentRight labTitle:@"1600"];
    energyLabel.backgroundColor = backView.backgroundColor;
    [backView addSubview:energyLabel];
    energyLabel.right = backView.width-10;
    
    energyLabel.text = [NSString stringWithFormat:@"%@",[Common isNULLString3:m_indexDayDict[@"budget_calories"] ]];
    return sectionView ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeaderHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"newsCell";
    ThinPlanViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ThinPlanViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectedBackgroundView = [Common creatCellBackView];
    }
    NSDictionary *dataDic = [m_arrayList objectAtIndex:indexPath.row];
    cell.infoDict =  dataDic;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_arrayList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    float height = 10.0;
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kThinPlanViewCellH;
}
@end