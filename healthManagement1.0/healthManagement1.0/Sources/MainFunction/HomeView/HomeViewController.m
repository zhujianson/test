
#import "HomeViewController.h"
#import "CommonHttpRequest.h"
#import "CheckSugarViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NewsDeatilViewController.h"
#import "HomeTableViewCell.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "DBOperate.h"
//#import "OneExpertViewController.h"
#import "TopicDetailsViewController.h"
#import "NoticeDetailViewController.h"
#import "ScoreRewardsViewController.h"
//#import "QuickAddWeight.h"
#import "PerfectViewController.h"
#import "ToolsViewController.h"
//#import "BoolSugarVC.h"
#import "WebViewController.h"
#import "Mealtime.h"
#import "SteperHomeViewController.h"
//#import "FriendListTableView.h"
#import "UIImageView+WebCache.h"
#import "GlideTooltip.h"
#import "DoctorListViewController.h"

@interface HomeViewController () <HomeTVCDelegate>
{
    NSMutableDictionary *m_todayDic;
    
    UIView *m_jifenView;
    UIView *m_headerbutView;
    UIView *m_tableHeaderView;
}

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"首页";
        self.log_pageID = 11;
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
        imageV.contentMode = UIViewContentModeCenter;
        imageV.image = [UIImage imageNamed:@"common.bundle/home/logo.png"];
        self.navigationItem.titleView = imageV;
        [imageV release];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataBegin) name:@"loadDataBegin" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refleshTip) name:@"refleshTip" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationToday) name:@"notificationToday" object:nil];
		
        [self reStartAlert];
        
        int num = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"xinshouzhinan_%@",g_nowUserInfo.userid]] intValue];
        if (num < 4) {
            [[NSUserDefaults standardUserDefaults] setObject:@(num+1) forKey:[NSString stringWithFormat:@"xinshouzhinan_%@",g_nowUserInfo.userid]];
        }
    }
    return self;
}

//二维码
- (void)butEventPersonal
{
}

- (void)prepAudio:(int)num
{
    int isPlay = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"lastPlayNum_%@", g_nowUserInfo.userid]] intValue];
//    if (num <= isPlay) {
//        return;
//    }
    if (num > isPlay) {
        SystemSoundID soundID = 0;
//        NSURL* fileURL = [[NSBundle mainBundle] URLForResource:@"alert1.caf" withExtension:nil];
        NSString *mainBundlPath = [[NSBundle mainBundle] bundlePath];
        NSString *filePath =[mainBundlPath stringByAppendingPathComponent:@"common.bundle/mp3/alert1.caf"];
        
        NSURL* fileURL =  [NSURL fileURLWithPath:filePath];
        
        if (fileURL != nil) {
            SystemSoundID theSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &theSoundID);
            if (error == kAudioServicesNoError) {
                soundID = theSoundID;
            } else {
                NSLog(@"Failed to create sound ");
            }
        }
        AudioServicesPlaySystemSound(soundID);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:num] forKey:[NSString stringWithFormat:@"lastPlayNum_%@", g_nowUserInfo.userid]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)getAllFile
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString *path = @"/System/Library/Audio/UISounds/SMS";
    NSError *error = nil;
    NSArray * tempFileList = [[[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:path error:&error]] autorelease];
    //     AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1106);
    NSLog(@"%@++++++%@",tempFileList,error);
}

- (void)reloadUnMsgNum
{
//    int num = g_nowUserInfo.broadcastNotReadNum + g_nowUserInfo.warningNotReadNum;
//    if (num>0) {
//        m_viewu.hidden = NO;
//        [self prepAudio:num];
//    }
//    else {
//        m_viewu.hidden = YES;
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.view.backgroundColor = [CommonImage colorWithHexString:@"f5f5f5"];
    
    m_array = [[NSMutableArray alloc] init];
	m_sequenceArray  = [[NSMutableArray alloc] init];
    
//	m_OperationQueue = [[IconOperationQueue alloc] init];
//	[m_OperationQueue setM_arrayList:m_array];
//    m_OperationQueue.delegate = self;
//    m_OperationQueue.arrayScetion = @"array";
//    m_OperationQueue.imageKey = @"img_url";
//    m_OperationQueue.pathSuffix = @"?imageView2/1/w/540/h/300";
    
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStyleGrouped];
    m_tableView.backgroundColor = [UIColor clearColor];
    UIView *viewBackground = [[UIView alloc] initWithFrame:CGRectZero];
    viewBackground.backgroundColor = self.view.backgroundColor;
    m_tableView.backgroundView = viewBackground;
    [viewBackground release];
    m_tableView.separatorColor = [CommonImage colorWithHexString:LINE_COLOR];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.showsHorizontalScrollIndicator = NO;
    m_tableView.showsVerticalScrollIndicator = NO;
    UIView *viewheaer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 107)];
    viewheaer.backgroundColor = [UIColor clearColor];
    m_tableView.tableHeaderView = viewheaer;
    [viewheaer release];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 49)];
    m_tableView.tableFooterView = footerView;
    [footerView release];
    [self.view addSubview:m_tableView];
    
    m_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -460, kDeviceWidth, 460)];
    m_refreshHeaderView.delegate = self;
    m_refreshHeaderView.backgroundColor = self.view.backgroundColor;
    [m_tableView addSubview:m_refreshHeaderView];
	[m_refreshHeaderView egoRefreshScrollViewDidScroll:m_tableView];
	[m_refreshHeaderView egoRefreshScrollViewDidEndDragging:m_tableView];
    
    [self createHeaderView];
	m_tableHeaderView = [[UIView alloc] initWithFrame:m_headerbutView.bounds];
    m_tableHeaderView.backgroundColor = [UIColor whiteColor];
    [m_tableHeaderView addSubview:m_headerbutView];
    m_tableView.tableHeaderView = m_tableHeaderView;
    [m_tableHeaderView release];
    
    UIView *lineTop = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, kDeviceWidth, 0.5)];
    lineTop.backgroundColor = m_tableView.separatorColor;
    [m_tableHeaderView addSubview:lineTop];
    [lineTop release];
    
    UIView *lineBotton = [[UIView alloc] initWithFrame:CGRectMake(0, m_tableHeaderView.height-0.5, kDeviceWidth, 0.5)];
    lineBotton.tag = 1345;
    lineBotton.backgroundColor = m_tableView.separatorColor;
    [m_tableHeaderView addSubview:lineBotton];
    [lineBotton release];
    
//    CalculatorInputView *ca = [[CalculatorInputView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) withDelegate:self];
//    [self.view addSubview:ca];
//    ca.frame = CGRectMake(100, 100, 260, 150);
    
    if (g_nowUserInfo.channel && g_nowUserInfo.channel.length) {
        
        GlideTooltipModel *model = [[GlideTooltipModel alloc] init];
        model.title = [NSString stringWithFormat:@"%@用户，您好，康迅360与你同行。", g_nowUserInfo.channel];
        model.view = self.view;
        model.key = @"HomeViewControllerCount";
        [GlideTooltip showInView:model];
    }
}

/**
 *  观察属性变化
 *
 *  @param keyPath
 *  @param object
 *  @param change
 *  @param context
 */

- (void)viewWillAppear:(BOOL)animated
{
//    if (IOS_7) {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    }
    self.navigationController.navigationBarHidden = NO;
//    [self reloadUnMsgNum];
    [super viewWillAppear:animated];
    
    long nowTime = [CommonDate getLongTime];
    if (nowTime - m_lastShowTime > 20*60) {
        
        [self loadDataBegin];
        
        m_lastShowTime = nowTime;
    }
    
    [self refleshTip];
}

- (void)refleshTip
{
    UIView * tip = (UIView*)[self.view viewWithTag:200];
    tip.hidden = !g_nowUserInfo.doctorMsgCount;
    
    
//    int count = [[DBOperate shareInstance] getNoReadCount];
//    
//    m_navRedImage.hidden = !MAX(count + g_nowUserInfo.broadcastNotReadNum, 0);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (m_advScroller) {
        [m_advScroller startPlayAdv];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (m_advScroller) {
        [m_advScroller pausePlayAdv];
    }

}

//创建广告滚动条
- (void)createAdvertising:(NSMutableArray*)array
{
    if (m_advScroller) {
        [m_advScroller setCreatBackViewStr:array];
    }
    else {
        m_advScroller = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, kDeviceWidth, 110*kDeviceWidth/375) ImageArray:array isAutoPlay:YES setImageKey:@"img_url"];//pathSuffix:[NSString stringWithFormat:@"?imageView2/1/w/%d/h/%d", 640, 360]
        m_advScroller.delegate = self;
        [m_tableHeaderView addSubview:m_advScroller];
        
        m_headerbutView.frame = [Common rectWithOrigin:m_headerbutView.frame x:0 y:m_advScroller.bottom];
        float height = m_headerbutView.bottom;
        
        if (m_jifenView) {
            m_jifenView.frame = [Common rectWithOrigin:m_jifenView.frame x:0 y:m_headerbutView.bottom];
            height = m_jifenView.bottom;
        }
        
        [self setTableHeaderViewFrame:height];
    }
}

//广告点击回调
- (void)touchAdvertising:(NSMutableDictionary*)dic
{
    NSDictionary *dicItem = dic;
    
    if ([dicItem[@"islink"] boolValue]) {
        
        //跳转到活动页面
        NoticeDetailViewController *noticeDetailVC = [[NoticeDetailViewController alloc] init];
        
        noticeDetailVC.m_isHideNavBar = [dicItem[@"transparentYn"] isEqualToString:@"Y"];
        
//        NSString *requestURL = [NSString stringWithFormat:@"%@operation/activity/%@.html?id=%@",NOTICE_DETAIL_URL, [dicItem objectForKey:@"detailID"], g_nowUserInfo.userid];
        NSString *requestURL = dic[@"click_url"];
        NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
        [dicc setObject:requestURL forKey:@"url"];
        noticeDetailVC.m_url = requestURL;
        [dicc setObject:@"1" forKey:@"isShare"];
        [noticeDetailVC setM_dicInfo:dicc];
        noticeDetailVC.shareURL = requestURL;
        noticeDetailVC.titleName = dicItem[@"title"];
        noticeDetailVC.subTitle = dicItem[@"subtitle"];
        noticeDetailVC.newsId = dicItem[@"detailID"];
        [self.navigationController pushViewController:noticeDetailVC animated:YES];
        [noticeDetailVC release];
    }
}

//创建头
- (void)createHeaderView
{
    m_headerbutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 104)];
    m_headerbutView.clipsToBounds = YES;
    m_headerbutView.tag = 90;
    m_headerbutView.backgroundColor = [UIColor whiteColor];
    
    NSArray *array = [NSArray arrayWithObjects:
                      @{@"image":@"common.bundle/home/quick/bloodSugar", @"title":@"记血糖"},
                      @{@"image":@"common.bundle/home/quick/sport", @"title":@"爱运动"},
                      @{@"image":@"common.bundle/home/quick/tool", @"title":@"工具箱"},
                      @{@"image":@"common.bundle/home/quick/yiyou", @"title":@"问医生"},
                      nil];
    NSDictionary *dic;
    UIButton *but;
    CGRect rect;
    for (int i = 0; i < 4; i++) {
        dic = [array objectAtIndex:i];
        but = [self createLnkToolsItem:dic];
        but.tag = i+100;
        rect = but.frame;
        rect.origin.x = i*kDeviceWidth/4;
        but.frame = rect;
        [m_headerbutView addSubview:but];
        if (i == 3) {
            UIImage *redHeartImageContent = [UIImage imageNamed:@"common.bundle/topic/conversation_icon_redpoint.png"];
            UIImageView *redHeartImage = [[UIImageView alloc]initWithFrame:CGRectMake(but.width/2+14, but.height/2-34, 12, 12)];
            redHeartImage.tag = 200;
            redHeartImage.hidden = YES;
            redHeartImage.image = redHeartImageContent;
            [but addSubview:redHeartImage];
            [redHeartImage release];
        }
    }
//    UIView *lin = [[UIView alloc] initWithFrame:CGRectMake(0, 106.5, kDeviceWidth, 0.5)];
//    lin.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
//    [m_headerbutView addSubview:lin];
//    [lin release];
}

//头Item
- (UIButton*)createLnkToolsItem:(NSDictionary*)dic
{
    NSString *image = [dic objectForKey:@"image"];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
//	but.imageView.clipsToBounds = NO;
    but.frame = CGRectMake(0, 0, ceil(kDeviceWidth/4), 107);
    NSString *title = [dic objectForKey:@"title"];
    [but setTitle:title forState:UIControlStateNormal];
    [but setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
//    but.titleLabel.font = [UIFont systemFontOfSize:14];
    but.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:14];
    [but setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_n.png", image]] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_p.png", image]] forState:UIControlStateHighlighted];
    [but addTarget:self action:@selector(butEventLnkToolsItem:) forControlEvents:UIControlEventTouchUpInside];
    CGSize size = but.currentImage.size;
    [but setTitleEdgeInsets:UIEdgeInsetsMake(28, -size.width, -28, 0)];
    [but setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 10, -[title sizeWithFont:but.titleLabel.font].width)];
    
    return but;
}

//积分奖励
- (void)createQiandao:(NSMutableDictionary*)dic
{
    if (!m_jifenView) {
        
        m_jifenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 46)];
        m_jifenView.tag = 91;
        m_jifenView.clipsToBounds = YES;
        m_jifenView.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];
//        [m_jifenView addTarget:self action:@selector(showJifen) forControlEvents:UIControlEventTouchDragInside];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showJifen)];
        [m_jifenView addGestureRecognizer:tap];
        [tap release];
        
        UIButton *but = (UIButton*)[m_headerbutView viewWithTag:103];
        float x = (but.width - 50)/2.f;
        
        UILabel *labTitle = [Common createLabel];
        labTitle.frame = CGRectMake(x, 5, 75, 18);
        labTitle.textColor = [CommonImage colorWithHexString:@"333333"];
        labTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:14];
        labTitle.text = @"积分奖励";
        [m_jifenView addSubview:labTitle];
        
        UIView *viewB = [[UIView alloc] initWithFrame:CGRectMake(labTitle.right, (labTitle.bottom-5)/2.f+2, kDeviceWidth - labTitle.right - 50 - x - 50, 5)];
        viewB.tag = 1202;
        viewB.backgroundColor = [CommonImage colorWithHexString:@"e5e5e5"];
        [m_jifenView addSubview:viewB];
        
        UIView *viewWancheng = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 5)];
        viewWancheng.tag = 1201;
        viewWancheng.backgroundColor= [CommonImage colorWithHexString:@"2fcd58"];
        [viewB addSubview:viewWancheng];
        [viewWancheng release];
        
        UILabel *labQuanbu = [Common createLabel];
        labQuanbu.tag = 1203;
        labQuanbu.textAlignment = NSTextAlignmentCenter;
        labQuanbu.frame = CGRectMake(viewB.right, labTitle.top, 50, labTitle.height);
        labQuanbu.textColor = [CommonImage colorWithHexString:@"999999"];
        labQuanbu.font = [UIFont systemFontOfSize:12];
        [m_jifenView addSubview:labQuanbu];
        [labQuanbu release];
        
        UIButton *butQiandao = [UIButton buttonWithType:UIButtonTypeCustom];
        butQiandao.tag = 1200;
        butQiandao.frame = CGRectMake(but.left+x, 1, 50, 26);
        butQiandao.layer.cornerRadius = 3;
        butQiandao.clipsToBounds = YES;
        butQiandao.layer.borderColor = [CommonImage colorWithHexString:@"c8c8c8"].CGColor;
        butQiandao.layer.borderWidth = 0.5;
        [butQiandao setBackgroundImage:[CommonImage createImageWithColor:[CommonImage colorWithHexString:@"cccccc"]] forState:UIControlStateHighlighted];
        butQiandao.titleLabel.font = [UIFont systemFontOfSize:13];
        [butQiandao setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [butQiandao addTarget:self action:@selector(butEventQiandao) forControlEvents:UIControlEventTouchUpInside];
        [m_jifenView addSubview:butQiandao];
        
        [m_tableHeaderView addSubview:m_jifenView];
        [m_jifenView release];
    }
    
    m_jifenView.frame = [Common rectWithOrigin:m_jifenView.frame x:0 y:m_headerbutView.bottom];
    [self setTableHeaderViewFrame:m_jifenView.bottom];
    
    [self setJifenDic:dic];
}

- (void)showJifen
{
    ScoreRewardsViewController *score = [[ScoreRewardsViewController alloc] init];
    [self.navigationController pushViewController:score animated:YES];
    [score release];
}

- (void)setTableHeaderViewFrame:(float)height
{
    m_tableHeaderView.frame = [Common rectWithSize:m_tableHeaderView.frame width:kDeviceWidth height:height];
    UIView *lineBotton = [m_tableHeaderView viewWithTag:1345];
    lineBotton.frame = [Common rectWithOrigin:lineBotton.frame x:0 y:m_tableHeaderView.height];
    m_tableView.tableHeaderView = m_tableHeaderView;
//    [m_tableHeaderView release];
}

- (void)setJifenDic:(NSMutableDictionary*)dic
{
    int completeNum = [[dic objectForKey:@"completeNum"] intValue];
    int sum = [[dic objectForKey:@"sum"] intValue];
    
    UIButton *butQiandao = (UIButton*)[m_jifenView viewWithTag:1200];
    butQiandao.enabled = YES;
    [butQiandao setTitle:@"签到" forState:UIControlStateNormal];
    if ([[dic objectForKey:@"registration"] boolValue]) {
        [butQiandao setTitle:@"已签到" forState:UIControlStateNormal];
        butQiandao.enabled = NO;
    }
    
    UIView *viewWancheng = [m_jifenView viewWithTag:1201];
    UIView *viewB = [m_jifenView viewWithTag:1202];
    CGRect rect = viewWancheng.frame;
    rect.size.width = sum ? viewB.width/sum*(MIN(completeNum,sum)) : viewB.width;
//     rect.size.width = sum ? viewB.width/sum*completeNum : viewB.width;
    viewWancheng.frame = rect;
        
    NSString *weiwancheng = [NSString stringWithFormat:@"%d/%d", completeNum, sum];
    UILabel *labQuanbu = (UILabel*)[m_jifenView viewWithTag:1203];
    labQuanbu.attributedText = [self replaceRedColorWithNSString:weiwancheng andUseKeyWord:[NSString stringWithFormat:@"%d",completeNum] andWithFontSize:17 TextColor:@"2fcd58"];
}

//描红
- (NSMutableAttributedString *)replaceRedColorWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )s TextColor:(NSString*)coler
{
    NSMutableAttributedString *attrituteString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:coler], NSFontAttributeName : [UIFont systemFontOfSize:s]} range:range];
    return attrituteString;
}

//网络加载
- (void)loadDataBegin
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:g_nowUserInfo.userToken forKey:@"userid"];
//    [dic setObject:@"3" forKey:@"type"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:URL_getHomeList values:dic requestKey:URL_getHomeList delegate:self controller:self actiViewFlag:0 title:nil];
	m_nowPage++;
}

- (void)butEventQiandao
{
    [m_todayDic setObject:[NSNumber numberWithBool:YES] forKey:@"registration"];
    
    UIButton *butQiandao = (UIButton*)[m_tableHeaderView viewWithTag:1200];
    [butQiandao setTitle:@"已签到" forState:UIControlStateNormal];
    butQiandao.enabled = NO;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:g_nowUserInfo.userid forKey:@"uid"];
//    [dic setObject:@"channel_001" forKey:@"cid"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:URL_checkin values:dic requestKey:URL_checkin delegate:self controller:self actiViewFlag:0 title:0];
}

#pragma mark - EGORefreshTableHeaderDelegate
//收起刷新
- (void)finishRefresh
{
    [m_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:m_tableView];
    m_reloading = NO;
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
	if (m_reloading) {
		return;
	}
    m_reloading = YES;
    [self loadDataBegin];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return m_reloading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[m_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

//头item事件
- (void)butEventLnkToolsItem:(UIButton*)but
{
    switch (but.tag-100) {
        case 0:
        {
//            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//            NSDictionary *family = [FamilyListView getSelectFamilyInfoByUserid];
//            [dic setObject:family[@"user_no"] forKey:@"accountId"];
//            [dic setObject:family[@"nickName"] forKey:@"nickName"];
//            [dic setObject:[NSNumber numberWithLong:[CommonDate getLongTime]] forKey:@"recordDate"];
//            [[Mealtime alloc] initWithBlock:^(id timeBucket){
//                QuickAddBloodSugar * add = [[QuickAddBloodSugar alloc] initWithTitle:@"血糖"];
//                add.isShow = YES;
//                add.isShowTime = YES;
//                add.timeBucket = timeBucket;
//                add.accountId = family[@"user_no"];
//                add.recordDate = [NSString stringWithFormat:@"%ld",[CommonDate getLongTime]];
//                [add show];
//                [add setBloodSugarView];
//                add.saveDataBlock = ^{
//                };
//
//            } withType:nowMealtimeConf withView:self];
        }
            break;
        case 1:
        {
            SteperHomeViewController *step = [[SteperHomeViewController alloc] init];
            [self.navigationController pushViewController:step animated:YES];
            [step release];
        }
            break;
        case 2:
        {
            ToolsViewController *toolsVC = [[ToolsViewController alloc] init];
            [self.navigationController pushViewController:toolsVC animated:YES];
            [toolsVC release];
        }
            break;
        case 3:
        {    //医友
//            FriendListTableView *doctorList = [[FriendListTableView alloc]init];
//            doctorList.title = @"问医生";
////            doctorList.type = doctorApply;
//            doctorList.log_pageID = 402;
//            doctorList.m_superClass = self;
//            [self.navigationController pushViewController:doctorList animated:YES];
//            [doctorList release];
            DoctorListViewController *doctorList = [[DoctorListViewController alloc] init];
            [self.navigationController pushViewController:doctorList animated:YES];
            [doctorList release];
        }
            break;
            
        default:
            break;
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    m_lastScrollOfferY2 = scrollView.contentOffset.y;
}

//UIScrollView滚动停止
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//	NSArray *visiblePaths = [m_tableView indexPathsForVisibleRows];
//    [m_OperationQueue loadImagesForOnscreenRows:visiblePaths isRow:NO];
//}

//UIScrollView松开手指
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//	if (!decelerate)//手指松开且不滚动
//	{
//		NSArray *visiblePaths = [m_tableView indexPathsForVisibleRows];
//		[m_OperationQueue loadImagesForOnscreenRows:visiblePaths isRow:NO];
//	}

	[m_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

//- (void)showImageForDownload:(NSDictionary *)imageDicInfo
//{
//	if (m_isClose) {
//		return;
//	}
//	
//	NSMutableDictionary *dicCansu = [[NSMutableDictionary alloc] initWithDictionary:imageDicInfo];
//	[self performSelectorOnMainThread:@selector(setSellerTableCellImage:) withObject:dicCansu waitUntilDone:YES];
//}
//
//- (void)setSellerTableCellImage:(NSDictionary*)canshu
//{
//	UIImage *image = [canshu objectForKey:@"image"];
//	NSIndexPath *indexPath = [canshu objectForKey:@"indexPath"];
//	[canshu release];
//	
//	HomeTableViewCellCom *cell = (HomeTableViewCellCom*)[m_tableView cellForRowAtIndexPath:indexPath];
//	[cell setIconImage:image Index:[[canshu objectForKey:@"NO."] intValue]];
//}

- (void)shuaxinCell:(NSMutableDictionary*)dic
{
	int row = (int)[m_array indexOfObject:dic];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
	[m_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -
#pragma mark Table Data Source Methods
//Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return m_array.count;
}

//获取数据条数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    float height = 0.1;
    if (section == m_array.count-1) {
        return height = 10;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *dic = [m_array objectAtIndex:indexPath.section];
    
    float height = 0;
	NSString *type = [dic objectForKey:@"displayFormat"];
    if ([type isEqualToString:@"-1"]) {
        height = 160;
    }
    else if ([type isEqualToString:@"110"]) {
        height = 105;
    }
    else if ([type isEqualToString:@"19"]) {
        height += 50;
//        height += 175; //组的头title
        height += (120/320.f)*kDeviceWidth;
        height += 20;
	}
    else if ([type isEqualToString:@"20"]) {
		height += 60;
    }
    else if ([type isEqualToString:@"21"]) {
        height += 35;
        height += (260/320.f)*kDeviceWidth;
        height += 102-30;
    }
    else if ([type isEqualToString:@"22"]) {
        height = 170;
    }
    else if ([type isEqualToString:@"23"]) {
        height = 60;
    }
	else {
        height += 50;
        height += (160/320.f)*kDeviceWidth; //组的头title
        height += [[dic objectForKey:@"contentHeight"] floatValue] + 22; //详情
    }
    return height;
}

//填充数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSMutableDictionary *dic = [m_array objectAtIndex:indexPath.section];
    
	NSString *type = [dic objectForKey:@"displayFormat"];
	HomeTableViewCellCom *cell = [tableView dequeueReusableCellWithIdentifier:type];
	
	if ([type isEqualToString:@"110"]) {
        
        if ( !cell )
        {
            cell = (HomeTableViewCellCom *)[[[MoveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:type] autorelease];
            cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
            cell.backgroundView.backgroundColor = [UIColor whiteColor];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor redColor];
//			cell.delegate = self;
        }
        
        [cell setInfoDic:dic];
    }
    else  if ([type isEqualToString:@"19"]) {
        
        if ( !cell )
        {
            cell = (HomeTableViewCellCom *)[[[NoticeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:type] autorelease];
            cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
            cell.backgroundView.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.delegate = self;
        }
        
        [cell setInfoDic:dic];
		NSArray *array = [dic objectForKey:@"array"];
		
		[((NoticeTableViewCell*)cell) setViewNumber:(int)array.count];
		
//		int index = [[dic objectForKey:@"index"] intValue];
		
		for (int i = 0; i < array.count; i++) {
			
			NSMutableDictionary *dicItem = [array objectAtIndex:i];
            
            NSString *imagePath = [dicItem[@"img_url"] stringByAppendingFormat:@"?imageView2/1/w/%d/h/%d", (int)kDeviceWidth*2, (int)(110*kDeviceWidth/375*2)];
            [cell setIconImage:imagePath Index:i];
            
//			UIImage *image = [m_OperationQueue getImageForUrl:imagePath];
//			
//			if (image) {
//				[cell setIconImage:image Index:i];
//			} else {
//				if (tableView.dragging == NO && tableView.decelerating == NO)//table停止不再滑动的时候下载图片（先用默认的图片来代替Cell的image）
//				{
//					[m_OperationQueue startIconDownload:imagePath forIndexPath:indexPath setNo:i];
//				}
//				if (!cell.imageView.image) {
//					[cell setIconImage:[UIImage imageNamed:@"common.bundle/common/conversation_logo.png"] Index:i];
//				}
//			}
		}
    }
	else if ([type isEqualToString:@"20"]) {
		
		if ( !cell )
		{
            cell = (HomeTableViewCellCom *)[[[TodayTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:type] autorelease];
            cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
            cell.backgroundView.backgroundColor = [UIColor whiteColor];
            cell.superview.backgroundColor = [UIColor redColor];
			cell.delegate = self;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell setInfoDic:dic];
    }
    else if ([type isEqualToString:@"21"]) {
        
        if ( !cell )
        {
            cell = (HomeTableViewCellCom *)[[[bloodGlucoseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:type] autorelease];
            cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
            cell.backgroundView.backgroundColor = [UIColor whiteColor];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell setInfoDic:dic];
    }
    else  if ([type isEqualToString:@"22"]) {
        
        if ( !cell )
        {
            cell = (HomeTableViewCellCom *)[[[expertTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:type] autorelease];
            cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
            cell.backgroundView.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        
        [cell setInfoDic:dic];
        
        NSArray *array = [dic objectForKey:@"array"];
        
        for (int i = 0; i < array.count; i++) {
            
            NSMutableDictionary *dicItem = [array objectAtIndex:i];
            
            NSString *imagePath = [dicItem[@"img_url"] stringByAppendingString:@"?imageView2/1/w/160/h/160"];
            [cell setIconImage:imagePath Index:i];
        }
    }
    else if ([type isEqualToString:@"23"]) {
        
        if ( !cell )
        {
            cell = (HomeTableViewCellCom *)[[[homeGuideTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:type] autorelease];
            cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
            cell.backgroundView.backgroundColor = [UIColor whiteColor];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell setInfoDic:dic];
    }
    else {
        if ( !cell )
        {
            cell = [[[HomeTableViewCellTopic alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:type] autorelease];
            cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
            cell.backgroundView.backgroundColor = [UIColor whiteColor];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.delegate = self;
        }
        
        [cell setInfoDic:dic];
//        , (160/320.f)*kDeviceWidth
        NSString *imagePath = [dic[@"img_url"] stringByAppendingFormat:@"?imageView2/1/w/%d/h/%d", (int)(kDeviceWidth-30)*2, (int)((160/320.f)*kDeviceWidth)*2];
        [cell setIconImage:imagePath Index:0];
        
//        UIImage *image = [m_OperationQueue getImageForUrl:imagePath];
//        
//        if (image) {
//            [cell setIconImage:image Index:0];
//        } else {
//            if (tableView.dragging == NO && tableView.decelerating == NO)//table停止不再滑动的时候下载图片（先用默认的图片来代替Cell的image）
//            {
//                [m_OperationQueue startIconDownload:imagePath forIndexPath:indexPath setNo:0];
//            }
//            if (!cell.imageView.image) {
//                [cell setIconImage:[UIImage imageNamed:@"common.bundle/common/conversation_logo.png"] Index:0];
//            }
//        }
    }
//    cell.backgroundColor = [UIColor clearColor];
    
	return cell;
}

//- (void)betEventTouch:(NSMutableDictionary *)dic
//{
//	int row = (int)[m_array indexOfObject:dic];
//	NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:row];
//	[self tableView:m_tableView didSelectRowAtIndexPath:path];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic = [m_array objectAtIndex:indexPath.section];
    int index = [[dic objectForKey:@"tag"] intValue];
    
    NSLog(@"---row:%ld",(long)indexPath.row);
    switch (index)
    {
//        case 3://专家咨询
//        {
//            ShowConsultViewController *showConsultVC = [[ShowConsultViewController alloc] init];
//            [self.navigationController pushViewController:showConsultVC animated:YES];
//            [showConsultVC release];
//        }
            break;
        case 4://新闻连播
        {
            NewsDeatilViewController *newsVC = [[NewsDeatilViewController alloc] init];
//            newsVC.title = dic[@"title"];
            newsVC.titleName = newsVC.title;
            newsVC.dateString = [CommonDate  getServerTime:(long)([dic[@"createTime"] longLongValue]/1000) type:4];
            [newsVC setNewsId:[dic objectForKey:@"id"]];
            newsVC.shareTitle = dic[@"title"];
            newsVC.shareImage = [dic objectForKey:@"img_url"];
            newsVC.shareContentString = dic[@"content"];
            newsVC.shareURL = [self getShareURLType:@"news" andId:dic[@"id"]];
            
            [self.navigationController pushViewController:newsVC animated:YES];
            [newsVC release];
        }
            break;
        case 5://专家话题
        {
			TopicDetailsViewController * top = [[TopicDetailsViewController alloc] init];
            top.m_isHideNavBar = [dic[@"transparent"] boolValue];
//			[dic setObject:[dic objectForKey:@"themeId"] forKey:@"themeId"];
            [dic setObject:[dic objectForKey:@"id"] forKey:@"postId"];
			top.m_dic = dic;
            top.shareTitle = [NSString stringWithFormat:@"【康迅360】- 您值得信赖的健康管理专家%@ %@",dic[@"typestr"],dic[@"title"]];
			top.shareImage = [dic objectForKey:@"img_url"];
			top.shareContentString = dic[@"title"];
			[self.navigationController pushViewController:top animated:YES];
			[top release];
        }
            break;
		case 20://每日任务
        {
            ScoreRewardsViewController *score = [[ScoreRewardsViewController alloc] init];
			[self.navigationController pushViewController:score animated:YES];
			[score release];
		}
			break;
        case 110:
        {
        
//            StepCounterViewController * mainStepVC = [[StepCounterViewController alloc]init];
//            MainStepViewController *mainStepVC = [[MainStepViewController alloc] init];
            SteperHomeViewController *mainStepVC = [[SteperHomeViewController alloc] init];

            [self.navigationController pushViewController:mainStepVC animated:YES];
            [mainStepVC release];
        }
            break;
        case 101:
        {
            int index = [[dic objectForKey:@"index"] intValue];
            NSArray *array = [dic objectForKey:@"array"];
            NSDictionary *dicItem = [array objectAtIndex:index];
            
            if ([dicItem[@"islink"] boolValue]) {

				//跳转到活动页面
				NoticeDetailViewController *noticeDetailVC = [[NoticeDetailViewController alloc] init];
                
				noticeDetailVC.m_isHideNavBar = [dicItem[@"transparentYn"] isEqualToString:@"Y"];
//                self.navigationController.navigationBarHidden = YES;
				//            noticeDetailVC.title = dic[@"title"];
                
				NSString *requestURL = [NSString stringWithFormat:@"%@operation/activity/%@.html?id=%@",NOTICE_DETAIL_URL, [dicItem objectForKey:@"detailID"], g_nowUserInfo.userid];
				NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
				[dicc setObject:requestURL forKey:@"url"];
				[dicc setObject:@"1" forKey:@"isShare"];
//				[dicc setObject:[dicItem objectForKey:@"detailID"] forKey:@"id"];
				[noticeDetailVC setM_dicInfo:dicc];
                noticeDetailVC.titleName = dicItem[@"title"];
                noticeDetailVC.subTitle = dicItem[@"subtitle"];
                noticeDetailVC.newsId = dicItem[@"detailID"];
				[self.navigationController pushViewController:noticeDetailVC animated:YES];
				[noticeDetailVC release];
			}
        }
			break;
        case 102:
            
            break;
        default:
            break;
    }
}

- (void)butEventHomeGuide:(homeGuideEnum)type
{
    switch (type) {
        case xinshouzhinan:
        {
            WebViewController *help = [[WebViewController alloc] init];
//            help.isUrl = YES;
            help.m_url = HEALP_SERVER_NEW;
            help.title = @"新手指南";
            [self.navigationController pushViewController:help animated:YES];
            [help release];
        }
            break;
        case tangyoubidu:
        {
            WebViewController *help = [[WebViewController alloc] init];
//            help.isUrl = YES;
            help.m_url = HEALP_SERVER_ABOURT;
            help.title = @"关于我们";
            [self.navigationController pushViewController:help animated:YES];
            [help release];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)notificationToday
{
    @try {
        if (g_nowUserInfo.userid && m_todayDic) {
            int completeNum = [[m_todayDic objectForKey:@"completeNum"] intValue];
            int sum = [[m_todayDic objectForKey:@"sum"] intValue];
            [m_todayDic setObject:[NSNumber numberWithInt: MIN((completeNum+1),sum)] forKey:@"completeNum"];
            
            [self setJifenDic:m_todayDic];
//            int row = (int)[m_array indexOfObject:m_todayDic];
//            [m_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:row]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
        
    }
}

- (void)toNoticView
{
//调到话题页面
            NSDictionary *dicItem = @{@"transparentYn":@"Y",@"detailID":@"402880cc4acdf691014acdf711c70001",@"title":@"标题",@"content":@"sub标题",@"islink":@"Y"};
    
     if ([dicItem[@"islink"] boolValue]) {
				NoticeDetailViewController *noticeDetailVC = [[NoticeDetailViewController alloc] init];
    
				noticeDetailVC.m_isHideNavBar = [dicItem[@"transparentYn"] isEqualToString:@"Y"];
    //                self.navigationController.navigationBarHidden = YES;
				//            noticeDetailVC.title = dic[@"title"];
				NSString *requestURL = [NSString stringWithFormat:@"%@operation/activity/%@.html?id=%@",NOTICE_DETAIL_URL, [dicItem objectForKey:@"detailID"], g_nowUserInfo.userid];
				NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
				[dicc setObject:requestURL forKey:@"url"];
				[dicc setObject:@"1" forKey:@"isShare"];
    //				[dicc setObject:[dicItem objectForKey:@"detailID"] forKey:@"id"];
				[noticeDetailVC setM_dicInfo:dicc];
                noticeDetailVC.titleName = dicItem[@"title"];
                noticeDetailVC.subTitle = dicItem[@"content"];
                noticeDetailVC.newsId = dicItem[@"detailID"];
				[self.navigationController pushViewController:noticeDetailVC animated:YES];
				[noticeDetailVC release];
     }
}

- (void)toTopicView
{
    NSDictionary *dic = @{@"transparentYn":@"N",@"themeId":@"ff8080814af25b2b014b01b7855c0182",@"title":@"标题",@"content":@"sub标题",@"islink":@"Y"};
    
    TopicDetailsViewController * top = [[TopicDetailsViewController alloc] init];
    top.m_isHideNavBar = [dic[@"transparent"] boolValue];
    top.m_dic = dic;
    top.shareTitle = dic[@"title"];
//    top.shareImage = [dic objectForKey:@"img_url"];
    top.shareContentString = dic[@"content"];
    top.shareURL = [self getShareURLType:@"theme" andId:dic[@"themeId"]];
    [self.navigationController pushViewController:top animated:YES];
    [top release];
}

- (void)toNewsView
{
    NSDictionary *dic = @{@"transparentYn":@"N",@"newsId":@"ff8080814af25b2b014b0049d9b70140",@"title":@"标题",@"content":@"sub标题",@"islink":@"Y",@"createTime":@"1421639014839"};

    
    NewsDeatilViewController *newsVC = [[NewsDeatilViewController alloc] init];
    //            newsVC.title = dic[@"title"];
    newsVC.titleName = newsVC.title;
    newsVC.dateString = [CommonDate  getServerTime:(long)([dic[@"createTime"] longLongValue]/1000) type:4];
    [newsVC setNewsId:[dic objectForKey:@"newsId"]];
    newsVC.shareTitle = dic[@"title"];
//    newsVC.shareImage = [dic objectForKey:@"img_url"];
    newsVC.shareContentString = dic[@"content"];
    newsVC.shareURL = [self getShareURLType:@"news" andId:dic[@"newsId"]];
    
    [self.navigationController pushViewController:newsVC animated:YES];
    [newsVC release];
}

- (NSString*)getShareURLType:(NSString*)type andId:(NSString*)idString
{
    NSString* shareURL = [NSString stringWithFormat:@"%@%@.html", Share_Server_URL,idString];
    
    return shareURL;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didFinishFail:(ASIHTTPRequest*)loader
{
    [self finishRefresh];
}

- (void)didFinishSuccess:(ASIHTTPRequest*)loader
{
    NSString* responseString = [loader responseString];
    NSDictionary* dic = [responseString KXjSONValueObject];
    
    NSDictionary *head = [dic objectForKey:@"head"];
    if (![[head objectForKey:@"state"] intValue])
    {
        NSDictionary *body = [dic objectForKey:@"body"];
        if([loader.username isEqualToString:URL_getHomeList]){
            
            [self finishRefresh];
            
			[m_array removeAllObjects];
            m_todayDic = nil;
            
            //新手指南
            int num = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"xinshouzhinan_%@",g_nowUserInfo.userid]] intValue];
            if (num < 4) {
                NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:@{@"typestr":@"积分奖励",  @"displayFormat":@"23", @"tag":[NSNumber numberWithFloat:23]}];
                [m_array addObject:dic1];
            }
            
            //公告栏
            NSArray *announcementlist = [body objectForKey:@"ad_list"];
            if (announcementlist.count) {
                
                NSMutableDictionary *dicItem;
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *item in announcementlist) {
                    
                    NSString *detailID = item[@"id"];
                    NSString *img_url = [Common isNULLString3:item[@"img"]];
                    NSString *click_url = [Common isNULLString3:item[@"url"]];
                    dicItem = [NSMutableDictionary dictionaryWithDictionary:
                               @{@"typestr":@"公告栏",
                                 @"title":[Common isNULLString3: item[@"title"]],
                                 @"img_url":img_url,
                                 @"click_url":click_url,
                                 @"islink": [Common isNULLString3:item[@"islink"]],
                                 @"detailID":detailID,
                                 @"subtitle":[Common isNULLString3:item[@"content"]]}];
                    
                    [array addObject:dicItem];
                }
                
                [self createAdvertising:array];
            }
            
            //积分
            NSDictionary *point_change = [body objectForKey:@"point_change"];
            if ([point_change isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:@{@"typestr":@"积分奖励",  @"displayFormat":@"20", @"tag":[NSNumber numberWithFloat:20]}];
                [dic1 setObject:[point_change objectForKey:@"point_adward_complete"] forKey:@"completeNum"];
                //                    [dic1 setObject:[dicItem objectForKey:@""] forKey:@"point"];
                [dic1 setObject:[point_change objectForKey:@"point_adward_total"] forKey:@"sum"];
                [dic1 setObject:[point_change objectForKey:@"is_check_in"] forKey:@"registration"];
                m_todayDic = [dic1 retain];
                [self createQiandao:m_todayDic];
            }
            
            //专家直通车
            NSDictionary *doc_specials = [body objectForKey:@"doc_specials"];
            if ([doc_specials isKindOfClass:[NSDictionary class]]) {
                
                NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:@{@"displayFormat":@"22", @"tag":[NSNumber numberWithFloat:102], @"index":@"0", @"typestr":doc_specials[@"title"], @"title":doc_specials[@"info"]}];
                
                NSMutableDictionary *dicItem, *dicTest;
                NSMutableArray *array = [NSMutableArray array];
                [dic1 setObject:array forKey:@"array"];
                
                NSArray *arrays = [doc_specials objectForKey:@"doc_list"];
                for (int i = 0; i < arrays.count; i++) {
                    dicTest = [arrays objectAtIndex:i];
                    dicItem = [NSMutableDictionary dictionary];
                    [dicItem setObject:dicTest[@"img_url"] forKey:@"img_url"];
                    [dicItem setObject:dicTest[@"name"] forKey:@"name"];
                    [dicItem setObject:dicTest[@"info"] forKey:@"zhicheng"];
                    
                    [array addObject:dicItem];
                }
                
                [m_array addObject:dic1];
            }
            
            NSArray *home_news = [body objectForKey:@"home_news"];
            if ([home_news isKindOfClass:[NSArray class]]) {
                NSMutableDictionary *group, *dic, *dicItem;
                for (int i = 0; i < home_news.count; i++) {
                    
                    dic = [home_news objectAtIndex:i];
                    
                    group = [dic objectForKey:@"group"];
                    
                    NSDictionary *dicc = dic[@"news_list"][0];
                    
                    dicItem = [NSMutableDictionary dictionary];
                    [m_array addObject:dicItem];
                    [dicItem setObject:@"5" forKey:@"tag"];
                    [dicItem setObject:dicc[@"id"] forKey:@"id"];
                    [dicItem setObject:group[@"name"] forKey:@"typestr"];
                    [dicItem setObject:dicc[@"title"] forKey:@"title"];
                    [dicItem setObject:dicc[@"remark"] forKey:@"content"];
                    [dicItem setObject:dicc[@"img_url"] forKey:@"img_url"];
                    [dicItem setObject:dicc[@"transparent"] forKey:@"transparent"];
                    
                    NSString *content = [dicItem objectForKey:@"content"];
                    float height = 0;
                    if (content.length) {
                        height = [Common heightForString:content Width:270 Font:[UIFont systemFontOfSize:15]].height+2;
                    }
                    height = MIN(36, height);
                    [dicItem setObject:[NSNumber numberWithFloat:height] forKey:@"contentHeight"];
                    
                    height = [Common heightForString:[dicItem objectForKey:@"title"] Width:270 Font:[UIFont systemFontOfSize:17]].height+2;
                    height = MIN(42, height);
                    [dicItem setObject:[NSNumber numberWithFloat:height] forKey:@"titleHeight"];
                    
                    NSString *subTitle = [dicItem objectForKeyedSubscript:@"subTitle"];
                    height = [Common heightForString:subTitle Width:195 Font:[UIFont systemFontOfSize:14]].height+2;
                    height = MIN(36, height);
                    [dicItem setObject:[NSNumber numberWithFloat:height] forKey:@"subTitleHeight"];
                }
            }

            [m_tableView reloadData];
        }
        else if ([loader.username isEqualToString:StepDataUploadRequest]) {
			NSLog(@"%@", dic);
		}
        else if ([loader.username isEqualToString:GET_JUDGE_CATERING]) {
            NSLog(@"%@", dic);
            if ([dic[@"rs"] intValue] == 1) {
                PerfectViewController * perf = [[PerfectViewController alloc] init];
                [self.navigationController pushViewController:perf animated:YES];
                [perf release];
            }
            else {
                //吃什么
                CheckSugarViewController *calculator = [[CheckSugarViewController alloc] init];
                [self.navigationController pushViewController:calculator animated:YES];
                [calculator release];
                [[NSUserDefaults standardUserDefaults] setObject:dic[@"rs"] forKey:[NSString stringWithFormat:@"%@_getCheckUserBasicInfo",g_nowUserInfo.userid]];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
    else {
        [self finishRefresh];
        
        [Common TipDialog:[dic objectForKey:@"msg"]];
    }
}

- (void)shuaxinTableView
{
	[m_tableView reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loadDataBegin" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [m_tableView release];
    [m_array release];
	[m_sequenceArray release];
//    [m_OperationQueue release];
    [m_refreshHeaderView release];
    [m_advScroller release];
    
    [m_jifenView release];
    [m_headerbutView release];
	
    [super dealloc];
}

//刷新提醒根据用户
- (void)reStartAlert
{
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    NSArray *dic_data =  [[[DBOperate shareInstance] getAllAlertsFromDB] retain];
//    HealthAlertListTableViewController *hvc = [[HealthAlertListTableViewController alloc]init];
//    for (NSDictionary *dict in dic_data)
//    {
//        if ([dict[@"use_yn"] isEqualToString:@"Y"])
//        {
//            [hvc postLocalNotification:dict];
//        }
//    }
//    [hvc startClockZeroMorning];//开启零点通知
//    [hvc release];
//    [dic_data release];
}

@end
