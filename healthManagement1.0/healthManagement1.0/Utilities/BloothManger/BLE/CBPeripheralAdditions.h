#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>


#define IOS7Later [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0


@class SSBLEReadWriteManager;


@interface CBPeripheral (CBPeripheralAdditions)

@property (nonatomic, readonly) NSString *deviceID;
@property (nonatomic, retain) NSNumber *deviceType;
@property (nonatomic, copy) NSString *advertiseName;
@property (nonatomic, copy) NSString *serialNO;
@property (nonatomic, retain) NSNumber *newRSSI;

@end
