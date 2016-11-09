//
//  CommonMedicineViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-8.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "CommonMedicineViewController.h"
#import "CommonMedDetailViewController.h"
#import "DBOperate.h"
#import "MedicineDetailViewController.h"

@interface CommonMedicineViewController ()<
    UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource,
    UITableViewDelegate> {
        UISearchDisplayController *searchC;
        DBOperate *myDataBase;
        UITableView *allTableView;
}

@property(nonatomic, retain) NSMutableArray *dataArray;    //数据源
@property(nonatomic, retain) NSMutableArray *searchArray;  //搜索数据源

@end

@implementation CommonMedicineViewController

- (void)dealloc {
  self.dataArray = nil;
  self.searchArray = nil;
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
 *  获得数据源
 */
- (void)getDataArray {
  //异步中同步获取，主线程回调刷新---待完善

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        NSString *sql = [NSString stringWithFormat:@"SELECT\
                         DMKBASE_DRUG.id,\
                         DMKBASE_DRUG.drug\
                         FROM DMKBASE_DRUG\
                         ORDER BY pinyin1 ASC"];
        
        NSArray *medicinesArray =
        [myDataBase getDataForSQL:sql getParam:@[ @"id", @"drug" ]];
        //    NSLog(@"clss:%@",medicinesArray);
        [self.dataArray addObjectsFromArray:medicinesArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [allTableView reloadData];
            [self stopLoadingActiView];//隐藏view
            
        });
    
    });
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
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
  allTableView.separatorColor = [CommonImage colorWithHexString:LINE_COLOR];
  allTableView.backgroundColor = [UIColor clearColor];
  allTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  [self setExtraCellLineHidden:allTableView];
  [self setExtraCellLineHidden:searchC.searchResultsTableView];
  [self.view addSubview:allTableView];
    
  [self showLoadingActiview];
  [self getDataArray];
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

#pragma mark - UITableViewDataSource And UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  if ([tableView isKindOfClass:[searchC.searchResultsTableView class]]) {
    return self.searchArray.count;
  } else {
    return self.dataArray.count;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *identifier = @"sosCell";
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:identifier];
  if (!cell) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:identifier] autorelease];
      //自定义右箭头
      cell.accessoryView = [CommonImage creatRightArrowX:cell.frame.size.width-22 Y:(cell.frame.size.height-12)/2 cell:cell];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
      //cell点击背景颜色
      cell.selectedBackgroundView = [Common creatCellBackView];
  }
  if ([tableView isKindOfClass:[searchC.searchResultsTableView class]]) {
    NSDictionary *medicineDic = self.searchArray[indexPath.row];
    cell.textLabel.text = medicineDic[@"drug"];
  } else {
    NSDictionary *medicineDic = self.dataArray[indexPath.row];
    cell.textLabel.text = medicineDic[@"drug"];
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  NSString *idString = nil;
  NSString *titleName = nil;
  if ([tableView isKindOfClass:[searchC.searchResultsTableView class]]) {
    NSDictionary *medicinelDic = self.searchArray[indexPath.row];
    idString = medicinelDic[@"id"];
    titleName = medicinelDic[@"drug"];

  } else {
    NSDictionary *medicinelDic = self.dataArray[indexPath.row];
    idString = medicinelDic[@"id"];
    titleName = medicinelDic[@"drug"];
  }
  //    idString = @"ff80808146cd57920146d224f1fc024e";
  //获得
  NSString *sql = [NSString
                   stringWithFormat:@"SELECT DMKBASE_DRUG.drug,\
                   DMKBASE_DRUG.product,\
                   DMKBASE_DRUG.feature,\
                   DMKBASE_DRUG.catalog,\
                   DMKBASE_DRUG.mechanism,\
                   DMKBASE_DRUG.applicable,\
                   DMKBASE_DRUG.usage,\
                   DMKBASE_DRUG.weight,\
                   DMKBASE_DRUG.hypoglycemia,\
                   DMKBASE_DRUG.elder, \
                   DMKBASE_DRUG.tips \
                   FROM DMKBASE_DRUG\
                    WHERE DMKBASE_DRUG.id='%@'",idString];

  NSArray *specialArray = [myDataBase getDataForSQL:sql
                                           getParam:@[
                                                      @"drug",
                                                      @"product",
                                                      @"feature",
                                                      @"catalog",
                                                      @"mechanism",
                                                      @"applicable",
                                                      @"usage",
                                                      @"weight",
                                                      @"hypoglycemia",
                                                      @"elder",
                                                      @"tips"
                                                    ]];
  //    NSLog(@"clss:%@",specialArray);
  NSDictionary *detailDic = nil;
  if (specialArray.count) {
    detailDic = specialArray[0];
  }

    
//    NSString *medicineName = [NSString stringWithFormat:@"药品名称:%@\n",detailDic[@"drug"]];
    NSString *medicineName = detailDic[@"drug"];
//    if(![detailDic[@"ZPILLNAMEINCOMMON"] isEqualToString:@"null"] && [detailDic[@"ZPILLNAMEINCOMMON"] length]){
//        medicineName = [medicineName stringByAppendingFormat:@"通用名称:%@",detailDic[@"ZPILLNAMEINCOMMON"]];
//    }
    NSDictionary *methodDic = @{@"title": @"药品名称",@"content":medicineName,@"icon":@"yaopinmingcheng.png"};
    NSMutableArray *detailArray = [[NSMutableArray alloc] initWithCapacity:0];
    [detailArray addObject:methodDic];
    
    if(![detailDic[@"product"] isEqualToString:@"null"] && [detailDic[@"product"] length]){
        NSDictionary *methodDic = @{@"title": @"商品名",@"content":detailDic[@"product"],@"icon":@"shangpinming.png"};
        [detailArray addObject:methodDic];
    }
    if(![detailDic[@"feature"] isEqualToString:@"null"] && [detailDic[@"feature"] length]){
        NSDictionary *methodDic = @{@"title": @"药品特征",@"content":detailDic[@"feature"],@"icon":@"yaopintezheng.png"};
        [detailArray addObject:methodDic];
        
    }
    if(![detailDic[@"catalog"] isEqualToString:@"null"] && [detailDic[@"catalog"] length]){
        NSDictionary *methodDic = @{@"title": @"药品类别",@"content":detailDic[@"catalog"],@"icon":@"yaopinleibie.png"};
        [detailArray addObject:methodDic];
        
    }
    if(![detailDic[@"mechanism"] isEqualToString:@"null"] && [detailDic[@"mechanism"] length]){
        NSDictionary *methodDic = @{@"title": @"降糖机制",@"content":detailDic[@"mechanism"],@"icon":@"jiangtangjizhi.png"};
        [detailArray addObject:methodDic];
        
    }
    if(![detailDic[@"applicable"] isEqualToString:@"null"] && [detailDic[@"applicable"] length]){
        NSDictionary *methodDic = @{@"title": @"适用人群",@"content":detailDic[@"applicable"],@"icon":@"shiyongrenqun.png"};
        [detailArray addObject:methodDic];
        
    }
    if(![detailDic[@"usage"] isEqualToString:@"null"] && [detailDic[@"usage"] length]){
        NSDictionary *methodDic = @{@"title": @"用法用量",@"content":detailDic[@"usage"],@"icon":@"yongfayongliang.png"};
        [detailArray addObject:methodDic];
    }
    if(![detailDic[@"weight"] isEqualToString:@"null"] && [detailDic[@"weight"] length]){
        NSDictionary *methodDic = @{@"title": @"对体重影响",@"content":detailDic[@"weight"],@"icon":@"duitizhongdeyingxiang.png"};
        [detailArray addObject:methodDic];
    }
    if(![detailDic[@"hypoglycemia"] isEqualToString:@"null"] && [detailDic[@"hypoglycemia"] length]){
        NSDictionary *methodDic = @{@"title": @"低血糖发生率",@"content":detailDic[@"hypoglycemia"],@"icon":@"dixuetangfashenglv.png"};
        [detailArray addObject:methodDic];
    }
    if(![detailDic[@"elder"] isEqualToString:@"null"] && [detailDic[@"elder"] length]){
        NSDictionary *methodDic = @{@"title": @"长者须知",@"content":detailDic[@"elder"],@"icon":@"zhangzhexuzhi.png"};
        [detailArray addObject:methodDic];
    }
    if(![detailDic[@"tips"] isEqualToString:@"null"] && [detailDic[@"tips"] length]){
        NSDictionary *methodDic = @{@"title": @"用药小贴士",@"content":detailDic[@"tips"],@"icon":@"zhongyaoxiaotieshi.png"};
        [detailArray addObject:methodDic];
    }

    MedicineDetailViewController* detail = [[MedicineDetailViewController alloc] init];
    detail.title = titleName;
    detail.dataArray = detailArray;
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}

#pragma mark - searchDelegate
/**
 *  搜索数据库
 *
 *  @param searchBar
 */
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
  NSLog(@"---%@", searchText);
  //移除之前的内容
  [self.searchArray removeAllObjects];
  //获得
  NSString *sql = [NSString stringWithFormat:@"SELECT\
                     DMKBASE_DRUG.id,\
                     DMKBASE_DRUG.drug\
                     FROM DMKBASE_DRUG WHERE ((drug like '%%%@%%')||(pinyin1 like '%%%@%%'))",
                                             searchText, searchText];

  NSArray *specialArray =
      [myDataBase getDataForSQL:sql getParam:@[ @"drug", @"id" ]];
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
