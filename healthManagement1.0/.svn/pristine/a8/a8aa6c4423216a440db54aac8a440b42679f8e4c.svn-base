//
//  FriendModel.h
//  healthManagement1.0
//
//  Created by 徐国洪 on 15/10/16.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendModel : NSObject

@property (nonatomic, strong) NSString *accountId;

@property (nonatomic, strong) NSString *nickName;//昵称

@property (nonatomic, strong) NSString *userPhoto;//头像

@property (nonatomic, strong) NSString *channelName;//所在机构

@property (nonatomic, strong) NSString *typeName;//医师类型名称

@property (nonatomic, strong) NSString *typeColor;//医师类型色值

@property (nonatomic, strong) NSString *info;//擅长领域

@property (nonatomic, strong) NSString *expectMessage;//寄语

@property (nonatomic, strong) NSArray *impressions;//印象 字符串数组

@property (nonatomic, strong) NSString *chatContent;//最近一条聊天信息

@property (nonatomic) int chatContentType;//最近一条聊天信息类型

@property (nonatomic) int unReadCount;//未读消息数

@property (nonatomic) long chatTime;//最近一条聊天的时间


@property (nonatomic) BOOL isPay;//是否为在线问诊


- (id)initWithDic:(NSDictionary*)dic;

- (NSMutableDictionary*)getFriendModelDic;

+ (NSMutableArray*)getFriendMArray:(NSDictionary*)dic;


@end


