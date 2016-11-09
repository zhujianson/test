//
//  FirstLogingViewController.m
//  healthManagement1.0
//
//  Created by xjs on 16/7/20.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "FirstLogingViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "FastLoginViewController.h"

@interface FirstLogingViewController () <UITextFieldDelegate>
{
    
    UITextField *m_txtURL;
}

@end

@implementation FirstLogingViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if ([self.navigationController.viewControllers count] == 1){
//        self.navigationController.navigationBar.hidden = YES;
//    }
    /* Listen for keyboard */
    if (IOS_7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /* No longer listen for keyboard */
//    float y = 20;
//    if (IOS_7) {
//        y = 0;
//    }
//    UIImageView* imageViewTest = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, kDeviceWidth, kDeviceHeight + 64)];
//    imageViewTest.image = [CommonImage imageWithView:self.view];
//    imageViewTest.contentMode = UIViewContentModeTop;
//    [APP_DELEGATE addSubview:imageViewTest];
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
//    if (IOS_7) {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    }
    
}

- (void)viewDidLoad {
    self.m_isHideNavBar = YES;
    [super viewDidLoad];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage * image = [UIImage imageNamed:@"common.bundle/login/logingIcon"];
    UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    icon.image = image;
    icon.contentMode = UIViewContentModeCenter;
    icon.center = CGPointMake(kDeviceWidth/2, (kDeviceHeight-160)/2);
    [self.view addSubview:icon];
    
    UIButton * btn;
    for (int i = 0; i<2; i++) {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame  = CGRectMake(40, kDeviceHeight+64-310/2+60*i, kDeviceWidth-80, 45);
        [btn setTitle:i?@"已有账号登录":@"快速登录" forState:UIControlStateNormal];
        [btn setTitleColor:[CommonImage colorWithHexString:i?@"666666":@"ffffff"] forState:UIControlStateNormal];
        btn.tag = 100+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        [btn addTarget:self action:@selector(chooseLoad:) forControlEvents:UIControlEventTouchUpInside];
        image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:i?@"ffffff":The_ThemeColor]];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        [self.view addSubview:btn];
        btn.layer.cornerRadius = btn.height/2;
        btn.layer.borderColor = [CommonImage colorWithHexString:@"cccccc"].CGColor;
        btn.layer.borderWidth = 0.5;
        btn.clipsToBounds = YES;
    }
    
//    m_txtURL = [self createTextField:NSLocalizedString(@"服务器完整地址", nil)];
//    m_txtURL.clearButtonMode = NO;
//    m_txtURL.returnKeyType = UIReturnKeyDone;
//    m_txtURL.backgroundColor = [UIColor redColor];
//    m_txtURL.frame = CGRectMake(0, 20, kDeviceWidth, 47);
//    [self.view addSubview:m_txtURL];
//    [m_txtURL release];
    
    [self removeAdvView];

    // Do any additional setup after loading the view.
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

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == m_txtURL) {
        g_url = [[NSString alloc] initWithString:textField.text];
    }
}

- (void)chooseLoad:(UIButton*)btn
{
    switch (btn.tag-100) {
        case 0:
        {
            FastLoginViewController * fast = [[FastLoginViewController alloc]init];
            fast.title = @"快速登录";
            [self.navigationController pushViewController:fast animated:YES];
            
        }
            break;
        case 1:
        {
            LoginViewController * load = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:load animated:YES];
        }
            break;
   
        default:
            break;
    }
}

//清除广告页
- (void)removeAdvView
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    if (IOS_7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    
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
