//
//  MedicineViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-7.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "MedicineViewController.h"
#import "ChineseToPinyin.h"
#import "ChineseInclude.h"
#import "MedicineDetailViewController.h"
#import "DBOperate.h"
#import "SOSDetailViewController.h"
#import "AppDelegate.h"

@interface MedicineViewController ()
{
    DBOperate *myDataBase;
    NSMutableArray *medicineNameArray;
}

@property (nonatomic,retain) NSMutableArray *dataArray;

@end

@implementation MedicineViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"药品查询";
        dataDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        self.dataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        myDataBase = [DBOperate shareInstance];
    }
    return self;
}

- (void)dealloc
{
    self.searchBar = nil;
    self.dataArray = nil;
    [_displayController release];
    [physicalNameArr release];
    [searchResults release];
    [medicineVC release];
    [pingyinArr release];
    [dataDic release];
    [super dealloc];
}

- (NSArray *)getDataArray
{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT DMKBASE_DISEASE.disease FROM DMKBASE_DISEASE ORDER BY DMKBASE_DISEASE.PINYIN"];
    
    NSArray *classiesArray = [myDataBase  getDataForSQL:sql getParam:@[@"disease"]];
    //    NSLog(@"clss:%@",classiesArray);
    [self.dataArray addObjectsFromArray:classiesArray];
    
    medicineNameArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for(NSDictionary *medDic in self.dataArray){
        
        NSString *medicName = medDic[@"disease"];
        if(medicName.length){
            [medicineNameArray addObject:medicName];
        }
    }
    return medicineNameArray;
    
    
    
//    NSString *sql = [NSString stringWithFormat:@"SELECT\
//                     ZPILLINSTRUCTION.Z_PK,\
//                    ZPILLINSTRUCTION.ZPILLNAMEINCOMMON,\
//                    ZPILLINSTRUCTION.ZPILLNAMEINMERCHANDISE\
//                     FROM ZPILLINSTRUCTION"];
//    
//    NSArray *classiesArray = [myDataBase  getDataForSQL:sql getParam:@[@"Z_PK",@"ZPILLNAMEINCOMMON",@"ZPILLNAMEINMERCHANDISE"]];
////    NSLog(@"clss:%@",classiesArray);
//    [self.dataArray addObjectsFromArray:classiesArray];
//    
//    medicineNameArray = [[NSMutableArray alloc] initWithCapacity:0];
//    
//    for(NSDictionary *medDic in self.dataArray){
//    
//        NSString *commonName = medDic[@"ZPILLNAMEINCOMMON"];
//        NSString *medicName = medDic[@"ZPILLNAMEINMERCHANDISE"];
//        if(medicName.length){
//            [medicineNameArray addObject:[NSString stringWithFormat:@"%@_%@",medicName,medDic[@"Z_PK"]]];
//        }else{
//            [medicineNameArray addObject:[NSString stringWithFormat:@"%@_%@",commonName,medDic[@"Z_PK"]]];
//        }
//    }
//    return medicineNameArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    m_progress_ = [Common ShowMBProgress:self.view MSG:@"加载中..." Mode:MBProgressHUDModeIndeterminate];
    m_progress_.alpha = 0.8;
    [self searchBarInit];
    [self getDataForDB];
    //    [medicineVC release];
    
    
    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
}

- (void)getDataForDB
{
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       NSArray *nameArray = [self getDataArray];
                       
                       //数据源
                       physicalNameArr = [[NSMutableArray alloc] initWithArray:nameArray];
                       [nameArray release];
                       //得到数据源的拼音数组
                       pingyinArr = [[NSMutableArray alloc] init];
                       for (int i = 0; i < [physicalNameArr count]; i++) {
                           /**
                            *  汉字转化为拼音
                            */
                           [pingyinArr addObject:[ChineseToPinyin pinyinFromChiniseString:physicalNameArr[i]]];
                           //        [dataDic setObject:otherArr[i] forKey:physicalNameArr[i]]; //添加简介
                       }
                       
                       dispatch_async( dispatch_get_main_queue(), ^(void){
                           @try {
                               medicineVC = [[MedicineListViewController alloc] init];
                               [medicineVC.pingyinArrp addObjectsFromArray:pingyinArr];
                               [medicineVC.nameArr addObjectsFromArray:physicalNameArr];
                               [medicineVC.dataDic addEntriesFromDictionary:dataDic];
                               medicineVC.view.frame = CGRectMake(0, 44, kDeviceWidth, kDeviceHeight-44-50);
                               medicineVC.myDelegate = self;
                               [self.view addSubview:medicineVC.view];
                               
                               [self stopActiView];
                           }
                           @catch (NSException *exception) {
                               NSLog(@"EScrollerViewqweqweqwe");
                           }
                       });
                   });
}

- (void)stopActiView
{
    if (m_progress_)
    {
        [m_progress_ removeFromSuperview];
    }
    m_progress_ = nil;
}

/**
 *  创建搜索框
 */
- (void)searchBarInit
{

    self.searchBar =
    [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0.0f, kDeviceWidth, 44.0f)];
    self.searchBar.placeholder = @"请输入要查询的疾病名称";
    self.searchBar.delegate = self;
    
    self.searchBar.layer.borderWidth = 0.5f;
    self.searchBar.layer.borderColor = [CommonImage colorWithHexString:@"f0f0f0"].CGColor;
    //    searchBar.barStyle = uisearchb
    if (IOS_7) {
        self.searchBar.barTintColor = [CommonImage colorWithHexString:@"e5e5e5"];
    } else {
       self.searchBar.tintColor = [CommonImage colorWithHexString:@"e5e5e5"];
    }
    
    NSLog(@"-----self.view.frame:%@",NSStringFromCGRect(self.view.frame));
    
    
//    [self.view addSubview:self.searchBar];
    
    
    UITableView *allTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, SCREEN_HEIGHT)];
    allTableView.tableHeaderView = self.searchBar;
    allTableView.scrollEnabled = NO;
    allTableView.bounces = NO;
    allTableView.backgroundColor = [CommonImage colorWithHexString:@"f6f7ee"];
    allTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:allTableView];
    [allTableView release];

    
    for (UIView* view in self.searchBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
    }
    
    //相当于tableview
    _displayController =
    [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar
                                      contentsController:self];
    _displayController.active = NO;
    _displayController.searchResultsTableView.frame = CGRectMake(0, 100, kDeviceWidth, kDeviceHeight - 100);
    [Common setExtraCellLineHidden:_displayController.searchResultsTableView];
    _displayController.delegate = self;
    _displayController.searchResultsDataSource = self;
    _displayController.searchResultsDelegate = self;

    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

        NSLog(@"-----------beginEditing");
        self.isSearchingBlock(YES);
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"-----------endEditing");
    self.isSearchingBlock(NO);
}

/**
 *  输入中
 *
 *  @param searchBar  search
 *  @param searchText 输入的内容
 */
- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText
{
    CGRect viewRect = self.view.frame;
    viewRect.origin.x = kDeviceWidth;
    self.view.frame = viewRect;
    searchResults = [[NSMutableArray alloc] init];
    if (searchBar.text.length > 0 && ![ChineseInclude isIncludeChineseInString:searchBar.text]) {
        for (int i = 0; i < physicalNameArr.count; i++) {
            if ([ChineseInclude isIncludeChineseInString:physicalNameArr[i]]) {
                NSRange titleResult =
                [pingyinArr[i] rangeOfString:searchBar.text
                                     options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0) {
                    [searchResults addObject:physicalNameArr[i]];
                }
            } else {
                NSRange titleResult =
                [physicalNameArr[i] rangeOfString:searchBar.text
                                          options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0) {
                    [searchResults addObject:physicalNameArr[i]];
                }
            }
        }
    } else if (searchBar.text.length > 0 &&
               [ChineseInclude isIncludeChineseInString:searchBar.text]) {
        for (NSString* tempStr in physicalNameArr) {
            NSRange titleResult = [tempStr rangeOfString:searchBar.text
                                                 options:NSCaseInsensitiveSearch];
            if (titleResult.length > 0) {
                [searchResults addObject:tempStr];
            }
        }
    }
    NSLog(@"%@", searchResults);
    [_displayController.searchResultsTableView reloadData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
    [self.searchBar resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)_tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView
heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView*)tableView:(UITableView*)tableView
viewForHeaderInSection:(NSInteger)section
{
    UIView* cleanView = [[[UIView alloc] init] autorelease];
    cleanView.backgroundColor = [CommonImage colorWithHexString:@"f4f4f4"];
    UILabel* textLable = [Common createLabel:CGRectMake(10, 0, 300, 30)
                                   TextColor:nil
                                        Font:[UIFont systemFontOfSize:14]
                               textAlignment:NSTextAlignmentLeft
                                    labTitle:@"搜索结果"];
    textLable.textColor = [UIColor grayColor];
    [cleanView addSubview:textLable];
    
    return cleanView;
}

- (CGFloat)tableView:(UITableView*)tableView
heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 48;
}

- (NSInteger)tableView:(UITableView*)_tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [searchResults count];
}

- (UITableViewCell*)tableView:(UITableView*)_tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* indentifier = @"Cell";
    UITableViewCell* cell = (UITableViewCell*)
    [_tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:indentifier] autorelease];
//        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];

    }
    cell.textLabel.text = searchResults[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.detailTextLabel.text = [dataDic objectForKey:cell.textLabel.text];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    return cell;
}

- (void)tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell* cell = [tableView
                             cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row
                                                                      inSection:indexPath.section]];
    [self pushPhysicalData:cell.textLabel.text];
}

- (NSMutableArray *)getInfoFromDBWithName:(NSString *)name
{
    //获得
    NSString *sql = [NSString stringWithFormat:@"SELECT DMKBASE_DISEASE.disease,DMKBASE_DISEASE.introduction, group_concat(DMKBASE_SYMPTOM.symptom,'、') as symptoms\
                     FROM (DMKBASE_DISEASE LEFT JOIN DMKBASE_SRD ON DMKBASE_SRD.disease_id = DMKBASE_DISEASE.ID) LEFT JOIN DMKBASE_SYMPTOM ON DMKBASE_SYMPTOM.id = DMKBASE_SRD.symptom_id WHERE DMKBASE_DISEASE.disease = '%@'",name];
    NSArray *specialArray = [myDataBase  getDataForSQL:sql getParam:@[@"introduction",@"symptoms"]];
    NSLog(@"clss:%@",specialArray);

    
    return [NSMutableArray arrayWithArray:specialArray];
    
//    NSString *medicineName = [NSString stringWithFormat:@"药品名称:%@\n",detailDic[@"ZPILLNAMEINMERCHANDISE"]];
//    if(![detailDic[@"ZPILLNAMEINCOMMON"] isEqualToString:@"null"] && [detailDic[@"ZPILLNAMEINCOMMON"] length]){
//        medicineName = [medicineName stringByAppendingFormat:@"通用名称:%@",detailDic[@"ZPILLNAMEINCOMMON"]];
//    }
//    NSDictionary *methodDic = @{@"title": @"药品名称",@"content":medicineName,@"icon":@"yaopinmingcheng.png"};
//    NSMutableArray *detailArray = [[NSMutableArray alloc] initWithCapacity:0];
//    [detailArray addObject:methodDic];
//
//    if(![detailDic[@"ZPRESCRIPTION"] isEqualToString:@"null"] && [detailDic[@"ZPRESCRIPTION"] length]){
//        NSDictionary *methodDic = @{@"title": @"药品类型",@"content":detailDic[@"ZPRESCRIPTION"],@"icon":@"yaopinleixing.png"};
//        [detailArray addObject:methodDic];
//    }
//    if(![detailDic[@"ZEFFECT"] isEqualToString:@"null"] && [detailDic[@"ZEFFECT"] length]){
//        NSDictionary *methodDic = @{@"title": @"适应症",@"content":detailDic[@"ZEFFECT"],@"icon":@"shiyingzhneg.png"};
//        [detailArray addObject:methodDic];
//        
//    }
//    if(![detailDic[@"ZUNTOWARDEFFECT"] isEqualToString:@"null"] && [detailDic[@"ZUNTOWARDEFFECT"] length]){
//        NSDictionary *methodDic = @{@"title": @"不良反应",@"content":detailDic[@"ZUNTOWARDEFFECT"],@"icon":@"buliangfanying.png"};
//        [detailArray addObject:methodDic];
//        
//    }
//    if(![detailDic[@"ZBAN"] isEqualToString:@"null"] && [detailDic[@"ZBAN"] length]){
//        NSDictionary *methodDic = @{@"title": @"禁忌",@"content":detailDic[@"ZBAN"],@"icon":@"jinji.png"};
//        [detailArray addObject:methodDic];
//        
//    }
//    if(![detailDic[@"ZCAUTION"] isEqualToString:@"null"] && [detailDic[@"ZCAUTION"] length]){
//        NSDictionary *methodDic = @{@"title": @"注意事项",@"content":detailDic[@"ZCAUTION"],@"icon":@"zhuyishixiang.png"};
//        [detailArray addObject:methodDic];
//        
//    }
//    if(![detailDic[@"ZINTERATION"] isEqualToString:@"null"] && [detailDic[@"ZINTERATION"] length]){
//        NSDictionary *methodDic = @{@"title": @"药物相互作用",@"content":detailDic[@"ZINTERATION"],@"icon":@"yaowuxianghuzuoyong.png"};
//        [detailArray addObject:methodDic];
//    }
//    if(![detailDic[@"ZDOSAGE"] isEqualToString:@"null"] && [detailDic[@"ZDOSAGE"] length]){
//        NSDictionary *methodDic = @{@"title": @"用法用量",@"content":detailDic[@"ZDOSAGE"],@"icon":@"yongfayongliang.png"};
//        [detailArray addObject:methodDic];
//    }
//    if(![detailDic[@"ZSPEC"] isEqualToString:@"null"] && [detailDic[@"ZSPEC"] length]){
//        NSDictionary *methodDic = @{@"title": @"规格",@"content":detailDic[@"ZSPEC"],@"icon":@"guige.png"};
//        [detailArray addObject:methodDic];
//    }
//
//    
//    return [detailArray autorelease];
}

- (void)pushPhysicalData:(NSString*)physical
{
    
    
    NSMutableArray *resultArray = [self getInfoFromDBWithName:physical];

    NSDictionary *detailDic =nil;
    
    if(resultArray.count){
        detailDic = resultArray[0];
    }
    NSMutableArray *detailArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSArray *keyArray = @[@"introduction",@"symptoms"];
    NSArray *chineseKeyArray = @[physical,@"相关症状"];
    int i = 0;
    for(NSString *key in keyArray){
        NSString *value = detailDic[key];
        if(value.length){
            NSDictionary *dic = @{@"title": chineseKeyArray[i],@"content":value};
            [detailArray addObject:dic];
        }
        i++;
    }
    //    NSArray *detailArray = @[ methodDic, moreDic ];
    SOSDetailViewController *sosDetailVC =
    [[SOSDetailViewController alloc] init];
    sosDetailVC.title = @"疾病详情";
    self.log_pageID = 26;
    [sosDetailVC.dataArray addObjectsFromArray:detailArray];
    AppDelegate *myDelegate = [Common getAppDelegate];

    [myDelegate.navigationVC pushViewController:sosDetailVC animated:YES];
    [sosDetailVC release];

    
    
//   
//    MedicineDetailViewController* detail =
//    [[MedicineDetailViewController alloc] init];
//    detail.title = physical;
//    detail.dataArray = detailArray;
//    [self.navigationController pushViewController:detail animated:YES];
//    [detail release];
}

- (void)didReceiveMemoryWarning
{
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
