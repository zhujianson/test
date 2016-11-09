//
//  CalcutorProgram.m
//  jiuhaohealth2.1
//
//  Created by jiuhao-yangshuo on 14-8-5.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "CalcutorProgram.h"

@implementation CalcutorProgram
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSDictionary*)calculatorResultDict:(NSDictionary*)dict
{
    int caculatorType = [dict[@"type"] intValue];
    switch (caculatorType) {
    case 1:
        return [self resultBMI:dict]; //体重指数
        break;
    case 2:
        return [self resultBodyFat:dict]; //身体脂肪率
        break;
    case 3:
        return [self resultBMR:dict]; //基础代谢计算器
        break;
    case 4:
        return [self resultConvertSugerUnit:dict]; //血糖单位转换
        break;
    case 5:
        return [self resultConvertScaleToMol:dict]; //糖化血红蛋白
        break;
    case 6:
        return [self resultAverageBlood:dict]; //平均血糖转换
        break;
    default:
        break;
    }
    return nil;
}

//体重指数(指数，状况、理想体重)
- (NSDictionary*)resultBMI:(NSDictionary*)calcutorProgramDict
{
    NSMutableDictionary* resultDict = [[[NSMutableDictionary alloc] init] autorelease];

    NSString* bodyStatue = nil;
    NSString* heightString = [NSString stringWithFormat:@"%.3f", [calcutorProgramDict[@"bodyHeight"] intValue] / 100.0];
    if (![calcutorProgramDict[@"bodyHeight"] length]) {
        heightString = [NSString stringWithFormat:@"%.3f",g_nowUserInfo.height/100];
    }
    NSString* bodyWeight = calcutorProgramDict[@"bodyWeight"];
    NSString* ideaWeight = nil;
    NSString* BMIString = nil;
    if (heightString.length > 0 && bodyWeight.length > 0) {
        //    理想体重
        ideaWeight = [NSString stringWithFormat:@"%.1f", (heightString.floatValue * heightString.floatValue) * 24];
        //    bmi
        BMIString = [NSString stringWithFormat:@"%.1f", (bodyWeight.floatValue) / (heightString.floatValue * heightString.floatValue)];
    }
    float BMINumber = BMIString.floatValue;

    if (18.5 < BMINumber && BMINumber <= 23.9) {
        bodyStatue = NSLocalizedString(@"正常!", @"");
    } else if (23.9 < BMINumber && BMINumber <= 27.9) {
        bodyStatue = NSLocalizedString(@"超重!", @"");
    } else if (BMINumber >= 28) {
        bodyStatue = NSLocalizedString(@"肥胖!", @"");
    } else if (BMINumber <= 18.5 && BMINumber >= 0) {
        bodyStatue = NSLocalizedString(@"过轻!", @"");
    }
    [resultDict setObject:BMIString forKey:@"BMIString"];
    [resultDict setObject:bodyStatue forKey:@"bodyStatue"];
    [resultDict setObject:ideaWeight forKey:@"ideaWeight"];
    return resultDict;
}

// 身体脂肪计算器(总重量、体脂肪率，体脂状态)
- (NSDictionary*)resultBodyFat:(NSDictionary*)calcutorProgramDict
{
    NSMutableDictionary* resultDict = [[[NSMutableDictionary alloc] init] autorelease];

    NSString* bodyWaistline = calcutorProgramDict[@"bodyWaistline"];
    NSString* bodyWeight = calcutorProgramDict[@"bodyWeight"];
    NSString* bodyAge = calcutorProgramDict[@"bodyAge"];
    NSLog(@"%@", calcutorProgramDict);
    NSString* bodyFatScale = nil; //体质率
    NSString* bodyFatStatue = nil; //体质率
    float argumentA = 0; //体脂率
    //    0 男 1 女
    BOOL sex = [calcutorProgramDict[@"personSex"] intValue] == 1 ? YES : NO;
    NSLog(@"%d", [calcutorProgramDict[@"personSex"] intValue]);
    //bmi体重指数
    CGFloat bmi = bodyWeight.floatValue / (bodyWaistline.floatValue / 100) / (bodyWaistline.floatValue / 100);
    if (sex) {
        argumentA = 1.20 * bmi + (0.23 * bodyAge.floatValue) - 5.4;
        bodyFatScale = [NSString stringWithFormat:@"%.1f%@", argumentA,@"%"];
        if (argumentA < 17) {
            bodyFatStatue = NSLocalizedString(@"体脂偏低", @"");
        } else if (argumentA < 31) {
            bodyFatStatue = NSLocalizedString(@"正常值", @"");
        } else{
            bodyFatStatue = NSLocalizedString(@"体脂偏高", @"");
        }
    } else {
        argumentA = 1.20 * bmi + (0.23 * bodyAge.floatValue) - 10.8 - 5.4;
        bodyFatScale = [NSString stringWithFormat:@"%.1f%@", argumentA,@"%"];
        if (argumentA < 10) {
            bodyFatStatue = NSLocalizedString(@"体脂偏低", @"");
        } else if (argumentA < 21) {
            bodyFatStatue = NSLocalizedString(@"正常值", @"");
        } else {
            bodyFatStatue = NSLocalizedString(@"体脂偏高", @"");
        }
    }
    NSLog(@"%f", argumentA);
    [resultDict setObject:bodyFatScale forKey:@"bodyFatScale"];
    [resultDict setObject:bodyFatStatue forKey:@"bodyFatStatue"];
    return resultDict;
}

//基础代谢计算器(基础代谢率)
- (NSDictionary*)resultBMR:(NSDictionary*)calcutorProgramDict
{
    NSMutableDictionary* resultDict = [[[NSMutableDictionary alloc] init] autorelease];

    NSString* bodyWeight = calcutorProgramDict[@"bodyWeight"];
    NSString* bodyHeight = calcutorProgramDict[@"bodyHeight"];
    NSString* bodyAge = calcutorProgramDict[@"bodyAge"];

    BOOL sex = [calcutorProgramDict[@"personSex"] intValue] == 1 ? YES : NO;
    CGFloat kcal;

    NSString* BMRString = nil;
    float BMRStringNum = 0;
    if (sex) {
        //女性基础代谢算法
        if (bodyAge.intValue <= 15) {
            kcal = 41.2;
        } else if ( bodyAge.intValue <= 17 && bodyAge.intValue >= 16) {
            kcal = 43.4;
        } else if (bodyAge.intValue <= 19 && bodyAge.intValue >= 18) {
            kcal = 36.8;
        } else if (bodyAge.intValue <= 30 && bodyAge.intValue >= 20) {
            kcal = 35.0;
        } else if (bodyAge.intValue <= 40 && bodyAge.intValue >= 31) {
            kcal = 35.1;
        } else if (bodyAge.intValue <= 50 && bodyAge.intValue >= 41) {
            kcal = 34.0;
        } else{
            kcal = 33.1;
        }
        BMRStringNum = (0.00659 * bodyHeight.floatValue + 0.0126 * bodyWeight.floatValue - 0.1603) * kcal * 24;

    } else {
        //男性基础代谢算法
          if (bodyAge.intValue <= 15) {
              kcal = 46.7;
        } else if ( bodyAge.intValue <= 17 && bodyAge.intValue >= 16) {
            kcal = 46.2;
        } else if (bodyAge.intValue <= 19 && bodyAge.intValue >= 18) {
            kcal = 39.7;
        }else if (bodyAge.intValue <= 30 && bodyAge.intValue >= 20) {
            kcal = 37.7;
        } else if (bodyAge.intValue <= 40 && bodyAge.intValue >= 31) {
            kcal = 37.9;
         } else if (bodyAge.intValue <= 50 && bodyAge.intValue >= 41) {
            kcal = 36.8;
        } else{
            kcal = 35.6;
        }
        BMRStringNum = (0.00659 * bodyHeight.floatValue + 0.0126 * bodyWeight.floatValue - 0.1603) * kcal * 24;
    }
    BMRString = [NSString stringWithFormat:@"%.1f", BMRStringNum];
    [resultDict setObject:BMRString forKey:@"BMRString"];
    return resultDict;
}

//血糖单位换算器
- (NSDictionary*)resultConvertSugerUnit:(NSDictionary*)calcutorProgramDict
{
    NSMutableDictionary* resultDict = [[[NSMutableDictionary alloc] init] autorelease];

    float sugerUnitMgdlFloat = [calcutorProgramDict[@"sugerUnitMgdl"] floatValue];
    float sugerUnitMmmollFloat = [calcutorProgramDict[@"sugerUnitMmmoll"] floatValue];
    
    //修改----
    NSLog(@"%f--%f", sugerUnitMgdlFloat, sugerUnitMmmollFloat);
    BOOL personMany = [calcutorProgramDict[@"personMany"] intValue] == 1 ? YES : NO;
    if (!personMany) {
        sugerUnitMgdlFloat = sugerUnitMmmollFloat/18;
    } else {
        sugerUnitMmmollFloat = sugerUnitMgdlFloat * 18.0;
    }
    
    NSLog(@"%f--%f", sugerUnitMmmollFloat, sugerUnitMgdlFloat / 18.0);
    NSString* sugerUnitMgdl = [NSString stringWithFormat:@"%.1f", sugerUnitMgdlFloat<0?0:sugerUnitMgdlFloat];
    NSString* sugerUnitMmmoll = [NSString stringWithFormat:@"%.1f", sugerUnitMmmollFloat<0?0:sugerUnitMmmollFloat];
    [resultDict setObject:sugerUnitMgdl forKey:@"sugerUnitMmmoll"];
    [resultDict setObject:sugerUnitMmmoll forKey:@"sugerUnitMgdl"];
    return resultDict;
}

//糖化血红蛋白
- (NSDictionary*)resultConvertScaleToMol:(NSDictionary*)calcutorProgramDict
{
    NSMutableDictionary* resultDict = [[[NSMutableDictionary alloc] init] autorelease];

    float hemoglobinScaleFloat = [calcutorProgramDict[@"hemoglobinScale"] floatValue];
    float hemoglobinMmmollFloat = [calcutorProgramDict[@"hemoglobinMmmoll"] floatValue];

    BOOL personMany = [calcutorProgramDict[@"personMany"] intValue] == 1 ? YES : NO;
    if (personMany) {
        hemoglobinMmmollFloat = (hemoglobinScaleFloat - 2.15) * 10.929;
    } else {
        hemoglobinScaleFloat = (hemoglobinMmmollFloat / 10.929) + 2.15;
        hemoglobinScaleFloat= hemoglobinMmmollFloat<=0?0:hemoglobinScaleFloat;
    }
    NSString* hemoglobinMmmoll = [NSString stringWithFormat:@"%.1f", hemoglobinMmmollFloat<0?0:hemoglobinMmmollFloat];
    NSString* hemoglobinScale = [NSString stringWithFormat:@"%.0f", hemoglobinScaleFloat<0?0:hemoglobinScaleFloat];
    [resultDict setObject:hemoglobinScale forKey:@"hemoglobinScale"];
    [resultDict setObject:hemoglobinMmmoll forKey:@"hemoglobinMmmoll"];
    return resultDict;
}

//糖化血红蛋白平均
- (NSDictionary*)resultAverageBlood:(NSDictionary*)calcutorProgramDict
{
    NSMutableDictionary* resultDict = [[[NSMutableDictionary alloc] init] autorelease];
    float hemoglobinScaleFloat = [calcutorProgramDict[@"hemoglobinScale"] floatValue];
    float averageBloodSugerFloat = [calcutorProgramDict[@"averageBloodSuger"] floatValue];

    BOOL personMany = [calcutorProgramDict[@"personMany"] intValue] == 1 ? YES : NO;
    BOOL unitMGDL = [calcutorProgramDict[@"unitMG/DL"] intValue] == 1 ? YES : NO;//左右单位
    if (personMany)//上面\下面
    {
        averageBloodSugerFloat = unitMGDL? (hemoglobinScaleFloat*28.7 - 46.7):(hemoglobinScaleFloat*1.59 - 2.59);
    } else
    {
        hemoglobinScaleFloat =  unitMGDL? (averageBloodSugerFloat+46.7)/28.7:(averageBloodSugerFloat+2.59)/1.59;
        hemoglobinScaleFloat= averageBloodSugerFloat<=0?0:hemoglobinScaleFloat;
    }
    NSString* averageBloodSuger = [NSString stringWithFormat:@"%.1f", averageBloodSugerFloat<0?0:averageBloodSugerFloat];
    NSString* hemoglobinScale = [NSString stringWithFormat:@"%.1f", hemoglobinScaleFloat<0?0:hemoglobinScaleFloat];
    [resultDict setObject:hemoglobinScale forKey:@"hemoglobinScale"];
    [resultDict setObject:averageBloodSuger forKey:@"averageBloodSuger"];
    return resultDict;
}

@end
