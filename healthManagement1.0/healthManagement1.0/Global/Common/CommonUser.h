//
//  CommonDisease.h
//  jiuhaohealth4.0
//
//  Created by 徐国洪 on 15-5-24.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUser : NSObject
+ (NSMutableArray*)getBloodSugarArray;

+ (NSString*)getBloodSugarType:(NSString*)str;

+ (NSMutableArray*)getIntBloodSugarArray;

+ (int)getBloodSugarIndexType:(NSString*)str;

//根据预警设置颜色
+ (BOOL)setTextColor:(UILabel*)label :(NSString*)Contrast;

//根据预警设置颜色
+ (NSString*)setColorForWarningType:(NSString*)waning;

+ (NSString*)getContentWithType:(NSString*)type;

+ (NSString*)getSex:(NSString*)str;

//获取糖尿病类型,数字编码为Key
+ (NSDictionary*)getBloodSugarDic1;

//获取糖尿病类型,名称为Key
+ (NSDictionary*)getBloodSugarDic2;

//获取既往病史
+ (NSMutableArray*)getHistoryDisease;

//关系
+ (NSString*)getRelationship:(NSString*)str;

//获取糖尿病类型
+ (NSMutableArray*)getBloodSugar;
//获取家人关系
+ (NSMutableArray*)getFmalyRelationship;

+ (NSString*)getAfterTypeForTime:(NSString*)str;

+ (void)setUpSexImageView:(UIImageView *)view withSexString:(NSString *)sexString;
+ (NSString*)getUserName;
+ (NSString*)getUserPswd;

//体重
+ (NSString*)getColorForTizhong:(NSString*)str;
+ (NSString*)getColorForTizhong2:(NSString*)str;

@end
