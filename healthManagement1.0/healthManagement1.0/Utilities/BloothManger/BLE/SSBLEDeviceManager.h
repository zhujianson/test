#import <Foundation/Foundation.h>
#import "SSBLEDevice.h"


typedef NS_ENUM(int, SSBLEModeEnum) {
    SSBLEModeNone = 0,
    SSBLEModeConnectManual = 1,
    SSBLEModeConnectAuto = 2
};


@interface SSBLEDeviceManager : NSObject

@property (nonatomic, readonly, retain) NSMutableDictionary *deviceIDToPeripheralMap;

- (NSInteger)peripheralsCount;

- (id)initWithDeviceTypes:(NSArray *)deviceTypes rssiMin:(int)rssiMin;

#pragma mark add/remove delegate
- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;

#pragma mark connect/disconnect BLE
- (void)reset;
- (void)scanPeripherals;
- (void)connect:(NSDictionary *)deviceIDToAdvertiseNameMap;
- (void)disconnect:(NSString *)deviceID;
- (void)connectWithSerialNO:(NSDictionary *)serialNOToAdvertiseNameMap;
- (void)disconnectWithSerialNO:(NSString *)serialNO;
- (void)connect;
- (void)disconnect;

#pragma mark write data to SENSSUNFAT
//发送测试脂肪命令,脂肪秤使用
//(sex表示性别，0-女,1-男)，
//(userID表示用户序号，值范围1～12)，
//(age表示年龄，值范围10～100)，
//(heightCM表示身高，单位cm，值范围10～100)，
//(heightInch表示身高，单位英寸，值范围100～250)
- (void)sendSENSSUNFATTestFatWithSex:(int)sex userID:(int)userID age:(int)age heightCM:(int)heightCM heightInch:(int)heightInch peripheral:(CBPeripheral *)peripheral;

//发送查询历史数据命令，脂肪秤使用
//(userID表示用户序号，值范围1～12)
- (void)sendSENSSUNFATSearchHistoryWithUserID:(int)userID peripheral:(CBPeripheral *)peripheral;

#pragma mark write data to SSBLESENSSUNBODYCLOCK
//发送闹钟设置指令，闹钟秤使用
//（repeatSun表示闹钟在星期日是否执行，1－是，0－否）
//（repeatMon表示闹钟在星期一是否执行，1－是，0－否）
//（repeatTue表示闹钟在星期二是否执行，1－是，0－否）
//（repeatWed表示闹钟在星期三是否执行，1－是，0－否）
//（repeatThu表示闹钟在星期四是否执行，1－是，0－否）
//（repeatFri表示闹钟在星期五是否执行，1－是，0－否）
//（repeatSat表示闹钟在星期六是否执行，1－是，0－否）
//（hour表示设置闹钟执行在哪一小时，值范围0～23）
//（minute表示设置闹钟执行在哪一分钟，值范围0～59）
//（tone表示设置哪一首铃声，值范围0~14）铃声文件在文件夹Tones下
//0.秋日私语               tone1.aac
//1.杜鹃圆舞曲              tone2.aac
//2.柴可夫斯基1812序曲      tone3.aac
//3.钢琴奏鸣曲              tone4.aac
//4.土耳其进行曲            tone5.aac
//5.胡桃夹子_进行曲          tone6.aac
//6.胡桃夹子_俄罗斯舞        tone7.aac
//7.我心永恒                tone8.aac
//8.小天鹅之舞              tone9.aac
//9.恭喜！恭喜！             tone10.aac
//10.机器猫                 tone11.aac
//11.我在那一角落患过伤风     tone12.aac
//12.生日快乐               tone13.aac
//13.圣诞老公公进城来         tone14.aac
//14.嘀嘀嘀！               tone15.aac
// (index表示设置秤体第几个闹钟，当为体重闹钟秤时，index仅为0，当为体脂闹钟秤时，index值范围0－2)
- (void)sendSENSSUNBODYCLOCKSetting:(CBPeripheral *)peripheral :(int)repeatSun :(int)repeatMon :(int)repeatTue :(int)repeatWed :(int)repeatThu :(int)repeatFri :(int)repeatSat :(int)hour :(int)minute :(int)tone :(int)index;

#pragma mark write data to SENSSUNSUPERFAT
//发送测试脂肪命令,八电极使用
//(sex表示性别，0-女,1-男)，
//(userID表示用户序号，值范围1～12)，
//(age表示年龄，值范围10～100)，
//(heightCM表示身高，单位cm，值范围10～100)，
//(heightInch表示身高，单位英寸，值范围100～250)
- (void)sendSENSSUNSUPERFATTestFatWithSex:(int)sex userID:(int)userID age:(int)age heightCM:(int)heightCM heightInch:(int)heightInch peripheral:(CBPeripheral *)peripheral;

#pragma mark write data to SENSSUNGROWTH
//发送新增用户命令
//(userNO表示用户序号，值范围1-8),
- (void)sendSENSSUNGROWTHUserAdd:(int)userNO :(CBPeripheral *)peripheral;
//发送删除用户命令
//(userNO表示用户序号，值范围1-8),
- (void)sendSENSSUNGROWTHUserDelete:(int)userNO :(CBPeripheral *)peripheral;
//发送设置用户命令
//(userNO表示用户序号，值范围1-8),
- (void)sendSENSSUNGROWTHUserSet:(int)userNO :(CBPeripheral *)peripheral;
//发送浅度同步用户数据命令
//(userNO表示用户序号，值范围1-8),
- (void)sendSENSSUNGROWTHSyncDataShallow:(int)userNO :(CBPeripheral *)peripheral;
//发送深度同步用户数据命令
//(userNO表示用户序号，值范围1-8),
- (void)sendSENSSUNGROWTHSyncDataDeep:(int)userNO :(CBPeripheral *)peripheral;

@end
