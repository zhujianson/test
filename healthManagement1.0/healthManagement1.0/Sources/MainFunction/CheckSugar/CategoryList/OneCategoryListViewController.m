//
//  OneCategoryListViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-15.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "OneCategoryListViewController.h"
#import "DBOperate.h"
#import "SugarDetailViewController.h"

@interface OneCategoryListViewController ()
<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource,
UITableViewDelegate> {
    UISearchDisplayController *searchC;
    DBOperate *myDataBase;
    UITableView *allTableView;
}
@property(nonatomic, retain) NSMutableArray *dataArray;    //数据源
@property(nonatomic, retain) NSMutableArray *searchArray;  //搜索数据源

@end

@implementation OneCategoryListViewController

- (void)dealloc {
    self.dataArray = nil;
    self.searchArray = nil;
    [searchC release];
    [allTableView release];
    self.categoryName = nil;
    
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        self.searchArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        myDataBase = [DBOperate shareInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    allTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [Common setExtraCellLineHidden:allTableView];
    [Common setExtraCellLineHidden:searchC.searchResultsTableView];
    [self.view addSubview:allTableView];
    
    [self showLoadingActiview];
    [self getDataArray];
}
/**
 *  获得数据源
 */
- (void)getDataArray {
    //异步中同步获取，主线程回调刷新---待完善
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *sql = nil;
        NSArray *resultArray = nil;
        
        if(self.footCategoryFlag){
            
            sql = [NSString stringWithFormat:@"SELECT TCC_INGREDIENTS.id,\
                   TCC_INGREDIENTS.GL_100G,\
                   TCC_INGREDIENTS.INGREDIENT\
                   FROM TCC_INGREDIENTS\
                   WHERE TCC_INGREDIENTS.CATALOG = '%@' ORDER BY TCC_INGREDIENTS.PINYIN ASC",self.categoryName];
            
            
            
            resultArray = [myDataBase getDataForSQL:sql getParam:@[@"id",@"GL_100G",@"INGREDIENT"]];
        }else{
            
            sql = [NSString stringWithFormat:@"SELECT TCC_DISHES.ID,\
                   TCC_DISHES.GL_100G,\
                   TCC_DISHES.DISH\
                   FROM TCC_DISHES WHERE SOC = '%@' ORDER BY TCC_DISHES.DISH_PINYIN ASC",self.categoryName];
            resultArray = [myDataBase getDataForSQL:sql getParam:@[@"ID",@"GL_100G",@"DISH"]];
        }

        [self.dataArray addObjectsFromArray:resultArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [allTableView reloadData];
            [self stopLoadingActiView];//隐藏view
            
        });
        
    });
 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView isKindOfClass:[searchC.searchResultsTableView class]]){
    
        return self.searchArray.count;
    }
    return self.dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"oneCategoryCell"];
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
//        //标识图标
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(256, 22, 25, 25)];
//        imageView.tag = 123;
//        [cell.contentView addSubview:imageView];
//        [imageView release];
    
    }
//    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:123];
//    imageView.image = [UIImage imageNamed:@"common.bundle/topic/Recommend.png"];
    NSDictionary *oneDic = nil;
    if([tableView isKindOfClass:[searchC.searchResultsTableView class]]){
        oneDic = self.searchArray[indexPath.row];
    }else{
        oneDic = self.dataArray[indexPath.row];
    }
   
    if(self.footCategoryFlag){
        cell.textLabel.text = oneDic[@"INGREDIENT"];
    }else{
        cell.textLabel.text = oneDic[@"DISH"];
    }
    NSString *gl100GString = oneDic[@"GL_100G"];
    
    cell.detailTextLabel.hidden = YES;//关闭宜食
    
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
    
//    cell.detailTextLabel.attributedText = [self replaceRedColorWithNSString:[NSString stringWithFormat:@"血糖风险指数:%.1f mmol/L",[gl100GString floatValue]] andUseKeyWord:[NSString stringWithFormat:@"%.1f",[gl100GString floatValue]] andWithFontSize:14];
    
    
    return cell;
}

- (NSMutableAttributedString *)replaceRedColorWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )size
{
    NSMutableAttributedString *attrituteString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:@"ed968c"], NSFontAttributeName : [UIFont systemFontOfSize:size]} range:range];
    return attrituteString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    NSDictionary *oneDic = nil;
    if([tableView isKindOfClass:[searchC.searchResultsTableView class]]){
        oneDic = self.searchArray[indexPath.row];
    }else{
        oneDic = self.dataArray[indexPath.row];
    }
    NSString *key = nil;
    NSString *name = nil;
    if(self.footCategoryFlag){
        self.log_pageID = 14;
        key = oneDic[@"id"];
        name = oneDic[@"INGREDIENT"];
        
    }else{
        self.log_pageID = 16;
        key = oneDic[@"ID"];
        name = oneDic[@"DISH"];
    }

    
    SugarDetailViewController *sugarDetailVC = [[SugarDetailViewController alloc] init];
    sugarDetailVC.ismenu = !self.footCategoryFlag;
    sugarDetailVC.title = name;
    sugarDetailVC.key = key;
    [self.navigationController pushViewController:sugarDetailVC animated:YES];
    [sugarDetailVC release];
    
    
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    NSLog(@"---%@", searchText);
    //移除之前的内容
    [self.searchArray removeAllObjects];
    //获得
    
    
    
    NSString *sql = nil;
    NSArray *specialArray = nil;
    if(self.footCategoryFlag){
        
 
        
        sql = [NSString stringWithFormat:@"SELECT TCC_INGREDIENTS.id,\
               TCC_INGREDIENTS.INGREDIENT,TCC_INGREDIENTS.GL_100G\
               FROM TCC_INGREDIENTS\
               WHERE ( ((TCC_INGREDIENTS.INGREDIENT LIKE '%%%@%%') OR(TCC_INGREDIENTS.PINYIN LIKE '%%%@%%') OR (TCC_INGREDIENTS.PINYIN_INDEX LIKE '%%%@%%'))) ORDER BY TCC_INGREDIENTS.PINYIN ASC",searchText,searchText,searchText];
        
        specialArray = [myDataBase getDataForSQL:sql getParam:@[@"id", @"INGREDIENT",@"GL_100G"]];
    }else{
        
        sql = [NSString stringWithFormat:@"SELECT TCC_DISHES.ID,\
               TCC_DISHES.DISH,TCC_DISHES.GL_100G\
               FROM TCC_DISHES WHERE (((DISH like '%%%@%%')OR(DISH_PINYIN LIKE '%%%@%%') OR (DISH_PINYIN_INDEX LIKE '%%%@%%')) AND ( SOC = '%@' )) ORDER BY TCC_DISHES.DISH_PINYIN ASC",searchText,searchText,searchText, self.categoryName];
        specialArray = [myDataBase getDataForSQL:sql getParam:@[@"ID", @"DISH",@"GL_100G"]];
        
    }
    NSLog(@"clss:%@",specialArray);
    
    [self.searchArray addObjectsFromArray:specialArray];
    [searchC.searchResultsTableView reloadData];
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
