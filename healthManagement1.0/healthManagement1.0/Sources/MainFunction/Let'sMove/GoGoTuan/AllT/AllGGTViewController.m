//
//  AllGGTViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-11-27.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "AllGGTViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "MyGGTTableViewCell.h"
#import "StepTeamMemViewController.h"
#import "AppDelegate.h"

@interface AllGGTViewController ()
<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>

{
       EGORefreshTableHeaderView *_headView;
        UITableView *myTableView;
}

@property (nonatomic,retain) NSMutableArray *dataArray;

@end

@implementation AllGGTViewController


- (void)dealloc
{
    self.dataArray = nil;
    
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, SCREEN_HEIGHT-44-49-50)];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = [UIColor clearColor];//[CommonImage colorWithHexString:@"#f6f7ed"];
    [self.view addSubview:myTableView];
    [myTableView release];
    [self setExtraCellLineHidden:myTableView];
    _headView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -460, kDeviceWidth, 460)];
    _headView.delegate = self;
    _headView.backgroundColor = [UIColor clearColor];
    [myTableView addSubview:_headView];
    [_headView release];
//    [self getDataSource];
    m_loadingMore = NO;
    //无网络 直接返回
    NetWorkType type = [Common checkNetworkIsValidType];
    if(type == NetWorkType_None)
    {
        return;
    }
    [self getDataSource];

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


#pragma mark -- TableViewDelegate And DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"allGGTCell";
    MyGGTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[MyGGTTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];
    }
    if(indexPath.row >= self.dataArray.count){
        return cell;
    }
    
    NSDictionary *oneDic = self.dataArray[indexPath.row];
    [cell setDataDic:oneDic];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *appDelegate = [Common getAppDelegate];
    StepTeamMemViewController *memberListVC = [[StepTeamMemViewController alloc] init];
    NSDictionary *teamDic = self.dataArray[indexPath.row];
//    memberListVC.hasApplyFlag = YES;
    memberListVC.title = teamDic[@"name"];
    memberListVC.teamId = teamDic[@"id"];
    memberListVC.tuanCount = [teamDic[@"total"] intValue];
    [appDelegate.navigationVC pushViewController:memberListVC animated:YES];
    [memberListVC release];
}

/**
 *  发送网络请求
 */
- (void)getDataSource
{
    m_loadingMore = YES;
    NSMutableDictionary *requestDic =  [[NSMutableDictionary alloc] initWithCapacity:0];
//    [requestDic setValue:[NSNumber numberWithInt:m_nowPage] forKey:@"pageNo"];
//    [requestDic setValue:[NSNumber numberWithInt:g_everyPageNum] forKey:@"pageSize"];
    
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GetALLGGTList values:requestDic requestKey:GetALLGGTList  delegate:self controller:self actiViewFlag:_dataArray.count>0?0:1 title:nil];
    m_nowPage++;
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
        if ([loader.username isEqualToString:GetALLGGTList]){
            if (m_nowPage==2) {
                [self.dataArray removeAllObjects];
            }
            if(resultArray.count < g_everyPageNum){
                
                [self endOfResultList];
            }
            [self.dataArray addObjectsFromArray:resultArray];
            [myTableView reloadData];
            [self finishRefresh];
        }else if ([loader.username isEqualToString:RemovePKRelation]){

        }
    }else{
    
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
    [self setExtraCellLineHidden:myTableView];
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

/**
 * UIScrollView delegate
 *
 *  @param scrollView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [_headView egoRefreshScrollViewDidScroll:scrollView];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_headView egoRefreshScrollViewDidEndDragging:scrollView];
    NSLog(@"------------:%f",scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.size.height);
    //上提
    if(hasMoreFlag == YES && m_loadingMore == NO &&  scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.size.height <= -40){
        m_loadingMore = YES;
        [self getDataSource];
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
