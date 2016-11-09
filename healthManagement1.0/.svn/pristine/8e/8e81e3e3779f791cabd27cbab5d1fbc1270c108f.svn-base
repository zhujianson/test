#import <CoreBluetooth/CoreBluetooth.h>


typedef NS_ENUM(int, SSBLEDeviceTypeEnum) {
    SSBLESENSSUNBODY = 1,
    SSBLESENSSUNFAT = 2,
    SSBLESENSSUNSUPERFAT = 4,
    SSBLESENSSUNFOOD = 6,
    SSBLESENSSUNBODYCLOCK = 12,
    SSBLESENSSUNFATCLOCK = 14,
    SSBLESENSSUNGROWTH = 15
};


@class SSBLEDevice;
@class BodyMeasure;
@class SSBLEReadWriteData;


@protocol SSBLEDeviceDelegate <NSObject>
@optional
- (void)peripheralDidDiscover:(CBPeripheral *)peripheral;
- (void)peripheralDidConnect:(CBPeripheral *)peripheral;
- (void)peripheralDidDisconnect:(CBPeripheral *)peripheral;
- (void)peripheralDidAllowWrite:(CBPeripheral *)peripheral;
//当value的DataType＝DataTypeWeigh，表示接收到秤重数据，此时values＝nil
//当value的DataType＝DatatypeTestFat，表示接收到测试脂肪数据，此时values＝nil
//当value的DataType＝DataTypeHistory，表示接收到历史数据，此时values＝nil
//当values!=nil时，表示接收完所有历史数据，历史数据存储在values对象中，此时value＝nil
//此接口仅供：体重，体脂，八电极秤体使用
- (void)peripheralDidReceived:(CBPeripheral *)peripheral value:(BodyMeasure *)value values:(NSMutableArray *)values;
//此接口仅供：除体重，体脂，八电极外的秤体使用
- (void)peripheralDidReceived:(CBPeripheral *)peripheral data:(SSBLEReadWriteData *)data datas:(NSArray *)datas;
- (void)peripheralDidWrite:(CBPeripheral *)peripheral data:(SSBLEReadWriteData *)data;
- (void)peripheralDidFailToWrite:(CBPeripheral *)peripheral data:(SSBLEReadWriteData *)data;

@end
