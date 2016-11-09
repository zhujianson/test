//
//  ScoreRewardsViewController.m
//  jiuhaohealth2.1
//
//  Created by jiuhao-yangshuo on 14-12-3.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "ScoreRewardsViewController.h"
#import "ScoreRewardsCell.h"
#import "WebViewController.h"

@interface ScoreRewardsViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ScoreRewardsViewController
{
     UITableView *scoreRewadsListTableView;
      NSMutableArray *m_arrayList;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"积分奖励";
         m_arrayList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)dealloc
{
    [scoreRewadsListTableView release];
    [m_arrayList release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createTablewView];
    [self getDataSource];
    self.navigationItem.rightBarButtonItem = [Common CreateNavBarButton3:self setEvent:@selector(goToNext) setTitle:@"说明"];

//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"说明 " style:UIBarButtonItemStylePlain target:self action:@selector(goToNext)];
//    self.navigationItem.rightBarButtonItem = right;
//    [right release];

//    UIBarButtonItem *rightButtonItem = [Common CreateNavBarButton:self setEvent:@selector(goToNext) setImage:@"common.bundle/nav/m_help.png" setTitle:nil];
////    UIBarButtonItem *rightButtonItem = [Common createNavBarButton:self setEvent:@selector(goToNext) withNormalImge:];
//    self.navigationItem.rightBarButtonItem = rightButtonItem;

    // Do any additional setup after loading the view.
}

-(void)createTablewView
{
    scoreRewadsListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    scoreRewadsListTableView.dataSource = self;
    scoreRewadsListTableView.delegate = self;
    scoreRewadsListTableView.backgroundColor = [UIColor clearColor];
    scoreRewadsListTableView.separatorColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
    [self.view addSubview:scoreRewadsListTableView];
    
    UIView *footerView = [self createFooterView];
    scoreRewadsListTableView.tableFooterView = footerView;
}

- (void)goToNext
{
	NSLog(@"xiayi bu");
    
    WebViewController *help = [[WebViewController alloc] init];
    //    help.isUrl = YES;
    help.m_url = HEALP_SERVER_POINTDES;
    help.title = @"积分说明";
    [self.navigationController pushViewController:help animated:YES];
    [help release];
}

- (void)goToScore
{
    
//    WalletWebView * wallet = [[WalletWebView alloc]init];
//    wallet.title = @"积分商城";
//    NSString *requestURL;
//    NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
//    requestURL = [NSString stringWithFormat:@"http://wx.kangxun360.com/static/points/index.html?token=%@",g_nowUserInfo.userToken];
//    [dicc setObject:requestURL forKey:@"url"];
//    [dicc setObject:@"0" forKey:@"isShare"];
//    wallet.m_url = requestURL;
//    [wallet setM_dicInfo:dicc];
//    [self.navigationController pushViewController:wallet animated:YES];
//    [wallet release];
}


-(UIView *)createFooterView
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 450/2)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lineLabels = [Common createLabel:CGRectMake(0, 0, kDeviceWidth, 10) TextColor:nil Font:nil textAlignment:NSTextAlignmentCenter labTitle:nil];
    lineLabels.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR];
    
    [footerView addSubview:lineLabels];
    
    UILabel *lineLabel = [Common createLabel:CGRectMake(15, 0, kDeviceWidth-15, 0.5) TextColor:nil Font:nil textAlignment:NSTextAlignmentCenter labTitle:nil];
    lineLabel.backgroundColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
    [footerView addSubview:lineLabel];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToScore)];
    [footerView addGestureRecognizer:tap];
    [tap release];
    
    
//    UILabel *knowScoreDetail = [Common createLabel:CGRectMake(kDeviceWidth-20-200, 20, 200, 18) TextColor:@"999999" Font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentRight labTitle:@"了解详细积分规则"];
//    [footerView addSubview:knowScoreDetail];
    
//    UIButton * taskButtonTop = [UIButton buttonWithType:UIButtonTypeCustom];
//    taskButtonTop.frame = CGRectMake(20, knowScoreDetail.bottom+45,kDeviceWidth-40, 35);
//    taskButtonTop.clipsToBounds = YES;
//    taskButtonTop.layer.borderWidth = 0.5;
//    taskButtonTop.layer.borderColor = [CommonImage colorWithHexString:@"#1bc0c0"].CGColor;
//    taskButtonTop.layer.cornerRadius = 4;
////    [taskButton addTarget:self action:@selector(registeredPWDEvent) forControlEvents:UIControlEventTouchUpInside];
//    [taskButtonTop setTitle:NSLocalizedString(@"做任务有什么", nil) forState:UIControlStateNormal];
//    taskButtonTop.titleLabel.font = [UIFont systemFontOfSize:15];
//    [taskButtonTop setTitleColor:[CommonImage colorWithHexString:@"#1bc0c0"]forState:UIControlStateNormal];
//    [footerView addSubview:taskButtonTop];

    NSArray *noremalImgeArrays = @[@"common.bundle/scoreMall/shop_icon_task.png",@"common.bundle/scoreMall/shop_icon_money.png",@"common.bundle/scoreMall/shop_icon_commodity.png"];
    NSArray *titleArrays = @[@"做任务",@"赚积分",@"换商品"];
    NSArray *titleColorArrays = @[@"fea94c",@"ff6969",@"11bbe6"];
    float leftWeight = (kDeviceWidth-50*noremalImgeArrays.count-55*(noremalImgeArrays.count-1))/2;
    leftWeight = 30;
    float spaceWeight = (kDeviceWidth-50*noremalImgeArrays.count-2*leftWeight)/(noremalImgeArrays.count-1);
//    spaceWeight = 55;
    UILabel *lineLabelMidlle = [Common createLabel:CGRectMake(20, 40, kDeviceWidth-40, 0.5) TextColor:nil Font:nil textAlignment:NSTextAlignmentCenter labTitle:nil];

    lineLabelMidlle.backgroundColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
    [footerView addSubview:lineLabelMidlle];
    

    UILabel *taskNameDetail = [Common createLabel:CGRectMake(0,lineLabelMidlle.bottom-9, 140, 18) TextColor:@"666666" Font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter labTitle:@"做任务有什么用?"];
    taskNameDetail.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:taskNameDetail];
    taskNameDetail.center = CGPointMake(footerView.center.x, taskNameDetail.center.y);
    
    UIButton *taskBtn = nil;
    UILabel *labTitle = nil;
    for (int i = 0; i < noremalImgeArrays.count; i++) {
        UIImage *indexImge = [UIImage imageNamed:noremalImgeArrays[i]];
        taskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        taskBtn.frame = CGRectMake(leftWeight+i*(indexImge.size.width+spaceWeight), taskNameDetail.bottom+19, indexImge.size.width,indexImge.size.height);
        taskBtn.tag = 100+i;
        [taskBtn setImage:indexImge forState:UIControlStateNormal];
//       [taskBtn addTarget:self action:@selector(butEventTool:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:taskBtn];
        
        labTitle = [Common createLabel:CGRectMake(0, taskBtn.height+ 10, taskBtn.width, 18) TextColor:[titleColorArrays objectAtIndex:i] Font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter labTitle:titleArrays[i]];
        [taskBtn addSubview:labTitle];
        taskBtn.tag = i+100;
        taskBtn.userInteractionEnabled = NO;
        
        [footerView addSubview:taskBtn];
        if (i != 2)
        {
            UIImage *imgeNext = [UIImage imageNamed:@"common.bundle/scoreMall/shop_icon_next.png"];
            UIImageView *nextImge = [[UIImageView alloc]initWithImage:imgeNext];
            nextImge.frame = CGRectMake(taskBtn.width+(spaceWeight-imgeNext.size.width)/2.0, (taskBtn.height-imgeNext.size.height)/2, imgeNext.size.width, imgeNext.size.height);
            [taskBtn addSubview:nextImge];
            [nextImge release];
        }
    }
    //上下间距一致
    footerView.frameHeight = taskBtn.bottom + 28 +taskNameDetail.frameY;
    return [footerView autorelease];
}

- (void)getDataSource
{
    NSMutableDictionary *requestDic = [[NSMutableDictionary alloc] initWithCapacity:0];
//    [requestDic setValue:g_nowUserInfo.userid forKey:@"uid"];
//     [requestDic setValue:@"11035c6c381c45f89927aa10f7566dcc" forKey:@"uid"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:URL_getPointDailyTasks values:requestDic requestKey:URL_getPointDailyTasks delegate:self controller:self actiViewFlag:1 title:nil];
    [requestDic release];
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    NSDictionary *head = [dic objectForKey:@"head"];
    if (![[head objectForKey:@"state"] intValue])
    {
        NSDictionary *body = [dic objectForKey:@"body"];
        if ([loader.username isEqualToString:URL_getPointDailyTasks]){
            NSArray *array = [body objectForKey:@"list"];
            if (array.count) {
                [m_arrayList removeAllObjects];
                [m_arrayList addObjectsFromArray:array];
                [scoreRewadsListTableView reloadData];
            }
        }
        else {
            if (!dic) {
                [Common TipDialog:NSLocalizedString(@"网络异常", nil)];
                return;
            }
        }
    }
    else
         [Common TipDialog:[dic objectForKey:@"msg"]];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 50)];
//    sectionView.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR];
    sectionView.backgroundColor =[UIColor whiteColor];
    
    UILabel *taskName = [Common createLabel:CGRectMake(15, 0, kDeviceWidth - 185, 50) TextColor:@"333333" Font:[UIFont systemFontOfSize:16.0] textAlignment:NSTextAlignmentLeft labTitle:@"每日任务"];
//	taskName.backgroundColor = [UIColor redColor];
    [sectionView addSubview:taskName];
    
	UILabel *taskFinish = [Common createLabel:CGRectMake(taskName.right, 0, 80, 50) TextColor:@"333333" Font:[UIFont systemFontOfSize:16.0] textAlignment:NSTextAlignmentCenter labTitle:@"完成情况"];
//	taskFinish.backgroundColor = [UIColor yellowColor];
    [sectionView addSubview:taskFinish];
    
	UILabel *taskScore = [Common createLabel:CGRectMake(kDeviceWidth-15-35, 0, 35, 50) TextColor:@"333333" Font:[UIFont systemFontOfSize:16.0] textAlignment:NSTextAlignmentRight labTitle:@"奖励"];
//	taskScore.backgroundColor = [UIColor blueColor];
    [sectionView addSubview:taskScore];

    UIImage *imgeScore = [UIImage imageNamed:@"common.bundle/scoreMall/shop_icon_detil.png"];
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(taskScore.left-20, 15, 20, 20)];
    image.image = imgeScore;
    [sectionView addSubview:image];
    [image release];
    
    UILabel *lineLabel = [Common createLabel:CGRectMake(0, 49.5, kDeviceWidth, 0.5) TextColor:nil Font:nil textAlignment:NSTextAlignmentCenter labTitle:nil];
    lineLabel.backgroundColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
    [sectionView addSubview:lineLabel];

    return [sectionView autorelease];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"newsCell";
    ScoreRewardsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[ScoreRewardsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dataDic = [m_arrayList objectAtIndex:indexPath.row];
    [cell setFillContentWithDict:dataDic];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_arrayList.count;
}

@end
