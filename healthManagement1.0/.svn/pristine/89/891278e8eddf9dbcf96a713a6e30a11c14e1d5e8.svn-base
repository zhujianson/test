//
//  HealthRecordModel.h
//  healthManagement1.0
//
//  Created by wangmin on 16/1/6.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {

    titleType = 0,//标题用
    pairType = 1,//键值对
    textType = 2,//只有文字
    diseaseType = 3//疾病显示
    
}HealthRecordType;


@interface HealthRecordModel : NSObject

@property (nonatomic,strong) NSString *logoImageName;//选项卡图片

@property (nonatomic,strong) NSString *logoName;//选项卡的名称

@property (nonatomic,assign) HealthRecordType type;//类型

@property (nonatomic,strong) NSString *keyString;//key

@property (nonatomic,strong) NSString *valueString;//value


@property (nonatomic,strong) NSString *diseaseTitleString;//疾病标题

@property (nonatomic,strong) NSArray *diseaseArray;//疾病数组

@property (nonatomic,strong) NSString *contentString;//内容

@property (nonatomic,assign) CGFloat rowHeight;




- (void)parseData:(NSDictionary *)dic;

@end
