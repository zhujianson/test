//
//  ThinPersonalViewController.m
//  healthManagement1.0
//
//  Created by xjs on 16/6/3.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "ThinPersonalViewController.h"
#import "PerfectCell.h"
#import "PickerView.h"
#import "InputDueDatePicker.h"
#import "ThinViewController.h"

@interface ThinPersonalViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@end

@implementation ThinPersonalViewController
{
    NSMutableArray* dataArray;
    UITableView * m_myTable;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.log_pageID = 20;

    self.title = @"享瘦派";
    dataArray = [[NSMutableArray alloc] init];
    if (!g_nowUserInfo.m_sex) {
    [self getMyInfo];
    }else{
        [self createTableView];
    }

    // Do any additional setup after loading the view.
}


- (void)getMyInfo
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:URL_GETINFO values:dic requestKey:URL_GETINFO delegate:self controller:self actiViewFlag:1 title:nil];
}

- (void)createTitleView
{
    UILabel * lab = [Common createLabel:CGRectMake(15, 0, kDeviceWidth-30, 30) TextColor:@"999999" Font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentLeft labTitle:@"完善资料,定制精确享瘦方案"];
    [self.view addSubview:lab];
    
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
    PerfectCell* cell = [tableView dequeueReusableCellWithIdentifier:cellF];
    if (!cell) {
        cell = [[PerfectCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellF];
        cell.backgroundColor = [UIColor whiteColor];
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];
        
        [cell setP_block:^(NSDictionary *dic) {
            [self setDicWithDic:dic];
        }];
    }
    if (indexPath.row) {
        //自定义右箭头
        cell.accessoryView = [CommonImage creatRightArrowX:cell.frame.size.width-22 Y:(cell.frame.size.height-12)/2 cell:cell];
    }else{
        //自定义右箭头
        cell.accessoryView = nil;

    }
    NSDictionary* dic;
    dic = dataArray[indexPath.row];
    [cell setInfoWithDic:dic];
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==2 || indexPath.row == 3 || !indexPath.row) {
        return;
    }
    [self textResignFirst];
    
//    dic = m_infoDic;
    //    NSMutableDictionary * m_arrDic = arr[indexPath.section][indexPath.row];
    if (indexPath.row == 1) {
        [self setTimePickerWithString:dataArray[indexPath.row][@"value"] type:0 table:tableView];
        return;
    }
}

- (void)setTimePickerWithString:(NSString *)timeString type:(int)type table:(UITableView*)table
{
    if (!timeString.length)
    {
        timeString = @"1980-06-15";
    }
    //时间日期选择器
    InputDueDatePicker* inputDueDateView = [[InputDueDatePicker alloc] initWithTitle:@"请选择出生年月日"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* dateTime = [dateFormatter dateFromString:timeString];
    inputDueDateView.inputDueDatePicker.date = dateTime;
    
    [self.view addSubview:inputDueDateView];
    [inputDueDateView setInputDueDatePickerBlock:^(NSDate* date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString * datestr = [dateFormatter stringFromDate:date];
        NSMutableDictionary * dic = dataArray[1];
        [dic setObject:datestr forKey:@"value"];
        [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
    }];
}

- (void)textResignFirst
{
    UITableView * tab;
    tab = m_myTable;
    PerfectCell *cell = (PerfectCell*)[tab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [cell removeTextFirst];
    cell = (PerfectCell*)[tab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    [cell removeTextFirst];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    [m_infoDic setObject:textField.text forKey:@"nickName"];
}

- (UITextField*)createTextField:(NSString*)title
{
    UITextField* text = [[UITextField alloc] init];
    text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    text.contentMode = UIViewContentModeCenter;
    text.autocapitalizationType = UITextAutocapitalizationTypeNone;
    text.placeholder = title;
    text.returnKeyType = UIReturnKeyDone;
    
    //    text.clearButtonMode = YES;
    text.delegate = self;
    [text setTextColor:[CommonImage colorWithHexString:@"#666666"]];
    [text setFont:[UIFont systemFontOfSize:14]];
    return text;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self textResignFirst];
}

- (void)createButton
{
    UIImage* backImage =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:The_ThemeColor]];
    UIButton * determine = nil;
    determine = [UIButton buttonWithType:UIButtonTypeCustom];
    determine.frame = CGRectMake(0, kDeviceHeight-50, kDeviceWidth, 50);
    [determine addTarget:self action:@selector(withdraw) forControlEvents:UIControlEventTouchUpInside];
    [determine setTitle:@"提交" forState:UIControlStateNormal];
    [determine setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [determine setBackgroundImage:backImage forState:UIControlStateNormal];
    [self.view addSubview:determine];
    
}

- (void)withdraw
{
    for (int i = 0; i<dataArray.count; i++) {
        if (![dataArray[i][@"value"] length]) {
            [Common TipDialog2:@"请先完善未填写的资料"];
            return;
        }
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"" forKey:@"accountId"];
    [dic setObject:dataArray[0][@"value"] forKey:@"sex"];
    [dic setObject:dataArray[1][@"value"] forKey:@"birthday"];
    [dic setObject:dataArray[2][@"value"] forKey:@"height"];
    [dic setObject:dataArray[3][@"value"] forKey:@"weight"];

    [[CommonHttpRequest defaultInstance] sendNewPostRequest:URL_UPDATAINFO values:dic requestKey:URL_UPDATAINFO delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"加载中...", nil)];

}

- (void)didFinishSuccess:(ASIHTTPRequest*)loader
{
    NSString* responseString = [loader responseString];
    NSDictionary* dic = [responseString KXjSONValueObject];
    
    NSDictionary *head = dic[@"head"];
    if (![head[@"state"] intValue]) {
//        NSDictionary *body = dic[@"body"];
        if ([loader.username isEqualToString:URL_UPDATAINFO])
        {
            g_nowUserInfo.m_sex = dataArray[0][@"value"];
            g_nowUserInfo.m_birthday = dataArray[1][@"value"];
            g_nowUserInfo.m_height = [dataArray[2][@"value"] floatValue];
            g_nowUserInfo.m_weight = [dataArray[3][@"value"] floatValue];

            for (int i = 0; i<self.navigationController.viewControllers.count; i++) {
                if ([self.navigationController.viewControllers[i] isKindOfClass:[ThinViewController class]]) {
                    [self.navigationController popToViewController:self.navigationController.viewControllers[i] animated:YES];
                    return;
                }
            }
            ThinViewController * thin = [[ThinViewController alloc]init];
            [self.navigationController pushViewController:thin animated:YES];
        }else if ([loader.username isEqualToString:URL_GETINFO])
        {
            g_nowUserInfo.m_birthday = dic[@"body"][@"birthday"];
            g_nowUserInfo.m_sex = dic[@"body"][@"sex"];
            g_nowUserInfo.m_height = [dic[@"body"][@"height"] floatValue];
            g_nowUserInfo.m_weight = [dic[@"body"][@"weight"] floatValue];
            [self createTableView];
        }
    }
    else
    {
        [Common TipDialog2:head[@"msg"]];
    }
}


- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}

- (void)createTableView
{
    [dataArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"性别",@"title",g_nowUserInfo.m_sex,@"value", nil]];
    [dataArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"生日",@"title",g_nowUserInfo.m_birthday,@"value", nil]];
    [dataArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"身高",@"title",[NSString stringWithFormat:@"%g",g_nowUserInfo.m_height],@"value", nil]];
    [dataArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"当前体重",@"title",[NSString stringWithFormat:@"%g",g_nowUserInfo.m_weight],@"value", nil]];
    
    [self createTitleView];
    
    m_myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, kDeviceWidth, 50*4) style:UITableViewStylePlain];
    m_myTable.delegate = self;
    m_myTable.dataSource = self;
    m_myTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:m_myTable];
    m_myTable.rowHeight = 50;
    m_myTable.separatorColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
    [Common setExtraCellLineHidden:m_myTable];
    
    [self createButton];

}

- (void)setDicWithDic:(NSDictionary*)dic
{
    NSMutableDictionary * m_d;
    switch ([dic[@"tag"] intValue]) {
        case 0:
            m_d = dataArray[0];
            
            break;
        case 1:
            m_d = dataArray[2];

            break;
        case 2:
            m_d = dataArray[3];

            break;

        default:
            break;
    }
    [m_d setObject:dic[@"text"] forKey:@"value"];
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
