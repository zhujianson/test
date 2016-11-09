//
//  CheckSugarViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-15.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "CheckSugarViewController.h"
#import "SugarListViewController.h"
#import "AppDelegate.h"
#import "KXSlideView.h"
#import "DBOperate.h"
#import "OneCategoryListViewController.h"
#import "SugarDetailViewController.h"
#import "EScrollerView.h"

#import "WebViewController.h"
#import "FoodRecordViewController.h"
#import "FoodDetailViewController.h"
#import "PerfectViewController.h"
//#import "FlyMSC.h"

@interface CheckSugarViewController ()
<SlideViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate,EScrollerViewDelegate>
{
   UISearchDisplayController *searchC;
    DBOperate *myDataBase;
    int currentPage;
    
    __block  UISearchBar *searchBar;
    __block  NSMutableArray *m_arrayImage;//图片数组
    EScrollerView *m_advScroller;
    
    UIScrollView *mainScollview;
    BOOL haveRecomdFood;
    
    UILabel *suggestLabel;//建议
    UILabel *numLabel;//数量
    UILabel *nameLabel;//名字
    UILabel *dayLabel;//日子
    UILabel *monthLabel;//月份
    UIImageView *imgeView;//心形
    UILabel *benefitsNameLable;//益处
    UILabel *benefitsLable;//益处
}

@property (nonatomic,retain)NSMutableArray *searchArray;
@end

@implementation CheckSugarViewController
- (void)dealloc
{
    [mainScollview release];
    [m_arrayImage release];
    [_searchArray release];
    m_advScroller.delegate = nil;
    [m_advScroller release];

    [super dealloc];
}

//- (BOOL)closeNowView
//{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    return NO;
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"食物库";
        self.log_pageID = 149;

        self.searchArray = [[NSMutableArray alloc] initWithCapacity:0];
        myDataBase = [DBOperate shareInstance];
         m_arrayImage = [[NSMutableArray alloc] init];
        
//        UIBarButtonItem *right = [Common createNavBarButton:self setEvent:@selector(butEVent) withNormalImge:@"common.bundle/nav/editor_normal.png" andHighlightImge:@"common.bundle/nav/editor_pressed.png"];
//        self.navigationItem.rightBarButtonItem = right;
//        [FlyMSC shareInstance];
    }
    return self;
}

-(void)butEVent
{
    PerfectViewController * perf = [[PerfectViewController alloc]init];
    perf.isNew = YES;
    [self.navigationController pushViewController:perf animated:YES];
    [perf release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *myDelegate = [Common getAppDelegate];
    myDelegate.navigationVC = self.navigationController;
    // Do any additional setup after loading the view.

    searchBar =
    [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
    searchBar.delegate = self;
    searchBar.layer.borderWidth = 0.5f;
    searchBar.layer.borderColor = [CommonImage colorWithHexString:@"e5e5e5"].CGColor;
    if (IOS_7) {
        searchBar.barTintColor = [CommonImage colorWithHexString:@"e5e5e5"];
    } else {
        searchBar.tintColor = [CommonImage colorWithHexString:@"e5e5e5"];
        //右按钮微调ios6下
         [searchBar setPositionAdjustment:UIOffsetMake(-10, 0) forSearchBarIcon:UISearchBarIconBookmark];
    }
    
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    [searchField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
     searchBar.showsBookmarkButton =YES;
    [searchBar setImage:[UIImage imageNamed:@"common.bundle/check/voice.png"]forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    [searchBar setImage:[UIImage imageNamed:@"common.bundle/check/voicePress.png"]forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateHighlighted];
    searchC = [[UISearchDisplayController alloc] initWithSearchBar:searchBar
                                                contentsController:self];
    searchC.delegate = self;
    searchC.searchResultsDelegate = self;
    searchC.searchResultsDataSource = self;
    //    searchC.searchResultsTableView.backgroundColor = [UIColor clearColor];
    searchC.searchResultsTableView.frame =  CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
//    CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 100);
    searchBar.placeholder = @"请输入菜名或食材";
    [self setExtraCellLineHidden:searchC.searchResultsTableView];
    searchBar.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:searchBar];
    [searchBar release];

    //scrollView
    //食物列表
    SugarListViewController *foodVC = [[SugarListViewController alloc] init];
    foodVC.foodListFlag =YES;
    foodVC.view.frame = CGRectMake(0, 0, kDeviceWidth, SCREEN_HEIGHT-44-50-40);
    //菜谱列表
    SugarListViewController *menuVC = [[SugarListViewController alloc] init];
    menuVC.view.frame = CGRectMake(0, 0, kDeviceWidth, SCREEN_HEIGHT-44-50-40);
    menuVC.foodListFlag = NO;
    NSArray *viewArray = @[foodVC,menuVC];
    NSArray *titleArray = @[@"食物",@"菜谱"];
//    SlideView *slideView = [[SlideView alloc] initWithFrame:CGRectMake(0, 50, kDeviceWidth, SCREEN_HEIGHT-44-50) titleHeight:30];
////   slideView.backgroundColor = [UIColor redColor];
//    slideView.theTitleType = SegmentTypeWithTwoItem;
//    slideView.delegate = self;
//    [self.view addSubview:slideView];
//    [slideView release];
//    
//    [slideView  setTitleArray:titleArray SourcesArray:viewArray SetDefault:0];

//    [self createContentView];
//    [self loadAdvData];
    
    
    KXSlideView *kxSlideView = [[KXSlideView alloc] initWithFrame:CGRectMake(0, 50, kDeviceWidth, SCREEN_HEIGHT-44-50) titleScrollViewFrame:
                                CGRectMake(0, 0, kDeviceWidth, 40)];
    kxSlideView.theSlideType = SegmentType;
    kxSlideView.delegate = self;
    [kxSlideView setTitleArray:titleArray SourcesArray:viewArray SetDefault:0];
    [self.view addSubview:kxSlideView];
    [kxSlideView release];
    [foodVC release];
    [menuVC release];
    
    
}

/*
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
      [searchBar  resignFirstResponder];
      [self vocieRecognizer];
       NSLog(@"click");
}

-(void)createContentView
{
    float leftWeight = 10;
    mainScollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, searchBar.bottom, kDeviceWidth, kDeviceHeight-searchBar.bottom)];
    [self.view addSubview:mainScollview];
    
    float offset = leftWeight;

    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(leftWeight, offset, kDeviceWidth-2*leftWeight, 40)];
    topView.backgroundColor = [CommonImage colorWithHexString:@"ebebeb"];
    [mainScollview addSubview:topView];
    [topView release];
    
    nameLabel = [Common createLabel:CGRectMake(10,0,200,topView.height) TextColor:@"333333" Font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentLeft labTitle:@"黑椒牛排"];
    [topView addSubview:nameLabel];
    
    UILabel *lineLabel = [Common createLabel:CGRectMake(topView.width-50,leftWeight,0.5,topView.height-leftWeight*2) TextColor:@"999999" Font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft labTitle:nil];
    lineLabel.backgroundColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_SHEN];
    [topView addSubview:lineLabel];
//    5是空隙
    dayLabel = [Common createLabel:CGRectMake(lineLabel.right+5,0,50,topView.height) TextColor:@"999999" Font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft labTitle:@"23日"];
    [topView addSubview:dayLabel];
    
    monthLabel = [Common createLabel:CGRectMake(lineLabel.left-30-5,0,30,topView.height) TextColor:@"999999" Font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentRight labTitle:@"3月"];
    [topView addSubview:monthLabel];
    
    offset += topView.height;
    UIButton *backView = [UIButton buttonWithType:UIButtonTypeCustom];
    backView.tag = 1006;
    UIImage *image = [UIImage imageNamed:@"common.bundle/check/recommendDefault.png"];
    NSString *recommendTitle = @"查看推荐菜品";
    backView.contentMode = UIViewContentModeScaleAspectFill;
    backView.titleLabel.font = [UIFont systemFontOfSize:15.0];
    UIImage* imageBack =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"8ccf44"]];
    [backView setBackgroundImage:imageBack forState:UIControlStateNormal];
    //    [backView addTarget:self action:@selector(backViewClick) forControlEvents:UIControlEventTouchUpInside];
    [backView setImage:image forState:UIControlStateNormal];
    [backView setTitle:recommendTitle forState:UIControlStateNormal];
    backView.frame = CGRectMake(leftWeight, offset, kDeviceWidth-2*leftWeight,kDeviceWidth-2*leftWeight);
    [backView setTitleEdgeInsets:UIEdgeInsetsMake(33, -image.size.width, -33, 0)];
    [backView setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 10, -[recommendTitle sizeWithFont:backView.titleLabel.font].width)];
    
    UILabel *dateLabel = [Common createLabel:CGRectMake(15,10,200,20) TextColor:@"ffffff" Font:[UIFont systemFontOfSize:21] textAlignment:NSTextAlignmentLeft labTitle:@""];
    [backView addSubview:dateLabel];
    //    dateLabel.text = [Common formatCreatetTime:[NSDate date]];
    dateLabel.text = @"今天";
    [mainScollview addSubview:backView];
    
    offset += backView.height;
    UIView *bottomView = [[[UIView alloc]initWithFrame:CGRectMake(leftWeight, offset, kDeviceWidth-2*leftWeight, 40)]autorelease];
    bottomView.backgroundColor = [CommonImage colorWithHexString:@"ebebeb"];
    [mainScollview addSubview:bottomView];
    
    UIImage* imageBackView  = [UIImage imageNamed:@"common.bundle/check/bgMask.png"];
    UIImageView *bgImgeView = [[UIImageView alloc]initWithImage:imageBackView];
    bgImgeView.tag = 2103;
    bgImgeView.frame = CGRectMake(0,0, imageBackView.size.width,imageBackView.size.height);
    bgImgeView.userInteractionEnabled = YES;
    [mainScollview addSubview:bgImgeView];
    bgImgeView.center = CGPointMake(bottomView.center.x, bottomView.center.y-(bgImgeView.height- bottomView.height)/2.0);
    
    
    UIImage *imgeCmera = [UIImage imageNamed:@"common.bundle/check/camera.png"];
    UIImage *imgeCmeraPress = [UIImage imageNamed:@"common.bundle/check/camera_p.png"];
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    customButton.frame = CGRectMake(0,0, imageBackView.size.width,imageBackView.size.height);
    customButton.tag = 100;
//    customButton.layer.cornerRadius = customButton.width/2.0;
//    customButton.clipsToBounds = YES;
    [customButton setImage:imgeCmera forState:UIControlStateNormal];
    [customButton setImage:imgeCmeraPress forState:UIControlStateHighlighted];
//    UIImage* imageBackView =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"ededed"]];
//  [customButton setBackgroundImage:imageBackView forState:UIControlStateNormal];
    [customButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [customButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [customButton setImageEdgeInsets:UIEdgeInsetsMake(2, 0, -2, 0)];
    [bgImgeView addSubview:customButton];
    [bgImgeView release];
//    customButton.center = CGPointMake(bottomView.center.x, bottomView.center.y-(customButton.height- bottomView.height)/2.0);
    
    suggestLabel = [Common createLabel:CGRectMake(10,0,200,bottomView.height) TextColor:@"666666" Font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentLeft labTitle:@"建议食用:106克"];
    [bottomView addSubview:suggestLabel];
    
    NSString * title = @"123";
    float titleWeight = [Common sizeForString:title andFont:14].width;
    numLabel = [Common createLabel:CGRectMake(bottomView.width-15-titleWeight, 0, titleWeight, bottomView.height) TextColor:@"666666" Font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentRight labTitle:title];
    [bottomView addSubview:numLabel];
    
    UIImage *headtImage = [UIImage imageNamed:@"common.bundle/check/tcc/heart.png"];
    imgeView = [[UIImageView alloc]initWithFrame:CGRectMake(numLabel.left-10-headtImage.size.width,(bottomView.height-headtImage.size.height)/2 , headtImage.size.width, headtImage.size.height)];
    imgeView.image = headtImage;
    [bottomView addSubview:imgeView];
    [imgeView release];
    
    offset += bottomView.height +15;
    UIView *coverView = [[[UIView alloc]initWithFrame:CGRectMake(leftWeight, offset, kDeviceWidth-2*leftWeight, 40)]autorelease];
    coverView.backgroundColor = self.view.backgroundColor;
    [mainScollview addSubview:coverView];
    
    benefitsNameLable = [Common createLabel:CGRectMake(leftWeight, offset, coverView.width, 14) TextColor:COLOR_FF5351 Font:[UIFont systemFontOfSize:15.0] textAlignment:NSTextAlignmentLeft labTitle:nil];
    [mainScollview addSubview:benefitsNameLable];
    
    benefitsLable = [Common createLabel:CGRectMake(leftWeight, benefitsNameLable.bottom+5, coverView.width, 0) TextColor:@"333333" Font:[UIFont systemFontOfSize:15.0] textAlignment:NSTextAlignmentLeft labTitle:nil];
    benefitsLable.numberOfLines = 0;
    benefitsNameLable.lineBreakMode = NSLineBreakByWordWrapping;
    [mainScollview addSubview:benefitsLable];
    
    mainScollview.contentSize = CGSizeMake(kDeviceWidth, offset);
}

#pragma mark --食物功效
-(void)updateScrollViewContentSizeWithBenefitsLable:(NSDictionary *)foodDict withKey:(NSString *)keyString
{
    NSString *colums_show = foodDict[@"colums_show"];//f07 对应食物功效
    float height = 0;
    if (colums_show.length && [colums_show  containsString:keyString])
    {
        NSString *benefitString = foodDict[@"food_efficacy"];
        if (benefitString.length)
        {
            benefitsNameLable.text = @"食物功效 : ";
            benefitsLable.text = benefitString;
            CGSize size = [Common sizeForAllString:benefitString andFont:15.0 andWight:benefitsLable.width];
            height = size.height;//数据有截断89.7777 截断为89.777 
        }
    }
    benefitsLable.frameHeight = ceilf(height);
    float offset = benefitsLable.bottom;
    mainScollview.contentSize = CGSizeMake(kDeviceWidth, offset);
}

//完善信息
-(void)backViewClick
{
    if(!haveRecomdFood)
        [self butEVent];
}

- (void)viewWillAppear:(BOOL)animated
{
//    self.tabBarController.tabBar.hidden = YES;
//    if (!m_arrayImage.count)
//    {
        //是否完善信息,然后推荐食物
//        NSString *recomdFood = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_getCheckUsertype",g_nowUserInfo.userid]];
//        haveRecomdFood = recomdFood.length? YES:NO;
//    }
//    else
//    [m_advScroller startPlayAdv];
//    [self loadAdvData];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [m_advScroller pausePlayAdv];
    [super viewWillDisappear:animated];
}

#pragma mark 识别语音
-(void)vocieRecognizer
{
//    [[FlyMSC shareInstance] setIFlYRecognizerViewCenterInFatherView:self.view];
    [[FlyMSC shareInstance] createIFlyRecognizerView:self.view];
    [[FlyMSC shareInstance] listenword:^(NSString *content, int errorCode) {
        [searchBar  becomeFirstResponder];
        searchBar.text = content;
        [self searchBar:searchBar textDidChange:content];
    }];
}

-(void)btnClick:(UIButton *)button
{
    button.enabled = NO;
    int buttonTag = (int)button.tag;
    switch (buttonTag)
    {
        case 100:
        {
            NSLog(@"拍食物");
            FoodRecordViewController * foot = [[FoodRecordViewController alloc]init];
            foot.title = @"拍食物";
            [self.navigationController pushViewController:foot animated:YES];
            [foot release];
        }
            break;
        case 101:
        {
//            [self vocieRecognizer];
            NSLog(@"语言搜索");
        }
            break;
        default:
            break;
    }
     button.enabled = YES;
}

-(void)leftAndRightbtnClick:(UIButton *)button
{
    int buttonTag = (int)button.tag;
    switch (buttonTag)
    {
        case 200:
        {
            [m_advScroller setShowImageViewIndex:m_advScroller.getCpage-1];
            NSLog(@"left");
        }
            break;
        case 201:
        {
             [m_advScroller setShowImageViewIndex:m_advScroller.getCpage+1];
            NSLog(@"right");
        }
            break;
        default:
            break;
    }
}

- (void)loadAdvData
{
    NSMutableDictionary *dict = [@{@"userId": g_nowUserInfo.userid} mutableCopy];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GET_FOODHOME values:dict requestKey:GET_FOODHOME delegate:self controller:self actiViewFlag:0 title:nil];
    [dict release];
}

//创建广告滚动条
- (void)createAdvertising:(NSMutableArray*)array
{
    if (m_advScroller) {
        [m_advScroller setCreatBackViewStr:array];
    }
    else {
        
        UIView *backView = [mainScollview viewWithTag:1006];
        
        NSArray *imgeArrays = @[@"common.bundle/check/left.png",@"common.bundle/check/right.png"];
        for (int i = 0; i<2; i++)
        {
            UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
            customButton.frame = CGRectMake(!i?0:kDeviceWidth-40, backView.center.y-20,40,40);
            customButton.tag = 200+i;
            [customButton setBackgroundImage:[UIImage imageNamed:imgeArrays[i]] forState:UIControlStateNormal];
            [customButton addTarget:self action:@selector(leftAndRightbtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [mainScollview addSubview:customButton];
        }
        
        m_advScroller = [[EScrollerView alloc] initWithFrameRect:backView.frame ImageArray:array isAutoPlay:NO setImageKey:@"picture_url"];
        m_advScroller.delegate = self;
        UIImageView *imageView = (UIImageView *)[mainScollview viewWithTag:2103];
        NSInteger index = [mainScollview.subviews indexOfObject:imageView];
        // 插入到按钮下面
        [mainScollview insertSubview:m_advScroller atIndex:index];
        m_advScroller.showPageControl = NO;
        [backView removeFromSuperview];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [m_advScroller setShowImageViewIndex:m_advScroller.getCpage+1];//跳到当天
        });
    }
}

//广告点击回调
- (void)touchAdvertising:(NSMutableDictionary*)dic
{
    NSLog(@"+++++%@",dic);
  	FoodDetailViewController *help = [[FoodDetailViewController alloc] init];
    help.dictInfo = dic;
    help.title = dic[@"flagString"];
  	[self.navigationController pushViewController:help animated:YES];
   	[help release];
}

/**
 *  隐藏tableviewd多余分割线
 *
 *  @param tableView
 */
- (void)setExtraCellLineHidden:(UITableView *)tableView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [view release];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //Class:UISearchResultsTableView isKindOfClass: UITableView  正确 （小属于大）
    
    return self.searchArray.count;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierCell = @"sugerlistCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"sugarCell"] autorelease];
        //自定义右箭头
        cell.accessoryView = [CommonImage creatRightArrowX:cell.frame.size.width-22 Y:(cell.frame.size.height-12)/2 cell:cell];
        cell.backgroundColor = [UIColor clearColor];//[CommonImage colorWithHexString:@"#f6f7ed"];
        cell.contentView.backgroundColor = [UIColor clearColor];//[CommonImage colorWithHexString:@"#f6f7ed"];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];
        cell.textLabel.textColor = [CommonImage colorWithHexString:@"#333333"];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.frame = CGRectMake(20, 13, 200, 16);
        cell.detailTextLabel.textColor = [CommonImage colorWithHexString:@"#343434"];
        cell.detailTextLabel.font =[UIFont systemFontOfSize:14.0f];
        cell.detailTextLabel.frame = CGRectMake(20, 38, 200, 15);
    }
    
    NSDictionary *oneDic = self.searchArray[indexPath.row];
//    if(!currentPage){
    if ([oneDic[@"INGREDIENT"] length])
    {
        cell.textLabel.text = oneDic[@"INGREDIENT"];
    }else{
        cell.textLabel.text = oneDic[@"DISH"];
    }
    
    NSString *gl100GString = oneDic[@"GL_100G"];
    
    
    if([gl100GString floatValue] <= 10){
        cell.detailTextLabel.text = NSLocalizedString(@"宜食", @"");
        cell.detailTextLabel.textColor = [CommonImage colorWithHexString:@"56b2ff"];
    }else if([gl100GString floatValue] >10 && [gl100GString floatValue] < 20){
        cell.detailTextLabel.text = NSLocalizedString(@"不宜食", @"");
        cell.detailTextLabel.textColor = [CommonImage colorWithHexString:@"ffa34d"];
    }else {
        cell.detailTextLabel.text = NSLocalizedString(@"少食", @"");
        cell.detailTextLabel.textColor = [CommonImage colorWithHexString:@"e75441"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;// [[self.dataHeightArray objectAtIndex:indexPath.row] floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *key = nil;
    NSString *name = nil;
    
    NSDictionary *oneDic = self.searchArray[indexPath.row];
    if([oneDic[@"INGREDIENT"] length]){
        key = oneDic[@"id"];
        name = oneDic[@"INGREDIENT"];
        currentPage = 0;
    }else{
        key = oneDic[@"ID"];
        name = oneDic[@"DISH"];
        currentPage = 1;
    }
    
    SugarDetailViewController *sugarDetailVC = [[SugarDetailViewController alloc] init];
    sugarDetailVC.ismenu = currentPage;
    sugarDetailVC.title = name;
    sugarDetailVC.key = key;
    [self.navigationController pushViewController:sugarDetailVC animated:YES];
    [sugarDetailVC release];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  滑动代理函数
 *
 *  @param page
 */
-(void)selPageScrollView:(int)page
{
    currentPage = page;
    if(currentPage == 0){
        searchBar.placeholder = @"请输入食物名称(支持拼音)";
    }else{
        searchBar.placeholder = @"请输入菜谱名称(支持拼音)";
    }
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    NSLog(@"---%@", searchText);
    //移除之前的内容
    [self.searchArray removeAllObjects];
    //获得
    
    NSString *sql = nil;
    NSArray *specialArray = nil;
//    if(currentPage == 0){
//        sql = [NSString
//               stringWithFormat:@"SELECT TCC_IC.CODE,TCC_IC.CATALOG\
//               FROM TCC_IC\
//               WHERE (TCC_IC.CATALOG LIKE '%%%@%%'\
//               OR TCC_IC.PINYIN LIKE '%%%@%%')\
//               ORDER BY TCC_IC.CODE ASC",searchText,searchText];
//        specialArray = [myDataBase getDataForSQL:sql getParam:@[@"CODE",@"CATALOG"]];
        
        
        sql = [NSString stringWithFormat:@"SELECT TCC_INGREDIENTS.id,\
               TCC_INGREDIENTS.INGREDIENT,TCC_INGREDIENTS.GL_100G\
               FROM TCC_INGREDIENTS\
               WHERE (((TCC_INGREDIENTS.INGREDIENT LIKE '%%%@%%') OR (TCC_INGREDIENTS.PINYIN LIKE '%%%@%%') OR (TCC_INGREDIENTS.PINYIN_INDEX LIKE '%%%@%%'))) ORDER BY TCC_INGREDIENTS.PINYIN ASC",searchText,searchText,searchText];
        
        specialArray = [myDataBase getDataForSQL:sql getParam:@[@"id", @"INGREDIENT",@"GL_100G"]];
      [self.searchArray addObjectsFromArray:specialArray];
        
//    }else{
//
//        sql = [NSString
//               stringWithFormat:@"SELECT DISTINCT TCC_DISHES.SOC\
//               FROM TCC_DISHES WHERE SOC like '%%%@%%' OR  SOCPINYIN LIKE '%%%@%%'",searchText,searchText];
//        specialArray = [myDataBase getDataForSQL:sql getParam:@[@"SOC"]];
        
        sql = [NSString stringWithFormat:@"SELECT TCC_DISHES.ID,\
               TCC_DISHES.DISH,TCC_DISHES.GL_100G\
               FROM TCC_DISHES WHERE (((DISH like '%%%@%%')OR(DISH_PINYIN LIKE '%%%@%%') OR (DISH_PINYIN_INDEX LIKE '%%%@%%'))) ORDER BY TCC_DISHES.DISH_PINYIN ASC",searchText,searchText,searchText];
        specialArray = [myDataBase getDataForSQL:sql getParam:@[@"ID", @"DISH",@"GL_100G"]];
    
//    }
        NSLog(@"clss:%@",specialArray);
    
    [self.searchArray addObjectsFromArray:specialArray];
    [searchC.searchResultsTableView reloadData];
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}


- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    NSArray *resultArray = dic[@"rs"];
    NSLog(@"%@",dic);
    if (![[dic objectForKey:@"state"] intValue])
    {
         if ([loader.username isEqualToString:GET_FOODHOME]) {
             __block CheckSugarViewController *weakSelf =  self;
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                 [m_arrayImage removeAllObjects];
                 [m_arrayImage addObjectsFromArray:resultArray];
                 [weakSelf updateDateFromArray:m_arrayImage];
                 dispatch_async( dispatch_get_main_queue(), ^(void){
                     if (resultArray.count>0)
                     {
                         [weakSelf createAdvertising:m_arrayImage];
                     }
                 });
             });
        }
    }
}

#pragma mark ----改变数值
-(void)changeViewDataWith:(NSDictionary *)dic
{
    NSString *title = [dic[@"hug_count"] stringValue];
    float titleWeight = [Common sizeForString:title andFont:14].width;
    numLabel.frame = CGRectMake(m_advScroller.width-15-titleWeight, 0, titleWeight, numLabel.height);
    imgeView.frameX = numLabel.left-10-imgeView.image.size.width;
    if ([dic[@"flagDes"] length])
    {
          nameLabel.attributedText = dic[@"flagDes"];
    }
    else
        nameLabel.text = dic[@"name"];
    numLabel.text = title;
    
    dayLabel.attributedText = dic[@"scheduling_day"];
    monthLabel.text = dic[@"scheduling_month"];
    suggestLabel.text = dic[@"eatSugget"];
    [self updateScrollViewContentSizeWithBenefitsLable:dic withKey:@"f07"];
}

-(void)updateDateFromArray:(NSMutableArray *)array
{
    if (!array.count)
    {
        return;
    }
    NSCalendar *myCalendar = [NSCalendar currentCalendar];
    // 当前日期
//    int currentDate = (int)[myCalendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSString *flagString = @"";
    for (int i =0 ;i<array.count; i++)
    {
        NSMutableDictionary *indexDict = array[i];
        NSString *scheduling_date = indexDict[@"scheduling_date"];
//          NSString *scheduling_date = @"2015-05-03";
        if (scheduling_date.length)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *selectDate = [formatter dateFromString:scheduling_date];
            NSString *curuunet = [formatter stringFromDate: [NSDate date]]; //统一时间点
            NSDate *currentDate = [formatter dateFromString:curuunet];
            [formatter release];
            
            // 目标日期
             NSDateComponents *comps = [myCalendar components:unitFlags fromDate:currentDate toDate:selectDate options:0];
            int diff = (int)comps.day;
            int diffMonth = (int)comps.month;
            if (diffMonth ==0 && diff < 2 && diff >= -1)
            {
                switch (diff)
                {
                    case 0:
                        flagString = @"今日";
                        break;
                    case 1:
                        flagString = @"明日";
                        break;
                    case -1:
                        flagString = @"昨日";
                        break;
                    default:
                        break;
                }
            }
            
//           NSString *keyWord = [NSString stringWithFormat:@"(%@)",flagString];
//           NSString *dayString = [NSString stringWithFormat:@"%d日%@",tar,keyWord];
//           NSMutableAttributedString *wordString = [self replaceRedColorWithNSString:dayString andUseKeyWord:keyWord andWithFontSize:15.0];
//           [indexDict setObject:wordString forKey:@"flagString"];
            
            if ([indexDict[@"doc_role"] length])
            {
                NSString *keyWord = [NSString stringWithFormat:@"(%@)",[self convertTagertString:indexDict[@"doc_role"] toWithDefaultString:@""]];
                NSString *dayString = [NSString stringWithFormat:@"%@  %@",indexDict[@"name"],keyWord];
                NSMutableAttributedString *wordString = [self replaceRedColorWithNSString:dayString andUseKeyWord:keyWord andWithFontSize:12.0 andWithFrontColor:@"666666"];
                [indexDict setObject:wordString forKey:@"flagDes"];
            }

            [indexDict setObject:[flagString stringByAppendingString:@"推荐"] forKey:@"flagString"];
            
            NSString *timeTypeString = [self getEatTimeFromDict:indexDict];
            [indexDict setObject:timeTypeString forKey:@"timeType"];
            
            NSString *eatSuggetString = [self getEatSuggestString:indexDict];
            [indexDict setObject:eatSuggetString forKey:@"eatSugget"];
            
            NSRange range = NSMakeRange(5, 2);
            NSString *scheduling_month = [[scheduling_date substringWithRange:range] stringByAppendingString:@"月"];
            [indexDict setObject:scheduling_month forKey:@"scheduling_month"];
            range.location += 3;
            NSString *scheduling_day = [scheduling_date substringWithRange:range];
            
            NSString *dayAllString = [NSString stringWithFormat:@"%@日",scheduling_day];
            NSMutableAttributedString *scheduling_dayNew = [self replaceRedColorWithNSString:dayAllString andUseKeyWord:scheduling_day andWithFontSize:20.0 andWithFrontColor:COLOR_FF5351];
            [indexDict setObject:scheduling_dayNew forKey:@"scheduling_day"];
        }
    }
}

///  得到进餐时间
///
///  @param dict 字典
///
///  @return 返回拼接字符串
-(NSString *)getEatTimeFromDict:(NSMutableDictionary *)dict
{
    NSString *eatTimeString = nil;
    NSString *startHours = [self convertTagertString: dict[@"start_hours"] toWithDefaultString:@"07"];
    NSString *startMinute = [self convertTagertString:dict[@"start_minute"] toWithDefaultString:@"00"];
    NSString *end_hours = [self convertTagertString:dict[@"end_hours"] toWithDefaultString:@"09"];
    NSString *end_minute = [self convertTagertString:dict[@"end_minute"] toWithDefaultString:@"00"];
    NSString *timeType = dict[@"time_type"];
    NSString *timeTypeString = @"早餐";
//    时间段类型(1.早餐 2.午餐 3.晚餐 4.加餐)
    switch ([timeType intValue])
    {
        case 1:
            timeTypeString = @"早餐";
            break;
        case 2:
            timeTypeString = @"午餐";
            break;
        case 3:
            timeTypeString = @"晚餐";
            break;
        case 4:
            timeTypeString = @"加餐";
            break;
        default:
            break;
    }
    eatTimeString = [NSString stringWithFormat:@"%@ : %@:%@-%@:%@",timeTypeString,startHours,startMinute,end_hours,end_minute];
    return eatTimeString;
}

///  对空对象进行默认赋值
///
///  @param tagertString   原来字符串
///  @param defautltString 默认字符串
///
///  @return 根据情况返回字符串
-(NSString *)convertTagertString:(NSString *)tagertString toWithDefaultString:(NSString *)defautltString
{
    if ((NSNull *)tagertString  == [NSNull null] || ![tagertString length] || [@"" isEqualToString: tagertString])
    {
        return defautltString;
    }
    else
        return tagertString;
}

///  建议食用
///
///  @param dict 原数据
///
///  @return 返回拼接
-(NSString *)getEatSuggestString:(NSMutableDictionary *)dict
{
    NSString *eatSuggestString = nil;
    NSString *recommendUse = [self convertTagertString: dict[@"recommend_use"] toWithDefaultString:@"0"];
    NSString *unitType = dict[@"unit"];
    NSString *unitTypeString = @"g";
    //   单位(单位：1-g,2-ml)
    switch ([unitType intValue])
    {
        case 1:
            unitTypeString = @"g";
            break;
        case 2:
            unitTypeString = @"ml";
            break;
        default:
            break;
    }
    eatSuggestString = [NSString stringWithFormat:@"建议食用 : %@ %@",recommendUse,unitTypeString];
    return eatSuggestString;
}

- (NSMutableAttributedString *)replaceRedColorWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )size andWithFrontColor:(NSString *)frontColor
{
    NSMutableAttributedString *attrituteString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:frontColor], NSFontAttributeName : [UIFont systemFontOfSize:size]} range:range];
    return attrituteString;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UITableView *tableView = [searchC searchResultsTableView];
    [tableView setContentInset:UIEdgeInsetsMake(0, 0, kbSize.height, 0)];
    [tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, kbSize.height, 0)];
}

@end
