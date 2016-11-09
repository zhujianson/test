//
//  DiaryModelView.m
//  jiuhaohealth4.0
//
//  Created by jiuhao-yangshuo on 15-6-15.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "DiaryModelView.h"
#import "DiraryHistoryType.h"
#import "NSDate+convenience.h"
#import "CommonUser.h"

@implementation DiaryModelView

+ (void)changeButtonValueColorWithWarning:(NSString *)warning withButton:(UIView *)targetView
{
    //warning :  0正常 1高  2低
    NSString *colorString = @"333333";
    switch ([warning intValue]) {
        case 0:
            colorString = @"333333";
            break;
        case 1:
            colorString = [CommonUser setColorForWarningType:warning];
            break;
        case 2:
            colorString = [CommonUser setColorForWarningType:warning];
            break;
        default:
            break;
    }
    if([targetView isKindOfClass:[UIButton class]])
    {
        [(UIButton *)targetView setTitleColor:[CommonImage colorWithHexString:colorString] forState:UIControlStateNormal];
    }
    else if([targetView isKindOfClass:[UILabel class]])
    {
        ((UILabel *)targetView).textColor = [CommonImage colorWithHexString:colorString];
    }
    else if([targetView isKindOfClass:[UITextField class]])
    {
        ((UITextField *)targetView).textColor = [CommonImage colorWithHexString:colorString];
    }
}

+(NSArray *)obtainTimeSectionArray
{
    NSArray *buttonArray = @[[NSNumber numberWithInt:TimeEarlyMorningType],
                             [NSNumber numberWithInt:TimeBeforeBreakfastType],
                             [NSNumber numberWithInt:TimeAfterBreakfastType],
                             [NSNumber numberWithInt:TimeBeforeNooningType],
                             [NSNumber numberWithInt:TimeAfterNooningType],
                             
                             [NSNumber numberWithInt:TimeBeforeDinnerType],
                             [NSNumber numberWithInt:TimeAfterDinnerType],
                             [NSNumber numberWithInt:TimeBeforeSleepType],
                             [NSNumber numberWithInt:TimeRandomType],
                             ];
    return buttonArray;
}

+(int)obtainIndexTimeSectionArray:(DiraryTimeType)m_DiraryTimeType
{
    NSArray *array = [[self class] obtainTimeSectionArray];
    int indexCount = (int)[array indexOfObject:[NSNumber numberWithInt:m_DiraryTimeType]];
    return indexCount;
}

+ (long)getLongTimeWithOff:(int)offMonth
{
    NSDate* now = [[NSDate date] offsetMonth:-(offMonth-1)];
    NSLog(@"++++%@",now);
    unsigned long test = (long)[now timeIntervalSince1970];
    return test;
}

+ (long)getLongTimeWithOffDay:(int)offDay
{
    NSDate* now = [[NSDate date] offsetDay:offDay];
    NSLog(@"++++%@",now);
    unsigned long test = (long)[now timeIntervalSince1970];
    return test;
}

+ (unsigned long)getLongTimeWithDate1:(NSString*)dateString
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [dateFormatter dateFromString:dateString];
    [dateFormatter release];
    unsigned long test = (unsigned long)[date timeIntervalSince1970];
    return test;
}

+(NSDictionary *)getPartFile
{
    NSString* pathname = [[NSBundle mainBundle] pathForResource:@"part" ofType:@"txt"];
    NSString* str = [NSString stringWithContentsOfFile:pathname encoding:NSUTF8StringEncoding error:nil];
    NSDictionary* dic = [str KXjSONValueObject];
    return dic;
}

+(NSString *)mixtureTimeString:(NSNumber*)timeSelect
{
    long long timeNow = 0;
//    if ([timeSelect isKindOfClass:[NSNumber class]])
//    {
        timeNow = timeSelect.longLongValue;
//    }
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init]autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *selectDateString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeNow]];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *nowDateString = [formatter stringFromDate:[NSDate date]];
    
    NSRange range = {0,selectDateString.length};
    nowDateString = [nowDateString stringByReplacingCharactersInRange:range withString:selectDateString];
    NSDate* date = [formatter dateFromString:nowDateString];

    unsigned long long test = (long long)[date timeIntervalSince1970];
    NSString* convertString = [NSString stringWithFormat:@"%llu", test];

    return convertString;
}

+(NSArray *)obtainArrayWithoutDuplicates:(NSArray *)origelArray
{
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:origelArray];
    NSArray *arrayWithoutDuplicates = [orderedSet array];
    return arrayWithoutDuplicates;
}

//描红
+ (NSMutableAttributedString *)replaceRedColorWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )s TextColor:(NSString*)coler andThreeNSString:(NSString*)three andThreeColor:(NSString*)tColor
{
    NSMutableAttributedString *attrituteString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:@"333333"], NSFontAttributeName : [UIFont systemFontOfSize:s]} range:NSMakeRange(0, str.length)];
    
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:coler], NSFontAttributeName : [UIFont systemFontOfSize:s]} range:range];
    
    NSRange range2 = NSMakeRange(range.length+1, [three length]);
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:tColor], NSFontAttributeName : [UIFont systemFontOfSize:s]} range:range2];
    
    return attrituteString;
}

+(void)changeUIViewNumerColorWithView:(UIView *)targetView
                      andWithDataType:(DiraryHistoryType)m_diaryType
                          andWithDict:(NSDictionary *)dict
                          withTwoLine:(BOOL)twoLine
                          withWarning:(NSString *)warning
{
    if (m_diaryType == BloodSugarType)
    {
        NSString *warning = dict[@"warning"];
        [[self class] changeButtonValueColorWithWarning:warning withButton:targetView];
    }
    else if (m_diaryType == BloodPressType)
    {
        NSString *sbpString = dict[@"sbp"];
        NSString *dbpString = dict[@"dbp"];
        NSString *titleString = [NSString stringWithFormat:@"%@%@%@", sbpString,(twoLine?@"\n":@"/"),dbpString];
        
        NSMutableArray *array= nil;
        if (warning.length)
        {
            array = [[warning componentsSeparatedByString:@","] mutableCopy];
            if (array.count == 3)
            {
                [array removeLastObject];
            }
            else
            {
                array = [@[@"0",@"0"] mutableCopy];
            }
        }
        NSString *waning = array[0];
        NSString *gColor = [CommonUser setColorForWarningType:waning];//高压
        waning = array[1];
        NSString *dColor = [CommonUser setColorForWarningType:waning];//低压
        if (array)
        {
            [array release];
        }
        UIFont *targetViewFront = [UIFont systemFontOfSize:12.0];
        if ([targetView isKindOfClass:[UIButton class]])
        {
            targetViewFront = ((UIButton *)targetView).titleLabel.font;
        }
        else if([targetView isKindOfClass:[UILabel class]])
        {
            targetViewFront = ((UILabel *)targetView).font;
        }
        else
        {
            targetViewFront = ((UILabel *)targetView).font;
        }
        NSAttributedString* attributedText = [[self class]replaceRedColorWithNSString:titleString andUseKeyWord:sbpString andWithFontSize:targetViewFront.pointSize TextColor:gColor andThreeNSString:dbpString andThreeColor:dColor];
        if ([targetView isKindOfClass:[UIButton class]])
        {
            [(UIButton *)targetView setAttributedTitle:attributedText forState:UIControlStateNormal];
        }
        else if([targetView isKindOfClass:[UILabel class]])
        {
            ((UILabel *)targetView).attributedText = attributedText;
        }
        else
        {
             ((UILabel *)targetView).attributedText = attributedText;
        }
    }
}

//是否和当前日期在同月份
+(int)getMonthDaysWithDate:(NSDate *)selectedDate
{
    int days = 0;
    NSCalendar *myCalendar = [NSCalendar currentCalendar];
    days = [selectedDate numDaysInMonth];
    
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *componentsNow =
    [myCalendar components:unitFlags fromDate: [NSDate new]];
    NSDateComponents *components =
    [myCalendar components:unitFlags fromDate: selectedDate];
    if (components.year == componentsNow.year &&  components.month == componentsNow.month )
    {
        days = (int)componentsNow.day;
    }
    return days;
}

+(NSString *)getTimeWithKey:(NSString *)keyStr
{
    NSString *postTime = @"";
    NSString *kLastTime = keyStr;
    postTime = [[NSUserDefaults standardUserDefaults] objectForKey:kLastTime];
    if (!postTime.length)
    {
        postTime = @"";
    }
    return postTime;
}

///  存本地一个时间标识
///
///  @param keyStr  key
///  @param timeStr value 为nil 为默认本地时间
+(void)saveTimeWithKey:(NSString *)keyStr withTimeStr:(NSString *)timeStr
{
    if (timeStr.length)
    {
        timeStr = [NSString stringWithFormat:@"%lld",[CommonDate getLonglongTime]];
    }
    if (keyStr.length & timeStr.intValue)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",timeStr] forKey:keyStr];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end
