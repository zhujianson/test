//
//  ModifyViewController.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-4.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "ModifyViewController.h"
#import "CommonHttpRequest.h"
#import "PickerView.h"

@interface ModifyViewController ()<UITextFieldDelegate>
{
    UITextField* textFiled;
}

@end

@implementation ModifyViewController
@synthesize m_infoDic;
@synthesize m_strUrl;
//@synthesize m_Dic;
@synthesize m_isAdd,m_isFriend;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
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

- (void)butSaveEvent
{
    if ([NSString isContainsEmoji:textFiled.text])
    {
        [Common TipDialog:NSLocalizedString(@"暂不支持表情信息", nil)];
        return;
    }
    [m_infoDic setObject:textFiled.text forKey:@"nickName1"];
    if ([textFiled.text length]>10) {
        [Common TipDialog2:@"名称不能超过10位!"];
        return;
    }
    if (_m_isModify) {
        NSLog(@"修改备注名");
        if (m_isFriend)
        {
            [self ModifyTheRemark];
        }
        return;
    }
//    if (!textFiled.text.length || ![self isAllspace])
//    {
//        [Common TipDialog2:@"姓名不能为空!"];
//        return;
//    }

    if([textFiled.text isEqualToString:[m_infoDic objectForKey:@"value"]]){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if ([m_infoDic[@"is_add"] intValue] == 1) {
        [self alertView:nil clickedButtonAtIndex:0];
        return;
    }

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:textFiled.text forKey:@"nick_name"];
    if ([m_infoDic[@"is_current_user"] intValue] == 0 && m_infoDic[@"is_current_user"]) {
        [dic setObject:m_infoDic[@"id"] forKey:@"id"];
    }

    [[CommonHttpRequest defaultInstance] sendNewPostRequest:UPDATAField_API_URL values:dic requestKey:UPDATAField_API_URL delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"修改中...", nil)];
    
    UIButton * saveBtn = (UIButton*)[self.navigationController.navigationBar viewWithTag:255];
    saveBtn.userInteractionEnabled = NO;
}

- (void)dealloc{

    [m_infoDic release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_isFriend = [m_infoDic[@"m_isFriend"] boolValue];
    
    if (_m_isModify) {
        [self createModifyView];
        if (m_isFriend)
        {
            [self createSaveBtn:185];
        }
    }else{
//        self.title = [m_infoDic objectForKey:@"title"];
        [self creatName];
        [self createSaveBtn:95];
    }
}

- (void)createModifyView
{
    NSArray * arr = [NSArray arrayWithObjects:@"备注名",@"原命名", nil];
    UIView * view;
    UILabel * lab;
    for (int i = 0; i<2; i++) {
        lab = [Common createLabel:CGRectMake(20, 10+i*85, kDeviceWidth-40, 30) TextColor:@"666666" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft labTitle:arr[i]];
        [self.view addSubview:lab];
        
        view = [[UIView alloc] initWithFrame:CGRectMake(-1, lab.bottom, kDeviceWidth+2, 45)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN].CGColor;
        [self.view addSubview:view];
        UITextField* text = [[[UITextField alloc] init]autorelease];
        text.frame = CGRectMake(20, 0, kDeviceWidth-40, 45);
        text.tag = 11+i;
        text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        text.contentMode = UIViewContentModeCenter;
        text.autocapitalizationType = UITextAutocapitalizationTypeNone;
        text.clearButtonMode = YES;
        [text setTextColor:[CommonImage colorWithHexString:@"#666666"]];
        [text setFont:[UIFont systemFontOfSize:16]];
        [view addSubview:text];
        if (i) {
            text.text = m_infoDic[@"nickName"];
            text.userInteractionEnabled = NO;
        }else{
            text.placeholder = @"请输入备注名";
            text.delegate = self;
            [text addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//            if ([m_Dic[@"nickName1"] length]) {
                text.text = m_infoDic[@"nickName1"];
//            }else{
//                text.text = m_Dic[@"nickName"];
//            }
            textFiled = text;
        }
        [view release];
    }
}

- (void)ModifyTheRemark
{
    if (!textFiled.text.length || ![self isAllspace])
    {
        [Common TipDialog2:@"备注名不能为空!"];
        return;
    }

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:m_infoDic[@"friendId"] forKey:@"friendId"];
    [dic setObject:textFiled.text forKey:@"commentName"];
    [m_infoDic setObject:textFiled.text forKey:@"nickName1"];

    [[CommonHttpRequest defaultInstance] sendNewPostRequest:MODIFY_FRIEND values:dic requestKey:MODIFY_FRIEND delegate:self controller:self actiViewFlag:1 title:nil];
    UIButton * saveBtn = (UIButton*)[self.navigationController.navigationBar viewWithTag:255];
    saveBtn.userInteractionEnabled = NO;

}

/**
 *  创建修改姓名界面
 */
- (void)creatName
{
    UIView* cleanView = [[[UIView alloc] initWithFrame:CGRectMake(0, 20, kDeviceWidth, 50)] autorelease];
    cleanView.layer.borderWidth = 0.5;
    cleanView.layer.borderColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN].CGColor;
    cleanView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cleanView];

    textFiled = [[UITextField alloc]init];
    textFiled.delegate =self;
    textFiled.placeholder = @"请输入您的姓名";
    
    textFiled.font = [UIFont systemFontOfSize:17];
    textFiled.frame = CGRectMake(20, 0, kDeviceWidth-40, 50);
    textFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [textFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    textFiled.text = [m_infoDic objectForKey:@"value"]?m_infoDic[@"value"]:m_infoDic[@"nickName"];
    textFiled.delegate = self;
    textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    textFiled.layer.cornerRadius = 4;
    textFiled.clipsToBounds = YES;
    textFiled.backgroundColor = [UIColor whiteColor];
    textFiled.textColor = [UIColor blackColor];
    [cleanView addSubview:textFiled];
    [textFiled becomeFirstResponder];
    [textFiled release];
}

- (BOOL)isAllspace
{
    NSString *str = [textFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [str length];
}

/**
 *  输入进行数据转换
 *
 *  @param textField
 *  @param range
 *  @param string
 *
 *  @return 开始执行转换方法
 */
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
//    NSMutableString *changeString = [NSMutableString stringWithString:textField.text];
//    [changeString replaceCharactersInRange:range withString:string];

//    if ([changeString length]>10) {
//        return NO;
//    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
//    if (textField.text.length > 10) {
//        textField.text = [textField.text substringToIndex:10];
//    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [textFiled resignFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [m_infoDic setObject:textFiled.text forKey:@"value"];
    [m_infoDic setObject:textFiled.text forKey:@"nickName"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - NetWork Function

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dict = [responseString KXjSONValueObject];
    NSDictionary * dic = dict[@"head"];
    if (![[dic objectForKey:@"state"] intValue] == 0) {
        [Common TipDialog:[dic objectForKey:@"msg"]];
        return;
    }

    if (![[dic objectForKey:@"state"] intValue])
    {
        NSLog(@"%@",m_infoDic);
        if([loader.username isEqualToString:UPDATAField_API_URL]){
            [m_infoDic setObject:textFiled.text forKey:@"value"];
            [m_infoDic setObject:textFiled.text forKey:@"nickName"];
            
            if ([m_infoDic[@"is_current_user"] intValue]==1 || !m_infoDic[@"is_add"]) {
                g_nowUserInfo.nickName = textFiled.text;
            }
        }
        
        MBProgressHUD* progress_ = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.view.frame.size.height)];
        progress_.labelText = @"修改成功";
        progress_.mode = MBProgressHUDModeText;
        progress_.userInteractionEnabled = NO;
        [[[UIApplication sharedApplication].windows lastObject] addSubview:progress_];
        [progress_ show:YES];
        [progress_ showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [progress_ release];
            [progress_ removeFromSuperview];
        }];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [Common TipDialog:[dic objectForKey:@"msg"]];
        UIButton * saveBtn = (UIButton*)[self.navigationController.navigationBar viewWithTag:255];
        saveBtn.userInteractionEnabled = YES;
    }
}

- (void)setModifyRemarksBlock:(ModifyRemarksBlock)block
{
    _remarkBlock = [block copy];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (!m_isFriend && _m_isModify)
    {
        _remarkBlock(textFiled.text);
//        [self.navigationController popViewControllerAnimated:YES];
    }
    [super viewWillDisappear:animated];
}

@end
