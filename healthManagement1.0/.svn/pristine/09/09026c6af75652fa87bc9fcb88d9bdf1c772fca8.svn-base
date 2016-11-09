//
//  SOSViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-6.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "SOSViewController.h"
#import "SOSDetailViewController.h"
#import "DBOperate.h"

@interface SOSViewController ()<UISearchBarDelegate, UISearchDisplayDelegate,
                                UITableViewDataSource, UITableViewDelegate> {
  UISearchDisplayController *searchC;
  DBOperate *myDataBase;
  UITableView *allTableView;
}

@property(nonatomic, retain) NSMutableArray *dataArray;    //数据源
@property(nonatomic, retain) NSMutableArray *searchArray;  //搜索数据源

@end

@implementation SOSViewController

- (void)dealloc {
  self.dataArray = nil;
  self.searchArray = nil;
  self.titleName = nil;
  [searchC release];
  [allTableView release];

  [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    self.dataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    self.searchArray =
        [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    myDataBase = [DBOperate shareInstance];
  }
  return self;
}

/**
 *  获得列表数组
 */
- (void)getSOSClassiesArray {
  if (self.secondPage) {
      [self stopLoadingActiView];//隐藏view
      return;
  }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *sql = [NSString
                         stringWithFormat:@"SELECT\
                         DMKBASE_FIRSTAID.ID,\
                            DMKBASE_FIRSTAID.NAME\
                         FROM DMKBASE_FIRSTAID"];
        
        NSArray *classiesArray =
        [myDataBase getDataForSQL:sql getParam:@[ @"ID",@"NAME"]];
        [self.dataArray addObjectsFromArray:classiesArray];

        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [allTableView reloadData];
            [self stopLoadingActiView];//隐藏view
            
        });
        
    });

}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.title = self.titleName;
    self.view.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR2];

  UISearchBar *searchBar =
      [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44)];
  searchBar.delegate = self;
  searchBar.layer.borderWidth = 0.5f;
  searchBar.layer.borderColor = [CommonImage colorWithHexString:@"f0f0f0"].CGColor;
  //    searchBar.barStyle = uisearchb
  if (IOS_7) {
    searchBar.barTintColor = [CommonImage colorWithHexString:@"e5e5e5"];
  } else {
    searchBar.tintColor = [CommonImage colorWithHexString:@"e5e5e5"];
  }

  searchC = [[UISearchDisplayController alloc] initWithSearchBar:searchBar
                                              contentsController:self];
  searchC.delegate = self;
  searchC.searchResultsDelegate = self;
  searchC.searchResultsDataSource = self;
  //    searchC.searchResultsTableView.backgroundColor = [UIColor clearColor];
  searchC.searchResultsTableView.frame =
      CGRectMake(0, 0, kDeviceWidth, SCREEN_HEIGHT - 100);
  //    searchBar.placeholder = @"请输入您要查询的病症 例如：头痛";
  searchBar.backgroundColor = [UIColor clearColor];

  allTableView = [[UITableView alloc]
      initWithFrame:CGRectMake(0, 0, kDeviceWidth, SCREEN_HEIGHT - 44)];
  allTableView.tableHeaderView = searchBar;
  allTableView.delegate = self;
  allTableView.dataSource = self;
  allTableView.backgroundColor = [UIColor clearColor];
allTableView.separatorColor = [CommonImage colorWithHexString:LINE_COLOR];

  allTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  [self setExtraCellLineHidden:allTableView];
  [self setExtraCellLineHidden:searchC.searchResultsTableView];
  [self.view addSubview:allTableView];
    
    [self showLoadingActiview];
    [self getSOSClassiesArray];
    
}

/**
 *  隐藏tableviewd多余分割线
 *
 *  @param tableView
 */
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
  UIView *view = [UIView new];
  view.backgroundColor = [UIColor clearColor];
  [tableView setTableFooterView:view];
  [view release];
}

#pragma mark - UITableViewDataSource And UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  if ([tableView isKindOfClass:[searchC.searchResultsTableView class]]) {
    return self.searchArray.count;
  }

  return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *identifier = @"sosCell";
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:identifier];
  if (!cell) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:identifier] autorelease];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
//    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
      //cell点击背景颜色
      cell.selectedBackgroundView = [Common creatCellBackView];
      //自定义右箭头
      cell.accessoryView = [CommonImage creatRightArrowX:cell.frame.size.width-22 Y:(cell.frame.size.height-12)/2 cell:cell];
  }
  if ([tableView isKindOfClass:[searchC.searchResultsTableView class]]) {
    NSDictionary *oneSpecialDic = self.searchArray[indexPath.row];

    cell.textLabel.text = oneSpecialDic[@"NAME"];

  } else {
    if (self.secondPage) {
      NSDictionary *specialDic = self.dataArray[indexPath.row];
      cell.textLabel.text = specialDic[@"name"];

    } else {
      //第一页
      NSDictionary *classDic = self.dataArray[indexPath.row];
      cell.textLabel.text = classDic[@"NAME"];
    }
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

//    
//  if ([tableView isKindOfClass:[searchC.searchResultsTableView class]]) {
//    NSDictionary *oneSpecialDic = self.searchArray[indexPath.row];
//
//    NSDictionary *methodDic = @{
//      @"title" : @"急救方法",
//      @"content" : oneSpecialDic[@"first_aid"]
//    };
//    NSDictionary *moreDic = @{
//      @"title" : @"更多",
//      @"content" : oneSpecialDic[@"remark"]
//    };
//    NSArray *detailArray = @[ methodDic, moreDic ];
//
//    SOSDetailViewController *sosDetailVC =
//        [[SOSDetailViewController alloc] init];
//    sosDetailVC.title = oneSpecialDic[@"name"];
//    [sosDetailVC.dataArray addObjectsFromArray:detailArray];
//    [self.navigationController pushViewController:sosDetailVC animated:YES];
//    [sosDetailVC release];
//    return;
//  }
//
//  if (self.secondPage) {
    NSDictionary *specialDic = nil;
    
    if ([tableView isKindOfClass:[searchC.searchResultsTableView class]]) {
        specialDic = self.searchArray[indexPath.row];
    }else{
        specialDic = self.dataArray[indexPath.row];
    }
   
    NSString *idString = specialDic[@"ID"];

    //获得
      NSString *sql = [NSString stringWithFormat:@"SELECT DMKBASE_FIRSTAID.introduction,\
                       DMKBASE_FIRSTAID.etiology,\
                       DMKBASE_FIRSTAID.determine,\
                       DMKBASE_FIRSTAID.monitor,\
                       DMKBASE_FIRSTAID.treatment,\
                       DMKBASE_FIRSTAID.contact,\
                       DMKBASE_FIRSTAID.notice1,\
                       DMKBASE_FIRSTAID.notice2,\
                       DMKBASE_FIRSTAID.notice3,\
                       DMKBASE_FIRSTAID.manifestations,\
                       DMKBASE_FIRSTAID.principle, \
                       DMKBASE_FIRSTAID.operation\
                       FROM DMKBASE_FIRSTAID\
                       WHERE DMKBASE_FIRSTAID.ID = '%@'",idString];
    NSArray *keyArray = @[ @"introduction", @"etiology",@"determine",@"monitor",@"treatment",@"contact",@"notice1",@"notice2",@"notice3",@"manifestations",@"principle",@"operation"];
    NSArray *specialArray =
        [myDataBase getDataForSQL:sql getParam:keyArray];

    NSDictionary *detailDic = nil;
    if (specialArray.count) {
      detailDic = specialArray[0];
    }
//    NSDictionary *methodDic = @{
//      @"title" : @"急救方法",
//      @"content" : detailDic[@"first_aid"]
//    };
//    NSDictionary *moreDic = @{
//      @"title" : @"更多",
//      @"content" : detailDic[@"remark"]
//    };
      
//      "introduction"="症状介绍";
//      "etiology"="病因介绍";
//      "determine"="判断";
//      "monitor"="移动监测发现异常的急救";
//      "treatment"="家庭急救";
//      "contact"="联系就医";
//      "notice1"="就医须知";
//      "notice2"="糖尿病病友须知";
//      "notice3"="糖尿病病友须知";
//      "manifestations"="临床表现";
//      "principle"="治疗原则";
//      "operation"="动作要点";
      
      NSMutableArray *detailArray = [[NSMutableArray alloc] initWithCapacity:0];
      
      for(NSString *key in keyArray){
          NSString *value = detailDic[key];
          if(value.length){
              NSDictionary *dic = @{@"title": NSLocalizedString(key, @""),@"content":value};
              [detailArray addObject:dic];
          }
      }
//    NSArray *detailArray = @[ methodDic, moreDic ];
    self.log_pageID = 30;
    SOSDetailViewController *sosDetailVC =
        [[SOSDetailViewController alloc] init];
    sosDetailVC.title = specialDic[@"NAME"];
    [sosDetailVC.dataArray addObjectsFromArray:detailArray];
    [self.navigationController pushViewController:sosDetailVC animated:YES];
    [sosDetailVC release];
//    return;
//  }
  //第一页单击某一列，获得该类的子类

//  NSDictionary *classDic = self.dataArray[indexPath.row];
//  NSString *classificationName = classDic[@"classification"];
//
//  NSString *sql = [NSString
//      stringWithFormat:@"SELECT t_family_emergency.name,t_family_emergency.id "
//                       @"FROM t_family_emergency WHERE classification = '%@'",
//                       classificationName];
//
//  NSArray *specialArray =
//      [myDataBase getDataForSQL:sql getParam:@[ @"name", @"id" ]];
//  //    NSLog(@"clss:%@",specialArray);
//
//  SOSViewController *sosVC = [[SOSViewController alloc] init];
//  sosVC.secondPage = YES;
//  [sosVC.dataArray addObjectsFromArray:specialArray];
//  sosVC.titleName = classificationName;
//  [self.navigationController pushViewController:sosVC animated:YES];
//  [sosVC release];
}

#pragma mark - searchDelegate
/**
 *  点击搜索按钮
 *
 *  @param searchBar
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
  NSLog(@"---%@", searchText);
  //移除之前的内容
  [self.searchArray removeAllObjects];
  //获得
  NSString *sql = [NSString
                   stringWithFormat:@"SELECT\
                   DMKBASE_FIRSTAID.ID,\
                   DMKBASE_FIRSTAID.NAME\
                   FROM DMKBASE_FIRSTAID WHERE (DMKBASE_FIRSTAID.NAME LIKE '%%%@%%' OR DMKBASE_FIRSTAID.PINYIN LIKE '%%%@%%')", searchText,searchText];

  NSArray *specialArray =
      [myDataBase getDataForSQL:sql
                       getParam:@[ @"ID", @"NAME"]];
  //    NSLog(@"clss:%@",specialArray);

  [self.searchArray addObjectsFromArray:specialArray];
  [searchC.searchResultsTableView reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
