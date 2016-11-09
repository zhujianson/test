//
//  AddSelectDeviceView.m
//  healthManagement1.0
//
//  Created by jiuhao-yangshuo on 16/2/23.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "AddSelectDeviceView.h"
#import "AddSelectDeviceCell.h"

@interface AddSelectDeviceView()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation AddSelectDeviceView

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    AddSelectDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AddSelectDeviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row < self.m_dataArray.count)
    {
        cell.m_deviceModel = self.m_dataArray[indexPath.row];
    }
    return cell;
}

-(void)setUpCustomData
{
    self.m_cellHight = kAddSelectDeviceCellH;
    self.m_titleString = @"选择设备";
    DeviceModel *modelOne = [DeviceModel fillDataIndexWithName:@"蓝牙设备" withImagePath:@"common.bundle/personnal/device/bluetooth.png" withIndex:0];
    DeviceModel *modelTwo = [DeviceModel fillDataIndexWithName:@"多参设备" withImagePath:@"common.bundle/personnal/device/multi-Input.png" withIndex:1];
    [self.m_dataArray addObject:modelOne];
    [self.m_dataArray addObject:modelTwo];
}
@end
