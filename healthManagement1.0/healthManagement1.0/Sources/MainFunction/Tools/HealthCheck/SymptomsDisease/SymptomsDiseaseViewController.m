//
//  SymptomsDiseaseViewController.m
//  jiuhaoHealth2.0
//
//  Created by wangmin on 14-4-20.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import "SymptomsDiseaseViewController.h"
#import "CommonHttpRequest.h"
#import "DiseaseInfoViewController.h"
#import "DBOperate.h"
#import "SOSDetailViewController.h"

@interface SymptomsDiseaseViewController ()
<UITableViewDataSource,UITableViewDelegate>
{

    DBOperate *myDBOperation;//数据库对象
}
@property (nonatomic,retain) NSString *nextPageTitle;//下一页面标题
@end

@implementation SymptomsDiseaseViewController

- (void)dealloc
{
    self.diseaseArray = nil;
    self.nextPageTitle = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"诊断结果", nil);
        self.log_pageID = 25;
//        UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
//        self.navigationItem.backBarButtonItem = backBar;
        myDBOperation = [DBOperate shareInstance];
        
    }
    return self;
}


//根据ID获取疾病信息
- (void)getSymptomDiseaseByid:(NSString *)diseaseId
{
    
   NSDictionary *resultDic = [myDBOperation getDiseaseInfoById:diseaseId];
    
    NSLog(@"resultArray:%@",resultDic);

    //修改跳转页面
    NSMutableArray *detailArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *keyArray = @[@"introduction",@"symptoms"];
    NSArray *chineseKeyArray = @[resultDic[@"disease"],@"相关症状"];
    int i = 0;
    for(NSString *key in keyArray){
        NSString *value = resultDic[key];
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
    [sosDetailVC.dataArray addObjectsFromArray:detailArray];
    [self.navigationController pushViewController:sosDetailVC animated:YES];
    [sosDetailVC release];
    [detailArray release];

}


- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    
    NSString *responseString = [loader responseString];
    
    //过滤<br/><p></p>
//    responseString = [responseString  stringByReplacingOccurrencesOfString:@"\\u003cp\\u003e" withString:@""];
//    responseString = [responseString  stringByReplacingOccurrencesOfString:@"\\u003c/p\\u003e" withString:@""];
//    responseString = [responseString stringByReplacingOccurrencesOfString:@"\\u003cbr/\\u003e" withString:@"\n"];
    
    
    NSDictionary *dic = [responseString KXjSONValueObject];
    if (![[dic objectForKey:@"state"] intValue])
    {
       if([loader.username isEqualToString:GetSymptomDiseaseByid]){
            //根据疾病id查看疾病详细
            
            NSDictionary *resultDic = dic[@"rs"];
            NSLog(@"resultArray:%@",resultDic);
            
            DiseaseInfoViewController *diseaseInfoVC = [[DiseaseInfoViewController alloc] init];
            diseaseInfoVC.thirdName = NSLocalizedString(@"症状", nil);
            NSString *diseaseInfo = resultDic[@"diseaseInfo"];//简介
            NSString *diseaseCause = resultDic[@"diseaseCause"];//病因
            NSString *symptom = resultDic[@"symptom"];//症状
            NSString *diagnose = resultDic[@"diagnose"];//诊断
            diseaseInfoVC.title = self.nextPageTitle;
            diseaseInfoVC.diseaseArray = [NSMutableArray arrayWithObjects:diseaseInfo.length>0?diseaseInfo:@"",diseaseCause.length>0?diseaseCause:@"",symptom.length>0?symptom:@"",diagnose.length>0?diagnose:@"", nil];
            
            [self.navigationController pushViewController:diseaseInfoVC animated:YES];
            [diseaseInfoVC release];
           
        }
        
    }else {
        [Common TipDialog:[dic objectForKey:@"msg"]];
        return;
    }
    
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    NSLog(@"fail");
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UITableView *diseaseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, SCREEN_HEIGHT-44)];
    diseaseTableView.dataSource = self;
    diseaseTableView.delegate = self;
    diseaseTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:diseaseTableView];
    [diseaseTableView release];
    [self setExtraCellLineHidden:diseaseTableView];
    
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    //    [view release];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.diseaseArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"checkCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];
        
            UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        progressView.progressViewStyle = UIProgressViewStyleBar;
        progressView.progressTintColor = [CommonImage colorWithHexString:@"6CD014"];
        progressView.trackTintColor = [CommonImage colorWithHexString:@"e5e5e5"];
            cell.accessoryView = progressView;
            [progressView release];
        }
 
    //搜索
    
    CGRect frame = cell.textLabel.frame;
    frame.size.width = 200;
    cell.textLabel.frame = frame;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.textColor = [CommonImage colorWithHexString:@"#333333"];

    NSDictionary *diseasemDic = self.diseaseArray[indexPath.row];
    
    cell.textLabel.text = diseasemDic[@"diseaseName"];
    UIProgressView *accessView = (UIProgressView *)cell.accessoryView;
//    accessView.hidden = YES;
    accessView.progress = [diseasemDic[@"odds"] floatValue]/self.allOdds;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *selectedDic = self.diseaseArray[indexPath.row];
    //调到疾病详情
    self.nextPageTitle = selectedDic[@"diseaseName"];
    [self getSymptomDiseaseByid:selectedDic[@"id"]];
        
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end