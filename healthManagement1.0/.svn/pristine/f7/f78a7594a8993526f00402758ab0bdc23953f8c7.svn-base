//
//  CheckDiseaseListViewController.m
//  jiuhaoHealth2.0
//
//  Created by wangmin on 14-4-9.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import "CheckDiseaseListViewController.h"
#import "CommonHttpRequest.h"
#import "DiseaseInfoViewController.h"
#import "SymptomsDiseaseViewController.h"
#import "DBOperate.h"
#import "AppDelegate.h"

@interface CheckDiseaseListViewController ()
<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    UITableView *generalSymptomsTableView;
    UITableView *sepecialSynptomsTableView;
    UISearchDisplayController* searchC;//针对SpecialSynptomsTableView数据进行搜索
    UIView *headView;//头view
    
    int currentChoice;
    
    BOOL isRequestFlag;//请求标志位
    
    int  currentWaitReloadSection;//等待刷新的section
    
    UIButton *toCheckButton;//诊断按钮 -- 男女中有
    
    BOOL  isScrolling;//正在滚动
    
    DBOperate *myDBOperation;//数据库对象

}
//男女数据源

@property (nonatomic,retain) NSMutableDictionary *crowIDArray;//人群id数组

@property (nonatomic,retain) NSMutableArray *sepcialSymDataArray;//特定病症数组

@property (nonatomic,retain) NSMutableArray *allSymDataArray;//所有病症数组

@property (nonatomic,retain) UIButton *currentSelectedBtn;//当前选中的button

//老跟幼特殊处理---数据源
@property (nonatomic,retain) NSMutableArray *listSynptomsArray;//症状列表---老跟幼的列表数据源

@property (nonatomic,retain) NSMutableArray *detailSynptomsArray;//具体症状介绍

@property (nonatomic,retain) NSMutableArray *openFlagArray;//开关控制

@property (nonatomic,retain) NSMutableArray *arrowFlagArray;//箭头开关数组

@property (nonatomic,retain) NSMutableArray *allDiseaseArray;//所有疾病数组

@property (nonatomic,retain) NSMutableArray *selectedArray;//选中的数组





@property (nonatomic,retain) NSString *nextPageTitle;//下一页面标题

@property (nonatomic,retain) NSMutableArray *searchResultArray;//搜索结果数组


@end

@implementation CheckDiseaseListViewController

- (void)dealloc
{
    [generalSymptomsTableView release];
    [sepecialSynptomsTableView release];
    self.generalSymDataArray = nil;
    self.sepcialSymDataArray = nil;
    self.allSymDataArray = nil;
    self.crowIDArray = nil;
    self.manSymDataArray = nil;
    self.womanSymDataArray = nil;
    self.nextPageTitle = nil;
    self.arrowFlagArray = nil;
    self.selectedArray = nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.openFlagArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        self.crowIDArray = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
        self.arrowFlagArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        self.allDiseaseArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        self.selectedArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        self.title = NSLocalizedString(@"我的自查", nil);
//        UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回", nil) style:UIBarButtonItemStylePlain target:self action:nil];
//        self.navigationItem.backBarButtonItem = backBar;
//        [backBar release];
        
        myDBOperation = [DBOperate shareInstance];
    }
    return self;
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    BOOL is = FALSE;
//    NSArray *array = self.navigationController.viewControllers;
//    for (id cla in array) {
//        if ([cla isKindOfClass:[CheckDiseaseListViewController class]]) {
//            is = TRUE;
//            break;
//        }
//    }
//    
//    if (is) {
//        [g_winDic removeObjectForKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
//    }
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [g_winDic setObject:@"1" forKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
//}

#pragma mark - UISearchDisplayDelegate

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    NSLog(@"search begin");
    generalSymptomsTableView.hidden = YES;
    sepecialSynptomsTableView.hidden = YES;
    headView.hidden = YES;

}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{

    //改变数据源-------

    switch (self.currentSelectedBtn.tag) {
        case 100:
        case 101:
        {
            
            generalSymptomsTableView.hidden = NO;
            sepecialSynptomsTableView.hidden = NO;
        }
            break;
        case 102:
        case 103:
        {
            generalSymptomsTableView.hidden = YES;
            sepecialSynptomsTableView.hidden = NO;
        }
            break;
        default:
            break;
    }

    headView.hidden = NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{

    return NO;

}

#pragma mark - UISearBarDelegae 

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

    [self getSymptomsinfoByName:searchBar.text];
}


#pragma mark - ChoiceButtonClicked Function
- (void)choiceButtonClicked:(UIButton *)choiceBtn
{

    if(isScrolling){
    
        return;
    }
    
    if(self.currentSelectedBtn.tag == choiceBtn.tag){
    
        return;
    }
    
    [self.selectedArray removeAllObjects];
    currentChoice = (int)choiceBtn.tag;
    if(self.currentSelectedBtn){
        self.currentSelectedBtn.selected = NO;
        self.currentSelectedBtn = choiceBtn;
        self.currentSelectedBtn.selected = YES;
    }else{
    
        self.currentSelectedBtn = choiceBtn;
        self.currentSelectedBtn.selected = YES;
    }
    
//    [choiceBtn setBackgroundColor:[CommonImage colorWithHexString:VERSION_TEXT_COLOR]];
    
    //改变数据源-------
    switch (choiceBtn.tag) {
        case 100:
        {//男
            if(self.hasDiffenerntSource){
            
                self.generalSymDataArray = self.manSymDataArray;
                
            }
            toCheckButton.hidden = NO;
            [self.listSynptomsArray removeAllObjects];//移除掉然后重新获得第一个二级部位的相关病症
            generalSymptomsTableView.hidden = NO;
            sepecialSynptomsTableView.hidden = NO;
            sepecialSynptomsTableView.frame = sepecialSynptomsTableView.frame = CGRectMake(80, 55, kDeviceWidth-80, SCREEN_HEIGHT-44-55-50);
            [generalSymptomsTableView reloadData];//刷新
            [self choiceFirstRowOfGeneralSymptomsTableView];//选中第一个

            
        }
            break;
        case 101:
        {//女
            
            if(self.hasDiffenerntSource){
                
                self.generalSymDataArray = self.womanSymDataArray;
                
            }
            toCheckButton.hidden = NO;
            [self.listSynptomsArray removeAllObjects];//移除掉然后重新获得第一个二级部位的相关病症
            generalSymptomsTableView.hidden = NO;
            sepecialSynptomsTableView.hidden = NO;
            sepecialSynptomsTableView.frame =  CGRectMake(80, 55, kDeviceWidth-80, SCREEN_HEIGHT-44-55-50);
            [generalSymptomsTableView reloadData];//刷新
            [self choiceFirstRowOfGeneralSymptomsTableView];//选中第一个
            
            
        }
            break;
        case 102:
        {//老
             toCheckButton.hidden = YES;
            sepecialSynptomsTableView.frame = CGRectMake(0, 55, kDeviceWidth, SCREEN_HEIGHT-44-55);
            toCheckButton.hidden = YES;
            generalSymptomsTableView.hidden = YES;
            sepecialSynptomsTableView.hidden = NO;
            //根据人群获得症状
            self.listSynptomsArray = [NSMutableArray array];
            [sepecialSynptomsTableView reloadData];//刷新症状列表--老人--没有cell
            [self getSymptomsinfoByCrowd:self.crowIDArray[@"老人"]];
            
            
        }
            break;
        case 103:
        {//幼
             toCheckButton.hidden = YES;
            sepecialSynptomsTableView.frame = CGRectMake(0, 55, kDeviceWidth, SCREEN_HEIGHT-44-55);
            toCheckButton.hidden = YES;
            generalSymptomsTableView.hidden = YES;
            sepecialSynptomsTableView.hidden = NO;
            self.listSynptomsArray = [NSMutableArray array];
            [sepecialSynptomsTableView reloadData];//刷新症状列表--老人--没有cell
            //根据人群获得症状
            [self getSymptomsinfoByCrowd:self.crowIDArray[@"小孩"]];
            
        }
            break;
        default:
            break;
    }
    
    //刷新数组
    
}

//- (void)getChoiceView
//{
//    NSArray *titleArray = @[NSLocalizedString(@"男", nil),NSLocalizedString(@"女", nil),NSLocalizedString(@"老", nil),NSLocalizedString(@"幼", nil)];
//    
//    UIButton *button = nil;
//    
//    CGFloat width = kDeviceWidth/4.0f;
//    
//    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 55)];
//    headView.backgroundColor = [CommonImage colorWithHexString:@"f8f8f8"];
//    [self.view addSubview:headView];
//    [headView release];
//
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 54, kDeviceWidth, 1)];
//    line.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//    line.alpha = 0.3;
//    [headView addSubview:line];
//    [line release];
//    
//    CGFloat offset = 10.0f;
//    
//    width = 75.0f;
//    
//    NSArray *normalImgArray = @[@"img.bundle/check/left_nor.png",@"img.bundle/check/mid_nor.png",@"img.bundle/check/mid_nor.png",@"img.bundle/check/right_nor.png"];
//    NSArray *selectedImgArray = @[@"img.bundle/check/left_sel.png",@"img.bundle/check/mid_sel.png",@"img.bundle/check/mid_sel.png",@"img.bundle/check/right_sel.png"];
//    
//    for(int i = 0;i < 4; i++){
//    
//        button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(offset+i*width, 12, width, 30);
//        button.tag = 100+i;
//        [button setTitle:titleArray[i] forState:UIControlStateNormal];
//        
//        [button setTitleColor:[CommonImage colorWithHexString:@"#333333"] forState:UIControlStateNormal];
//        button.titleLabel.font =[ UIFont systemFontOfSize:15.0f];
//
//        UIImage *norImg = [UIImage imageNamed:normalImgArray[i]];
//        UIImage *selectedImg = [UIImage imageNamed:selectedImgArray[i]];
//        [button setBackgroundImage:selectedImg forState:UIControlStateHighlighted];
//        [button setBackgroundImage:norImg forState:UIControlStateNormal];
//        [button setBackgroundImage:selectedImg forState:UIControlStateSelected];
//        
//
//        [button addTarget:self action:@selector(choiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [headView addSubview:button];
//        if(i == 1 || i == 2 || i == 3){
//            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10+i*width-1, 12, 1, 30)];
//            line.backgroundColor = [CommonImage colorWithHexString:@"87c843"];
//            line.alpha = 0.3;
//            [headView addSubview:line];
//            [line release];
//        }
//        if(i == self.selectedManORWoman){//默认选中男或女
//            [self showSelected:button];
//        
//        }
//        
//    }
//}

//显示选中效果
//- (void)showSelected:(UIButton *)choiceBtn
//{
//    currentChoice = choiceBtn.tag;
//    if(self.currentSelectedBtn){
//        self.currentSelectedBtn.selected = NO;
//        self.currentSelectedBtn = choiceBtn;
//        self.currentSelectedBtn.selected = YES;
//    }else{
//        
//        self.currentSelectedBtn = choiceBtn;
//        self.currentSelectedBtn.selected = YES;
//    }
//
//
//}


#pragma NetWorkReleated Function
//根据类型查询身体部位接口
- (void)getSymptomsinfoBybodyPartWithBodyPartId:(NSString *)bodyPartId
{
    
  NSArray *resultArray = [myDBOperation getSymptomListByBodyPartId:bodyPartId];
    
    
    self.listSynptomsArray = [NSMutableArray arrayWithArray:resultArray];
    [self.allDiseaseArray removeAllObjects];
    [self.openFlagArray removeAllObjects];
    [self.arrowFlagArray removeAllObjects];
    //男女症状查看疾病开关
    for(int i = 0; i < self.listSynptomsArray.count; i++){
        [self.openFlagArray addObject:@"0"];
        [self.arrowFlagArray addObject:@"0"];
        [self.allDiseaseArray addObject:[NSArray array]];//疾病数据源按照section排放
    }
    [sepecialSynptomsTableView reloadData];

    return;
    
//    [[CommonHttpRequest defaultInstance] sendHttpRequest:[GetSymptomsinfoBybodyPart stringByAppendingFormat:@"%@/-1/-1",bodyPartId] encryptStr:GetSymptomsinfoBybodyPart delegate:self controller:self actiViewFlag:YES title:NSLocalizedString(@"正在加载...", nil)];
    
}
//获取症状的相关疾病列表
//多个用分号分开
- (void)getSymptomsDiseaseBysymptomids:(NSString *)ids
{

    
//    ids = @"003ec7ff49954221ae08859811065e4a;004014e200e04e69b9d906926c0a23b6;004457c7b02e4ba88c23d59f91a75767;";
//    ids = @"003ec7ff49954221ae08859811065e4a";
//    NSDictionary *requestDic = @{@"ids":ids};
    
   NSArray *resultArray = [myDBOperation getDiseaseListBySymptomIds:ids];
    
    //resultArray 最后一项为权重总和
    
    NSMutableArray *resultMutArray = [NSMutableArray arrayWithArray:resultArray];
    
    NSDictionary *allOddsDic = [resultArray firstObject];
    [resultMutArray removeObjectAtIndex:0];
    
    
    
    //跳转到另外一个页面中--疾病列表
    NSLog(@"--resultArray:%@",resultArray);
    //            self.diseaseArray = [[NSMutableArray alloc] initWithArray:resultArray];
    SymptomsDiseaseViewController *symptomsDiseaseVC = [[SymptomsDiseaseViewController alloc] init];
    symptomsDiseaseVC.allOdds = [allOddsDic[@"odds"] floatValue];
    symptomsDiseaseVC.diseaseArray = resultMutArray;
    
     AppDelegate *myDelegate = [Common getAppDelegate];
    
    [myDelegate.navigationVC pushViewController:symptomsDiseaseVC animated:YES];
    [symptomsDiseaseVC release];


    return;
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [requestDic setValue:ids forKey:@"ids"];
    
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GetSymptomsDiseaseBysymptomids values:requestDic requestKey:GetSymptomsDiseaseBysymptomids delegate:self controller:self actiViewFlag:YES title:nil];
}

//根据ID获取疾病信息
- (void)getSymptomDiseaseByid:(NSString *)diseaseId
{

//    [myDBOperation getDiseaseInfoById:diseaseId];
    
    
//    [[CommonHttpRequest defaultInstance] sendHttpRequest:[GetSymptomDiseaseByid stringByAppendingFormat:@"%@",diseaseId] encryptStr:GetSymptomDiseaseByid delegate:self controller:self actiViewFlag:YES title:NSLocalizedString(@"正在获取疾病详细", nil)];
}

//获取人群编号

- (void)getAllSymptomCrowd{

    
    NSArray *resultArray = [myDBOperation getALlSymptomCrowd];
    
    
    //获取人群id
    NSLog(@"resultArray:%@",resultArray);
    for(NSDictionary *dic in resultArray){
        if([dic[@"crowdName"] isEqualToString:NSLocalizedString(@"老人", nil)]){
            
            [self.crowIDArray setObject:dic[@"crowdId"] forKey:NSLocalizedString(@"老人", nil)];
        }else if([dic[@"crowdName"] isEqualToString:NSLocalizedString(@"小孩", nil)]){
            
            [self.crowIDArray setObject:dic[@"crowdId"] forKey:NSLocalizedString(@"小孩", nil)];
        }
    }
    
        return;
    
//    [[CommonHttpRequest defaultInstance] sendHttpRequest:GetAllSymptomCrowd encryptStr:GetAllSymptomCrowd delegate:self controller:self actiViewFlag:NO title:nil];
}
//根据人群获得症状

- (void)getSymptomsinfoByCrowd:(NSString *)crowdId
{
    
  NSArray *resultArray = [myDBOperation getSymptomListByCrowId:crowdId];
    
    self.listSynptomsArray = [NSMutableArray arrayWithArray:resultArray];
    [sepecialSynptomsTableView reloadData];//刷新症状列表--老人--没有cell
    return;

//    [[CommonHttpRequest defaultInstance] sendHttpRequest:[GetSymptomsinfoByCrowd stringByAppendingFormat:@"%@/-1/-1",crowdId] encryptStr:GetSymptomsinfoByCrowd delegate:self controller:self actiViewFlag:YES title:nil];
}

//获取症状详细

- (void)getSymptomsinfoById:(NSString *)symptomsId
{

    NSDictionary *resultDic =   [myDBOperation getSymptomInfoById:symptomsId];
    DiseaseInfoViewController *diseaseInfoVC = [[DiseaseInfoViewController alloc] init];
    diseaseInfoVC.thirdName = NSLocalizedString(@"检查", nil);
    NSString *diseaseInfo = resultDic[@"symptomInfo"];//简介
    NSString *diseaseCause = resultDic[@"symptomCause"];//病因
    NSString *symptom = resultDic[@"examinationInfo"];//症状---不叫症状
    NSString *diagnose = resultDic[@"diagnose"];//诊断
    diseaseInfoVC.title = self.nextPageTitle;
    diseaseInfoVC.diseaseArray = [NSMutableArray arrayWithObjects:diseaseInfo.length>0?diseaseInfo:@"",diseaseCause.length>0?diseaseCause:@"",symptom.length>0?symptom:@"",diagnose.length>0?diagnose:@"", nil];
    
    [self.navigationController pushViewController:diseaseInfoVC animated:YES];
    [diseaseInfoVC release];

    
    
    return;
//    [[CommonHttpRequest defaultInstance] sendHttpRequest:[GetSymptomsinfoById stringByAppendingFormat:@"%@",symptomsId] encryptStr:GetSymptomsinfoById delegate:self controller:self actiViewFlag:YES title:NSLocalizedString(@"正在获取症状详细", nil)];

}

//根据症状名搜索症状

- (void)getSymptomsinfoByName:(NSString *)nameString
{
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [requestDic setValue:nameString forKey:@"name"];
    [requestDic setValue:@"0" forKey:@"limitStart"];
    [requestDic setValue:@"9999" forKey:@"limitEnd"];
    
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GetSymptomsinfoByName values:requestDic requestKey:GetSymptomsinfoByName delegate:self controller:self actiViewFlag:0 title:nil];

}


#pragma mark - ASIHttpRequest Response  Delegate

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    NSArray *resultArray = dic[@"rs"];
    if (![[dic objectForKey:@"state"] intValue])
    {
        if ([loader.username isEqualToString:GetSymptomsinfoBybodyPart]){
            
            self.listSynptomsArray = [NSMutableArray arrayWithArray:resultArray];
            [self.allDiseaseArray removeAllObjects];
            [self.openFlagArray removeAllObjects];
            [self.arrowFlagArray removeAllObjects];
            //男女症状查看疾病开关
            for(int i = 0; i < self.listSynptomsArray.count; i++){
                [self.openFlagArray addObject:@"0"];
                [self.arrowFlagArray addObject:@"0"];
                [self.allDiseaseArray addObject:[NSArray array]];//疾病数据源按照section排放
            }
            [sepecialSynptomsTableView reloadData];
            
        }else if([loader.username isEqualToString:GetSymptomsDiseaseBysymptomids]){
            //根据症状查找疾病返回，适用于男女 数据源为
            
            
            //跳转到另外一个页面中--疾病列表
            NSLog(@"--resultArray:%@",resultArray);
            //            self.diseaseArray = [[NSMutableArray alloc] initWithArray:resultArray];
            SymptomsDiseaseViewController *symptomsDiseaseVC = [[SymptomsDiseaseViewController alloc] init];
            symptomsDiseaseVC.diseaseArray = resultArray;
            [self.navigationController pushViewController:symptomsDiseaseVC animated:YES];
            [symptomsDiseaseVC release];
            
            
//            self.sepcialSymDataArray = [NSMutableArray arrayWithArray:resultArray];
////            [sepecialSynptomsTableView reloadData];
//            
//            if(resultArray.count){
//                //添加到数据源中
//                [self.allDiseaseArray replaceObjectAtIndex:currentWaitReloadSection withObject:resultArray];
//                
//                [sepecialSynptomsTableView reloadSections:[NSIndexSet indexSetWithIndex:currentWaitReloadSection] withRowAnimation:UITableViewRowAnimationAutomatic];
//            }else{
////                [self.openFlagArray replaceObjectAtIndex:currentWaitReloadSection withObject:[NSString stringWithFormat:@"%d",0]];
//                [sepecialSynptomsTableView reloadSections:[NSIndexSet indexSetWithIndex:currentWaitReloadSection] withRowAnimation:UITableViewRowAnimationAutomatic];
//            }
//            isRequestFlag = NO;//请求结束
      
        }else if([loader.username isEqualToString:GetSymptomDiseaseByid]){
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
            
            
        }else if([loader.username isEqualToString:GetAllSymptomCrowd]){
        //获取人群id
            NSLog(@"resultArray:%@",resultArray);
            for(NSDictionary *dic in resultArray){
                if([dic[@"crowdName"] isEqualToString:NSLocalizedString(@"老人", nil)]){
                
                    [self.crowIDArray setObject:dic[@"crowdId"] forKey:NSLocalizedString(@"老人", nil)];
                }else if([dic[@"crowdName"] isEqualToString:NSLocalizedString(@"小孩", nil)]){
                    
                    [self.crowIDArray setObject:dic[@"crowdId"] forKey:NSLocalizedString(@"小孩", nil)];
                }

            }
        }else if([loader.username isEqualToString:GetSymptomsinfoByCrowd]){
                //根据人群id获得症状
                NSLog(@"resultArray:%@",resultArray);
            
            self.listSynptomsArray = [NSMutableArray arrayWithArray:resultArray];
            [sepecialSynptomsTableView reloadData];//刷新症状列表--老人--没有cell
            
        }else if([loader.username isEqualToString:GetSymptomsinfoById]){
            
            NSDictionary *resultDic = dic[@"rs"];
            
            DiseaseInfoViewController *diseaseInfoVC = [[DiseaseInfoViewController alloc] init];
            diseaseInfoVC.thirdName = NSLocalizedString(@"检查", nil);
            NSString *diseaseInfo = resultDic[@"symptomInfo"];//简介
            NSString *diseaseCause = resultDic[@"symptomCause"];//病因
            NSString *symptom = resultDic[@"examinationInfo"];//症状---不叫症状
            NSString *diagnose = resultDic[@"diagnose"];//诊断
            diseaseInfoVC.title = self.nextPageTitle;
            diseaseInfoVC.diseaseArray = [NSMutableArray arrayWithObjects:diseaseInfo.length>0?diseaseInfo:@"",diseaseCause.length>0?diseaseCause:@"",symptom.length>0?symptom:@"",diagnose.length>0?diagnose:@"", nil];
            
            [self.navigationController pushViewController:diseaseInfoVC animated:YES];
            [diseaseInfoVC release];
            
         
        }else if([loader.username isEqualToString:GetSymptomsinfoByName]){
            //模糊搜索结果
        
            NSLog(@"resultArray:%@",resultArray);
            
            self.searchResultArray = [NSMutableArray arrayWithArray:resultArray];
            [searchC.searchResultsTableView reloadData];
        
        }
        
    }else {
        isRequestFlag = NO;//请求结束
        [Common TipDialog:[dic objectForKey:@"msg"]];
        return;
    }
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    isRequestFlag = NO;//请求结束
    NSLog(@"fail");
    
    if([loader.username isEqualToString:GetSymptomsDiseaseBysymptomids]){
        NSString *errorString = [loader.error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        if([errorString isEqualToString:@"The request timed out"]){
        
            [Common TipDialog:NSLocalizedString(@"请求超时!", nil)];
            return;
        }
    }
    
    [Common TipDialog:NSLocalizedString(@"请求失败，请稍后重试", nil)];

    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [CommonImage colorWithHexString:@"f8f8f8"];
    

 
//    [self getAllSymptomCrowd];//获取人群id
//    [self getChoiceView];
    
    
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 54, kDeviceWidth, 40)];
//    searchBar.delegate = self;
//
//    searchC = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
//    searchC.delegate = self;
//    searchC.searchResultsDelegate = self;
//    searchC.searchResultsDataSource = self;
//    searchBar.placeholder = @"请输入您要查询的病症 例如：头痛";
//    searchBar.backgroundColor = [UIColor clearColor];
//    
//
//    UITableView *allTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, kDeviceWidth, SCREEN_HEIGHT)];
//    allTableView.tableHeaderView = searchBar;
//    allTableView.scrollEnabled = NO;
//    allTableView.bounces = NO;
//    allTableView.backgroundColor = [CommonImage colorWithHexString:@"f6f7ee"];
//    allTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:allTableView];
//    [allTableView release];
    
    //部位数据源
    NSArray *partArray = @[@"全身",@"头部",@"胸部",@"腹部",@"四肢",@"背部",@"会阴"];
    self.generalSymDataArray = [NSMutableArray arrayWithArray:partArray];
    
    
    //全身症状Table
    generalSymptomsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 80, SCREEN_HEIGHT-44-55-50)];
    generalSymptomsTableView.dataSource = self;
    generalSymptomsTableView.delegate = self;
    generalSymptomsTableView.backgroundColor = [UIColor whiteColor];
    generalSymptomsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:generalSymptomsTableView];
    
    //特殊部位症状Table
    sepecialSynptomsTableView = [[UITableView alloc] initWithFrame:CGRectMake(80, 0, kDeviceWidth-80, SCREEN_HEIGHT-44-55-50)];
    sepecialSynptomsTableView.dataSource = self;
    sepecialSynptomsTableView.separatorColor = [CommonImage colorWithHexString:LINE_COLOR];
    sepecialSynptomsTableView.delegate = self;
    sepecialSynptomsTableView.backgroundColor = [UIColor clearColor];
    sepecialSynptomsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:sepecialSynptomsTableView];
 
    //诊断按钮
    toCheckButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toCheckButton.frame = CGRectMake(15, SCREEN_HEIGHT-44-55-44, kDeviceWidth-30, 44);
    toCheckButton.layer.cornerRadius = 4.0f;
    [self.view addSubview:toCheckButton];

    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
    [toCheckButton setBackgroundImage:image forState:UIControlStateNormal];
    [toCheckButton addTarget:self action:@selector(sendToDiagnosis:) forControlEvents:UIControlEventTouchUpInside];
    [toCheckButton setTitle:NSLocalizedString(@"诊断", nil) forState:UIControlStateNormal];
    toCheckButton.layer.cornerRadius = 4;
    toCheckButton.clipsToBounds = YES;

    [self performSelector:@selector(choiceFirstRowOfGeneralSymptomsTableView) withObject:nil afterDelay:0.2];

   
}


- (void)sendToDiagnosis:(UIButton *)btn
{
    NSLog(@"self.selected:%@",self.selectedArray);
    
    if(!self.selectedArray || !self.selectedArray.count||self.selectedArray.count == 0){
        
        [Common TipDialog:NSLocalizedString(@"请至少选择一个病症进行诊断", nil)];
    }
    //疾病列表数据源
    NSString *ids = @"";
    for(NSDictionary *oneDic in self.selectedArray){
        
        ids = [NSString stringWithFormat:@"%@;%@",ids,oneDic[@"id"]];
        
    }
    if(self.selectedArray.count == 1){
        
        [self getSymptomsDiseaseBysymptomids:[ids substringFromIndex:1]];
        
    }else if(self.selectedArray.count > 1){
        
        [self getSymptomsDiseaseBysymptomids:[ids substringFromIndex:1]];
    }
    
    
}


- (void)choiceFirstRowOfGeneralSymptomsTableView
{
    if(self.generalSymDataArray.count > 0){
        [self tableView:generalSymptomsTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [generalSymptomsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark - Table view data source And Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if(tableView == generalSymptomsTableView){
        
        return 0;
    }else if(tableView == sepecialSynptomsTableView){
              return 44;
    }
        return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if(tableView == generalSymptomsTableView){
    
        return nil;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
        titleLabel.text = NSLocalizedString(@"全身症状", nil);
        titleLabel.font = [UIFont systemFontOfSize:13.0f];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        return [titleLabel autorelease];

    }
    if(tableView == sepecialSynptomsTableView){
    
        UIImageView *arrowImv = nil;
        CGFloat offset = 0.0f;
        if(currentChoice == 102 || currentChoice == 103){
        //老跟幼 用headView进行列表展示，row进行详细展示
            offset = 80;
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, kDeviceWidth-80+offset, 44);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.tag = 100+section;
        //男女为显示症状，老幼为显示疾病
        NSDictionary *bodyDic = self.listSynptomsArray[section];
        
        [button setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
        
        [button setTitle:[NSString stringWithFormat:@"   %@",bodyDic[@"symptomName"]] forState:UIControlStateNormal];
        [button setBackgroundColor:[CommonImage colorWithHexString:@"f8f8f8"]];
        [button setTitleColor:[CommonImage colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [button setTitleColor:[CommonImage colorWithHexString:@"#333333"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(openOrClose:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        
        //分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, kDeviceWidth, 0.5)];
        line.backgroundColor = [CommonImage colorWithHexString:@"#666666"];
        line.alpha = 0.4;
        [button addSubview:line];
        [line release];
        //箭头符号
        
        arrowImv = [[UIImageView alloc] initWithFrame:CGRectMake(button.size.width-30, 11, 20, 20)];
        arrowImv.image = [UIImage imageNamed:@"common.bundle/diary/selected_off.png"];
        arrowImv.tag = 999;
        [button addSubview:arrowImv];
        [arrowImv release];
        
        if(currentChoice == 102 || currentChoice == 103){
            arrowImv.hidden = YES;
        }else{
            arrowImv.hidden = NO;
            
            if([self.selectedArray containsObject:bodyDic]){
                //将颜色置为绿色
               
                NSString *imageName = @"common.bundle/diary/selected_on.png";
                
                arrowImv.image = [UIImage imageNamed:imageName];
            }else{
                arrowImv.image = [UIImage imageNamed:@"common.bundle/diary/selected_off.png"];
            }
            
            
//            if([self.arrowFlagArray[section] boolValue]){
//                //开启
//                arrowImv.transform = CGAffineTransformMakeRotation(M_PI);
//
//            }else {
//                //关闭
//                arrowImv.transform = CGAffineTransformMakeRotation(0);
//
//            }
            
        }
        
        
        return button;

    }
    
    
    return nil;
}
- (void)openOrClose:(UIButton *)btn
{
    int section = (int)btn.tag - 100;
    if(currentChoice == 102 || currentChoice == 103){
    //老幼--进入下一页面查看疾病详细
        
        NSDictionary *symptomDic = self.listSynptomsArray[section];
        self.nextPageTitle = symptomDic[@"symptomName"];
        //获取症状详细
        [self getSymptomsinfoById:symptomDic[@"id"]];
        
        
    
    }else{
    //男女 展开查看 疾病列表
   
        UIImageView *arrowImagView = (UIImageView *)[btn viewWithTag:999];
        
        
        NSDictionary *selectedDic = self.listSynptomsArray[section];//症状字典

        
        if([self.selectedArray containsObject:selectedDic]){
            //已经有了，移除掉，并将颜色置为灰色
            [self.selectedArray removeObject:selectedDic];
            arrowImagView.image = [UIImage imageNamed:@"common.bundle/diary/selected_off.png"];
        }else{
            [self.selectedArray addObject:selectedDic];
            
            NSString *imageName = @"common.bundle/diary/selected_on.png";
            
            arrowImagView.image = [UIImage imageNamed:imageName];
        }

        
        /*
        //以下为点击症状时，展开cell显示疾病信息----废弃
        
        if(isRequestFlag == YES){
            return;//不响应连续点击
        }
        
        UIImageView *arrowImagView = (UIImageView *)[btn viewWithTag:999];
        
        currentWaitReloadSection = section;
        
        
        NSString *oldFlag = self.openFlagArray[section];
        NSString *oldArrowFlag = self.arrowFlagArray[section];
        [self.openFlagArray replaceObjectAtIndex:section withObject:[NSString stringWithFormat:@"%d",![oldFlag integerValue]]];
        [self.arrowFlagArray replaceObjectAtIndex:section withObject:[NSString stringWithFormat:@"%d",![oldArrowFlag integerValue]]];
        if(![oldArrowFlag integerValue]){//新数字为1时请求网络
            
#warning 判断数组中该cuurentWaitReloadSection是否有内容,有则直接刷新
            [UIView animateWithDuration:0.5 animations:^{
                 arrowImagView.transform = CGAffineTransformMakeRotation(M_PI);
            }];
           
            
            NSArray *oldResultArray = [self.allDiseaseArray objectAtIndex:currentWaitReloadSection];
            if(oldResultArray.count){
            
                 self.sepcialSymDataArray = [NSMutableArray arrayWithArray:oldResultArray];
                
                [sepecialSynptomsTableView reloadSections:[NSIndexSet indexSetWithIndex:currentWaitReloadSection] withRowAnimation:UITableViewRowAnimationAutomatic];
                return;
            }
   
            isRequestFlag = YES;
            NSDictionary *bodyDic = self.listSynptomsArray[section];
            [self getSymptomsDiseaseBysymptomids:bodyDic[@"id"]];
        }else{
            //否则直接收起
            
            [UIView animateWithDuration:0.5 animations:^{
                arrowImagView.transform = CGAffineTransformMakeRotation(0);
            }];
//            arrowImagView.transform = CGAffineTransformMakeRotation(0);
//           arrowImagView.image  = [UIImage imageNamed:@"common.bundle/msg/right_normal.png"];
             [sepecialSynptomsTableView reloadSections:[NSIndexSet indexSetWithIndex:currentWaitReloadSection] withRowAnimation:UITableViewRowAnimationAutomatic];
        }*/
    }
         
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == sepecialSynptomsTableView){
        
//        if(currentChoice == 102 || currentChoice == 103){
            //老跟幼 用headView进行列表展示，row进行详细展示
            return   self.listSynptomsArray.count;
    
//        }else {
//        //男女
//            return 1;
//            
//        }
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == generalSymptomsTableView){
        
        return self.generalSymDataArray.count;
        
    }else if(tableView == sepecialSynptomsTableView){
        
        if(currentChoice == 102 || currentChoice == 103){
            //老跟幼 用headView进行列表展示，row进行详细展示
            return  0;
            
        }else {
            //男女
            //0关闭 1开启//self.sepcialSymDataArray.count;
            if([self.openFlagArray[section] boolValue]){
                
                NSArray *diseaseArray = self.allDiseaseArray[section];
//                return self.sepcialSymDataArray.count;
                return diseaseArray.count;
            }
        }
    }else{
    //搜索的
      return   self.searchResultArray.count;
    
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"checkCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
    
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        
    }

    if(tableView == generalSymptomsTableView){
    
        UIImageView *selectedImageView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common.bundle/check/generalPressed.png"]];
        selectedImageView.frame = CGRectMake(0, 0, 80, 44);
        cell.selectedBackgroundView = selectedImageView;
        [selectedImageView release];
        
        
//        NSDictionary *bodyDic = self.generalSymDataArray[indexPath.row];
        NSString *bodyString = self.generalSymDataArray[indexPath.row];
        cell.textLabel.text = bodyString;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
//        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textColor = [CommonImage colorWithHexString:@"#333333"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    }else if(tableView == sepecialSynptomsTableView){
        
        if(currentChoice == 102 || currentChoice == 103){
            //老跟幼 用headView显示疾病 没有row
            
            cell.textLabel.text = self.detailSynptomsArray[indexPath.row];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            
        }else {
            //男女--headView显示症状，row显示疾病
            NSDictionary *bodyDic = self.sepcialSymDataArray[indexPath.row];
            
            cell.textLabel.text = [NSString stringWithFormat:@"   %@",bodyDic[@"diseaseName"]];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
            
        }
    }else{
        //搜索
        NSDictionary *symptomDic = self.searchResultArray[indexPath.row];
        
        cell.textLabel.text = symptomDic[@"symptomName"];
    
    
    
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(tableView == generalSymptomsTableView){

        NSString *bodyString = self.generalSymDataArray[indexPath.row];
        //查询数据库
        NSArray *resultArray = [myDBOperation getSymptomListByName:bodyString];
        self.listSynptomsArray = [NSMutableArray arrayWithArray:resultArray];
        [self.allDiseaseArray removeAllObjects];
        [self.openFlagArray removeAllObjects];
        [self.arrowFlagArray removeAllObjects];
        [self.selectedArray removeAllObjects];
        //男女症状查看疾病开关
        for(int i = 0; i < self.listSynptomsArray.count; i++){
            [self.openFlagArray addObject:@"0"];
            [self.arrowFlagArray addObject:@"0"];
            [self.allDiseaseArray addObject:[NSArray array]];//疾病数据源按照section排放
        }
        [sepecialSynptomsTableView reloadData];
        toCheckButton.hidden = NO;

//        NSDictionary *bodyDic = self.generalSymDataArray[indexPath.row];
//        [self getSymptomsinfoBybodyPartWithBodyPartId:bodyDic[@"partId"]];
        
    }else if(tableView == sepecialSynptomsTableView) {
        
        if(currentChoice == 102 || currentChoice == 103){
            //老跟幼 用headView进行列表展示，row进行详细展示
            //不响应
            
        }else {
            //男女
            //进入详细
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            NSArray *diseaseArray = self.allDiseaseArray[indexPath.section];
            NSDictionary *diseaseDic = diseaseArray[indexPath.row];
            self.nextPageTitle = diseaseDic[@"diseaseName"];
            
            //初始化选择的病症数组
            
            self.selectedArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            
            
            [self getSymptomDiseaseByid:diseaseDic[@"id"]];
        }
    }else{
    
 
        NSDictionary *symptomDic = self.searchResultArray[indexPath.row];
        self.nextPageTitle = symptomDic[@"symptomName"];
        //获取症状详细
        [self getSymptomsinfoById:symptomDic[@"id"]];
    
    }
    
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(tableView == generalSymptomsTableView){
        selectedCell.textLabel.textColor = [CommonImage colorWithHexString:@"#333333"];
        
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//   
//    isScrolling = YES;
//    
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    isScrolling = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate == NO){
    
        isScrolling = NO;
    }

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    isScrolling = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
