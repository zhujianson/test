//
//  myDayRankListViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-11-27.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "myDayRankListViewController.h"
#import "RankTableViewCell.h"
#import "EGORefreshTableHeaderView.h"
#import "StepUserInfoViewController.h"
#import "AppDelegate.h"

@interface myDayRankListViewController ()
<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
     EGORefreshTableHeaderView *_headView;
    UITableView *rankListTableView;
}
@property (nonatomic,retain) NSMutableArray *dataList;
@end

@implementation myDayRankListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [CommonImage colorWithHexString:Color_fafafa];
     self.dataList = [NSMutableArray arrayWithCapacity:0];
    // Do any additional setup after loading the view.
    rankListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - 40)];
    rankListTableView.backgroundColor = [UIColor clearColor];
    rankListTableView.dataSource = self;
    rankListTableView.delegate = self;
    rankListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:rankListTableView];
    [rankListTableView release];
    UIView *footerView = [Common createTableFooter];
    rankListTableView.tableFooterView = footerView;
    _headView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -460, kDeviceWidth, 460)];
    _headView.delegate = self;
    _headView.backgroundColor = [UIColor clearColor];
    [rankListTableView addSubview:_headView];
    [_headView release];

//    if(!self.isDayRankFlag){
//    
        [self getDataSource];
//    }
//    
    NSLog(@"---%d",self.isDayRankFlag);
    
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

- (void)viewWillAppear:(BOOL)animated
{
    //无网络 直接返回
    NetWorkType type = [Common checkNetworkIsValidType];
    if(type == NetWorkType_None)
    {
        return;
    }
    [self getDataSource];
}

- (void)getDataSource
{
    NSMutableDictionary *requestDic =  [[NSMutableDictionary alloc] initWithCapacity:0];
//    [requestDic setValue:g_nowUserInfo.userid forKey:@"uid"];
    
    NSString *requestName =  GetTopListForDay;
    if(!self.isDayRankFlag){
        //全部排名
        requestName = GetTopList;
    }
    [requestDic setValue:[NSNumber numberWithInt:m_nowPage] forKey:@"pageNo"];
    [requestDic setValue:[NSNumber numberWithInt:g_everyPageNum] forKey:@"pageSize"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:requestName values:requestDic requestKey:requestName delegate:self controller:self actiViewFlag:1 title:nil];
    m_nowPage++;
    [requestDic release];
}

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    if ([dic[@"head"][@"state"] isEqualToString:@"0000"])
    {
        NSDictionary *bodyDic = dic[@"body"];
        if ([loader.username isEqualToString:GetTopList]) {

            NSMutableArray *resultArray = [NSMutableArray arrayWithArray:bodyDic[@"resultSet"]];
            
            if(resultArray.count < g_everyPageNum){
                [self endOfResultList];
            }
            if (m_nowPage==2) {
                [self.dataList removeAllObjects];
                
                NSDictionary *myDic = bodyDic[@"resultSet"][0];
                
                NSDictionary *newMyDic = @{@"nickName": myDic[@"nickName"],@"userPhoto":myDic[@"userPhoto"],@"sex":[NSString stringWithFormat:@"%@",myDic[@"sex"]],@"distance":[NSString stringWithFormat:@"%@",myDic[@"distance"]],@"stepCnt":[NSString stringWithFormat:@"%@",myDic[@"stepCnt"]],@"rank":[NSString stringWithFormat:@"%@",myDic[@"rank"]],@"change":[NSString stringWithFormat:@"%@",myDic[@"upNum"]],@"userId":@"1"};
                
                [self.dataList addObject:newMyDic];
                [resultArray removeObjectAtIndex:0];
                
            }
                [self.dataList addObjectsFromArray:resultArray];
                [rankListTableView reloadData];
            
        }else  if ([loader.username isEqualToString:GetTopListForDay]) {
 
            NSMutableArray *resultArray = [NSMutableArray arrayWithArray:bodyDic[@"resultSet"]];
     
            if(resultArray.count < g_everyPageNum){
                [self endOfResultList];
            }

            if (m_nowPage==2) {
                
                [self.dataList removeAllObjects];
                
                NSDictionary *myDic = bodyDic[@"resultSet"][0];
                NSDictionary *newMyDic = @{@"nickName": myDic[@"nickName"],@"userPhoto":myDic[@"userPhoto"],@"sex":[NSString stringWithFormat:@"%@",myDic[@"sex"]],@"distance":[NSString stringWithFormat:@"%@",myDic[@"distance"]],@"stepCnt":[NSString stringWithFormat:@"%@",myDic[@"stepCnt"]],@"rank":[NSString stringWithFormat:@"%@",myDic[@"rank"]],@"change":[NSString stringWithFormat:@"%@",myDic[@"upNum"]],@"userId":@"1"};
                
                [self.dataList addObject:newMyDic];
                [resultArray removeObjectAtIndex:0];
            }
            

            [self.dataList addObjectsFromArray:resultArray];
            [rankListTableView reloadData];
        }
        
        [self finishRefresh];
        
    } else {
        
     [Common TipDialog:dic[@"head"][@"msg"]];
    }
}

//停止加载TableView
- (void)endOfResultList
{
    hasMoreFlag = NO;
    UILabel *lab = (UILabel*)[rankListTableView.tableFooterView viewWithTag:tableFooterViewLabTag];
    lab.text = @"已到底部";
    lab.frame = CGRectMake(0, 0, kDeviceWidth, 45);
    UIActivityIndicatorView *activi = (UIActivityIndicatorView*)[rankListTableView.tableFooterView viewWithTag:tableFooterViewActivityTag];
    [activi removeFromSuperview];
    //    activi.hidden = YES;
    
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"rankCell";
    RankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[RankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
//        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];
    }
    
    if(indexPath.row >= self.dataList.count){
        return cell;
    }
    
    NSDictionary *oneDic = self.dataList[indexPath.row];
    
    
    [cell setDataDic:oneDic isFirst:indexPath.row == 0 isDay:self.isDayRankFlag];
    
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
      NSDictionary *oneDic = self.dataList[indexPath.row];

    AppDelegate *appDelegate = [Common getAppDelegate];
    StepUserInfoViewController *memberInfotVC = [[StepUserInfoViewController alloc] init];
    memberInfotVC.userId =  oneDic[@"accountId"];
    [appDelegate.navigationVC pushViewController:memberInfotVC animated:YES];
    [memberInfotVC release];

}

#pragma mark - EGORefreshTableHeaderDelegate
//收起刷新
- (void)finishRefresh{
    
    [_headView egoRefreshScrollViewDataSourceDidFinishedLoading:rankListTableView];
    m_loadingMore = NO;
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    hasMoreFlag = YES;
    m_loadingMore = YES;
    //下拉刷新 开始请求新数据 ---原数据清除
    m_nowPage = 1;//复位
    [self setExtraCellLineHidden:rankListTableView];
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
    //上提
    if(hasMoreFlag == YES && m_loadingMore == NO &&  scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.size.height <= -40){
        m_loadingMore = YES;
        [self getDataSource];
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
