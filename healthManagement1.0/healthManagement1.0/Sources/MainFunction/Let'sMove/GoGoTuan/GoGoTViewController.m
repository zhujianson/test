//
//  GoGoTViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-11-26.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "GoGoTViewController.h"
#import "SugarListViewController.h"
#import "AppDelegate.h"
#import "KXSlideView.h"
#import "DBOperate.h"
#import "OneCategoryListViewController.h"
#import "SugarDetailViewController.h"
#import "AllGGTViewController.h"
#import "MyGGTViewController.h"
#import "MyGGTTableViewCell.h"
#import "StepTeamMemViewController.h"



@interface GoGoTViewController ()
<SlideViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UISearchDisplayController *searchC;
    int currentPage;
    
    UISearchBar *searchBar;
}
@property (nonatomic,retain)NSMutableArray *searchArray;

@end

@implementation GoGoTViewController


- (void)dealloc
{
    self.searchArray = nil;
    
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.searchArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"走走团";
    self.view.backgroundColor = [CommonImage colorWithHexString:Color_fafafa];

    //全部团
    AllGGTViewController *allGGTVC = [[AllGGTViewController alloc] init];
    allGGTVC.view.frame = CGRectMake(0, 10, kDeviceWidth, kDeviceHeight-50);
    allGGTVC.view.backgroundColor = [UIColor clearColor];
    allGGTVC.view.clipsToBounds = YES;
    
    //我的团
    MyGGTViewController *myGGTVC = [[MyGGTViewController alloc] init];
    myGGTVC.view.frame = CGRectMake(0, 10, kDeviceWidth, kDeviceHeight-50);
    myGGTVC.view.clipsToBounds = YES;
    myGGTVC.view.backgroundColor = [UIColor clearColor];
    NSArray *viewArray = @[allGGTVC,myGGTVC];
    NSArray *titleArray = @[@"全部",@"我的团"];
//    SlideView *slideView = [[SlideView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) titleHeight:40 withTitleButHeight:30 withY:0];
//    slideView.LineSeparate = YES;
//    [slideView noScrollWithTheContentView];//停止滑动
//    slideView.theTitleType = SegmentTypeWithTwoItem;
//    slideView.delegate = self;
//    [self.view addSubview:slideView];
//    [slideView release];
//    [slideView setTitleArray:titleArray SourcesArray:viewArray SetDefault:0];
    
    
    KXSlideView *kxSlideView = [[KXSlideView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) titleScrollViewFrame:
                                CGRectMake(0, 0, kDeviceWidth, 40)];
    kxSlideView.theSlideType = SegmentType;
    kxSlideView.delegate = self;
    [kxSlideView forbiddenScorllContentView];
    [kxSlideView setTitleArray:titleArray SourcesArray:viewArray SetDefault:0];
    [self.view addSubview:kxSlideView];
    [kxSlideView release];

    [allGGTVC release];
    [myGGTVC release];
    
    
//    UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5,kDeviceWidth, 0.5)];
//    lineView.backgroundColor =  [CommonImage colorWithHexString:@"e5e5e5"];
//    [self.view addSubview:lineView];
//    [lineView release];

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
    return self.searchArray.count;
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
    if(indexPath.row >= self.searchArray.count){
        return cell;
    }
    
    //    NSDictionary *oneDic = self.dataArray[indexPath.row];
    //    NSMutableDictionary *theDic = [NSMutableDictionary dictionaryWithDictionary:oneDic];
    //    [theDic setObject:self.myName forKey:@"myName"];
    //    [theDic setObject:self.otherName forKey:@"otherName"];
    //
    //    [cell setDataDic:theDic];
    
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
    //    NSDictionary *otherScoreDic = self.dataArray[indexPath.row];
    memberListVC.hasApplyFlag = YES;
    [appDelegate.navigationVC pushViewController:memberListVC animated:YES];
    [memberListVC release];
    
}

/**
 *  输入中
 *
 *  @param searchBar  search
 *  @param searchText 输入的内容
 */

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:animated];
    [self performSelector:@selector(hiddenNavigationBarLine) withObject:nil afterDelay:0];
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
        self.log_pageID = 108;
        searchBar.placeholder = @"搜索";
    }else{
        self.log_pageID = 109;
        searchBar.placeholder = @"搜索";
    }
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    NSLog(@"---%@", searchText);
    //移除之前的内容
    [self.searchArray removeAllObjects];
    //获得
    
//    NSString *sql = nil;
    NSArray *specialArray = nil;
    if(currentPage == 0){
        //        sql = [NSString
        
    }else{
        //
        //        sql = [NSString
        //               stringWithFormat:@"SELECT DISTINCT TCC_DISHES.SOC\
        //               FROM TCC_DISHES WHERE SOC like '%%%@%%' OR  SOCPINYIN LIKE '%%%@%%'",searchText,searchText];
        //        specialArray = [myDataBase getDataForSQL:sql getParam:@[@"SOC"]];
        
       }
    NSLog(@"clss:%@",specialArray);
    
    [self.searchArray addObjectsFromArray:specialArray];
    [searchC.searchResultsTableView reloadData];
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
