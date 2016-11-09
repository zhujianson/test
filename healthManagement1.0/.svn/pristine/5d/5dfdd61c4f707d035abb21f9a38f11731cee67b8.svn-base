//
//  AddBuddy.m
//  jiuhaohealth3.0
//
//  Created by xjs on 15-3-9.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "AddBuddy.h"
#import "ModifyViewController.h"
//#import "ApplyInfoViewController.h"
#import "NoticeDetailViewController.h"
#import "RadarDoctorViewController.h"
#import "InvitationDoctorViewController.h"

@implementation AddBuddy

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray * titleArr = @[@"扫一扫",@"手机号"];
//    ,@"雷达推荐",@"用户编号"
    CGFloat w,h;
    UIButton * backViewBtn = nil;
    CGFloat viewW = kDeviceWidth/2,viewH = 140*kDeviceWidth/375;
    for (int i = 0; i<titleArr.count; i++) {
        h = i%2;
        w = i/2;
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"common.bundle/wallet/Looking_%d.png",i]];
        backViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backViewBtn.tag = 100+i;
        backViewBtn.frame = CGRectMake(h * viewW, w * viewH, viewW, viewH);
        [self.view addSubview:backViewBtn];
        
        NSString * titleBtn = titleArr[i];
        CGSize titleSize = [titleBtn sizeWithFont:[UIFont systemFontOfSize:14]];
        
        [backViewBtn.imageView setContentMode:UIViewContentModeCenter];
        [backViewBtn setImageEdgeInsets:UIEdgeInsetsMake(-25.0,
                                                         0.0,
                                                         0.0,
                                                         -titleSize.width)];
        [backViewBtn setImage:image forState:UIControlStateNormal];
        
        [backViewBtn.titleLabel setContentMode:UIViewContentModeCenter];
        [backViewBtn.titleLabel setBackgroundColor:[UIColor clearColor]];
        [backViewBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [backViewBtn.titleLabel setTextColor:[CommonImage colorWithHexString:COLOR_666666]];
        [backViewBtn setTitleEdgeInsets:UIEdgeInsetsMake(45.0,
                                                         -image.size.width,
                                                         0.0,
                                                         0.0)];
        [backViewBtn setTitleColor:[CommonImage colorWithHexString:COLOR_666666] forState:UIControlStateNormal];
        [backViewBtn setTitle:titleBtn forState:UIControlStateNormal];
        [backViewBtn addTarget:self action:@selector(setJumpEvents:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    UIView *lineView = nil;
    for (int i = 0; i<titleArr.count; i++) {
        lineView  = [[UIView alloc] initWithFrame:CGRectMake(0, backViewBtn.height*i-0.25,kDeviceWidth, 0.5)];
        lineView.backgroundColor =  [CommonImage colorWithHexString:@"e6e6e6"];
        [self.view addSubview:lineView];
        [lineView release];
        if (i) {
            lineView  = [[UIView alloc] initWithFrame:CGRectMake(backViewBtn.width*i-0.25, 0,0.5, backViewBtn.height)];
            lineView.backgroundColor =  [CommonImage colorWithHexString:@"e6e6e6"];
            [self.view addSubview:lineView];
            [lineView release];
        }
    }
}



- (void)setJumpEvents:(UIButton*)btn
{
    switch (btn.tag-100) {
        case 0:
            [self scanning];
            break;
//        case 1:
//        {
//            RadarDoctorViewController * radar = [[RadarDoctorViewController alloc]init];
//            [self.navigationController pushViewController:radar animated:YES];
//            [radar release];
//        }
//            break;
//        case 2:
//        {
//            InvitationDoctorViewController * inviration = [[InvitationDoctorViewController alloc]init];
//            [inviration setInviteView];
//            [self.navigationController pushViewController:inviration animated:YES];
//            [inviration release];
//        }
//            break;
        case 1:
        {
            InvitationDoctorViewController * inviration = [[InvitationDoctorViewController alloc]init];
            [inviration setIphotoView];
            [self.navigationController pushViewController:inviration animated:YES];
            [inviration release];
        }

            break;
  
        default:
            break;
    }
}

- (void)determine
{
    [self touchesBegan:nil withEvent:nil];
    UITextField * text = (UITextField*)[self.view viewWithTag:11];
    if ([text.text length]==0) {
        [Common TipDialog2:@"用户编号不能为空!"];
        [text becomeFirstResponder];
        return;
    }
    //扫描好友二维码
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:text.text forKey:@"qrCode"];
    [dic setObject:g_nowUserInfo.userid forKey:@"userId"];
    [dic setObject:[NSString stringWithFormat:@"%d",0]  forKey:@"userType"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:GET_FRIENDDETAIL values:dic requestKey:GET_FRIENDDETAIL delegate:self controller:self actiViewFlag:1 title:@""];

//    ModifyViewController * detail = [[ModifyViewController alloc]init];
//    detail.title = @"备注信息";
//    detail.m_isModify = YES;
//    [self.navigationController pushViewController:detail animated:YES];
//    [detail release];
}

- (void)scanning
{
//    [self touchesBegan:nil withEvent:nil];
//    //是否有摄像头
//    if (![self isCameraAvailable]) {
//        [Common TipDialog2:@"该设备不支持此功能!"];
//        return;
//    }
//    ScanningViewController * rt = [[ScanningViewController alloc] init];
//    rt.sao_type = typeSaoBuddy;
//    rt.m_userId = @"糖友";
//    rt.isFirst = YES;
//    [self.navigationController pushViewController:rt animated:YES];
//    [rt release];
}

- (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITextField * text = (UITextField*)[self.view viewWithTag:11];
    [text resignFirstResponder];
}

- (NSString *)getStringValue:(NSString *)aString
{
    if(aString.length){
        return aString;
    }else{
        
        return @"";
    }
    
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}


- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    NSString *responseString = [loader responseString];
    NSDictionary *dic = [responseString KXjSONValueObject];
    
    if (![[dic objectForKey:@"state"] intValue])
    {
        if ([loader.username isEqualToString:GET_FRIENDDETAIL]) {
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
            NSString *role = dic[@"rs"][@"role"];
            if(role.intValue == 0){
            //会员
                NSDictionary *rs = [dic[@"rs"] objectForKey:@"userVo"];
                [dataDic setObject:role forKey:@"toType"];//接受者类型
                [dataDic setObject:rs[@"id"] forKey:@"id"];//接受者id
                [dataDic setObject:rs[@"filePath"] forKey:@"filePath"];
                [dataDic setObject:rs[@"nickName"] forKey:@"nickName"];//修改备注用
                
                [dataDic setObject:[self getStringValue:rs[@"remarkName"]] forKey:@"remarkName"];//修改备注用
                [dataDic setObject:rs[@"id"] forKey:@"friendId"];//修改备注用
                [dataDic setObject:role forKey:@"type"];//修改备注用
                [dataDic setObject:[NSString stringWithFormat:@"性别：%@",[CommonUser getSex:[NSString stringWithFormat:@"%@",rs[@"sex"]]]] forKey:@"secText"];
                [dataDic setObject:[NSString stringWithFormat:@"年龄：%@",[CommonDate getAgeWithBirthday:rs[@"birthday"]]] forKey:@"thirdText"];
                
            }else{
            //医师
                NSDictionary *rs = [dic[@"rs"] objectForKey:@"docVo"];
                [dataDic setObject:role forKey:@"toType"];//接受者类型
                [dataDic setObject:rs[@"id"] forKey:@"id"];//接受者id
                [dataDic setObject:rs[@"imgUrl"] forKey:@"filePath"];
                [dataDic setObject:rs[@"nickName"] forKey:@"nickName"];
                
                [dataDic setObject:[self getStringValue:rs[@"remarkName"]] forKey:@"remarkName"];//修改备注用
                [dataDic setObject:rs[@"id"] forKey:@"friendId"];//修改备注用
                [dataDic setObject:role forKey:@"type"];//修改备注用
                [dataDic setObject:[NSString stringWithFormat:@"职称：%@",rs[@"title"]] forKey:@"secText"];
                [dataDic setObject:[NSString stringWithFormat:@"医院：%@",rs[@"mechanism"]] forKey:@"thirdText"];
            }
//            ApplyInfoViewController *applyViewVC = [[ApplyInfoViewController alloc] initWithNibName:@"ApplyInfoViewController" bundle:nil];
//            applyViewVC.isApplyViewFlag = YES;
//            applyViewVC.isFromScanView = NO;
//            applyViewVC.dataDic = dataDic;
//            [self.navigationController pushViewController:applyViewVC animated:YES];
//            [applyViewVC release];
        }
    }
    else {
        [Common TipDialog:[dic objectForKey:@"msg"]];
    }
}

@end
