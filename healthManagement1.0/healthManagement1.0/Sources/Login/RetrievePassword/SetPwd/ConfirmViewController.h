//
//  ConfirmViewController.h
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-19.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "Common.h"

@interface ConfirmViewController : CommonViewController<UITextFieldDelegate>
{
    int _type;
    UITextField *m_txtUserName;
    UITextField *m_txtPassWord;

}
@property (nonatomic,copy) NSString* phoneStr;
@property (nonatomic,copy) NSString* verificationStr;//验证码

- (id)initWithType:(int)type;

@end
