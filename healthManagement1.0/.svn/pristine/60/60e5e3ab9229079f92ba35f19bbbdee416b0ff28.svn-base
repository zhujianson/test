//
//  MsgDBOperate.m
//  jiuhaohealth4.1
//
//  Created by 徐国洪 on 15-9-18.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "MsgDBOperate.h"
#import "DBOperate.h"

@implementation MsgDBOperate
{
    FMDatabase *m_fmdatabase;
}

- (void)dealloc
{
    [m_fmdatabase release];
    [super dealloc];
}

+ (MsgDBOperate*)shareInstance
{
    static MsgDBOperate* _msgDBOperate = nil;
    if (!_msgDBOperate) {
        _msgDBOperate = [[MsgDBOperate alloc] init];
    }
    return _msgDBOperate;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self createFriendTable];
    }
    return self;
}

- (void)createFriendTable
{
    DBOperate *dboperate = [DBOperate shareInstance];
    m_fmdatabase = [[dboperate getDBForEnum:kangxunLocalDB] retain];
    
    BOOL isOK = [m_fmdatabase executeUpdate:@"CREATE TABLE IF NOT EXISTS friendList (onlyId varchar PRIMARY KEY,\
                 id varchar,\
                         userId varchar,\
                         friendType int,\
                         friendId int,\
                         nickName varchar,\
                         doctorTitle varchar,\
                         imgUrl varchar,\
                         readCount int,\
                         accountType int,\
                 contentType varchar,\
                 draftContent varchar,\
                         content varchar,\
                         vipLevel varchar,\
                         createTime long)"]; //
    //    accountId varchar,\
    accountId varchar,\
//    accountType int,\   -1为好友请求数
//    friendId varchar,\
//    friendType varchar,\
//    cTime long,\
//    content varchar,\
//    contentType int,\
//    createTime long,\
//    doctorTitle = 3,\
//    flag int,\
//    imgUrl varchar,\
//    nickName varchar,\
//    nickName1 varchar,\
//    readCount int,\
//    vipLevel varchar)"]; //
        /*
         当前的用户ID
         用户类型(医生或会员)
         好友ID
         好友名称
         医生的职称
         头像
         未读消息数
         什么医生(9号医生, 第三方医生)
         内容类型
         内容
         时间
         */
    NSLog(@"");
}

// 判断是否存在表
- (BOOL)isTableOK:(NSString*)tableName forDB:(FMDatabase*)DB
{
    FMResultSet *rs = [DB executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        NSLog(@"isTableOK %d", (int)count);
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}

//根据类型(type)获取列表
- (NSMutableArray*)getFriendListForType:(int)type
{
    NSMutableArray* data = [NSMutableArray array];
    NSMutableDictionary* dic;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM friendList WHERE userId = %@ AND friendType = %d ORDER BY createTime DESC",g_nowUserInfo.userid, type];
    FMResultSet * rs = [m_fmdatabase executeQuery:sql];
    while ([rs next]) {
        dic = [NSMutableDictionary dictionary];
        [dic setObject:[rs stringForColumn:@"id"] forKey:@"id"];
        [dic setObject:[rs stringForColumn:@"friendType"] forKey:@"friendType"];
        [dic setObject:[rs stringForColumn:@"userId"] forKey:@"userId"];
        [dic setObject:[Common isNULLString3:[rs stringForColumn:@"friendId"]] forKey:@"friendId"];
        [dic setObject:[rs stringForColumn:@"nickName"] forKey:@"nickName"];
        [dic setObject:[rs stringForColumn:@"doctorTitle"] forKey:@"doctorTitle"];
        [dic setObject:[rs stringForColumn:@"imgUrl"] forKey:@"imgUrl"];
        [dic setObject:[rs stringForColumn:@"readCount"] forKey:@"readCount"];
        [dic setObject:[rs stringForColumn:@"accountType"] forKey:@"accountType"];
        [dic setObject:[rs stringForColumn:@"contentType"] forKey:@"contentType"];
        [dic setObject:[rs stringForColumn:@"content"] forKey:@"content"];
        [dic setObject:[Common isNULLString3:[rs stringForColumn:@"draftContent"]] forKey:@"draftContent"];
        [dic setObject:[rs stringForColumn:@"vipLevel"] forKey:@"vipLevel"];
        [dic setObject:[rs stringForColumn:@"createTime"] forKey:@"createTime"];

        [data addObject:dic];
    }
    return data;
}

//插入聊天数组
- (BOOL)replaceChatRecordToDBWithData:(NSMutableArray*)dataArray withType:(int)type
{
    [m_fmdatabase beginTransaction];
    BOOL isRollBack = NO;
    @try {
        for (int i = 0; i < dataArray.count; i++)
        {
            id data = dataArray[i];
            NSString *sqlite = [self fengzhuangStrForDic:data withType:type];
            BOOL a = [m_fmdatabase executeUpdate:sqlite];
            if (!a) {
                NSLog(@"插入失败1");
            }
        }
    }
    @catch (NSException *exception)
    {
        isRollBack = YES;
        [m_fmdatabase rollback];
    }
    @finally
    {
        if (!isRollBack)
        {
            [m_fmdatabase commit];
        }
    }
    
    return isRollBack;
}

//封装数据
- (NSString*)fengzhuangStrForDic:(NSDictionary*)dic withType:(int)type
{
    NSString *ID = [dic objectForKey:@"id"];
    NSString *friendType = [NSString stringWithFormat:@"%d", type];
    NSString *userId = g_nowUserInfo.userid;//[dic objectForKey:@"accountId"];
    NSString *friendId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"friendId"]];
    NSString *onlyId = [NSString stringWithFormat:@"%@_%@",g_nowUserInfo.userid, friendId];
    NSString *nickName = [dic objectForKey:@"nickName"];
    NSString *nickName1 = [dic objectForKey:@"nickName1"];
    nickName = nickName1.length ? nickName1 : nickName;
    NSString *doctorTitle = [dic objectForKey:@"doctorTitle"];
    NSString *draftContent = [Common isNULLString3:[dic objectForKey:@"draftContent"]];
    NSString *imgUrl = [dic objectForKey:@"imgUrl"];
    NSString *readCount = [dic objectForKey:@"readCount"];
    NSString *accountType = [NSString stringWithFormat:@"%@", [dic objectForKey:@"accountType"]];
    NSString *contentType = [NSString stringWithFormat:@"%@", [dic objectForKey:@"contentType"]];
    NSString *content = [dic objectForKey:@"content"];
    NSString *createTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"createTime"]];
    
    if (createTime.length>10) {
        createTime = [createTime substringToIndex:10];
    }
    NSString *vipLevel = [dic objectForKey:@"vipLevel"];

    NSString *sql = [NSString stringWithFormat:@"REPLACE INTO friendList(onlyId,id,userId,friendId,friendType,nickName,doctorTitle,imgUrl,readCount,accountType,contentType,content,createTime,vipLevel,draftContent) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@', '%@')",onlyId, ID , userId, friendId, friendType, nickName, doctorTitle, imgUrl, readCount, accountType, contentType, content, createTime, vipLevel, draftContent];
    
    return sql;
}

- (NSString*)fengzhuangDel:(NSString*)friendId
{
    NSString *onlyId = [NSString stringWithFormat:@"%@_%@",g_nowUserInfo.userid, friendId];
    NSString *sql = [NSString stringWithFormat:@"delete from friendList WHERE onlyId = '%@'", onlyId];
    
    return sql;
}

//更新行数据
- (void)updateFriendListRow:(NSDictionary*)dic
{
//    NSString *ID = [dic objectForKey:@"id"];
//    NSString *friendType = [dic objectForKey:@"friendType"];
    NSString *friendId = [dic objectForKey:@"friendId"];
    NSString *nickName = [dic objectForKey:@"nickName"];
    NSString *doctorTitle = [dic objectForKey:@"doctorTitle"];
    NSString *imgUrl = [dic objectForKey:@"imgUrl"];
    NSString *readCount = [dic objectForKey:@"readCount"];
//    NSString *accountType = [dic objectForKey:@"accountType"];
    NSString *contentType = [dic objectForKey:@"contentType"];
    NSString *content = [dic objectForKey:@"content"];
    NSString *createTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"createTime"]];
    if (createTime.length>10) {
        createTime = [createTime substringToIndex:10];
    }
    NSString *vipLevel = [dic objectForKey:@"vipLevel"];
    
    NSString *onlyId = [NSString stringWithFormat:@"%@_%@", g_nowUserInfo.userid, friendId];
    
    NSString *sqlite = [NSString stringWithFormat:@"UPDATE friendList SET imgUrl = '%@', nickName = '%@', doctorTitle = '%@', readCount = '%@', contentType = '%@', content = '%@', createTime = '%@', vipLevel = '%@' WHERE onlyId = '%@'", imgUrl, nickName, doctorTitle, readCount, contentType, content, createTime, vipLevel, onlyId];

    [m_fmdatabase executeUpdate:sqlite];
}

//更新草稿
- (void)updateDirft:(NSDictionary*)dic
{
    NSString *friendId = [dic objectForKey:@"friendId"];
    int contentType = [[dic objectForKey:@"contentType"] intValue];
    NSString *draftContent = [Common isNULLString3:[dic objectForKey:@"draftContent"]];
    NSString *content = [Common isNULLString3:[dic objectForKey:@"content"]];
    NSString *createTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"createTime"]];
    if (createTime.length>10) {
        createTime = [createTime substringToIndex:10];
    }
    
    NSString *onlyId = [NSString stringWithFormat:@"%@_%@", g_nowUserInfo.userid, friendId];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE friendList SET contentType = '%d', content = '%@', draftContent = '%@', createTime = '%@' WHERE onlyId = '%@'", contentType, content, draftContent, createTime, onlyId];
    
    if ([m_fmdatabase executeUpdate:sql]) {
        NSLog(@"delte success!");
    } else {
        NSLog(@"delete failed!");
    }
}

//删除
- (void)deleteRowForFriendId:(NSArray*)friendList
{
    NSString *sql = @"delete from friendList WHERE friendId in (";
    NSString *del = @"";
    for (NSString *friendId in friendList) {
        del = [del stringByAppendingFormat:@"\'%@\',", friendId];
    }
    NSString *indel = [del substringToIndex:del.length-1];
    sql = [sql stringByAppendingFormat:@"%@)", indel];
//    NSString *sql = [NSString stringWithFormat:@"delete from friendList WHERE in id = '%@'", friendId];
    if ([m_fmdatabase executeUpdate:sql]) {
        NSLog(@"delte success!");
    } else {
        NSLog(@"delete failed!");
    }
}

//更新
- (BOOL)updateFriendInfoRow:(NSString *)sql
{
    BOOL isOK;
    if ([m_fmdatabase executeUpdate:sql]) {
        isOK = YES;
    } else {
        isOK = NO;
    }
    
    return isOK;
}

@end

