//
//  AddDeviceViewController.h
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-8-20.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYBankCardFormatTextField.h"

@interface AddDeviceViewController : CommonViewController <UITextFieldDelegate,UIImagePickerControllerDelegate,UIWebViewDelegate>
{
    UITextField *m_userName;
}
@property (nonatomic,assign) int temp;
@property (nonatomic,assign) NSString* modelid;
@property (nonatomic,assign) NSString* device_no;

@end