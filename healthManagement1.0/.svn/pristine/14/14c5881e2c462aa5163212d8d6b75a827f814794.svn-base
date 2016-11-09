//
//  UserInfoModel.h
//  jiuhaoHealth2.0.1
//
//  Created by 徐国洪 on 14-5-28.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
@property (nonatomic, retain) NSString *userid;             //当前用户id
@property (nonatomic, retain) NSString *nickName;           //姓名
@property (nonatomic, retain) NSString *mobilePhone;      //手机号
@property (nonatomic, retain) NSString *birthday;         //生日
@property (nonatomic, retain) NSString *sex;              //性别
@property (nonatomic, retain) NSString *filePath;         //用户头像地址
@property (nonatomic, retain) NSString *isfinishAanswerQuestion;
@property (nonatomic, assign) int fraction;             //指数
@property (nonatomic, assign) int status;           //状态
@property (nonatomic, retain) NSString *identity;         //身份证
@property (nonatomic, assign) int isBind;           //状态  //1绑定 ,0 未绑定
@property (nonatomic, assign) int isPush;           //状态  //0开 ,1关
@property (nonatomic, assign) int broadcastNotReadNum;      //系统未读消息
@property (nonatomic, assign) int myMessageNoReadNum;       //我的消息未读总数量
@property (nonatomic, assign) int totalunreadMsgCount;      //未读消息总数量
@property (nonatomic, assign) int doctorMsgCount;      //医师消息未读总数量
@property (nonatomic, assign) int friendMsgCount;      //好友消息未读总数量
@property (nonatomic, retain) NSString *diabetesType;         //糖尿病类型
@property (nonatomic, retain) NSString *isActive;    //是否有会员绑定
@property (nonatomic, retain) NSString *userToken;//用户临时ID
@property (nonatomic,copy) NSString * activeNumber;//设备编号
@property (nonatomic,assign) float stepLength;//步长
@property (nonatomic,assign) float weight;//体重
@property (nonatomic,assign) float height;//身高
@property (nonatomic,assign) float maxSpeed;//最高速度
@property (nonatomic,assign) float maxSpeedOfPatient;//糖友最高速度
@property (nonatomic,assign) int integral;//积分
@property (nonatomic,copy) NSString* money;//现金
@property (nonatomic,assign)  BOOL thirdLogin;//第三方登录y n
@property (nonatomic,copy)  NSString *isBindEquipment;//第三方登录 授权码
@property (nonatomic,assign) int check_code;//      0:代表不是志愿者    1：代表是志愿者
@property (nonatomic,retain) NSString * qiniuToken;
@property (nonatomic,retain) NSString * channel;//会员来源，太平康迅
@property (nonatomic, assign) int myPostNotRead;      //我的帖子未读总数量
@property (nonatomic, assign) int myThreadNotRead;   //我的跟帖未读总数量
@property (nonatomic, assign) int myPlanCounts;   //方案数据
@property (nonatomic, assign) int myReportCounts;   //报告数据

@property (nonatomic,retain) NSString * medical_history;//既往病史
@property (nonatomic,retain) NSString * complications;//并发症

//new app
@property (nonatomic,copy) NSString * imgUrl;//首页图片URL
@property (nonatomic,copy) NSString * score;//评估分数
@property (nonatomic,copy) NSString* age;//年龄
@property (nonatomic,copy) NSString* reportUrl;//健康报告URL
@property (nonatomic,copy) NSString* reportTitle;//健康报告提示信息
@property (nonatomic,copy) NSString* informationTitle;//健康资讯最近一条的标题
//@property (nonatomic,copy) NSString* managerUrl;//健康管家付费服务

//@property (nonatomic,copy) NSString * m_order;//订单
//@property (nonatomic,copy) NSString * m_convert;//红包
//@property (nonatomic,copy) NSString * m_remaining;//余额

@property (nonatomic,assign) float m_weight;//享瘦派体重
@property (nonatomic,assign) float m_height;//享瘦派身高
@property (nonatomic, retain) NSString *m_birthday;         //享瘦派生日
@property (nonatomic, retain) NSString *m_sex;              //享瘦派性别



@property (nonatomic, retain) NSString *agent_mobile;              ////代理人手机号


- (id)initWithDic:(NSDictionary*)dic;
- (void)setMyBasicInformation:(NSDictionary*)dic;
- (void)removeAllKeyValue;
- (void)setMyInfo:(NSDictionary*)dic;

@end
