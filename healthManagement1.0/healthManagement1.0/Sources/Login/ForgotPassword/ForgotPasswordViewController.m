//
//  ForgotPasswordViewController.m
//  healthManagement1.0
//
//  Created by xjs on 16/7/20.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "ChangesReginViewController.h"
#import "SFHFKeychainUtils.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController
{
    NSDictionary * textDic;
    UITextField *m_phoneText;
    UITextField *m_codeText;
    
    UIView *m_codeView;
    
    UIButton *m_butLogin;
    UIButton *m_butCode;
    
    NSTimer *m_timer;
    UITextField *m_txtPassWord;
    UITextField *m_txtPassWord2;
    NSString *phoneStr;
    
    int timing;
}

@synthesize phoneStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    switch (_type) {
        case 1:
            [self createFirst];
            break;
        case 2:
            [self createTwo];
            break;
 
        default:
            break;
    }
    m_butLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    m_butLogin.frame = CGRectMake(25, 310/2, kDeviceWidth-50, 45);
    [m_butLogin setTitle:_type==1?@"下一步":@"完成" forState:UIControlStateNormal];
    [m_butLogin setTitleColor:[CommonImage colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    m_butLogin.titleLabel.font = [UIFont systemFontOfSize:18];
    m_butLogin.layer.cornerRadius = m_butLogin.height/2;
    m_butLogin.clipsToBounds = YES;
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:The_ThemeColor]];
    [m_butLogin setBackgroundImage:image forState:UIControlStateNormal];
    [m_butLogin addTarget:self action:@selector(selectCountry:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_butLogin];

    // Do any additional setup after loading the view.
}

- (void)createFirst
{
    //手机号
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(25, 26, kDeviceWidth-50, 50)];
    [self.view addSubview:view1];
    
    UIButton *butCountry = [UIButton buttonWithType:UIButtonTypeCustom];
    butCountry.frame = CGRectMake(0, 0, 60, view1.height);
    [butCountry setTitle:@"+86" forState:UIControlStateNormal];
    [butCountry addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    [butCountry setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [butCountry setImage:[UIImage imageNamed:@"common.bundle/login/down.png"] forState:UIControlStateNormal];
    butCountry.titleLabel.font = [UIFont systemFontOfSize:17];
    [view1 addSubview:butCountry];
    float width = [Common sizeForString:butCountry.titleLabel.text andFont:butCountry.titleLabel.font.pointSize].width;
    [butCountry setTitleEdgeInsets:UIEdgeInsetsMake(0, MIN(width-butCountry.width+4, 0), 0, 0)];
    [butCountry setImageEdgeInsets:UIEdgeInsetsMake(0, width+7, 0, 0)];
    
    m_phoneText = [Common createTextField:@"请输入手机号" setDelegate:nil setFont:17];
    [m_phoneText setKeyboardType:UIKeyboardTypeNumberPad];
    m_phoneText.frame = CGRectMake(butCountry.right, 0, view1.width-butCountry.right, view1.height);
    [view1 addSubview:m_phoneText];
    
    UIView *line = [[UILabel alloc] initWithFrame:CGRectMake(0, view1.height - 0.5, view1.width, 0.5)];
    line.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
    [view1 addSubview:line];
    
    //验证码
    m_codeView = [[UIView alloc] initWithFrame:CGRectMake(view1.left, view1.bottom, view1.width, view1.height)];
//    m_codeView.alpha = 0;
    [self.view addSubview:m_codeView];
    
    m_codeText = [Common createTextField:@"验证码" setDelegate:nil setFont:17];
    [m_codeText setKeyboardType:UIKeyboardTypeNumberPad];
    m_codeText.frame = CGRectMake(0, 0, view1.width-100, view1.height);
    [m_codeView addSubview:m_codeText];
    
    m_butCode = [UIButton buttonWithType:UIButtonTypeCustom];
    m_butCode.frame = CGRectMake(m_codeText.right, 0, 100, view1.height);
    [m_butCode setTitleColor:[CommonImage colorWithHexString:@"37de80"] forState:UIControlStateNormal];//
    [m_butCode setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateDisabled];//666666
    [m_butCode addTarget:self action:@selector(getCodeForServer:) forControlEvents:UIControlEventTouchUpInside];
    [m_butCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [m_codeView addSubview:m_butCode];
    
    line = [[UILabel alloc] initWithFrame:CGRectMake(m_codeView.left, m_codeView.bottom - 0.25, view1.width, 0.5)];
    line.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
    [self.view addSubview:line];
    
}

- (void)choose:(UIButton*)btn
{
    
}

- (void)setShowCodeView:(BOOL)is
{
    float y;
    if (is) {
        y = 40;
    }
    else {
        y = 0;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        m_codeView.alpha = is;
        m_butLogin.transform = CGAffineTransformMakeTranslation(0, 40);
    }];
}

- (void)getCodeForServer:(UIButton*)btn
{
    
    if (m_phoneText.text.length == 0) {
        NSString *str = [NSString stringWithFormat:@"请输入手机号"];
        [Common TipDialog:NSLocalizedString(str, nil)];
        [m_phoneText becomeFirstResponder];
        return;
    }
    //    [self HideKeyboard];
    phoneStr = m_phoneText.text;
    if (![textDic[@"regin"] isEqualToString:@"中国大陆"] && textDic) {
        phoneStr = [NSString stringWithFormat:@"%@%@",textDic[@"num"],m_phoneText.text];
    }
    // 获取验证码
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:phoneStr forKey:@"phone"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:CHECKPHOTO_API_URL values:dic requestKey:CHECKPHOTO_API_URL delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"加载中...", nil)];
    
    if (!m_timer) {
        m_timer = [[NSTimer alloc] initWithFireDate:[NSDate distantFuture] interval:4 target:self selector:@selector(timeBegin) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:m_timer forMode:NSDefaultRunLoopMode];
    }
    timing = 90;
    [m_timer setFireDate:[NSDate date]]; //继续。
    
    m_butCode.enabled = NO;
}

//- (void)pausePlayAdv
//{
//    if (!m_playTimer) {
//        return;
//    }
//    [m_playTimer setFireDate:[NSDate distantFuture]];//暂停
//}

- (void)selectCountry:(UIButton*)but
{
    switch (_type) {
        case 1:
        {
            ForgotPasswordViewController * forgot = [[ForgotPasswordViewController alloc]init];
            forgot.type = 2;
            [self.navigationController pushViewController:forgot animated:YES];
            
            
        }
            break;
        case 2:
        {
            [m_txtPassWord resignFirstResponder];
            [m_txtPassWord2 resignFirstResponder];
            //
            if ([self judgeThePass]) {
                return;
            }

            NSLog(@"重置密码");
            NSMutableDictionary* dic = [NSMutableDictionary dictionary];
            [dic setObject:_verificationStr forKey:@"code"];
            [dic setObject:phoneStr forKey:@"phone"];
            [dic setObject:m_txtPassWord.text forKey:@"password"];
            [[CommonHttpRequest defaultInstance] sendNewPostRequest:EMAILTHREE_API_URL values:dic requestKey:EMAILTHREE_API_URL delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"加载中...", nil)];
        }
            break;
  
        default:
            break;
    }
}

- (BOOL)judgeThePass
{
    if ([m_txtPassWord2.text length] == 0 ) {
        [Common createAlertViewWithString:@"密码不能为空！" withDeleagte:nil];
        return YES;
    }else
        if ([m_txtPassWord.text length] == 0) {
            [Common createAlertViewWithString:@"确认密码不能为空！" withDeleagte:nil];
            return YES;
        }else
            if ([m_txtPassWord2.text length] < 6) {
                [Common createAlertViewWithString:@"密码长度必须大于6位！" withDeleagte:nil];
                return YES;
            }else
                if (![m_txtPassWord2.text isEqualToString:m_txtPassWord.text]) {
                    [Common createAlertViewWithString:@"两次输入的密码不一致！" withDeleagte:nil];
                    return YES;
                }else
                    if ([m_txtPassWord2.text length] >14) {
                        [Common createAlertViewWithString:@"密码长度必须小于15位！" withDeleagte:nil];
                        return YES;
                    }
    return NO;
}


- (void)butEventSend
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

}

- (void)isSee:(UIButton*)btn
{
    btn.selected = !btn.selected;

    switch (btn.tag-100) {
        case 0:
            if (btn.selected) {
                [m_txtPassWord setSecureTextEntry:NO];
                
            }else{
                [m_txtPassWord setSecureTextEntry:YES];
            }

            break;
        case 1:
            if (btn.selected) {
                [m_txtPassWord2 setSecureTextEntry:NO];
                
            }else{
                [m_txtPassWord2 setSecureTextEntry:YES];
                
            }

            break;

        default:
            break;
    }
}

- (void)timeBegin
{
    timing--;
    
    if (!timing) {
        m_butCode.enabled = YES;
        
        [m_timer setFireDate:[NSDate distantFuture]];//暂停
        [m_butCode setTitle:@"重新发送" forState:UIControlStateNormal];
        return;
    }
    [m_butCode setTitle:[NSString stringWithFormat:@"%d", timing] forState:UIControlStateDisabled];
}

- (void)createTwo
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(25, 26, kDeviceWidth-50, 100)];
    [self.view addSubview:view];
    UITextField * firld;
    UIButton * seeBtn;
    UIView *line;
    UIImage * image = [UIImage imageNamed:@"common.bundle/login/passwrold_nor"];
    for (int i =0; i<2; i++) {
        firld = [Common createTextField:i?@"请再次输入密码":@"请输入密码" setDelegate:self setFont:17];
        [firld setValue:[CommonImage colorWithHexString:@"#cccccc"] forKeyPath:@"_placeholderLabel.textColor"];

        [firld setSecureTextEntry:YES];
        firld.clearButtonMode = NO;
        firld.frame = CGRectMake(0, view.height/2*i, view.width-30, view.height/2);
        [view addSubview:firld];
        if (i) {
            m_txtPassWord2 = firld;
        }else{
            m_txtPassWord = firld;
        }
        
        seeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        seeBtn.tag = 100+i;
        seeBtn.frame = CGRectMake(view.width-image.size.width, firld.top, image.size.width, firld.height);
        [seeBtn setImage:image forState:UIControlStateNormal];
        [seeBtn setImage:[UIImage imageNamed:@"common.bundle/login/passwrold_pre"] forState:UIControlStateSelected];
        [seeBtn addTarget:self action:@selector(isSee:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:seeBtn];
        
        line = [[UILabel alloc] initWithFrame:CGRectMake(0, firld.bottom - 0.25, view.width, 0.5)];
        line.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
        [view addSubview:line];

    }

    
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    if (m_txtPassWord == textField || m_txtPassWord2 == textField) {
        NSMutableString *changeString = [NSMutableString stringWithString:textField.text];
        [changeString replaceCharactersInRange:range withString:string];
        if ([changeString length]> 14) {
            return NO;
        }
    }
    return YES;
}


- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}

- (void)didFinishSuccess:(ASIHTTPRequest*)loader
{
    NSString* responseString = [loader responseString];
    NSDictionary* dict = [responseString KXjSONValueObject];
    NSDictionary * dic = dict[@"head"];
    
    if ([[dic objectForKey:@"state"] intValue] == 0) {
        
        if ([loader.username isEqualToString:EMAILTHREE_API_URL]) {
            //找回密码
            UIAlertView* alert = [[UIAlertView alloc]
                                  initWithTitle:@""
                                  message:NSLocalizedString(@"您的密码已重置成功！", nil)
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"去登录", nil)
                                  otherButtonTitles:nil];
            [alert show];
            [self saveUserAccount];

        }
    }
    else {
        [Common TipDialog:dic[@"msg"]];
    }
}

- (void)saveUserAccount
{
    NSString* name = phoneStr;
    NSString* pswd = m_txtPassWord.text;
    [SFHFKeychainUtils storeUsername:name andPassword:pswd forServiceName:BUNDLE_IDENTIFIER updateExisting:YES error:NULL];
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    //切换用户，重新上传push信息
//    AppDelegate* myDelegate = [Common getAppDelegate];
//    myDelegate.isUploadPushInfo = NO;
//    [self performSelector:@selector(qweqwe) withObject:nil afterDelay:0.3];
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
    
    [UIView animateWithDuration:0.35 animations:^{
        CGRect rect = loginView.frame;
        rect.origin.y = 0;
        loginView.frame = rect;
    } completion:^(BOOL finished) {
        //      LoginViewController *view1 = [[LoginViewController alloc] init];
        CommonNavViewController *view1 = [[CommonNavViewController alloc] initWithRootViewController:LoginViewCon];
        APP_DELEGATE.rootViewController = view1;
    }];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [m_txtPassWord resignFirstResponder];
    [m_txtPassWord2 resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
