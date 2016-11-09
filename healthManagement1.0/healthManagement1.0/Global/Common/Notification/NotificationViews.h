//
//  NotificationViews.h
//  jiuhaohealth3.0
//
//  Created by wangmin on 15-1-20.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kAlertType = @"9999999";

@interface NotificationViews : NSObject

@property (nonatomic,retain) NSDictionary *dataDic;//数据字典

@property (nonatomic,retain) NSDictionary *notifiDic;;//通知的数据

//transparentFlag  Y N  标题是否是透明的 ——公告专用
//isLink 是否具有超链接 — 公告专用
//createTime 创建时间 ——新闻专用
//
//ID  新闻ID 话题ID 公告ID
//title 标题
//subTitle 副标题
//type  新闻 100 话题101 公告102

//显示公告View
- (void)toNoticView;

//显示话题View
- (void)toTopicView;

//显示新闻View
- (void)toNewsView;

// 处理收到的APNS消息，向服务器上报收到APNS消息
+(void)handleRemoteNotificationWithUserInfo:(NSDictionary *)userInfo;

+(NotificationViews *)shareInstance;

@end

