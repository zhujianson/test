//
//  HMHomeViewController.m
//  healthManagement1.0
//
//  Created by jiuhao-yangshuo on 15/10/19.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "HMHomeViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "SettingViewController.h"
#import "BoxListViewController.h"
#import "DiaryModelView.h"
#import "DoctorViewController.h"
#import "ScanDeviceListView.h"
//#import "SteperHomeViewController.h"
#import "HealthNewsListViewController.h"
//#import "ToolsViewController.h"
#import "AccountInformationViewController.h"
#import "DBOperate.h"
//#import "WebViewController.h"
#import "ShowConsultViewController.h"
#import "MsgDBOperate.h"
#import "EScrollerView.h"
#import "NoticeDetailViewController.h"
#import "WalletViewController.h"
#import "PersonalCenterViewController.h"
#import "HomeIndexItemViewController.h"
#import "HomeModel.h"
#import "TopicDetailsViewController.h"
#import "ThinViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "HomeTableViewCell.h"
#import "XHAudioPlayerHelper.h"
#import "KXPayManage.h"
#import "SoundListViewController.h"
#import "FastLoginViewController.h"
#import "VideoDetailViewController.h"
#import "TheAgentViewController.h"
#import "BindAgentViewController.h"
#import "MobClick.h"

static NSString *const kReportTime  = @"kReportTimet";
static NSString *const kNewsTime  = @"kNewsTime";
static NSInteger kImageViewTag  = 1601;
static NSInteger kRedImageViewTag  = 1603;


@interface HMHomeViewController ()<EScrollerViewDelegate,UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate, TableCellDelegate>
{
//    UIScrollView *m_scrollView;
    UIImageView *m_navRedImage;
    UILabel *tipTimeLable;//@"下午好"
    UILabel *tipContent;//@"大雪天要
    UIButton *m_tipImageView;
    
    EScrollerView *m_advScroller;
    NSDictionary *m_dict;
    NSMutableDictionary *m_lastMsgDic;/*聊天消息   徐国洪*/
    BOOL m_refreshScroe; //只是刷新报告内容
    
    float m_viewScale;
    NSMutableArray *m_menusViewArray;
    float kImageHeight;
    UIImageView *m_docRedImage;
    
    CGFloat beforeNewHeight;
    UIView *m_buttonsView;
    
    NSMutableDictionary *m_thinDic;
    EGORefreshTableHeaderView* m_refreshHeaderView;
    UITableView * m_table;
    NSMutableArray * m_allData;
    
    BOOL m_reloading;
    UIView *m_tableHeaderView;//头
    
    UIView *m_navView;
    UIButton *m_butAdd;
}
@property (nonatomic, strong) NSMutableDictionary *m_dicc;
//@property (nonatomic,retain) PanViewRoom *panViewRoom;


//@property (nonatomic,strong) LeftSliderViewController *m_leftView;
@end

@implementation HMHomeViewController
//@synthesize m_leftView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.m_isHideNavBar = 64;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveMesg:) name:@"reciveMesg" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeDataLoad) name:kRfreshHome object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refleshThin) name:@"refleshThin" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMyInformation) name:@"getMyInformation" object:nil];

//        [self createNav];
        
        //导航
        m_navView = [self createNavTitle];
        [self.view addSubview:m_navView];
        
        m_refreshScroe = NO;
        m_viewScale = kRelativity6DeviceWidth;
        m_menusViewArray = [[NSMutableArray alloc] init];
        kImageHeight  = 170;
        self.log_pageID = 1;

    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_allData = [[NSMutableArray alloc] init];
    
    AppDelegate *myDelegate = [Common getAppDelegate];
    myDelegate.navigationVC = self.navigationController;
    
    kImageHeight =  kImageHeight *m_viewScale;
    if (IS_4_INCH_SCREEN)
    {
        kImageHeight -= 11;
    }
    [self createScrollView];
    
    if ([g_nowUserInfo.userToken length])
    {
        [self getMyInfo];
        [self getMyInformation];
    }
    
    [self.view bringSubviewToFront:m_navView];
    
    [self.view bringSubviewToFront:m_butAdd];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[XHAudioPlayerHelper shareInstance] setDelegate:self];
    
    [self refleshTip];
    
    if (IOS_7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[XHAudioPlayerHelper shareInstance] stopAudio];
    [[XHAudioPlayerHelper shareInstance] setDelegate:nil];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (m_advScroller) {
        [m_advScroller startPlayAdv];
    }
}

- (void)refleshTip
{
    if(m_docRedImage)
    {
        m_docRedImage.hidden = !MAX(g_nowUserInfo.doctorMsgCount, 0);
    }
}

- (UIView*)createNavTitle
{
    float height = IOS_7 ? 64 : 44;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, height)];
    view.backgroundColor = [UIColor whiteColor];
    view.alpha = 0;
    
    float y = IOS_7 ? 20 : 0;
    UIImageView *imageTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, 120, 44)];
    imageTitle.center = CGPointMake(kDeviceWidth/2.f, y+22);
    imageTitle.image = [UIImage imageNamed:@"common.bundle/home/homeLogo.png"];
    imageTitle.contentMode = UIViewContentModeCenter;
    [view addSubview:imageTitle];
    
    m_butAdd = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth-55, y, 55, 44)];
    [m_butAdd setImage:[UIImage imageNamed:@"common.bundle/nav/dialiren.png"] forState:UIControlStateNormal];
    [m_butAdd addTarget:self action:@selector(showDailirenVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_butAdd];
    
    return view;
}

- (void)createScrollView
{
    m_table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight+64) style:UITableViewStyleGrouped];
    m_table.dataSource = self;
    m_table.delegate = self;
    m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //分割线颜色
    m_table.separatorColor = [CommonImage colorWithHexString:LINE_COLOR];
    [self.view addSubview:m_table];
    
    m_tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0)];
    m_tableHeaderView.clipsToBounds = YES;
    m_table.tableHeaderView = m_tableHeaderView;
    if (IOS_7) {
        m_table.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 49)];
    footerView.backgroundColor = [UIColor clearColor];
    m_table.tableFooterView = footerView;
    
    m_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -460, kDeviceWidth, 460)];
    m_refreshHeaderView.delegate = self;
    m_refreshHeaderView.backgroundColor = [CommonImage colorWithHexString:@"f2f2f2"];
    [m_table addSubview:m_refreshHeaderView];
}

//创建广告滚动条
- (void)createAdvertising:(NSMutableArray*)array
{
    if (m_advScroller) {
        [m_advScroller setCreatBackViewStr:array];
    }
    else {
        m_advScroller = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, kDeviceWidth, kImageHeight) ImageArray:array isAutoPlay:YES setImageKey:@"img_url"];
        m_advScroller.delegate = self;
        //        m_advScroller.showPageControl = YES;
        [m_tableHeaderView addSubview:m_advScroller];
        
        
        m_tableHeaderView.height = m_advScroller.bottom;
        float height = m_tableHeaderView.bottom;
        
        if (m_buttonsView) {
            m_buttonsView.top = m_advScroller.bottom;
            height = m_buttonsView.bottom;
        }
        
        [self setTableHeaderViewFrame:height];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [m_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    [self.view bringSubviewToFront:m_butAdd];
    
    float alpha = 0;
    
    if (!m_advScroller) {
        alpha = 1;
    }
    else {
        
        float y = m_advScroller.height/2.f;
        float height = m_advScroller.height;
        if (scrollView.contentOffset.y+44 > y && scrollView.contentOffset.y+44 < height) {
            alpha = (scrollView.contentOffset.y+44 - y)/y;
        }
        else if (scrollView.contentOffset.y <= y) {

            alpha = 0;
        }
        else {
            alpha = 1;

        }
    }
    m_navView.alpha = alpha;
}

- (void)setTableHeaderViewFrame:(float)height
{
    m_tableHeaderView.height = height;
    
    m_table.tableHeaderView = m_tableHeaderView;
}

//创建
- (void)createContentView
{
    float viewHight = kImageHeight;
    //创建模板
    [self createViewWithStartX:viewHight];
    
    NSMutableArray *menusArray = m_dict[@"menus"];
    //添加充内容
    [self updateMenusWithArray:menusArray];
    
    [self setTableHeaderViewFrame:m_buttonsView.bottom];
}

- (void)createViewWithStartX:(float)startX
{
    if (m_buttonsView)
    {
        return;
    }
    
    UIView *lineView = nil;
    int num = 4;
    float viewHight = startX;
    
    NSMutableArray *menusArray = m_dict[@"menus"];
    NSMutableArray * m_dataArr = [[NSMutableArray alloc] init];
    [m_dataArr addObjectsFromArray:menusArray];
    [m_dataArr addObject:@""];
    
    CGFloat w,h;
    UIButton * backViewBtn = nil;
    
    UIView *buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHight, kDeviceWidth, 0.1)];
    buttonsView.backgroundColor = [UIColor clearColor];
    m_buttonsView = buttonsView;
    [m_tableHeaderView addSubview:buttonsView];
    
    CGFloat viewW = kDeviceWidth/num;//, viewH = 103.0*m_viewScale;
    CGFloat viewH = 88.f/375*kDeviceWidth;//, viewH = 103.0*m_viewScale;
    
    for (int i = 0; i<MIN(m_dataArr.count+1, 4); i++) {
        h = i%num;
        w = i/num;
        __block UIImageView * imageV;
        backViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        backViewBtn.tag = 100+i;
        backViewBtn.frame = CGRectMake(h * viewW, 0 , viewW, viewH);
        backViewBtn.backgroundColor = [UIColor whiteColor];
        [buttonsView addSubview:backViewBtn];
        
        imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        imageV.center = CGPointMake(backViewBtn.width/2, (backViewBtn.height-20)/2);
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        imageV.tag = kImageViewTag;
        [backViewBtn addSubview:imageV];
        
        [backViewBtn.titleLabel setContentMode:UIViewContentModeCenter];
        [backViewBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [backViewBtn setTitleEdgeInsets:UIEdgeInsetsMake(46, 0, 0.0, 0.0)];
        [backViewBtn setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [backViewBtn setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateHighlighted];
        
        [backViewBtn addTarget:self action:@selector(setJumpEvents:) forControlEvents:UIControlEventTouchUpInside];
        UIImage* HighlenbleImage = [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"f5f5f5"]];
        [backViewBtn setBackgroundImage:HighlenbleImage forState:UIControlStateHighlighted];
        [m_menusViewArray addObject:backViewBtn];
        
        UIImageView *redImage = [[UIImageView alloc]initWithFrame:CGRectMake(imageV.right -2, imageV.top+2, 8, 8)];
        redImage.backgroundColor = [CommonImage colorWithHexString:VERSION_ERROR_TEXT_COLOR];
        redImage.clipsToBounds = YES;
        redImage.tag = kRedImageViewTag;
        redImage.layer.cornerRadius = 4;
        redImage.hidden = YES;
        redImage.backgroundColor = [UIColor redColor];
        [backViewBtn addSubview:redImage];
    }
    
//    int lineNum = (int)(m_dataArr.count-1)/num+1;
//    for (int i = 0; i<lineNum; i++) {
//        lineView  = [[UIView alloc] initWithFrame:CGRectMake(0, backViewBtn.height*i-0.25,kDeviceWidth, 0.5)];
//        lineView.backgroundColor =  [CommonImage colorWithHexString:@"ededed"];
//        [buttonsView addSubview:lineView];
//    }
    
    buttonsView.height = backViewBtn.bottom;
    viewHight = buttonsView.bottom;
    
    viewHight +=  8.0*m_viewScale;
    beforeNewHeight = viewHight;
}

#pragma mark - EGORefreshTableHeaderDelegate
//收起刷新
- (void)finishRefresh
{
    [m_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:m_table];
    m_reloading = NO;
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    if (m_reloading) {
        return;
    }
    m_reloading = YES;
    [self homeDataLoad];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return m_reloading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [m_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
//}

//UIScrollView松开手指
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [m_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - UITableView DataSource  And Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return m_allData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([m_allData[section][@"type"] intValue] == 2) {
        return 47;
    }
    else {
        return 7;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , kDeviceWidth, 47)];
    lineView1.backgroundColor = self.view.backgroundColor;
    if (!m_allData.count) {
        return lineView1;
    }
    if ([m_allData[section][@"type"] intValue] == 2) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 7, kDeviceWidth, 40)];
        view.backgroundColor = [UIColor whiteColor];
        [lineView1 addSubview:view];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15+3+7, 0, kDeviceWidth, 40)];
        titleLabel.textColor = [CommonImage colorWithHexString:@"999999"];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.text = @"健康资讯";
        titleLabel.userInteractionEnabled = YES;
        [view addSubview:titleLabel];
        
        UIView *viewheader = [[UIView alloc] initWithFrame:CGRectMake(15, 27/2, 3, 13)];
        viewheader.backgroundColor = [CommonImage colorWithHexString:The_ThemeColor];
        [view addSubview:viewheader];

        UIButton *butMore = [UIButton buttonWithType:UIButtonTypeCustom];
        butMore.frame = CGRectMake(kDeviceWidth-15-6-26-7, 0, 13*2, 40);
        [butMore setTitle:@"更多" forState:UIControlStateNormal];
        [butMore setTitleColor:[CommonImage colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [butMore addTarget:self action:@selector(butEventMoreNews) forControlEvents:UIControlEventTouchUpInside];
        butMore.titleLabel.font = [UIFont systemFontOfSize:12];
        [view addSubview:butMore];

        UIImageView * rightI = [[UIImageView alloc]initWithFrame:CGRectMake(butMore.right+7, butMore.top, 6, butMore.height)];
        rightI.image = [UIImage imageNamed:@"common.bundle/common/smallR.png"];
//        rightI.backgroundColor = [UIColor redColor];
        rightI.contentMode =  UIViewContentModeCenter;
        [view addSubview:rightI];
        
    }

    return lineView1;
}

- (void)butEventMoreNews
{
    UIStoryboard *healthNewsSB = [UIStoryboard storyboardWithName:@"HealthNews" bundle:nil];
    HealthNewsListViewController *helthNewsVC = [healthNewsSB instantiateViewControllerWithIdentifier:@"HealthNewsList"];
    [self.navigationController pushViewController:helthNewsVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![m_allData[indexPath.section][@"type"] intValue]) {
        NSDictionary * dic = m_allData[indexPath.section][@"data"][indexPath.row];
//        NSDictionary *d;
//        if (dic[@"key"]) {
//            d =[dic[@"key"] objectAtIndex:0];
//        }else{
//            d = dic;
//        }
        CGSize size = [Common sizeForAllString:dic[@"courseTitle"] andFont:17 andWight:kDeviceWidth-30];
        return  170/2+size.height+20;
    }else if([m_allData[indexPath.section][@"type"] intValue]==1){
        return 326/2;
    }
    return 190/2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *sectionArray = m_allData[section][@"data"];
    return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (!m_allData.count) {
//        return nil;
//    }
    if (![m_allData[indexPath.section][@"type"] intValue]) {
        static NSString * cell1= @"cell1";
        SoundTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cell1];
        if (!cell) {
            cell = [[SoundTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                             reuseIdentifier:cell1];
            cell.selectedBackgroundView = [Common creatCellBackView];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            cell.delegate = self;
        }
//        WS(weak)
//        cell.soundBlock = ^(NSDictionary * dic){
//            NSLog(@"%@",dic);
//        };

        if (indexPath.row<[m_allData[indexPath.section][@"data"] count]) {
            NSMutableDictionary * dic = m_allData[indexPath.section][@"data"][indexPath.row];
            
//            NSMutableDictionary *d;
//            if (dic[@"key"]) {
//                d =[dic[@"key"] objectAtIndex:0];
//            }else{
//                d = dic;
//            }
            [cell setSoundInfoWithDic:dic];
        }
        return cell;
    }
    else if([m_allData[indexPath.section][@"type"] intValue] == 1)
    {
        static NSString * cell1= @"cell2";
        VideoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cell1];
        if (!cell) {
            cell = [[VideoTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                             reuseIdentifier:cell1];
            cell.selectedBackgroundView = [Common creatCellBackView];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
        }
        
        WSS(weak)
        cell.videoBlock = ^(NSDictionary *dic, NSString *index){
//            NSLog(@"%d",videoTag);
            [MobClick event:[NSString stringWithFormat:@"home_video_click_%@", index] label:dic[@"courseTitle"]];
            VideoDetailViewController *detail = [[VideoDetailViewController alloc] init];
            detail.m_superDic = (NSMutableDictionary*)dic;
            detail.m_superClass = self;
            detail.index = index;
            [weak.navigationController pushViewController:detail animated:YES];
        };
        
        if (indexPath.row<[m_allData[indexPath.section][@"data"] count]) {
            NSDictionary * dic = m_allData[indexPath.section][@"data"];
            
            [cell setVideoInfoWithDic:dic];
        }
        return cell;
    }else {
        static NSString * cell1= @"cell3";
        HomeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cell1];
        if (!cell) {
            cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                            reuseIdentifier:cell1];
            cell.selectedBackgroundView = [Common creatCellBackView];
        }
        [cell setInformationWithDic:m_allData[indexPath.section][@"data"][indexPath.row]];
        
        return cell;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![m_allData[indexPath.section][@"type"] intValue]) {
//        NSMutableDictionary *dic = m_allData[indexPath.section][@"data"][@"key"][0];
        
    }else if([m_allData[indexPath.section][@"type"] intValue] == 1){
        
    }else if([m_allData[indexPath.section][@"type"] intValue] == 2){
        m_thinDic = nil;
        NSMutableDictionary *dataDic = m_allData[indexPath.section][@"data"][indexPath.row];
//        NSDictionary *dataDic = self.dataList[indexPath.row];
        
        TopicDetailsViewController * top = [[TopicDetailsViewController alloc] init];
        top.m_isHideNavBar = [dataDic[@"transparent"] intValue];
        top.m_dic = dataDic;
        //        top.title = dataDic[@"postName"];
        top.shareTitle = [NSString stringWithFormat:@"【康迅360】- 您值得信赖的健康管理专家 %@",dataDic[@"postName"]];
        top.shareContentString = [NSString stringWithFormat:@"【康迅360】- 您值得信赖的健康管理专家%@",dataDic[@"shareTitle"]];
        [self.navigationController  pushViewController:top animated:YES];
    }
}


- (void)showPic:(NSMutableDictionary*)dic withID:(id)cell
{
    NSLog(@"%@", dic);
    // 是否免费 0、免费 1、收费 2、锁定
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
    }
    else if ([dic[@"isFree"] intValue] == 3) {
        
        self.m_dicc = dic;
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        [dic1 setObject:dic[@"id"] forKey:@"id"];
        [dic1 setObject:kWXAppID forKey:@"appId"];
        [[CommonHttpRequest defaultInstance] sendNewPostRequest:URL_POSTREWARD values:dic1 requestKey:URL_POSTREWARD delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"加载中...", nil)];
    }
    
//    self.log_pageIDs = @"play";
    [MobClick event:@"play" label:dic[@"courseTitle"]];
//    [MobClick event:[NSString stringWithFormat:@"_%d", log_pageID]];

}

#pragma end

//停止播放
- (void)didAudioPlayerStopPlay:(AVAudioPlayer*)audioPlayer
{
    if (!audioPlayer) {
        return;
    }
    XHAudioPlayerHelper *audioPlay = [XHAudioPlayerHelper shareInstance];
    NSMutableDictionary *dic = audioPlay.dicInfo;
    if (dic) {
        [dic setObject:[NSNumber numberWithBool:0] forKey:@"isPlay"];
        
        int section = 0;
        for (NSDictionary *item in m_allData) {
            
            if (![item[@"type"] intValue]) {
                break;
            }
            
            section++;
        }
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:section];
        
//        int index = (int)[m_allData indexOfObject:dic];
        
        SoundTableViewCell *cell = (SoundTableViewCell*)[m_table cellForRowAtIndexPath:index];
        if (cell) {
            [cell.imagePlayView stopAnimating];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event response
//广告点击回调
- (void)touchAdvertising:(NSMutableDictionary*)dic
{
    NSDictionary *dicItem = dic;
    if ([dicItem[@"islink"] boolValue]) {
        //跳转到活动页面
        NoticeDetailViewController *noticeDetailVC = [[NoticeDetailViewController alloc] init];
        noticeDetailVC.m_isHideNavBar = [dicItem[@"transparentYn"] isEqualToString:@"Y"];
        noticeDetailVC.log_pageID = 2;

        NSString *requestURL = dic[@"click_url"];
        NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
        [dicc setObject:requestURL forKey:@"url"];
        noticeDetailVC.m_url = requestURL;
        [dicc setObject:dic[@"isShare"] forKey:@"isShare"];
        [noticeDetailVC setM_dicInfo:dicc];
        noticeDetailVC.shareURL = requestURL;
        noticeDetailVC.titleName = dicItem[@"title"];
        noticeDetailVC.subTitle = dicItem[@"subtitle"];
        noticeDetailVC.newsId = dicItem[@"detailID"];
        [self.navigationController pushViewController:noticeDetailVC animated:YES];
    }
    
//    FastLoginViewController *fast = [[FastLoginViewController alloc] init];
//    [self.navigationController pushViewController:fast animated:YES];
}

- (void)gotoWebViewWithDict:(NSMutableDictionary *)dict
{
    NoticeDetailViewController *noticeDetailVC = ( NoticeDetailViewController *)[HomeIndexItemViewController  fetchViewControllerWithDict:dict];
    if (!noticeDetailVC)
    {
        return;
    }
    [self.navigationController pushViewController:noticeDetailVC animated:YES];
    [HomeModel setNoRedImageWithDict:dict];
}

- (void)updateMenusWithArray:(NSArray *)menusArray
{
    NSInteger count = MIN(menusArray.count+1, m_menusViewArray.count);
    for (NSInteger i = 0 ; i < count;i++)
    {
        UIButton *backViewBtn = m_menusViewArray[i];
        UIImageView *imageV = (UIImageView*)[backViewBtn viewWithTag:kImageViewTag];
        NSDictionary *dict = nil;
//        if (i != count-1)
//        {
            NSInteger index = MIN(i, menusArray.count-1);
            dict = menusArray[index];
            //iconType为1原生应用 根据iconTarget查找本地字典确定应用指向 为2 H5页面 取iconTarget为页面地址
            [CommonImage setImageFromServer:dict[@"imgUrl"] View:imageV Type:2];
            [backViewBtn setTitle:dict[@"iconName"] forState:UIControlStateNormal];
//        }
//        else
//        {
//            imageV.image = [UIImage imageNamed:@"common.bundle/home/homeMore.png"];
//            [backViewBtn setTitle:@"太平送福" forState:UIControlStateNormal];
//            dict = @{};
//        }
        backViewBtn.dicInfo = dict;
        if ([@"question" isEqualToString:dict[@"iconTarget"]])
        {
             UIImageView *redImageV = (UIImageView*)[backViewBtn viewWithTag:kRedImageViewTag];
            m_docRedImage = redImageV;
        }
        [self setHidenRedImageWithShow:[HomeModel isShowRedImageWithDict:dict] withButton:backViewBtn];
    }
}

- (void)setHidenRedImageWithShow:(BOOL)show withButton:(UIButton *)backViewBtn
{
    UIImageView *redImageV = (UIImageView*)[backViewBtn viewWithTag:kRedImageViewTag];
    redImageV.hidden = show;
}

- (void)setJumpEvents:(UIButton *)btn
{
    m_thinDic = nil;
    NSMutableDictionary *dict = btn.dicInfo;
    if (dict &&!dict.count)
    {
        WS(weakSelf);
        HomeIndexItemViewController * wallet = [[HomeIndexItemViewController alloc]init];
        [wallet setKXBlock:^(id content) {
            [weakSelf updateMenusWithArray:content];
        }];
        [self.navigationController pushViewController:wallet animated:YES];
        return;
    }
    else
    {
        int iconType = [dict[@"iconType"] intValue];
        NSString *iconTarget = dict[@"iconTarget"];
        //iconType为1原生应用
        if (iconType == 2)
        {
            if ([iconTarget isEqualToString:@"ThinViewController"]) {
                m_thinDic = dict;
            }
            if ([dict.allKeys containsObject:@"iconName"])
            {
                 [dict setObject:dict[@"iconName"] forKey:kWebTitle];
            }
            [self gotoWebViewWithDict:dict];
            [self setHidenRedImageWithShow:YES withButton:btn];
        }
        else
        {
            NSString *viewC = [HomeModel fetchViewControllerStrWith:iconTarget];
            UIViewController *viewController = [[NSClassFromString(viewC) alloc]init];
            if (viewController)
            {
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }
        return;
    }
}

- (void)refleshThin
{
    if (m_thinDic) {
        [m_thinDic setObject:[NSNumber numberWithInt:1] forKey:@"iconType"];
    }
}

//只是刷新得分
- (void)refreshScore
{
    m_refreshScroe = YES;
    [self getMyInfo];
}

#pragma mark - Set-getUi
- (void)createNav
{
//    self.navigationItem.rightBarButtonItem = [Common createNavBarButton:self setEvent:@selector(showDailirenVC) withNormalImge:@"common.bundle/nav/dialiren.png" andHighlightImge:nil];
//    
//    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
//    imageV.contentMode = UIViewContentModeCenter;
//    imageV.image = [UIImage imageNamed:@"common.bundle/home/homeLogo.png"];
//    self.navigationItem.titleView = imageV;
}

- (void)showDailirenVC
{
    id vc;
    if (g_nowUserInfo.agent_mobile.length) {
        vc = [[TheAgentViewController alloc] init];
    }
    else {
        vc = [[BindAgentViewController alloc] init];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

//获取未读消息
- (void)getMsg
{
    NSString *time = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@boxLastRowTime1", g_nowUserInfo.userid]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:time?time:@"-1" forKey:@"time"];
    [dic setObject:[DiaryModelView getTimeWithKey:@"kLastPostTime"] forKey:@"postTime"];
    [dic setObject:[DiaryModelView getTimeWithKey:@"kLastTime"]  forKey:@"replyTime"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GET_MSG_NOT_READ_COUNT values:dic requestKey:GET_MSG_NOT_READ_COUNT delegate:self controller:self actiViewFlag:0 title:NSLocalizedString(@"加载中...", nil)];
}

- (void)getMyInfo
{
    [g_nowUserInfo setMyBasicInformation:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_Info"]];

    [self homeDataLoad];
}

- (void)homeDataLoad
{
    [[XHAudioPlayerHelper shareInstance] stopAudio];
    
    if (!g_nowUserInfo.userToken) {
        return;
    }
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GET_API_USERIFNO_URL values:dic requestKey:GET_API_USERIFNO_URL delegate:self controller:self actiViewFlag:0 title:NSLocalizedString(@"", nil)];
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
        if ([loader.username isEqualToString:GET_API_USERIFNO_URL])
        {
            [m_allData removeAllObjects];
            
            m_dict = body;
            
            g_nowUserInfo.broadcastNotReadNum = [[body objectForKey:@"brocastCounts"] intValue]; //信箱未读数
            g_nowUserInfo.doctorMsgCount = [[body objectForKey:@"questionCounts"] intValue]; //医生未读数
            g_nowUserInfo.myPlanCounts = [[body objectForKey:@"planCounts"] intValue]; //看健康未读数
//          g_nowUserInfo.myReportCounts = [[body objectForKey:@"reportCounts"] intValue]; //报告未读数
//            [self refreshNoReadRedImage];
            
            [APP_DELEGATE2 setUserID:g_nowUserInfo.userid];
            //公告栏
            NSArray *announcementlist = [body objectForKey:@"list"];
            if (announcementlist.count) {
                
                NSMutableDictionary *dicItem;
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *item in announcementlist) {
                    
                    NSString *detailID = item[@"id"];
                    NSString *img_url = [Common isNULLString3:item[@"img"]];
                    NSString *click_url = [Common isNULLString3:item[@"url"]];
                    NSString *isShare = [HomeModel getShareFromDict:item withKey:@"isShare"];
                    dicItem = [NSMutableDictionary dictionaryWithDictionary:
                               @{@"typestr":@"公告栏",
                                 @"title":[Common isNULLString3: item[@"title"]],
                                 @"img_url":img_url,
                                 @"click_url":click_url,
                                 @"islink": [Common isNULLString3:item[@"islink"]],
                                 @"isShare": isShare,//0 不分享  1：分享
                                 @"detailID":detailID,
                                 @"subtitle":[Common isNULLString3:item[@"content"]]}];
                    [array addObject:dicItem];
                }
                [self createAdvertising:array];
                [self createContentView];
                //音频
                NSMutableDictionary * listDic = [NSMutableDictionary dictionary];
                if ([m_dict[@"audio_list"] count]) {
                    [listDic setObject:@"0" forKey:@"type"];
                    [listDic setObject:m_dict[@"audio_list"] forKey:@"data"];
                    [m_allData addObject:listDic];
                }
//                视频
                if ([m_dict[@"video_list"] count]) {
                    listDic = [NSMutableDictionary dictionary];
                    [listDic setObject:@"1" forKey:@"type"];
                    [listDic setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:m_dict[@"video_list"],@"key", nil] forKey:@"data"];
                    [m_allData addObject:listDic];
                }
//                资讯
                if ([m_dict[@"newsList"] count]) {
                    listDic = [NSMutableDictionary dictionary];
                    [listDic setObject:@"2" forKey:@"type"];
                    [listDic setObject:m_dict[@"newsList"] forKey:@"data"];
                    [m_allData addObject:listDic];

                }
                [m_table reloadData];
                [self finishRefresh];

//                if (!m_leftView)
//                {
//                    m_leftView = [PersonalCenterViewController showLeftSliderViewControllerWithMainViewController:self];
//                }
            }
            
        }else if ([loader.username isEqualToString:LOGIN_API_URL])
        {
            g_nowUserInfo = [Common initWithUserInfoDict:body];
            [self getMyInfo];
            [self getMyInformation];
//            [self getMsg];
        }
        else if ([loader.username isEqualToString:GET_MSG_NOT_READ_COUNT])
        {
            NSDictionary * body = dic[@"body"];
            g_nowUserInfo.broadcastNotReadNum = [[body objectForKey:@"brocastCounts"] intValue]; //信箱未读数
            g_nowUserInfo.myMessageNoReadNum = [[body objectForKey:@"unread_comment"] intValue]; //评论未读数
            g_nowUserInfo.totalunreadMsgCount = [[body objectForKey:@"unread_friend"] intValue]; //总未读数
            g_nowUserInfo.doctorMsgCount = [[body objectForKey:@"unread_doctor"] intValue]; //医生未读数
            g_nowUserInfo.friendMsgCount = [[body objectForKey:@"friendMsgCount"] intValue]; //糖友未读数
            g_nowUserInfo.myPostNotRead = [[body objectForKey:@"my_post_not_read"] intValue]; //我的帖子未读总数量
            g_nowUserInfo.myThreadNotRead = [[body objectForKey:@"my_thread_not_read"] intValue]; //我的跟帖未读总数量
            g_nowUserInfo.integral = [body[@"points_available"] intValue];
//            [self refreshNoReadRedImage];
        }
        else if ([loader.username isEqualToString:GETMYINFO_API_URL])
        {
            [g_nowUserInfo setMyBasicInformation:[dic objectForKey:@"body"][@"user_info"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getWallet" object:nil];
        }
        else if ([loader.username isEqualToString:URL_POSTREWARD]) {
//            NSMutableDictionary *d= body;
            if (![body[@"rewardStatus"] intValue]) {
                [self.m_dicc setObject:[NSNumber numberWithInteger:5] forKey:@"isFree"];
                
                
                int section = 0;
                for (NSDictionary *item in m_allData) {
                    
                    if (![item[@"type"] intValue]) {
                        break;
                    }
                    
                    section++;
                }
                
                
                NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:section];
                UITableViewCell *cell = [m_table cellForRowAtIndexPath:index];
                [self showPic:self.m_dicc withID:cell];
                [m_table reloadData];
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
                
                [self.m_dicc setObject:[NSNumber numberWithInteger:5] forKey:@"isFree"];
                int section = 0;
                for (NSDictionary *item in m_allData) {
                    
                    if (![item[@"type"] intValue]) {
                        break;
                    }
                    
                    section++;
                }
                
                
                NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:section];
                UITableViewCell *cell = [m_table cellForRowAtIndexPath:index];
                [self showPic:self.m_dicc withID:cell];
//                [m_table reloadData];
                
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
    
    [self.m_dicc setObject:[NSNumber numberWithInteger:5] forKey:@"isFree"];
    int section = 0;
    for (NSDictionary *item in m_allData) {
        
        if (![item[@"type"] intValue]) {
            break;
        }
        
        section++;
    }
    
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:section];
    UITableViewCell *cell = [m_table cellForRowAtIndexPath:index];
    [self showPic:self.m_dicc withID:cell];
    
    [[KXPayManage sharePayEngine] setUpNilBlock];
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    if ([loader.username isEqualToString:GETMYINFO_API_URL])
    {
        [g_nowUserInfo setMyBasicInformation:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_Info"]];
        [APP_DELEGATE2 setUserID:g_nowUserInfo.userid];
    }
}

#pragma mark - PrivateMethod

- (void)getMyInformation
{
    //获取个人信息
    NSMutableDictionary* dic1 = [NSMutableDictionary dictionary];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GETMYINFO_API_URL values:dic1 requestKey:GETMYINFO_API_URL delegate:self controller:self actiViewFlag:0 title:NSLocalizedString(@"登录中...", nil)];
}
@end
