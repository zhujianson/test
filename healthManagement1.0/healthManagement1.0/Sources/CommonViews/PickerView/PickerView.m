//
//  PickerView.m
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-8-13.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "PickerView.h"

#define PICK_HEIGHT 30

@implementation PickerView
{
    BOOL isPick;
    NSString * titleStr;
}
@synthesize m_pickerView;

- (void)createPickViewWithArray:(NSArray*)array andWithSelectString:(NSString*)selectString setTitle:(NSString*)title isShow:(BOOL)isLine
{
    m_defalutArray = [array retain];
    titleStr = title;
    m_view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    m_view.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidder:)];
    [m_view addGestureRecognizer:tap];
    [tap release];

    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.tag = 789;
    [m_view addSubview:view];
    [view release];

    UIView* topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 35)];
    topView.backgroundColor = [CommonImage colorWithHexString:COLOR_FF5351];
    topView.tag = 88;
	topView.userInteractionEnabled = YES;
    //    [m_view addSubview:topView];
    [view addSubview:topView];
    [topView release];

    UIButton* but = [[UIButton alloc] initWithFrame:CGRectMake(topView.width - 55, 0, 60, topView.height)];
    [but setTitle:@"确定" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:17];
    [but addTarget:self action:@selector(hiddl) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:but];
    [but release];

    CGFloat weight = [Common unicodeLengthOfString:title];
    UIButton* custom = [UIButton buttonWithType:UIButtonTypeCustom];
    custom.frame = CGRectMake(5, 0, weight*17/2+5, topView.height);
    [custom setTitle:title forState:UIControlStateNormal];
    [custom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [custom addTarget:self action:@selector(custom) forControlEvents:UIControlEventTouchUpInside];
//    custom.titleEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 0);
    custom.titleLabel.font = [UIFont systemFontOfSize:17];
    [topView addSubview:custom];
    if (![title isEqualToString:@"自定义添加"]) {
        custom.userInteractionEnabled = NO;
    }
    if ([title isEqualToString:@"选择绑定家人"]) {
        isPick = YES;
    }
    custom.tag = 89;
    m_pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, topView.bottom, topView.width, kDeviceHeight/3)];
    m_pickerView.delegate = self;
    
    m_pickerView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    m_pickerView.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR];
    m_pickerView.dataSource = self;
    m_pickerView.showsSelectionIndicator = YES;
    [view addSubview:m_pickerView];
    view.frame = CGRectMake(0, m_view.height+10, topView.width, m_pickerView.bottom);
    [self selectRowInOneComponentWithString:selectString];
    [APP_DELEGATE addSubview:m_view];
    [UIView animateWithDuration:0.3 animations:^{
        m_view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        view.transform = CGAffineTransformMakeTranslation(0, -view.height-10);
    }];
    
    if (isLine) {
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth/2-5, self.m_pickerView.height/2-5, 10, 10)];
        lab1.backgroundColor = [UIColor clearColor];
        lab1.text = @"-";
        lab1.textColor = [CommonImage colorWithHexString:COLOR_FF5351];
        [self.m_pickerView addSubview:lab1];
        [lab1 release];
    }
}

- (void)custom
{
    picBlock(@"new");
    [m_view removeFromSuperview];
    [self release];
}

- (void)setM_row:(NSInteger)m_row
{
    [m_pickerView selectRow:m_row inComponent:0 animated:NO];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return PICK_HEIGHT;
}

//默认选中
- (void)selectRowInOneComponentWithString:(NSString*)selectString
{
    if (!selectString)
    {
        return;
    }
    NSArray* array = [selectString componentsSeparatedByString:@"."];
    for (int i = 0; i < m_defalutArray.count; i++) {
        NSArray* array1 = [m_defalutArray objectAtIndex:i];
        for (int j = 0; j < array1.count; j++) {
            NSString* targetString = [array1 objectAtIndex:j];
            if (i<array.count) {
                if ([targetString isEqualToString:[array objectAtIndex:i]]) {
                    [m_pickerView selectRow:j inComponent:i animated:NO];
                    break;
                }
            }
        }
    }
}

- (void)setPickerViewBlock:(PickerViewBlock)back
{
    picBlock = [back copy];
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    int numComponents = 0;
    for (NSArray* subArray in m_defalutArray) {
        if (subArray.count) {
            numComponents++;
        }
    }
    //    return [m_defalutArray count];
    return numComponents;
}

//- (UIView* )pickerView:(UIPickerView*)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView*)view
//{
//    UILabel* pickerLabel = (UILabel*)view;
//    if (!pickerLabel) {
//        pickerLabel = [[[UILabel alloc] init] autorelease];
//        pickerLabel.minimumScaleFactor = 5.;
//        pickerLabel.adjustsFontSizeToFitWidth = YES;
//        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
//        [pickerLabel setBackgroundColor:[UIColor clearColor]];
//        pickerLabel.textColor = [CommonImage colorWithHexString:@"#666666"];
//        [pickerLabel setFont:[UIFont systemFontOfSize:20]];
//    }
//    pickerLabel.text = [[m_defalutArray objectAtIndex:component] objectAtIndex:row];
//    
//    return pickerLabel;
//}

- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%@--%ld--%ld", m_defalutArray,(long)row,(long)component);
    if ([titleStr isEqualToString:@"糖化血红蛋白"]) {
        int f = [[self returnMyNum] intValue];
        [m_defalutArray release];
        NSArray * arr;
        if (f != 10) {
            arr = [NSArray arrayWithObjects:@[@"5",@"6",@"7",@"8",@"9",@"10"],@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"], nil];
        }else{
            arr = [NSArray arrayWithObjects:@[@"5",@"6",@"7",@"8",@"9",@"10"],@[@"0"], nil];
        }
        m_defalutArray = [arr retain];
        [m_pickerView reloadAllComponents];
    }
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[m_defalutArray objectAtIndex:component] count];
}

#pragma mark UIPickerViewDelegate
//
- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[m_defalutArray objectAtIndex:component] objectAtIndex:row];
}

//发送通知
- (void)headerbtn //:(UIButton *)btn
{
    NSString* contnet = @"", *str;
    int row = 0;
    NSArray* array;
    for (int i = 0; i < [m_defalutArray count]; i++) {
        if ([m_defalutArray[i] count]) {
            row = (int)[m_pickerView selectedRowInComponent:i];
            array = [m_defalutArray objectAtIndex:i];
            str = [array objectAtIndex:row];
            //        尺寸转化
            if ([str rangeOfString:@"尺"].location != NSNotFound) {
                str = [[str componentsSeparatedByString:@"  "] firstObject];
            }
            contnet = [contnet stringByAppendingFormat:@"%@.", str];
        }
    }

    contnet = [contnet substringToIndex:contnet.length - 1];
    if (isPick) {
        picBlock([NSString stringWithFormat:@"%d",row]);
        return;
    }
    picBlock(contnet);
}

- (NSString*)returnMyNum
{
    NSString* contnet = @"", *str;
    int row = 0;
    NSArray* array;
    for (int i = 0; i < [m_defalutArray count]; i++) {
        if ([m_defalutArray[i] count]) {
            row = (int)[m_pickerView selectedRowInComponent:i];
            array = [m_defalutArray objectAtIndex:i];
            str = [array objectAtIndex:row];
            //        尺寸转化
            if ([str rangeOfString:@"尺"].location != NSNotFound) {
                str = [[str componentsSeparatedByString:@"  "] firstObject];
            }
            contnet = [contnet stringByAppendingFormat:@"%@.", str];
        }
    }
    
    contnet = [contnet substringToIndex:contnet.length - 1];
    return contnet;
    
}

- (void)hidder:(UITapGestureRecognizer*)view
{
    [UIView animateWithDuration:0.3 animations:^{
        UIView *view = [m_view viewWithTag:789];
        m_view.backgroundColor = [UIColor clearColor];
        view.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL f) {
        [m_view removeFromSuperview];
        [self release];
    }];

}

- (void)hiddl
{
    [self headerbtn];
    [self hidder:nil];
}

- (void)dealloc
{
    [m_view release];
    [m_pickerView release];
    [m_defalutArray release];

    if (picBlock) {
        [picBlock release];
    }

    [super dealloc];
}

@end
