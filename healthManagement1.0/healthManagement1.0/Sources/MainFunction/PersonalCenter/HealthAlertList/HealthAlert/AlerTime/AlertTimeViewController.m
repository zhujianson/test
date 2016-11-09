//
//  AlertTimeViewController.m
//  jiuhaoHealth2.0
//
//  Created by yangshuo on 14-4-3.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import "AlertTimeViewController.h"
#import "NSDate+convenience.h"
#import "InputDueDatePicker.h"

@interface AlertTimeViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation AlertTimeViewController
{
     AlertTimeViewControllerBlock _inBlobk;
     UITableView * m_tableView;
     NSMutableArray *m_dataArray;
     int  currentIndex;//目前的时间
}

@synthesize defaultString;

- (id)initWithTimeString:(NSString *)timeString
{
    self = [super init];
    if (self)
    {
        m_dataArray = [[NSMutableArray alloc]init];
        // Custom initialization
        if (timeString.length)
        {
            [m_dataArray addObjectsFromArray:[timeString componentsSeparatedByString:@" | "]];
        }
        UIBarButtonItem* right =
        [Common createNavBarButton:self
                          setEvent:@selector(timeChoose)
                    withNormalImge:@"common.bundle/nav/newadd_btn_pre.png"
                  andHighlightImge:nil];

        self.navigationItem.rightBarButtonItem = right;
        self.title = NSLocalizedString(@"提醒时间",nil);
        if (!m_dataArray.count)
        {
             [self timeChoose];
        }
    }
    return self;
}

- (void)dealloc
{
    [m_dataArray release];
    [m_tableView release];
    [super dealloc];
}

-(void)timeChoose
{
    currentIndex = -1;
    [self changeTimeWithChooseString:@"06:00"];//默认
}

/**
 *  时间选择
 *
 *  @param currentString 目前的时间
 */
-(void)changeTimeWithChooseString:(NSString *)currentString
{
    InputDueDatePicker*inputDueDateView = [[InputDueDatePicker alloc] initWithTitle:@"请选择时间"];
    inputDueDateView.inputDueDatePicker.datePickerMode = UIDatePickerModeTime;
    
//  inputDueDateView.inputDueDatePicker.minuteInterval = 30;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *currentDate = [dateFormatter dateFromString:currentString];
    
    [dateFormatter release];
    
    inputDueDateView.inputDueDatePicker.date = currentDate;
//    NSString *minString = @"06:00";
//    NSDate *minDate = [dateFormatter dateFromString:minString];
//    NSString *maxString = @"23:30";
//    NSDate *maxDate = [dateFormatter dateFromString:maxString];
//    [dateFormatter release];
    
//    inputDueDateView.inputDueDatePicker.minimumDate = minDate;
//    inputDueDateView.inputDueDatePicker.maximumDate = maxDate;

    [self.view addSubview:inputDueDateView];
    [inputDueDateView setInputDueDatePickerBlock:^(NSDate *date) {
        NSString * content = [self timeStringFromDate:date];
        
         NSMutableArray *currentTimeArray = [m_dataArray mutableCopy];
        if (currentIndex >= 0)
        {
            [currentTimeArray removeObjectAtIndex:currentIndex];
        }
       
        if ([currentTimeArray containsObject:content])
        {
            [Common TipDialog:NSLocalizedString(@"提醒时间重复,请重新选择提醒时间!", nil)];
            [currentTimeArray release];
            return;
        }
        if (currentIndex == -1)//添加
        {
            [m_dataArray addObject:content];
        }
        else//修改
        {
            [m_dataArray replaceObjectAtIndex:currentIndex withObject:content];
        }
         [currentTimeArray release];
        [self updateDataArray];
       
    }];
    [inputDueDateView release];
    return;
}

#pragma mark 更新数据
-(void)updateDataArray
{
    if (m_dataArray.count >8 )
    {
        [Common TipDialog:NSLocalizedString(@"最多添加八个提醒时间!", nil)];
        return;
    }
     NSString *content = [m_dataArray componentsJoinedByString:@" | "];
     _inBlobk(content);
     [m_tableView reloadData];
}

- (NSString *)timeStringFromDate:(NSDate *)timeDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:(@"HH:mm")];
    NSString *timeString = [formatter stringFromDate:timeDate];
    [formatter release];
    return timeString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self createTableView];
}

-(void)createTableView
{
    m_tableView = [[UITableView alloc]
                   initWithFrame:CGRectMake(0, 35, kDeviceWidth, kDeviceHeight-35)
                   style:UITableViewStylePlain];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
//    m_tableView.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR2];
    m_tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:m_tableView];
    m_tableView.rowHeight = 44;
    [Common setExtraCellLineHidden:m_tableView];
    m_tableView.separatorColor = [CommonImage colorWithHexString:@"e5e5e5"];
    if ([m_tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [m_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    m_tableView.backgroundView = view;
    [view release];

}

//- (void)createSaveBtn
//{
//    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
//    but.frame = CGRectMake(0, 0, 31, 44);
//    [but addTarget:self action:@selector(butEventSave) forControlEvents:UIControlEventTouchUpInside];
//    [but setImage:[UIImage imageNamed:@"common.bundle/nav/data_save.png"] forState:UIControlStateNormal];
//    [but setImage:[UIImage imageNamed:@"common.bundle/nav/data_save_p.png"] forState:UIControlStateHighlighted];
//    UIBarButtonItem *saveBar = [[UIBarButtonItem alloc] initWithCustomView:but];
//    self.navigationItem.rightBarButtonItem = saveBar;
//    [saveBar release];
//}

//存储
//-(void)butEventSave
//{
//    if (![dict objectForKey:@"time"])
//    {
//        if (!datePickerType)
//        {
//            [dict setObject:[[NSDate date] offsetDay:1] forKey:@"time"];
//        }
//        else
//        {
//            [self dateChanged:m_datePicker];
////            [dict setObject:[self getCurrentTime] forKey:@"time"];
//        }
//    }
//     _inBlobk(dict);
//    [self.navigationController popViewControllerAnimated:YES];
//}
//时间去 00 30
-(NSDate *)getCurrentTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"HH:mm"];
    NSDate *date = [NSDate date];
    NSString *locString = [dateFormatter  stringFromDate:date];
    NSString *miniString = [locString substringFromIndex:2].intValue <30? [NSString stringWithFormat:@"%d",00]:[NSString stringWithFormat:@"%d",30];
    locString = [NSString stringWithFormat:@"%@%@",[locString substringToIndex:3],miniString];
    
    date = [dateFormatter dateFromString:locString];
    [dateFormatter release];
    return date;
}

-(void)setAlertTimeViewControllerBlock:(AlertTimeViewControllerBlock)_handler
{
    _inBlobk = [_handler copy];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)createDatePicker
//{
//    m_datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 35, 320, 200)];
//    m_datePicker.backgroundColor = [CommonImage colorWithHexString:@"#ffffff"];
//    if ([datePickerType isEqualToString:@"time"])
//    {
//        m_datePicker.datePickerMode = UIDatePickerModeTime;
//        m_datePicker.minuteInterval = 30;
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"HH:mm"];
//        NSString *currentString = @"06:00";
//        NSDate *currentDate = [dateFormatter dateFromString:currentString];
//        
//        m_datePicker.date = currentDate;
//        NSString *minString = @"06:00";
//         NSDate *minDate = [dateFormatter dateFromString:minString];
//        NSString *maxString = @"23:30";
//        NSDate *maxDate = [dateFormatter dateFromString:maxString];
//        [dateFormatter release];
//        
//        
//        m_datePicker.minimumDate = minDate;
//        m_datePicker.maximumDate = maxDate;
//
//    }
//    else
//    {
//         m_datePicker.datePickerMode = UIDatePickerModeDate;
//        if (defaultString.length > 0 )
//        {
//            m_datePicker.date = [self formatTimeString:defaultString];
//        }
//         m_datePicker.minimumDate = [[NSDate date] offsetDay:1];
//    }
//    [m_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:m_datePicker];
//    
//}

-(NSDate *)formatTimeString:(NSString *)timeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [dateFormatter dateFromString:timeString];
    [dateFormatter release];
    return date;
}

//-(void)dateChanged:(id)sender
//{
//    UIDatePicker* control = (UIDatePicker*)sender;
//    NSDate* date = control.date;
//    NSLog(@"%@",date);
//    [dict setObject:date forKey:@"time"];
//}


#pragma mark tablevIew

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView
heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_dataArray count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* indentifier = @"Cell";
    UITableViewCell* cell = (UITableViewCell*)
    [tableView dequeueReusableCellWithIdentifier:indentifier];
    UIButton* btn;
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:indentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        cell.contentView.backgroundColor = [UIColor clearColor];
         btn.frame = CGRectMake(kDeviceWidth-60, 0, 60, 44);
        btn.tag = 10000;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btn addTarget:self action:@selector(deleteBUtton:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"common.bundle/alert/center_btn_cancel_normal.png"] forState:UIControlStateNormal];
        [cell.contentView addSubview:btn];
        
        UILabel *titleLabel = [Common createLabel:CGRectMake(15, 0, 200, 44) TextColor:@"666666" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft labTitle:nil];
        titleLabel.tag = 10001;
        [cell.contentView addSubview:titleLabel];
        
        //cell点击背景颜色
        cell.selectedBackgroundView = [Common creatCellBackView];

        
    }
    if (indexPath.row < [m_dataArray count])
    {
         UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:10001];
         titleLabel.text = m_dataArray[indexPath.row];
     }
    return cell;
}

-(void)deleteBUtton:(UIButton *)btn
{
    CGPoint p = [btn.superview convertPoint:btn.frame.origin toView:m_tableView];
    NSIndexPath *indexPath = [m_tableView indexPathForRowAtPoint:p];
    [m_dataArray removeObjectAtIndex:indexPath.row];
    [self updateDataArray];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString *currentString = m_dataArray[indexPath.row];
    currentIndex = (int)indexPath.row;
    [self changeTimeWithChooseString:currentString];
}

@end
