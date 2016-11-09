//
//  ScanningViewController.h
//  jiuhaohealth2.1
//
//  Created by xjs on 14-10-10.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZBarSDK.h"


typedef enum
{
    typeSaoDevice = 1,//设备
    typeSaoDoctor,//医生
    typeSaoBuddy,//
    typeSaoIdentity,//身份
    typeSaoAgent,//代理人
    
}ScanningType;


@interface ScanningViewController : CommonViewController<ZBarReaderDelegate,AVCaptureMetadataOutputObjectsDelegate,ZBarReaderViewDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    ZBarReaderView *readerView;
    
}
//@property (strong,nonatomic)AVCaptureDevice * device;
//@property (strong,nonatomic)AVCaptureDeviceInput * input;
//@property (strong,nonatomic)AVCaptureMetadataOutput * output;
//@property (strong,nonatomic)AVCaptureSession * session;
//@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) ScanningType sao_type;
@property (nonatomic, assign) NSString *m_userId;

@end