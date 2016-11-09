//
//  AlertTableViewCell.m
//  jiuhaoHealth2.0
//
//  Created by 徐国洪 on 14-4-4.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import "AlertTableViewCell.h"
#import "Common.h"
#import "CommonHttpRequest.h"

@implementation AlertTableViewCell
{
    BOOL switchOn;
}
@synthesize dicInfo,m_labCyclist,view;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, kDeviceWidth-20, 150)];
        view.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];
        view.layer.cornerRadius = 4.0f;
        view.layer.borderWidth = 0.5f;
        view.layer.borderColor = [CommonImage colorWithHexString:@"e5e5e5"].CGColor;
        [self.contentView addSubview:view];
        [view release];
        
        m_labTitle = [[UILabel alloc] initWithFrame:CGRectMake(17, (45-19)/2, 220, 19)];
        m_labTitle.backgroundColor = [UIColor clearColor];
        m_labTitle.textColor = [CommonImage colorWithHexString:@"333333"];
        m_labTitle.font = [UIFont systemFontOfSize:18];
        [view addSubview:m_labTitle];
        
        UILabel *lineTop = [self createLineLabelWithHeight:45];
        [view addSubview:lineTop];
        
        m_labCon = [[UILabel alloc] initWithFrame:CGRectMake(17, 45+(45-14)/2, kDeviceWidth-50, 14)];
        m_labCon.backgroundColor = [UIColor clearColor];
        m_labCon.textColor = [CommonImage colorWithHexString:@"666666"];
        m_labCon.font = [UIFont systemFontOfSize:15];
        [view addSubview:m_labCon];
        
        UILabel *lineMiddle = [self createLineLabelWithHeight:90];
        [view addSubview:lineMiddle];

        m_labCyclist = [[UILabel alloc] initWithFrame:CGRectMake(17, 110, IOS_7?270:220, 17)];
        m_labCyclist.backgroundColor = [UIColor clearColor];
        m_labCyclist.numberOfLines = 0;
        m_labCyclist.textColor = [CommonImage colorWithHexString:@"666666"];
        m_labCyclist.font = [UIFont systemFontOfSize:14];
        [view addSubview:m_labCyclist];
        
        m_switch = [[UISwitch alloc] initWithFrame:CGRectMake(kDeviceWidth -(IOS_7? 90:110),7, 43, 21)];
        m_switch.onTintColor = [CommonImage colorWithHexString:COLOR_FF5351];
        [m_switch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [view addSubview:m_switch];
        
    }
    return self;
}

- (UILabel *)createLineLabelWithHeight:(int)lineHeight
{
    UILabel *labelLine = [[[UILabel alloc]initWithFrame:CGRectMake(0, lineHeight-0.5, kDeviceWidth-20, 0.5)] autorelease];
    labelLine.backgroundColor = [CommonImage colorWithHexString:@"#000000"];
    labelLine.alpha = 0.2f;
    return labelLine;
}
- (void)setAlertTableViewCellBlock:(AlertTableViewCellBlock)_handler
{
    _inBlobk = [_handler copy];
}

- (void)switchValueChanged:(id)sender
{
    UISwitch *control = (UISwitch*)sender;
    if (switchOn != control.on &&  [dicInfo isKindOfClass:[NSMutableDictionary class]] && dicInfo.allKeys.count > 0 )
    {
        [dicInfo setObject:[NSNumber numberWithBool:control.on] forKey:@"isOpen"];
         switchOn = m_switch.on;
        _inBlobk(dicInfo);
    }
}

- (void)setDicInfo:(NSMutableDictionary*)dic
{
    dicInfo = [dic retain];
    m_labTitle.text = [dic objectForKey:@"med_name"];
    NSString *sendtimeTitle = [[dic objectForKey:@"sendtime"] stringByReplacingOccurrencesOfString:@"," withString:@"   |   "];
    if ([sendtimeTitle rangeOfString:@" |"].location != NSNotFound)
    {
         sendtimeTitle = [NSString stringWithFormat:@"%@   |",sendtimeTitle];
    }
    CGSize  size = [ sendtimeTitle sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kDeviceWidth-50, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    if (size.height > 17)
    {
        m_labCyclist.frame = CGRectMake(m_labCyclist.frame.origin.x, 110, m_labCyclist.frame.size.width,m_labCyclist.frame.size.height+17);
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height+17);
    }
    else
    {
         m_labCyclist.frame = CGRectMake(17, 110, kDeviceWidth-50, 17);
    }
    m_labCyclist.text = sendtimeTitle;
    m_labCon.text = [self convertFrequencyWithDictionnary:dic];
    [m_switch setOn: [self getRemindStateWithDictionnary:dic]];
    switchOn = [self getRemindStateWithDictionnary:dic];
}
//把001转为对应星期
-(NSString *)convertFrequencyWithDictionnary:(NSDictionary *)dict
{
    if ([dict[@"frequency"] isEqualToString:REPEARTTEXT] )
    {
        return @"永不";
    }
    NSArray *array = [[dict objectForKey:@"frequency"] componentsSeparatedByString:@","];
    NSArray *weekArray = [[NSArray alloc] initWithObjects:@"每天",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日", nil];
    NSString *returnStr = nil;
    for (NSString *str in array)
    {
        if (!returnStr)
        {
            returnStr = [weekArray objectAtIndex:str.intValue];
        }
        else
        {
          returnStr  = [NSString stringWithFormat:@"%@ %@",returnStr,[weekArray objectAtIndex:str.intValue]];
        }
    }
    [weekArray release];
    return returnStr;
}
-(BOOL)getRemindStateWithDictionnary:(NSDictionary *)dict
{
    NSString *str = [dict objectForKey:@"use_yn"] ;
    if ([@"N" isEqualToString:str])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [m_labTitle release];
    [m_labCon release];
    [m_labCyclist release];
    [m_switch release];
    self.dicInfo = nil;
    if(_inBlobk){
        [_inBlobk release];
        _inBlobk = nil;
    }
    
    [super dealloc];
}

@end
