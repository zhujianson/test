//
//  FastLoginViewController.m
//  healthManagement1.0
//
//  Created by xuguohong on 16/7/20.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "FastLoginViewController.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "TencentOpenAPI/TencentOAuth.h"
#import "YRilView.h"
#import "ChangesReginViewController.h"
#import "DefauleViewController.h"
#import "Global.h"
#import "ForgotPasswordViewController.h"
#import "PerfectInformation.h"
#import "RetrievePasswordViewController.h"
#import "KXShareManager.h"
#import "HomeModel.h"

@interface FastLoginViewController () <UITextFieldDelegate>
{
    UITextField *m_phoneText;
    UITextField *m_codeText;
    
    UIView *m_codeView;
    
    UIButton *m_butLogin;
    UIButton *m_butCode;
    
    NSTimer *m_timer;
    
    int timing;
    
    NSDictionary *textDic;
    
    NSString *phoneStr;
}

@end

@implementation FastLoginViewController

- (void)createNavClose
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@" 关闭" style:UIBarButtonItemStyleDone target:self action:@selector(butClose)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)butClose
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    float y = 26;
    if ([self.title isEqualToString:@"绑定手机号"]) {
        
        [self createNavClose];
        
        UILabel *labTitle = [Common createLabel];
        labTitle.frame = CGRectMake(25, 10, kDeviceWidth-50, 40);
        labTitle.text = @"您目前为游客模式，请先登录，查看完整信息！";
        labTitle.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:labTitle];
        
        y = labTitle.bottom;
    }
    
    //手机号
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(25, y, kDeviceWidth-50, 50)];
    [self.view addSubview:view1];
    
    UIButton *butCountry = [UIButton buttonWithType:UIButtonTypeCustom];
    butCountry.frame = CGRectMake(0, 0, 60, view1.height);
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
    
    m_phoneText = [self createTextField:@"请输入手机号"];
    [m_phoneText setKeyboardType:UIKeyboardTypeNumberPad];
    m_phoneText.frame = CGRectMake(butCountry.right+15, 0, view1.width-butCountry.right-15, view1.height);
    [view1 addSubview:m_phoneText];
    
    UIView *line = [[UILabel alloc] initWithFrame:CGRectMake(0, view1.height - 0.5, view1.width, 0.5)];
    line.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
    [view1 addSubview:line];
    
    //验证码
    m_codeView = [[UIView alloc] initWithFrame:CGRectMake(view1.left, view1.bottom, view1.width, view1.height)];
    m_codeView.alpha = 0;
    [self.view addSubview:m_codeView];
    
    m_codeText = [self createTextField:@"验证码"];
    [m_codeText setKeyboardType:UIKeyboardTypeNumberPad];
    m_codeText.frame = CGRectMake(0, 0, view1.width-100, view1.height);
    [m_codeView addSubview:m_codeText];
    
    m_butCode = [UIButton buttonWithType:UIButtonTypeCustom];
    m_butCode.frame = CGRectMake(m_codeText.right, 0, 100, view1.height);
    [m_butCode setTitleColor:[CommonImage colorWithHexString:@"37de80"] forState:UIControlStateNormal];//
    [m_butCode setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateDisabled];//666666
    [m_butCode addTarget:self action:@selector(getCodeForServer) forControlEvents:UIControlEventTouchUpInside];
    [m_butCode setTitle:@"重新发送" forState:UIControlStateNormal];
    m_butCode.titleLabel.font = [UIFont systemFontOfSize:14];
    [m_codeView addSubview:m_butCode];
    
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, m_codeView.height - 0.5, m_codeView.width, 0.5)];
    line.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
    [m_codeView addSubview:line];
    
    //
    m_butLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    m_butLogin.layer.cornerRadius = 22.5;
    m_butLogin.clipsToBounds = YES;
    m_butLogin.enabled = NO;
    m_butLogin.frame = CGRectMake(m_codeView.left, view1.bottom+30, m_codeView.width, 45);
    [m_butLogin setTitle:@"下一步" forState:UIControlStateNormal];
    [m_butLogin setBackgroundImage:[CommonImage createImageWithColor:[CommonImage colorWithHexString:@"cccccc"]] forState:UIControlStateDisabled];
    [m_butLogin setBackgroundImage:[CommonImage createImageWithColor:[CommonImage colorWithHexString:@"37de80"]] forState:UIControlStateNormal];
    [m_butLogin addTarget:self action:@selector(denglu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_butLogin];
    
    
    if ([WXApi isWXAppInstalled] && [self.title isEqualToString:@"快速登录"]) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(m_codeView.left, kDeviceHeight - 150-10, m_codeView.width, 1)];
        line.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common.bundle/common/xuxian.png"]];
        [self.view addSubview:line];
        
        UILabel *labTitle = [Common createLabel];
        labTitle.backgroundColor = [UIColor whiteColor];
        labTitle.frame = CGRectMake((kDeviceWidth-100)/2.f, line.top-10, 100, 20);
        labTitle.text = @"第三方账号登录";
        labTitle.font = [UIFont systemFontOfSize:13];
        labTitle.textColor = [CommonImage colorWithHexString:@"999999"];
        labTitle.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:labTitle];
        
        UIImage *image = [UIImage imageNamed:@"common.bundle/login/weixin.png"];
        UIButton *butWeixin = [UIButton buttonWithType:UIButtonTypeCustom];
        butWeixin.frame = CGRectMake((kDeviceWidth-80)/2.f, labTitle.bottom+30, 80, 80);
        [butWeixin setTitle:@"微信登录" forState:UIControlStateNormal];
        [butWeixin setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
        butWeixin.titleLabel.font = [UIFont systemFontOfSize:13];
        [butWeixin setImage:image forState:UIControlStateNormal];
        [butWeixin addTarget:self action:@selector(threeLogin:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:butWeixin];
        
        CGSize size = butWeixin.currentImage.size;
        float widht = [butWeixin.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:butWeixin.titleLabel.font}].width;
        [butWeixin setImageEdgeInsets:UIEdgeInsetsMake(-20, 0, 20, -widht)];
        [butWeixin setTitleEdgeInsets:UIEdgeInsetsMake(size.height/2+5, -size.width, -size.height/2-5, 0)];
        
//        [noremalImgeArrays addObject:@"common.bundle/login/login_btn_wechat.png"];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if (IOS_7) {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    }
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

- (void)setShowCodeView:(BOOL)is
{
    float y;
    if (is) {
        y = 45;
    }
    else {
        y = 0;
    }
    
    if (m_codeView.alpha != is) {
        m_butLogin.enabled = is;
        [UIView animateWithDuration:0.2 animations:^{
            m_codeView.alpha = is;
            m_butLogin.transform = CGAffineTransformMakeTranslation(0, y);
        }];
    }
}

- (void)getCodeForServer
{
    if (m_phoneText.text.length == 0) {
        NSString *str = [NSString stringWithFormat:@"请输入手机号"];
        [Common TipDialog:NSLocalizedString(str, nil)];
        [m_phoneText becomeFirstResponder];
        return;
    }
    phoneStr = m_phoneText.text;
    if (![textDic[@"regin"] isEqualToString:@"中国大陆"] && textDic) {
        phoneStr = [NSString stringWithFormat:@"%@%@",textDic[@"num"],m_phoneText.text];
    }
    
    // 获取验证码
//    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
//    [dic setObject:phoneStr forKey:@"phone"];
//    [[CommonHttpRequest defaultInstance] sendNewPostRequest:CHECKPHOTO_API_URL values:dic requestKey:CHECKPHOTO_API_URL delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"加载中...", nil)];
    //获取验证码
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:phoneStr forKey:@"phone"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:REGISTER_API_URL values:dic requestKey:REGISTER_API_URL delegate:self controller:self actiViewFlag:0 title:NSLocalizedString(@"加载中...", nil)];
    
    if (!m_timer) {
        m_timer = [[NSTimer alloc] initWithFireDate:[NSDate distantFuture] interval:1 target:self selector:@selector(timeBegin) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:m_timer forMode:NSDefaultRunLoopMode];
    }
    timing = 90;
    [m_timer setFireDate:[NSDate date]]; //继续。
    
    m_butCode.enabled = NO;
    
    [self setShowCodeView:YES];
    if ([self.title isEqualToString:@"快速登录"]) {
    [m_butLogin setTitle:@"登录" forState:UIControlStateNormal];
    }else{
        [m_butLogin setTitle:@"下一步" forState:UIControlStateNormal];
    }
}

- (void)denglu:(UIButton*)but
{
    if ([but.titleLabel.text isEqualToString:@"下一步"] && !m_codeView.alpha) {
        [self getCodeForServer];
        self.title = @"输入验证码";
        return;
    }
    
    if (m_phoneText.text.length == 0) {
        NSString *str = [NSString stringWithFormat:@"请输入手机号"];
        [Common TipDialog:NSLocalizedString(str, nil)];
        [m_phoneText becomeFirstResponder];
        return;
    }
    
    if (m_codeText.text.length == 0) {
        NSString *str = [NSString stringWithFormat:@"请输入验证码"];
        [Common TipDialog:NSLocalizedString(str, nil)];
        [m_codeText becomeFirstResponder];
        return;
    }
    
    if ([self.title isEqualToString:@"快速登录"] || [self.title isEqualToString:@"输入验证码"]) {
        
        // 获取验证码
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        [dic setObject:m_phoneText.text forKey:@"phone"];
        [dic setObject:m_codeText.text forKey:@"code"];
        [[CommonHttpRequest defaultInstance] sendNewPostRequest:login_by_mobile_code values:dic requestKey:login_by_mobile_code delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"加载中...", nil)];
    }
    else if ([self.title isEqualToString:@"绑定手机号"]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:m_phoneText.text forKey:@"phone"];
        [dic setObject:m_codeText.text forKey:@"code"];
        [[CommonHttpRequest defaultInstance] sendNewPostRequest:validateBind values:dic requestKey:validateBind delegate:self controller:self actiViewFlag:1 title:nil];
    }
    else {
        
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        [dic setObject:phoneStr forKey:@"phone"];
        [dic setObject:m_codeText.text forKey:@"code"];
        [[CommonHttpRequest defaultInstance] sendNewPostRequest:EMAILTWO_API_URL values:dic requestKey:EMAILTWO_API_URL delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"加载中...", nil)];
    }
}

- (void)selectCountry:(UIButton*)but
{
    ChangesReginViewController *change = [[ChangesReginViewController alloc] init];
    change.textDic = textDic;
    [change setChangesReginBlock:^(NSDictionary *dic) {
        UILabel *lab = (UILabel*)[self.view viewWithTag:11];
        lab.text = dic[@"regin"];
        lab = (UILabel*)[self.view viewWithTag:12];
        lab.text = [NSString stringWithFormat:@"(%@)",dic[@"num"]];
        
        textDic = dic;
        
        if (![textDic[@"regin"] isEqualToString:@"中国大陆"] && textDic) {
            timing = 90*2;
        } else {
            timing = 90;
        }
        
        [but setTitle:[NSString stringWithFormat:@"+%@", textDic[@"num"]] forState:UIControlStateNormal];
        float width = [Common sizeForString:but.titleLabel.text andFont:but.titleLabel.font.pointSize].width;
        [but setTitleEdgeInsets:UIEdgeInsetsMake(0, MIN(width-but.width+4, 0), 0, 0)];
        [but setImageEdgeInsets:UIEdgeInsetsMake(0, width+7, 0, 0)];
    }];
    [self.navigationController pushViewController:change animated:YES];
}

- (void)timeBegin
{
    timing--;
    
    if (!timing) {
        m_butCode.enabled = YES;
        
        [m_timer setFireDate:[NSDate distantFuture]];//暂停
//        [m_butCode setTitle:@"重新发送" forState:UIControlStateNormal];
        return;
    }
    [m_butCode setTitle:[NSString stringWithFormat:@"%d秒后重发", timing] forState:UIControlStateDisabled];
}

-(void)sendAuthRequest
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *changeString = [NSMutableString stringWithString:textField.text];
    [changeString replaceCharactersInRange:range withString:string];
    if (textField == m_phoneText) {
        if ([changeString length] >= 7) {
            
            m_butLogin.enabled = YES;
            
            if ([changeString length]>11) {
                return NO;
            }
        }
        else {
//            m_codeText.text = @"";
            if ([m_butLogin.titleLabel.text isEqualToString:@"下一步"]) {
                
                m_butLogin.enabled = NO;
            }
//            [self setShowCodeView:NO];
//            [m_butLogin setTitle:@"下一步" forState:UIControlStateNormal];
        }
    }
    
//    if (m_phoneText.text.length >= 7 && m_codeText.text.length > 1) {
//        [m_butLogin setTitle:@"登录" forState:UIControlStateNormal];
//    }
//    else {
//        [m_butLogin setTitle:@"gh" forState:UIControlStateNormal];
//    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:m_phoneText]) {
        [m_codeText resignFirstResponder];
    }
    return YES;
}

- (void)threeLogin:(UIButton*)btn
{
    //判断是否授权
//    BOOL is = [ShareSDK hasAuthorized:SSDKPlatformTypeWechat];
//    if (!is) {
    
        WSS(weakSelf);
        [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error){
            
            if (state == SSDKResponseStateSuccess)
            {
                NSLog(@"uid=%@",user.uid);
                NSLog(@"%@",user.credential);
                NSLog(@"token=%@",user.credential.token);
                NSLog(@"nickname=%@",user.nickname);
                [weakSelf sendThirdLoginRequetWithUerId:user.uid withName:user.nickname];
                
                //存贮第三方账号信息
                [[NSUserDefaults standardUserDefaults] setObject:user.uid forKey:@"thirdUserInfo"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else {
                [Common TipDialog:@"授权失败"];
            }
        }];
//    }
//    else {
//        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"thirdUserInfo"];
//        [self sendThirdLoginRequetWithUerId:token];
//    }
}
//- (void)loginBtnClickHandler:(id)sender
//{
//    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
//                      authOptions:nil
//                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
//                               if (result)
//                               {
//                                   PFQuery *query = [PFQuery queryWithClassName:@"UserInfo"];
//                                   [query whereKey:@"uid" equalTo:[userInfo uid]];
//                                   [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//                                       
//                                       if ([objects count] == 0)
//                                       {
//                                           PFObject *newUser = [PFObject objectWithClassName:@"UserInfo"];
//                                           [newUser setObject:[userInfo uid] forKey:@"uid"];
//                                           [newUser setObject:[userInfo nickname] forKey:@"name"];
//                                           [newUser setObject:[userInfo profileImage] forKey:@"icon"];
//                                           [newUser saveInBackground];
//                                           
//                                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"欢迎注册" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//                                           [alertView show];
//                                           [alertView release];
//                                       }
//                                       else
//                                       {
//                                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"欢迎回来" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//                                           [alertView show];
//                                           [alertView release];
//                                       }
//                                   }];
//                                   
//                                   MainViewController *mainVC = [[[MainViewController alloc] init] autorelease];
//                                   [self.navigationController pushViewController:mainVC animated:YES];
//                                   
//                               }
//                               
//                           }];
//}
- (void)sendThirdLoginRequetWithUerId:(NSString *)thirdUserid withName:(NSString*)name
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:thirdUserid forKey:@"third_id"];
    [dic setObject:@"wechar" forKey:@"third_type"];
    [dic setObject:name forKey:@"userName"];
    NSLog(@"%@", dic);
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:LOGIN_API_THIRD values:dic requestKey:LOGIN_API_THIRD delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"加载中...", nil)];
}

- (void)getMyInfo
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    
    //获取个人信息
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GETMYINFO_API_URL values:dic requestKey:GETMYINFO_API_URL delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"获取个人信息...", nil)];
}

- (void)didFinishFail:(ASIHTTPRequest*)loader
{

}

- (void)didFinishSuccess:(ASIHTTPRequest*)loader
{
    NSString* responseString = [loader responseString];
    NSDictionary* dict = [responseString KXjSONValueObject];
    
    NSDictionary *head = dict[@"head"];
    if ([head[@"state"] intValue]) {
        
        [Common TipDialog2:[head objectForKey:@"msg"]];
        
        if ([loader.username isEqualToString:CHECKPHOTO_API_URL])
        {
            [m_timer setFireDate:[NSDate distantFuture]];//暂停
            m_butCode.enabled = YES;
        }
    }
    else {
        
        NSDictionary *body = dict[@"body"];
        if ([loader.username isEqualToString:CHECKPHOTO_API_URL])
        {
            //获取验证码
            NSMutableDictionary* dic = [NSMutableDictionary dictionary];
            [dic setObject:phoneStr forKey:@"phone"];
            [[CommonHttpRequest defaultInstance] sendNewPostRequest:REGISTER_API_URL values:dic requestKey:REGISTER_API_URL delegate:self controller:self actiViewFlag:0 title:NSLocalizedString(@"加载中...", nil)];
        }
        else if ([loader.username isEqualToString:REGISTER_API_URL]) { //
            NSLog(@"1231231");
        }
        else if ([loader.username isEqualToString:login_by_mobile_code]) { //快速登录
            
            g_nowUserInfo = [Common initWithUserInfoDict:[dict objectForKey:@"body"]];
            
            if ([dict[@"body"][@"need_info"] integerValue] == 1) {
                PerfectInformation* retrieve = [[PerfectInformation alloc] init];
                retrieve.m_token = [dict objectForKey:@"body"][@"token"];
                [self.navigationController pushViewController:retrieve animated:YES];
                return;
            }
            [self goToMainViewController];
        }
        else if ([loader.username isEqualToString:EMAILTWO_API_URL]) {
            
            //找回密码
            ForgotPasswordViewController* basic = [[ForgotPasswordViewController alloc] init];
            basic.phoneStr = phoneStr;
            basic.verificationStr = m_codeText.text;
            basic.type = 2;
            [self.navigationController pushViewController:basic animated:YES];
        }
        else if ([loader.username isEqualToString:validateBind]) {
            g_nowUserInfo.mobilePhone = phoneStr;
            g_nowUserInfo.userToken = head[@"msg"];
            
//            g_nowUserInfo = [Common initWithUserInfoDict:head];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getMyInformation" object:nil];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        else if ([loader.username isEqualToString:LOGIN_API_THIRD])
        {
//            if ([body[@"need_info"] integerValue] == 1) {
//                //第三方第一次登陆，续注册
//                RetrievePasswordViewController* retrieve = [[RetrievePasswordViewController alloc] initWithType:1];
//                retrieve.title = @"绑定手机号";
////                retrieve.isComeFromQQ = YES;
//                retrieve.thirdStr = body[@"third_id"];
//                [self.navigationController pushViewController:retrieve animated:YES];
//            }
//            else {
            g_nowUserInfo = [Common initWithUserInfoDict:body];
            g_nowUserInfo.thirdLogin = YES;
            [self goToMainViewController];
//            }
        }
    }
}

//进入首页
- (void)goToMainViewController
{
    DefauleViewController* nav = [[DefauleViewController alloc] init];
    UIImage* nowViewImage = [CommonImage imageWithView:self.view];
    APP_DELEGATE.rootViewController = nav;
    

    UIImageView* nowView = [[UIImageView alloc] initWithImage:nowViewImage];
    nowView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight + 64);
    [APP_DELEGATE addSubview:nowView];
    [APP_DELEGATE bringSubviewToFront:nowView];
    
    [UIView animateWithDuration:0.35 animations:^{
        nowView.transform = CGAffineTransformMakeTranslation(0, kDeviceHeight+64);
    } completion:^(BOOL finished) {
        [nowView removeFromSuperview];
    }];
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
