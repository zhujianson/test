//
//  DeviceModel.m
//  healthManagement1.0
//
//  Created by jiuhao-yangshuo on 16/2/23.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "DeviceModel.h"

@implementation DeviceModel

+(DeviceModel *)fillDataWithName:(NSString *)name withImagePath:(NSString *)imagePath
{
    DeviceModel *model = [[DeviceModel alloc] init];
    model.deviceImage = imagePath;
    model.deviceName = name;
    return model;
}

+(DeviceModel *)fillDataIndexWithName:(NSString *)name withImagePath:(NSString *)imagePath withIndex:(NSInteger)index
{
    DeviceModel *model = [self fillDataWithName:name withImagePath:imagePath];
    model.deviceIndex = index;
    return model;
}
@end
