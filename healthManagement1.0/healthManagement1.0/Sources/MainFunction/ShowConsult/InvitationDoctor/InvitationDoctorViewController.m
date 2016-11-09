//
//  InvitationDoctorViewController.m
//  jiuhaohealth4.0
//
//  Created by xjs on 15/5/12.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "InvitationDoctorViewController.h"
#import "KXTextView.h"

@interface InvitationDoctorViewController ()<UITextFieldDelegate,UITextViewDelegate>

@end

@implementation InvitationDoctorViewController
{
    UITextField * m_iphoneText;
    UIImageView*m_headerView;
    UILabel * m_nameLabel;
    UILabel * m_sexLabel;
    UILabel * m_addressLabel;
    UITextField * m_textView;
    UITextField * m_commentName;

    UIView * m_backView;
    UIButton * invitationBtn;

    NSDictionary * m_dic;
}

- (void)dealloc
{
    [m_headerView release];
    [m_backView release];
    [m_textView release];
    [m_iphoneText release];
    if (m_dic) {
        [m_dic release];
    }
    [super dealloc];
}

- (void)setInviteView
{
    self.title = @"用户编号";
    [self createView:@"请输入用户编号"];
}

- (void)setIphotoView
{
    self.title = @"手机号";
    [self createView:@"请输入手机号"];
}

- (void)createView:(NSString*)text
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kDeviceWidth, 45.25)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [CommonImage colorWithHexString:LINE_COLOR].CGColor;
    [self.view addSubview:view];
    [view release];
    
    m_iphoneText = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, view.width-30, view.height)];
    m_iphoneText.delegate = self;
    m_iphoneText.clearButtonMode = YES;
    m_iphoneText.returnKeyType = UIReturnKeySearch;
    m_iphoneText.placeholder = text;
    m_iphoneText.text = _m_invite;
    m_iphoneText.font = [UIFont systemFontOfSize:16];
    m_iphoneText.textColor = [CommonImage colorWithHexString:@"666666"];
    [view addSubview:m_iphoneText];
    if (!_m_invite) {
        [m_iphoneText becomeFirstResponder];
    }else{
        m_iphoneText.userInteractionEnabled = NO;
    }
    
    m_backView = [[UIView alloc]initWithFrame:CGRectMake(0, view.bottom-0.25, kDeviceWidth, 290/2+45)];
    m_backView.backgroundColor = [UIColor whiteColor];
    m_backView.layer.borderWidth = 0.5;
    m_backView.hidden = YES;
    m_backView.layer.borderColor = [CommonImage colorWithHexString:LINE_COLOR].CGColor;
    [self.view addSubview:m_backView];
    
    m_headerView = [[UIImageView alloc]init];
    m_headerView.clipsToBounds = YES;
    m_headerView.backgroundColor = [UIColor yellowColor];
    m_headerView.contentMode = UIViewContentModeScaleAspectFill;
    m_headerView.frame = CGRectMake(15, 20, 60, 60);
    m_headerView.layer.cornerRadius = m_headerView.width/2.0;
    [m_backView addSubview:m_headerView];
    
    m_nameLabel = [Common createLabel:CGRectMake(m_headerView.right+15, m_headerView.top, 200, 20) TextColor:@"333333" Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft labTitle:nil];
    [m_backView addSubview:m_nameLabel];
    
    m_sexLabel = [Common createLabel:CGRectMake(m_nameLabel.left, m_nameLabel.bottom, 200, 20) TextColor:@"999999" Font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft labTitle:nil];
    [m_backView addSubview:m_sexLabel];
    
    m_addressLabel = [Common createLabel:CGRectMake(m_nameLabel.left, m_sexLabel.bottom, 200, 20) TextColor:@"999999" Font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft labTitle:nil];
    [m_backView addSubview:m_addressLabel];
    
    UIView*lineView  = [[UIView alloc] initWithFrame:CGRectMake(0, 100-0.25,kDeviceWidth, 0.5)];
    lineView.backgroundColor =  [CommonImage colorWithHexString:LINE_COLOR];
    [m_backView addSubview:lineView];
    [lineView release];
    
    m_textView = [[UITextField alloc] initWithFrame:CGRectMake(m_headerView.left, lineView.bottom, kDeviceWidth-30, 45)];
    m_textView.backgroundColor = [UIColor clearColor];
    m_textView.delegate = self;
    m_textView.returnKeyType = UIReturnKeyDone;
    m_textView.textColor = [CommonImage colorWithHexString:@"#333333"];
    m_textView.font = [UIFont systemFontOfSize:16];
    m_textView.placeholder = NSLocalizedString(@"请输入验证信息", nil);
    [m_backView addSubview:m_textView];

//    m_textView = [[KXTextView alloc] initWithFrame:CGRectMake(m_headerView.left, lineView.bottom, kDeviceWidth-30, 45)];
//    m_textView.backgroundColor = [UIColor clearColor];
//    [m_textView setEditable:YES];
//    m_textView.delegate = self;
//    m_textView.returnKeyType = UIReturnKeyDone;
//    m_textView.textColor = [CommonImage colorWithHexString:@"#333333"];
//    m_textView.font = [UIFont systemFontOfSize:16];
//    m_textView.placeholder = NSLocalizedString(@"请输入验证信息", nil);
//    m_textView.placeholderColor = [CommonImage colorWithHexString:@"#bbbbbb"];
//    m_textView.placeHolderLabel.font = [UIFont systemFontOfSize:16];
//    [m_backView addSubview:m_textView];
    
    lineView  = [[UIView alloc] initWithFrame:CGRectMake(0, m_textView.bottom-0.25,kDeviceWidth, 0.5)];
    lineView.backgroundColor =  [CommonImage colorWithHexString:LINE_COLOR];
    [m_backView addSubview:lineView];
    [lineView release];
    
    m_commentName = [[UITextField alloc]initWithFrame:CGRectMake(m_headerView.left, m_textView.bottom,  kDeviceWidth-30, 45)];
    m_commentName.delegate = self;
    m_commentName.clearButtonMode = YES;
    m_commentName.returnKeyType = UIReturnKeySearch;
    m_commentName.placeholder = @"备注名";
    m_commentName.font = [UIFont systemFontOfSize:16];
    m_commentName.textColor = [CommonImage colorWithHexString:@"666666"];
    [m_backView addSubview:m_commentName];

    invitationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    invitationBtn.frame = CGRectMake(15, view.bottom+330/2+45, kDeviceWidth-30, 44);
    [invitationBtn setTitleColor:[CommonImage colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [invitationBtn setTitle:NSLocalizedString(@"邀请", nil) forState:UIControlStateNormal];
    invitationBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    invitationBtn.layer.cornerRadius = 4;
    invitationBtn.clipsToBounds = YES;
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
    [invitationBtn setBackgroundImage:image forState:UIControlStateNormal];
    [invitationBtn addTarget:self action:@selector(invitation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:invitationBtn];
    invitationBtn.hidden = YES;
}

- (void)invitation
{
    if ([NSString isContainsEmoji:m_textView.text])
    {
        [Common TipDialog:NSLocalizedString(@"暂不支持表情信息", nil)];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:m_dic[@"id"] forKey:@"friendId"];
    [dic setObject:m_textView.text forKey:@"remark"];
    [dic setObject:m_commentName.text forKey:@"commentName"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:ADD_FRIEND_URL values:dic requestKey:ADD_FRIEND_URL delegate:self controller:self actiViewFlag:1 title:nil];
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}


- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    if (![[dic[@"head"] objectForKey:@"state"] intValue])
    {
        if ([loader.username isEqualToString:GET_FRIEND_DATA]) {
            //获取详情
            if (m_dic) {
                [m_dic release];
            }
            m_dic = [[dic objectForKey:@"body"][@"user_info"] retain];
            m_backView.hidden = NO;
            invitationBtn.hidden = NO;
            m_nameLabel.text = m_dic[@"nick_name"];
            m_sexLabel.text = [NSString stringWithFormat:@"%@  %@岁",[CommonUser getSex:m_dic[@"sex"]],[CommonDate getAgeWithBirthday:m_dic[@"birthday"]]];
            if ([m_dic[@"city"] isEqualToString:m_dic[@"province"]]) {
                m_addressLabel.text = [NSString stringWithFormat:@"来自%@",m_dic[@"province"]];
            }else{
                m_addressLabel.text = [NSString stringWithFormat:@"来自%@%@",m_dic[@"province"],m_dic[@"city"]];
            }
//            [CommonImage setPicImageQiniu:m_dic[@"head_img"] View:m_headerView Type:0 Delegate:nil];
            [CommonImage setImageFromServer:m_dic[@"head_img"] View:m_headerView Type:0];

        } else if ([loader.username isEqualToString:ADD_FRIEND_URL]) {
            //获取详情
            NSLog(@"邀请成功");
            MBProgressHUD *progress_ = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.view.frame.size.height)];
            progress_.labelText = @"邀请成功";
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
            
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
        }
    }
    else {
        [Common TipDialog2:[dic[@"head"] objectForKey:@"msg"]];
    }
}
//16851933140
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
//    if (![textField.text length]) {
//        [Common TipDialog2:textField.placeholder];
//        return NO;
//    }
    if (m_iphoneText == textField) {
        [self getFriendData];
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)getFriendData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:m_iphoneText.text forKey:@"key"];
    [dic setObject:[self.title isEqualToString:@"手机号"]?@"mobile":@"un"  forKey:@"type"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GET_FRIEND_DATA values:dic requestKey:GET_FRIEND_DATA delegate:self controller:self actiViewFlag:1 title:nil];

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
