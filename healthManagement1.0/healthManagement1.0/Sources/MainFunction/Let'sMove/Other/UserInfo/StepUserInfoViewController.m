//
//  StepUserInfoViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-11-28.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "StepUserInfoViewController.h"
#import "SendPkMesViewController.h"

#import "UserPhotoView.h"

//#import "ApplyInfoViewController.h"
#import "UserInfoCell.h"
#import "InvitationDoctorViewController.h"
#import "MyChallengerViewController.h"
#import "GoGoTViewController.h"

#import "PickerView.h"
#import "AppDelegate.h"
#import "MyStepCounterHistoryViewController.h"


@interface StepUserInfoViewController ()
{
    UIScrollView *myStepInfoScrollView;
    UIView *tipsView;
    BOOL haveUploadSwitchStatusFlag;
    
    UIButton *but;
    int  status;
    __block MBProgressHUD* hub;
    __block  NSMutableArray * m_dataArr;
    UITableView * m_tableView;
    NSString * flagStr_server;
    
    NSString *challengeString;
    NSMutableArray *stepsArray;
}

@property (nonatomic,retain) NSDictionary *dataDic;

@property (nonatomic,retain) UIImageView *photoImageView;//头像
@property (nonatomic,retain) UILabel *nameLabel;//名字
@property (nonatomic,retain) UIProgressView *progressView;//进度

@property (nonatomic,retain) UILabel *perDayStepCountLabel;//日均步数
@property (nonatomic,retain) UILabel *allFenLabel;//总分label

@property (nonatomic,retain) NSMutableArray *levelImageViewArray;//图片数组

@property (nonatomic,retain) UIImageView *vImageView;//头像

@property (nonatomic,retain)  NSString * flagStr;//开关标识位

@end

@implementation StepUserInfoViewController

- (void)dealloc
{
    hub = nil;
    self.dataDic = nil;
    self.photoImageView = nil;
    self.nameLabel = nil;
    self.progressView = nil;
    self.levelImageViewArray = nil;
    self.perDayStepCountLabel = nil;
    self.allFenLabel = nil;
    self.vImageView = nil;
    self.flagStr = nil;
    self.publishPostsDic = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"个人计步信息";
        status = -1;
        self.log_pageID = 111;
    }
    return self;
}

-(BOOL)closeNowView
{
    [tipsView removeFromSuperview];
    return [super closeNowView];
}

- (UIBarButtonItem*)createNavBarButton:(id)target setEvent:(SEL)sel withNormalImge:(NSString*)normalImge andHighlightImge:(NSString*)HighlightImge
{
    but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.tag = 130;
    but.hidden = YES;
    but.frame = CGRectMake(0, 0, 31, 44);
    [but addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* navBar = [[[UIBarButtonItem alloc] initWithCustomView:but] autorelease];
    return navBar;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getDataSource];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    stepsArray = [[NSMutableArray arrayWithCapacity:0] retain];
    for (int i = 10000; i < 40000; i+=5000) {
        [stepsArray addObject:[NSString stringWithFormat:@"%d步", i]];
    }
    
    
    
}


- (void)createTable
{
    m_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    m_tableView.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR];
    m_tableView.rowHeight = 40;
    m_tableView.separatorColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
    
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.rowHeight = 44;
    m_tableView.tableHeaderView = [self setTableHeader];
    m_tableView.separatorColor = [CommonImage colorWithHexString:@"dcdcdc"];
    [self.view addSubview:m_tableView];
    [Common setExtraCellLineHidden:m_tableView];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    
    UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kDeviceWidth, 0.5)];
    lineView.backgroundColor =  [CommonImage colorWithHexString:@"dcdcdc"];
    [view addSubview:lineView];
    [lineView release];
    
    lineView  = [[UIView alloc] initWithFrame:CGRectMake(0, 9.5,kDeviceWidth, 0.5)];
    lineView.backgroundColor =  [CommonImage colorWithHexString:@"dcdcdc"];
    [view addSubview:lineView];
    [lineView release];
    
    return [view autorelease];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell)
    {
        cell = [[[UserInfoCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(0, 44-0.5,kDeviceWidth, 0.5)];
        lineView.backgroundColor =  [CommonImage colorWithHexString:@"dcdcdc"];
        lineView.tag = 999;
        [cell addSubview:lineView];
        [lineView release];

    }
    cell.isMeFlag = self.isMeFlag;
    [cell setDataFromDic:m_dataArr[indexPath.section][indexPath.row]];
    
    __block typeof(self) weakSelf = self;
    [cell setSwitchStatusFlag:^(int isSwirch) {
        
        weakSelf.flagStr = isSwirch? @"1" : @"2";
        
    }];
    if (indexPath.section == 1 || (indexPath.section==2 && indexPath.row == 1)|| (!self.isMeFlag && indexPath.section == 0)|| (!self.isMeFlag && indexPath.section == 2 && indexPath.row == 0)) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        //自定义右箭头
        cell.accessoryView = [CommonImage creatRightArrowX:cell.frame.size.width-22 Y:(cell.frame.size.height-12)/2 cell:cell];
    }
    
    UIView *lineView = (UIView *)[cell viewWithTag:999];
    if(indexPath.section == 2 && indexPath.row == 1){
        lineView.hidden = NO;
    }else{
        lineView.hidden = YES;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_dataArr[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [m_dataArr count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    
                    if(!self.isMeFlag){
                        
                        return;
                    }
                    
                    //排名
                    MyChallengerViewController *myChallengerVC = [[MyChallengerViewController alloc] init];
                    [self.navigationController pushViewController:myChallengerVC animated:YES];
                    [myChallengerVC release];
                }
                    break;
                case 1:
                {
                    //目标
                    
                    PickerView* myPicker = [[PickerView alloc] init];
                    NSString *targetString = [NSString stringWithFormat:@"%d",[Common getAppDelegate].stepCounterObj.targetStep];

                    [myPicker createPickViewWithArray:[NSArray arrayWithObject:stepsArray] andWithSelectString:targetString setTitle:@"请选择目标步数" isShow:NO];
                    [myPicker setPickerViewBlock:^(NSString* content) {
                        
                        [myPicker release];
                        
                        NSString *newTarget = [content substringToIndex:content.length-1];
                        [Common getAppDelegate].stepCounterObj.targetStep = newTarget.intValue;
                        NSMutableArray *array = [m_dataArr[0] mutableCopy];
                        
                        [array replaceObjectAtIndex:1 withObject:@{@"title": @"计步目标",@"data":content}];
                        
                        [m_dataArr replaceObjectAtIndex:0 withObject:array];
                        [array release];
                        
                        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }];
                    
                }
                    break;
                case 2:
                {
                    //计步历史
//                    ModeStepHistoryVCViewController *modeHisoryVC = [[ModeStepHistoryVCViewController alloc] init];
                   MyStepCounterHistoryViewController *modeHisoryVC = [[MyStepCounterHistoryViewController alloc] init];
//                    modeHisoryVC.publishPostsDic = self.publishPostsDic;
                    [self.navigationController pushViewController:modeHisoryVC animated:YES];
                    [modeHisoryVC release];
                }
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                {
                    
                    if(!self.isMeFlag){
                        
                        return;
                    }
                    
                    //走走团
                    GoGoTViewController *goGoTVC = [[GoGoTViewController alloc] init];
                    [self.navigationController pushViewController:goGoTVC animated:YES];
                    [goGoTVC release];
                }
                    break;
                    
                default:
                    break;
            }
            
            break;
    }
    
}


- (UIView*)setTableFoot
{
    UIView * footView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 70)]autorelease];
    footView.backgroundColor = [UIColor clearColor];
    
    CGFloat width = (kDeviceWidth - 20*2 - 10)/2.0f;
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"91d000"]];
    UIButton * determine = [UIButton buttonWithType:UIButtonTypeCustom];
    determine.frame = CGRectMake(20, (footView.height-44)/2, width, 44);
    [determine addTarget:self action:@selector(determine) forControlEvents:UIControlEventTouchUpInside];
    [determine setTitle:@"加为好友" forState:UIControlStateNormal];
    [determine setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [determine setBackgroundImage:image forState:UIControlStateNormal];
    determine.layer.cornerRadius = 4;
    determine.clipsToBounds = YES;
    [footView addSubview:determine];
    
    image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
    UIButton * challengeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    challengeBtn.frame = CGRectMake(determine.right+10, determine.top, width, 44);
    
    [challengeBtn addTarget:self action:@selector(sendPkRequest) forControlEvents:UIControlEventTouchUpInside];
    [challengeBtn setTitle:challengeString forState:UIControlStateNormal];
    [challengeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [challengeBtn setBackgroundImage:image forState:UIControlStateNormal];
    challengeBtn.layer.cornerRadius = 4;
    challengeBtn.clipsToBounds = YES;
    [footView addSubview:challengeBtn];
    but = challengeBtn;
    return footView;
    
}

- (UIView*)setTableHeader
{
    UIView * headerView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 100)]autorelease];
    headerView.backgroundColor = [UIColor whiteColor];
    //头像
    self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 70, 70)];
    self.photoImageView.layer.cornerRadius = 35;
//    [CommonImage setPicImageQiniu:self.dataDic[@"userPhoto"] View:self.photoImageView Type:0 Delegate:nil];
    [CommonImage setImageFromServer:self.dataDic[@"userPhoto"] View:self.photoImageView Type:0];

    self.photoImageView.layer.masksToBounds = YES;
    [headerView addSubview:self.photoImageView];
    [self.photoImageView release];
    
    UIImageView *UserPhoneVIP = [[UIImageView alloc] initWithFrame:CGRectMake(self.photoImageView.width+self.photoImageView.origin.x-23, self.photoImageView.bottom-23, 23, 23)];
    UserPhoneVIP.tag = 891;
    UserPhoneVIP.layer.cornerRadius = 23/2;
    UserPhoneVIP.clipsToBounds = YES;
    NSString * imageV = [NSString stringWithFormat:@"common.bundle/personnal/VIPlevel%@.png",self.dataDic[@"vipLevel"]];
    UserPhoneVIP.image = [UIImage imageNamed:imageV];
    [headerView addSubview:UserPhoneVIP];
    [UserPhoneVIP release];
    
    //昵称
    CGFloat nameX = self.photoImageView.frame.origin.x+self.photoImageView.width+20;
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameX, 19,100, 21)];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.nameLabel.text = self.dataDic[@"nickName"];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textColor = [CommonImage colorWithHexString:@"333333"];
    [headerView addSubview:self.nameLabel];
    [self.nameLabel release];
    
    float widht = [self.dataDic[@"nickName"] sizeWithFont:self.nameLabel.font].width + 10;
    
    NSString *region = self.dataDic[@"region"];
    
    
    NSString *local0 = @"";
    NSString *local1 = @"";
    if(region.length){
        
        NSArray *regionArray = [region componentsSeparatedByString:@"#"];
        if(regionArray.count == 2){
            local0 = regionArray[0];
            local1 = regionArray[1];
        }
        
    }
    
    float widht2 = [local0 sizeWithFont:[UIFont systemFontOfSize:12]].width + 5;
    UILabel* m_ProvinceLab = [Common createLabel];
    
    m_ProvinceLab.backgroundColor = [CommonImage colorWithHexString:@"56b2ff"];
    m_ProvinceLab.frame = CGRectMake(self.nameLabel.origin.x+widht, self.nameLabel.top, widht2, 21);
    m_ProvinceLab.textAlignment = NSTextAlignmentCenter;
    m_ProvinceLab.layer.cornerRadius = 2;
    m_ProvinceLab.clipsToBounds = YES;
    m_ProvinceLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    m_ProvinceLab.textColor = [UIColor whiteColor];
    [headerView addSubview:m_ProvinceLab];
    m_ProvinceLab.text = local0;
    [m_ProvinceLab release];
    
    widht2 = [local1 sizeWithFont:[UIFont systemFontOfSize:12]].width + 5;
    UILabel* m_CityLab = [Common createLabel];
    m_CityLab.backgroundColor = [CommonImage colorWithHexString:@"ffb700"];
    m_CityLab.frame = CGRectMake(m_ProvinceLab.right+5, self.nameLabel.top, widht2, 21);
    m_CityLab.textAlignment = NSTextAlignmentCenter;
    m_CityLab.layer.cornerRadius = 2;
    m_CityLab.clipsToBounds = YES;
    m_CityLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    m_CityLab.textColor = [UIColor whiteColor];
    [headerView addSubview:m_CityLab];
    m_CityLab.text = local1;
    [m_CityLab release];
    if(!local0.length){
        m_ProvinceLab.hidden = YES;
    }
    if(!local1.length){
        m_CityLab.hidden = YES;
    }
    
    
    //等级图标
    CGFloat imageY = self.nameLabel.origin.y + self.nameLabel.size.height + 9;
    
    int  level = [self.dataDic[@"level"] intValue];
    
    CGFloat allWidth = (kDeviceWidth - nameX - 100);
    //    CGFloat offset = allWidth/9.0f;
    //    CGFloat originX = nameX + (level-1)*offset;
    
    
    NSArray *imageArray = @[@"common.bundle/move/levelImg/move_icon_turtle01_small.png",@"common.bundle/move/levelImg/move_icon_turtle02_small.png",@"common.bundle/move/levelImg/move_icon_turtle03_small.png",@"common.bundle/move/levelImg/move_icon_rabbit01_small.png",@"common.bundle/move/levelImg/move_icon_rabbit02_small.png",@"common.bundle/move/levelImg/move_icon_rabbit03_small.png",@"common.bundle/move/levelImg/move_icon_leopard01_small.png",@"common.bundle/move/levelImg/move_icon_leopard02_small.png",@"common.bundle/move/levelImg/move_icon_leopard03_small.png"];
    NSArray *levelTitleArray = @[@"乌龟1级",@"乌龟2级",@"乌龟3级",@"兔子1级",@"兔子2级",@"兔子3级",@"豹子1级",@"豹子2级",@"豹子3级"];
    
    UIImage *image = [UIImage imageNamed:imageArray[level-1]];
    UIImageView *levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.nameLabel.origin.x, imageY, image.size.width+5, image.size.height+5)];
    levelImageView.image = image;
    [headerView addSubview:levelImageView];
    [levelImageView release];
    
    
    UILabel *levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(levelImageView.origin.x+levelImageView.size.width+5, imageY, 80, levelImageView.size.height)];
    levelLabel.text = levelTitleArray[level-1];
    levelLabel.backgroundColor = [UIColor clearColor];
    levelLabel.textColor = [CommonImage colorWithHexString:@"999999"];
    levelLabel.font = [UIFont systemFontOfSize:10];
    [headerView addSubview:levelLabel];
    [levelLabel release];
    
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame = CGRectMake(nameX, imageY, kDeviceWidth-nameX, 30);
    [imageBtn addTarget:self action:@selector(showTipsView) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:imageBtn];
    
    NSArray *colorArray = @[@"6098ff",@"56cdec",@"1fd49f",@"75dd3c",@"cfdd0a",@"fde422",@"ffca1b",@"ff9921",@"fe6339"];
    
    //进度
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(nameX, 80, allWidth, 20)];
    self.progressView.progressViewStyle = UIProgressViewStyleBar;
    self.progressView.progressTintColor = [CommonImage colorWithHexString:colorArray[level-1]];
    self.progressView.trackTintColor = [CommonImage colorWithHexString:@"e5e5e5"];
    [headerView addSubview:self.progressView];
    [self.progressView release];
    self.progressView.progress = [self.dataDic[@"level"] intValue]/9.0;
    
    
    NSArray *titleArray = @[@"100",@"300",@"600",@"1000",@"1500",@"2500",@"4000",@"6000"];
    
    
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.progressView.origin.x+self.progressView.size.width+10, 70, 80, 20)];
    NSString *nextDisString = level<9? titleArray[level-1]:[NSString stringWithFormat:@"%@+",titleArray.lastObject];
    distanceLabel.text = [NSString stringWithFormat:@"%.2f/%@",[self.dataDic[@"totalDistance"]  floatValue]/1000,nextDisString];
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.textColor = [CommonImage colorWithHexString:@"666666"];
    distanceLabel.font = [UIFont systemFontOfSize:15];
    distanceLabel.adjustsFontSizeToFitWidth = YES;
    [headerView addSubview:distanceLabel];
    [distanceLabel release];
    
    return headerView;
}

/**
 *  请求用户信息
 */
- (void)getDataSource
{
    NSMutableDictionary *requestDic =  [[NSMutableDictionary alloc] initWithCapacity:0];
    //    [requestDic setValue:self.userId forKey:@"targetId"];
    //    [requestDic setValue:g_nowUserInfo.userid forKey:@"uid"];
    //     [requestDic setValue:@"3" forKey:@"appVersion"];
    [requestDic setValue:self.userId forKey:@"id"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GetStepUserInfo values:requestDic requestKey:GetStepUserInfo  delegate:self controller:self actiViewFlag:1 title:nil];
    [requestDic release];
}

////
//- (void)switchofBloodReques
//{
//    NSMutableDictionary *requestDic =  [[NSMutableDictionary alloc] initWithCapacity:0];
//    //    [requestDic setValue:self.userId forKey:@"targetId"];
//    //    [requestDic setValue:g_nowUserInfo.userid forKey:@"uid"];
//    //     [requestDic setValue:@"3" forKey:@"appVersion"];
//    if(!self.isMeFlag){
//        [requestDic setValue:self.userId forKey:@"id"];
//    }
//    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GetStepUserInfo values:requestDic requestKey:GetStepUserInfo  delegate:self controller:self actiViewFlag:1 title:nil];
//    [requestDic release];
//}


- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    NSLog(@"fail");
}

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dict = [responseString KXjSONValueObject];
    if ([dict[@"head"][@"state"] isEqualToString:@"0000"])
    {
        NSDictionary *dic = dict[@"body"];
        if ([loader.username isEqualToString:GetStepUserInfo]){
            self.dataDic =  dic[@"info"];
            status = [self.dataDic[@"challengeStatus"] intValue];
            if(status == 0){//可以申请
                challengeString = @"挑战";
                //                but.hidden = NO;
                //                [but setImage:[UIImage imageNamed:@"common.bundle/move/move_nevigationbar_icon_pk_normal.png"] forState:UIControlStateNormal];
                //                [but setImage:[UIImage imageNamed:@"common.bundle/move/move_nevigationbar_icon_pk_pressed.png"] forState:UIControlStateHighlighted];
                
            }else if(status == 1){
                challengeString = @"约战中";
                //                but.hidden = NO;
                //                //申请中
                //                but.frame = CGRectMake(0, 0, 60, 44);
                //                but.titleLabel.font = [UIFont systemFontOfSize:15.0f];
                //               [but setTitle:@"约战中" forState:UIControlStateNormal];
                
            }else if (status == 2){
                challengeString = @"挑战中";
                //进行中
                //                but.hidden = NO;
                //                but.frame = CGRectMake(0, 0, 60, 44);
                //                but.titleLabel.font = [UIFont systemFontOfSize:15.0f];
                //                [but setTitle:@"挑战中" forState:UIControlStateNormal];
            }
            
            self.isMeFlag = [dic[@"info"][@"isMe"] boolValue];
            //            NSString *bsValue =  self.isMeFlag ? @"yesMe" : @"";//要不要显示开关
            
            flagStr_server = dic[@"info"][@"bsFlag"];//服务器上的开关标识
            self.flagStr = flagStr_server;
            NSString *stepCount = [Common getAppDelegate].stepCounterObj.stepCount;
            NSString *targetString = [NSString stringWithFormat:@"%d步",[Common getAppDelegate].stepCounterObj.targetStep];
            
            NSArray *group0 = [NSArray arrayWithObjects:@{@"title": @"目前排名",@"data":dic[@"info"][@"myRank"]},nil];
            if(self.isMeFlag){
                
                group0 = [NSArray arrayWithObjects:@{@"title": @"目前排名",@"data":dic[@"info"][@"myRank"]},@{@"title": @"计步目标",@"data":targetString},@{@"title": @"计步历史",@"data":[NSString stringWithFormat:@"%@ 步",stepCount]},nil];
            }
            
            m_dataArr = [[NSMutableArray alloc]initWithObjects:
                         group0,
                         [NSArray arrayWithObjects:@{@"title": @"总步数",@"data":[NSString stringWithFormat:@"%@ 步",dic[@"info"][@"totalStepCnt"]]},@{@"title": @"总里程",@"data":[NSString stringWithFormat:@"%.2f 公里",[dic[@"info"][@"totalDistance"] floatValue]/1000]},@{@"title": @"总消耗",@"data":[NSString stringWithFormat:@"%.0f 大卡",[dic[@"info"][@"totalCalorie"]floatValue]]},nil],
                         [NSArray arrayWithObjects:@{@"title": @"参与团",@"data":dic[@"info"][@"activityName"]},@{@"title": @"挑战纪录",@"data":[NSString stringWithFormat:@"胜:%@次  负:%@次",dic[@"info"][@"pkWinCnt"],dic[@"info"][@"pkFailCnt"]]},nil], nil];

            [self createTable];
            //            [self getHeadView];
            //            [self getPerStepAndAllFenView];
            [self createTips];
            if(self.isMeFlag){
                but.hidden = YES;
            }else{
                m_tableView.tableFooterView = [self setTableFoot];
            }
            
        }
    }else{
        [Common TipDialog:dict[@"head"][@"msg"]];
    }
}

/**
 *  发送PK请求
 */
- (void)sendPkRequest
{
    if(status != 0){
        
        return;
    }
    SendPkMesViewController *sendPkVC = [[SendPkMesViewController alloc] init];
    sendPkVC.userId = self.userId;
    [self.navigationController pushViewController:sendPkVC animated:YES];
    [sendPkVC release];
}


- (void)showTipsView
{
    [UIView animateWithDuration:0.35 animations:^{
        tipsView.alpha = 1;
        
    }];
}

- (CGSize)getSizeWithString:(NSString *)string font:(UIFont *)font constrainSize:(CGSize)constrsize
{
    CGSize size = [string sizeWithFont:font constrainedToSize:constrsize lineBreakMode:NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail];
    return size;
}

- (void)closeView:(id)sender
{
    tipsView.alpha = 0;
}

- (void)createTips
{
    tipsView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    tipsView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [APP_DELEGATE addSubview:tipsView];
    [tipsView release];
    tipsView.alpha = 0;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView:)];
    [tipsView addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    CGFloat height = 450;
    if(IS_Small_INCH_SCREEN){
        height = 375;
    }
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(24, (tipsView.size.height-height)/2, kDeviceWidth-24*2, height)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 8.0f;
    [tipsView addSubview:whiteView];
    [whiteView release];
    
    UIImage *image = [UIImage imageNamed:@"common.bundle/common/search_close_icon_nor.png"];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(kDeviceWidth-24*2-40, 5, 40, 40);
    [closeBtn setImage:image forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"common.bundle/common/search_close_icon_pre.png"] forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:closeBtn];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(24+20, whiteView.origin.y+30, kDeviceWidth-24*2-20*2, tipsView.size.height-2*whiteView.origin.y-60)];
    scrollView.backgroundColor = [UIColor clearColor];
    [tipsView addSubview:scrollView];
    [scrollView release];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, scrollView.size.width, 17)];
    titleLabel.text = @"运动等级";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [scrollView addSubview:titleLabel];
    [titleLabel release];
    
    NSString *strings = @"走的越远等级就会越高，记得经常开启计步和小伙伴一起成长吧！";
    CGSize stringSize = [self getSizeWithString:strings font:[UIFont systemFontOfSize:15.0f] constrainSize:CGSizeMake(scrollView.size.width, 1000)];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, scrollView.size.width, stringSize.height)];
    contentLabel.text = strings;
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:15.0f];
    contentLabel.textColor = [CommonImage colorWithHexString:@"333333"];
    [scrollView addSubview:contentLabel];
    [contentLabel release];
    
    
    NSArray *leftTitleArray = @[@"乌龟1",@"乌龟2",@"乌龟3",@"乌龟1",@"兔子1",@"兔子2",@"兔子3",@"豹子1",@"豹子2"];
    NSArray *rightTitleArray =  @[@"乌龟2",@"乌龟3",@"乌龟1",@"兔子1",@"兔子2",@"兔子3",@"豹子1",@"豹子2",@"豹子3"];
    NSArray *leftImageArray = @[@"common.bundle/move/levelImg/move_icon_turtle01.png",@"common.bundle/move/levelImg/move_icon_turtle02.png",@"common.bundle/move/levelImg/move_icon_turtle03.png",@"common.bundle/move/levelImg/move_icon_rabbit01.png",@"common.bundle/move/levelImg/move_icon_rabbit02.png",@"common.bundle/move/levelImg/move_icon_rabbit03.png",@"common.bundle/move/levelImg/move_icon_leopard01.png",@"common.bundle/move/levelImg/move_icon_leopard02.png"];
    NSArray *rightImageArray = @[@"common.bundle/move/levelImg/move_icon_turtle02.png",@"common.bundle/move/levelImg/move_icon_turtle03.png",@"common.bundle/move/levelImg/move_icon_rabbit01.png",@"common.bundle/move/levelImg/move_icon_rabbit02.png",@"common.bundle/move/levelImg/move_icon_rabbit03.png",@"common.bundle/move/levelImg/move_icon_leopard01.png",@"common.bundle/move/levelImg/move_icon_leopard02.png",@"common.bundle/move/levelImg/move_icon_leopard03.png"];
    NSArray *lineImageArray = @[@"common.bundle/move/levelImg/move_content_arrow_blue01.png",@"common.bundle/move/levelImg/move_content_arrow_blue02.png",@"common.bundle/move/levelImg/move_content_arrow_green03.png",@"common.bundle/move/levelImg/move_content_arrow_green01.png",@"common.bundle/move/levelImg/move_content_arrow_green02.png",@"common.bundle/move/levelImg/move_content_arrow_yellow01.png",@"common.bundle/move/levelImg/move_content_arrow_yellow02.png",@"common.bundle/move/levelImg/move_content_orange.png"];
    NSArray *titleArray = @[@"100km",@"300km",@"600km",@"1000km",@"1500km",@"2500km",@"4000km",@"6000km"];
    
    NSArray *colorArray = @[@"92b5ff",@"1ebce5",@"1fd49f",@"75dd3c",@"dce66a",@"fde213",@"ffc60c",@"ff9921"];
    
    CGFloat fromY = contentLabel.origin.y + contentLabel.size.height + 25;
    
    for(int i = 0; i < 8; i++){
        UIView *view = [self getLevelViewWithDataArray:@[leftTitleArray[i],leftImageArray[i],titleArray[i],lineImageArray[i],rightImageArray[i],rightTitleArray[i],colorArray[i]] frame:CGRectMake(0, fromY, scrollView.size.width, 55)];
        fromY = view.origin.y + view.size.height + 25;
        [scrollView addSubview:view];
        if(i == 7){
            scrollView.contentSize = CGSizeMake(scrollView.size.width, view.origin.y+view.size.height+20);
        }
    }
    
    
    //    UIView *view1 =  [self getLevelViewWithDataArray:@[@"蓝龟",@"common.bundle/move/levelImg/move_icon_turtle_blue.png",@"100km",@"common.bundle/move/levelImg/move_content_arrow_blue.png",@"common.bundle/move/levelImg/move_icon_turtle_green.png",@"绿龟",@"10c6e1"] frame:CGRectMake(0, contentLabel.origin.y + contentLabel.size.height+25, scrollView.size.width, 55)];
    //    [scrollView addSubview:view1];
    //    UIView *view2 =  [self getLevelViewWithDataArray:@[@"绿龟",@"common.bundle/move/levelImg/move_icon_turtle_green.png",@"300km",@"common.bundle/move/levelImg/move_content_arrow_green02.png",@"common.bundle/move/levelImg/move_icon_rabbit_green.png",@"绿兔",@"2fcd85"] frame:CGRectMake(0, view1.origin.y + view1.size.height+25, scrollView.size.width, 55)];
    //    [scrollView addSubview:view2];
    //    UIView *view3 =  [self getLevelViewWithDataArray:@[@"绿兔",@"common.bundle/move/levelImg/move_icon_rabbit_green.png",@"600km",@"common.bundle/move/levelImg/move_content_arrow_green01.png",@"common.bundle/move/levelImg/move_icon_rabbit_yellow.png",@"黄兔",@"b5cd2f"] frame:CGRectMake(0, view2.origin.y + view2.size.height+25, scrollView.size.width, 55)];
    //    [scrollView addSubview:view3];
    //
    //    UIView *view4 =  [self getLevelViewWithDataArray:@[@"黄兔",@"common.bundle/move/levelImg/move_icon_rabbit_yellow.png",@"1000km",@"common.bundle/move/levelImg/move_content_arrow_yellow.png",@"common.bundle/move/levelImg/move_icon_leopard_orange.png",@"橙豹",@"f3ce3a"] frame:CGRectMake(0, view3.origin.y + view3.size.height+25, scrollView.size.width, 55)];
    //    [scrollView addSubview:view4];
    //
    //    UIView *view5 =  [self getLevelViewWithDataArray:@[@"橙豹",@"common.bundle/move/levelImg/move_icon_leopard_orange.png",@"1500km",@"common.bundle/move/levelImg/move_content_arrow_orange.png",@"common.bundle/move/levelImg/move_icon_leopard_red.png",@"红豹",@"fea94c"] frame:CGRectMake(0, view4.origin.y + view4.size.height+25, scrollView.size.width, 55)];
    //    [scrollView addSubview:view5];
    //
    //    scrollView.contentSize = CGSizeMake(scrollView.size.width, view5.origin.y+view5.size.height+20);
    
    
}

- (UIView *)getLevelViewWithDataArray:(NSArray *)array frame:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor clearColor];
    //左边等级文字
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, 30, 13)];
    leftLabel.text = array[0];
    leftLabel.backgroundColor = [UIColor clearColor];
    leftLabel.textColor = [CommonImage colorWithHexString:@"666666"];
    leftLabel.font = [UIFont systemFontOfSize:13];
    [view addSubview:leftLabel];
    [leftLabel release];
    leftLabel.hidden = YES;
    //左边的图片
    UIImageView * leftImv = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 55, 55)];
    leftImv.image = [UIImage imageNamed:array[1]];
    [view addSubview:leftImv];
    [leftImv release];
    
    //右边等级文字
    
    //右边等级文字
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width-leftLabel.size.width-leftLabel.origin.x, 13, 30, 13)];
    rightLabel.text = array[5];
    rightLabel.backgroundColor = [UIColor clearColor];
    rightLabel.textColor = [CommonImage colorWithHexString:@"666666"];
    rightLabel.font = [UIFont systemFontOfSize:13];
    [view addSubview:rightLabel];
    [rightLabel release];
    rightLabel.hidden = YES;
    //右边的图片
    UIImageView* rightImv = [[UIImageView alloc] initWithFrame:CGRectMake(rect.size.width-20-55, 0, 55, 55)];
    rightImv.image = [UIImage imageNamed:array[4]];
    [view addSubview:rightImv];
    [rightImv release];
    
    //箭头的图片
    UIImageView* arrowImv = [[UIImageView alloc] initWithFrame:CGRectMake(leftImv.origin.x+leftImv.size.width+5,25, (rightImv.origin.x-5-leftImv.origin.x-leftImv.size.width-5), 6)];
    arrowImv.image = [UIImage imageNamed:array[3]];
    [view addSubview:arrowImv];
    [arrowImv release];
    
    UILabel *middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(arrowImv.origin.x, 0, arrowImv.size.width, 25)];
    middleLabel.text = array[2];
    middleLabel.textAlignment = NSTextAlignmentCenter;
    middleLabel.textColor = [CommonImage colorWithHexString:array.lastObject];
    middleLabel.font = [UIFont systemFontOfSize:13];
    [view addSubview:middleLabel];
    [middleLabel release];
    
    return [view autorelease];
}


/**
 *  获得头信息
 */
- (void)getHeadView
{
    //头像
    self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 70, 70)];
    self.photoImageView.layer.cornerRadius = 35;
//    [CommonImage setPicImageQiniu:self.dataDic[@"iconPath"] View:self.photoImageView Type:0 Delegate:nil];
    [CommonImage setImageFromServer:self.dataDic[@"iconPath"] View:self.photoImageView Type:0];

    self.photoImageView.layer.masksToBounds = YES;
    [myStepInfoScrollView addSubview:self.photoImageView];
    [self.photoImageView release];
    //    self.photoImageView.hidden = YES;
    //
    //
    //    UserPhotoView *photoView = [[UserPhotoView alloc] initWithFrame:CGRectMake(20, 15, 70, 70) withSexImageBounds:CGRectMake(0, 0, 20, 20) andVImageBounds:CGRectMake(0, 0, 20, 20)];
    //    [myStepInfoScrollView addSubview:photoView];
    //    [photoView release];
    //
    //    [photoView setImageURLString:self.dataDic[@"iconPath"] sexImageName:nil andVImageName:@"common.bundle/move/v_01.png"];
    //    photoView.onClickViewEvent = ^(void){
    //
    //        NSLog(@"click me");
    //    };
    //
    //    return;
    //    //加v
    //    self.vImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.photoImageView.origin.x+50,70-8, 20, 20)];
    //    [myStepInfoScrollView addSubview:self.vImageView];
    //    self.vImageView.backgroundColor = [UIColor clearColor];
    //    self.vImageView.image = [UIImage imageNamed:@"common.bundle/move/v_03.png"];
    //    [self.vImageView release];
    
    
    
    //昵称
    CGFloat nameX = self.photoImageView.frame.origin.x+self.photoImageView.width+20;
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameX, 19, kDeviceWidth-nameX-15, 21)];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.nameLabel.text = self.dataDic[@"userName"];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textColor = [CommonImage colorWithHexString:@"333333"];
    [myStepInfoScrollView addSubview:self.nameLabel];
    [self.nameLabel release];
    
    
    
    //等级图标
    CGFloat imageY = self.nameLabel.origin.y + self.nameLabel.size.height + 9;
    //    NSArray *imagesArray = @[@"move_icon_turtle_blue.png",@"move_icon_turtle_green.png",@"move_icon_rabbit_green.png",@"move_icon_rabbit_yellow.png",@"move_icon_leopard_orange.png",@"move_icon_leopard_red.png"];
    //    NSArray *grayImagesArry = @[@"move_icon_turtle_gray01.png",@"move_icon_turtle_gray02.png",@"move_icon_rabbit_gray01.png",@"move_icon_rabbit_gray02.png",@"move_icon_leopard_gray01.png",@"move_icon_leopard_gray02.png"];
    //    CGFloat marginx = nameX;
    //    self.levelImageViewArray = [NSMutableArray arrayWithCapacity:0];
    ////    for(NSString *imageName in imagesArray){
    //
    //    for(int i = 1; i < 7; i++){
    //
    //        NSString *imageName = grayImagesArry[i-1];
    //        if(i <= [self.dataDic[@"level"] intValue]){
    //            imageName = imagesArray[i -1];
    //        }
    //
    //        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"common.bundle/move/%@",imageName]];
    //        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(marginx, imageY, image.size.width, image.size.height)];
    //        imageView.image = image;//[self  grayImage:image];
    //        [myStepInfoScrollView addSubview:imageView];
    //        [self.levelImageViewArray addObject:imageView];
    //        [imageView release];
    //        marginx += image.size.width + 5;
    //    }
    
    
    //namex 开始 宽度为150 分九段
    
    int  level = [self.dataDic[@"level"] intValue];
    
    CGFloat allWidth = (kDeviceWidth - nameX - 100);
    CGFloat offset = allWidth/9.0f;
    CGFloat originX = nameX + (level-1)*offset;
    
    
    NSArray *imageArray = @[@"common.bundle/move/levelImg/move_icon_turtle01_small.png",@"common.bundle/move/levelImg/move_icon_turtle02_small.png",@"common.bundle/move/levelImg/move_icon_turtle03_small.png",@"common.bundle/move/levelImg/move_icon_rabbit01_small.png",@"common.bundle/move/levelImg/move_icon_rabbit02_small.png",@"common.bundle/move/levelImg/move_icon_rabbit03_small.png",@"common.bundle/move/levelImg/move_icon_leopard01_small.png",@"common.bundle/move/levelImg/move_icon_leopard02_small.png",@"common.bundle/move/levelImg/move_icon_leopard03_small.png"];
    NSArray *levelTitleArray = @[@"乌龟1级",@"乌龟2级",@"乌龟3级",@"兔子1级",@"兔子2级",@"兔子3级",@"豹子1级",@"豹子2级",@"豹子3级"];
    
    UIImage *image = [UIImage imageNamed:imageArray[level-1]];
    UIImageView *levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, imageY, image.size.width+5, image.size.height+5)];
    levelImageView.image = image;
    [myStepInfoScrollView addSubview:levelImageView];
    [levelImageView release];
    
    
    UILabel *levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(levelImageView.origin.x+levelImageView.size.width+5, imageY, 80, levelImageView.size.height)];
    levelLabel.text = levelTitleArray[level-1];
    levelLabel.backgroundColor = [UIColor clearColor];
    levelLabel.textColor = [CommonImage colorWithHexString:@"999999"];
    levelLabel.font = [UIFont systemFontOfSize:15];
    [myStepInfoScrollView addSubview:levelLabel];
    [levelLabel release];
    
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame = CGRectMake(nameX, imageY, kDeviceWidth-nameX, 30);
    [imageBtn addTarget:self action:@selector(showTipsView) forControlEvents:UIControlEventTouchUpInside];
    [myStepInfoScrollView addSubview:imageBtn];
    
    NSArray *colorArray = @[@"6098ff",@"56cdec",@"1fd49f",@"75dd3c",@"cfdd0a",@"fde422",@"ffca1b",@"ff9921",@"fe6339"];
    
    //进度
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(nameX, 80, allWidth, 20)];
    self.progressView.progressViewStyle = UIProgressViewStyleBar;
    self.progressView.progressTintColor = [CommonImage colorWithHexString:colorArray[level-1]];
    self.progressView.trackTintColor = [CommonImage colorWithHexString:@"e5e5e5"];
    [myStepInfoScrollView addSubview:self.progressView];
    [self.progressView release];
    self.progressView.progress = [self.dataDic[@"level"] intValue]/9.0;
    
    
    NSArray *titleArray = @[@"100",@"300",@"600",@"1000",@"1500",@"2500",@"4000",@"6000"];
    
    
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.progressView.origin.x+self.progressView.size.width+10, 70, 80, 20)];
    NSString *nextDisString = titleArray[level-1];
    distanceLabel.text = [NSString stringWithFormat:@"%.2f/%@",[self.dataDic[@"totalDistance"]  floatValue]/1000,nextDisString];
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.textColor = [CommonImage colorWithHexString:@"666666"];
    distanceLabel.font = [UIFont systemFontOfSize:15];
    distanceLabel.adjustsFontSizeToFitWidth = YES;
    [myStepInfoScrollView addSubview:distanceLabel];
    [distanceLabel release];
    
    
    UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(0, 99.5,kDeviceWidth, 0.5)];
    lineView.backgroundColor =  [CommonImage colorWithHexString:@"e5e5e5"];
    [myStepInfoScrollView addSubview:lineView];
    [lineView release];
}

- (void)getPerStepAndAllFenView
{
    CGFloat orignY = 100;
    CGFloat perWidth = (kDeviceWidth - 24)/2.0f;
    //日均步数
    self.perDayStepCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, orignY+17, perWidth, 22)];
    self.perDayStepCountLabel.backgroundColor = [UIColor clearColor];
    self.perDayStepCountLabel.text = self.dataDic[@"stepCnt"];
    self.perDayStepCountLabel.textColor = [CommonImage colorWithHexString:@"fe6339"];
    self.perDayStepCountLabel.font = [UIFont systemFontOfSize:30];
    self.perDayStepCountLabel.textAlignment = NSTextAlignmentCenter;
    [myStepInfoScrollView addSubview:self.perDayStepCountLabel];
    [self.perDayStepCountLabel release];
    UILabel *perCountTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.perDayStepCountLabel.origin.y+self.perDayStepCountLabel.size.height+8, perWidth, 16)];
    perCountTextLabel.backgroundColor = [UIColor clearColor];
    perCountTextLabel.text = @"今日步数";
    perCountTextLabel.textColor = [CommonImage colorWithHexString:@"fe6339"];
    perCountTextLabel.font = [UIFont systemFontOfSize:15];
    perCountTextLabel.textAlignment = NSTextAlignmentCenter;
    [myStepInfoScrollView addSubview:perCountTextLabel];
    [perCountTextLabel release];
    //分隔线
    UIImageView *separImageView = [[UIImageView alloc] initWithFrame:CGRectMake(perWidth , orignY + 20, 24, 40)];
    separImageView.image = [UIImage imageNamed:@"common.bundle/move/move_content_slash.png"];//[self  grayImage:image];
    [myStepInfoScrollView addSubview:separImageView];
    [separImageView release];
    //总积分
    self.allFenLabel = [[UILabel alloc] initWithFrame:CGRectMake(perWidth+24, orignY+17, perWidth, 22)];
    self.allFenLabel.backgroundColor = [UIColor clearColor];
    self.allFenLabel.text = [NSString stringWithFormat:@"%@",self.dataDic[@"point"]];
    self.allFenLabel.textColor = [CommonImage colorWithHexString:@"fea94c"];
    self.allFenLabel.font = [UIFont systemFontOfSize:30];
    self.allFenLabel.textAlignment = NSTextAlignmentCenter;
    [myStepInfoScrollView addSubview:self.allFenLabel];
    [self.allFenLabel release];
    UILabel *allFenTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(perWidth+24, self.allFenLabel.origin.y+self.allFenLabel.size.height+8, perWidth, 16)];
    allFenTextLabel.backgroundColor = [UIColor clearColor];
    allFenTextLabel.text = @"总积分";
    allFenTextLabel.textColor = [CommonImage colorWithHexString:@"fea94c"];
    allFenTextLabel.font = [UIFont systemFontOfSize:15];
    allFenTextLabel.textAlignment = NSTextAlignmentCenter;
    [myStepInfoScrollView addSubview:allFenTextLabel];
    [allFenTextLabel release];
    
    UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(0, 179.5,kDeviceWidth, 0.5)];
    lineView.backgroundColor =  [CommonImage colorWithHexString:@"e5e5e5"];
    [myStepInfoScrollView addSubview:lineView];
    [lineView release];
    //具体内容
    
    BOOL hasSwitchFlag =  [self.userId isEqualToString:g_nowUserInfo.userid];
    
    int row = 0;
    NSString *bsValueString = self.dataDic[@"bsValue"];
    if(bsValueString.length != 0){
        [self getCellViewWithKey:@"最近血糖" Value:[NSString stringWithFormat:@"%@ mmol/L" ,self.dataDic[@"bsValue"]] hasSwitch:hasSwitchFlag index:0 hasTwoValue:NO];
        row += 1;
        
        UILabel *sugarLabel = (UILabel *)[myStepInfoScrollView viewWithTag:100];
        sugarLabel.textColor = [CommonImage colorWithHexString:@"fe6339"];
        sugarLabel.attributedText = [self replaceWithNSString:[NSString stringWithFormat:@"%@ mmol/L" ,self.dataDic[@"bsValue"]] andUseKeyWord:@"mmol/L" andWithFontSize:16 keywordColor:@"333333"];
    }
    
    [self getCellViewWithKey:@"总步数" Value:[NSString stringWithFormat:@"%@ 步" ,self.dataDic[@"totalStepCnt"]] hasSwitch:NO index:row hasTwoValue:NO];
    [self getCellViewWithKey:@"总里程" Value:[NSString stringWithFormat:@"%.2f 公里",[self.dataDic[@"totalDistance"]  floatValue]/1000] hasSwitch:NO index:row+1 hasTwoValue:NO];
    [self getCellViewWithKey:@"总排名" Value:[NSString stringWithFormat:@"%@%@" ,self.dataDic[@"rank"],([self.dataDic[@"rank"] isEqualToString:@"暂无"]?@"":@" 名")] hasSwitch:NO index:row+2 hasTwoValue:NO];
    [self getCellViewWithKey:@"挑战记录" Value:@"" hasSwitch:NO index:row+3 hasTwoValue:YES];
    
    
    UILabel *winFailLabel = (UILabel *)[myStepInfoScrollView viewWithTag:100+row+3];
    winFailLabel.textColor = [CommonImage colorWithHexString:@"fe6339"];
    winFailLabel.attributedText = [self replaceWithNSString:[NSString stringWithFormat:@"胜：%@ 次 负：%@ 次" ,self.dataDic[@"pkWinCnt"],self.dataDic[@"pkFailCnt"]] andUseKeyWord:[NSString stringWithFormat:@"负：%@ 次" ,self.dataDic[@"pkFailCnt"]] andWithFontSize:16 keywordColor:@"479aff"];
    
    
    
    if(!self.isMeFlag){
        UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"91d000"]];
        UIButton * determine = [UIButton buttonWithType:UIButtonTypeCustom];
        determine.frame = CGRectMake(20, winFailLabel.bottom+30, 135, 44);
        [determine addTarget:self action:@selector(determine) forControlEvents:UIControlEventTouchUpInside];
        [determine setTitle:@"加为好友" forState:UIControlStateNormal];
        [determine setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [determine setBackgroundImage:image forState:UIControlStateNormal];
        determine.layer.cornerRadius = 4;
        determine.clipsToBounds = YES;
        [myStepInfoScrollView addSubview:determine];
        image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
        UIButton * challengeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        challengeBtn.frame = CGRectMake(kDeviceWidth-20-135, winFailLabel.bottom+30, 135, 44);
        [challengeBtn addTarget:self action:@selector(sendPkRequest) forControlEvents:UIControlEventTouchUpInside];
        [challengeBtn setTitle:@"挑战" forState:UIControlStateNormal];
        [challengeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [challengeBtn setBackgroundImage:image forState:UIControlStateNormal];
        challengeBtn.layer.cornerRadius = 4;
        challengeBtn.clipsToBounds = YES;
        [myStepInfoScrollView addSubview:challengeBtn];
        myStepInfoScrollView.contentSize = CGSizeMake(kDeviceWidth, determine.bottom + 30);
    }
    
}

- (void)determine
{
    
    //    NSDictionary *dic = self.dataDic;
    //    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    //        //会员
    //        [dataDic setObject:@"0" forKey:@"toType"];//接受者类型
    //        [dataDic setObject:dic[@"userId"] forKey:@"id"];//接受者id
    //        [dataDic setObject:dic[@"iconPath"] forKey:@"filePath"];
    //        [dataDic setObject:dic[@"userName"] forKey:@"nickName"];
    //        [dataDic setObject:[NSString stringWithFormat:@"性别：%@",[CommonUser getSex:[NSString stringWithFormat:@"%@",dic[@"sex"]]]] forKey:@"secText"];
    //        [dataDic setObject:[NSString stringWithFormat:@"年龄：%@",[CommonDate getAgeWithBirthday:dic[@"birthday"]]] forKey:@"thirdText"];
    //
    //        [dataDic setObject:dic[@"userId"] forKey:@"friendId"];//好友Id
    //         [dataDic setObject:@"0" forKey:@"type"];//好友类型
    //
    //    ApplyInfoViewController *applyViewVC = [[ApplyInfoViewController alloc] initWithNibName:@"ApplyInfoViewController" bundle:nil];
    //    applyViewVC.isApplyViewFlag = YES;
    //    applyViewVC.dataDic = dataDic;
    //    [self.navigationController pushViewController:applyViewVC animated:YES];
    //    [applyViewVC release];
    InvitationDoctorViewController * inviration = [[InvitationDoctorViewController alloc]init];
    inviration.m_invite = self.dataDic[@"userNo"];
    [inviration setInviteView];
    [inviration getFriendData];
    [self.navigationController pushViewController:inviration animated:YES];
    [inviration release];
}


- (NSMutableAttributedString *)replaceWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )size keywordColor:(NSString *)colorString
{
    NSMutableAttributedString *attrituteString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
    if(!keyWord){
        return attrituteString;
    }
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:colorString], NSFontAttributeName : [UIFont systemFontOfSize:size]} range:range];
    return attrituteString;
}

- (void)getCellViewWithKey:(NSString *)key Value:(NSString *)value hasSwitch:(BOOL)hasSwitch  index:(int)row hasTwoValue:(BOOL)hasTwoFlag
{
    //key
    CGFloat originY = 180 + row*45 +15;
    UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, originY, 80, 16)];
    keyLabel.font = [UIFont systemFontOfSize:16];
    keyLabel.textColor = [CommonImage colorWithHexString:@"333333"];
    keyLabel.text = key;
    keyLabel.backgroundColor = [UIColor clearColor];
    [myStepInfoScrollView addSubview:keyLabel];
    [keyLabel release];
    
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-120, originY, 100, 16)];
    valueLabel.textAlignment = NSTextAlignmentRight;
    valueLabel.textColor = [CommonImage colorWithHexString:@"fea94c"];
    valueLabel.text = value;
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.font = [UIFont systemFontOfSize:16.0f];
    [myStepInfoScrollView addSubview:valueLabel];
    [valueLabel release];
    valueLabel.tag = 100+row;
    
    
    if(hasSwitch){
        
        BOOL resultFlag = [self.dataDic[@"bsFlag"] isEqualToString:@"Y"]? YES : NO;
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(kDeviceWidth -(IOS_7? 70:90),originY-8, 43, 10)];
        switchView.onTintColor = [CommonImage colorWithHexString:COLOR_FF5351];
        switchView.on = resultFlag;//[self.dataDic[@"bsFlag"] intValue];
        [switchView addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [myStepInfoScrollView addSubview:switchView];
        
        valueLabel.frame = CGRectMake(kDeviceWidth -(IOS_7? 70:90)-120, originY, 100, 16);
        valueLabel.textColor = [CommonImage colorWithHexString:@"fea94c"];
        
    }else{
        CGFloat addWidth = 0;
        if(hasTwoFlag){
            addWidth = 60;
            
        }
        valueLabel.frame =CGRectMake(kDeviceWidth-120-addWidth, originY, 100+addWidth, 16);
        valueLabel.textColor = [CommonImage colorWithHexString:@"333333"];
        
    }
    
    CGFloat originX = 15;
    if(hasTwoFlag){
        originX = 0;
    }
    
    UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(originX, originY-15+44.5,kDeviceWidth, 0.5)];
    lineView.backgroundColor =  [CommonImage colorWithHexString:@"e5e5e5"];
    [myStepInfoScrollView addSubview:lineView];
    [lineView release];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(![flagStr_server isEqualToString:_flagStr]){
        haveUploadSwitchStatusFlag = YES;
    }
    
    if(haveUploadSwitchStatusFlag){
        
        //        NSString *flag = [self.dataDic[@"bsFlag"] boolValue]? @"N" : @"Y";
        
        NSMutableDictionary *requestDic =  [[NSMutableDictionary alloc] initWithCapacity:0];
        [requestDic setValue:_flagStr forKey:@"state"];
        
        [[CommonHttpRequest defaultInstance] sendNewPostRequest:BSValueSwitch values:requestDic requestKey:BSValueSwitch  delegate:self controller:self actiViewFlag:0 title:nil];
        [requestDic release];
        
    }
}

-(void)switchValueChanged:(UISwitch *)switchView
{
    BOOL resultFlag = [self.dataDic[@"bsFlag"] isEqualToString:@"Y"]? YES : NO;
    if(resultFlag != switchView.on){
        haveUploadSwitchStatusFlag = YES;
    }
    if(!switchView.on){
        [Common TipDialog2:@"关闭后血糖值将不会被别人看到。"];
    }
}


- (void)didReceiveMemoryWarning
{
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
