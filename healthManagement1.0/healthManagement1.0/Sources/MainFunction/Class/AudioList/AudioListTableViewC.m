//
//  AudioListTableViewC.m
//  healthManagement1.0
//
//  Created by xuguohong on 16/7/4.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "AudioListTableViewC.h"
#import "EGORefreshTableHeaderView.h"
#import "HomeTableViewCell.h"
#import "KXPayManage.h"
#import "XHAudioPlayerHelper.h"
#import "AudioListTableViewC.h"

@interface AudioListTableViewC ()<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate, TableCellDelegate, XHAudioPlayerHelperDelegate>


@end

@implementation AudioListTableViewC
{
    UITableView * m_table;
    UIView * m_headerView;
    EGORefreshTableHeaderView *_headView;
    
    NSMutableDictionary *m_dicc;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _m_allData = [[NSMutableArray alloc]init];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐话题";
    [self createTable];
    
    [self getAllData];
    UIView* footerView = [Common createTableFooter];
    m_table.tableFooterView = footerView;
    
    _headView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -460, kDeviceWidth, 460)];
    _headView.delegate = self;
    _headView.backgroundColor = [UIColor clearColor];
    [m_table addSubview:_headView];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[XHAudioPlayerHelper shareInstance] setDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[XHAudioPlayerHelper shareInstance] stopAudio];
    [[XHAudioPlayerHelper shareInstance] setDelegate:nil];
}

- (void)createTable
{
    m_table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.view.size.height-64) style:UITableViewStyleGrouped];
    m_table.dataSource = self;
    m_table.delegate = self;
    //分割线颜色
    m_table.separatorColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
    m_table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:m_table];
//    m_table.rowHeight = 147;
    m_table.tableHeaderView = [self createHeaderView];
}

- (UIView*)createHeaderView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 45)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * lab = [Common createLabel:CGRectMake(15, 25/2, 20, 20) TextColor:@"ffffff" Font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentCenter labTitle:@"荐"];
    lab.layer.cornerRadius = lab.width/2;
    lab.clipsToBounds = YES;
    
    [view addSubview:lab];
    lab.backgroundColor = [CommonImage colorWithHexString:@"ffc75c"];
    UILabel * titleLab = [Common createLabel:CGRectMake(lab.right+10, 0, 200, view.height) TextColor:@"666666" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft labTitle:self.m_superDic[@"name"]];
    [view addSubview:titleLab];
    
    return view;
}

- (void)getAllData
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:@"2" forKey:@"type"];
    [dic setObject:self.m_superDic[@"name"] forKey:@"keyword"];
    [dic setValue:[NSNumber numberWithInt:m_nowPage] forKey:@"pageNumber"];
    [dic setValue:[NSNumber numberWithInt:g_everyPageNum] forKey:@"pageSize"];
    
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GET_API_CORSELIST values:dic requestKey:GET_API_CORSELIST delegate:self controller:self actiViewFlag:0 title:NSLocalizedString(@"", nil)];
    m_nowPage++;
    
}

#pragma mark - UITableView DataSource  And Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _m_allData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = _m_allData[indexPath.section];
    CGSize size = [Common sizeForAllString:dic[@"courseTitle"] andFont:17 andWight:kDeviceWidth-30];
    float h = 170/2+size.height+20;

    return h;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , kDeviceWidth, 0)];
    lineView1.backgroundColor = self.view.backgroundColor;
    return lineView1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cell1= @"cell1";
    SoundTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cell1];
    if (!cell) {
        cell = [[SoundTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                         reuseIdentifier:cell1];
        cell.selectedBackgroundView = [Common creatCellBackView];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        cell.delegate = self;
    }
//    WSS(weak);
//    cell.soundBlock = ^(NSDictionary * dic){
//        NSLog(@"%@",dic);
//    };
    
    
    //    if (indexPath.row<[_m_allData[indexPath.section][@"data"] count]) {
    NSDictionary * dic = _m_allData[indexPath.section];
    [cell setSoundInfoWithDic:dic];
    //    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma end


- (void)showPic:(NSMutableDictionary*)dic withID:(id)cell
{
    // 是否免费 0、免费 3、收费 2、锁定
    if ([dic[@"isFree"] intValue] != 3) {
        
        BOOL is = [[dic objectForKey:@"isPlay"] boolValue];
        
        [dic setObject:[NSNumber numberWithBool:!is] forKey:@"isPlay"];
        
        if (!is) {
            [dic setObject:@([dic[@"browseNum"] intValue]+1) forKey:@"browseNum"];
            [m_table reloadRowsAtIndexPaths:@[[m_table indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationNone];
            
            [((SoundTableViewCell*)cell).imagePlayView startAnimating];
            NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
            [dicc setObject:dic[@"id"] forKey:@"id"];
            [[CommonHttpRequest defaultInstance] sendNewPostRequest:add_audio_counts values:dicc requestKey:add_audio_counts delegate:self controller:self actiViewFlag:0 title:nil];
        } else {
            [((SoundTableViewCell*)cell).imagePlayView stopAnimating];
        }
        
        [[XHAudioPlayerHelper shareInstance] managerAudioWithFileName:dic[@"url"] toPlay:!is withDic:dic];
        [[XHAudioPlayerHelper shareInstance] setDelegate:self];
    }
    else if ([dic[@"isFree"] intValue] == 3) {
        
        m_dicc = dic;
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        [dic1 setObject:dic[@"id"] forKey:@"id"];
        [dic1 setObject:kWXAppID forKey:@"appId"];
        [[CommonHttpRequest defaultInstance] sendNewPostRequest:URL_POSTREWARD values:dic1 requestKey:URL_POSTREWARD delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"加载中...", nil)];
    }
}

//停止播放
- (void)didAudioPlayerStopPlay:(AVAudioPlayer*)audioPlayer
{
    XHAudioPlayerHelper *audioPlay = [XHAudioPlayerHelper shareInstance];
    NSMutableDictionary *dic = audioPlay.dicInfo;
    if (dic) {
        [dic setObject:[NSNumber numberWithBool:0] forKey:@"isPlay"];
        int index = (int)[_m_allData indexOfObject:dic];
        SoundTableViewCell *cell = (SoundTableViewCell*)[m_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
        if (cell) {
            [cell.imagePlayView stopAnimating];
        }
    }
}

- (void)didFinishFail:(ASIHTTPRequest*)loader
{
    if ([loader.username isEqualToString:GET_API_CORSELIST])
    {
        
    }
}

- (void)didFinishSuccess:(ASIHTTPRequest*)loader
{
    NSString* responseString = [loader responseString];
    NSDictionary* dic = [responseString KXjSONValueObject];
    
    NSMutableDictionary *head = dic[@"head"];
    if (![head[@"state"] intValue]) {
        NSDictionary *body = dic[@"body"];
        if (!body.count)
        {
            return;
        }
        if ([loader.username isEqualToString:GET_API_CORSELIST])
        {
            //            [_m_allData addObjectsFromArray:body[@"list"]];
            if (m_nowPage==2) {
                [_m_allData removeAllObjects];
            }
            
//            NSMutableArray * arr = [NSMutableArray array];
            
            for (NSDictionary * d in body[@"list"][0][@"list"]) {
                    [_m_allData addObject:d];
            }
            if([body[@"list"][0][@"list"] count] < g_everyPageNum){
                [self endOfResultList];
            }
            
            [m_table reloadData];
            [self finishRefresh];
        }
        else if ([loader.username isEqualToString:URL_POSTREWARD]) {
            
            if (![body[@"rewardStatus"] intValue]) {
                [m_dicc setObject:[NSNumber numberWithInteger:5] forKey:@"isFree"];
                
                NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:[_m_allData indexOfObject:m_dicc]];
                UITableViewCell *cell = [m_table cellForRowAtIndexPath:index];
                [self showPic:m_dicc withID:cell];
            }
            else {
                WS(weakSelf);
                [KXPayManage wxPayWithHandleServerResult:body result:^(int statusCode, NSString *statusMessage, id resultDict, NSError *error, NSData *data) {
                    [weakSelf handlerPayResultWithStatusMessage:statusMessage];
                }];
            }
        }
    }
    else
    {
        if ([loader.username isEqualToString:URL_POSTREWARD]) {
            if ([head[@"state"] intValue] == 2004) {
                
//                [m_dicc setObject:[NSNumber numberWithInteger:5] forKey:@"isFree"];
//                int section = 0;
//                for (NSDictionary *item in _m_allData) {
//                    
//                    if (![item[@"type"] intValue]) {
//                        break;
//                    }
//                    
//                    section++;
//                }
                
                
                NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:[_m_allData indexOfObject:m_dicc]];
                UITableViewCell *cell = [m_table cellForRowAtIndexPath:index];
                [self showPic:m_dicc withID:cell];
                [m_table reloadData];
                
                return;
            }
        }
        else {
            [Common TipDialog2:head[@"msg"]];
        }
    }
}

- (void)handlerPayResultWithStatusMessage:(NSString *)statusMessage
{
    if (![kPaySuccess isEqualToString:statusMessage])
    {
        return;
    }
    
    [m_dicc setObject:[NSNumber numberWithInteger:5] forKey:@"isFree"];
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:[_m_allData indexOfObject:m_dicc]];
    UITableViewCell *cell = [m_table cellForRowAtIndexPath:index];
    [self showPic:m_dicc withID:cell];
    
    [[KXPayManage sharePayEngine] setUpNilBlock];
}

//停止加载TableView
- (void)endOfResultList
{
    hasMoreFlag = NO;
    UILabel *lab = (UILabel*)[m_table.tableFooterView viewWithTag:tableFooterViewLabTag];
    lab.text = @"已到底部";
    lab.frame = CGRectMake(0, 0, kDeviceWidth, 45);
    UIActivityIndicatorView *activi = (UIActivityIndicatorView*)[m_table.tableFooterView viewWithTag:tableFooterViewActivityTag];
    [activi removeFromSuperview];
    //    activi.hidden = YES;
    
}

#pragma mark - EGORefreshTableHeaderDelegate
//收起刷新
- (void)finishRefresh{
    
    [_headView egoRefreshScrollViewDataSourceDidFinishedLoading:m_table];
    m_loadingMore = NO;
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    hasMoreFlag = YES;
    m_loadingMore = YES;
    //下拉刷新 开始请求新数据 ---原数据清除
    m_nowPage = 1;//复位
    //    [newsListTableView reloadData];
    [self getAllData];
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
        [self getAllData];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end