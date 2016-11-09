//
//  DBOperate.h
//  Mazda
//
//  Created by binfo on 12-11-7.
//  Copyright (c) 2012年 B.H. Tech Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Global.h"
#import "Global_Url.h"

typedef enum{
    kangxunLocalDB, //记录用户信息
    KangxunDB //服务端同步用的
}dbType;

@interface DBOperate : NSObject
{
    FMDatabase* m_db;
}

+ (DBOperate*)shareInstance;


//获取数据库
- (FMDatabase*)getDBForEnum:(dbType)type;


/**
 *  插入行到表
 *
 *  @param sql 串
 *
 *  @return 返回是否成功
 */
- (BOOL)insertDataForDB:(NSString*)sql withDB:(FMDatabase*)db;

/**
 *  根据sql串查询表中符合的数据
 *
 *  @param sql    串
 *  @param params 获取的字段
 *
 *  @return 数组
 */
- (NSArray*)getDataForSQL:(NSString*)sql getParam:(NSArray*)params;

/**
 *  插入行到表
 *
 *  @param sql 串
 *
 *  @return 返回是否成功
 */
- (BOOL)insertDataForSQL:(NSString*)sql;

//创建聊天表
- (BOOL)createDBWithTable;

- (NSMutableArray*)getAllSymptomBodyPartWithParentPartId:(NSString*)parentId;

- (NSArray*)getDiseaseListBySymptomIds:(NSString*)ids;

- (NSArray*)getAllSymptomBodyPart;

- (NSArray*)getSymptomListByName:(NSString*)name;

- (NSDictionary*)getDiseaseInfoById:(NSString*)diseaseId;

- (NSArray*)getSymptomListByCrowId:(NSString*)crowId;

- (NSArray*)getSymptomListByBodyPartId:(NSString*)partId;

- (NSDictionary*)getSymptomInfoById:(NSString*)symptomId;

- (NSArray*)getDiseaseInfoByName:(NSString*)name;

- (NSArray*)getALlSymptomCrowd;

//查询健康配餐表1级页面
- (NSArray*)getFoodGroup:(int)page;

//查询二级页面
- (NSArray*)getFoodItemForGroupid:(NSString*)grouuid setPage:(int)page;

//yangshuo
//风险评估模板查询
- (NSDictionary*)getTestExerciseByreportId:(NSString*)reportID;

//插入风险评估结果
- (BOOL)insertTestExerciseByreport:(NSDictionary*)data;

//风险评估报告查询
- (NSDictionary*)getExerciseDetailByreportId:(NSString*)reportID;

//上次答题查询
- (NSDictionary*)getLastExerciseDetailByreport;

//查询风险评估报告列表(已完成)
- (NSArray*)getAllExerciseDetailByreport;

//更新已读未读状态
-(void)upadteReportReadStateByReportId:(NSString *)reportID;

//删除数据
-(void)deleteReportReadStateByReportId:(NSString *)reportID;

//的到上次答题的分数
- (NSString*)getLastExerciseHealthScoreWithCreateDate:(NSString *)createDate;

//删除改用户下所有未完成数据
-(void)deleteNOFinishReportFromDB;

//查询闹钟列表
- (NSArray*)getAllAlertsFromDB;

//查询某一条闹钟记录跟根据标示
- (NSMutableDictionary *)getAllAlertsFromDBWithSelectAlertTag:(NSString *)alertTag withUserId:(NSString *)userId;

//新闹钟入库
- (BOOL)insertMyAlertToDBWithData:(NSDictionary*)data;

//更新闹钟的内容
-(void)upadteMyAlertFromDBByAlertId:(NSDictionary *)data ;

//删除闹钟
-(void)deleteMyAlertByAlertId:(NSString *)alertID;

-(void)moveDB;

- (NSMutableArray*)getSportsAllData:(NSString*)datatype type:(int)type;

//更新喜欢不喜欢(食品和运动) Y N
-(void)upadteFavoriteReadStateByItemId:(NSString *)itemid withType:(int)type withState:(NSString *)loveState;
//查询方案数据
- (NSMutableArray*)getPlanAllData:(NSString*)datatype type:(int)type ids:(NSString*)textId;

- (NSMutableArray*)getPlanAllText:(NSString*)textId Pid:(NSString*)pid;

//插入报告建议
- (BOOL)insertEvaluateToDBWithData:(NSDictionary*)data;

- (NSMutableArray*)getAllEvaluateData;
//体检参考数据
- (NSMutableArray*)getAllReportData;

//根据存储时间和userid删除报告数据
- (BOOL)DeleteEvaluateData:(NSString*)time;

//插入聊天行
- (BOOL)insertChatRecordToDBWithData:(NSDictionary*)data;

//体检参考数据
- (NSMutableArray*)getChatRecordData:(int)page withFriendId:(NSString*)friendId;

/**
 *  服务器更新
 *
 *  @param sql 传入可执行的sql串
 *
 *  @return 返回成功失败
 */
- (BOOL)updateDataForServer:(NSString*)sql;

/**
 *  插入行到表
 *
 *  @param sql 串
 *
 *  @return 返回是否成功
 */
- (BOOL)insertLocalDataForSQL:(NSString*)sql;

//解密字符串 
- (NSString*)decryptionWithStr:(NSString*)str;

- (void)closeDB;

//插入消息
- (BOOL)insertMegToDBWithData:(NSDictionary*)data type:(int)type;

//获取未读消息数
- (int)getNoReadCount;

//查询信箱列表
- (NSMutableArray*)getMsgListData:(int)page type:(int)type;
//删除信箱信息
- (BOOL)DeleteMegToDBWithData:(NSDictionary*)data type:(int)type;

//删除信箱信息
- (BOOL)ClearMegToDBType:(int)type;

/**
 *  数据来源库
 *
 *  @return
 */
- (FMDatabase*)getDB;

@end
