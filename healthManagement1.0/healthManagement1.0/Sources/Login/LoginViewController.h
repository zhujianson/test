//
//  LoginViewController.h
//  waimaidan2.0
//
//  Created by sunzhf on 13-4-3.
//  Copyright (c) 2013年 qianliqianxun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSCheckBoxView.h"
#import "Common.h"

@interface LoginViewController : CommonViewController<UITextFieldDelegate, UIActionSheetDelegate,UIAlertViewDelegate>{
    
//    UITextField *m_txtURL;
}
- (void)setFid:(id)vc;
- (void)setAutomaticLogin;
@property (nonatomic,retain) UIImageView * m_LaunchImage;

@end
