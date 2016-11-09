//
//  UserInfoModel.m
//  jiuhaoHealth2.0.1
//
//  Created by 徐国洪 on 14-5-28.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import "UserInfoModel.h"
#import "Common.h"
#import "AppDelegate.h"

@implementation UserInfoModel

- (id)initWithDic:(NSDictionary*)dic
{
    self.userToken               = [Common isNULLString:[dic objectForKey:@"token"]];           //当前用户id
    return self;
}

//基本信息赋值
- (void)setMyBasicInformation:(NSDictionary*)dic
{
    if (!dic) {
        return;
    }
    //基本信息赋值
    self.mobilePhone          = [Common isNULLString3:[dic objectForKey:@"mobile_phone"]];      //手机号
    self.totalunreadMsgCount  = [[dic objectForKey:@"totalunreadMsgCount"] intValue];//未读消息总数量
    self.birthday             = [Common isNULLString:[dic objectForKey:@"birthday"]];         //生日
    self.isActive             = [Common isNULLString:[dic objectForKey:@"isactive"]] ;
    self.fraction             = 0;
    self.isfinishAanswerQuestion          = [Common isNULLString:[dic objectForKey:@"isfinishAanswerQuestion"]];
    self.status               = [[dic objectForKey:@"status"] intValue];           //状态
    self.identity             = [Common isNULLString:[dic objectForKey:@"identity"]];         //身份证
    self.isBind               = [[dic objectForKey:@"is_bind"] intValue];        //1绑定 ,0 未绑定
    self.userid  = [Common isNULLString:[dic objectForKey:@"user_no"]]; //用户编号
    self.thirdLogin = NO;
    self.stepLength = [[dic objectForKey:@"step"] floatValue]/100; //步子长度---cm--转为m
    self.weight = [[dic objectForKey:@"weight"] floatValue]; //体重 --- kg
    self.height = [[dic objectForKey:@"height"] floatValue]; //身高 --- cm
    self.maxSpeed = [[dic objectForKey:@"maxSpeed"] floatValue]; //最大速度 --- m/s
    self.maxSpeedOfPatient = [[dic objectForKey:@"maxSpeedOfPatient"] floatValue]; //最大速度 --- m/s
    if(self.maxSpeedOfPatient == 0){
        self.maxSpeedOfPatient = 2.5;
    }
    self.diabetesType = dic[@"diabetesType"];
    self.isPush = [dic[@"is_push"] boolValue];
    self.isBindEquipment = dic[@"is_bind_equipment"];
    self.check_code = [dic[@"vip_level"] intValue];//会员等级
    self.integral =0;
    self.money = @"0";
    self.channel = dic[@"channel"];
    self.medical_history = dic[@"history"];
    self.complications = dic[@"complication"];
    self.nickName             = [Common isNULLString4:[dic objectForKey:@"nick_name"]];//用户名
    self.sex                  = [dic objectForKey:@"sex"];              //性别
    self.age  = [Common isNULLString:[dic objectForKey:@"age"]]; //年龄
    self.filePath             = [Common isNULLString:[dic objectForKey:@"head_img"]];         //用户头像地址
    
    self.agent_mobile         = [Common isNULLString3:dic[@"agent_mobile"]];
    
//    self.managerUrl             = [Common isNULLString:dic[@"managerUrl"]];


    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",[[dic objectForKey:@"step"] floatValue]/100] forKey:[NSString stringWithFormat:@"stepLength%@",[dic objectForKey:@"user_no"]]];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"weight"] forKey:[NSString stringWithFormat:@"weight%@",[dic objectForKey:@"user_no"]]];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"head_img"] forKey:[NSString stringWithFormat:@"%@_loadingImage",self.mobilePhone]];//头像缓存
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSelector:@selector(refreshStepLogicData) withObject:nil afterDelay:0.2];
    
}

- (void)setMyInfo:(NSDictionary*)dic
{
    self.nickName             = [Common isNULLString4:[dic objectForKey:@"nickName"]];//用户名
    self.sex                  = [dic objectForKey:@"sex"];              //性别
    self.age  = [Common isNULLString:[dic objectForKey:@"age"]]; //年龄
    self.filePath             = [Common isNULLString:[dic objectForKey:@"userPhoto"]];         //用户头像地址
    self.imgUrl = dic[@"imgUrl"];;//首页图片URL
    self.score = dic[@"score"];;//评估分数
    self.reportUrl = dic[@"reportUrl"];//健康报告URL
    self.reportTitle = dic[@"reportTitle"];//健康报告提示信息
    self.informationTitle = dic[@"informationTitle"];//健康资讯最近一条的标题
    self.userid  = [Common isNULLString:[dic objectForKey:@"userNo"]]; //用户编号

}
- (void)refreshStepLogicData
{
    AppDelegate *myAppDelegate = [Common getAppDelegate];
//    [myAppDelegate.stepCounterObj refreshData];
}


- (void)removeAllKeyValue
{
    self.birthday = nil;         //生日
    self.filePath = nil;         //用户头像地址
    self.userid = nil;           //当前用户id
    self.mobilePhone = nil;      //手机号
    self.nickName = nil;         //用户名
    self.isActive = nil;
    self.isfinishAanswerQuestion = nil;
    self.identity = nil;         //身份证
    self.userToken = nil;
    self.qiniuToken = nil;
    self.sex = nil;
    self.money = nil;
    self.medical_history = nil;
    self.complications = nil;
    self.m_sex = nil;
    self.m_birthday = nil;
    self.agent_mobile = nil;
}

- (void)dealloc
{
    [self removeAllKeyValue];
    [super dealloc];
}

@end
