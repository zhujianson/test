//
//  LoginViewController.m
//  waimaidan2.0
//
//  Created by sunzhf on 13-4-3.
//  Copyright (c) 2013年 qianliqianxun. All rights reserved.
//

#import "LoginViewController.h"
#import "Common.h"
#import "CommonHttpRequest.h"
#import "SFHFKeychainUtils.h"
#import "AppDelegate.h"
#import "RetrievePasswordViewController.h"
#import "PerfectInformation.h"
#import "CommonNavViewController.h"
#import "SelectionListView.h"
#import "DefauleViewController.h"
#import "YRilView.h"
#import "UIImageView+WebCache.h"
#import "ForgotPasswordViewController.h"
#import "FastLoginViewController.h"
#import "ChangesReginViewController.h"

#define ERRORPASSWOD @"您输入的密码错误，请输入正确的密码信息！"
#define IPHONE4S (kDeviceHeight<500?20:0)
#define IPHONE4 (kDeviceHeight<500?10:0)
#define IOS6HEIGHT (!IOS_7?20:0)

#define headerImage @"common.bundle/common/center_my-family_head_icon.png"

@implementation LoginViewController {
    UIButton* btn_Login;
    UIAlertView* m_alert;
    NSDictionary *thirdUserInfo;
    NSMutableArray * noremalImgeArrays;
    UIImageView* imageIcon;
    NSString * m_thiddLoadType;
    CGFloat m_keyHeight;
    BOOL m_isLoading;
    NSDictionary *textDic;
    
    NSString *phoneStr;
    UITextField *m_txtUserName;
    UITextField *m_txtPassWord;
    
    UITextField *m_txtURL;
    
    SSCheckBoxView *m_checkBox;
    id m_fvc;

}
- (void)setFid:(id)vc
{
    m_fvc = vc;
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        m_isLoading = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if ([self.navigationController.viewControllers count] == 1){
//        self.navigationController.navigationBar.hidden = YES;
//    }
    /* Listen for keyboard */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    if (IOS_7) {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /* No longer listen for keyboard */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//    float y = 20;
//    if (IOS_7) {
//        y = 0;
//    }
//    UIImageView* imageViewTest = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, kDeviceWidth, kDeviceHeight + 64)];
//    imageViewTest.image = [CommonImage imageWithView:self.view];
//    imageViewTest.contentMode = UIViewContentModeTop;
//    [APP_DELEGATE addSubview:imageViewTest];
//    [imageViewTest release];
////    self.navigationController.navigationBar.hidden = NO;
//    
//    self.navigationController.view.transform = CGAffineTransformMakeTranslation(320, 0);
//    [APP_DELEGATE bringSubviewToFront:self.navigationController.view];
//    
//    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{ //修改坐标
//        self.navigationController.view.transform = CGAffineTransformMakeTranslation(0, 0);
//        float widht = kDeviceWidth;
//        if (IOS_7) {
//            widht = kDeviceWidth/1.45;
//        }
//        imageViewTest.transform = CGAffineTransformMakeTranslation(-widht, 0);
//    } completion:^(BOOL finished) {
//        [imageViewTest removeFromSuperview];
//    }];

}

- (void)viewDidLoad
{
	[super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"登录";
    
    if ([self isAotuLogin]) {
        //自动登录
        return;
    }
//    [self removeAdvView];
    [self createView];
}

- (void)createView
{
//    UIView * view = [UIView alloc]initWithFrame:<#(CGRect)#>
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(25, 26, kDeviceWidth-50, 100)];
    [self.view addSubview:view1];
    
//    m_txtURL = [self createTextField:NSLocalizedString(@"服务器完整地址", nil)];
//    m_txtURL.clearButtonMode = NO;
//    m_txtURL.returnKeyType = UIReturnKeyDone;
//    m_txtURL.backgroundColor = [UIColor redColor];
//    m_txtURL.frame = CGRectMake(0, 0, kDeviceWidth, 30);
//    [self.view addSubview:m_txtURL];
//    [m_txtURL release];

    
    UIButton *butCountry = [UIButton buttonWithType:UIButtonTypeCustom];
    butCountry.frame = CGRectMake(0, 0, 60, view1.height/2);
    [butCountry setTitle:@"+86" forState:UIControlStateNormal];
    [butCountry addTarget:self action:@selector(selectCountry:) forControlEvents:UIControlEventTouchUpInside];
    [butCountry setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [butCountry setImage:[UIImage imageNamed:@"common.bundle/login/down.png"] forState:UIControlStateNormal];
    butCountry.titleLabel.font = [UIFont systemFontOfSize:17];
    [view1 addSubview:butCountry];
    float width = [Common sizeForString:butCountry.titleLabel.text andFont:butCountry.titleLabel.font.pointSize].width;
    [butCountry setTitleEdgeInsets:UIEdgeInsetsMake(0, MIN(width-butCountry.width+4, 0), 0, 0)];
    [butCountry setImageEdgeInsets:UIEdgeInsetsMake(0, width+7, 0, 0)];
    
    UIView *lindh = [[UIView alloc] initWithFrame:CGRectMake(butCountry.right-0.5, 12, 0.5, butCountry.height-24)];
    lindh.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
    [butCountry addSubview:lindh];
    
    m_txtUserName = [self createTextField:@"请输入手机号"];
    [m_txtUserName setKeyboardType:UIKeyboardTypeNumberPad];
    m_txtUserName.frame = CGRectMake(butCountry.right+15, 0, view1.width-butCountry.right-15, view1.height/2);
    [view1 addSubview:m_txtUserName];
    
    UIView *line = [[UILabel alloc] initWithFrame:CGRectMake(0, view1.height/2 - 0.25, view1.width, 0.5)];
    line.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
    [view1 addSubview:line];
    
    m_txtPassWord = [self createTextField:@"请输入密码"];
    [m_txtPassWord setSecureTextEntry:YES];
    m_txtPassWord.clearButtonMode = NO;
    m_txtPassWord.frame = CGRectMake(0, m_txtUserName.bottom, view1.width-30, view1.height/2);
    [view1 addSubview:m_txtPassWord];

    UIButton * seeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seeBtn.frame = CGRectMake(m_txtPassWord.right, m_txtPassWord.top, 30, m_txtPassWord.height);
    [seeBtn setImage:[UIImage imageNamed:@"common.bundle/login/passwrold_nor"] forState:UIControlStateNormal];
    [seeBtn setImage:[UIImage imageNamed:@"common.bundle/login/passwrold_pre"] forState:UIControlStateSelected];
    [seeBtn addTarget:self action:@selector(isSee:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:seeBtn];
    
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, view1.height - 0.25, view1.width, 0.5)];
    line.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
    [view1 addSubview:line];
    
    btn_Login = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Login.frame = CGRectMake(25, view1.bottom+30, kDeviceWidth-50, 45);
    [btn_Login setTitleColor:[CommonImage colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [btn_Login setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
    btn_Login.titleLabel.font = [UIFont systemFontOfSize:18];
    btn_Login.layer.cornerRadius = btn_Login.height/2;
    btn_Login.clipsToBounds = YES;
    btn_Login.enabled = NO;
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:The_ThemeColor]];
    [btn_Login setBackgroundImage:image forState:UIControlStateNormal];
    [btn_Login setBackgroundImage:[CommonImage createImageWithColor:[CommonImage colorWithHexString:@"cccccc"]] forState:UIControlStateDisabled];
    [btn_Login addTarget:self action:@selector(Login_handle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_Login];
    BOOL isAuto = [[NSUserDefaults standardUserDefaults] boolForKey:@"checkstatus"];
    BOOL isAotuLogin = YES;
    if (!isAuto && [[NSUserDefaults standardUserDefaults] objectForKey:@"checkstatus"]) {
        isAotuLogin = NO;
    }
    m_checkBox = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(btn_Login.left, btn_Login.bottom + 8, 150, 30) style:kSSCheckBoxViewStyleBox checked:isAotuLogin Login:YES];
    
    
    [m_checkBox setUpCheckImage:@"common.bundle/diary/selected_on.png" andWithNormalImage:@"common.bundle/diary/selected_off.png"];
    m_checkBox.titleFont = [UIFont systemFontOfSize:15];
    m_checkBox.titleColor = [CommonImage colorWithHexString:@"999999"];
    [self.view addSubview:m_checkBox];
    [m_checkBox setText:NSLocalizedString(@"自动登录", nil)];

    
    UIView * bottmView = [[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-50, kDeviceWidth, 50)];
    bottmView.backgroundColor = [CommonImage colorWithHexString:@"fafafa"];
    [self.view addSubview:bottmView];
    UIButton * labBtn;
    UIView * lineView;
    for (int i=0; i<2; i++) {
        labBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        labBtn.frame = CGRectMake(kDeviceWidth/2*i, 0, kDeviceWidth/2, bottmView.height);
        [labBtn setTitle:i?@"快速登录":@"忘记密码" forState:UIControlStateNormal];
        [labBtn setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
        labBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [labBtn addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
        labBtn.tag = 100+i;
        [bottmView addSubview:labBtn];
        if (i) {
            lineView = [[UIView alloc]initWithFrame:CGRectMake(labBtn.left-0.25, 25/2, 0.5, 25)];
            lineView.backgroundColor = [CommonImage colorWithHexString:@"e6e6e6"];
            [bottmView addSubview:lineView];
            [lineView release];
        }
    }
    [bottmView release];
    

    m_txtUserName.text = [CommonUser getUserName];
//    if (isAotuLogin) {
//        m_txtPassWord.text = [CommonUser getUserPswd];
//    }

}

- (void)isSee:(UIButton*)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [m_txtPassWord setSecureTextEntry:NO];

    }else{
        [m_txtPassWord setSecureTextEntry:YES];

    }
}

- (void)selectCountry:(UIButton*)but
{
    ChangesReginViewController *change = [[ChangesReginViewController alloc] init];
    change.textDic = textDic;
    [change setChangesReginBlock:^(NSDictionary *dic) {
        textDic = dic;
        [but setTitle:[NSString stringWithFormat:@"+%@", textDic[@"num"]] forState:UIControlStateNormal];
        float width = [Common sizeForString:but.titleLabel.text andFont:but.titleLabel.font.pointSize].width;
        [but setTitleEdgeInsets:UIEdgeInsetsMake(0, MIN(width-but.width+4, 0), 0, 0)];
        [but setImageEdgeInsets:UIEdgeInsetsMake(0, width+7, 0, 0)];
    }];
    [self.navigationController pushViewController:change animated:YES];

}


- (void)chooseType:(UIButton*)btn
{
    FastLoginViewController * forgot = [[FastLoginViewController alloc]init];
    forgot.title = btn.titleLabel.text;
//    switch (btn.tag-100) {
//        case 0:
//        {
//
//            
//        }
//            break;
//        case 1:
//        {
//            
//        }
//            break;
//
//        default:
//            break;
//    }
    [self.navigationController pushViewController:forgot animated:YES];
    [forgot release];

}

//- (void)createView
//{
////    if (IOS_7) {
////        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
////    }
////    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
////    if (IOS_7) {
////        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
////    }
//    self.view.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR];
//    
//    imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-85)/2,kDeviceHeight/4-IPHONE4S, 85, 85)]; //260*232
//    imageIcon.clipsToBounds = YES;
//    imageIcon.layer.cornerRadius = imageIcon.width/2;
//    //    imageIcon.contentMode = UIViewContentModeCenter;
//    imageIcon.image = [UIImage imageNamed:headerImage];
//    [self.view addSubview:imageIcon];
//    [imageIcon release];
//    
////        m_txtURL = [self createTextField:NSLocalizedString(@"服务器完整地址", nil)];
////        m_txtURL.clearButtonMode = NO;
////        m_txtURL.returnKeyType = UIReturnKeyDone;
////        m_txtURL.backgroundColor = [UIColor redColor];
////        m_txtURL.frame = CGRectMake(0, imageIcon.bottom-20, kDeviceWidth, 47);
////        [self.view addSubview:m_txtURL];
////        [m_txtURL release];
//    
//    UIImageView* textImageVBack = [[UIImageView alloc] initWithFrame:CGRectMake(20, imageIcon.bottom + 20, kDeviceWidth-40, 100)];
//    textImageVBack.layer.borderWidth = 0.5;
//    textImageVBack.layer.borderColor = [CommonImage colorWithHexString:LINE_COLOR].CGColor;
//    textImageVBack.backgroundColor = [UIColor whiteColor];
//    textImageVBack.layer.cornerRadius = 4;
//    textImageVBack.clipsToBounds = YES;
//    textImageVBack.userInteractionEnabled = YES;
//    [self.view addSubview:textImageVBack];
//    [textImageVBack release];
//    
//    m_txtUserName = [self createTextField:NSLocalizedString(@"手机号", nil)];
//    [m_txtUserName setKeyboardType:UIKeyboardTypeASCIICapable];
//    m_txtUserName.frame = CGRectMake(40, 0, kDeviceWidth-80-10, 49);
//    [textImageVBack addSubview:m_txtUserName];
//    UIImageView* pickerImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, (50-18)/2, 13, 18)];
//    pickerImage.image = [UIImage imageNamed:@"common.bundle/login/login_icon_user.png"];
//    [textImageVBack addSubview:pickerImage];
//    pickerImage.contentMode = UIViewContentModeScaleAspectFit;
//    [pickerImage release];
//    
//    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, textImageVBack.height/2-0.25, kDeviceWidth - 20 * 2, 0.5)];
//    lineView.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
//    [textImageVBack addSubview:lineView];
//    [lineView release];
//    
//    m_txtPassWord = [self createTextField:NSLocalizedString(@"密码", nil)];
//    [m_txtPassWord setFont:[UIFont systemFontOfSize:16]];
//    [m_txtPassWord setSecureTextEntry:YES];
//    m_txtPassWord.clearButtonMode = YES;
//    m_txtPassWord.returnKeyType = UIReturnKeyDone;
//    m_txtPassWord.frame = CGRectMake(40, lineView.top, kDeviceWidth-80-80, 49);
//    [textImageVBack addSubview:m_txtPassWord];
//    
//    UIButton* btn_FindPWD = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn_FindPWD.frame = CGRectMake(textImageVBack.width-80, 17/2+50, 80, 30);
//    [btn_FindPWD setTitleColor:[CommonImage colorWithHexString:@"999999"] forState:UIControlStateNormal];
//    [btn_FindPWD setTitle:NSLocalizedString(@"忘记密码? ", nil) forState:UIControlStateNormal];
//    btn_FindPWD.titleLabel.font = [UIFont systemFontOfSize:13];
//    [btn_FindPWD addTarget:self action:@selector(butFindPWDEvent) forControlEvents:UIControlEventTouchUpInside];
//    [textImageVBack addSubview:btn_FindPWD];
//    
//    pickerImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 50+(50-18)/2, 13, 18)];
//    pickerImage.image = [UIImage imageNamed:@"common.bundle/login/login_icon_password.png"];
//    pickerImage.contentMode = UIViewContentModeScaleAspectFit;
//    [textImageVBack addSubview:pickerImage];
//    [pickerImage release];
//    
//    id isAuto = [[NSUserDefaults standardUserDefaults] objectForKey:@"checkstatus"];
//    BOOL isAotuLogin;
//    if (!isAuto) {
//        [[[NSUserDefaults standardUserDefaults] objectForKey:@"checkstatus"] boolValue];
//        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"checkstatus"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        isAotuLogin = YES;
//    }
//    m_checkBox = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(20, textImageVBack.bottom + 6, 150, 30) style:kSSCheckBoxViewStyleBox checked:isAotuLogin Login:YES];
//
//    [m_checkBox setUpCheckImage:@"common.bundle/diary/login_icon_radiobutton_pressed.png" andWithNormalImage:@"common.bundle/diary/login_icon_radiobutton_normal.png"];
//    m_checkBox.titleFont = [UIFont systemFontOfSize:15];
//    m_checkBox.titleColor = [CommonImage colorWithHexString:@"999999"];
//    [self.view addSubview:m_checkBox];
//    [m_checkBox setText:NSLocalizedString(@"自动登录", nil)];
//    
//    btn_Login = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn_Login.frame = CGRectMake((kDeviceWidth-52)/2+32, m_checkBox.bottom + 15, (kDeviceWidth-52)/2, 44);
//    [btn_Login setTitleColor:[CommonImage colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
//    [btn_Login setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
//    btn_Login.titleLabel.font = [UIFont systemFontOfSize:18];
//    btn_Login.layer.cornerRadius = 4;
//    btn_Login.clipsToBounds = YES;
//    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
//    [btn_Login setBackgroundImage:image forState:UIControlStateNormal];
//    [btn_Login addTarget:self action:@selector(Login_handle) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn_Login];
//    
//    UIButton * retrieve = [UIButton buttonWithType:UIButtonTypeCustom];
//    retrieve.frame = CGRectMake(20, btn_Login.top, btn_Login.frame.size.width, btn_Login.frame.size.height);
//    retrieve.clipsToBounds = YES;
//    retrieve.layer.cornerRadius = 4;
//    image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"69d136"]];
//    [retrieve setBackgroundImage:image forState:UIControlStateNormal];
//    [retrieve addTarget:self action:@selector(registeredPWDEvent) forControlEvents:UIControlEventTouchUpInside];
//    [retrieve setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
//    retrieve.titleLabel.font = [UIFont systemFontOfSize:18];
//    [self.view addSubview:retrieve];
//    
//    m_keyHeight = retrieve.bottom;
//    
//    m_txtUserName.text = [CommonUser getUserName];
//    NSString * imageUrl = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_loadingImage",m_txtUserName.text]];
//    if (imageUrl && [imageUrl length]) {
//        NSString *imagePath = [imageUrl stringByAppendingString:@"?imageView2/1/w/80/h/80"];
//        UIImage *defaul = [UIImage imageNamed:@"common.bundle/common/center_my-family_head_icon.png"];
//        [imageIcon sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:defaul];
//    }
//    
//    if (isAotuLogin) {
//        m_txtPassWord.text = [CommonUser getUserPswd];
//    }
//    
////     m_txtUserName.text = @"13810582372";
////     m_txtPassWord.text = @"$987654321";
//}

- (BOOL)isAotuLogin
{
    BOOL isAotuLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"checkstatus"] boolValue];
    if (isAotuLogin && [Common checkNetworkIsValid] && [CommonUser getUserPswd])
    {
        [self setAutomaticLogin];
        
        return YES;
    }
    return NO;
    
}

#pragma mark test

- (UITextField*)createTextField:(NSString*)title
{
    UITextField* text = [[UITextField alloc] init];
    text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    text.contentMode = UIViewContentModeCenter;
    text.autocapitalizationType = UITextAutocapitalizationTypeNone;
    text.placeholder = title;
    text.clearButtonMode = YES;
    text.delegate = self;
    [text setValue:[CommonImage colorWithHexString:@"#cccccc"] forKeyPath:@"_placeholderLabel.textColor"];
    [text setTextColor:[CommonImage colorWithHexString:@"#666666"]];
    [text setFont:[UIFont systemFontOfSize:17]];
    return text;
}

- (void)saveUserAccount
{
    NSString* name = phoneStr;
    NSString* pswd = m_txtPassWord.text;
    if (m_checkBox.checked) {
        [SFHFKeychainUtils storeUsername:name andPassword:pswd forServiceName:BUNDLE_IDENTIFIER updateExisting:YES error:NULL];
    } else {
        [SFHFKeychainUtils deleteItemForUsername:name andServiceName:BUNDLE_IDENTIFIER error:NULL];
    }

    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//3秒消失
- (void)customAlertWithTipTitle:(NSString*)tiptitle withType:(int)type withDismissSelf:(BOOL)disMissSelf
{
    NSString* buttonTitle = nil;
    switch (type) {
    case 1:
        buttonTitle = @"关闭";
        break;
    default:
        buttonTitle = @"确定";
        break;
    }

    m_alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                         message:tiptitle
                                        delegate:self
                               cancelButtonTitle:buttonTitle
                               otherButtonTitles:nil];
    if (disMissSelf) {
        [self performSelector:@selector(performDismiss:) withObject:nil afterDelay:3.0f];
    }
    [m_alert show];
}

- (void)performDismiss:(NSTimer*)timer
{
    if (m_alert) {
        [m_alert dismissWithClickedButtonIndex:0 animated:NO];
        [m_alert release];
        m_alert = nil;
    }
    
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    if (m_txtPassWord == textField) {
        NSMutableString *changeString = [NSMutableString stringWithString:textField.text];
        [changeString replaceCharactersInRange:range withString:string];
        if ([changeString length]> 14) {
            return NO;
        }
    } else {
        imageIcon.image = [UIImage imageNamed:headerImage];
    }
    
    if (m_txtUserName.text.length>5 && m_txtPassWord.text.length>4) {
        btn_Login.enabled = YES;
    }else{
        btn_Login.enabled = NO;

    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == m_txtUserName) {
//        NSString * imageUrl = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_loadingImage",m_txtUserName.text]];
//        if (imageUrl && [imageUrl length]) {
//            NSString *imagePath = [imageUrl stringByAppendingString:@"?imageView2/1/w/80/h/80"];
//            UIImage *defaul = [UIImage imageNamed:@"common.bundle/common/center_my-family_head_icon.png"];
//            [imageIcon sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:defaul];
//
//        }else{
//            imageIcon.image = [UIImage imageNamed:headerImage];
//        }
    }
    else if (textField == m_txtURL) {
        g_url = [[NSString alloc] initWithString:textField.text];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField == m_txtUserName) {
        imageIcon.image = [UIImage imageNamed:headerImage];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)HideKeyboard
{
    [m_txtUserName resignFirstResponder];
    [m_txtPassWord resignFirstResponder];
}

#pragma mark Login
- (void)Login_handle
{    
    NSString* text = [m_txtUserName.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (m_txtUserName.text.length == 0 && m_txtPassWord.text.length == 0) {
        [self customAlertWithTipTitle:@"帐号密码不能为空!" withType:1 withDismissSelf:YES];
        return;
    } else if (m_txtUserName.text.length == 0) {
        [self customAlertWithTipTitle:@"请输入帐号!" withType:1 withDismissSelf:YES];
        return;
    } else if (m_txtPassWord.text.length == 0) {
        [self customAlertWithTipTitle:@"请输入密码!" withType:1 withDismissSelf:YES];
        return;
    }else if (m_txtPassWord.text.length < 6) {
        [self customAlertWithTipTitle:@"请输入正确密码!" withType:1 withDismissSelf:YES];
        return;
    }
    [self HideKeyboard];
    phoneStr = m_txtUserName.text;
    if (![textDic[@"regin"] isEqualToString:@"中国大陆"] && textDic) {
        phoneStr = [NSString stringWithFormat:@"%@%@",textDic[@"num"],m_txtUserName.text];
    }

    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
	[dic setObject:phoneStr forKey:@"username"];
	[[NSUserDefaults standardUserDefaults] setObject:text forKey:@"username"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    [dic setObject:m_txtPassWord.text forKey:@"password"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:LOGIN_API_URL values:dic requestKey:LOGIN_API_URL delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"登录中...", nil)];

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kangxun_goToView"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"thirdUserInfo"];//移除帐号信息
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setAutomaticLogin
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:[CommonUser getUserName] forKey:@"username"];
    [dic setObject:[CommonUser getUserPswd] forKey:@"password"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:LOGIN_API_URL values:dic requestKey:LOGIN_API_URL delegate:self controller:self actiViewFlag:0 title:NSLocalizedString(@"登录中...", nil)];

}


/**
 *  找回密码
 */
- (void)butFindPWDEvent
{
    RetrievePasswordViewController* retrieve = [[RetrievePasswordViewController alloc] initWithType:0];
    [self.navigationController pushViewController:retrieve animated:YES];
    [retrieve release];
}
 
/**
 *  注册
 */
- (void)registeredPWDEvent
{
    RetrievePasswordViewController* retrieve = [[RetrievePasswordViewController alloc] initWithType:1];
    [self.navigationController pushViewController:retrieve animated:YES];
    [retrieve release];
    
}

- (void)removeFindPassWordView:(UITapGestureRecognizer*)tapGestureRecognize
{
    if (tapGestureRecognize.view.superview) {
        [tapGestureRecognize.view.superview removeFromSuperview];
    }
}

- (void)didFinishFail:(ASIHTTPRequest*)loader
{
    if (!m_txtPassWord) {
        m_isLoading = NO;
        [self removeAdvView];
//        [_m_LaunchImage removeFromSuperview];
        [self createView];
    }
    [Common TipDialog:NSLocalizedString(@"网络异常", nil)];
    [SFHFKeychainUtils deleteItemForUsername:m_txtUserName.text andServiceName:BUNDLE_IDENTIFIER error:NULL];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"checkstatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didFinishSuccess:(ASIHTTPRequest*)loader
{
    NSString* responseString = [loader responseString];
    NSDictionary* dict = [responseString KXjSONValueObject];

    NSDictionary * dic = dict[@"head"];
    if ([[dic objectForKey:@"state"] intValue] || !dict || !dict.count) {
        [Common TipDialog2:[dic objectForKey:@"msg"]];
        if (!m_txtPassWord) {
            [self removeAdvView];
            [self createView];
        }
        m_isLoading = NO;
        return;
    }
    if ([loader.username isEqualToString:LOGIN_API_URL]) {
        
        g_nowUserInfo = [Common initWithUserInfoDict:[dict objectForKey:@"body"]];
        [APP_DELEGATE2 setUserID:g_nowUserInfo.userid];
        
        [self removeAdvView];

        BOOL isSel = NO;
        if (m_checkBox.checked) {
            isSel = YES;
        }
        if (m_txtPassWord) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isSel] forKey:@"checkstatus"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self saveUserAccount];
        }
        
        if ([dict[@"body"][@"need_info"] integerValue] == 1) {
            PerfectInformation* retrieve = [[PerfectInformation alloc] init];
            retrieve.m_token = [dict objectForKey:@"body"][@"token"];
            [self.navigationController pushViewController:retrieve animated:YES];
            [retrieve release];
            return;
        }
        [self goToMainViewController];
    }
}

//清除广告页
- (void)removeAdvView
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    AppDelegate* myDelegate = [Common getAppDelegate];
    UIImageView *imageV = (UIImageView*)[myDelegate.window viewWithTag:99];
    if (!imageV) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        sleep(2.5);
        dispatch_async( dispatch_get_main_queue(), ^(void){
            
            [UIView animateWithDuration:0.2 animations:^{
                imageV.alpha = 0;
            } completion:^(BOOL finished) {
                [imageV removeFromSuperview];
            }];
        });
    });
}

//进入首页
- (void)goToMainViewController
{
    DefauleViewController* nav = [[DefauleViewController alloc] init];
    UIImage* nowViewImage = [CommonImage imageWithView:self.view];
    APP_DELEGATE.rootViewController = nav;
    [nav release];
    
    UIImageView *imageV = (UIImageView*)[APP_DELEGATE viewWithTag:99];
    if (imageV) {
        [APP_DELEGATE bringSubviewToFront:imageV];
    }
    
    if (m_isLoading) {
        return;
    }
    UIImageView* nowView = [[UIImageView alloc] initWithImage:nowViewImage];
    nowView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight + 64);
    [APP_DELEGATE addSubview:nowView];
    [nowView release];
    [APP_DELEGATE bringSubviewToFront:nowView];
    
    if (imageV) {
        [APP_DELEGATE bringSubviewToFront:imageV];
    }
    
    [UIView animateWithDuration:0.35 animations:^{
        nowView.transform = CGAffineTransformMakeTranslation(0, kDeviceHeight+64);
    } completion:^(BOOL finished) {
        [nowView removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self HideKeyboard];
}

#pragma mark -
#pragma mark Responding to keyboard events
//当键盘出现时候上移坐标
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    CGFloat keyH = keyboardSize.height + m_keyHeight;
    
    if (keyH > kDeviceHeight) {
        keyH = kDeviceHeight-keyboardSize.height - m_keyHeight-15;
        [UIView animateWithDuration:0.35 animations:^{
            CGRect originFrame = APP_DELEGATE.frame;
            originFrame.origin.y += keyH/2.0;
            self.view.frame = originFrame;
        }];
    }
}

//当键盘消失时候下移坐标
- (void)keyboardWillHide:(NSNotification*)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    CGFloat keyH = keyboardSize.height + m_keyHeight;
    if (keyH > kDeviceHeight) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = APP_DELEGATE.frame;
        }];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [m_txtUserName release];
    [m_txtPassWord release];
    [m_checkBox release];
    [noremalImgeArrays release];
    [super dealloc];
}

@end
