//
//  DoctorListViewController.m
//  healthManagement1.0
//
//  Created by 徐国洪 on 15/10/16.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "DoctorListViewController.h"
#import "FriendListCell.h"
#import "ShowConsultViewController.h"
#import "DocDetailViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "UIImageView+WebCache.h"

@interface DoctorListViewController () <UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate>
{
    UITableView *m_tableView;
    NSMutableArray *m_array;
    BOOL m_isloading;
    
    EGORefreshTableHeaderView *m_headView;
}

@end

@implementation DoctorListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSource) name:@"refreshFriendList" object:nil];
        self.log_pageID = 35;

    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [CommonImage colorWithHexString:@"f2f2f2"];
    self.title = @"问医生";
    
    m_array = [[NSMutableArray alloc] init];
    
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    m_tableView.backgroundColor = [UIColor clearColor];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.separatorColor = [CommonImage colorWithHexString:LINE_COLOR];
    m_tableView.rowHeight = 70;
    [Common setExtraCellLineHidden:m_tableView];
    [self.view addSubview:m_tableView];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0.5)];
    footer.backgroundColor = m_tableView.separatorColor;
    m_tableView.tableFooterView = footer;
    
    m_headView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -460, kDeviceWidth, 460)];
    m_headView.delegate = self;
    m_headView.backgroundColor = [UIColor clearColor];
    [m_tableView addSubview:m_headView];
    [m_headView egoRefreshScrollViewDidScroll:m_tableView];
    [m_headView egoRefreshScrollViewDidEndDragging:m_tableView];
    
    [self getDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [m_tableView reloadData];
}

- (void)getDataSource
{
    m_loadingMore = YES;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSNumber numberWithInt:1] forKey:@"type"];
    [dic setObject:REQUEST_PAGE_NUM forKey:@"pageSize"];
    [dic setObject:@"0" forKey:@"lastUpdateTime"];//time?time:
    [dic setObject:[NSString stringWithFormat:@"%d",m_nowPage] forKey:@"pageNo"];
    
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:URL_getDoctorList values:dic requestKey:URL_getDoctorList delegate:self controller:self actiViewFlag:0 title:nil];
    m_nowPage++;
}

#pragma mark tableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return m_array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dicSeciton = m_array[section];
    return [dicSeciton[@"array"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 31;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *dicSeciton = m_array[section];
    
    UILabel *lab = [Common createLabel];
    lab.frame = CGRectMake(0, 0, kDeviceWidth, 31);
    lab.font = [UIFont systemFontOfSize:13];
    lab.backgroundColor = [CommonImage colorWithHexString:@"f2f2f2"];
    lab.textColor = [CommonImage colorWithHexString:@"999999"];
    lab.text = [NSString stringWithFormat:@"  %@", dicSeciton[@"title"]];
    
    UIView *tline = [Common getHLineForY:0];
    [lab addSubview:tline];
    
    UIView *dline = [Common getHLineForY:lab.height];
    [lab addSubview:dline];
    
    return lab;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    FriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (cell == nil)
    {
        cell = [[FriendListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    FriendModel *model = m_array[indexPath.section][@"array"][indexPath.row];
    
    NSString *imagePath = [model.userPhoto stringByAppendingString:@"?imageView2/1/w/160/h/160"];
    UIImage *defaul = [UIImage imageNamed:@"common.bundle/common/center_my-family_head_icon.png"];
    [cell.m_headerView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:defaul];

    [cell setInfoModel:model];

    return cell;
}

#pragma end

#pragma mark - tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FriendModel *model = m_array[indexPath.section][@"array"][indexPath.row];
    if (model.chatTime) {
        ShowConsultViewController *showConsultVC = [[ShowConsultViewController alloc] init];
//        NSMutableDictionary *dic = [model getFriendModelDic];
//        [showConsultVC setM_dicInfo:dic];
        showConsultVC.friendModel = model;
        [((CommonViewController*)self.m_superClass).navigationController pushViewController:showConsultVC animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refleshFriendListTip" object:nil];//wangmin添加,解决糖圈左上角红点不消失问题
        
        model.unReadCount = 0;
    }
    else {
        DocDetailViewController *docVC = [[DocDetailViewController alloc] init];
        docVC.m_superClass = self;
        docVC.friendModel = model;
        [((CommonViewController*)self.m_superClass).navigationController pushViewController:docVC animated:YES];
    }
}

#pragma end

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [m_headView egoRefreshScrollViewDidScroll:scrollView];
}

//UIScrollView松开手指
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [m_headView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - EGORefreshTableHeaderDelegate

//收起刷新
- (void)finishRefresh
{
    [m_headView egoRefreshScrollViewDataSourceDidFinishedLoading:m_tableView];
    m_isloading = NO;
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    if (m_isloading) {
        return;
    }
    //上拉加载  拖动过程中
    m_isloading = YES;
    
    m_nowPage = 1;//复位
    
    [self getDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return m_isloading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}
#pragma end


- (NSMutableDictionary*)getCaogao
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *filePath = [[Common datePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.plist", g_nowUserInfo.userid, @"caogao"]];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (isExist) {
        dic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    }
    return dic;
}

#pragma mark - 网络回调

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    NSLog(@"%@",dic);
    
    NSDictionary *head = [dic objectForKey:@"head"];
    if (![[head objectForKey:@"state"] intValue])
    {
        NSDictionary *body = [dic objectForKey:@"body"];
        if ([loader.username isEqualToString:URL_getDoctorList]) {
            
            [m_array removeAllObjects];
            
            //更新
            [m_array addObjectsFromArray:[FriendModel getFriendMArray:body]];
            
            NSDictionary *dicCaogao = [self getCaogao];
            NSString *accountId, *centent;
            for (NSMutableDictionary *item in m_array) {
                
                NSArray *sectionArray = item[@"array"];
                for (FriendModel *model in sectionArray) {
                    
                    accountId = [NSString stringWithFormat:@"%@", model.accountId];
                    centent = [dicCaogao objectForKey:accountId];
                    if (centent) {
                        model.chatContent = centent;
                        model.chatContentType = 50;
                    }
                }
            }
            
            [m_tableView reloadData];
            [self finishRefresh];
            

        }
    }
    else {
        [Common TipDialog:[head objectForKey:@"msg"]];
        if ([loader.username isEqualToString:URL_getDoctorList]){
            [self finishRefresh];
        }
    }
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    NSLog(@"fail");
    [self finishRefresh];
    if ([loader.username isEqualToString:URL_getDoctorList]){
        m_loadingMore = NO;
    }
}
#pragma end

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
