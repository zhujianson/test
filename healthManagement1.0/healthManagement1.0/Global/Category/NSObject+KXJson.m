//
//  NSObject+KXJson.m
//  TextIpa
//
//  Created by jiuhao-yangshuo on 15/9/14.
//  Copyright (c) 2015年 jiuhao. All rights reserved.
//

#import "NSObject+KXJson.h"
//#import "SBJson.h"

@implementation NSObject (KXJsonString)

//解析
-(NSString *)KXjSONString
{
    //    NSJSONWritingPrettyPrinted的意思是将生成的json数据格式化输出 \n 
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options: 0
                                                         error:&error];
    if (!jsonData)
    {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    }
    else
    {
        return [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
    }
}

@end



@implementation NSString(KXJsonObject)

//转为字典
-(id)KXjSONValueObject
{
    if(self == nil){
        return self;
    }
    
//    return [self JSONValue];
    //    NSJSONReadingMutableContainers：返回可变容器，NSMutableDictionary或NSMutableArray。
    //    NSJSONReadingMutableLeaves：返回的JSON对象中字符串的值为NSMutableString
    NSError *error = nil;
    NSString *filterString = [self stringByReplacingOccurrencesOfString:@":null" withString:@":\"\""];
    NSData *data = [filterString  dataUsingEncoding:NSUTF8StringEncoding];
    id myObject = [NSJSONSerialization JSONObjectWithData:data
                                                   options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                                                     error:&error];
    if (!myObject)
    {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @{};
    }
    else
    {
        return myObject;
//        return [[myObject retain] autorelease];
    }
}

@end