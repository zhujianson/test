//
//  ApplyInfoViewController.m
//  jiuhaohealth3.0
//
//  Created by wangmin on 15-3-10.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "ApplyInfoViewController.h"
#import "ModifyViewController.h"
#import "KXTextView.h"


@interface ApplyInfoViewController ()
<UITextViewDelegate>
{
    __block NSString* m_noteName;

    
    __block MBProgressHUD* hub;
}
@property (retain, nonatomic) IBOutlet UIImageView *photoImageView;

@property (retain, nonatomic) IBOutlet UILabel *theNameLabel;

@property (retain, nonatomic) IBOutlet UILabel *secLabel;

@property (retain, nonatomic) IBOutlet UILabel *thirdLabel;

@property (retain, nonatomic) IBOutlet UIView *headerView;

//@property (retain, nonatomic) IBOutlet UIView *textViewBack;


@property (retain, nonatomic) IBOutlet UIButton *modifyNameBtn;
//@property (retain, nonatomic) IBOutlet UILabel *backCornView;
//@property (retain, nonatomic) IBOutlet UILabel *applyInfoLabel;//显示请求信息Label
@property (retain, nonatomic) IBOutlet UIButton *okBtn;
@property (retain, nonatomic) IBOutlet KXTextView *textView;//输入备注区域TextView
//@property (retain, nonatomic) IBOutlet UILabel *placeHolderLabel;
@end

@implementation ApplyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    m_noteName = @"";
    
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
    self.okBtn.backgroundColor = nil;
    [self.okBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self.okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    if(self.isApplyViewFlag){
        self.title = @"详细信息";
        self.textView.userInteractionEnabled = YES;
        self.textView.placeholder = @"备注";
//        self.applyInfoLabel.hidden = YES;
        self.modifyNameBtn.hidden = NO;
        [self.okBtn setTitle:@"添加" forState:UIControlStateNormal];
        
        if([self.dataDic[@"id"] isEqualToString:g_nowUserInfo.userid]){
            //自己的帐户不可以修改备注名
            self.modifyNameBtn.hidden = YES;
        }
    }else{
        self.title = @"新的朋友";
        self.textView.userInteractionEnabled = NO;
        self.modifyNameBtn.hidden = NO;
        self.textView.text = self.dataDic[@"content"];
//        self.placeHolderLabel.hidden = YES;
//        self.applyInfoLabel.hidden = NO;
    }
    
    if(self.isAllReadyAddedFlag){
        
        [self.okBtn setTitle:@"已添加" forState:UIControlStateNormal];
        self.okBtn.enabled = NO;
    }
    
    UILabel *line = [Common createLineLabelWithHeight:self.headerView.height];
    [self.headerView addSubview:line];
    
    self.textView.layer.borderColor = [CommonImage colorWithHexString:LINE_COLOR].CGColor;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.cornerRadius = 4;
    
    //头像设置
//    [CommonImage setPicImageQiniu:self.dataDic[@"userPhoto"] View:self.photoImageView Type:0 Delegate:nil];
    [CommonImage setImageFromServer:self.dataDic[@"userPhoto"] View:self.photoImageView Type:0];

    self.photoImageView.layer.cornerRadius = 35.0f;
    self.photoImageView.layer.masksToBounds = YES;
    
    //修改备注名圆角处理
    self.modifyNameBtn.layer.borderColor = [CommonImage colorWithHexString:LINE_COLOR].CGColor;
    self.modifyNameBtn.layer.borderWidth = 0.5;
    self.modifyNameBtn.layer.cornerRadius = 5.0f;
    self.modifyNameBtn.layer.masksToBounds = YES;
    //申请理由背景处理
//    self.backCornView.layer.cornerRadius = 5.0f;
//    self.backCornView.layer.masksToBounds = YES;
    //按钮圆角处理
    self.okBtn.backgroundColor = [CommonImage colorWithHexString:COLOR_FF5351];
    self.okBtn.layer.cornerRadius = 5.0f;
    self.okBtn.layer.masksToBounds = YES;
    NSString *remarkName = self.dataDic[@"remarkName"];
    
    self.theNameLabel.text = remarkName.length? remarkName :self.dataDic[@"nickName"];
    self.secLabel.text = self.dataDic[@"secText"];
    self.thirdLabel.text = self.dataDic[@"thirdText"];
    
//    self.applyInfoLabel.numberOfLines = 0;
    self.textView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /* Listen for keyboard */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /* No longer listen for keyboard */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark keyboard notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    if(IS_Small_INCH_SCREEN){
    
        [UIView animateWithDuration:0.25 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -100);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.view.transform = CGAffineTransformIdentity;
}


//红色按钮点击按钮响应
- (IBAction)redBtnClicked:(UIButton *)sender {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.dataDic[@"accountId"] forKey:@"id"];
    [dic setObject:m_noteName forKey:@"commentName"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:APPROVE_FRIEND_URL values:dic requestKey:APPROVE_FRIEND_URL delegate:self controller:self actiViewFlag:1 title:nil];
}

#pragma mark - NetWork Delegate

- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    
    if (![[dic[@"head"] objectForKey:@"state"] intValue])
    {
        if ([loader.username isEqualToString:APPROVE_FRIEND_URL]){
                //通过申请
            NSLog(@"-----pass");
            
            if(hub){
                [hub removeFromSuperview];
                hub = nil;
            }
            
            hub = [Common ShowMBProgress:[UIApplication sharedApplication].keyWindow MSG:@"添加成功！" Mode:MBProgressHUDModeText];
            if (self.applySuccessBlock) {
                self.applySuccessBlock();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hub removeFromSuperview];
                hub = nil;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                });
            });
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        [Common TipDialog2:[dic[@"head"] objectForKey:@"msg"]];
        self.okBtn.enabled = YES;
    }
}

- (void)didFinishFail:(ASIHTTPRequest*)loader
{
    self.okBtn.enabled = YES;
}


//修改备注名
- (IBAction)modifyBtnClicked:(id)sender {
    ModifyViewController * detail = [[ModifyViewController alloc]init];
    detail.title = @"备注信息";
    detail.m_isModify = YES;
    detail.m_isFriend = NO;
    detail.m_infoDic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic];
//    [detail.m_Dic addEntriesFromDictionary:_dataDic];
    __block typeof(self) weakSelf = self;
    detail.remarkBlock = ^(NSString *newName){
        weakSelf.theNameLabel.text = newName;
//        m_noteName = newName;
        m_noteName = newName.length ? newName : weakSelf.dataDic[@"nickName"];
    };
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}

#pragma mark - UITextViewDelegate


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.textView resignFirstResponder];
}

- (void)dealloc {
    [_photoImageView release];
    [_modifyNameBtn release];
    [_theNameLabel release];
//    [_backCornView release];
//    [_applyInfoLabel release];
    [_okBtn release];
    [_textView release];
//    [_placeHolderLabel release];
    [_secLabel release];
    [_thirdLabel release];
    [_applySuccessBlock  release];
    [super dealloc];
}

@end
