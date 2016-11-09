//
//  AddFriendViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-9-29.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "AddFriendViewController.h"
#import "CommonHttpRequest.h"
#import "ChangesReginViewController.h"
#import "StepUserInfoViewController.h"
#import "AppDelegate.h"

@interface AddFriendViewController ()
{

    UITextField  *m_alertContent;
    NSDictionary * textDic;
}
@end

@implementation AddFriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"挑战好友";
        
//        UIBarButtonItem *rightButtonItem = [Common createNavBarButton:self setEvent:@selector(shareFunc) withNormalImge:@"common.bundle/nav/top_share_icon_nor.png" andHighlightImge:@"common.bundle/nav/top_share_icon_pre.png"];
//        self.navigationItem.rightBarButtonItem = rightButtonItem;
         self.log_pageID = 116;
    }
    return self;
}

- (void)shareFunc
{
    AppDelegate *myAppDelegate = [Common getAppDelegate];
    

    self.shareTitle = @"【康迅360】- 您值得信赖的健康管理专家";
    self.shareContentString = [NSString stringWithFormat:@"走走降血糖，我走了%@步敢来挑战么？",myAppDelegate.stepShareDic[@"step"]];
    NSMutableString *myshareURL = [NSMutableString stringWithFormat:@"%@sport/index.html?",Share_Server_URL];
    NSArray *allKeys = myAppDelegate.stepShareDic.allKeys;
    for(NSString *key in allKeys){
        [myshareURL  appendFormat:@"%@=%@&",key,myAppDelegate.stepShareDic[key]];
    }
    NSString  *lastshareURL = [myshareURL substringToIndex:myshareURL.length-1];
    lastshareURL = [lastshareURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.shareURL = lastshareURL;
    
    [self goToShare];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self createContentCellView];
    
    UILabel *titleLabel = [Common createLabel:CGRectMake(14, 0, kDeviceWidth-40, 50) TextColor:@"666666" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft labTitle:@"添加朋友一起参加计步挑战"];
    [self.view addSubview:titleLabel];

    UIView *cleanView = [self creatView];
    [self.view addSubview:cleanView];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
////    [self performSelector:@selector(showNavigationBarLine) withObject:nil afterDelay:0];
//}

- (UIView*)creatView
{
    UIView* cleanView = [[[UIView alloc] initWithFrame:CGRectMake(0,50, kDeviceWidth, 45*2)]autorelease];
    cleanView.backgroundColor = [UIColor whiteColor];
    cleanView.layer.borderWidth = 0.5;
    cleanView.layer.borderColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN].CGColor;
    
    UIImageView * rigthImage = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-27, (44-7)/2, 13/2, 21/2)];
    rigthImage.image = [UIImage imageNamed:@"common.bundle/common/right-arrow_pre.png"];
    
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
    labFuwu.textColor = [CommonImage colorWithHexString:@"333333"];
    labFuwu.tag = 12;
    labFuwu.text = NSLocalizedString(@"(0086)", nil);
    labFuwu.font = [UIFont systemFontOfSize:16];
    [cleanView addSubview:labFuwu];
    [labFuwu release];
    
    NSString *str = [NSString stringWithFormat:@"请输入手机号"];
    m_alertContent = [self createTextField:NSLocalizedString(str, nil)];
    m_alertContent.keyboardType = UIKeyboardTypeNumberPad;
    
    [m_alertContent setTextColor:[CommonImage colorWithHexString:@"#666666"]];
    [m_alertContent setFont:[UIFont systemFontOfSize:17]];
    m_alertContent.returnKeyType = UIReturnKeyNext;
    m_alertContent.tag = 201;
    m_alertContent.frame = CGRectMake(80, 45, kDeviceWidth-105, 45);
    [cleanView addSubview:m_alertContent];
    //	[m_userName becomeFirstResponder];
    

    UIView *view;
    for (int i =1; i<2; i++) {
        view = [[UIView alloc] initWithFrame:CGRectMake(16, 45*i, kDeviceWidth-20, 0.5)];
        view.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
        [cleanView addSubview:view];
        [view release];
    }
    
    
    UIButton *yesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    yesButton.frame = CGRectMake(20, 160, kDeviceWidth-40, 40);
    [yesButton setTitle:NSLocalizedString(@"添加", nil) forState:UIControlStateNormal];
    [yesButton addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
    yesButton.tag = 1;
    yesButton.layer.cornerRadius = 4;
    yesButton.backgroundColor = [CommonImage colorWithHexString:VERSION_TEXT_COLOR];
    [self.view addSubview:yesButton];

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
        
//        if (![textDic[@"regin"] isEqualToString:@"中国大陆"] && textDic) {
//            timing = 90*2;
//        }else{
//            timing = 90;
//        }
        
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
    //    text.delegate = self;
    [text setTextColor:[CommonImage colorWithHexString:@"#666666"]];
    [text setFont:[UIFont systemFontOfSize:15]];
    return text;
}


-(void)createContentCellView
{
    UILabel *titleLabel = [Common createLabel:CGRectMake(14, 0, kDeviceWidth-40, 50) TextColor:@"666666" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft labTitle:@"添加朋友一起参加计步挑战"];
    [self.view addSubview:titleLabel];
    
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, kDeviceWidth, 44)];
    backView.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];
    [self.view addSubview:backView];
    [backView release];
    
    m_alertContent = [Common createTextField:@"请输入手机号" setDelegate:self setFont:17];
    m_alertContent.frame = CGRectMake(14, 0, kDeviceWidth-14, 44);
    m_alertContent.backgroundColor = [UIColor redColor];
    m_alertContent.textAlignment = NSTextAlignmentLeft;
    m_alertContent.textColor = [CommonImage colorWithHexString:@"666666"];
    m_alertContent.returnKeyType = UIReturnKeyDone;
    m_alertContent.clearButtonMode = UITextFieldViewModeWhileEditing;
    [backView addSubview:m_alertContent];
    
    UILabel *lineTop = [Common createLineLabelWithHeight:0];
    [backView addSubview:lineTop];
    
    UILabel *lineBottom = [Common createLineLabelWithHeight:44];
    [backView addSubview:lineBottom];
    
    
    UIButton *yesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    yesButton.frame = CGRectMake(20, 110, kDeviceWidth-40, 40);
    [yesButton setTitle:NSLocalizedString(@"添加", nil) forState:UIControlStateNormal];
    [yesButton addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
    yesButton.tag = 1;
    yesButton.layer.cornerRadius = 4;
    yesButton.backgroundColor = [CommonImage colorWithHexString:VERSION_TEXT_COLOR];
    [self.view addSubview:yesButton];

    
}

/**
 *  添加朋友
 */
- (void)btnclick
{
    
    
    if (m_alertContent.text.length == 0) {
        NSString *str = [NSString stringWithFormat:@"请输入手机号"];
        [Common TipDialog:NSLocalizedString(str, nil)];
        [m_alertContent becomeFirstResponder];
        return;
    }
    //    if (![Common isMobileNumber:m_phone.text]) {
    //        [Common TipDialog:NSLocalizedString(@"手机号码格式不正确，请重新输入！", nil)];
    //        [m_phone becomeFirstResponder];
    //        return;
    //    }
    //
    [m_alertContent resignFirstResponder];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"mobile" forKey:@"type"];
    
    NSString *str;
    str = m_alertContent.text;
    if (![textDic[@"regin"] isEqualToString:@"中国大陆"] && textDic) {
        str = [NSString stringWithFormat:@"%@%@",textDic[@"num"],m_alertContent.text];
    }
    [dic setObject:str forKey:@"key"];
   
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:QueryRegisterFriend values:dic requestKey:QueryRegisterFriend delegate:self controller:self actiViewFlag:1 title:nil];

    
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}


- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    if ([dic[@"head"][@"state"] isEqualToString:@"0000"])
    {
         if ([loader.username isEqualToString:QueryRegisterFriend]) {
//             NSString *msg = dic[@"msg"];
//             if([msg isEqualToString:@"success"]){
//            
                NSDictionary *bodyDic = dic[@"body"];
                NSString *userId = bodyDic[@"user_info"][@"id"];//18611976987
                 
                 StepUserInfoViewController *memberInfotVC = [[StepUserInfoViewController alloc] init];
                 memberInfotVC.userId =  userId;
                 [self.navigationController pushViewController:memberInfotVC animated:YES];
                 [memberInfotVC release];
//
//        }else if([msg isEqualToString:@"132"]){
//            UIAlertView* av = [[UIAlertView alloc]
//                               initWithTitle:NSLocalizedString(@"提示", nil)
//                               message:NSLocalizedString(@"对不起，没有找到此用户信息！请确认手机号是否正确!",
//                                                         nil)
//                               delegate:self
//                               cancelButtonTitle:nil
//                               otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
//            [av show];
//            [av release];
//
//        }else if([msg isEqualToString:@"120"]){
//            UIAlertView* av = [[UIAlertView alloc]
//                               initWithTitle:NSLocalizedString(@"提示", nil)
//                               message:NSLocalizedString(@"对不起，您已添加此用户！",
//                                                         nil)
//                               delegate:self
//                               cancelButtonTitle:nil
//                               otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
//            [av show];
//            [av release];
//            
//        }else if ([msg isEqualToString:@"133"]){
//            UIAlertView* av = [[UIAlertView alloc]
//                               initWithTitle:NSLocalizedString(@"提示", nil)
//                               message:NSLocalizedString(@"暂不支持挑战自己噢! ",
//                                                         nil)
//                               delegate:self
//                               cancelButtonTitle:nil
//                               otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
//            [av show];
//            [av release];
//        }
    }
        
    } else {
        
          [Common TipDialog:dic[@"head"][@"msg"]];
    }
}

- (void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag != 999){
    
        return;
    }

//        [self performSelector:@selector(qweqwe) withObject:nil afterDelay:0.3];
}

- (void)qweqwe
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
