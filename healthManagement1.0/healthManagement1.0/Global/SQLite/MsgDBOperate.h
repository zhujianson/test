//
//  MsgDBOperate.h
//  jiuhaohealth4.1
//
//  Created by 徐国洪 on 15-9-18.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgDBOperate : NSObject

+ (MsgDBOperate*)shareInstance;

//根据类型(type)获取列表
- (NSMutableArray*)getFriendListForType:(int)type;

//插入聊天数组
- (BOOL)replaceChatRecordToDBWithData:(NSMutableArray*)dataArray withType:(int)type;

//更新行数据
- (void)updateFriendListRow:(NSDictionary*)dic;

//删除
- (void)deleteRowForFriendId:(NSArray*)friendList;

//更新
- (BOOL)updateFriendInfoRow:(NSString *)sql;

//更新草稿
- (void)updateDirft:(NSDictionary*)dic;

@end
