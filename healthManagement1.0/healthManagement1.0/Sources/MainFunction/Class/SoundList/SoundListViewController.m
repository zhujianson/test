//
//  SoundListViewController.m
//  healthManagement1.0
//
//  Created by xjs on 16/7/4.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "SoundListViewController.h"
#import "HomeTableViewCell.h"
#import "EGORefreshTableHeaderView.h"
#import "KXPayManage.h"
#import "XHAudioPlayerHelper.h"
#import "AudioListTableViewC.h"

@interface SoundListViewController ()<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate, TableCellDelegate, XHAudioPlayerHelperDelegate>

@end

@implementation SoundListViewController
{
    UITableView * m_table;
    NSArray * m_NextArr;
    UIView * m_headerView;
    EGORefreshTableHeaderView *_headView;
    NSMutableDictionary *m_dicc;
}

- (void)dealloc
{
    m_table = nil;
    self.m_allData = nil;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _m_allData = [[NSMutableArray alloc]init];
        self.log_pageID = 13;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createTable];

    if (!_m_allData.count) {
        [self getAllData];
        UIView* footerView = [Common createTableFooter];
        m_table.tableFooterView = footerView;
        
        _headView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -460, kDeviceWidth, 460)];
        _headView.delegate = self;
        _headView.backgroundColor = [UIColor clearColor];
        [m_table addSubview:_headView];

    }

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
    m_table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.view.size.height-(_m_allData.count?64:158)) style:UITableViewStyleGrouped];
    m_table.dataSource = self;
    m_table.delegate = self;
    //分割线颜色
    m_table.separatorColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
    m_table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:m_table];
//    m_table.rowHeight = 147;
    
}

- (UIView*)headerView
{
    UIButton * btn;
    float w,h;
    UIView * lineView;
    int num = (m_NextArr.count+1)/2;
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, num * 40)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
//    arr[i][@"name"]
    for (int i = 0; i<m_NextArr.count; i++) {
        w = i%2,h = i/2;
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(w * (kDeviceWidth/2), 40*h, kDeviceWidth/2, 40);
        btn.tag = 100+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [btn setTitle:m_NextArr[i][@"name"] forState:UIControlStateNormal];
        [view addSubview:btn];
        [btn addTarget:self action:@selector(chooseTap:) forControlEvents:UIControlEventTouchUpInside];
        if (!w) {
            lineView = [[UIView alloc]initWithFrame:CGRectMake(btn.right-0.25, btn.top+10, 0.5, 20)];
            lineView.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
            [view addSubview:lineView];
        }
        UIEdgeInsets edge = {0,0,0,0};
        edge.left = -(btn.width-MIN([Common sizeForString:btn.titleLabel.text andFont:btn.titleLabel.font.pointSize].width, btn.width))+30;
        [btn setTitleEdgeInsets:edge];
    }
    if (m_NextArr.count>2) {
        lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 40-0.25, kDeviceWidth-30, 0.25)];
        lineView.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
        [view addSubview:lineView];
    }
    
    return view;
}

- (void)getAllData
{
    [[XHAudioPlayerHelper shareInstance] stopAudio];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:@"2" forKey:@"type"];
    [dic setObject:@"0" forKey:@"classification"];
    [dic setValue:[NSNumber numberWithInt:m_nowPage] forKey:@"pageNumber"];
    [dic setValue:[NSNumber numberWithInt:g_everyPageNum] forKey:@"pageSize"];

    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GET_API_CORSELIST values:dic requestKey:GET_API_CORSELIST delegate:self controller:self actiViewFlag:0 title:NSLocalizedString(@"", nil)];
    m_nowPage++;

}

- (void)chooseTap:(UIButton*)btn
{
    AudioListTableViewC * sound = [[AudioListTableViewC alloc]init];
//    [sound.m_allData addObjectsFromArray:m_NextArr[btn.tag-100][@"list"]];
    sound.m_superDic = m_NextArr[btn.tag-100];
    sound.title = m_NextArr[btn.tag-100][@"name"];
    
    [self.view.superview.viewController.navigationController pushViewController:sound animated:YES];
    
}

#pragma mark - UITableView DataSource  And Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _m_allData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = _m_allData[indexPath.section];
    CGSize size = [Common sizeForAllString:dic[@"courseTitle"] andFont:17 andWight:kDeviceWidth-30];
    float h = 170/2+size.height+20;
    
    return h;
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

- (void)showPic:(NSMutableDictionary*)dic withID:(id)cell
{
    //视频状态  0可以观看  1需要测评  2需要解锁   3需要付费
    // 是否免费 0、免费 2、锁定  3、收费
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
#pragma end


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
    
    NSDictionary *head = dic[@"head"];
    if (![head[@"state"] intValue]) {
        NSMutableDictionary *body = dic[@"body"];
        if (!body.count)
        {
            return;
        }
        if ([loader.username isEqualToString:GET_API_CORSELIST])
        {
//            [_m_allData addObjectsFromArray:body[@"list"]];
            m_NextArr =body[@"list"];
//            NSArray * listA = body[@"list"][@"list"];
//            if([listA count] < g_everyPageNum){
//                [self endOfResultList];
//            }
            
            if (m_nowPage==2) {
                [_m_allData removeAllObjects];
                
            }

            NSMutableArray * arr = [NSMutableArray array];
            
            for (NSDictionary * d in body[@"list"]) {
                for (NSDictionary * dd in d[@"list"]) {
                    [arr addObject:dd];
                    [_m_allData addObject:dd];
                }
            }
            if([arr count] < g_everyPageNum){
                [self endOfResultList];
            }
            
            [m_table reloadData];
            [m_headerView removeFromSuperview];
            m_headerView = nil;
            
            m_headerView = [self headerView];
            [m_table setTableHeaderView:m_headerView];
            [self finishRefresh];
            
        }
        else if ([loader.username isEqualToString:URL_POSTREWARD]) {
//            NSDictionary * d= body[@"body"];
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
                
                [m_dicc setObject:[NSNumber numberWithInteger:5] forKey:@"isFree"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end