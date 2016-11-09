//
//  SugarListViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-15.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "SugarListViewController.h"
#import "DBOperate.h"
#import "OneCategoryListViewController.h"
#import "AppDelegate.h"

@interface SugarListViewController ()
<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *sugarListTableView;
    DBOperate *myDataBase;
}
@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,retain) NSMutableArray *dataHeightArray;
@end

@implementation SugarListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        self.dataHeightArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        myDataBase = [DBOperate shareInstance];
    }
    return self;
}
- (void)dealloc
{
    self.dataArray = nil;
    self.dataHeightArray = nil;
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sugarListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, SCREEN_HEIGHT-44-44-45)];
    sugarListTableView.dataSource = self;
    sugarListTableView.delegate = self;
    sugarListTableView.backgroundColor = [CommonImage colorWithHexString:Color_fafafa];
    [self.view addSubview:sugarListTableView];
    [sugarListTableView release];
    [Common setExtraCellLineHidden:sugarListTableView];
    [self showLoadingActiview];
    [self getDataSource];
}

- (void)getDataSource
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *sql = nil;
        NSArray *resultArray = nil;
        if(self.foodListFlag){
            sql = [NSString
                   stringWithFormat:@"SELECT TCC_IC.CODE,TCC_IC.CATALOG\
                   FROM TCC_IC"];
            resultArray =
            [myDataBase getDataForSQL:sql getParam:@[@"CODE",@"CATALOG"]];
            //    NSLog(@"clss:%@",classiesArray);
        }else{
            sql = [NSString
                   stringWithFormat:@"SELECT DISTINCT TCC_DISHES.SOC\
                   FROM TCC_DISHES"];
            resultArray =
            [myDataBase getDataForSQL:sql getParam:@[@"SOC"]];
        }

        [self.dataArray addObjectsFromArray:resultArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [sugarListTableView reloadData];
            [self stopLoadingActiView];//隐藏view
            
        });
        
    });

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;// [[self.dataHeightArray objectAtIndex:indexPath.row] floatValue];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //Class:UISearchResultsTableView isKindOfClass: UITableView  正确 （小属于大）
    
    return self.dataArray.count;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierCell = @"sugerlistCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierCell] autorelease];
        //自定义右箭头
        cell.accessoryView = [CommonImage creatRightArrowX:cell.frame.size.width-22 Y:(cell.frame.size.height-12)/2 cell:cell];
        cell.backgroundColor = [UIColor clearColor];//[CommonImage colorWithHexString:@"#f6f7ed"];
        cell.contentView.backgroundColor = [UIColor clearColor];//[CommonImage colorWithHexString:@"#f6f7ed"];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];

    }
    
    NSDictionary *oneDic = self.dataArray[indexPath.row];
     if(self.foodListFlag){
         cell.textLabel.text = oneDic[@"CATALOG"];
     }else{
         cell.textLabel.text = oneDic[@"SOC"];
     }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *name = nil;
    NSString *title = nil;
    NSDictionary *oneDic = self.dataArray[indexPath.row];
    if(self.foodListFlag){
        self.log_pageID = 13;

        name = oneDic[@"CODE"];
        title = oneDic[@"CATALOG"];
    }else{
        self.log_pageID = 15;
        name = oneDic[@"SOC"];
        title = oneDic[@"SOC"];
    }
    NSLog(@"----name:%@",name);
    AppDelegate *myDelegate = [Common getAppDelegate];
    OneCategoryListViewController *oneCategoryVC = [[OneCategoryListViewController alloc] init];
    oneCategoryVC.categoryName = name;
    oneCategoryVC.title = title;
    oneCategoryVC.footCategoryFlag = _foodListFlag;
    [myDelegate.navigationVC pushViewController:oneCategoryVC animated:YES];
    [oneCategoryVC release];
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
