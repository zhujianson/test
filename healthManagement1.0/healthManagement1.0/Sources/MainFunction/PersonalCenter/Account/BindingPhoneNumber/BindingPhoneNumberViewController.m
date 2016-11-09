//
//  BindingPhoneNumberViewController.m
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-8-21.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "BindingPhoneNumberViewController.h"
#import "CommonHttpRequest.h"
#import "ChangesReginViewController.h"
#import "ConfirmViewController.h"
#import "LoginViewController.h"
#import "SFHFKeychainUtils.h"
#import "AppDelegate.h"

@interface BindingPhoneNumberViewController ()
{
    int timing;
    NSTimer * time;
    NSDictionary * textDic;
    BOOL changePhone;
}

@end

@implementation BindingPhoneNumberViewController
//@synthesize m_type;
@synthesize m_infoDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        changePhone = YES;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (time) {
        [time invalidate];
        time = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    timing = 90;
    
    UIView *cleanView = [self creatView];
    [self.view addSubview:cleanView];
//    [cleanView release];
    
    UIButton *btn_activate = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_activate.layer.cornerRadius = 4;
	btn_activate.frame = CGRectMake(20, cleanView.bottom+20, kDeviceWidth-40, 44);
	[btn_activate setTitleColor:[CommonImage colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
    [btn_activate setBackgroundImage:image forState:UIControlStateNormal];
	btn_activate.titleLabel.font = [UIFont systemFontOfSize:20];
	[btn_activate addTarget:self action:@selector(butEventOK) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn_activate];
    
    NSString * titleT;
//    if (g_nowUserInfo.mobilePhone.length) {
//        titleT = @"修改绑定";
//        [btn_activate setTitle:NSLocalizedString(@"确认修改", nil) forState:UIControlStateNormal];
//        UILabel* textLab = [Common createLabel:CGRectMake(20, 0, kDeviceWidth-40, 75) TextColor:@"666666" Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft labTitle:[NSString stringWithFormat:@"您目前绑定的手机号：%@\n(注：港澳台地区将在2分钟内送达，请耐心等待)",g_nowUserInfo.mobilePhone]];
//        textLab.numberOfLines = 0;
//        [self.view addSubview:textLab];
//    }else{
        titleT = @"绑定手机";
        changePhone = NO;
        [btn_activate setTitle:NSLocalizedString(@"绑定", nil) forState:UIControlStateNormal];
        
        UILabel* textLab = [Common createLabel:CGRectMake(20, 0, kDeviceWidth-40, 95) TextColor:@"666666" Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft labTitle:@"为了提供给您优质的健康服务，请您用实名手机号码完成注册！\n(注：港澳台地区将在2分钟内送达，请耐心等待)"];
        textLab.numberOfLines = 0;
        [self.view addSubview:textLab];
        textLab = [Common createLabel:CGRectMake(20, btn_activate.bottom, kDeviceWidth-40, 80) TextColor:@"6B6B6B" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft labTitle:@"太平吉象郑重声明：\n我们会以法律的名义确保您的安全不受任何侵犯！非常感谢您的信任和支持！"];
        textLab.numberOfLines = 0;
        [self.view addSubview:textLab];
    
//    }
    self.title = titleT;
}

- (UIView*)creatView
{
    UIView* cleanView = [[[UIView alloc] initWithFrame:CGRectMake(0,100, kDeviceWidth, 45*3)]autorelease];
    cleanView.backgroundColor = [UIColor whiteColor];
    
    cleanView.layer.borderWidth = 0.5;
    cleanView.layer.borderColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN].CGColor;

    
    UIImageView * rigthImage = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-27, 13, 7, 16)];
    rigthImage.image = [UIImage imageNamed:@"common.bundle/diary/entrance_btn_right-arrow_normal.png"];
    [cleanView addSubview:rigthImage];
    [rigthImage release];
    
    UILabel *textLab = [Common createLabel:CGRectMake(20, 0, kDeviceWidth, 44) TextColor:@"333333" Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft labTitle:@"中国大陆"];
    textLab.userInteractionEnabled = YES;
    textLab.tag = 11;
    [cleanView addSubview:textLab];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeRegin)];
    [textLab addGestureRecognizer:tap];
    [tap release];
    
    UILabel *labFuwu = [[UILabel alloc] initWithFrame:CGRectMake(19, 45, 60, 45)];
	labFuwu.backgroundColor = [UIColor clearColor];
	labFuwu.textColor = [UIColor blackColor];
    labFuwu.tag = 12;
	labFuwu.text = NSLocalizedString(@"(0086)", nil);
	labFuwu.font = [UIFont systemFontOfSize:16];
	[cleanView addSubview:labFuwu];
	[labFuwu release];
	
    NSString *str = [NSString stringWithFormat:@"请输入手机号"];
	m_phone = [self createTextField:NSLocalizedString(str, nil)];
    m_phone.keyboardType = UIKeyboardTypeNumberPad;
    
    [m_phone setTextColor:[CommonImage colorWithHexString:@"#666666"]];
    [m_phone setFont:[UIFont systemFontOfSize:14]];
	m_phone.returnKeyType = UIReturnKeyNext;
    m_phone.tag = 201;
	m_phone.frame = CGRectMake(80, 45, kDeviceWidth-165, 45);
	[cleanView addSubview:m_phone];
    //	[m_userName becomeFirstResponder];
    
    UIButton *butSend = [UIButton buttonWithType:UIButtonTypeCustom];
    butSend.tag = 99;
    butSend.adjustsImageWhenHighlighted = YES;
    butSend.layer.cornerRadius = 4;
    butSend.clipsToBounds = YES;
	butSend.frame = CGRectMake(m_phone.right + 5, m_phone.origin.y+9, 70, 27);
	[butSend setTitleColor:[CommonImage colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
    [butSend setBackgroundImage:image forState:UIControlStateNormal];
	[butSend setTitle:NSLocalizedString(@"发送验证码", nil) forState:UIControlStateNormal];
	butSend.titleLabel.font = [UIFont systemFontOfSize:12];
	[butSend addTarget:self action:@selector(butEventSend) forControlEvents:UIControlEventTouchUpInside];
	[cleanView addSubview:butSend];
	
    
	UILabel *labHuanjing = [[UILabel alloc] initWithFrame:CGRectMake(19, 45*2, 60, 45)];
	labHuanjing.backgroundColor = [UIColor clearColor];
	labHuanjing.textColor = [UIColor blackColor];
	labHuanjing.text = NSLocalizedString(@"验证码", nil);
	labHuanjing.font = [UIFont systemFontOfSize:16];
	[cleanView addSubview:labHuanjing];
	[labHuanjing release];
    
	m_pwd = [self createTextField:NSLocalizedString(@"请输入验证码", nil)];
	m_pwd.returnKeyType = UIReturnKeyDone;
//    m_pwd.keyboardType = UIKeyboardTypeNumberPad;
    m_pwd.tag = 202;
    m_pwd.delegate = self;
	m_pwd.frame = CGRectMake(80, 45*2, kDeviceWidth-80, 45);
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
        textDic = dic;
        
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
    [text setFont:[UIFont systemFontOfSize:14]];
    return text;
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
			break;
	}
	return YES;
}

- (void)HideKeyboard
{
	[m_phone resignFirstResponder];
	[m_pwd resignFirstResponder];
}

- (void)butEventSend
{
    if (m_phone.text.length == 0) {
        NSString *str = [NSString stringWithFormat:@"请输入手机号"];
        [Common TipDialog:NSLocalizedString(str, nil)];
        [m_phone becomeFirstResponder];
        return;
    }
//    if (![Common isMobileNumber:m_phone.text]) {
//        [Common TipDialog:NSLocalizedString(@"手机号码格式不正确，请重新输入！", nil)];
//        [m_phone becomeFirstResponder];
//        return;
//    }
//    
    [self HideKeyboard];
    //90秒倒计时
    time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeBegin) userInfo:nil repeats:YES];
    [time fire];
    
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *str;
    str = m_phone.text;
    if (![textDic[@"regin"] isEqualToString:@"中国大陆"] && textDic) {
        str = [NSString stringWithFormat:@"%@%@",textDic[@"num"],m_phone.text];
    }
    [dic setObject:str forKey:@"phone"];
    NSString *sendUrl = REGISTER_API_URL;
//    if (!g_nowUserInfo.mobilePhone.length && g_nowUserInfo.thirdLogin)
//    {
//        sendUrl = SEND_THIRD_STEP_ONE;
//    }
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:sendUrl values:dic requestKey:sendUrl delegate:self controller:self actiViewFlag:1 title:nil];
}

- (void)timeBegin
{
    timing--;
    UIButton * btn = (UIButton*)[self.view viewWithTag:99];
    UILabel * lab = (UILabel*)[self.view viewWithTag:11];
    lab.userInteractionEnabled = NO;
    if (timing==0) {
        [btn setTitle:NSLocalizedString(@"发送验证码", nil) forState:UIControlStateNormal];
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
	[self HideKeyboard];
	
    if (m_phone.text.length == 0) {
        NSString *str = [NSString stringWithFormat:@"请输入手机号"];
        [Common TipDialog:NSLocalizedString(str, nil)];
        [m_phone becomeFirstResponder];
        return;
    } else if (m_pwd.text.length == 0) {
        [Common TipDialog:NSLocalizedString(@"请输入验证码", nil)];
        [m_pwd becomeFirstResponder];
        return;
    }
	
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	[dic setObject:m_pwd.text forKey:@"code"];
	[dic setObject:m_phone.text forKey:@"phone"];
    
    NSString *sendUrl = validateBind;
//    if (!g_nowUserInfo.mobilePhone.length && g_nowUserInfo.thirdLogin)
//    {
//        sendUrl = SEND_THIRD_STEP_TWO;
//        [dic setObject:m_phone.text forKey:@"phone"];
//    }
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:sendUrl values:dic requestKey:sendUrl delegate:self controller:self actiViewFlag:1 title:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    g_nowUserInfo.mobilePhone = m_phone.text;
//    if (![textDic[@"regin"] isEqualToString:@"中国大陆"] && textDic) {
//        g_nowUserInfo.mobilePhone = [NSString stringWithFormat:@"%@%@",textDic[@"num"],m_phone.text];
//    }
//    [m_infoDic setObject:g_nowUserInfo.mobilePhone forKey:@"value"];
//    [self saveUserAccount];
//    if (g_nowUserInfo.thirdLogin && !changePhone)//第三方登录 绑定手机号
//    {
//        ConfirmViewController* basic = [[ConfirmViewController alloc] initWithType:1];
//        basic.phoneStr = g_nowUserInfo.mobilePhone;
//        [self.navigationController pushViewController:basic animated:YES];
//        [basic release];
//    }
//    else
//    {
//        [self butLogOutEvent];
//    }
}

- (void)saveUserAccount
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSString* username = [userDefault objectForKey:@"username"];
    NSString* userpswd = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:BUNDLE_IDENTIFIER error:NULL];

    NSString* name = g_nowUserInfo.mobilePhone;
    NSString* pswd = userpswd;
    [SFHFKeychainUtils storeUsername:name andPassword:pswd forServiceName:BUNDLE_IDENTIFIER updateExisting:YES error:NULL];
    [userDefault setObject:name forKey:@"username"];
    [userDefault synchronize];
}

/**
 *  返回登录界面
 */
- (void)qweqwe
{
    LoginViewController* LoginViewCon = [[LoginViewController alloc] init];
    UIImage* loginViewImage = [CommonImage imageWithView:LoginViewCon.view];
    UIImageView* loginView = [[UIImageView alloc] initWithImage:loginViewImage];
    loginView.frame = CGRectMake(0, kDeviceHeight + 64, kDeviceWidth, kDeviceHeight + 64);
    [self.navigationController.view addSubview:loginView];
    [loginView release];
    
    [UIView animateWithDuration:0.35 animations:^{
        CGRect rect = loginView.frame;
        rect.origin.y = 0;
        loginView.frame = rect;
    } completion:^(BOOL finished) {
        
        //      LoginViewController *view1 = [[LoginViewController alloc] init];
        CommonNavViewController *view1 = [[CommonNavViewController alloc] initWithRootViewController:LoginViewCon];
        [LoginViewCon release];
        APP_DELEGATE.rootViewController = view1;
        [view1 release];
    }];
}


- (void)butLogOutEvent
{
    //切换用户，重新上传push信息
    AppDelegate* myDelegate = [Common getAppDelegate];
    myDelegate.isUploadPushInfo = NO;
    [self performSelector:@selector(qweqwe) withObject:nil afterDelay:0.3];
}

#pragma mark - NetWork Function

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}


- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    
    if (![[dic[@"head"] objectForKey:@"state"] intValue])
    {
        if([loader.username isEqualToString:validateBind] || [loader.username isEqualToString:SEND_THIRD_STEP_TWO]){
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"绑定成功",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
			[av show];
			[av release];
            
        }
        else if ([loader.username isEqualToString:REGISTER_API_URL] || [loader.username isEqualToString:SEND_EMAIL_CODE] || [loader.username isEqualToString:SEND_THIRD_STEP_ONE] ) {
            MBProgressHUD *progress_ = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.view.frame.size.height)];
            progress_.labelText = @"验证码发送成功";
            progress_.mode = MBProgressHUDModeText;
            progress_.userInteractionEnabled = NO;
            [[[UIApplication sharedApplication].windows lastObject] addSubview:progress_];
            [progress_ show:YES];
            [progress_ showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            } completionBlock:^{
                [progress_ release];
                [progress_ removeFromSuperview];
            }];
        }
    }
    else {
        [Common TipDialog:[dic[@"head"] objectForKey:@"msg"]];
        [self stopRequest];
    }
}

- (void)stopRequest
{
    UIButton * btn = (UIButton*)[self.view viewWithTag:99];
    [btn setTitle:NSLocalizedString(@"发送验证码", nil) forState:UIControlStateNormal];
    [time invalidate];
    time = nil;
    timing = 90;
    btn.userInteractionEnabled = YES;
    UILabel * lab = (UILabel*)[self.view viewWithTag:11];
    lab.userInteractionEnabled = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self HideKeyboard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
