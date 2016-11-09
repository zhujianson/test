//
//  StepTeamMemViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-11-28.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "StepTeamMemViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "MemberTableViewCell.h"
#import "AppDelegate.h"
#import "StepUserInfoViewController.h"


@interface StepTeamMemViewController ()
<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>

{
    EGORefreshTableHeaderView *_headView;
    UITableView *myTableView;
    __block  MBProgressHUD *hub;
    BOOL noAllowCheckUserInfoFlag;
    UIButton *applyBtn;//加入按钮
    
}

@property (nonatomic,retain) NSMutableArray *dataArray;

@end

@implementation StepTeamMemViewController

- (void)dealloc
{
    hub = nil;
    self.dataArray = nil;
    self.teamId = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
        self.log_pageID = 110;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    [self getTeamInfo];

    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 90, kDeviceWidth, SCREEN_HEIGHT-44-90)];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = [UIColor clearColor];//[CommonImage colorWithHexString:@"#f6f7ed"];
    [self.view addSubview:myTableView];
    [myTableView release];
    [self setExtraCellLineHidden:myTableView];//footView 关闭
    _headView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -460, kDeviceWidth, 460)];
    _headView.delegate = self;
    _headView.backgroundColor = [UIColor clearColor];
    [myTableView addSubview:_headView];
    [_headView release];
    //    [self getDataSource];
    m_loadingMore = NO;

    [self getDataSource];
}



- (void)getTeamInfoView:(NSDictionary *)dic
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 90)];
    headView.backgroundColor = [CommonImage colorWithHexString:@"e8f9f9"];
    [self.view addSubview:headView];
    [headView release];
    //标题
    UILabel *teamTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, kDeviceWidth-20*2, 16)];
    teamTitleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    teamTitleLabel.backgroundColor = [UIColor clearColor];
    teamTitleLabel.text = dic[@"manifesto"];//manifesto
    [self.view addSubview:teamTitleLabel];
    [teamTitleLabel release];
    //运动人数
    //总人数
    UILabel *teamNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-60-15, teamTitleLabel.origin.y+teamTitleLabel.size.height+10, 60, 17)];//名字长度*15+5
    teamNumLabel.font = [UIFont systemFontOfSize:14.0f];
    teamNumLabel.text = [NSString stringWithFormat:@"%@/%@",[[Common isNULLString3:dic[@"memberCount"]] length]? dic[@"memberCount"]:@"0",dic[@"total"]];;
    teamNumLabel.textColor = [CommonImage colorWithHexString:@"666666"];
    teamNumLabel.textAlignment = NSTextAlignmentCenter;
    teamNumLabel.backgroundColor = [UIColor clearColor];
    teamNumLabel.layer.cornerRadius = 5.0f;
    teamNumLabel.layer.masksToBounds = YES;
    [self.view addSubview:teamNumLabel];
    [teamNumLabel release];
    //运动时间
    UILabel *moveTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, teamTitleLabel.origin.y+teamTitleLabel.size.height+10, kDeviceWidth-20*2-70-5, 14)];
    moveTimeLabel.font = [UIFont systemFontOfSize:15.0f];
    moveTimeLabel.text = [NSString stringWithFormat:@"运动时间：%@",[CommonDate getServerTime:[dic[@"sportsTime"] longLongValue] type:1]];
    moveTimeLabel.textColor = [CommonImage colorWithHexString:@"333333"];
    moveTimeLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:moveTimeLabel];
    [moveTimeLabel release];
    //运动地点
    UILabel *moveLocLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, moveTimeLabel.origin.y+moveTimeLabel.size.height+10, kDeviceWidth-20*2-70-5, 14)];
    moveLocLabel.tag = 777;
    moveLocLabel.font = [UIFont systemFontOfSize:15.0f];
    moveLocLabel.text = [NSString stringWithFormat:@"地点：%@ %@",dic[@"activityArea"],dic[@"activityAddress"]];
    NSLog(@"---%@",moveLocLabel.text);
    moveLocLabel.backgroundColor = [UIColor clearColor];
    moveLocLabel.textColor = [CommonImage colorWithHexString:@"333333"];
    [self.view addSubview:moveLocLabel];
    [moveLocLabel release];
    //申请加入
    applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    applyBtn.frame = CGRectMake(0, 0, 40, 44);
    applyBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    applyBtn.tag = 666;

//    NSString* imageName = @"common.bundle/nav/navigationbar_icon_apply_normal.png";
//    UIImage *image1 = [UIImage imageNamed:imageName];
//    [applyBtn setImage:image1 forState:UIControlStateNormal];
    [applyBtn addTarget:self action:@selector(applyJoin:) forControlEvents:UIControlEventTouchUpInside];

    [applyBtn setTitle:@"加入" forState:UIControlStateNormal];
    [applyBtn setTitleColor:[CommonImage colorWithHexString:VERSION_ERROR_TEXT_COLOR] forState:UIControlStateNormal];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:applyBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    if(![dic[@"isJoined"] boolValue]){
        applyBtn.hidden = NO;//允许加入，未加入，不可以看
        noAllowCheckUserInfoFlag = YES;
    }else{
        applyBtn.hidden = YES;
        noAllowCheckUserInfoFlag = NO;;
        moveLocLabel.frame = CGRectMake(20, moveTimeLabel.origin.y+moveTimeLabel.size.height+10, kDeviceWidth-20*2, 14);
    }
    
}

- (void)applyJoin:(UIButton *)btn
{
    NSMutableDictionary *requestDic =  [[NSMutableDictionary alloc] initWithCapacity:0];
    [requestDic setValue:self.teamId forKey:@"id"];
//    [requestDic setValue:g_nowUserInfo.userid forKey:@"userId"];
//    [requestDic setValue:@"2" forKey:@"status"];
    
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:AddTeamMem values:requestDic requestKey:AddTeamMem  delegate:self controller:self actiViewFlag:1 title:nil];
    [requestDic release];
    btn.enabled = NO;
}

/**
 *  隐藏tableviewd多余分割线
 *
 *  @param tableView
 */
-(void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [view release];
    UIView *footView = [Common createTableFooter];
    [view addSubview:footView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"allGGTCell";
    MemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[MemberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];
    }
    if(indexPath.row >= self.dataArray.count){
        return cell;
    }
    
        NSDictionary *oneDic = self.dataArray[indexPath.row];
        NSMutableDictionary *theDic = [NSMutableDictionary dictionaryWithDictionary:oneDic];
        [theDic setObject:indexPath forKey:@"index"];
    
        [cell setDataDic:theDic];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(noAllowCheckUserInfoFlag){
    
        [Common TipDialog2:@"申请加入后才能查看成员信息！"];
        return;
    }
    
    AppDelegate *appDelegate = [Common getAppDelegate];
    StepUserInfoViewController *memberInfotVC = [[StepUserInfoViewController alloc] init];
     NSDictionary *oneDic = self.dataArray[indexPath.row];
    memberInfotVC.userId =  oneDic[@"accountId"];
    [appDelegate.navigationVC pushViewController:memberInfotVC animated:YES];
    [memberInfotVC release];
    
}


//获得成员列表
- (void)getDataSource
{
    m_loadingMore = YES;
    NSMutableDictionary *requestDic =  [[NSMutableDictionary alloc] initWithCapacity:0];
    [requestDic setValue:self.teamId forKey:@"id"];
    [requestDic setValue:[NSNumber numberWithInt:m_nowPage] forKey:@"pageNo"];
    [requestDic setValue:[NSNumber numberWithInt:self.tuanCount] forKey:@"pageSize"];
//    [requestDic setValue:[NSNumber numberWithInt:g_everyPageNum] forKey:@"pageSize"];
    
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GetTMemList values:requestDic requestKey:GetTMemList  delegate:self controller:self actiViewFlag:self.dataArray>0?0:1 title:nil];
    m_nowPage++;
    [requestDic release];
}

//获取团信息
- (void)getTeamInfo
{
    NSMutableDictionary *requestDic =  [[NSMutableDictionary alloc] initWithCapacity:0];
//    [requestDic setValue:g_nowUserInfo.userid forKey:@"userId"];
    [requestDic setValue:self.teamId forKey:@"id"];
    
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GetTInfo values:requestDic requestKey:GetTInfo  delegate:self controller:self actiViewFlag:1 title:nil];
    [requestDic release];
    
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    NSLog(@"fail");
    //    m_loadingMore = NO;
    //    [self endOfResultList];
    [self finishRefresh];
}

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    if ([dic[@"head"][@"state"] isEqualToString:@"0000"])
    {
        NSDictionary *bodyDic = dic[@"body"];
        
        NSArray *resultArray = bodyDic[@"resultSet"];

        if ([loader.username isEqualToString:GetTMemList]){
            if (m_nowPage==2) {
                [self.dataArray removeAllObjects];
            }
//            if(resultArray.count < g_everyPageNum){
            if(resultArray.count <= self.tuanCount){
            
                [self endOfResultList];
            }
            [self.dataArray addObjectsFromArray:resultArray];
            [myTableView reloadData];
            [self finishRefresh];
        }else if ([loader.username isEqualToString:GetTInfo]){
            
            NSDictionary *resultDic = bodyDic[@"data"];
            [self getTeamInfoView:resultDic];
        }else if ([loader.username isEqualToString:AddTeamMem]){
                //加入成功
                //隐藏按钮
            noAllowCheckUserInfoFlag = NO;
            if(hub){
                
                [hub removeFromSuperview];
                hub = nil;
            }
            
             hub =  [Common ShowMBProgress:self.view MSG:@"加入成功！" Mode:MBProgressHUDModeText];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyGGTListRefreshNotification" object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hub removeFromSuperview];
                hub = nil;
            });
//            UIButton *applyBtn = (UIButton *)[self.view viewWithTag:666];
              applyBtn.hidden = YES;
//            UILabel *moveLocLabel = (UILabel *)[self.view viewWithTag:777];
//             CGRect moveLocLabelFrame =  moveLocLabel.frame;
//             moveLocLabelFrame.size.width = kDeviceWidth-20*2;
//             moveLocLabel.frame = moveLocLabelFrame;
        }
    }else {
        if ([loader.username isEqualToString:AddTeamMem])
        {
            //加入团失败，按钮恢复可点击状态
            applyBtn.enabled = YES;
        }
          [Common TipDialog:dic[@"head"][@"msg"]];
    
    }
}

//停止加载TableView
- (void)endOfResultList
{
     hasMoreFlag = NO;
    UILabel *lab = (UILabel*)[myTableView.tableFooterView viewWithTag:tableFooterViewLabTag];
    lab.text = @"已到底部";
    lab.frame = CGRectMake(0, 0, kDeviceWidth, 45);
    UIActivityIndicatorView *activi = (UIActivityIndicatorView*)[myTableView.tableFooterView viewWithTag:tableFooterViewActivityTag];
    [activi removeFromSuperview];
    //    activi.hidden = YES;
    
}

#pragma mark - EGORefreshTableHeaderDelegate
//收起刷新
- (void)finishRefresh{
    
    [_headView egoRefreshScrollViewDataSourceDidFinishedLoading:myTableView];
    m_loadingMore = NO;
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    hasMoreFlag = YES;
    m_loadingMore = YES;
    //下拉刷新 开始请求新数据 ---原数据清除
    m_nowPage = 1;//复位
//    [self setExtraCellLineHidden:myTableView];

    //    [newsListTableView reloadData];
    [self getDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return m_loadingMore;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

//scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [_headView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_headView egoRefreshScrollViewDidEndDragging:scrollView];
    NSLog(@"------------:%f",scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.size.height);
//    //上提
//    if(hasMoreFlag == YES && m_loadingMore == NO &&  scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.size.height <= -40){
//        m_loadingMore = YES;
//        [self getDataSource];
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
