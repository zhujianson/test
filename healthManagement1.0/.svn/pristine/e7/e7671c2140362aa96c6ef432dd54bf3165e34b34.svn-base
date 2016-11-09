//
//  RetrievePasswordViewController.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-4.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "RetrievePasswordViewController.h"
#import "CommonHttpRequest.h"
#import "SFHFKeychainUtils.h"
#import "ChangesReginViewController.h"
#import "SFHFKeychainUtils.h"
#import "RetrievePasswordViewController.h"
#import "AccountInformationViewController.h"
#import "PerfectInformation.h"
#import "ConfirmViewController.h"
#import "HMHomeViewController.h"

@interface RetrievePasswordViewController ()<UIScrollViewDelegate>

@end

@implementation RetrievePasswordViewController
{
    NSDictionary * textDic;
    int timing;
    NSTimer * time;
    UITextField *m_phone;
    UITextField *m_pwd;

    NSString * phoneStr;
    
    UITextField *m_txtUserName;
    UITextField *m_txtPassWord;
    UITextField *m_usernoWord;

}
- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)dealloc
{
    [m_pwd release];
    [m_phone release];
    if (m_txtPassWord) {
        [m_txtPassWord release];
        [m_txtUserName release];
        [m_usernoWord release];
    }
    [_thirdStr release];
    [textDic release];
    
    [super dealloc];
}

- (id)initWithType:(int)type
{
    self = [super init];
    if (self) {
        // Custom initialization
        _type = type;
        if (!type) {
            self.title = @"密码找回";
        } else {
            self.title = @"用户注册";
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self creatPhoneView];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (time) {
        [time invalidate];
        time = nil;
    }
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
//    if(IOS_7){
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    }
    [super viewWillAppear:animated];
}

- (void)creatPhoneView
{
    timing = 90;
    UIScrollView * m_scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    m_scroll.backgroundColor = [UIColor clearColor];
    m_scroll.delegate = self;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resigin)];
    [m_scroll addGestureRecognizer:tap];
    [tap release];
    
    UIView *cleanView = [self creatView];
    [m_scroll addSubview:cleanView];
    //    [cleanView release];
    
    UIButton *btn_activate = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_activate.layer.cornerRadius = 4;
    if (_type) {
        
        UIView* backView = [[UIView alloc] initWithFrame:CGRectMake(0, cleanView.bottom+20, kDeviceWidth, 90)];
        backView.layer.borderWidth = 0.5;
        backView.layer.borderColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN].CGColor;
        backView.backgroundColor = [UIColor whiteColor];
        [m_scroll addSubview:backView];
        [backView release];
        
        UILabel * lab;
        for (int i = 0; i<2; i++) {
            lab = [Common createLabel:CGRectMake(20, i*45, 85, 45) TextColor:@"333333" Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft labTitle:!i?@"密码":@"确认密码"];
            [backView addSubview:lab];
        }
        
        m_txtUserName = [self createTextField:NSLocalizedString(@"输入密码:", nil)];
        m_txtUserName.returnKeyType = UIReturnKeyDone;
        [m_txtUserName setSecureTextEntry:YES];
        m_txtUserName.font = [UIFont systemFontOfSize:16];
        //    m_txtUserName.keyboardType = UIKeyboardTypeNamePhonePad;
        m_txtUserName.frame = CGRectMake(105, 0, kDeviceWidth-115, 45);
        [backView addSubview:m_txtUserName];
        m_txtPassWord = [self createTextField:NSLocalizedString(@"再次输入密码:", nil)];
        m_txtPassWord.returnKeyType = UIReturnKeyDone;
        [m_txtPassWord setSecureTextEntry:YES];
        
        m_txtPassWord.font = [UIFont systemFontOfSize:16];
        //    m_txtUserName.keyboardType = UIKeyboardTypeNamePhonePad;
        m_txtPassWord.frame = CGRectMake(m_txtUserName.left, 45, kDeviceWidth-115, 45);
        [backView addSubview:m_txtPassWord];
        
        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 45, kDeviceWidth-20, 0.5)];
        lineView.backgroundColor = [CommonImage colorWithHexString:@"f4f4f4"];
        [backView addSubview:lineView];
        [lineView release];
        btn_activate.frame = CGRectMake(20, backView.bottom+50, kDeviceWidth-40, 44);
    }else{
    btn_activate.frame = CGRectMake(20, cleanView.bottom+50, kDeviceWidth-40, 44);
    }
    NSLog(@"%f",btn_activate.frame.origin.y);
    [btn_activate setTitleColor:[CommonImage colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
    btn_activate.layer.cornerRadius = 4;
    btn_activate.clipsToBounds = YES;

    [btn_activate setBackgroundImage:image forState:UIControlStateNormal];
    btn_activate.titleLabel.font = [UIFont systemFontOfSize:20];
    [btn_activate addTarget:self action:@selector(butEventOK) forControlEvents:UIControlEventTouchUpInside];
    [m_scroll addSubview:btn_activate];
    [btn_activate setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
    
    UILabel* textLab = [Common createLabel:CGRectMake(20, 0, kDeviceWidth-40, 30) TextColor:@"666666" Font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentLeft labTitle:[NSString stringWithFormat:@"港澳台地区将在2分钟内送达,请耐心等待!"]];
    textLab.numberOfLines = 0;
    [m_scroll addSubview:textLab];
    
    textLab = [Common createLabel:CGRectMake(20, btn_activate.bottom+15, kDeviceWidth-40, 20) TextColor:@"999999" Font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft labTitle:[NSString stringWithFormat:@"如有疑问请咨询客服电话:"]];
    [m_scroll addSubview:textLab];
    
    UIButton * phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneBtn.frame = CGRectMake(14*11.5+20, btn_activate.bottom+15, 110, 20);
    [phoneBtn setTitleColor:[CommonImage colorWithHexString:COLOR_FF5351] forState:UIControlStateNormal];
    phoneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [phoneBtn setTitle:HOTLINEPHONE forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(isPhone) forControlEvents:UIControlEventTouchUpInside];
    [m_scroll addSubview:phoneBtn];

    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(14*11.5+20, phoneBtn.bottom, phoneBtn.width, 1)];
    lineView.backgroundColor = [CommonImage colorWithHexString:COLOR_FF5351];
    [m_scroll addSubview:lineView];
    [lineView release];
    
    m_scroll.contentSize = CGSizeMake(0, lineView.bottom+20);
    [self.view addSubview:m_scroll];
    [m_scroll release];

}

- (void)isPhone
{
    UIActionSheet* sheet = [[UIActionSheet alloc]
                            initWithTitle:nil
                            delegate:self
                            cancelButtonTitle:@"取消"
                            destructiveButtonTitle:HOTLINEPHONE
                            otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
    [sheet release];
}

- (void)actionSheet:(UIActionSheet*)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex) {
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",HOTLINEPHONE]]];
    }
}

- (UIView*)creatView
{
    UIView* cleanView = [[[UIView alloc] initWithFrame:CGRectMake(0,30, kDeviceWidth, 45*3)]autorelease];
    cleanView.backgroundColor = [UIColor whiteColor];
    cleanView.layer.borderWidth = 0.5;
    cleanView.layer.borderColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN].CGColor;
    
    UIImageView * rigthImage = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-27, (44-7)/2, 13/2, 21/2)];
    rigthImage.image = [UIImage imageNamed:@"common.bundle/common/right-arrow_pre.png"];
    
    [cleanView addSubview:rigthImage];
    [rigthImage release];
    
    UILabel *textLab = [Common createLabel:CGRectMake(20, 0, kDeviceWidth, 44) TextColor:@"333333" Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft labTitle:@"中国大陆"];
    textLab.userInteractionEnabled = YES;
    textLab.tag = 11;
    [cleanView addSubview:textLab];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeRegin)];
    [textLab addGestureRecognizer:tap];
    [tap release];
    
    UILabel *labFuwu = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 85, 45)];
    labFuwu.backgroundColor = [UIColor clearColor];
    labFuwu.textColor = [CommonImage colorWithHexString:@"333333"];
    labFuwu.tag = 12;
    labFuwu.text = NSLocalizedString(@"(0086)", nil);
    labFuwu.font = [UIFont systemFontOfSize:16];
    [cleanView addSubview:labFuwu];
    [labFuwu release];
    
    NSString *str = [NSString stringWithFormat:@"请输入手机号"];
    m_phone = [self createTextField:NSLocalizedString(str, nil)];
    m_phone.keyboardType = UIKeyboardTypeNumberPad;
    
    [m_phone setTextColor:[CommonImage colorWithHexString:@"#666666"]];
    [m_phone setFont:[UIFont systemFontOfSize:17]];
    m_phone.returnKeyType = UIReturnKeyNext;
    m_phone.tag = 201;
    m_phone.frame = CGRectMake(105, 45, kDeviceWidth-195, 45);
    [cleanView addSubview:m_phone];
    //	[m_userName becomeFirstResponder];
    
    UIButton *butSend = [UIButton buttonWithType:UIButtonTypeCustom];
    butSend.tag = 99;
    butSend.adjustsImageWhenHighlighted = YES;
    butSend.frame = CGRectMake(kDeviceWidth-15-70, m_phone.origin.y+9, 70, 27);
    [butSend setTitleColor:[CommonImage colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    butSend.layer.cornerRadius = 4;
    butSend.clipsToBounds = YES;
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
    [butSend setBackgroundImage:image forState:UIControlStateNormal];
    [butSend setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
    butSend.titleLabel.font = [UIFont systemFontOfSize:12];
    [butSend addTarget:self action:@selector(butEventSend) forControlEvents:UIControlEventTouchUpInside];
    [cleanView addSubview:butSend];
    
    
    UILabel *labHuanjing = [[UILabel alloc] initWithFrame:CGRectMake(19, 45*2, 60, 45)];
    labHuanjing.backgroundColor = [UIColor clearColor];
    labHuanjing.textColor = [CommonImage colorWithHexString:@"333333"];
    labHuanjing.text = NSLocalizedString(@"验证码", nil);
    labHuanjing.font = [UIFont systemFontOfSize:16];
    [cleanView addSubview:labHuanjing];
    [labHuanjing release];

    m_pwd = [self createTextField:NSLocalizedString(@"请输入验证码", nil)];
    m_pwd.returnKeyType = UIReturnKeyDone;
//    m_pwd.keyboardType = UIKeyboardTypeNumberPad;
    m_pwd.tag = 202;
    m_pwd.delegate = self;
    m_pwd.frame = CGRectMake(105, 45*2, kDeviceWidth-115, 45);
    [cleanView addSubview:m_pwd];
    
    UIView *view;
    for (int i =1; i<3; i++) {
        view = [[UIView alloc] initWithFrame:CGRectMake(16, 45*i, kDeviceWidth-20, 0.5)];
        view.backgroundColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
        [cleanView addSubview:view];
        [view release];
    }
    
    return cleanView;
}

- (void)changeRegin
{
    NSLog(@"4444");
    ChangesReginViewController * change = [[ChangesReginViewController alloc]init];
    change.textDic = textDic;
    [change setChangesReginBlock:^(NSDictionary *dic) {
        UILabel * lab = (UILabel*)[self.view viewWithTag:11];
        lab.text = dic[@"regin"];
        lab = (UILabel*)[self.view viewWithTag:12];
        lab.text = [NSString stringWithFormat:@"(%@)",dic[@"num"]];
        
        textDic = [dic retain];
        
        if (![textDic[@"regin"] isEqualToString:@"中国大陆"] && textDic) {
            timing = 90*2;
        }else{
            timing = 90;
        }
        
    }];
    [self.navigationController pushViewController:change animated:YES];
    [change release];
}


- (UITextField*)createTextField:(NSString*)title
{
    UITextField* text = [[UITextField alloc] init];
    text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    text.contentMode = UIViewContentModeCenter;
    text.autocapitalizationType = UITextAutocapitalizationTypeNone;
    text.placeholder = title;
    text.clearButtonMode = YES;
    text.delegate = self;
    [text setTextColor:[CommonImage colorWithHexString:@"#666666"]];
    [text setFont:[UIFont systemFontOfSize:17]];
    return text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *changeString = [NSMutableString stringWithString:textField.text];
    [changeString replaceCharactersInRange:range withString:string];
    if (textField == m_phone) {
        if ([changeString length]>11) {
            return NO;
        }
    }else if(textField == m_pwd){
        if ([changeString length]> 8) {
            return NO;
        }
    }else if(textField == m_txtUserName || textField == m_txtPassWord){
        if ([changeString length]> 14) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case 201:
            [m_phone becomeFirstResponder];
            break;
        case 202:
            [m_pwd resignFirstResponder];
            break;
        default:
            [textField resignFirstResponder];
            break;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    if (textField == m_txtUserName || textField == m_txtPassWord) {
        if (kDeviceHeight<480) {
            [UIView animateWithDuration:0.35 animations:^{
                self.view.frame = [Common rectWithOrigin:self.view.frame x:0 y:self.view.frame.origin.y-150];
            }];
        }
    }
    if (textField == m_usernoWord) {
        if (kDeviceHeight-260 < 385) {
            [UIView animateWithDuration:0.35 animations:^{
                self.view.frame = [Common rectWithOrigin:self.view.frame x:0 y:kDeviceHeight-260-385];
            }];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField*)textField
{
    if (textField == m_txtUserName || textField == m_txtPassWord) {
    if (kDeviceHeight<480) {
        [UIView animateWithDuration:0.35 animations:^{
            if (IOS_7) {
                self.view.frame = [Common rectWithOrigin:self.view.frame x:0 y:self.view.frame.origin.y+150];
            }else{
                self.view.frame = APP_DELEGATE.frame;
            }
        }];
    }
    }
    if (textField == m_usernoWord) {
        if (kDeviceHeight-260 < 385) {
            [UIView animateWithDuration:0.35 animations:^{
                if (IOS_7) {
                    self.view.frame = [Common rectWithOrigin:self.view.frame x:0 y:64];
                }else{
                    self.view.frame = APP_DELEGATE.frame;
                }
            }];
        }
    }

    return YES;
}

- (void)HideKeyboard
{
    [m_phone resignFirstResponder];
    [m_pwd resignFirstResponder];
    [m_txtPassWord resignFirstResponder];
    [m_txtUserName resignFirstResponder];
}

- (void)butEventSend
{
    if (m_phone.text.length == 0) {
        NSString *str = [NSString stringWithFormat:@"请输入手机号"];
        [Common TipDialog:NSLocalizedString(str, nil)];
        [m_phone becomeFirstResponder];
        return;
    }
    [self HideKeyboard];
    phoneStr = m_phone.text;
    if (![textDic[@"regin"] isEqualToString:@"中国大陆"] && textDic) {
        phoneStr = [NSString stringWithFormat:@"%@%@",textDic[@"num"],m_phone.text];
    }

//        // 找回密码验证码
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:phoneStr forKey:@"phone"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:CHECKPHOTO_API_URL values:dic requestKey:CHECKPHOTO_API_URL delegate:self controller:self actiViewFlag:0 title:NSLocalizedString(@"加载中...", nil)];
}

- (void)timeBegin
{
    timing--;
    UIButton * btn = (UIButton*)[self.view viewWithTag:99];
    UILabel * lab = (UILabel*)[self.view viewWithTag:11];
    lab.userInteractionEnabled = NO;
    if (timing==0) {
        [btn setTitle:NSLocalizedString(@"重新获取", nil) forState:UIControlStateNormal];
        [time invalidate];
        time = nil;
        if (![textDic[@"regin"] isEqualToString:@"中国大陆"] && textDic) {
            timing = 90*2;
        }else{
            timing = 90;
        }
        btn.userInteractionEnabled = YES;
        lab.userInteractionEnabled = YES;
        return;
    }
    [btn setTitle:[NSString stringWithFormat:@"%d",timing] forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
    NSLog(@"%d",timing);
}

- (void)butEventOK
{
//    PerfectInformation * regis = [[PerfectInformation alloc]init];
//    regis.whichStep = 1;
//    regis.photoStr = phoneStr;
//    regis.pasWod = m_txtPassWord.text;
//    [self.navigationController pushViewController:regis animated:YES];
//    [regis release];
//    return;
    
    if (m_phone.text.length == 0) {
        NSString *str = [NSString stringWithFormat:@"请输入手机号"];
        [Common TipDialog2:NSLocalizedString(str, nil)];
        [m_phone becomeFirstResponder];
        return;
    }
    if ([m_pwd.text length] == 0) {
        [Common TipDialog2:@"验证码不能为空"];
        return;
    }
    [self HideKeyboard];
    if (!phoneStr) {
        phoneStr = m_phone.text;
        if (![textDic[@"regin"] isEqualToString:@"中国大陆"] && textDic) {
            phoneStr = [NSString stringWithFormat:@"%@%@",textDic[@"num"],m_phone.text];
        }
    }
    if (!_type) {
        NSLog(@"设置密码");
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        [dic setObject:phoneStr forKey:@"phone"];
        [dic setObject:m_pwd.text forKey:@"code"];
        [[CommonHttpRequest defaultInstance] sendNewPostRequest:EMAILTWO_API_URL values:dic requestKey:EMAILTWO_API_URL delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"加载中...", nil)];

    } else {
        if ([self judgeThePass]) {
            return;
        }
        // 注册帐号
        [self setPow];
    }
}

- (BOOL)judgeThePass
{
    if ([m_txtUserName.text length] == 0 ) {
        [Common TipDialog2:@"密码不能为空"];
        return YES;
    }else if ([m_txtPassWord.text length] == 0) {
        [Common TipDialog2:@"确认密码不能为空"];
        return YES;
   }else if ([m_txtUserName.text length] < 6) {
        [Common TipDialog2:@"密码长度必须大于6位"];
        return YES;
    }else if (![m_txtUserName.text isEqualToString:m_txtPassWord.text]) {
        [Common createAlertViewWithString:@"两次输入的密码不一致！" withDeleagte:nil];
        return YES;
     }
    return NO;
}


- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}

- (void)didFinishSuccess:(ASIHTTPRequest*)loader
{
    NSString* responseString = [loader responseString];
    NSDictionary* dict = [responseString KXjSONValueObject];
    NSDictionary * dic = dict[@"head"];
    
    if([loader.username isEqualToString:CHECKPHOTO_API_URL])
    {
        BOOL isBegin = NO;
        if (!_type) {
            // 找回密码验证码
            if ([[dic objectForKey:@"state"] intValue] == 0) {
                isBegin = YES;
            }else{
                [Common TipDialog:dic[@"msg"]];
            }
        } else {
            if ([[dic objectForKey:@"state"] intValue] != 0) {
                isBegin = YES;
            }else{
                [Common TipDialog:dic[@"msg"]];
            }
        }
        if (isBegin) {
            //90秒倒计时
            time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeBegin) userInfo:nil repeats:YES];
            [time fire];
            //        佼验手机号是否存在  找回密码需求
            NSMutableDictionary* dic = [NSMutableDictionary dictionary];
            [dic setObject:phoneStr forKey:@"phone"];
            [[CommonHttpRequest defaultInstance] sendNewPostRequest:REGISTER_API_URL values:dic requestKey:REGISTER_API_URL delegate:self controller:self actiViewFlag:0 title:NSLocalizedString(@"加载中...", nil)];
        }
        return;
    }
    
    if ([[dic objectForKey:@"state"] intValue] == 0) {
        
        if ([loader.username isEqualToString:REGISTER_APITWO_URL]) {
            [self setPow];
        }
        else if ([loader.username isEqualToString:EMAILTWO_API_URL]) {
            //找回密码
            [self stopRequest];

            ConfirmViewController* basic = [[ConfirmViewController alloc] initWithType:3];
            basic.verificationStr = m_pwd.text;
            basic.phoneStr = phoneStr;
            [self.navigationController pushViewController:basic animated:YES];
            [basic release];
        }
        else if([loader.username isEqualToString:REGISTER_APITHREE_URL]) {
            
            [self stopRequest];
            
            if ([m_usernoWord.text length]) {
                //该用户已在家人里存在，可以直接登录
                [self loading];
            } else {
                //注册完成
                PerfectInformation * regis = [[PerfectInformation alloc]init];
                regis.whichStep = 1;
                regis.photoStr = phoneStr;
                regis.pasWod = m_txtPassWord.text;
                [self.navigationController pushViewController:regis animated:YES];
                [regis release];
            }
            [self saveUserAccount];
            
        }
        else if ([loader.username isEqualToString:LOGIN_API_URL])
        {
            g_nowUserInfo = [Common initWithUserInfoDict:[dict objectForKey:@"body"]];
            //获取个人信息
            [self getMyInfo];
        }
        else if ([loader.username isEqualToString:GETMYINFO_API_URL])
        {
            [g_nowUserInfo setMyBasicInformation:[dict objectForKey:@"body"][@"user_info"]];
            [self goToMainViewController];
            
            [APP_DELEGATE2 setUserID:g_nowUserInfo.userid];
        }
    }
    else {
        if ([loader.username isEqualToString:REGISTER_API_URL] | [loader.username isEqualToString:EMAIL_API_URL]) {
            [self stopRequest];
        }
        else if ([loader.username isEqualToString:REGISTER_APITWO_URL]) {
            [Common TipDialog:[dict objectForKey:@"msg"]];
            
        }
        else if ([loader.username isEqualToString:EMAILTWO_API_URL]) {
            //找回密码
            [Common TipDialog:[dict objectForKey:@"msg"]];
            
        }
        else if([loader.username isEqualToString:REGISTER_APITHREE_URL]){
//            [self stopRequest];
        }
        [Common TipDialog:dic[@"msg"]];
    }
}

- (void)loading
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:phoneStr forKey:@"username"];
    [dic setObject:m_txtPassWord.text forKey:@"password"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:LOGIN_API_URL values:dic requestKey:LOGIN_API_URL delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"登录中...", nil)];
}


- (void)saveUserAccount
{
    NSString* name = phoneStr;
    NSString* pswd = m_txtPassWord.text;
    [SFHFKeychainUtils storeUsername:name andPassword:pswd forServiceName:BUNDLE_IDENTIFIER updateExisting:YES error:NULL];
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)setPow
{
    NSLog(@"设置密码");
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:phoneStr forKey:@"phone"];
    [dic setObject:m_txtPassWord.text forKey:@"password"];
    [dic setObject:m_pwd.text forKey:@"code"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:REGISTER_APITHREE_URL values:dic requestKey:REGISTER_APITHREE_URL delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"登录中...", nil)];

}

- (void)stopRequest
{
    UIButton * btn = (UIButton*)[self.view viewWithTag:99];
    UILabel * lab = (UILabel*)[self.view viewWithTag:11];

    [btn setTitle:NSLocalizedString(@"重新获取", nil) forState:UIControlStateNormal];
    [time invalidate];
    time = nil;
    if (![textDic[@"regin"] isEqualToString:@"中国大陆"] && textDic) {
        timing = 90*2;
    }else{
        timing = 90;
    }
    btn.userInteractionEnabled = YES;
    lab.userInteractionEnabled = YES;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self HideKeyboard];
}

- (void)resigin
{
    [self HideKeyboard];

}

- (BOOL)closeNowView
{
    [super closeNowView];
    
    [CommonImage popToNoNavigationView];
    return YES;
}



- (void)getMyInfo
{
    //获取个人信息
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GETMYINFO_API_URL values:dic requestKey:GETMYINFO_API_URL delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"获取个人信息...", nil)];
}

//进入首页
- (void)goToMainViewController
{
    HMHomeViewController* home = [[HMHomeViewController alloc] init];
    UIImage* nowViewImage = [CommonImage imageWithView:self.view];
    CommonNavViewController*view = [[CommonNavViewController alloc] initWithRootViewController:home];
    APP_DELEGATE.rootViewController = view;
    [view release];
    
    UIImageView* nowView = [[UIImageView alloc] initWithImage:nowViewImage];
    nowView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight + 64);
    [APP_DELEGATE addSubview:nowView];
    [nowView release];
    [APP_DELEGATE bringSubviewToFront:nowView];
    
    [UIView animateWithDuration:0.35 animations:^{
        nowView.transform = CGAffineTransformMakeTranslation(0, kDeviceHeight+64);
    } completion:^(BOOL finished) {
        [nowView removeFromSuperview];
    }];}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self HideKeyboard];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
