//
//  EditPwdViewController.m
//  jiuhaoHealth2.0
//
//  Created by 徐国洪 on 14-3-20.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import "EditPwdViewController.h"
#import "Global.h"
#import "Global_Url.h"

#import "Common.h"
#import "CommonHttpRequest.h"
#import "LoginViewController.h"
#import "SFHFKeychainUtils.h"

@interface EditPwdViewController () <UITextFieldDelegate>

@end

@implementation EditPwdViewController {
    BOOL _isRising;
}
- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"密码修改", nil);
        _isRising = NO;
        self.log_pageID = 43;

    }
    return self;
}

- (void)createSaveBtn:(CGFloat)h
{
    UIButton* btn_save = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_save.frame = CGRectMake(25, h, kDeviceWidth-50, 45);
    [btn_save setTitleColor:[CommonImage colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [btn_save setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
    btn_save.titleLabel.font = [UIFont systemFontOfSize:18];
    btn_save.layer.cornerRadius = btn_save.height/2;
    btn_save.clipsToBounds = YES;
    btn_save.tag = 88;
    btn_save.userInteractionEnabled = NO;
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"cccccc"]];
    [btn_save setBackgroundImage:image forState:UIControlStateNormal];
    [btn_save addTarget:self action:@selector(butEventOK) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_save];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [super viewWillDisappear:animated];
    /* No longer listen for keyboard */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /* No longer listen for keyboard */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (NSMutableAttributedString*)replaceRedColorWithNSString:(NSString*)str andUseKeyWord:(NSString*)keyWord andWithFontSize:(float)s
{
    NSMutableAttributedString* attrituteString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{ NSForegroundColorAttributeName : [UIColor grayColor],
                                      NSFontAttributeName : [UIFont systemFontOfSize:s] }
                             range:range];
    return attrituteString;
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    if (_isRising == YES) {
        self.view.frame = CGRectMake(0, IOS_7 ? 64 : 0, kDeviceWidth, self.view.bounds.size.height);
        _isRising = NO;
    }
}

//点击返回按钮返回主界面
- (void)LeftBarButtonItemPressed
{
    //	[self HideKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    // Do any additional setup after loading the view.
    [self creatView];
}

- (void)creatView
{
    UIImage * image = [UIImage imageNamed:@"common.bundle/login/passwrold_nor"];

    UIView* cleanView = [[[UIView alloc] initWithFrame:CGRectMake(0, 25, kDeviceWidth, 50*3)] autorelease];
    cleanView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:cleanView];

    m_textOldPwd = [self createTextField:NSLocalizedString(@"请输入当前密码", nil)];
    [m_textOldPwd setSecureTextEntry:YES];
    m_textOldPwd.returnKeyType = UIReturnKeyNext;
    m_textOldPwd.tag = 201;
    m_textOldPwd.clearButtonMode = YES;
    m_textOldPwd.frame = CGRectMake(25, 0, kDeviceWidth-50-image.size.width, 50);
    [cleanView addSubview:m_textOldPwd];
//    [m_textOldPwd becomeFirstResponder];

    m_textNewPwd1 = [self createTextField:NSLocalizedString(@"请输入新密码", nil)];
    [m_textNewPwd1 setSecureTextEntry:YES];
    m_textNewPwd1.returnKeyType = UIReturnKeyNext;
    m_textNewPwd1.tag = 202;
    m_textNewPwd1.delegate = self;
    m_textNewPwd1.clearButtonMode = YES;
    m_textNewPwd1.frame = CGRectMake(m_textOldPwd.left, m_textOldPwd.bottom, m_textOldPwd.width, m_textOldPwd.height);
    [cleanView addSubview:m_textNewPwd1];

    m_textNewPwd2 = [self createTextField:NSLocalizedString(@"请再次输入新密码", nil)];
    [m_textNewPwd2 setSecureTextEntry:YES];
    m_textNewPwd2.returnKeyType = UIReturnKeyDone;
    m_textNewPwd2.tag = 203;
    m_textNewPwd2.clearButtonMode = YES;
    m_textNewPwd2.frame = CGRectMake(m_textOldPwd.left, m_textNewPwd1.bottom, m_textOldPwd.width, m_textOldPwd.height);
    [cleanView addSubview:m_textNewPwd2];

    UIView* view;
    UIButton * seeBtn;
    for (int i = 0; i < 3; i++) {
        
        seeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        seeBtn.frame = CGRectMake(kDeviceWidth-image.size.width-25, 50 * i, image.size.width, m_textOldPwd.height);
        seeBtn.tag = 100+i;
        [seeBtn setImage:[UIImage imageNamed:@"common.bundle/login/passwrold_nor"] forState:UIControlStateNormal];
        [seeBtn setImage:[UIImage imageNamed:@"common.bundle/login/passwrold_pre"] forState:UIControlStateSelected];
        [seeBtn addTarget:self action:@selector(isSee:) forControlEvents:UIControlEventTouchUpInside];
        [cleanView addSubview:seeBtn];
        
        view = [[UIView alloc] initWithFrame:CGRectMake(25, 50+50 * i-0.25, kDeviceWidth-50, 0.5)];
        view.backgroundColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
        [cleanView addSubview:view];
        [view release];

    }
    
    [self createSaveBtn:cleanView.bottom+30];
}

- (void)isSee:(UIButton*)btn
{
    btn.selected = !btn.selected;
    UITextField * textF = nil;
    switch (btn.tag-100) {
        case 0:
            textF = m_textOldPwd;
            break;
        case 1:
            textF = m_textNewPwd1;
            break;
        case 2:
            textF = m_textNewPwd2;
            break;
        default:
            break;
    }
    textF.secureTextEntry = !textF.secureTextEntry;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
//    if (textField == m_textNewPwd1 && IS_4_INCH_SCREEN == NO && _isRising == NO) {
//        self.view.frame = CGRectMake(0, -30, 320, self.view.bounds.size.height);
//        _isRising = YES;
//    }
//    if (textField == m_textNewPwd2 && IS_4_INCH_SCREEN == NO && _isRising == NO) {
//        self.view.frame = CGRectMake(0, -30, 320, self.view.bounds.size.height);
//        _isRising = YES;
//    }
    return YES;
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if (textField == m_textNewPwd1 && IS_4_INCH_SCREEN == NO)
//    {
//        self.view.transform = CGAffineTransformMakeTranslation(0,260);
//    }
//}

- (UITextField*)createTextField:(NSString*)title
{
    UITextField* text = [[UITextField alloc] init];
    text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    text.contentMode = UIViewContentModeCenter;
    text.autocapitalizationType = UITextAutocapitalizationTypeNone;
    text.placeholder = title;
    //    text.backgroundColor = [UIColor whiteColor];
    text.clearButtonMode = YES;
    text.delegate = self;
    [text setValue:[CommonImage colorWithHexString:@"#cccccc"] forKeyPath:@"_placeholderLabel.textColor"];
    [text setTextColor:[CommonImage colorWithHexString:@"#666666"]];
    [text setFont:[UIFont systemFontOfSize:17]];

    return text;
}

- (BOOL)butEventOK
{
    [self HideKeyboard];

    if (m_textOldPwd.text.length == 0) {
        [Common TipDialog:NSLocalizedString(@"请输入原密码", nil)];

        [m_textOldPwd becomeFirstResponder];
        return NO;
    }
    if ([self judgeThePass]) {
        return NO;
    }

	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	[dic setObject:m_textOldPwd.text forKey:@"old_pwd"];
	[dic setObject:m_textNewPwd1.text forKey:@"new_pwd"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:UPDATE_USER_PWD values:dic requestKey:UPDATE_USER_PWD delegate:self controller:self actiViewFlag:1 title:nil];
    return YES;
    
}

- (BOOL)judgeThePass
{
    if ([m_textNewPwd1.text length] == 0 ) {
        [Common createAlertViewWithString:@"密码不能为空！" withDeleagte:nil];
        return YES;
    }else
        if ([m_textNewPwd2.text length] == 0) {
            [Common createAlertViewWithString:@"确认密码不能为空！" withDeleagte:nil];
            return YES;
    }else
    if ([m_textNewPwd1.text length] < 6) {
        [Common createAlertViewWithString:@"密码长度必须大于6位！" withDeleagte:nil];
        return YES;
    }else
    if (![m_textNewPwd1.text isEqualToString:m_textNewPwd2.text]) {
        [Common createAlertViewWithString:@"两次输入的密码不一致！" withDeleagte:nil];
        m_textNewPwd1.text = @"";
        m_textNewPwd2.text = @"";
        [m_textNewPwd1 becomeFirstResponder];
        return YES;
    }else
    if ([m_textNewPwd1.text length] >14) {
        [Common createAlertViewWithString:@"密码长度必须小于15位！" withDeleagte:nil];
        return YES;
    }
    return NO;
}


- (void)HideKeyboard
{
    [m_textOldPwd resignFirstResponder];
    [m_textNewPwd1 resignFirstResponder];
    [m_textNewPwd2 resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    switch (textField.tag) {
    case 201:
        [m_textNewPwd1 becomeFirstResponder];
        break;
    case 202:
        [m_textNewPwd2 becomeFirstResponder];
        break;
    case 203:
        [m_textNewPwd2 resignFirstResponder];
        break;
    }
    return YES;
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    [self butLogOutEvent];
}

- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self butLogOutEvent];
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}


- (void)didFinishSuccess:(ASIHTTPRequest*)loader
{
    if ([loader.username isEqualToString:UPDATE_USER_PWD]) {
        NSString* responseString = [loader responseString];
        NSDictionary* dic = [responseString KXjSONValueObject];
        
        if (![[dic[@"head"] objectForKey:@"state"] intValue]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pwd"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"密码修改成功,请重新登录", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
            [av show];
            [av release];
        } else {
            [Common TipDialog2:[dic[@"head"] objectForKey:@"msg"]];
            return;
        }
    }
}

- (void)butLogOutEvent
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"checkstatus"];
    NSString* name = [CommonUser getUserName];
    [SFHFKeychainUtils deleteItemForUsername:name andServiceName:BUNDLE_IDENTIFIER error:NULL];
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    LoginViewController* logn = [[LoginViewController alloc] init];
    CommonNavViewController* nav = [[CommonNavViewController alloc] initWithRootViewController:logn];
    UIImage* nowViewImage = [CommonImage imageWithView:self.navigationController.view];
    APP_DELEGATE.rootViewController = nav;
    [nav release];
    
    UIImageView* nowView = [[UIImageView alloc] initWithImage:nowViewImage];
    nowView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight + 64);
    [APP_DELEGATE addSubview:nowView];
    [nowView release];
    [APP_DELEGATE bringSubviewToFront:nowView];
    
    [UIView animateWithDuration:0.35 animations:^{
        nowView.transform = CGAffineTransformMakeTranslation(0, kDeviceHeight+64);
    } completion:^(BOOL finished) {
        [nowView removeFromSuperview];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *changeString = [NSMutableString stringWithString:textField.text];
    [changeString replaceCharactersInRange:range withString:string];

    if ([changeString length]>14) {
        return NO;
    }
    
    if ([m_textOldPwd.text length] && [m_textNewPwd1.text length] && [m_textNewPwd2.text length]) {
        UIButton * btn_save = (UIButton*)[self.view viewWithTag:88];
        btn_save.userInteractionEnabled = YES;
        UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:The_ThemeColor]];
        [btn_save setBackgroundImage:image forState:UIControlStateNormal];

    }
    
    return YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    //    [self HideKeyboard];
}

- (void)dealloc
{
    [m_textOldPwd release];
    [m_textNewPwd1 release];
    [m_textNewPwd2 release];

    [super dealloc];
}

@end
