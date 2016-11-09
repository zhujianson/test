//
//  HealthRecordViewController.m
//  healthManagement1.0
//
//  Created by wangmin on 16/1/6.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "HealthRecordViewController.h"

#import "HealthRecordModel.h"

#import "HealthRecordCell.h"

@interface HealthRecordViewController ()
<UITableViewDataSource,UITableViewDelegate>
{

    UITableView *recordTableView;
}
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *keysArray;

@end

@implementation HealthRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"健康档案";
    self.log_pageID = 42;

    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.keysArray = [NSMutableArray arrayWithCapacity:0];
    //基本信息
    NSArray *basicInfoArray = @[@"nickName",@"sex",@"birthday"];
    NSArray *diseaseInfoArray = @[@"associatedHistory",@"familyHistory"];
    NSArray *testItemArray = @[@"height",@"weight",@"bmi",@"waist",@"hipline",@"whr",@"fatRatio",@"oxygen",@"bloodPressure",@"bloodSugar",@"uricAcid"];
    NSArray *foodSituationArray = @[@"dietaryAssessment"];
    NSArray *physicalSituationArray = @[@"physicalAssessment"];
    
    [self.keysArray  addObject:basicInfoArray];
    [self.keysArray  addObject:diseaseInfoArray];
    [self.keysArray  addObject:testItemArray];
    [self.keysArray  addObject:foodSituationArray];
    [self.keysArray  addObject:physicalSituationArray];
    
    
    recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    recordTableView.dataSource = self;
    recordTableView.delegate = self;
    recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:recordTableView];
    

    [self getDataSource];
}



- (void)getDataSource
{
    NSMutableDictionary *requestDic =  [[NSMutableDictionary alloc] initWithCapacity:0];
  
    
    NSString *requestName =  Get_Account_Health_Profile;
//    [requestDic setValue:[NSNumber numberWithInt:m_nowPage] forKey:@"pageNumber"];
//    [requestDic setValue:[NSNumber numberWithInt:g_everyPageNum] forKey:@"pageSize"];
//    [requestDic setValue:postId forKey:@"postId"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:requestName values:requestDic requestKey:requestName delegate:self controller:self actiViewFlag:0 title:nil];
}

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    if ([dic[@"head"][@"state"] isEqualToString:@"0000"])
    {
        NSDictionary *bodyDic = dic[@"body"];
        if ([loader.username isEqualToString:Get_Account_Health_Profile]) {
            
            int sectionIndex = 0;
            NSArray *titleArray = @[@"基本信息",@"现(既往)病史和家族史",@"检测指标",@"膳食情况",@"体力活动及锻炼情况"];
            NSArray *logoArray = @[@"common.bundle/healthRecord/jbxx.png",@"common.bundle/healthRecord/bshjzbs.png",@"common.bundle/healthRecord/jczb.png",@"common.bundle/healthRecord/ssqk.png",@"common.bundle/healthRecord/tlhdjdlqk.png"];
            
            NSDictionary *diseaseDic = @{@"A":@"高血压",@"B":@"糖尿病",@"C":@"血脂异常",@"D":@"脂肪肝",@"E":@"痛风",@"F":@"无"};
            
            for(NSArray *groupArray in self.keysArray){
            
                NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:0];
                HealthRecordModel *model = [[HealthRecordModel alloc] init];
                model.type = titleType;
                model.logoName = titleArray[sectionIndex];
                model.logoImageName = logoArray[sectionIndex];
                [sectionArray addObject:model];
                
                
                for(NSString *item in groupArray){
                
                    HealthRecordModel *itemModel = [[HealthRecordModel alloc] init];
                    if(sectionIndex == 0 || sectionIndex == 2){
                        
                        itemModel.type = pairType;
                        itemModel.keyString = NSLocalizedString(item, nil);
                        itemModel.valueString = [bodyDic objectForKey:item];
                        
                    }else if (sectionIndex == 1){
                        
                        itemModel.diseaseTitleString = NSLocalizedString(item, nil);
                        NSArray *diseaseArray = [[[bodyDic objectForKey:item] uppercaseString] componentsSeparatedByString:@","];//@[@"高血压",@"糖尿病",@"高血压",@"糖尿病",@"高血压",@"糖尿病的",@"高血压"];
                        NSMutableArray *newDiseaseArray = [NSMutableArray arrayWithCapacity:0];
                        NSArray *orderArray = @[@"A",@"B",@"D",@"E",@"C",@"F"];
                        for(NSString *disease in orderArray){
                            if([diseaseArray containsObject:disease]){
                                [newDiseaseArray addObject:diseaseDic[disease]];
                            }
                        }
                        itemModel.diseaseArray = newDiseaseArray;
                        
                        
                        itemModel.type = diseaseType;
                        
                    }else if(sectionIndex == 3 || sectionIndex == 4){
                        
                        itemModel.contentString = [bodyDic objectForKey:item];
                        itemModel.type = textType;
                    }

                    [sectionArray addObject:itemModel];
                }
                
                sectionIndex++;
                
                [self.dataArray addObject:sectionArray];
            }
        
            [recordTableView reloadData];
        }
        
        
    } else {
        
        [Common TipDialog:dic[@"head"][@"msg"]];
    }
}




- (void)getDataSources
{
    HealthRecordModel *model = [[HealthRecordModel alloc] init];
    model.type = titleType;
    model.rowHeight = 60;
    model.logoName = @"基本信息";
    model.logoImageName = @"common.bundle/healthRecord/jbxx.png";
    [self.dataArray addObject:model];
    
    HealthRecordModel *model1 = [[HealthRecordModel alloc] init];
    model1.type = pairType;
    model1.keyString = @"姓名";
    model1.valueString = @"越狱兔";
    model1.rowHeight = 50;
    [self.dataArray addObject:model1];
    [self.dataArray addObject:model1];
    [self.dataArray addObject:model1];
    
    HealthRecordModel *model2 = [[HealthRecordModel alloc] init];
    model2.type = titleType;
    model2.rowHeight = 60;
    model2.logoName = @"现(既往)病史和家族史";
    model2.logoImageName = @"common.bundle/healthRecord/bshjzbs.png";
    [self.dataArray addObject:model2];
    
    HealthRecordModel *model3 = [[HealthRecordModel alloc] init];
    model3.type = diseaseType;
    model3.rowHeight = 150;
    model3.diseaseTitleString = @"已患相关病史";
    model3.diseaseArray = @[@"高血压",@"糖尿病",@"高血压",@"糖尿病",@"高血压",@"糖尿病的",@"高血压"];
    [self.dataArray addObject:model3];

    HealthRecordModel *model4 = [[HealthRecordModel alloc] init];
    model4.type = diseaseType;
    model4.rowHeight = 100;
    model4.diseaseTitleString = @"家族相关病史";
    model4.diseaseArray = @[@"高血压",@"糖尿病"];
    [self.dataArray addObject:model4];
    
    HealthRecordModel *model5 = [[HealthRecordModel alloc] init];
    model5.type = titleType;
    model5.rowHeight = 60;
    model5.logoName = @"检测指标";
    model5.logoImageName = @"common.bundle/healthRecord/jczb.png";
    [self.dataArray addObject:model5];
    
    HealthRecordModel *model6 = [[HealthRecordModel alloc] init];
    model6.type = pairType;
    model6.rowHeight = 50;
    model6.keyString = @"身高";
    model6.valueString = @"越狱兔";
    [self.dataArray addObject:model6];
    [self.dataArray addObject:model6];
    [self.dataArray addObject:model6];
    
    HealthRecordModel *model7 = [[HealthRecordModel alloc] init];
    model7.type = titleType;
    model7.rowHeight = 60;
    model7.logoName = @"膳食情况";
    model7.logoImageName = @"common.bundle/healthRecord/ssqk.png";

    [self.dataArray addObject:model7];
    
    HealthRecordModel *model8 = [[HealthRecordModel alloc] init];
    model8.type = textType;
    model8.rowHeight = 90;
    model8.contentString = @"他的学业时间点卡德加快放假啊是打飞机啊水电费阿萨德来发掘时的看法拉丝机";
    [self.dataArray addObject:model8];
    
    HealthRecordModel *model9 = [[HealthRecordModel alloc] init];
    model9.type = titleType;
    model9.rowHeight = 60;
    model9.logoName = @"体力活动及锻炼情况";
    model9.logoImageName = @"common.bundle/healthRecord/tlhdjdlqk.png";
    [self.dataArray addObject:model9];
    
    HealthRecordModel *model10 = [[HealthRecordModel alloc] init];
    model10.type = textType;
    model10.rowHeight = 90;
    model10.contentString = @"他的学业时间点卡德加快放假啊是打飞机啊水电费阿萨德来发掘时的看法拉丝机";
    [self.dataArray addObject:model10];
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.dataArray[section] count];

}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , kDeviceWidth, 7)];
    lineView1.backgroundColor = [CommonImage colorWithHexString:@"f2f2f2"];
    
    return lineView1;
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == [self.dataArray count]-1){
    
        return 0;
    }
    
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthRecordModel *model = self.dataArray[indexPath.section][indexPath.row];
    
    return model.rowHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    HealthRecordModel *model = self.dataArray[indexPath.section][indexPath.row];
    
    long sectionCount = [self.dataArray[indexPath.section] count];
    
    BaseHealthRecordCell *cell = nil;
    
    
//    titleType = 0,//标题用
//    pairType = 1,//键值对
//    TextType = 2,//只有文字
//    diseaseType = 3//疾病显示
    
    switch (model.type) {
        case titleType:
        {
        
            static NSString *identifier = @"HealthRecordModel";
            
             cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(!cell){
                
                cell = [[HealthRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
        
            [(HealthRecordCell *)cell setData:model];
            
            
        }
            break;
        case pairType:
        {
        
            static NSString *identifier = @"HealthRecordModelpairType";
            
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(!cell){
                
                cell = [[HealthRecordPairCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [(HealthRecordPairCell *)cell setData:model];
            if(indexPath.row == sectionCount-1){
            
                cell.lineView.hidden = YES;
            }else{
                cell.lineView.hidden = NO;
            }

            
        }
            break;
        case textType:
        {
            
            static NSString *identifier = @"HealthRecordModelTextType";
            
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(!cell){
                
                cell = [[HealthRecordTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [(HealthRecordTextCell *)cell setData:model];
            if(indexPath.row == sectionCount-1){
                
                cell.lineView.hidden = YES;
            }else{
                cell.lineView.hidden = NO;
            }
 
        }
            break;
        case diseaseType:
        {
            static NSString *identifier = @"HealthRecordModeldiseaseType";
            
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(!cell){
                
                cell = [[HealthRecordDiseaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [(HealthRecordDiseaseCell *)cell setData:model];
            if(indexPath.row == sectionCount-1){
                
                cell.lineView.hidden = YES;
            }else{
                cell.lineView.hidden = NO;
            }
        }
            break;
        default:
            break;
    }
    
    return cell;


}



@end
