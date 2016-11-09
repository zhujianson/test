//
//  CustomDiseaseViewController.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-22.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "CustomDiseaseViewController.h"

@interface CustomDiseaseViewController ()
{
    UITableView*myTable;
    NSString * m_str;
    int m_nowSelIndex;
    int fieldTag;
    UITextField * field;
}
@end

@implementation CustomDiseaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"自定义添加";
    }
    return self;
}

- (void)dealloc
{
    [myTable release];
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [field resignFirstResponder];
    if (_myDelegate && [_myDelegate respondsToSelector:@selector(transmissionCustomData:)]) {
        if (m_str) {
            [_myDelegate transmissionCustomData:m_str];
        }
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _type;
//    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 17;
    if (section == 0) {
        return 35;
    }
    if (_type == 1) {
        return 0.1;
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
    NSString* cellF = [NSString stringWithFormat:@"cell%ld", (long)indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellF];
    
    UILabel *labTitle;
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellF] autorelease];
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];

//
    }
    labTitle = [Common createLabel];
    labTitle.frame = CGRectMake(15, 0, 280, 44);
    labTitle.tag = 150;
    labTitle.textColor = [CommonImage colorWithHexString:@"333333"];
    labTitle.font = [UIFont systemFontOfSize:15];
    [cell addSubview:labTitle];
    [labTitle release];
    if (!indexPath.row) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        field = [[UITextField alloc]init];
        field.delegate = self;
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [field becomeFirstResponder];
        field.frame = CGRectMake(60, 0, kDeviceWidth-80, 44);
        field.tag = indexPath.section+100;
        [cell addSubview:field];
        [field release];
    }

    labTitle = (UILabel*)[cell viewWithTag:150];
    labTitle.text = [NSString stringWithFormat:@"疾病："];

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
//    [field resignFirstResponder];
////    //时间日期选择器
//    InputDueDatePicker*inputDueDateView = [[InputDueDatePicker alloc] initWithTitle:@"请选择确诊时间"];
//    [self.view addSubview:inputDueDateView];
//    [inputDueDateView setInputDueDatePickerBlock:^(NSDate *date) {
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString * datestr = [dateFormatter stringFromDate:date];
//    [dateFormatter release];
//    NSMutableDictionary *dic = [dataArray objectAtIndex:m_nowSelIndex];
//    [dic setObject:datestr forKey:@"date"];
//    [myTable reloadData];
//    }];
//    [inputDueDateView release];
//    m_nowSelIndex = (int)indexPath.section;
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    m_str = textField.text;
}

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
- (UIView*)addwithdrawFromAccount
{
    UIView* cleanView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)] autorelease];
    cleanView.backgroundColor = [UIColor clearColor];
    UIButton * withBtn =[UIButton buttonWithType:UIButtonTypeContactAdd];
    withBtn.frame = CGRectMake(280, 10, 30, 30);
    withBtn.layer.cornerRadius = 4;
    [withBtn addTarget:self action:@selector(addNewData) forControlEvents:UIControlEventTouchUpInside];
    [cleanView addSubview:withBtn];
    return cleanView;
}

- (void)addNewData
{
    [myTable reloadData];
//    m_nowSelIndex = [NSIndexPath indexPathForRow:0 inSection:dataArray.count-1];
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
