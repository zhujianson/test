//
//  RedPacketBaseVC.m
//  jiuhaohealth4.2
//
//  Created by jiuhao-yangshuo on 15/12/11.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "RedPacketBaseVC.h"
#import "RedPacketBaseCell.h"

static const float  kRedPacketTableViewH = 40;

@interface RedPacketBaseVC ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation RedPacketBaseVC
@synthesize  isShow;
@synthesize m_dataArray;
@synthesize m_tableView;
@synthesize m_redPacketUseType;

#pragma mark -life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_dataArray = [[NSMutableArray alloc]init];
//        self.title = @"我的跟帖";
        isShow = NO;
    }
    return self;
}

- (void)dealloc
{
    [m_tableView release];
    [m_dataArray release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    m_nowPage = 1;
    [self creatTableView];

//    [self getDataSource];
}

- (void)creatTableView
{
    m_tableView = [[UITableView alloc]
                   initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kRedPacketTableViewH)
                   style:UITableViewStylePlain];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.backgroundColor = [UIColor clearColor];
    [Common setExtraCellLineHidden:m_tableView];
    [self.view addSubview:m_tableView];
    m_tableView.tableHeaderView = [self createheadView];
    m_tableView.separatorColor = [CommonImage colorWithHexString:@"ebebeb"];
    if (IOS_7) {
        [m_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    //创建加载更多
    UIView* footerView = [Common createTableFooter];
    m_tableView.tableFooterView = footerView;
}

-(UIView *)createheadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 10)];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}

- (void)endOfResultList
{
    UILabel *lab = (UILabel*)[m_tableView.tableFooterView viewWithTag:tableFooterViewLabTag];
    lab.text = @"已到底部";
    lab.textColor = [CommonImage colorWithHexString:@"cccccc"];
    lab.frame = CGRectMake(0, 0, kDeviceWidth, 45);
    UIActivityIndicatorView *activi = (UIActivityIndicatorView*)[m_tableView.tableFooterView viewWithTag:tableFooterViewActivityTag];
    [activi removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float cellHeight = kRedPacketCellH;
    return cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_dataArray count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* identifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];
        
    }
//    if (indexPath.row < [m_dataArray count]) {
//        [cell setMessageData:m_dataArray[indexPath.row]];
//    }
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //上拉加载  拖动过程中
    if(m_loadingMore == NO)
    {
        // 下拉到最底部时显示更多数据
        if( !m_loadingMore && scrollView.contentOffset.y >= ( scrollView.contentSize.height - scrollView.frame.size.height - 45) )
        {
            [self getDataSource];
        }
    }
    if (!m_dataArray.count) {
        return;
    }
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    isShow = YES;
}

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    if ([dic[@"head"][@"state"] isEqualToString:@"0000"])
    {
        if ([loader.username isEqualToString:k_GetRedPacketList])
        {
            isShow = YES;
            NSMutableArray *resultList = dic[@"body"][@"topicList"];
            [m_dataArray addObjectsFromArray:resultList];
            if(resultList.count < g_everyPageNum)
            {
                [self endOfResultList];
            }
            else {
                m_loadingMore = NO;
            }
        }
        else
        {
            [Common TipDialog2:dic[@"head"][@"msg"]];
        }
    }
}
@end
