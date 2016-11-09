//
//  ConfigData.m
//  GreatWall
//
//  Created by Sidney on 13-3-20.
//  Copyright (c) 2013年 BH Technology Co., Ltd. All rights reserved.
//

#import "ConfigData.h"


static ConfigData *_instance;

@implementation ConfigData

+ (id)shareInstance
{
    if (!_instance) {
        _instance = [[ConfigData alloc] init];
        [_instance setNeedRotation:NO];
    }
    return _instance;
}

- (NSString *)userID
{
    return _userID;
}

//计算字符串长度
- (int)textLength:(NSString *)text
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        //一个汉字两个字节，应是+2.项目中数据库使用的mysql-utf8 一个汉字是3个字节，改成+3
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3){
            number += 3;
        }else{
            number ++;
        }
    }
    return ceil(number);
}

- (void)writeToPlist:(id)object fileName:(NSString *)fileName
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString * path = [paths  objectAtIndex:0];
    NSString * filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    NSLog(@"filePath:%@",filePath);
    [object writeToFile:filePath atomically:YES];
}

#pragma mark -
#pragma mark - 用户查询类型

+ (int)getCurTypeId
{
    return [[[[[ConfigData shareInstance] userDataTypes] objectAtIndex:0] objectForKey:@"data_id"] intValue];
}

+ (NSString *)getCurType
{
    return [[[[ConfigData shareInstance] userDataTypes] objectAtIndex:0] objectForKey:@"data_name"];
}

+ (NSMutableArray *)getAllUserDataType
{
    NSMutableArray *allType = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    for (NSDictionary * dic in [[ConfigData shareInstance] userDataTypes]) {
        NSString * type = [dic objectForKey:@"data_name"];
		if(![type isEqualToString:@"脉率"])
			[allType addObject:type];
    }
    
    return allType;
}

#pragma mark -
#pragma mark - 健康报告用户查询类型

+ (int)getReportCurTypeId
{
    return [[[[[ConfigData shareInstance] userReportTypes] objectAtIndex:[[ConfigData shareInstance] selectReportTypeId]] objectForKey:@"data_id"] intValue];
}

+ (NSString *)getReportCurType
{
    return [[[[ConfigData shareInstance] userReportTypes] objectAtIndex:[[ConfigData shareInstance] selectReportTypeId]] objectForKey:@"data_name"];
}

+ (NSArray *)getReportAllUserDataType
{
    NSMutableArray *allType = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    for (NSDictionary * dic in [[ConfigData shareInstance] userReportTypes]) {
        NSString * type = [dic objectForKey:@"data_name"];
        [allType addObject:type];
    }
    
    return allType;
}

@end
