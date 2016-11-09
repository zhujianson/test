//
//  ScanDeviceListView.m
//  healthManagement1.0
//
//  Created by jiuhao-yangshuo on 16/2/23.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "ScanDeviceListView.h"
#import "ScanDeviceListViewCell.h"

@implementation ScanDeviceListView

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    ScanDeviceListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ScanDeviceListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row < self.m_dataArray.count)
    {
//        cell.m_deviceModel = self.m_dataArray[indexPath.row];
        [cell loadData:self.m_dataArray[indexPath.row]];
    }
    return cell;
}

-(void)setUpCustomData
{
    self.m_cellHight = kScanDeviceListViewCellH;
    self.m_titleString = @"选择设备";
//    DeviceModel *modelOne = [DeviceModel fillDataIndexWithName:@"蓝牙设备" withImagePath:@"common.bundle/personnal/device/bluetooth.png" withIndex:0];
//    DeviceModel *modelTwo = [DeviceModel fillDataIndexWithName:@"多参设备" withImagePath:@"common.bundle/personnal/device/multi-Input.png" withIndex:1];
//    [self.m_dataArray addObject:modelOne];
//    [self.m_dataArray addObject:modelTwo];
}

+(void)showScanDeviceListViewWithBlock:(KXSelectBaseViewBlock )block  withDataArray:(NSArray *)dataArray
{
    ShowSelectBaseView *payView = [APP_DELEGATE viewWithTag:1996];
    if (!payView)
    {
        payView = [[self alloc] initWithKXPayManageViewBlock:block];
        payView.tag = 1996;
        [APP_DELEGATE addSubview:payView];
        [payView show];
    }

    [payView.m_dataArray removeAllObjects];
    [payView.m_dataArray addObjectsFromArray:dataArray];
    [payView updateFrame];
}
@end
