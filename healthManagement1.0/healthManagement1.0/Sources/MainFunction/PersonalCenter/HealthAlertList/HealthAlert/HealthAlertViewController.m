//
//  HealthAlertViewController.m
//  jiuhaoHealth2.0
//
//  Created by yangshuo on 14-4-2.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import "HealthAlertViewController.h"
#import "CommonHttpRequest.h"
#import "HealthWeekCycleViewController.h"
#import "AlertTimeViewController.h"
#import "NSDate+convenience.h"
#import "DBOperate.h"
#import "HealthAlerNameVCViewController.h"
#import "SoundList/SoundListViewController.h"
#import "HealthAlert.h"

#import "HealthAlertListTableViewController.h"
#import "AlertManager.h"

@class HealthAlertViewController;

#define  VIEWFRONTSIZE 16
#define  VIEWCONTENTFRONTSIZE 15
#define  CELLHEIGHT 50
#define  CONTENTTAG 222222

@interface HealthAlertViewController ()<UIAlertViewDelegate>

@end

@implementation HealthAlertViewController
{
    NSArray *m_leftData;
    NSMutableArray *m_rightData;
    BOOL _isUpdate;
    BOOL _isFirstChange;
    
    NSDictionary *m_dict;
    UISwitch *m_switch;
    
    UILabel *contentHeader;
    UILabel *timeLabel;
    UILabel *repeatLabel;
    UILabel *soundLabel;
    
    NSString *alertTag;
}

- (id)initWithUpdate:(BOOL)update andWithAlertID:(NSDictionary *)remind
{
    self = [super init];
    if (self)
    {
        // Custom initialization
        _isUpdate = update;
        m_dict = [remind retain];
        
        m_rightData = [[NSMutableArray alloc] init];
        if (_isUpdate)
        {
            [self loadDataAlertById];
        }
        else
        {
            [m_rightData addObject:NSLocalizedString(@"", nil)];
            [m_rightData addObject:NSLocalizedString(@"", nil)];
            [m_rightData addObject:@"永不"];
            [m_rightData addObject:@"声音1"];
            [m_rightData addObject:@"Y"];
        }
        self.title = NSLocalizedString(@"提醒设置", nil);
        m_leftData = [[NSArray alloc]initWithObjects:NSLocalizedString(@"提醒内容", nil), NSLocalizedString(@"提醒时间", nil), NSLocalizedString(@"重复",nil),@"提示音",@"振动", nil];
        _isFirstChange = YES;
        
//        UIBarButtonItem *left = [Common createNavBarButton:self setEvent:@selector(loadDataBegin) withNormalImge:@"common.bundle/nav/data_save.png" andHighlightImge:@"common.bundle/nav/data_save_p.png"];
//        self.navigationItem.rightBarButtonItem = left;

        
    }
    return self;
}

- (void)dealloc
{
    [m_switch release];
    [m_leftData release];
    [m_rightData release];
    m_dict  = nil;
    [super dealloc];
}

//把000 转为周几
-(NSString *)convertFrequencyWithDictionnary:(NSDictionary *)dict
{
    if ([dict[@"frequency"] isEqualToString:REPEARTTEXT] )
    {
        return @"永不";
    }
    NSArray *array = [[dict objectForKey:@"frequency"] componentsSeparatedByString:@","];
    NSArray *weekArray = [[NSArray alloc] initWithObjects:NSLocalizedString(@"每天", nil),NSLocalizedString(@"周一", nil),NSLocalizedString(@"周二", nil),NSLocalizedString(@"周三", nil),NSLocalizedString(@"周四", nil),NSLocalizedString(@"周五", nil),NSLocalizedString(@"周六", nil),NSLocalizedString(@"周日", nil), nil];
    NSString *returnStr = nil;
    for (NSString *str in array)
    {
        if (!returnStr)
        {
            returnStr = [weekArray objectAtIndex:str.intValue];
        }
        else
        {
            returnStr  = [NSString stringWithFormat:@"%@  %@",returnStr,[weekArray objectAtIndex:str.intValue]];
        }
    }
    [weekArray release];
    return returnStr;
}

//添加或者修改
- (void)loadDataBegin
{
    NSString *contentString = [contentHeader.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (contentString.length == 0 || !contentHeader.text)
    {
        [Common TipDialog:NSLocalizedString(@"提醒内容不能为空", nil)];
        ((UIButton *)[self.view viewWithTag:1]).enabled = YES;
        return;
    }
    else
    {
        ((UIButton *)[self.view viewWithTag:1]).enabled = YES;
        if([Common stringContainsEmoji:contentString])
        {
            [Common TipDialog:NSLocalizedString(@"暂不支持表情信息", nil)];
            return;
        }
    }
    if (![m_rightData[1] length])
    {
         [Common TipDialog:NSLocalizedString(@"提醒时间不能为空", nil)];
         return;
    }
    if (![m_rightData[2] length])
    {
        [m_rightData replaceObjectAtIndex:2 withObject:@"永不"];
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[self covertWeekNameToNumber:m_rightData[2]] forKey:@"frequency"];//频率,
    if ([[m_rightData objectAtIndex:1] containsString:@"|"])
    {
          [dic setObject:[[m_rightData objectAtIndex:1] stringByReplacingOccurrencesOfString:@" | " withString:@","] forKey:@"sendtime"];
    }
    else
        [dic setObject:[[m_rightData objectAtIndex:1] stringByReplacingOccurrencesOfString:@";" withString:@","] forKey:@"sendtime"] ;//时间用分号隔开
    [dic setObject:g_nowUserInfo.userid forKey:@"userid"];//用户编号
    
    [dic setObject:m_rightData[0] forKey:@"med_name"];
    [dic setObject:m_rightData[4] forKey:@"isShake"];
    [dic setObject:[self convertStringWithIndexString:m_rightData[3] isEnglish:YES] forKey:@"soundName"];
    NSString * updateTime = [CommonDate formatCreatetTimeTwo:[NSDate new]];
    [dic setObject:updateTime forKey:@"updateTime"];
    if ([m_rightData[2] isEqualToString:@"永不"])//简单替换
    {
        [m_rightData replaceObjectAtIndex:2 withObject: REPEARTTEXT];
        [dic setObject:REPEARTTEXT forKey:@"frequency"];
    }
  
    if (_isUpdate)
    {
        [dic setObject:m_dict[@"use_yn"] forKey:@"use_yn"];
        [dic setObject:[m_dict objectForKey:@"id"] forKey:@"id"];
        [dic setObject:m_dict[@"repeatFlag"] forKey:@"repeatFlag"];
        [[DBOperate shareInstance] upadteMyAlertFromDBByAlertId:dic];
    }
    else
    {
         [dic setObject:@"Y" forKey:@"use_yn"];
//         [dic setObject:[self createCodeStringWithDateString:[self getCurrentTime]] forKey:@"id"];
         [dic setObject:[AlertManager createAlertIdWithDateString:[self getCurrentTime] withUserId:g_nowUserInfo.userid withCurrunteMainId:g_nowUserInfo.userid] forKey:@"id"];
         if (alertTag.length)
         {
            [dic setObject:alertTag forKey:@"alertTag"];
         }
         [[DBOperate shareInstance] insertMyAlertToDBWithData:dic];
        //触发通知 生成的页面.
    }
    
    NSLog(@"%@",self.navigationController.viewControllers);
    if ([dic[@"use_yn"] isEqualToString:@"Y"])
    {
        [AlertManager startClock:dic];
    }

    NSString *tipString =  _isUpdate ? NSLocalizedString(@"修改成功！", nil):NSLocalizedString(@"添加成功", nil);
    [Common createAlertViewWithString:tipString withDeleagte:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAlertData" object:nil userInfo:nil];
    [dic release];
}

-(NSString *)getCurrentTime
{
    NSDate *data =[NSDate date];
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *returnString = [fm stringFromDate:data];
    [fm release];
    return returnString;
}

//比较时间
-(BOOL)compareStartDate:(NSString *)startDate AndEndDate:(NSString *)endDate
{
    NSDate *startD = [self timeStringToDateWithString:startDate];
    NSDate *endD = [self timeStringToDateWithString:endDate];
//    if ([startD compare:endD] == NSOrderedDescending || [startD compare:endD] == NSOrderedSame)
     if ([startD compare:endD] == NSOrderedDescending )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//比较时间
-(BOOL)compareLocalTimeStartDate:(NSString *)startDate
{
//    NSDate *startD = [self timeStringToDateWithString:startDate];
//    NSDate *endD = [NSDate new];
    NSString *endString = [[NSDate date].description  substringToIndex:10];
    if ([startDate isEqualToString:endString])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//字符串 转date
-(NSDate *)timeStringToDateWithString:(NSString *)timeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:(@"yyyy-MM-dd")];
    NSDate *dateTime = [formatter dateFromString:timeString];
    [formatter release];
    return dateTime;
}

//字符串 转date
-(NSDate *)alertTimeStringToDateWithString:(NSString *)timeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:(@"yyyy-MM-dd HH:mm")];
    NSDate *dateTime = [formatter dateFromString:timeString];
    [formatter release];
    return dateTime;
}

//根据id 获取内容
-(void)loadDataAlertById
{
    NSString *contentString = @"";
    if ([m_dict objectForKey:@"med_name"])
    {
        contentString = [m_dict objectForKey:@"med_name"];
    }
    [m_rightData addObject:contentString];
    [m_rightData addObject:[[m_dict objectForKey:@"sendtime"] stringByReplacingOccurrencesOfString:@"," withString:@" | "]];
    [m_rightData addObject:[self convertFrequencyWithDictionnary:m_dict]];
    
    NSString *alertSoundString = @"";
    if ([m_dict objectForKey:@"soundName"])
    {
        alertSoundString = [self convertStringWithIndexString:m_dict[@"soundName"] isEnglish:NO];
    }
    [m_rightData addObject:alertSoundString];
    
    NSString *shakeString = @"1";
    if ([m_dict objectForKey:@"isShake"])
    {
        shakeString = [m_dict objectForKey:@"isShake"];
    }
     [m_rightData addObject:shakeString];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createContentView];
}

///  特定血糖 和血压的走这个
///
///  @param title 内容 并且不让编辑
-(void)setAlertTitle:(NSString *)title
{
    UIButton *nameButton = (UIButton *)[self.view viewWithTag:100];
    if (nameButton)
    {
        nameButton.enabled = NO;
        contentHeader.text = title;
        m_rightData[0] = title;
        if ([title containsString:@"血糖"])
        {
            alertTag = kSugerAlert;
        }
        else if ([title containsString:@"血压"])
        {
            alertTag = kBloodAlert;
        }
    }
}
#pragma mark  生成界面
-(void)createContentView
{
    int heightOff = 20;
    //100 101 102
    for (int i = 0; i<3; i++)
    {
        [self createContentCellViewWithPointY:heightOff andWithLeftTitle:m_leftData[i] andContentTitle:m_rightData[i] andBtnTag:100+i];
          heightOff += 64;
    }
//    提示音
    UIButton *alertSoundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    alertSoundButton.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];
    alertSoundButton.tag = 103;
    alertSoundButton.frame = CGRectMake(0, heightOff, kDeviceWidth, 44);
    [alertSoundButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alertSoundButton];
    
    UILabel *leftLabel = [Common createLabel:CGRectMake(14, 7, 150, 30) TextColor:@"#333333" Font:[UIFont systemFontOfSize:VIEWFRONTSIZE] textAlignment:NSTextAlignmentLeft labTitle:@""];
    leftLabel.text = m_leftData[3];
    [alertSoundButton addSubview:leftLabel];
    
    UILabel *rightLabel = [Common createLabel:CGRectMake(kDeviceWidth-160-30 , 7, 160, 30) TextColor:COLOR_999999 Font:[UIFont systemFontOfSize:VIEWCONTENTFRONTSIZE] textAlignment:NSTextAlignmentRight labTitle:@""];
    rightLabel.tag = CONTENTTAG;
    rightLabel.text = m_rightData[3];
    soundLabel = rightLabel;
    [alertSoundButton addSubview:rightLabel];
    
    UILabel *lineTop = [Common createLineLabelWithHeight:0];
    [alertSoundButton addSubview:lineTop];
    
    UILabel *labelMiddle = [[UILabel alloc]initWithFrame:CGRectMake(14, 44-0.5, kDeviceWidth-14, 0.5)] ;
    labelMiddle.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
    labelMiddle.alpha = 0.2f;
    [alertSoundButton addSubview:labelMiddle];
    [labelMiddle release];
    
    UIImageView *imgeView = [[UIImageView alloc]initWithFrame:CGRectMake(alertSoundButton.width-7-15, (alertSoundButton.height-13)/2, 13/2, 21/2)];
    imgeView.image = [UIImage imageNamed:@"common.bundle/common/right-arrow_pre.png"];
    [alertSoundButton addSubview:imgeView];
    [imgeView release];
    heightOff += alertSoundButton.height;
//    震动
    UIButton *shakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shakeButton.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];
    shakeButton.tag = 104;
    shakeButton.frame = CGRectMake(0, heightOff, kDeviceWidth, 44);
    [shakeButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shakeButton];
    
    UILabel *leftLabelSub = [Common createLabel:CGRectMake(14, 7, 150, 30) TextColor:@"#333333" Font:[UIFont systemFontOfSize:VIEWFRONTSIZE] textAlignment:NSTextAlignmentLeft labTitle:@""];
    leftLabelSub.text = m_leftData[4];
    [shakeButton addSubview:leftLabelSub];
    
    m_switch = [[UISwitch alloc] initWithFrame:CGRectMake(kDeviceWidth-(IOS_7?65:73),7, 43, 21)];
    if (!IOS_7) {
        m_switch.frame = [Common rectWithOrigin:m_switch.frame x:kDeviceWidth-90 y:0];
        
    }
    m_switch.onTintColor = [CommonImage colorWithHexString:COLOR_FF5351];
    [m_switch setOn:([m_rightData[4] isEqualToString:@"Y"]? YES:NO )];
    [m_switch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [shakeButton addSubview:m_switch];
    
    UILabel *lineBottom = [Common createLineLabelWithHeight:44];
    [shakeButton addSubview:lineBottom];
    
    heightOff += shakeButton.height +20;
    
    UIButton * btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSave.frame = CGRectMake(20, heightOff, kDeviceWidth-40, 44);
    [btnSave setTitleColor:[CommonImage colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [btnSave setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
    btnSave.titleLabel.font = [UIFont systemFontOfSize:18];
    btnSave.layer.cornerRadius = 4;
    btnSave.clipsToBounds = YES;
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
    [btnSave setBackgroundImage:image forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(btnSave:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSave];
}

-(void)btnSave:(UIButton *)btn
{
    btn.enabled = NO;
    [self loadDataBegin];
    btn.enabled = YES;
}

- (void)switchValueChanged:(id)sender
{
    UISwitch *control = (UISwitch*)sender;
    NSString *isShake = control.isOn?@"Y":@"N";
    [m_rightData replaceObjectAtIndex:4 withObject:isShake];
}

-(void)createContentCellViewWithPointY:(int)pointY andWithLeftTitle:(NSString *)leftTitle andContentTitle:(NSString *)contentString andBtnTag:(int)btnTag
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];
    backButton.tag = btnTag;
    backButton.frame = CGRectMake(0, pointY, kDeviceWidth, 44);
    [backButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UILabel *leftLabel = [Common createLabel:CGRectMake(14, 7, 70, 30) TextColor:@"#333333" Font:[UIFont systemFontOfSize:VIEWFRONTSIZE] textAlignment:NSTextAlignmentLeft labTitle:@""];
    leftLabel.text = leftTitle;
    [backButton addSubview:leftLabel];
    int offX = 130;
    switch (btnTag) {
        case 101:
            offX = 90;
            break;
        case 102:
            offX = 55;
            break;
        default:
            break;
    }
    UILabel *rightLabel = [Common createLabel:CGRectMake(offX ,7, kDeviceWidth-30-offX, 30) TextColor:COLOR_999999 Font:[UIFont systemFontOfSize:VIEWCONTENTFRONTSIZE] textAlignment:NSTextAlignmentRight labTitle:@""];
    rightLabel.tag = CONTENTTAG;
    rightLabel.text = contentString;
    [backButton addSubview:rightLabel];
    
    switch (btnTag) {
        case 100:
            contentHeader = rightLabel;
        case 101:
            timeLabel = rightLabel;
            break;
        case 102:
            repeatLabel = rightLabel;
            break;
        default:
            break;
    }
    
    UILabel *lineTop = [Common createLineLabelWithHeight:0];
    [backButton addSubview:lineTop];
    
    UILabel *lineBottom = [Common createLineLabelWithHeight:44];
    [backButton addSubview:lineBottom];
    
    UIImageView *imgeView = [[UIImageView alloc]initWithFrame:CGRectMake(backButton.width-7-15, (backButton.height-13)/2, 13/2, 21/2)];
    imgeView.image = [UIImage imageNamed:@"common.bundle/common/right-arrow_pre.png"];
    [backButton addSubview:imgeView];
    [imgeView release];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
//        NSArray *dic_data =  [[[DBOperate shareInstance] getAllAlertsFromDB] retain];
//        if (dic_data.count != 0 && !_isUpdate) {
//        HealthRemindViewController*health =[[HealthRemindViewController alloc]init];
//        [self.navigationController pushViewController:health animated:YES];
//        [health release];
//        }else{
//        [self.navigationController popViewControllerAnimated:YES];
//        }
//        [dic_data release];
        
//            BOOL haveFalg = NO;
//            for (UIViewController * viewcontroller in self.navigationController.viewControllers)
//            {
//                if ([viewcontroller isKindOfClass:[HealthRemindViewController class]])
//                {
//                    haveFalg = YES;
//                }
//            }
//            if (!haveFalg)
//            {
//                HealthRemindViewController*health =[[HealthRemindViewController alloc]init];
//                [self.navigationController pushViewController:health animated:YES];
//                [health release];
//            }
//            else{
//                [self.navigationController popViewControllerAnimated:YES];
//            }
    }
}

- (void)btnclick:(UIButton *)btn
{
    if (btn.tag == 1)
    {
        //        确定后发起网络请求
        NSLog(@"确定");
        btn.enabled = NO;
        [self loadDataBegin];
    }
    else if(btn.tag == 2)
    {
        NSLog(@"重置");
        
        NSArray *origelArray = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"", nil), @"", @"永不",@"声音1",@"Y", nil];
        [m_rightData removeAllObjects];
        for (NSString *str in origelArray)
        {
            [m_rightData addObject:str];
        }
        [origelArray release];
        
        timeLabel.text = @"";
        contentHeader.text = @"";
        repeatLabel.text = @"永不";
        soundLabel.text = @"声音1";
        [m_switch setOn:YES animated:YES];;
    }
}


-(void)goToContentNameViewController
{
    HealthAlerNameVCViewController *healthAlertName = [[HealthAlerNameVCViewController alloc] initWithTitle:@"提醒内容" andWithPlaceHoder:@"请输入提醒内容"];
    [self.navigationController pushViewController:healthAlertName animated:YES];
    [healthAlertName release];
}

-(void)backBtnClick:(UIButton *)btn
{
    UILabel *contentLabel = (UILabel *)[btn viewWithTag:CONTENTTAG];
    if(btn.tag == 100)
    {
//        if (fiisrtArray.count == 0)
//        {
        NSString *m_alertTag = m_dict[@"alertTag"];
        if ([kSugerAlert isEqualToString:m_alertTag] || [kBloodAlert isEqualToString:m_alertTag])
        {
            return;
        }
        HealthAlerNameVCViewController *healthAlertName = [[HealthAlerNameVCViewController alloc] initWithTitle:@"提醒内容" andWithPlaceHoder:@"请输入提醒内容"];
        healthAlertName.m_Content = contentLabel.text;
            [healthAlertName setHealthAlerNameVCViewControllerBlock:^(NSString *content) {
                contentLabel.text = content;
                [m_rightData removeObjectAtIndex:0];
                [m_rightData insertObject:content atIndex:0];
            }];
            [self.navigationController pushViewController:healthAlertName animated:YES];
            [healthAlertName release];
            return;
    }
    else if(btn.tag == 101)
    {
        AlertTimeViewController *hwcv = [[AlertTimeViewController alloc]initWithTimeString:contentLabel.text];
        [hwcv setAlertTimeViewControllerBlock:^(NSString *timeContent) {
            NSLog(@"%@",timeContent);
            
            contentLabel.text = timeContent;
            
            if (!timeContent.length)
            {
                timeContent = @"";
            }
            [m_rightData removeObjectAtIndex:1];
            [m_rightData insertObject:[timeContent stringByReplacingOccurrencesOfString:@" | " withString:@";"] atIndex:1];
          
    
        }];
        [self.navigationController pushViewController:hwcv animated:YES];
        [hwcv release];
    }
    else if (btn.tag == 102)
    {
        HealthWeekCycleViewController *hwcv = [[HealthWeekCycleViewController alloc]initWithUpdate:_isUpdate  withContentString:contentLabel.text];
        [hwcv setHealthWeekCycleViewControllerBlock:^(NSMutableDictionary *content) {
            NSLog(@"%@",content);
            NSString *str = [self getStringFromContentDictionary:content];
            if (str)
            {
                 contentLabel.text = str;
                [m_rightData removeObjectAtIndex:2];
                [m_rightData insertObject:str atIndex:2];
            }
            else
            {
                contentLabel.text = @"永不";
                [m_rightData removeObjectAtIndex:2];
                [m_rightData insertObject:REPEARTTEXT atIndex:2];//永不重复
                [m_dict setValue:@"N" forKey:@"repeatFlag"];
            }
        }];
        [self.navigationController pushViewController:hwcv animated:YES];
        [hwcv release];
    }

    else if(btn.tag == 103)
    {
        SoundListViewController *hwcv = [[SoundListViewController alloc]initWithUpdateTitle:contentLabel.text];
//        hwcv.defaultString = m_rightData[2];
        [hwcv setSoundListViewControllerBlock:^(NSString *content) {
            contentLabel.text = content;
            if (content)
            {
                [m_rightData removeObjectAtIndex:3];
                [m_rightData insertObject:content atIndex:3];
            }
        }];

        [self.navigationController pushViewController:hwcv animated:YES];
        [hwcv release];
    }
}

-(NSString *)convertStringWithIndexString:(NSString *)content isEnglish:(BOOL)isEnglish
{
    NSString *replcaeString = isEnglish ? @"alert" :@"声音";
    NSRange range = {0,content.length-1};
    content = [content stringByReplacingCharactersInRange:range withString:replcaeString];
    NSLog(@"%@",content);
    return content;
}

- (NSString *)timeStringFromDate:(NSDate *)timeDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:(@"yyyy-MM-dd HH:mm:ss")];
    NSString *timeString = [formatter stringFromDate:timeDate];
    [formatter release];
    return timeString;
}

//  取出字典内容
- (NSString *)getStringFromContentDictionary:(NSMutableDictionary *)dict
{
    NSString *contentString = nil;
    NSArray *weekDay = [[NSArray alloc] initWithObjects:NSLocalizedString(@"每天", nil),NSLocalizedString(@"周一", nil),NSLocalizedString(@"周二", nil),NSLocalizedString(@"周三", nil),NSLocalizedString(@"周四", nil),NSLocalizedString(@"周五", nil),NSLocalizedString(@"周六", nil),NSLocalizedString(@"周日", nil), nil];
    for (NSString *key in weekDay)
    {
        if ([[dict objectForKey:key] boolValue])
        {
            if (!contentString)
            {
                contentString = key;
            }
            else
            {
                contentString = [NSString stringWithFormat:@"%@  %@",!contentString ? @"":contentString ,key];
            }
        }
    }
    [weekDay release];
    return contentString;
}
-(NSString *)covertWeekNameToNumber:(NSString *)weekString
{
    if ([weekString isEqualToString:@"永不"] || [weekString isEqualToString:@""])//简单替换
    {
       return REPEARTTEXT;
    }
    
    NSString *returnStr = [weekString stringByReplacingOccurrencesOfString:@"  " withString:@","];
    NSArray *weekDay = [[NSArray alloc] initWithObjects:NSLocalizedString(@"周一", nil),NSLocalizedString(@"周二", nil),NSLocalizedString(@"周三", nil),NSLocalizedString(@"周四", nil),NSLocalizedString(@"周五", nil),NSLocalizedString(@"周六", nil),NSLocalizedString(@"周日", nil),NSLocalizedString(@"每天", nil),nil];
    NSArray *weekDayNumber = [[NSArray alloc] initWithObjects:@"001",@"002",@"003",@"004",@"005",@"006",@"007",@"0",nil];
    for (int i = 0; i<weekDayNumber.count; i++)
    {
        returnStr = [returnStr stringByReplacingOccurrencesOfString:[weekDay objectAtIndex:i] withString:[weekDayNumber objectAtIndex:i]];
    }
    [weekDay release];
    [weekDayNumber release];
    return returnStr;
}

@end
