//
//  AddDeviceViewController.m
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-8-20.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "CommonHttpRequest.h"
#import "ScanningViewController.h"
#import "ActivateSuccessViewController.h"
#import "PickerView.h"
#import "GetFamilyList.h"
//#import "ModifyInformationViewController.h"
#import "AppDelegate.h"

@interface AddDeviceViewController ()
{
    NSString * userIdStr;
}
@end

@implementation AddDeviceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!_temp) {
        self.title = @"添加设备绑定";
        self.navigationItem.rightBarButtonItem = [Common CreateNavBarButton3:self setEvent:@selector(setupCamera) setTitle:@"扫码"];

        [self creatAdd];
    }else{
        self.title = @"操作说明";
        [self creatInstructions];
    }
}

- (void)creatAdd
{
    UIScrollView * scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
//    scroll.backgroundColor = [UIColor clearColor];
    scroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scroll];
    
    UIView *cleanView = [self creatView];
    [scroll addSubview:cleanView];
    
    UIButton *btn_activate = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_activate.tag = 2;
    btn_activate.layer.cornerRadius = 4;
    btn_activate.clipsToBounds = YES;
	btn_activate.frame = CGRectMake(15, cleanView.bottom+20, kDeviceWidth-30, 44);
	[btn_activate setTitleColor:[CommonImage colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
    [btn_activate setBackgroundImage:image forState:UIControlStateNormal];
	[btn_activate setTitle:NSLocalizedString(@"绑定", nil) forState:UIControlStateNormal];
	btn_activate.titleLabel.font = [UIFont systemFontOfSize:17];
	[btn_activate addTarget:self action:@selector(butEventOK:) forControlEvents:UIControlEventTouchUpInside];
	[scroll addSubview:btn_activate];
    
    scroll.contentSize = CGSizeMake(0,btn_activate.bottom+20);
    [scroll release];

}

- (UIView*)creatView
{
    UIView * view = [[[UIView alloc]init]autorelease];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HideKeyboard)];
    [view addGestureRecognizer:tap];
    [tap release];
    
    UILabel* nameLable = [Common createLabel:CGRectMake(20, 0, kDeviceWidth-40, 75) TextColor:@"666666" Font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentLeft labTitle:[NSString stringWithFormat:@"请您通过扫描二维码或输入设备编号绑定康迅360智慧健康设备！"]];
    nameLable.numberOfLines = 0;
    [view addSubview:nameLable];
	
//	float height = [Common heightForString:nameLable.text Width:kDeviceWidth - 40 Font:nameLable.font].height + 8;
//	CGRect rect = nameLable.frame;
//	rect.size.height = height;
//	nameLable.frame = rect;
    
//    UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(20, nameLable.frame.origin.y + nameLable.frame.size.height + 15, kDeviceWidth-40, 158)];

    UIView* cleanView = [[UIView alloc] initWithFrame:CGRectMake(-1, nameLable.bottom, kDeviceWidth+2, 45)];
    cleanView.backgroundColor = [UIColor whiteColor];
    cleanView.layer.borderWidth = 0.5;
    cleanView.layer.borderColor = [CommonImage colorWithHexString:LINE_COLOR].CGColor;

    UIView* lineView =
    [[UIView alloc] initWithFrame:CGRectMake(15, 44.25, kDeviceWidth-15, 0.5)];
    lineView.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
    [cleanView addSubview:lineView];
    lineView.alpha = 0.5;
    [lineView release];

	m_userName = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, kDeviceWidth-30, 45)];
    m_userName.placeholder = @"请输入设备编号";
    m_userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_userName.delegate = self;
    m_userName.clearButtonMode = YES;
    [m_userName setTextColor:[CommonImage colorWithHexString:@"#666666"]];

    [m_userName setFont:[UIFont systemFontOfSize:17]];
	m_userName.returnKeyType = UIReturnKeyNext;
	[cleanView addSubview:m_userName];
    view.frame = CGRectMake(0, 0, kDeviceWidth, cleanView.bottom);
    [view addSubview:cleanView];
    
    UILabel * famLab = [Common createLabel:CGRectMake(15, 45, kDeviceWidth-15, 45) TextColor:@"333333" Font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentLeft labTitle:@"家庭成员"];
    famLab.userInteractionEnabled = YES;
//    [cleanView addSubview:famLab];
    UITapGestureRecognizer * taps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(butEventDel)];
    [famLab addGestureRecognizer:taps];
    [taps release];
    
    userIdStr = nil;
    
    UILabel * nameLab = [Common createLabel:CGRectMake(kDeviceWidth-190-30-7, 45, 190, 45) TextColor:@"333333" Font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentRight labTitle:g_nowUserInfo.nickName];
    nameLab.tag = 88;
//    [cleanView addSubview:nameLab];
    
    UIImageView*rightView = [[[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-15-7,45+33/2, 13/2, 21/2)]autorelease];
    rightView.image = [UIImage imageNamed:@"common.bundle/common/right-arrow_pre.png"];
//    [cleanView addSubview:rightView];
    
    [cleanView release];
    return view;
}

- (void)butEventDel
{
    //    [self.delegate butEventDel:self.m_infoDic];
	
//	[self HideKeyboard];
//    __block NSInteger num = 0;
//	[[GetFamilyList alloc] initWithBlcok:^(NSMutableArray *farray){
//		NSMutableArray * arr = [[NSMutableArray alloc] init];
//		for (int i =0; i<farray.count; i++) {
//			if (farray[i][@"id"]==nil) {
//				break;
//            }else{
//                if ([farray[i][@"id"] isEqualToString:userIdStr]) {
//                    num = i;
//                }
//            }
//			[arr addObject:farray[i][@"nickName"]];
//		}
//        if (arr.count<7) {
//            [arr addObject:@"添加家庭成员"];
//        }
//		PickerView *myPicker = [[PickerView alloc] init];
//        UILabel * name = (UILabel*)[self.view viewWithTag:88];
//		[myPicker createPickViewWithArray:[NSArray arrayWithObject:arr] andWithSelectString:name.text setTitle:@"选择绑定家人" isShow:NO];
//        myPicker.m_row = num;
//		[myPicker setPickerViewBlock:^(NSString *content) {
//            NSString * chooseStr = [arr objectAtIndex:[content intValue]];
//            if ([content intValue] == arr.count-1) {
//                ModifyInformationViewController * modify = [[ModifyInformationViewController alloc]init];
//                modify.isDeviceAdd = YES;
//                [modify setModifyInformationBlock:^(NSMutableDictionary *dic) {
//                    NSLog(@"%@",dic);
//                    name.text = dic[@"nickName"];
//                    userIdStr = dic[@"id"];
//                    [g_familyList replaceObjectAtIndex:g_familyList.count-1 withObject:dic];
//                    if (g_familyList.count < 7) {
//                        [g_familyList addObject:[[[NSMutableDictionary alloc] init] autorelease]];
//                    }
//                }];
//                modify.title = @"添加家庭成员";
//                modify.m_infoDic = [[NSMutableDictionary alloc]init];
//                [self.navigationController pushViewController:modify animated:YES];
//                [modify release];
//            }else{
//            name.text = chooseStr;
//            if (![content intValue]) {
//                userIdStr = nil;
//            }else{
//			userIdStr = [farray objectAtIndex:[content intValue]][@"id"];
//            }
//            }
//			[arr release];
//		}];
//     } withView:self] ;
}

- (UITextField*)createTextField:(NSString*)title
{
    UITextField* text = [[[UITextField alloc] init]autorelease];
    text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    text.contentMode = UIViewContentModeCenter;
    text.autocapitalizationType = UITextAutocapitalizationTypeNone;
    text.placeholder = title;
    text.clearButtonMode = YES;
    text.delegate = self;
    [text setTextColor:[CommonImage colorWithHexString:@"#666666"]];
    [text setFont:[UIFont systemFontOfSize:14]];
    return text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	switch (textField.tag) {
		case 201:
			[m_userName becomeFirstResponder];
			break;
		default:
			break;
	}
	return YES;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self HideKeyboard];
}

- (void)HideKeyboard
{
	[m_userName resignFirstResponder];
}

- (void)butEventOK:(UIButton*)btn
{
	[self HideKeyboard];
	
    if (m_userName.text.length == 0 || ![self isAllspace]) {
        [Common TipDialog:NSLocalizedString(@"请输入设备编号", nil)];
        [m_userName becomeFirstResponder];
        return;
    }
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    NSString * str = [m_userName.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [dic setObject:str forKey:@"code"];
    if (userIdStr) {
        [dic setObject:userIdStr forKey:@"id"];
    }
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:REGISTER_APIFIVE_URL values:dic requestKey:REGISTER_APIFIVE_URL delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"加载中...", nil)];
}

- (BOOL)isAllspace
{
    NSString *str = [m_userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [str length];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - NetWork Function

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}


- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    NSDictionary * dict = dic[@"head"];
    NSLog(@"%@",dic);
    if (![[dict objectForKey:@"state"] intValue] == 0) {
        [Common TipDialog:[dict objectForKey:@"msg"]];
        return;
    }

    if ([loader.username isEqualToString:REGISTER_APIFIVE_URL])
    {
        ActivateSuccessViewController* activate = [[ActivateSuccessViewController alloc] init];
        activate.deveDic = [dic[@"body"] retain];
        activate.acticateNum = m_userName.text;
        activate.isAddDeve = YES;
        [self.navigationController pushViewController:activate animated:YES];
        [activate release];

   } else if([loader.username isEqualToString:Get_MYDEVICE_DETAIL])
   {
       [self beginAddWeb:dic[@"body"][@"data"]];
   }
}

- (void)beginAddWeb:(NSString*)url
{
    [self showLoadingActiview];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    webView.backgroundColor = self.view.backgroundColor;
    webView.opaque = NO;
    [webView loadHTMLString:url baseURL:nil];
    [self.view addSubview:webView];
    [webView release];
}

//操作说明
- (void)creatInstructions
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:_modelid forKey:@"id"];
    [dic setObject:_device_no forKey:@"number"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:Get_MYDEVICE_DETAIL values:dic requestKey:Get_MYDEVICE_DETAIL delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"加载中...", nil)];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self stopLoadingActiView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupCamera
{
    //是否有摄像头
    if (![self isCameraAvailable]) {
        [Common TipDialog2:@"该设备不支持此功能！"];
        return;
    }
    ScanningViewController * rt = [[ScanningViewController alloc] init];
	rt.m_userId = userIdStr;
    rt.isFirst = YES;
    rt.sao_type = typeSaoDevice;
    [self.navigationController pushViewController:rt animated:YES];
    [rt release];
}

- (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (void)dealloc
{
    [m_userName release];
    [super dealloc];
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
