//
//  HealthAlerNameVCViewController.m
//  jiuhaohealth2.1
//
//  Created by jiuhao-yangshuo on 14-8-18.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "HealthAlerNameVCViewController.h"

@interface HealthAlerNameVCViewController ()<UITextFieldDelegate>
{
    UITextField *m_alertContent;
    HealthAlerNameVCViewControllerBlock _inBlock;
    NSString *m_viewTitle;
    NSString *m_placeHoder;
}
@end

@implementation HealthAlerNameVCViewController

@synthesize m_Content;

- (id)initWithTitle:(NSString *)title andWithPlaceHoder:(NSString *)placeHoder
{
    self = [super init];
    if (self) {
        // Custom initialization
//        [self createSaveBtn];
        self.title = title;
        m_viewTitle = title;
        m_placeHoder = placeHoder;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)createSaveBtn
{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(0, 0, 31, 44);
    [but addTarget:self action:@selector(butSaveEvent) forControlEvents:UIControlEventTouchUpInside];
    [but setImage:[UIImage imageNamed:@"common.bundle/nav/data_save.png"] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"common.bundle/nav/data_save_p.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *saveBar = [[UIBarButtonItem alloc] initWithCustomView:but];
    self.navigationItem.rightBarButtonItem = saveBar;
    [saveBar release];
}

- (void)createSaveBtn:(CGFloat)h
{
    UIButton* btn_save = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_save.frame = CGRectMake(20, h, kDeviceWidth-40, 44);
    [btn_save setTitleColor:[CommonImage colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [btn_save setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
    btn_save.titleLabel.font = [UIFont systemFontOfSize:20];
    btn_save.layer.cornerRadius = 4;
    btn_save.clipsToBounds = YES;
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
    [btn_save setBackgroundImage:image forState:UIControlStateNormal];
    [btn_save addTarget:self action:@selector(butSaveEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_save];
}

-(void)setHealthAlerNameVCViewControllerBlock:(HealthAlerNameVCViewControllerBlock)_handler
{
    _inBlock = [_handler copy];
}

- (void)butSaveEvent
{
    NSString *contentString = [m_alertContent.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (contentString.length == 0 || !m_alertContent.text)
    {
        if ([m_viewTitle isEqualToString:@"提醒内容"])
        {
            [Common TipDialog:NSLocalizedString(@"提醒内容不能为空", nil)];
        }
        else
        {
            [Common TipDialog:NSLocalizedString(@"药物名称不能为空", nil)];
        }
         return;
    }
    
    else
    {
//        ((UIButton *)[self.view viewWithTag:1]).enabled = YES;
        if([Common stringContainsEmoji:contentString])
        {
            [Common TipDialog:NSLocalizedString(@"暂不支持表情信息", nil)];
            return;
        }
    }
    _inBlock(contentString);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createContentCellView
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 35, kDeviceWidth, 44)];
    backView.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];
    [self.view addSubview:backView];
    [backView release];
    
    m_alertContent = [Common createTextField:m_placeHoder setDelegate:self setFont:17];
    m_alertContent.frame = CGRectMake(14, 0, kDeviceWidth-14, 44);
    m_alertContent.textAlignment = NSTextAlignmentLeft;
    [m_alertContent becomeFirstResponder];
    m_alertContent.textColor = [CommonImage colorWithHexString:@"666666"];
    m_alertContent.returnKeyType = UIReturnKeyDone;
    if (m_Content.length > 0)
    {
        m_alertContent.text = m_Content;
    }
    m_alertContent.clearButtonMode = UITextFieldViewModeWhileEditing;
    [backView addSubview:m_alertContent];
    
    UILabel *lineTop = [Common createLineLabelWithHeight:0];
    [backView addSubview:lineTop];
    
    UILabel *lineBottom = [Common createLineLabelWithHeight:44];
    [backView addSubview:lineBottom];
    
    [self createSaveBtn:backView.bottom+20];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [m_alertContent resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createContentCellView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [m_alertContent resignFirstResponder];
}


@end
