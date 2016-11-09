//
//  EditPwdViewController.h
//  jiuhaoHealth2.0
//
//  Created by 徐国洪 on 14-3-20.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface EditPwdViewController : CommonViewController <UITextFieldDelegate, UIAlertViewDelegate>
{
	UITextField *m_textOldPwd;
	UITextField *m_textNewPwd1;
	UITextField *m_textNewPwd2;
}

@end
