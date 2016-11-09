//
//  ScanDeviceListViewCell.m
//  healthManagement1.0
//
//  Created by jiuhao-yangshuo on 16/2/23.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "ScanDeviceListViewCell.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "CBPeripheralAdditions.h"
#import "SSBLEDevice.h"

@implementation ScanDeviceListViewCell
{
    UILabel *nameLable;
    UIImageView * headerImage;
    UIView *m_backView;
    UILabel *numLable;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, kDeviceWidth-60, kScanDeviceListViewCellH-15)];
        [self.contentView addSubview:backView];
        m_backView = backView;
        backView.layer.cornerRadius = 2.5;
        backView.layer.masksToBounds = YES;
        backView.layer.borderColor = [CommonImage colorWithHexString:@"dcdcdc"].CGColor;
        backView.layer.borderWidth = 0.5;
        
        float spaceImageW = backView.height-2*10.0;
        headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, (backView.height-spaceImageW)/2.0, spaceImageW, spaceImageW)];
        headerImage.clipsToBounds = YES;
        [backView addSubview:headerImage];
        
        nameLable = [Common createLabel:CGRectMake(headerImage.right+15, headerImage.top,kDeviceWidth-headerImage.right-30, 30) TextColor:@"333333" Font:[UIFont systemFontOfSize:M_FRONT_SEVENTEEN] textAlignment:NSTextAlignmentLeft labTitle:@"123"];
        [backView addSubview:nameLable];
        
        numLable = [Common createLabel:CGRectMake(nameLable.left, nameLable.bottom,nameLable.width, 20) TextColor:@"333333" Font:[UIFont systemFontOfSize:M_FRONT_FOURTEEN] textAlignment:NSTextAlignmentLeft labTitle:@"123"];
        [backView addSubview:numLable];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor =[CommonImage colorWithHexString:@"f5f5f5"];
    }
    return self;
}

- (void)dealloc
{
    nameLable = nil;
    headerImage = nil;
}

-(void)setM_deviceModel:(DeviceModel *)m_deviceModel
{
    headerImage.image = [UIImage imageNamed:@"common.bundle/personnal/device/weigthDeviceIcon.png"];
    nameLable.text = @"康迅体重称";
    numLable.text = @"设备编号";
}

- (void)loadData:(id)obj {
    
    headerImage.image = [UIImage imageNamed:@"common.bundle/personnal/device/weigthDeviceIcon.png"];
    nameLable.text = @"康迅体重称";
    
    CBPeripheral *peripheral = (CBPeripheral *)obj;
    
    int deviceType = peripheral.deviceType.intValue;
    if (deviceType == SSBLESENSSUNBODY) {
        numLable.text = [NSString stringWithFormat:@"香山体重秤: %@\r\nSerialNO:%@", peripheral.deviceID, peripheral.serialNO];
    } else if (deviceType == SSBLESENSSUNFAT) {
        numLable.text = [NSString stringWithFormat:@"香山体脂秤: %@\r\nSerialNO:%@", peripheral.deviceID, peripheral.serialNO];
    }
    NSString *_rssiLabel = [NSString stringWithFormat:@"%d dBm", peripheral.newRSSI.intValue];
    NSLog(@"_rssiLabel:%@",_rssiLabel);
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    m_backView.backgroundColor = [CommonImage colorWithHexString:highlighted? @"ebebeb":@"ffffff"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    m_backView.backgroundColor = [CommonImage colorWithHexString:selected? @"ebebeb":@"ffffff"];
    // Configure the view for the selected state
}
@end
