//
//  AlertView.h
//  healthManagement1.0
//
//  Created by xuguohong on 16/7/12.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^alertViewBlock)(void);

@interface AlertView : UIView

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIButton *butOK;
@property (nonatomic, copy) alertViewBlock ablock;

@end






@interface AlertInputView : UIView <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *inputText;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIButton *butOK;
@property (nonatomic, copy) alertViewBlock ablock;

@end