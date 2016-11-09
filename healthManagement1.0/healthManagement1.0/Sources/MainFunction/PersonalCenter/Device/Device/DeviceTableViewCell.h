//
//  DeviceTableViewCell.h
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-8-20.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceViewController.h"

@protocol MyDeviceDelegate <NSObject>

- (void)butEventDel:(NSDictionary*)dic;

@end

@interface DeviceTableViewCell : UITableViewCell
{
    UILabel *m_labDeviceName;
    UILabel *m_labChangjia;
    UIImageView *m_imageDeviceIcon;
}
@property (nonatomic, assign) NSDictionary *m_infoDic;
@property (nonatomic, assign) UIImageView *m_imageDeviceIcon;
@property (nonatomic, assign) DeviceViewController *m_device;

@property (nonatomic, assign) id <MyDeviceDelegate> delegate;
- (void)setIconImage:(UIImage *)image;

- (void)changeStateWithConnectState:(BOOL)state;

@end
