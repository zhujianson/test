//
//  DeviceTableViewCell.m
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-8-20.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "DeviceTableViewCell.h"
#import "PickerView.h"
#import "GetFamilyList.h"
//#import "ModifyInformationViewController.h"

@implementation DeviceTableViewCell
{
    NSDictionary * deviceDic;
    UILabel * nameLab;
}
@synthesize m_imageDeviceIcon = m_imageDeviceIcon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        m_labDeviceName = [Common createLabel];
        m_labDeviceName.frame = CGRectMake(70, 25/2, kDeviceWidth-200, 20);
//        m_labDeviceName.numberOfLines = 2;
        m_labDeviceName.textColor  = [CommonImage colorWithHexString:@"333333"];
        m_labDeviceName.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:m_labDeviceName];
        
        m_labChangjia = [Common createLabel];
        m_labChangjia.frame = CGRectMake(m_labDeviceName.left, m_labDeviceName.bottom+5, 250, 20);
        m_labChangjia.textColor  = [CommonImage colorWithHexString:@"666666"];
        m_labChangjia.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:m_labChangjia];
        
        m_imageDeviceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 25/2, 40, 40)];
//        m_imageDeviceIcon.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:m_imageDeviceIcon];
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [but setTitleColor:[CommonImage colorWithHexString:@"999999"] forState:UIControlStateNormal];
        but.frame = CGRectMake(kDeviceWidth-120, 25/2, 80, 40);
        but.titleLabel.textAlignment = NSTextAlignmentRight;
        but.titleLabel.font = [UIFont systemFontOfSize:17];
        but.userInteractionEnabled = NO;
//        [but addTarget:self action:@selector(butEventDel) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:but];
        
        nameLab = [Common createLabel:CGRectMake(0, 0, but.width, but.height) TextColor:@"999999" Font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentRight labTitle:nil];
        [but addSubview:nameLab];
        
        
    }
    return self;
}

- (void)setM_infoDic:(NSDictionary *)dic
{
    deviceDic = dic;
    m_labDeviceName.text =[dic objectForKey:@"device_name"];
    nameLab.text = dic[@"nickName"];
    m_labChangjia.text = [NSString stringWithFormat:@"设备编号:%@",[dic objectForKey:@"device_no"]];
    if ([dic.allKeys containsObject:@"device_pic"])
    {
         [CommonImage setImageFromServer:dic[@"device_pic"] View:m_imageDeviceIcon Type:4];
    }
   
    if ([dic.allKeys containsObject:@"kWeightDevice"])
    {
        NSString *timeString = dic[@"kDeviceSaveTime"];
        NSString *titleStr = @"上次测量时间:无";
        if (timeString.length)
        {
            titleStr = [NSString stringWithFormat:@"上次测量时间:%@",timeString];
        }
        m_labChangjia.text = titleStr;
        nameLab.text = @"未连接";
        m_imageDeviceIcon.image = [UIImage imageNamed:@"common.bundle/personnal/device/weigthDeviceIcon.png"];
    }
}

-(void)changeStateWithConnectState:(BOOL)state
{
    if ([deviceDic.allKeys containsObject:@"kWeightDevice"])
    {
         nameLab.text = state? @"已连接":@"未连接";
    }
}

- (void)setIconImage:(UIImage *)image
{
	[m_imageDeviceIcon setImage:image];
}


- (void)butEventDel
{
//    [self.delegate butEventDel:self.m_infoDic];
	
//	
//	[[GetFamilyList alloc] initWithBlcok:^(NSMutableArray *farray){
//		
//		NSMutableArray * arr = [[NSMutableArray alloc] init];
//        NSMutableArray * arrId = [[NSMutableArray alloc] init];
//
//		for (int i =0; i<farray.count; i++) {
//			if (farray[i][@"id"]==nil) {
//				break;
//			}
//            [arrId addObject:farray[i][@"id"]];
//
//			[arr addObject:farray[i][@"nickName"]];
//		}
//        if (arr.count<7) {
//            [arr addObject:@"添加家庭成员"];
//        }
//        [g_winDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
//		PickerView *myPicker = [[PickerView alloc] init];
//		[myPicker createPickViewWithArray:[NSArray arrayWithObject:arr] andWithSelectString:nameLab.text setTitle:@"选择绑定家人" isShow:NO];
//		[myPicker setPickerViewBlock:^(NSString *content) {
//			NSString* name = [arr objectAtIndex:[content intValue]];
//            NSMutableDictionary* dic1 = [NSMutableDictionary dictionary];
//
//            if ([name isEqualToString:@"添加家庭成员"]) {
//                ModifyInformationViewController * modify = [[ModifyInformationViewController alloc]init];
//                modify.isDeviceAdd = YES;
//                [modify setModifyInformationBlock:^(NSMutableDictionary *dic) {
//                    NSLog(@"%@",dic);
//                    nameLab.text = dic[@"nickName"];
////                    userIdStr = dic[@"id"];
//                    [g_familyList replaceObjectAtIndex:g_familyList.count-1 withObject:dic];
//                    if (g_familyList.count < 7) {
//                        [g_familyList addObject:[[[NSMutableDictionary alloc] init] autorelease]];
//                    }
//                    [dic1 setObject:deviceDic[@"device_no"] forKey:@"code"];
//                    [dic1 setObject:dic[@"id"] forKey:@"id"];
//                    [[CommonHttpRequest defaultInstance] sendNewPostRequest:REGISTER_APIFIVE_URL values:dic1 requestKey:REGISTER_APIFIVE_URL delegate:self controller:self actiViewFlag:0 title:NSLocalizedString(@"修改中...", nil)];
//                }];
//                modify.log_pageID = 88;
//                modify.title = @"添加家庭成员";
//                modify.m_infoDic = [[NSMutableDictionary alloc]init];
//                [_m_device.navigationController pushViewController:modify animated:YES];
//                [modify release];
//            }else{
//			nameLab.text = name;
//			[dic1 setObject:deviceDic[@"device_no"] forKey:@"code"];
//            if ([content intValue]) {
//                [dic1 setObject:arrId[[content intValue]] forKey:@"id"];
//            }
//            [[CommonHttpRequest defaultInstance] sendNewPostRequest:REGISTER_APIFIVE_URL values:dic1 requestKey:REGISTER_APIFIVE_URL delegate:self controller:self actiViewFlag:0 title:NSLocalizedString(@"修改中...", nil)];
//            }
//			[arr release];
//            [arrId release];
//		}];
//		
//	} withView:self];
	
//    NSMutableArray * arr = [[NSMutableArray alloc]init];
//    for (int i =0; i<g_familyList.count; i++) {
//        if (g_familyList[i][@"id"]==nil) {
//            break;
//        }
//        [arr addObject:g_familyList[i][@"nickName"]];
//    }
//    UILabel * lab = (UILabel*)[self viewWithTag:44];
//
//    PickerView *myPicker = [[PickerView alloc] init];
//    [myPicker createPickViewWithArray:[NSArray arrayWithObject:arr] andWithSelectString:lab.text setTitle:@"选择绑定家人"];
//    [myPicker setPickerViewBlock:^(NSString *content) {
//        NSString* name = [arr objectAtIndex:[content intValue]];
//        lab.text = name;
//        userName = name;
//        
//        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
//        [dic setObject:g_nowUserInfo.userid forKey:@"userId"];
//        
//        [dic setObject:deviceDic[@"did"] forKey:@"did"];
//        [dic setObject:[g_familyList objectAtIndex:[content intValue]][@"id"] forKey:@"familyidOrUserid"];
//        if ([[g_familyList objectAtIndex:[content intValue]][@"id"] isEqualToString:g_nowUserInfo.userid]) {
//            [dic setObject:@"0" forKey:@"userType"];
//        }else{
//            [dic setObject:@"1" forKey:@"userType"];
//        }
//        [[CommonHttpRequest defaultInstance] sendNewPostRequest:Update_MYDEVICE values:dic requestKey:Update_MYDEVICE delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"修改中...", nil)];
//        [arr release];
//
//    }];

}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}


- (void)didFinishSuccess:(ASIHTTPRequest*)loader
{
    NSString* responseString = [loader responseString];
    NSDictionary* dict = [responseString KXjSONValueObject];
    
    if (![[dict[@"head"] objectForKey:@"state"] intValue] == 0) {
        [Common TipDialog2:[dict[@"head"] objectForKey:@"msg"]];
        return;
    }
    if ([loader.username isEqualToString:REGISTER_APIFIVE_URL]) {
        NSLog(@"%@", dict);
        
        [Common TipDialog2:@"修改成功"];
        if (_delegate&&[_delegate respondsToSelector:@selector(butEventDel:)]) {
            [_delegate butEventDel:deviceDic];
            
        }

    }
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
//    [m_labChangjia release];
    [m_labDeviceName release];
    [m_imageDeviceIcon release];
    
    [super dealloc];
}

@end
