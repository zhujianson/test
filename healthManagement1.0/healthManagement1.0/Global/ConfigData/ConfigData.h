//
//  ConfigData.h
//  GreatWall
//
//  Created by Sidney on 13-3-20.
//  Copyright (c) 2013年 BH Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum CUR_USER_ROLE
{
    CUR_USER_ROLE_MEMBER = 0,           //会员
}CUR_USER_ROLE;


@interface ConfigData : NSObject

@property (nonatomic, strong,setter=setUserID:,getter=userID) NSString * userID; //用户ID
@property (nonatomic, assign) NSString * guardianshipID; //监护人角色 当前监护对象ID

@property (nonatomic, strong) NSString * pushMsgID;      //推送信息箱详情ID
@property (nonatomic, strong) NSString * pushMsgType;    //推送信息类型

@property (nonatomic, strong) NSString * assistantID;//用户的助理ID
@property (nonatomic, strong) NSArray * userRoles;//当前用户所具有的角色 0会员 1监护人 2助理

@property (nonatomic, strong) NSDictionary * userInfoDic;//用户所有的信息字典(自己的信息)
@property (nonatomic, strong) NSDictionary * guarderUserInfoDic;//被监护人的信息 用户所有的信息字典

@property (nonatomic, strong) NSArray * userDataTypes;//用户的数据类型,例如,血压,血糖,心率等等...
@property (nonatomic, strong) NSArray * userReportTypes; //健康报告用户的数据类型
@property (nonatomic, assign) int selectReportTypeId;    //选中的数据类型ID

- (NSString *)userID;

+ (id)shareInstance;

//- (void)setNeedRotation:(BOOL)status;

//- (BOOL)getNeedRotation;

//计算字符串长度
- (int)textLength:(NSString *)text;

//验证用户是否开通该服务
//- (BOOL)verifyMenuPermissions:(NSString *)serviceCode;

//将获取的json数据写到沙盒中，方便查看数据。
- (void)writeToPlist:(id)object fileName:(NSString *)fileName;

/*  健康报告评估血压类型保存到本地数据类型 */
//+ (NSArray *)responseDataArrayforHealthData;

/*  获取默认类型Id */
+ (int)getCurTypeId;

/*  获取默认类型名称 */
+ (NSString *)getCurType;

/*  获取所有类型 */
+ (NSArray *)getAllUserDataType;

/*  获取健康报告默认类型Id */
+ (int)getReportCurTypeId;

/*  获取健康报告默认类型名称 */
+ (NSString *)getReportCurType;

/*  获取健康报告所有类型 */
+ (NSArray *)getReportAllUserDataType;


@end
