//
//  PerfectViewController.m
//  jiuhaohealth3.0
//
//  Created by xjs on 15-1-19.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "PerfectViewController.h"
#import "PickerView.h"
#import "InputDueDatePicker.h"
#import "CheckSugarViewController.h"

@interface PerfectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *dataArray;
    UITableView *myTable;
    NSMutableDictionary * m_infoDic;
    
}
@end

@implementation PerfectViewController

- (void)dealloc
{
    [dataArray release];
    [myTable release];
    [m_infoDic release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"每日膳食订阅";
    m_infoDic = [[NSMutableDictionary alloc] init];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_getCheckUserBasicInfo",g_nowUserInfo.userid]] intValue]==1 || [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_getCheckUsertype",g_nowUserInfo.userid]]) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_getCheckUsertype",g_nowUserInfo.userid]]) {
            [m_infoDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_getCheckUsertype",g_nowUserInfo.userid]] forKey:@"type"];
        }
        [self createPerfectData];
    }else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:g_nowUserInfo.userid forKey:@"userId"];
        [[CommonHttpRequest defaultInstance] sendNewPostRequest:GET_PERSONAL_BASIC values:dic requestKey:GET_PERSONAL_BASIC delegate:self controller:self actiViewFlag:1 title:nil];
    }
    
    // Do any additional setup after loading the view.
}

- (void)createPerfectData
{
    
    if (g_nowUserInfo.birthday) {
        [m_infoDic setObject:g_nowUserInfo.birthday forKey:@"birthday"];
    }
    if (g_nowUserInfo.weight) {
        [m_infoDic setObject:[NSString stringWithFormat:@"%.f",g_nowUserInfo.weight] forKey:@"weight"];
    }
    if (g_nowUserInfo.height) {
        [m_infoDic setObject:[NSString stringWithFormat:@"%.f",g_nowUserInfo.height] forKey:@"hight"];
    }
    
    dataArray = [[NSArray alloc] initWithObjects:
                 [NSMutableDictionary dictionaryWithDictionary:@{ @"title" : @"生日：",
                                                                  @"value" : [Common isNULLString3:[m_infoDic objectForKey:@"birthday"]] }],
                 [NSMutableDictionary dictionaryWithDictionary:@{ @"title" : @"身高：",
                                                                  @"value" : [Common isNULLString3:[m_infoDic objectForKey:@"hight"]] }],
                 [NSMutableDictionary dictionaryWithDictionary:@{ @"title" : @"体重：",
                                                                  @"value" : [Common isNULLString3:[m_infoDic objectForKey:@"weight"]] }],
                 [NSMutableDictionary dictionaryWithDictionary:@{ @"title" : @"劳动强度",
                                                                  @"value" : [Common isNULLString3:[m_infoDic objectForKey:@"type"]] }],
                 nil];
    
    myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-20) style:UITableViewStyleGrouped];
//    [Common setExtraCellLineHidden:myTable];
    myTable.showsVerticalScrollIndicator = NO;
    myTable.delegate = self;
    myTable.separatorColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_SHEN];
    myTable.dataSource = self;
    myTable.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR];
    [self.view addSubview:myTable];
    // ios7分割线调整
//    if (IOS_7) {
//        [myTable setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
//    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    myTable.backgroundView = view;
    [view release];
    
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 45)];
    footView.backgroundColor = [UIColor clearColor];
    myTable.tableFooterView = footView;
    [footView release];
    myTable.tableHeaderView = [self creatHeaderView];
    
    UIButton * save;
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_getCheckUserBasicInfo",g_nowUserInfo.userid]] intValue]!=1 ) {
    
        save = [UIButton buttonWithType:UIButtonTypeCustom];
        save.frame = CGRectMake(15, 0, kDeviceWidth-30, 44);
        [save setTitle:@"订阅" forState:UIControlStateNormal];
        [save addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
        save.tag = 600;
        save.layer.cornerRadius = 4;
        save.clipsToBounds = YES;
        UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
        [save setBackgroundImage:image forState:UIControlStateNormal];
        [footView addSubview:save];
//    }
//    else {
//        
//        for (int i = 0; i<2; i++) {
//            save = [UIButton buttonWithType:UIButtonTypeCustom];
//            save.frame = CGRectMake(15+((kDeviceWidth-40)/2+10)*i, 0, (kDeviceWidth-40)/2, 45);
//            [save setTitle:i==0?@"订阅":@"跳过" forState:UIControlStateNormal];
//            [save addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
//            save.tag = 600+i;
//            save.layer.cornerRadius = 4;
//            save.clipsToBounds = YES;
//            UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
//            [save setBackgroundImage:image forState:UIControlStateNormal];
//            [footView addSubview:save];
//        }
//    }
}

- (UIView*)creatHeaderView
{
    UIView * headerView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 50)]autorelease];
    UILabel* lab = [Common createLabel:CGRectMake(15, 10, kDeviceWidth-30, headerView.height) TextColor:@"666666" Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft labTitle:[NSString stringWithFormat:@"完善以下信息,我们的营养师会为您推荐精准的膳食菜谱。"]];
    lab.numberOfLines = 0;
    [headerView addSubview:lab];
    return headerView;
}

- (void)save:(UIButton*)btn
{
    if (btn.tag == 601) {
        if (_isNew) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
        //吃什么
        CheckSugarViewController *calculator = [[CheckSugarViewController alloc] init];
        [self.navigationController pushViewController:calculator animated:YES];
        [calculator release];
        }
        return;
    }
    NSString * errStr = nil;
    if ([m_infoDic objectForKey:@"birthday"] == nil) {
        errStr = @"生日不能为空！";
    } else if ([m_infoDic objectForKey:@"hight"] == nil) {
        errStr = @"身高不能为空！";
    } else if ([m_infoDic objectForKey:@"weight"] == nil) {
        errStr = @"体重不能为空！";
    } else if ([m_infoDic objectForKey:@"type"] == nil) {
        errStr = @"劳动强度不能为空！";
    }
    if (errStr) {
        [Common createAlertViewWithString:errStr withDeleagte:nil];
        return;
    }
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:g_nowUserInfo.userid forKey:@"userId"];
    [dic setObject:[m_infoDic objectForKey:@"birthday"] forKey:@"birthday"];
    [dic setObject:[m_infoDic objectForKey:@"hight"] forKey:@"hight"];
    [dic setObject:[m_infoDic objectForKey:@"weight"] forKey:@"weight"];
    [dic setObject:[self tyepChangeWithType:[m_infoDic objectForKey:@"type"]] forKey:@"type"];
    
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:UPDATE_MYDATA values:dic requestKey:UPDATE_MYDATA delegate:self controller:self actiViewFlag:1 title:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellF = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellF];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellF] autorelease];
        cell.backgroundColor = [UIColor whiteColor];
        CGRect rect = cell.imageView.frame;
        rect.origin.x -= 10;
        cell.imageView.frame = rect;
        cell.imageView.contentMode = UIViewContentModeLeft;
        cell.textLabel.textColor = [CommonImage colorWithHexString:@"666666"];
        cell.detailTextLabel.textColor = [CommonImage colorWithHexString:@"666666"];
        
        //自定义右箭头
        cell.accessoryView = [CommonImage creatRightArrowX:cell.frame.size.width-22 Y:(cell.frame.size.height-12)/2 cell:cell];
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];
    }
    NSLog(@"%@", m_infoDic);
    NSDictionary* dic = dataArray[indexPath.row];
    NSLog(@"%@", dic);
    cell.textLabel.text = [dic objectForKey:@"title"];
    cell.detailTextLabel.text = [dic objectForKey:@"value"];

    if (indexPath.row == 0) {
        cell.detailTextLabel.text = [m_infoDic objectForKey:@"birthday"];
    } else if (indexPath.row == 1) {
        if ([m_infoDic objectForKey:@"hight"]) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@cm", [m_infoDic objectForKey:@"hight"]];
        }
    } else if (indexPath.row == 2) {
        if ([m_infoDic objectForKey:@"weight"]) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@kg", [m_infoDic objectForKey:@"weight"]];
        }
    } else if (indexPath.row == 3) {
        cell.detailTextLabel.text = [m_infoDic objectForKey:@"type"];
    }

    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self setTimePicker];
    } else {
        NSMutableDictionary* dic = dataArray[indexPath.row];
        [self setPickerWithType:dic[@"title"]];
    }
}

- (void)setPickerWithType:(NSString*)title
{
    //    NSString *title = [m_infoDic objectForKey:@"title"];
    NSMutableArray* fiisrtArray;
    NSString* defualt, *titl;
    if ([title isEqualToString:@"身高："]) {
        titl = @"请选择身高(cm)";
        fiisrtArray = [Common createArrayWithBeginInt:50 andWithOverInt:250 haveZero:YES];
        defualt = @"170";
    } else if ([title isEqualToString:@"体重："]) {
        titl = @"请选择体重(kg)";
        fiisrtArray = [Common createArrayWithBeginInt:20 andWithOverInt:200 haveZero:YES];
        defualt = @"65";
    } else if ([title isEqualToString:@"劳动强度"]) {
        titl = @"劳动强度";
        fiisrtArray = [NSMutableArray arrayWithObjects:@"轻体力(如计算机、绘画等工作)", @"中体力(如田径运动员、司机等工作)", @"重体力(如搬重物、挖矿等工作)", nil];
        defualt = m_infoDic[@"type"];
    }
    PickerView* myPicker = [[PickerView alloc] init];
    [myPicker createPickViewWithArray:[NSArray arrayWithObject:fiisrtArray] andWithSelectString:defualt setTitle:titl isShow:NO];
    [myPicker setPickerViewBlock:^(NSString* content) {
        if ([title isEqualToString:@"劳动强度"]) {
            [self setAddData:title data:[content substringToIndex:3]];
        }else{
        [self setAddData:title data:content];
        }
    }];
}

- (void)setTimePicker
{
    //时间日期选择器
    InputDueDatePicker* inputDueDateView = [[InputDueDatePicker alloc] initWithTitle:@"请选择出生年月日"];
    NSString *currentDateString = @"1975-06-15";
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-DD"];
    NSDate *currentDate = [dateFormater dateFromString:currentDateString];
    [dateFormater release];
    
    inputDueDateView.inputDueDatePicker.date = currentDate;
    [self.view addSubview:inputDueDateView];
    [inputDueDateView setInputDueDatePickerBlock:^(NSDate* date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString * datestr = [dateFormatter stringFromDate:date];
        [dateFormatter release];
        [self setAddData:@"生日：" data:datestr];
    }];
    [inputDueDateView release];
}

- (void)setAddData:(NSString*)title data:(NSString*)data
{
    int section;
    if ([title isEqualToString:@"生日："]) {
        [m_infoDic setObject:data forKey:@"birthday"];
        [m_infoDic setObject:data forKey:@"birthDay"];
        section = 0;
    } else if ([title isEqualToString:@"身高："]) {
        [m_infoDic setObject:data forKey:@"hight"];
        section = 1;
    } else if ([title isEqualToString:@"体重："]) {
        [m_infoDic setObject:data forKey:@"weight"];
        section = 2;
    } else if ([title isEqualToString:@"劳动强度"]) {
        [m_infoDic setObject:data forKey:@"type"];
        section = 3;
    }
    [myTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:section inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}

- (void)didFinishSuccess:(ASIHTTPRequest*)loader
{
    NSString* responseString = [loader responseString];
    NSDictionary* dict = [responseString KXjSONValueObject];
    if ([[dict objectForKey:@"state"] intValue] == 0) {
        if ([loader.username isEqualToString:UPDATE_MYDATA]) {
            //吃什么
            [[NSUserDefaults standardUserDefaults] setObject:m_infoDic[@"type"] forKey:[NSString stringWithFormat:@"%@_getCheckUsertype",g_nowUserInfo.userid]];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:[NSString stringWithFormat:@"%@_getCheckUserBasicInfo",g_nowUserInfo.userid]];
            [[NSUserDefaults standardUserDefaults] synchronize];

            g_nowUserInfo.weight = [m_infoDic[@"weight"] floatValue]; //体重 --- kg
            g_nowUserInfo.height = [m_infoDic[@"hight"] floatValue]; //体重 --- kg
            g_nowUserInfo.birthday = [Common isNULLString:m_infoDic[@"birthday"]];         //生日

            if (_isNew) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                //吃什么
                CheckSugarViewController *calculator = [[CheckSugarViewController alloc] init];
                [self.navigationController pushViewController:calculator animated:YES];
                [calculator release];
            }
        }else if ([loader.username isEqualToString:GET_PERSONAL_BASIC]) {
            NSDictionary *rs = [dict objectForKey:@"rs"];
            g_nowUserInfo.weight = [[rs objectForKey:@"weight"] floatValue]; //体重 --- kg
            g_nowUserInfo.height = [[rs objectForKey:@"hight"] floatValue]; //体重 --- kg
            g_nowUserInfo.birthday = [Common isNULLString:[rs objectForKey:@"birthday"]];         //生日
            if (rs[@"type"]) {
                NSString * num = [self NumberChangeWithType:rs[@"type"]];
                [m_infoDic setObject:num forKey:@"type"];
                [[NSUserDefaults standardUserDefaults] setObject:num forKey:[NSString stringWithFormat:@"%@_getCheckUsertype",g_nowUserInfo.userid]];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            [self createPerfectData];

        }
    }else{
        [Common TipDialog:[dict objectForKey:@"msg"]];
    }
}


- (NSString*)NumberChangeWithType:(NSString*)type
{
    NSString * tp =@"";
    if ([type isEqualToString:@"1"]) {
        tp = @"轻体力";
    }else if ([type isEqualToString:@"2"]) {
        tp = @"中体力";
        
    }else if ([type isEqualToString:@"3"]) {
        tp = @"重体力";
    }
    return tp;
}

- (NSString*)tyepChangeWithType:(NSString*)type
{
    NSString * tp =@"";
    if ([type isEqualToString:@"轻体力"]) {
        tp = @"1";
    }else if ([type isEqualToString:@"中体力"]) {
        tp = @"2";
        
    }else if ([type isEqualToString:@"重体力"]) {
        tp = @"3";
    }
    return tp;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
