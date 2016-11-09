//
//  EnterWeightView.m
//  healthManagement1.0
//
//  Created by jiuhao-yangshuo on 16/6/3.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "EnterWeightView.h"

@interface EnterWeightView()<UITextFieldDelegate>

@end


static float UI_leftMargin = 25.0;
@interface EnterWeightView()
{
    KXBasicBlock m_callBackBlock;
    UIView* m_view;
    UITextField *m_textField;
    NSString *m_weekTargetWeight;
}
@end


@implementation EnterWeightView

-(id)initWithKXPayManageViewBlock:(KXBasicBlock)block
{
    CGRect frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self)
    {
        m_callBackBlock = [block copy];
        m_view = [[UIView alloc] initWithFrame:frame];
        m_view.backgroundColor = [UIColor clearColor];
        [self addSubview:m_view];
    }
    return self;
}

- (void )createShowView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(UI_leftMargin, 0, kDeviceWidth-2*UI_leftMargin, 440/2.0)];
    view.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];
    view.layer.cornerRadius = 4.0f;
    view.layer.masksToBounds = YES;
    m_view.userInteractionEnabled = YES;
    m_view = view;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(butEventClose)];
    [m_view addGestureRecognizer:tap];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, 55)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [CommonImage colorWithHexString:@"666666"];
    [view addSubview:titleLabel];
    titleLabel.text = @"温馨提示";
    
    //关闭
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(view.size.width-30, 14, 15, 15);
    [closeBtn setImage:[UIImage imageNamed:@"common.bundle/common/search_close_icon_nor.png"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"common.bundle/common/search_close_icon_pre.png"] forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(butEventClose) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:closeBtn];
    
    //分割线
    UIView *alineView  = [[UIView alloc] initWithFrame:CGRectMake(15, titleLabel.size.height-0.5,titleLabel.size.width-15*2, 0.5)];
    alineView.backgroundColor =  [CommonImage colorWithHexString:@"dcdcdc"];
    [titleLabel addSubview:alineView];
    
    UILabel *tipLab = [Common createLabel:CGRectMake(0, alineView.bottom, titleLabel.width,70) TextColor:@"333333" Font:[UIFont systemFontOfSize:16.0] textAlignment:NSTextAlignmentCenter labTitle:@"本周任务已全部完成\n赶快测测您的当前体重吧"];
    tipLab.numberOfLines = 0;
    [view addSubview:tipLab];
    
    UIView *enterView = [[UIView alloc] initWithFrame:CGRectMake(UI_leftMargin, tipLab.bottom, view.width-2*UI_leftMargin, 60.0)];
    enterView.backgroundColor = [CommonImage colorWithHexString:@"fafafa"];
    enterView.layer.cornerRadius = 3.0f;
    enterView.layer.masksToBounds = YES;
    enterView.layer.borderWidth = 0.5;
    enterView.layer.borderColor = [CommonImage colorWithHexString:@"ebebeb"].CGColor;
    [view  addSubview:enterView];
    
    m_textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 180, enterView.height)];
    m_textField.delegate = self;
    m_textField.textColor = [CommonImage colorWithHexString:@"666666"];
    m_textField.font = [UIFont systemFontOfSize:30.];
    m_textField.textAlignment = NSTextAlignmentCenter;
    m_textField.keyboardType = UIKeyboardTypeDecimalPad;
    [enterView addSubview:m_textField];
    [m_textField becomeFirstResponder];
    
    UIImage *image = [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
    UIButton * determine = [UIButton buttonWithType:UIButtonTypeCustom];
    determine.tag = 110;
    determine.frame = CGRectMake(m_textField.right, 0, enterView.width-m_textField.width, enterView.height);
    [determine addTarget:self action:@selector(saveDataFunc) forControlEvents:UIControlEventTouchUpInside];
    [determine setTitle:@"确定" forState:UIControlStateNormal];
    determine.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [determine setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [determine setBackgroundImage:image forState:UIControlStateNormal];
    determine.clipsToBounds = YES;
    [enterView addSubview:determine];
 
    m_weekTargetWeight = [NSString stringWithFormat:@"%.1f",[_infoDict[kWeight] floatValue]-0.5];
    m_textField.text = m_weekTargetWeight;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self butEventClose];
}

-(void)btnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 110:
            [self butEventClose];
            break;
        case 111:
            [self saveDataFunc];
            break;
        default:
            break;
    }
}

#pragma mark - 手势处理
//保存按钮响应
- (void)saveDataFunc
{
    
    if (m_textField.text.floatValue > 2.5+m_weekTargetWeight.floatValue)
    {
        [Common MBProgressTishi:@"本周增重大于2.5kg，请核实！" forHeight:kDeviceHeight];
        return;
    }
    else if (m_textField.text.floatValue < m_weekTargetWeight.floatValue -2.5)
    {
        [Common MBProgressTishi:@"本周减重大于2.5kg，请核实！" forHeight:kDeviceHeight];
        return;
    }
    
    NSString *content =  [NSString stringWithFormat:@"%.1f",m_textField.text.floatValue];
    if (m_callBackBlock)
    {
        m_callBackBlock(content);
    }
    [self hide];
}

- (void)butEventClose
{
    [self hide];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap
{
    [self hide];
}

- (void)hide
{
    [m_textField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        m_view.alpha = 0;
        m_view.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:^(BOOL finished) {
        [m_view removeFromSuperview];
        m_view = nil;
        [self removeFromSuperview];
    }];
}

-(void)dismiss:(BOOL)animate
{
    [UIView animateWithDuration:0.3 animations:^{
//        m_tableView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        m_view.backgroundColor = [UIColor clearColor];
        [self removeFromSuperview];
    }];
}

- (void)show
{
    [self createShowView];
    m_view.center = CGPointMake(kDeviceWidth/2, (kDeviceHeight+44)/2);
    m_view.alpha = 0.2;
    m_view.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [self addSubview:m_view];
    
    UIWindow *window = APP_DELEGATE;
    [window addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        m_view.alpha = 1;
        m_view.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL f){
        [UIView animateWithDuration:0.1 animations:^{
            m_view.transform = CGAffineTransformIdentity;
        }];
    }];
    
    WS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf becomeFirstResponder];
    });
}

-(void)becomeFirst
{
    [m_textField becomeFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    [UIView animateWithDuration:0.35 animations:^{
        if (self.height-220>m_view.height) {
            m_view.center = CGPointMake(kDeviceWidth/2, (self.height-140)/2);
        }else{
            m_view.center = CGPointMake(kDeviceWidth/2, m_view.height/2);
        }
    }];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField*)textField
{
    return YES;
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSMutableString *changeString = [NSMutableString stringWithString:textField.text];
    [changeString replaceCharactersInRange:range withString:string];
    NSInteger num = [textField.text containsString:@"."]?5:4;
    if ([changeString length] > num) {
        return NO;
    }
    return [Common textField:textField replacementString:string];
}


+(void)showEnterWeightViewWithBlock:(KXBasicBlock)block  withDict:(NSDictionary *)dict
{
    EnterWeightView *payView = [[EnterWeightView alloc] initWithKXPayManageViewBlock:block];
    payView.infoDict = dict;
    [APP_DELEGATE addSubview:payView];
    [payView show];
}
@end
