//
//  MedicalHistoryViewController.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-14.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "MedicalHistoryViewController.h"
#import "PickerView.h"
//#import "JSON.h"
#import "CommonHttpRequest.h"
#import "MedicalHistoryTableViewCell.h"
#import "NSObject+KXJson.h"

@interface MedicalHistoryViewController () <MedicalCellDelegate>
{
//    int pickerTemp;
    BOOL _isEditor;//判断是否修改过信息
    BOOL _isAdd;//判断是否修改过信息

}
@end

@implementation MedicalHistoryViewController
@synthesize m_infoDic;
@synthesize m_strUrl;
@synthesize m_Dic;
@synthesize m_isAdd;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"既往病史";
        self.log_pageID = 90;
        NSString *pathname = [[NSBundle mainBundle]  pathForResource:@"keyValue" ofType:@"txt" inDirectory:@"/"];
        NSString *str = [NSString stringWithContentsOfFile:pathname encoding:NSUTF8StringEncoding error:nil];
        m_dicKeyValue = [[NSDictionary alloc] initWithDictionary:[str KXjSONValueObject][2]];

        UIBarButtonItem *rightButtonItem = [Common createNavBarButton:self setEvent:@selector(addNewData) withNormalImge:@"common.bundle/nav/newadd_btn_pre.png" andHighlightImge:nil];
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    return self;
}

- (void)dealloc
{
    [myTable release];
    [diseaseNameArr release];
    [dataArray release];
    [self release];
    [super dealloc];
}

- (BOOL)closeNowView
{
    [super closeNowView];
    
    //FH00002|2012-8-9,FH00002|2013-08-08,definde自定义病|2013-08-08
    if ([dataArray.lastObject[@"title"] length]<1 | [dataArray.lastObject[@"date"] length]<1 ) {
        [dataArray removeLastObject];
    }
    if ([dataArray count]<1 && !_isEditor) {
        return YES;
    }
    
    if (dataArray.count) {
        if (!_isAdd) {
            return YES;
        }
        if ([dataArray count]>0 &&![dataArray lastObject][@"title"] |![dataArray lastObject][@"date"] ) {
            [dataArray removeLastObject];
        }
        NSString *str1 = [NSString string], *str2 = [NSString string];
        for (NSDictionary *dic in dataArray) {
            str1 = [str1 stringByAppendingFormat:@"%@,", [dic objectForKey:@"title"]];
            str2 = [str2 stringByAppendingFormat:@"%@|%@,", [dic objectForKey:@"key"], [dic objectForKey:@"date"]];
        }
        if([[str1 substringFromIndex:[str1 length]-1] isEqualToString:@","])
        {
            str1 = [str1 substringToIndex:[str1 length]-1];
        }
        [m_infoDic setObject:str1 forKey:@"value"];
        [m_infoDic setObject:str2 forKey:@"value2"];
        [m_Dic setObject:str2 forKey:@"history"];
        if (!m_isAdd) {
            [self loadDataBegin:YES];
        }
    }else{
        [m_infoDic removeObjectForKey:@"value"];
        [m_infoDic removeObjectForKey:@"value2"];
        [m_Dic removeObjectForKey:@"history"];
        if (!m_isAdd) {
            [self loadDataBegin:NO];
        }

    }

    return YES;
}

- (void)loadDataBegin:(BOOL)isNo
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:g_nowUserInfo.userid forKey:@"userId"];
    NSString *familyId = [m_infoDic objectForKey:@"familyId"];
    if (familyId) {
        [dic setObject:[m_infoDic objectForKey:@"familyId"] forKey:@"familyId"];
    }
    if (isNo) {
        [dic setObject:[m_infoDic objectForKey:@"value2"] forKey:@"jwbs"];
    }
    else {
        [dic setObject:@"" forKey:@"jwbs"];
    }
    NSLog(@"%@---%@",m_infoDic,m_strUrl);
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:m_strUrl values:dic requestKey:m_strUrl delegate:self controller:self actiViewFlag:0 title:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isEditor = NO;
    
    diseaseNameArr = [[NSMutableArray alloc] initWithArray:[m_dicKeyValue allValues]];
    NSLog(@"%@",diseaseNameArr);
    dataArray = [[NSMutableArray alloc] init];
    //FH00002|2012-8-9,FH00002|2013-08-08,definde自定义病|2013-08-08
    NSString *stt = [m_infoDic objectForKey:@"value2"];
    if (stt.length) {
        NSArray *array = [stt componentsSeparatedByString:@","];
        
        NSMutableDictionary *dic;
        for (NSString *str in array) {
            if (!str.length) {
                continue;
            }
            dic = [NSMutableDictionary dictionary];
            
            NSArray *array1 = [str componentsSeparatedByString:@"|"];
            
            NSString *str1 = [array1 objectAtIndex:0];
            
            NSRange ran = [str1 rangeOfString:@"definde"];
            if (ran.length) {
                NSString *str3 = [str1 substringFromIndex:ran.length];
                [dic setObject:str3 forKey:@"title"];
                [dic setObject:str1 forKey:@"key"];
            }else {
                [dic setObject:[m_dicKeyValue objectForKey:[array1 objectAtIndex:0]] forKey:@"title"];
                [dic setObject:[array1 objectAtIndex:0] forKey:@"key"];
            }
            [dic setObject:[array1 objectAtIndex:1] forKey:@"date"];
            
            [dataArray addObject:dic];
//            NSArray *array1 = [str componentsSeparatedByString:@"|"];
//            
//            [dic setObject:[m_dicKeyValue objectForKey:[array1 objectAtIndex:0]] forKey:@"title"];
//            [dic setObject:[m_dicKeyValue objectForKey:[array1 objectAtIndex:1]] forKey:@"date"];
//            [dic setObject:[array1 objectAtIndex:0] forKey:@"key"];
//            
//            [dataArray addObject:dic];
        }
    }
    
    myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStyleGrouped];
    myTable.delegate = self;
    myTable.dataSource = self;
    [Common setExtraCellLineHidden:myTable];
    myTable.separatorColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
    myTable.backgroundColor = [UIColor clearColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    myTable.backgroundView = view;
    [view release];
    [self.view addSubview:myTable];
//    myTable.tableFooterView = [self addwithdrawFromAccount];
    
    // Do any additional setup after loading the view.
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 90;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return [dataArray count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 17;
    if (section == 0) {
        height = 35;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    float height = 0.1;

	return height;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *type = @"cell";
    MedicalHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:type];
    
    if (!cell) {
        cell = [[[MedicalHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:type] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    NSMutableDictionary *dic = [dataArray objectAtIndex:indexPath.section];
    [cell setM_dicInfo:dic];

    return cell;
}

- (void)butEventName:(NSMutableDictionary*)dic
{
    //疾病列表选择器
//    pickerTemp = m_nowSelIndex.section;

    _isAdd = YES;

    PickerView *myPicker = [[PickerView alloc] init];
    NSString* strTitle = [diseaseNameArr objectAtIndex:0];
    if (dic.count) {
        strTitle = [dic objectForKey:@"title"];
    }
    [myPicker createPickViewWithArray:[NSArray arrayWithObject:diseaseNameArr] andWithSelectString:strTitle setTitle:@"自定义添加" isShow:NO];
    [myPicker setPickerViewBlock:^(NSString *content) {
        if ([content isEqualToString:@"new"]) {
            m_selDic = dic;
            CustomDiseaseViewController * custom = [[CustomDiseaseViewController alloc] init];
            custom.log_pageID = 91;
            custom.myDelegate = self;
            custom.type = 2;
            [self.navigationController pushViewController:custom animated:YES];
            [custom release];
            return;
        }
        [dic setObject:content forKey:@"title"];
        int i = 0;
        for (NSString *dd in [m_dicKeyValue allValues]) {
            if ([dd isEqualToString:content]) {
                
                [dic setObject:[[m_dicKeyValue allKeys] objectAtIndex:i] forKey:@"key"];
                NSLog(@"[[m_dicKeyValue allKeys] objectAtIndex:i]");
//                [self creatTimePicker];
                [self butEventTime:dic];
                break;
            }
            i++;
        }
        int index = (int)[dataArray indexOfObject:dic];
        [myTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:index]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)butEventTime:(NSMutableDictionary*)dic
{
    //时间日期选择器
    _isAdd = YES;

    InputDueDatePicker*inputDueDateView = [[InputDueDatePicker alloc] initWithTitle:@"请选择确诊时间"];
    [self.view addSubview:inputDueDateView];
    [inputDueDateView setInputDueDatePickerBlock:^(NSDate *date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString * datestr = [dateFormatter stringFromDate:date];
        [dateFormatter release];
        [dic setObject:datestr forKey:@"date"];
//        int index = [dataArray indexOfObject:dic];
//        [myTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:index]] withRowAnimation:UITableViewRowAnimationNone];
        [myTable reloadData];
    }];
    [inputDueDateView release];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    MedicalHistoryTableViewCell *cell = (MedicalHistoryTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
////    cell.contentView.userInteractionEnabled = NO;
//    
//    [cell setButEvent];
//    if (cell.editing) {
////        cell.contentView.userInteractionEnabled = YES;
//        cell.isEdit = YES;
//    }

    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [dataArray removeObjectAtIndex:indexPath.section];
        // Delete the row from the data source.
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSIndexSet * set = [NSIndexSet indexSetWithIndex:indexPath.section];
        
        [tableView deleteSections:set withRowAnimation:UITableViewRowAnimationFade];
        _isEditor = YES;
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

//- (void)

/**
 *  section背景
 *
 *  @param tableView mytable
 *  @param section   section
 *
 *  @return section背景
 */
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* cleanView = [[[UIView alloc] init] autorelease];
    cleanView.backgroundColor = [UIColor clearColor];
    return cleanView;
}

/**
 *  添加新的病例
 *
 *  @return
 */
//- (UIView*)addwithdrawFromAccount
//{
//    UIView* cleanView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
//    cleanView.backgroundColor = [UIColor clearColor];
//    UIButton * withBtn =[UIButton buttonWithType:UIButtonTypeContactAdd];
//    withBtn.frame = CGRectMake(280, 10, 30, 30);
//    withBtn.layer.cornerRadius = 4;
//    [withBtn addTarget:self action:@selector(addNewData) forControlEvents:UIControlEventTouchUpInside];
//    [cleanView addSubview:withBtn];
//    return cleanView;
//}

- (void)addNewData
{
    NSLog(@"%@",dataArray);
    if ([dataArray count]>0 &&![dataArray lastObject][@"title"] |![dataArray lastObject][@"date"] ) {
//        [Common TipDialog2:@"请填写既往病史"];
        
        return;
    }
    _isAdd = YES;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dataArray addObject:dic];
    [myTable setContentOffset:CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX)];//移动到底部
    [myTable reloadData];

    [self butEventName:dic];
}

- (void)transmissionCustomData:(NSArray*)arr
{
//    [dataArray removeLastObject];
    NSString *title, *date;
    for (int i=0; i<1; i++) {
        NSMutableDictionary * dic = [arr objectAtIndex:i];
        title = dic[@"title"];
        date = dic[@"date"];
        if ([title length] > 0 && [date length] > 0) {
            [m_selDic setObject:[NSString stringWithFormat:@"definde%@", title] forKey:@"key"];
            [m_selDic setObject:title forKey:@"title"];
            [m_selDic setObject:date forKey:@"date"];
//            [dataArray addObject:dic];
        }
    }
    [myTable reloadData];

    NSLog(@"%@",dataArray);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NetWork Function

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    if (![[dic objectForKey:@"state"] intValue])
    {
        if([loader.username isEqualToString:m_strUrl]){
            
            MBProgressHUD *progress_ = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.view.frame.size.height)];
            progress_.labelText = @"修改成功";
            progress_.mode = MBProgressHUDModeText;
            progress_.userInteractionEnabled = NO;
            [[[UIApplication sharedApplication].windows lastObject] addSubview:progress_];
            [progress_ show:YES];
            [progress_ showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [progress_ release];
                [progress_ removeFromSuperview];
            }];
        }
    }
    else {
        [Common TipDialog:[dic objectForKey:@"msg"]];
    }
}

@end
