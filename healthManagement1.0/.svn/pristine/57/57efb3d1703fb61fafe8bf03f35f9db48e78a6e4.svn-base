//
//  DBOperate.m
//  Mazda
//
//  Created by binfo on 12-11-7.
//  Copyright (c) 2012年 B.H. Tech Co.Ltd. All rights reserved.
//

#import "DBOperate.h"
#import "Encryption.h"
#include <CommonCrypto/CommonCryptor.h>
#import "Encryption.h"

@implementation DBOperate

/**
 *  健康自查表名定义
 */
#define SymptomTable "symptom_Table"
#define DiseaseTable "disease_Table"

#define KangxunDBVersion @"kangxunDBVersion"
#define KangxunLocalDBVersion @"kangxunLocalDBVersion"
#define KangxunDBName @"kangxun.db"
#define KangxunLocalDBName @"kangxunLocal.db"


#define LIMIT_SIZE 20

+ (DBOperate*)shareInstance
{
    static DBOperate* _instance = nil;
    if (!_instance) {
        _instance = [[DBOperate alloc] init];
    }
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self moveDB];
    }
    return self;
}

//数据库更换路径
- (void)moveDB
{
    //本地标示
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *kangxunDBVersion = [userDefaults objectForKey:KangxunDBVersion];
    NSString *kangxunLocalDBVersion = [userDefaults objectForKey:KangxunLocalDBVersion];
    
    //plist-标示
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *newKangxunDBVersion = [infoDic objectForKey:KangxunDBVersion];
    NSString *newKangxunLocalDBVersion = [infoDic objectForKey:KangxunLocalDBVersion];
    
    
    NSString * dbFile = [[Common datePath] stringByAppendingPathComponent:KangxunDBName];
    NSString * dbLocalRecordFile = [[Common datePath] stringByAppendingPathComponent:KangxunLocalDBName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(kangxunDBVersion && ![kangxunDBVersion isEqualToString:newKangxunDBVersion]){
        //本地为非空 且  本地版本与info不一致，移除数据库
        [fileManager removeItemAtPath:dbFile error:nil];
    }
    if(kangxunLocalDBVersion && ![kangxunLocalDBVersion isEqualToString:newKangxunLocalDBVersion]){
        //本地为非空 且  本地版本与info不一致，移除数据库
        [fileManager removeItemAtPath:dbLocalRecordFile error:nil];
    }
    
    if(![fileManager fileExistsAtPath:dbFile])
    {
        NSError *error = nil;
        NSString *dbEmpty = [[self getAppPath] stringByAppendingPathComponent:KangxunDBName];
        [fileManager copyItemAtPath:dbEmpty toPath:dbFile error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:dbEmpty error:NULL];
        if(!error){
            [userDefaults setObject:newKangxunDBVersion forKey:KangxunDBVersion];
        }
    }
    if(![fileManager fileExistsAtPath:dbLocalRecordFile])
    {
        NSError *error = nil;
        NSString *dbEmpty = [[self getAppPath] stringByAppendingPathComponent:KangxunLocalDBName];
        [fileManager copyItemAtPath:dbEmpty toPath:dbLocalRecordFile error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:dbEmpty error:NULL];
        if(!error){
            [userDefaults setObject:newKangxunLocalDBVersion forKey:KangxunLocalDBVersion];
        }
    }
}

//获取数据库
- (FMDatabase*)getDBForEnum:(dbType)type
{
    NSString *pathName;
    if (type == kangxunLocalDB) {
        pathName = KangxunLocalDBName;
    }
    else if (type == KangxunDB) {
        pathName = KangxunDBName;
    }
    NSString *pathString = [[Common datePath] stringByAppendingPathComponent:pathName];
    FMDatabase* db = [FMDatabase databaseWithPath:pathString];

    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    return db;
}


/**
 *  插入行到表
 *
 *  @param sql 串
 *
 *  @return 返回是否成功
 */
- (BOOL)insertDataForDB:(NSString*)sql withDB:(FMDatabase*)db
{
    if ([db executeUpdate:sql]) {
        
        NSLog(@"insert success!");
        [db close];
        return YES;
    }
    else {
        NSLog(@"insert failed!");
        [db close];
        return NO;
    }
}

/**
 *  数据来源库
 *
 *  @return
 */
- (FMDatabase*)getDB
{
    NSString *pathString = [[Common datePath] stringByAppendingPathComponent:@"kangxun.db"];
    FMDatabase* db = [FMDatabase databaseWithPath:pathString];
//    NSLog(@"-------%@",DB_PATH);
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    return db;
}
/**
 *  本地记录操作的数据库
 *
 *  @return
 */
- (FMDatabase*)getLocalRecordDB
{
    NSString *pathString = [[Common datePath] stringByAppendingPathComponent:@"kangxunLocal.db"];
    FMDatabase* db = [FMDatabase databaseWithPath:pathString];
//    NSLog(@"%@",DB_PATH);
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    return db;
}

//解密方法
- (NSString*)decryptionWithStr:(NSString*)str
{
    NSString *encrypt = [self decryptUseDES:str key:kKey];
    NSLog(@"encrypt = %@", str);
    return encrypt;
}


/**
 *  服务器更新
 *
 *  @param sql 传入可执行的sql串
 *
 *  @return 返回成功失败
 */
- (BOOL)updateDataForServer:(NSString*)sql
{
    BOOL is = YES;
    if (m_db) {
        if (![m_db open]) {
            [m_db close];
            m_db = [self getDB];
        }
    }
    else {
        m_db = [self getDB];
    }
    
    if ([m_db executeUpdate:sql]) {
        NSLog(@"updateDataForServer success!");
    } else {
        NSLog(@"updateDataForServer failed!");
        is = NO;
    }
    return is;
}

- (void)closeDB
{
    [m_db close];
	m_db = nil;
}

/**
 *  插入行到表
 *
 *  @param sql 串
 *
 *  @return 返回是否成功
 */
- (BOOL)insertDataForSQL:(NSString*)sql
{
    FMDatabase* db = [self getDB];
    if ([db executeUpdate:sql]) {

        NSLog(@"insert success!");
        [db close];
        return YES;
    } else {
        NSLog(@"insert failed!");
        [db close];
        return NO;
    }
}

/**
 *  插入行到表
 *
 *  @param sql 串
 *
 *  @return 返回是否成功
 */
- (BOOL)insertDataForLocalSQL:(NSString*)sql
{
    FMDatabase* db = [self getLocalRecordDB];
    if ([db executeUpdate:sql]) {
        
        NSLog(@"insert success!");
        [db close];
        return YES;
    } else {
        NSLog(@"insert failed!");
        [db close];
        return NO;
    }
}

/**
 *  插入行到表
 *
 *  @param sql 串
 *
 *  @return 返回是否成功
 */
- (BOOL)insertLocalDataForSQL:(NSString*)sql
{
    FMDatabase* db = [self getLocalRecordDB];
    if ([db executeUpdate:sql]) {
        
        NSLog(@"insert success!");
        [db close];
        return YES;
    } else {
        NSLog(@"insert failed!");
        [db close];
        return NO;
    }
}

/**
 *  根据sql串查询表中符合的数据
 *
 *  @param sql    串
 *  @param params 获取的字段
 *
 *  @return 数组
 */
- (NSArray*)getDataForSQL:(NSString*)sql getParam:(NSArray*)params
{
    @try {
    FMDatabase* db = [self getDB];
    FMResultSet* rs = [db executeQuery:sql];
    NSMutableArray* data = [[NSMutableArray alloc] init];
    NSString* value;
    NSMutableDictionary* dic;
        
    int paramsCount = params.count;
        
    while ([rs next]) {
        
        if(paramsCount == 1){//过滤只有一个value为null的情况
            NSString *key = params[0];
            NSString *value = [rs stringForColumn:key];
            if(value.length == 0){
                continue;
            }
        }
        dic = [NSMutableDictionary dictionary];

        for (NSString* key in params) {
            
            if([key isEqualToString:@"treatment"] | [key isEqualToString:@"mechanism"] | [key isEqualToString:@"applicable"] | [key isEqualToString:@"PRACTICE"])
            {
                //解密
            value = [self decryptionWithStr:[rs stringForColumn:key]];
            }else{
                //同一方法两个字段，一个加密一个不加密，判断
            if ([key isEqualToString:@"introduction"]) {
                NSString * introStr = [rs stringForColumn:key];
            value = [self decryptionWithStr:introStr];
            if (value.length<1) {
                value = introStr;
            }
            }else{
            value = [rs stringForColumn:key];
            }
            }
            
            if(value.length){
                [dic setObject:value forKey:key];
            }else{

                [dic setObject:@"" forKey:key];
            }
        }

        
        [data addObject:dic];
    }
    [db close];
    return [data autorelease];
    }
    @catch (NSException *exception) {
        NSMutableArray* data = [[NSMutableArray alloc] init];
        return [data autorelease];
    }
    @finally {
        
    }
}

/**
 *  根据部位id获得所属的二级部位列表
 *
 *  @param parentId 一级部位id
 *
 *  @return 二级部位列表
 */
- (NSMutableArray*)getAllSymptomBodyPartWithParentPartId:(NSString*)parentId
{
    @try {
        FMDatabase* db = [self getDB];

        FMResultSet* rs = [db executeQuery:@"SELECT ID, PART_ID,PART_NAME,PARENT_ID, LEVEL,PRIORITY FROM symptom_body_part WHERE (PART_ID = ?) ORDER BY PRIORITY ASC", parentId];
        NSMutableArray* data = [[NSMutableArray alloc] init];
        NSMutableDictionary* dic;
        while ([rs next]) {
            //待修改
            NSString* PART_ID = [rs stringForColumn:@"PART_ID"];
            NSString* PART_NAME = [rs stringForColumn:@"PART_NAME"];
            NSString* PARENT_ID = [rs stringForColumn:@"PARENT_ID"];
            NSString* PRIORITY = [rs stringForColumn:@"PRIORITY"];
            NSString* LEVEL = [rs stringForColumn:@"LEVEL"];
            NSString* ID = [rs stringForColumn:@"ID"];

            dic = [NSMutableDictionary dictionary];
            [dic setObject:PART_ID forKey:@"partId"];
            [dic setObject:PART_NAME forKey:@"partName"];
            [dic setObject:PARENT_ID forKey:@"parentId"];
            [dic setObject:LEVEL forKey:@"level"];
            [dic setObject:PRIORITY forKey:@"priority"];
            [dic setObject:ID forKey:@"id"];

            [data addObject:dic];
        }
        [db close];
        return [data autorelease];
    }
    @catch (NSException *exception) {
        
         NSMutableArray* data = [[NSMutableArray alloc] init];
         return [data autorelease];
    }
}

/**
 *  根据症状id获得疾病列表
 *
 *  @param ids 症状ids
 *
 *  @return 疾病list
 */
- (NSArray*)getDiseaseListBySymptomIds:(NSString*)ids
{
//    ids = @"e1303842e3814edea84052751b1800de;f81acf706ee340b88a3bda017b57c186;";

    @try {
    FMDatabase* db = [self getDB];
    
    NSArray *idsArray = [ids componentsSeparatedByString:@";"];
    NSString *idString = @"";
    for(NSString *oneId in idsArray){
        
        idString = [idString stringByAppendingFormat:@"'%@',",oneId];
    
    }
    
    idString = [idString substringToIndex:[idString length]-1];
    NSLog(@"idstring:%@",idString);

//    NSString* sql = [NSString stringWithFormat:@"SELECT ID,DISEASE_NAME,ALIAS_NAME,INITIAL,URL FROM symptom_disease WHERE (SYMPTOM_ID LIKE '%%%@%%')", ids];

//    NSString* sql = [NSString stringWithFormat:@"SELECT DMKBASE_SRD.disease_id,DMKBASE_SRD.disease FROM DMKBASE_SRD WHERE DMKBASE_SRD.symptom_id in ( %@)", idString];

    NSString* sql = [NSString stringWithFormat:@"SELECT DMKBASE_SRD.disease_id,DMKBASE_SRD.disease,sum(DMKBASE_SRD.odds) FROM DMKBASE_SRD WHERE DMKBASE_SRD.symptom_id in (%@) GROUP BY DMKBASE_SRD.disease_id, DMKBASE_SRD.disease\
                     UNION\
                     SELECT 'total_id' disease_id,'total_name' disease,sum(DMKBASE_SRD.odds) FROM DMKBASE_SRD WHERE DMKBASE_SRD.symptom_id in ( %@) ORDER BY sum(DMKBASE_SRD.odds) DESC",idString,idString];
    
    FMResultSet* rs = [db executeQuery:sql];

    NSMutableArray* data = [[NSMutableArray alloc] init];
    NSMutableDictionary* dic;
    while ([rs next]) {
        NSString *DISEASE_NAME = [rs stringForColumn:@"DMKBASE_SRD.disease"];
//        NSString* INITIAL = [rs stringForColumn:@"INITIAL"];
        NSString    *ID = [rs stringForColumn:@"DMKBASE_SRD.disease_id"];
        NSString *odds = [rs stringForColumn:@"sum(DMKBASE_SRD.odds)"];
        if(ID.length == 0){
            continue;
        }
        dic = [NSMutableDictionary dictionary];
        [dic setObject:DISEASE_NAME forKey:@"diseaseName"];
//        [dic setObject:INITIAL forKey:@"radio"];
        [dic setObject:ID forKey:@"id"];
        if (odds) {
            [dic setObject:odds forKey:@"odds"];
        }

        [data addObject:dic];
    }
    [db close];
    return [data autorelease];
    }
    @catch (NSException *exception) {
        
        NSMutableArray* data = [[NSMutableArray alloc] init];
        return [data autorelease];
    }
}

/**
 *  获得人群id
 *
 *  @return
 */
- (NSArray*)getALlSymptomCrowd
{
    @try{
    FMDatabase* db = [self getDB];
    FMResultSet* rs = [db executeQuery:@"SELECT ID,CROWD_ID,CROWD_NAME,PRIORITY FROM symptom_crowd"];

    NSMutableArray* data = [[NSMutableArray alloc] init];
    NSMutableDictionary* dic;
    while ([rs next]) {
        //待修改
        NSString* CROWD_ID = [rs stringForColumn:@"CROWD_ID"];
        NSString* CROWD_NAME = [rs stringForColumn:@"CROWD_NAME"];
        NSString* ID = [rs stringForColumn:@"ID"];
        NSString* PRIORITY = [rs stringForColumn:@"PRIORITY"];

        dic = [NSMutableDictionary dictionary];
        [dic setObject:CROWD_ID forKey:@"crowdId"];
        [dic setObject:CROWD_NAME forKey:@"crowdName"];
        [dic setObject:ID forKey:@"id"];
        [dic setObject:PRIORITY forKey:@"priority"];

        [data addObject:dic];
    }
    [db close];
    return [data autorelease];
    }
    @catch (NSException *exception) {
        NSMutableArray* data = [[NSMutableArray alloc] init];
        return [data autorelease];
    }
    @finally {
        
    }
}

/**
 *  点击文字时获得所有二级部位的
 *
 *  @return 二级部位数组
 */
- (NSArray*)getAllSymptomBodyPart
{
    @try{
    FMDatabase* db = [self getDB];

    FMResultSet* rs = [db executeQuery:@"SELECT ID, PART_ID,PART_NAME,PARENT_ID, LEVEL,PRIORITY FROM symptom_body_part WHERE (LEVEL != ?) ORDER BY PRIORITY ASC", @"-1"];
    
    NSMutableArray* data = [[NSMutableArray alloc] init];
    NSMutableDictionary* dic;
    while ([rs next]) {
        //待修改
        NSString* PART_ID = [rs stringForColumn:@"PART_ID"];
        NSString* PART_NAME = [rs stringForColumn:@"PART_NAME"];
        NSString* PARENT_ID = [rs stringForColumn:@"PARENT_ID"];
        NSString* PRIORITY = [rs stringForColumn:@"PRIORITY"];
        NSString* LEVEL = [rs stringForColumn:@"LEVEL"];
        NSString* ID = [rs stringForColumn:@"ID"];

        dic = [NSMutableDictionary dictionary];
        [dic setObject:PART_ID forKey:@"partId"];
        [dic setObject:PART_NAME forKey:@"partName"];
        [dic setObject:PARENT_ID forKey:@"parentId"];
        [dic setObject:LEVEL forKey:@"level"];
        [dic setObject:PRIORITY forKey:@"priority"];
        [dic setObject:ID forKey:@"id"];

        [data addObject:dic];
    }
    [db close];
    return [data autorelease];
    }
    @catch (NSException *exception) {
        NSMutableArray* data = [[NSMutableArray alloc] init];
        return [data autorelease];
    }
}

/**
 * 根据名称模糊搜索获得疾病列表
 *
 *  @param name 搜索问题
 *
 *  @return 症状列表
 */
- (NSArray*)getDiseaseInfoByName:(NSString*)name
{
    @try {
    FMDatabase* db = [self getDB];

//    NSString* sql = [NSString stringWithFormat:@" SELECT ID,DISEASE_NAME,ALIAS_NAME,INITIAL,URL FROM symptom_disease t1 WHERE 1 = 1 AND ((t1.DISEASE_NAME LIKE '%%%@%%') OR (t1.ALIAS_NAME LIKE '%%%@%%') OR (t1.DISEASE_INFO LIKE '%%%@%%') OR (t1.DISEASE_CAUSE LIKE '%%%@%%') OR (t1.SYMPTOM LIKE '%%%@%%') OR (t1.DIAGNOSE LIKE '%%%@%%'))", name, name, name, name, name, name];
    NSString* sql = [NSString stringWithFormat:@" SELECT DMKBASE_DISEASE.ID,DMKBASE_DISEASE.disease FROM DMKBASE_DISEASE WHERE ((disease LIKE '%%%@%%') OR(PINYIN LIKE '%%%@%%'))", name, name];
    
    
    FMResultSet* rs = [db executeQuery:sql];

    NSMutableArray* data = [[NSMutableArray alloc] init];
    NSMutableDictionary* dic;
    while ([rs next]) {
        //待修改
        NSString* DISEASE_NAME = [rs stringForColumn:@"disease"];
        NSString* ID = [rs stringForColumn:@"ID"];
//        NSString* INITIAL = [rs stringForColumn:@"INITIAL"];

        dic = [NSMutableDictionary dictionary];
        [dic setObject:DISEASE_NAME forKey:@"diseaseName"];
        [dic setObject:ID forKey:@"id"];
//        [dic setObject:INITIAL forKey:@"radio"];

        [data addObject:dic];
    }
    [db close];
    return [data autorelease];
    }
    @catch (NSException *exception) {
        return [NSMutableArray array];
        NSMutableArray* data = [[NSMutableArray alloc] init];
        return [data autorelease];
    }
}

/**
 * 根据名称模糊搜索获得症状列表
 *
 *  @param name 搜索问题
 *
 *  @return 症状列表
 */
- (NSArray*)getSymptomListByName:(NSString*)name
{
    @try{
    FMDatabase* db = [self getDB];

//    NSString* sql = [NSString stringWithFormat:@" SELECT ID,SYMPTOM_NAME,ALIAS_NAME,CROWD_ID,INITIAL,URL FROM symptom_info t1 WHERE 1 = 1 AND ((t1.SYMPTOM_NAME LIKE '%%%@%%') OR (t1.SYMPTOM_INFO LIKE '%%%@%%')OR (t1.SYMPTOM_CAUSE LIKE '%%%@%%'))", name, name, name];

//    NSString* sql = [NSString stringWithFormat:@" SELECT DMKBASE_SYMPTOM.id,DMKBASE_SYMPTOM.symptom FROM DMKBASE_SYMPTOM WHERE ((represent LIKE '%%%@%%') OR(symptom LIKE '%%%@%%') OR(PINYIN LIKE '%%%@%%'))", name, name, name];

      NSString* sql = [NSString stringWithFormat:@" SELECT DMKBASE_SYMPTOM.id,DMKBASE_SYMPTOM.symptom FROM DMKBASE_SYMPTOM WHERE (DMKBASE_SYMPTOM.catalog LIKE '%%%@%%')", name];
    
    FMResultSet* rs = [db executeQuery:sql];

    NSMutableArray* data = [[NSMutableArray alloc] init];
    NSMutableDictionary* dic;
    while ([rs next]) {
        //待修改
        NSString* SYMPTOM_NAME = [rs stringForColumn:@"symptom"];
        NSString* ID = [rs stringForColumn:@"id"];

        dic = [NSMutableDictionary dictionary];
        [dic setObject:SYMPTOM_NAME forKey:@"symptomName"];
        [dic setObject:ID forKey:@"id"];

        [data addObject:dic];
    }
    [db close];
    return [data autorelease];
    }
    @catch (NSException *exception) {
        NSMutableArray* data = [[NSMutableArray alloc] init];
        return [data autorelease];
    }
}

/**
 *  根据人群id获得症状信息
 *
 *  @param crowId
 *
 *  @return
 */
- (NSArray*)getSymptomListByCrowId:(NSString*)crowId
{
  @try{
    FMDatabase* db = [self getDB];

    FMResultSet* rs = [db executeQuery:@"\
                        SELECT\
                        ID,\
                        SYMPTOM_NAME,\
                        ALIAS_NAME,\
                        CROWD_ID,\
                        INITIAL,\
                        URL\
                        FROM\
                        symptom_info\
                        WHERE\
                        (CROWD_ID LIKE ?)\
                        ",
                                       crowId];

    NSMutableArray* data = [[NSMutableArray alloc] init];
    NSMutableDictionary* dic;
    while ([rs next]) {
        //待修改
        NSString* SYMPTOM_NAME = [rs stringForColumn:@"SYMPTOM_NAME"];
        NSString* CROWD_ID = [rs stringForColumn:@"CROWD_ID"];
        NSString* INITIAL = [rs stringForColumn:@"INITIAL"];
        NSString* URL = [rs stringForColumn:@"URL"];
        NSString* ID = [rs stringForColumn:@"ID"];

        dic = [NSMutableDictionary dictionary];
        [dic setObject:SYMPTOM_NAME forKey:@"symptomName"];
        [dic setObject:CROWD_ID forKey:@"crowdId"];
        [dic setObject:INITIAL forKey:@"initial"];
        [dic setObject:URL forKey:@"url"];
        [dic setObject:ID forKey:@"id"];

        [data addObject:dic];
    }
    [db close];
    return [data autorelease];
    }
  @catch (NSException *exception) {
        
        NSMutableArray* data = [[NSMutableArray alloc] init];
        return [data autorelease];
    }
}

/**
 *  根据人体部位获得症状列表
 *
 *  @param partId
 *
 *  @return List
 */
- (NSArray*)getSymptomListByBodyPartId:(NSString*)partId
{
    @try{
    FMDatabase* db = [self getDB];

    FMResultSet* rs = [db executeQuery:@"\
                        SELECT\
                        ID,\
                        SYMPTOM_NAME,\
                        ALIAS_NAME,\
                        CROWD_ID,\
                        INITIAL,\
                        URL\
                        FROM\
                        symptom_info\
                        WHERE\
                        (BODY_PART_ID LIKE ?)\
                        ",
                                       partId];

    NSMutableArray* data = [[NSMutableArray alloc] init];
    NSMutableDictionary* dic;
    while ([rs next]) {
        //待修改
        NSString* SYMPTOM_NAME = [rs stringForColumn:@"SYMPTOM_NAME"];
        NSString* ID = [rs stringForColumn:@"ID"];

        dic = [NSMutableDictionary dictionary];
        [dic setObject:SYMPTOM_NAME forKey:@"symptomName"];
        [dic setObject:ID forKey:@"id"];

        [data addObject:dic];
    }
    [db close];
    return [data autorelease];
    }
    @catch (NSException *exception) {
        NSMutableArray* data = [[NSMutableArray alloc] init];
        return [data autorelease];
    }
}

/**
 *  根据症状Id获得症状信息详细
 *
 *  @param symptomId 症状Id
 *
 *  @return 症状详细信息
 */
- (NSMutableDictionary*)getSymptomInfoById:(NSString*)symptomId
{
    @try{
    FMDatabase* db = [self getDB];
    FMResultSet* rs = [db executeQuery:@"SELECT\
                        ID,\
                        SYMPTOM_NAME,\
                        ALIAS_NAME,\
                        CROWD_ID,\
                        INITIAL,\
                        URL,\
                        SYMPTOM_INFO,\
                        SYMPTOM_CAUSE,\
                        EXAMINATION_INFO,\
                        DIAGNOSE,\
                        BODY_PART_ID,\
                        DEPARTMENT_ID,\
                        EXAMINATION_ID\
                        FROM\
                        symptom_info\
                        WHERE\
                        ID = ?\
                        ",
                                       symptomId];
    NSMutableDictionary* dic = nil;
    while ([rs next]) {
        //待修改
        NSString* SYMPTOM_INFO = [rs stringForColumn:@"SYMPTOM_INFO"];
        NSString* SYMPTOM_CAUSE = [rs stringForColumn:@"SYMPTOM_CAUSE"];
        NSString* EXAMINATION_INFO = [rs stringForColumn:@"EXAMINATION_INFO"];
        NSString* DIAGNOSE = [rs stringForColumn:@"DIAGNOSE"];

        dic = [NSMutableDictionary dictionary];
        [dic setObject:SYMPTOM_INFO forKey:@"symptomInfo"];
        [dic setObject:SYMPTOM_CAUSE forKey:@"symptomCause"];
        [dic setObject:EXAMINATION_INFO forKey:@"examinationInfo"];
        [dic setObject:DIAGNOSE forKey:@"diagnose"];
    }
    [db close];
    return dic;
    }
    @catch (NSException *exception) {
        return  [NSMutableDictionary dictionary];
    }
    @finally {
        
    }
}

/**
 *  根据疾病id获得疾病详细
 *
 *  @param diseaseId
 *
 *  @return 疾病信息
 */
- (NSDictionary*)getDiseaseInfoById:(NSString*)diseaseId
{
    @try{
    FMDatabase* db = [self getDB];
//    FMResultSet* rs = [db executeQuery:@"SELECT ID, DISEASE_NAME,ALIAS_NAME,INITIAL,URL,DISEASE_INFO, DISEASE_CAUSE,SYMPTOM,DIAGNOSE,COMPLICATION,CURE,PREVENTION,BODY_PART_ID,DEPARTMENT_ID,SYMPTOM_ID,EXAMINATION_ID,RELATED_DISEASE_ID FROM symptom_disease WHERE ID = ?", diseaseId];

//    FMResultSet* rs = [db executeQuery:@"SELECT disease,introduction FROM DMKBASE_DISEASE  WHERE DMKBASE_DISEASE.ID = ?", diseaseId];
    FMResultSet* rs = [db executeQuery:@"SELECT DMKBASE_DISEASE.disease,DMKBASE_DISEASE.introduction, group_concat(DMKBASE_SYMPTOM.symptom,'、') as symptoms\
                       FROM (DMKBASE_DISEASE LEFT JOIN DMKBASE_SRD ON DMKBASE_SRD.disease_id = DMKBASE_DISEASE.ID) LEFT JOIN DMKBASE_SYMPTOM ON DMKBASE_SYMPTOM.id = DMKBASE_SRD.symptom_id WHERE DMKBASE_DISEASE.ID = ?", diseaseId];
    
    NSMutableDictionary* dic = nil;
    while ([rs next]) {
        //待修改
        //解密
        NSString* DISEASE_INFO = [self decryptionWithStr:[rs stringForColumn:@"introduction"]];
        NSString* DISEASE_CAUSE = [rs stringForColumn:@"disease"];
        NSString* symptoms = [rs stringForColumn:@"symptoms"];
//        NSString* SYMPTOM = [rs stringForColumn:@"SYMPTOM"];
//        NSString* DIAGNOSE = [rs stringForColumn:@"DIAGNOSE"];

        dic = [NSMutableDictionary dictionary];
        [dic setObject:DISEASE_INFO forKey:@"introduction"];
        [dic setObject:DISEASE_CAUSE forKey:@"disease"];
        [dic setObject:symptoms forKey:@"symptoms"];
//        [dic setObject:SYMPTOM forKey:@"symptom"];
//        [dic setObject:DIAGNOSE forKey:@"diagnose"];
    }
    [db close];
    return dic;
    }
    @catch (NSException *exception) {
        return [NSMutableDictionary dictionary];
    }

}

/**
 *  插入数据到症状数据库表
 *
 *  @param dataArray 数据源
 *
 *  @return 成功状态
 */
- (BOOL)inserDataToSymptomTable:(NSArray*)dataArray
{

    return YES;
}

/**
 *  插入数据到疾病数据库表
 *
 *  @param dataArray 数据源
 *
 *  @return 成功状态
 */
- (BOOL)inserDataToDiseaseTable:(NSArray*)dataArray
{

    return YES;
}

/**
 *  根据症状名 性别 每页的页数返回症状列表
 *
 *  @param symptomName 搜索的症状名
 *  @param sex         性别
 *  @param page        pagesize
 *
 *  @return 症状列表
 */
- (NSArray*)getSymptomListByName:(NSString*)symptomName sex:(NSString*)sex pageNum:(int)page
{
    
    @try {
    FMDatabase* db = [self getDB];
    FMResultSet* rs = [db executeQuery:@"SELECT * FROM ? WHERE name = ? and sex = ? order by id desc LIMIT ? OFFSET ?", SymptomTable,
                                       symptomName, sex, [NSString stringWithFormat:@"%d", LIMIT_SIZE], [NSString stringWithFormat:@"%d", LIMIT_SIZE * page]];
    NSMutableArray* data = [[NSMutableArray alloc] init];
    NSMutableDictionary* dic;
    while ([rs next]) {
        //待修改
        NSString* consultID = [rs stringForColumn:@"consultID"];
        NSString* title = [rs stringForColumn:@"title"];
        NSString* time = [rs stringForColumn:@"time"];

        dic = [NSMutableDictionary dictionary];
        [dic setObject:consultID forKey:@"consultID"];
        [dic setObject:title forKey:@"title"];
        [dic setObject:time forKey:@"time"];

        [data addObject:dic];
    }
    [db close];
    return [data autorelease];
    }
    @catch (NSException *exception) {
       NSMutableArray* data = [[NSMutableArray alloc] init];
      return [data autorelease];
    }
}

//查询健康配餐表1级页面
- (NSArray*)getFoodGroup:(int)page
{
    FMDatabase* db = [self getDB];
    FMResultSet* rs =
    [db executeQuery:@"SELECT * FROM tool_food_group ORDER BY groupid DESC LIMIT ? OFFSET ?",
     [NSString stringWithFormat:@"%d", LIMIT_SIZE],
     [NSString stringWithFormat:@"%d", LIMIT_SIZE * page]];
    
    NSMutableArray* data = [[NSMutableArray alloc] init];
    NSMutableDictionary* dic;
    while ([rs next]) {
        NSString* groupname = [rs stringForColumn:@"groupname"];
        NSString* groupid = [rs stringForColumn:@"groupid"];
        
        dic = [[NSMutableDictionary alloc] init];
        [dic setObject:groupname forKey:@"groupname"];
        [dic setObject:groupid forKey:@"groupid"];
        
        [data addObject:dic];
    }
    [db close];
    
    return [data autorelease];
}

//查询二级页面
- (NSArray*)getFoodItemForGroupid:(NSString*)grouuid setPage:(int)page
{
    FMDatabase* db = [self getDB];
    FMResultSet* rs =
    [db executeQuery:@"SELECT foodid,foodname,cfnl,foodimg FROM tool_food_item AS a,tool_shicai_item AS b,tool_shicai_chengfen AS c WHERE a.groupid = ? AND a.foodname = b.scname AND b.scid = c.scid ORDER BY rowid DESC LIMIT ? OFFSET ?",
     page,
     [NSString stringWithFormat:@"%d", LIMIT_SIZE],
     [NSString stringWithFormat:@"%d", LIMIT_SIZE * page]];
    
    NSMutableArray* data = [[NSMutableArray alloc] init];
    NSMutableDictionary* dic;
    while ([rs next]) {
        NSString* foodid = [rs stringForColumn:@"foodid"];
        NSString* foodname = [rs stringForColumn:@"foodname"];
        NSString* cfnl = [rs stringForColumn:@"cfnl"];
        NSString* foodimg = [rs stringForColumn:@"foodimg"];
        
        dic = [[NSMutableDictionary alloc] init];
        [dic setObject:foodid forKey:@"foodid"];
        [dic setObject:foodname forKey:@"foodname"];
        [dic setObject:cfnl forKey:@"cfnl"];
        [dic setObject:foodimg forKey:@"foodimg"];
        
        [data addObject:dic];
    }
    [db close];
    
    return [data autorelease];

}


#pragma mark 风险评估
- (NSDictionary*)getTestExerciseByreportId:(NSString*)reportID
{
    FMDatabase* db = [self getDB];
    NSString *sql = [NSString stringWithFormat:@"SELECT id, type,name ,content_c FROM t_exercises_report WHERE id = '%@'",reportID];
    FMResultSet* rs = [db executeQuery:sql];
    NSMutableDictionary* dic = nil;
    while ([rs next]) {
        NSString* reportID = [rs stringForColumn:@"id"];
        NSString* reportName = [rs stringForColumn:@"name"];
        NSString* reportType = [rs stringForColumn:@"type"];
        NSString* reportContent = [rs stringForColumn:@"content_c"];
    
        dic = [NSMutableDictionary dictionary];
        [dic setObject:reportID forKey:@"reportID"];
        [dic setObject:reportName forKey:@"reportName"];
        [dic setObject:reportType forKey:@"reportType"];
        [dic setObject:reportContent forKey:@"content_c"];
    }
    [db close];
    return dic;
}

//插入报告
- (BOOL)insertTestExerciseByreport:(NSDictionary*)data
{
     NSString* exerciseId = data[@"id"];
     NSString* user_id = data[@"user_id"];
     NSString* create_date = data[@"create_date"];
     NSString* status = data[@"status"];
     NSString* fraction = data[@"fraction"];
    
     NSString* content = data[@"content"];
     NSString* answer = data[@"answer"];
     NSString* report_id = data[@"report_id"];
     NSString* recommend_report_id = data[@"recommend_report_id"];
     NSString* improve = data[@"improve"];
    
    NSString* healthPerformance = data[@"healthPerformance"];
    NSString* read_yn = data[@"read_yn"];
    NSString* sender = data[@"sender"];
    NSString* sendTime = data[@"sendTime"];
    NSString* title = data[@"title"];
    
//    NSString* iscansee = data[@"iscansee"];
    NSString* code = data[@"code"];
    NSString* currently = data[@"currently"];
    NSString* target = data[@"target"];
    NSString* del_yn = data[@"del_yn"];
    
    //    未完成的删除之前的备份
    if (status.intValue == 0)
    {
        [self deleteNOFinishReportFromDB];
    }
    
    FMDatabase* db = [self getDB];
    NSString *sqlite = [NSString stringWithFormat:@"INSERT INTO t_exercises(id,user_id,create_date,status,fraction,content,answer,report_id,recommend_report_id,improve,healthPerformance,read_yn,sender,sendTime,title,code,currently,target,del_yn) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",exerciseId , user_id, create_date, status, fraction, content,answer, report_id, recommend_report_id, improve, healthPerformance, read_yn, sender,sendTime,title, code,currently,target, del_yn];
      NSLog(@"%@",sqlite);
    if ([db executeUpdate:sqlite]) {
        NSLog(@"insert success !,插入报告");
        [db close];
        return YES;
    } else {
        NSLog(@"insert failed!");
        [db close];
        return NO;
    }
}

-(void)deleteNOFinishReportFromDB
{
    FMDatabase* db = [self getDB];
    
    NSString *sql = [NSString stringWithFormat:@"delete from t_exercises   WHERE status = '0'  AND user_id = '%@'",g_nowUserInfo.userid];
    if ([db executeUpdate:sql]) {
        NSLog(@"delte success!");
        [db close];
        return ;
    } else {
        NSLog(@"delete failed!");
        [db close];
        return ;
    }
}

- (NSDictionary*)getExerciseDetailByreportId:(NSString*)reportID 
{
    FMDatabase* db = [self getDB];
//   reportID =  @"0112771bd48a4002b3148fef202af4c6";
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_exercises  WHERE id = '%@'",reportID];
    FMResultSet* rs = [db executeQuery:sql];
    NSMutableDictionary* rootDict = nil;
    while ([rs next]) {
        NSString* exerciseId = [rs stringForColumn:@"id"];
        NSString* user_id = [rs stringForColumn:@"user_id"];
        NSString* create_date = [rs stringForColumn:@"create_date"];
        NSString* status = [rs stringForColumn:@"status"];
        NSString* fraction = [rs stringForColumn:@"fraction"];
        
        NSString* content = [rs stringForColumn:@"content"];
        NSString* answer = [rs stringForColumn:@"answer"];
        NSString* report_id = [rs stringForColumn:@"report_id"];
        NSString* recommend_report_id = [rs stringForColumn:@"recommend_report_id"];
        NSString* improve = [rs stringForColumn:@"improve"];
        
        NSString* healthPerformance = [rs stringForColumn:@"healthPerformance"];
        NSString* read_yn = [rs stringForColumn:@"read_yn"];
        NSString* sender = [rs stringForColumn:@"sender"];
        NSString* sendTime = [rs stringForColumn:@"sendTime"];
        NSString* title = [rs stringForColumn:@"title"];
        
//        NSString* iscansee = [rs stringForColumn:@"iscansee"];
        NSString* code = [rs stringForColumn:@"code"];
        NSString* currently = [rs stringForColumn:@"currently"];
        NSString* target = [rs stringForColumn:@"target"];
        NSString* del_yn = [rs stringForColumn:@"del_yn"];
        
        rootDict = [NSMutableDictionary dictionary];
        
        [rootDict setObject:exerciseId forKey:@"id"];
        [rootDict setObject:user_id  forKey:@"user_id"];
        [rootDict setObject:create_date forKey:@"create_date"];
        [rootDict setObject:status forKey:@"status"];
        [rootDict setObject:fraction.length==0?@"0":fraction forKey:@"fraction"];
        
        [rootDict setObject:content forKey:@"content"];
        [rootDict setObject:answer forKey:@"answer"];
        [rootDict setObject:report_id forKey:@"report_id"];
        [rootDict setObject:recommend_report_id forKey:@"recommend_report_id"];
        [rootDict setObject:healthPerformance forKey:@"healthPerformance"];
        
        [rootDict setObject:read_yn forKey:@"read_yn"];
        [rootDict setObject:sender forKey:@"sender"];
        [rootDict setObject:sendTime forKey:@"sendTime"];
        [rootDict setObject:title forKey:@"title"];
//        [rootDict setObject:iscansee forKey:@"iscansee"];
//    id 和code 一样为唯一标示
        [rootDict setObject:code forKey:@"code"];
        [rootDict setObject:currently forKey:@"currently"];
        [rootDict setObject:target forKey:@"target"];
        [rootDict setObject:del_yn forKey:@"del_yn"];
        [rootDict setObject:improve forKey:@"improve"];
    }
    [db close];
    return rootDict;
}

- (NSString*)getLastExerciseHealthScoreWithCreateDate:(NSString *)createDate
{
    FMDatabase* db = [self getDB];
    NSString *sql = [NSString stringWithFormat:@"SELECT fraction FROM t_exercises  WHERE status = '1'  AND user_id = '%@' AND create_date < '%@' order  by create_date desc LIMIT 1" ,g_nowUserInfo.userid,createDate];
    FMResultSet* rs = [db executeQuery:sql];
    NSString* fraction = nil;
    while ([rs next]) {
        fraction = [rs stringForColumn:@"fraction"];
    }
    [db close];
    return fraction;
}

//查询报告list
- (NSArray*)getAllExerciseDetailByreport
{
    FMDatabase* db = [self getDB];
    //   reportID =  @"0112771bd48a4002b3148fef202af4c6";
//    NSString *sql = @"SELECT * FROM t_exercises  WHERE status = '1'  order  by create_date desc " ;
     NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_exercises  WHERE status = '1'  AND user_id = '%@'  order  by create_date desc " ,g_nowUserInfo.userid];
    FMResultSet* rs = [db executeQuery:sql];
    NSMutableArray *data  = [[NSMutableArray alloc]init];
    while ([rs next]) {
        NSString* exerciseId = [rs stringForColumn:@"id"];
        NSString* user_id = [rs stringForColumn:@"user_id"];
        NSString* create_date = [rs stringForColumn:@"create_date"];
        NSString* status = [rs stringForColumn:@"status"];
        NSString* fraction = [rs stringForColumn:@"fraction"];
        
        NSString* content = [rs stringForColumn:@"content"];
        NSString* answer = [rs stringForColumn:@"answer"];
        NSString* report_id = [rs stringForColumn:@"report_id"];
        NSString* recommend_report_id = [rs stringForColumn:@"recommend_report_id"];
        NSString* improve = [rs stringForColumn:@"improve"];
        
        NSString* healthPerformance = [rs stringForColumn:@"healthPerformance"];
        NSString* read_yn = [rs stringForColumn:@"read_yn"];
        NSString* sender = [rs stringForColumn:@"sender"];
        NSString* sendTime = [rs stringForColumn:@"sendTime"];
        NSString* title = [rs stringForColumn:@"title"];
        
        //        NSString* iscansee = [rs stringForColumn:@"iscansee"];
        NSString* code = [rs stringForColumn:@"code"];
        NSString* currently = [rs stringForColumn:@"currently"];
        NSString* target = [rs stringForColumn:@"target"];
        NSString* del_yn = [rs stringForColumn:@"del_yn"];
        
        NSMutableDictionary  *rootDict = [NSMutableDictionary dictionary];
        
        [rootDict setObject:exerciseId forKey:@"id"];
        [rootDict setObject:user_id  forKey:@"user_id"];
        [rootDict setObject:create_date forKey:@"create_date"];
        [rootDict setObject:status forKey:@"status"];
        [rootDict setObject:fraction forKey:@"fraction"];
        
        [rootDict setObject:content forKey:@"content"];
        [rootDict setObject:answer forKey:@"answer"];
        [rootDict setObject:report_id forKey:@"report_id"];
        [rootDict setObject:recommend_report_id forKey:@"recommend_report_id"];
        [rootDict setObject:healthPerformance forKey:@"healthPerformance"];
        
        [rootDict setObject:read_yn forKey:@"read_yn"];
        [rootDict setObject:sender forKey:@"sender"];
        [rootDict setObject:sendTime forKey:@"sendTime"];
        [rootDict setObject:title forKey:@"title"];
        //        [rootDict setObject:iscansee forKey:@"iscansee"];
        //    id 和code 一样为唯一标示
        [rootDict setObject:code forKey:@"code"];
        [rootDict setObject:currently forKey:@"currently"];
        [rootDict setObject:target forKey:@"target"];
        [rootDict setObject:del_yn forKey:@"del_yn"];
        [rootDict setObject:improve forKey:@"improve"];
        
        [data addObject:rootDict];
        [rootDict release];
    }
    [db close];
    return [data autorelease];
}

- (NSDictionary*)getLastExerciseDetailByreport
{
    FMDatabase* db = [self getDB];
//    下面是测试
    NSString *sql = [NSString stringWithFormat:@"SELECT answer FROM t_exercises  WHERE status = '0'  AND user_id = '%@'  order  by create_date desc  LIMIT 1" ,g_nowUserInfo.userid];
//    NSString *str = @"0e80983b07b1474bbdcfb75be8d607bf";
//     NSString *sql = [NSString stringWithFormat:@"SELECT answer FROM t_exercises  WHERE  id = '%@'  order  by create_date desc  LIMIT 1",str ];
    FMResultSet* rs = [db executeQuery:sql];
    NSMutableDictionary* rootDict = nil;
    while ([rs next]) {

        NSString* answer = [rs stringForColumn:@"answer"];

        rootDict = [NSMutableDictionary dictionary];
        [rootDict setObject:answer forKey:@"answer"];

    }
    [db close];
    return rootDict;
}


-(void)upadteReportReadStateByReportId:(NSString *)reportID
{
    FMDatabase* db = [self getDB];
    NSString *sql = [NSString stringWithFormat:@"UPDATE t_exercises SET read_yn = 'Y' WHERE id = '%@'",reportID];
    
    if ([db executeUpdate:sql]) {
         NSLog(@"筛选的更新成功");
        [db close];
        return ;
    } else {
        NSLog(@"updata failed!");
        [db close];
        return ;
    }
}

-(void)deleteReportReadStateByReportId:(NSString *)reportID
{
    FMDatabase* db = [self getDB];
    NSString *sql = [NSString stringWithFormat:@"delete from t_exercises  WHERE id = '%@'",reportID];
    if ([db executeUpdate:sql]) {
        NSLog(@"delte success!");
        [db close];
        return ;
    } else {
        NSLog(@"delete failed!");
        [db close];
        return ;
    }
}

#pragma mark 闹钟
//查询闹钟列表
- (NSArray*)getAllAlertsFromDB
{
    @try {
        FMDatabase* db = [self getLocalRecordDB];
        
        if (![db open])
        {
            NSLog(@"打开数据库失败");
            return [NSArray array];
        }
        [db executeUpdate:@"create table IF NOT EXISTS  myAlert(id text,frequency text,med_name text,sendtime text,use_yn text,soundName text,repeatFlag text,isShake text,userId text)"];
        
//        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM myAlert  WHERE userid = '%@' order by id desc " ,g_nowUserInfo.userid];
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM myAlert WHERE id like '%@%%' order by id desc ",g_nowUserInfo.userid];
        FMResultSet* rs = [db executeQuery:sql];
        NSMutableArray *data  = [[NSMutableArray alloc]init];
        while ([rs next]) {
            NSString* alertId = [rs stringForColumn:@"id"];
            NSString* frequency = [rs stringForColumn:@"frequency"];
            NSString* med_name = [rs stringForColumn:@"med_name"];
            
            NSString* sendtime = [rs stringForColumn:@"sendtime"];
            NSString* use_yn = [rs stringForColumn:@"use_yn"];
            NSString* soundName = [rs stringForColumn:@"soundName"];
            NSString* repeatFlag = [rs stringForColumn:@"repeatFlag"];
            NSString* isShake = [rs stringForColumn:@"isShake"];
            NSString *alertTag =  [rs stringForColumn:@"alertTag"];
            NSString * updateTime = [rs stringForColumn:@"updateTime"];
            
            NSMutableDictionary  *rootDict = [[NSMutableDictionary alloc]init];
            
            [rootDict setObject:alertId forKey:@"id"];
            [rootDict setObject:frequency  forKey:@"frequency"];
            [rootDict setObject:med_name forKey:@"med_name"];
            
            [rootDict setObject:sendtime forKey:@"sendtime"];
            [rootDict setObject:use_yn forKey:@"use_yn"];
            [rootDict setObject:soundName forKey:@"soundName"];
            [rootDict setObject:repeatFlag forKey:@"repeatFlag"];
            [rootDict setObject:isShake forKey:@"isShake"];
            [rootDict setObject:alertTag forKey:@"alertTag"];
            [rootDict setObject:updateTime forKey:@"updateTime"];
            [data addObject:rootDict];
            [rootDict release];
        }
        [db close];
        return [data autorelease];
    }
    @catch (NSException *exception) {
        NSLog(@"数据异常");
        NSMutableArray* data = [[NSMutableArray alloc] init];
        return [data autorelease];
    }
}

-(NSMutableDictionary *)getAllAlertsFromDBWithSelectAlertTag:(NSString *)alertTag withUserId:(NSString *)userId
{
    @try {
        FMDatabase* db = [self getLocalRecordDB];
        if (![db open])
        {
            NSLog(@"打开数据库失败");
            return [NSMutableDictionary dictionary];
        }
        [db executeUpdate:@"create table IF NOT EXISTS  myAlert(id text,frequency text,med_name text,sendtime text,use_yn text,soundName text,repeatFlag text,isShake text,userId text)"];
        
        NSString *userIdString = [self defautUserIdStringWithIdString:userId];
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM myAlert  WHERE userid = '%@' AND alertTag = '%@'  order  by id desc " ,userIdString,alertTag];
        //    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM myAlert order  by id desc "];
        FMResultSet* rs = [db executeQuery:sql];
        NSMutableDictionary  *rootDict = [[NSMutableDictionary alloc]init];
        
        while ([rs next]) {
            NSString* alertId = [rs stringForColumn:@"id"];
            NSString* frequency = [rs stringForColumn:@"frequency"];
            NSString* med_name = [rs stringForColumn:@"med_name"];
            
            NSString* sendtime = [rs stringForColumn:@"sendtime"];
            NSString* use_yn = [rs stringForColumn:@"use_yn"];
            NSString* soundName = [rs stringForColumn:@"soundName"];
            NSString* repeatFlag = [rs stringForColumn:@"repeatFlag"];
            NSString* isShake = [rs stringForColumn:@"isShake"];
            NSString *alertTag =  [rs stringForColumn:@"alertTag"];
            NSString * updateTime = [rs stringForColumn:@"updateTime"];
            
            [rootDict setObject:alertId forKey:@"id"];
            [rootDict setObject:frequency  forKey:@"frequency"];
            [rootDict setObject:med_name forKey:@"med_name"];
            
            [rootDict setObject:sendtime forKey:@"sendtime"];
            [rootDict setObject:use_yn forKey:@"use_yn"];
            [rootDict setObject:soundName forKey:@"soundName"];
            [rootDict setObject:repeatFlag forKey:@"repeatFlag"];
            [rootDict setObject:isShake forKey:@"isShake"];
            [rootDict setObject:alertTag forKey:@"alertTag"];
            [rootDict setObject:updateTime forKey:@"updateTime"];
        }
        [db close];
        return [rootDict autorelease];
    }
    @catch (NSException *exception) {
        NSLog(@"数据异常");
        NSMutableDictionary  *rootDict = [[NSMutableDictionary alloc]init];
        return [rootDict autorelease];
    }
    
}

//设置默认值
-(NSString *)defautUserIdStringWithIdString:(NSString *)idString
{
    NSString *userIdString = idString;
    if (!userIdString.length)
    {
        userIdString = g_nowUserInfo.userid;
    }
    return userIdString;
}
//新闹钟入库
- (BOOL)insertMyAlertToDBWithData:(NSDictionary*)data
{
    @try {
        NSString* alertId = data[@"id"];
        NSString* userId = [self defautUserIdStringWithIdString:data[@"userId"] ];
        NSString* frequency = data[@"frequency"];
        NSString* med_name = data[@"med_name"];
        NSString* sendtime = data[@"sendtime"];
 
        NSString* userYn = data[@"use_yn"];
        NSString* soundName = data[@"soundName"];
        NSString* repeatFlag = @"Y";
        NSString* isShake = data[@"isShake"];;
        NSString *alertTag = [data[@"alertTag"] length] ? data[@"alertTag"] :@"putong";// 为普通得闹钟 不是血压和血糖的
        NSString * updateTime = [CommonDate formatCreatetTimeTwo:[NSDate new]];
        
        FMDatabase* db = [self getLocalRecordDB];
        NSString *sqlite = [NSString stringWithFormat:@"INSERT INTO myAlert(id,frequency,med_name,sendtime,use_yn,soundName,repeatFlag,isShake,userid,alertTag,updateTime) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",alertId , frequency, med_name,sendtime,userYn,soundName,repeatFlag,isShake,userId,alertTag,updateTime];
//        NSLog(@"%@",sqlite);
        if ([db executeUpdate:sqlite]) {
            NSLog(@"insert success !,插入闹钟");
            [db close];
            return YES;
        } else {
            NSLog(@"insert failed!");
            [db close];
            return NO;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"异常");
          return NO;
    }
}

//更新闹钟的内容
-(void)upadteMyAlertFromDBByAlertId:(NSDictionary *)data
{
    @try {
        NSString* alertId = data[@"id"];
        //    更新的是开启\关闭状态 Y是开启 N 是关闭
        BOOL isUpdateState = [data.allKeys containsObject:@"_isUpdate"];
        NSString* frequency = nil;
        NSString* med_name = nil;
        NSString* sendtime = nil;
        NSString *sql = nil;
        NSString* userYn = nil;
        NSString* soundName = nil;
        NSString* repeatFlag = nil;
        NSString* isShake = nil;
        NSString * updateTime = data[@"updateTime"];
        if(!isUpdateState)
        {
            frequency = data[@"frequency"];
            med_name = data[@"med_name"];
            sendtime = data[@"sendtime"];
            soundName = data[@"soundName"];
            repeatFlag = data[@"repeatFlag"];
            isShake = data[@"isShake"];
            if(!updateTime.length)
                updateTime = [CommonDate formatCreatetTimeTwo:[NSDate new]];;
            
            sql = [NSString stringWithFormat:@"UPDATE myAlert SET frequency = '%@',med_name = '%@',sendtime = '%@',soundName = '%@',repeatFlag = '%@',isShake = '%@',updateTime = '%@' WHERE id = '%@'",frequency,med_name,sendtime,soundName,repeatFlag,isShake,updateTime,alertId];
        }
        else
        {
            userYn = data[@"use_yn"];
            sql = [NSString stringWithFormat:@"UPDATE myAlert SET use_yn = '%@' WHERE id = '%@'",userYn,alertId];
        }
        FMDatabase* db = [self getLocalRecordDB];
        
        if ([db executeUpdate:sql]) {
            NSLog(@"闹钟的更新成功");
            [db close];
            return ;
        } else {
            NSLog(@"updata failed!");
            [db close];
            return ;
        }
    }
    @catch (NSException *exception) {
        
    }
}
//删除闹钟
-(void)deleteMyAlertByAlertId:(NSString *)alertID
{
    @try {
        FMDatabase* db = [self getLocalRecordDB];
        //    NSString *sql = [NSString stringWithFormat:@"delete from myAlert  WHERE id = '%@'  AND userid = '%@'",alertID,g_nowUserInfo.userid];
        NSString *sql = [NSString stringWithFormat:@"delete from myAlert  WHERE id = '%@' ",alertID];
        if ([db executeUpdate:sql]) {
            NSLog(@"delte 闹钟 success!");
            [db close];
            return ;
        } else {
            NSLog(@"delete failed!");
            [db close];
            return ;
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}


//-(NSString*)getDocPath//得到数据库文件在Doc目录下的路径
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    //找出文件下所有文件目录
//    NSString *docPath = ([paths count] > 0)?[paths objectAtIndex:0]:nil;
//    //找到Docutement目录
//    return docPath;
//}

-(NSString*)getAppPath//得到数据库文件在App目录下的路径
{
    return [[NSBundle mainBundle] resourcePath];
}

/**
 *  查询运动库数据
 *
 *  @param datatype 要查询的数据字段
 *  @param type     界面等级
 *
 *  @return 需要的数组
 */
- (NSMutableArray*)getSportsAllData:(NSString*)datatype type:(int)type
{
    FMDatabase* db = [self getDB];
    FMResultSet* rs;
    NSMutableArray* data = [[NSMutableArray alloc]init];
    NSString * sqliteStr;
    NSMutableDictionary* dic;
    switch (type) {
        case 1:
            rs =[db executeQuery:@"select * from GETSPORTY_CATALOG"];
            while ([rs next]) {
                NSString* code = [rs stringForColumn:@"CODE"];
                NSString* CATALOG = [rs stringForColumn:@"CATALOG"];
                dic = [[[NSMutableDictionary alloc] init]autorelease];
                [dic setObject:code forKey:@"CODE"];
                [dic setObject:CATALOG forKey:@"CATALOG"];
                [data addObject:dic];
            }
             break;
        case 2:
            sqliteStr = [NSString stringWithFormat:@"select * from GETSPORTY_ITEMS where CATALOG = '%@'",datatype];
            rs =[db executeQuery:sqliteStr];
            while ([rs next]) {
                
                NSString* strength = [rs stringForColumn:@"strength"];
                NSString* duration = [rs stringForColumn:@"duration"];
                NSString* frequency = [rs stringForColumn:@"frequency"];
                NSString* eddect = [rs stringForColumn:@"eddect"];
                NSString* attention = [rs stringForColumn:@"attention"];
                NSString* METs = [rs stringForColumn:@"METs"];
                NSString* instrument = [rs stringForColumn:@"instrument"];
                NSString* creator = [rs stringForColumn:@"creator"];
                NSString* calorie = [rs stringForColumn:@"calorie"];
                NSString* img1 = [rs stringForColumn:@"img1"];
                NSString* img2 = [rs stringForColumn:@"img2"];
                NSString* img3 = [rs stringForColumn:@"img3"];
                NSString* vedio1 = [rs stringForColumn:@"vedio1"];
                NSString* vedio2 = [rs stringForColumn:@"vedio2"];
                NSString* vedio3 = [rs stringForColumn:@"vedio3"];
                NSString* collect = [rs stringForColumn:@"collect"];
                NSString* sportID = [rs stringForColumn:@"id"];
                NSString* CATALOG = [rs stringForColumn:@"CATALOG"];
                NSString* ITEM = [rs stringForColumn:@"ITEM"];
                NSString* PIYIN = [rs stringForColumn:@"PIYIN"];
                NSString* ITEM_TITLE = [rs stringForColumn:@"ITEM_TITLE"];
                
                NSString* applicable = [rs stringForColumn:@"applicable"];
                //解密
                NSString* motion = [self decryptionWithStr:[rs stringForColumn:@"motion"]];
                NSString* effect = [rs stringForColumn:@"effect"];

                dic = [[[NSMutableDictionary alloc] init]autorelease];
                if (effect) {
                    [dic setObject:effect forKey:@"effect"];
                }
                if (strength) {
                    [dic setObject:strength forKey:@"strength"];
                }
                if (sportID) {
                    [dic setObject:sportID forKey:@"sportID"];
                }
                if (collect) {
                    [dic setObject:collect forKey:@"collect"];
                }
                if (vedio3) {
                    [dic setObject:vedio3 forKey:@"vedio3"];
                }
                if (instrument) {
                    [dic setObject:instrument forKey:@"instrument"];
                }
                if (creator) {
                    [dic setObject:creator forKey:@"creator"];
                }
                if (calorie) {
                    [dic setObject:calorie forKey:@"calorie"];
                }
                if (img1) {
                    [dic setObject:img1 forKey:@"img1"];
                }
                if (img2) {
                    [dic setObject:img2 forKey:@"img2"];
                }
                if (img3) {
                    [dic setObject:img3 forKey:@"img3"];
                }
                if (vedio1) {
                    [dic setObject:vedio1 forKey:@"vedio1"];
                }
                if (vedio2) {
                    [dic setObject:vedio2 forKey:@"vedio2"];
                }
                if (CATALOG) {
                    [dic setObject:CATALOG forKey:@"CATALOG"];
                }
                if (ITEM) {
                    [dic setObject:ITEM forKey:@"ITEM"];
                }
                if (PIYIN) {
                    [dic setObject:PIYIN forKey:@"PIYIN"];
                }
                if (ITEM_TITLE) {
                    [dic setObject:ITEM_TITLE forKey:@"ITEM_TITLE"];
                }
                if (applicable) {
                    [dic setObject:applicable forKey:@"applicable"];
                }
                if (motion) {
                    [dic setObject:motion forKey:@"motion"];
                }
                if (duration) {
                    [dic setObject:duration forKey:@"duration"];
                }
                if (frequency) {
                    [dic setObject:frequency forKey:@"frequency"];
                }
                if (eddect) {
                    [dic setObject:eddect forKey:@"eddect"];
                }
                if (attention) {
                    [dic setObject:attention forKey:@"attention"];
                }
                if (METs) {
                    [dic setObject:METs forKey:@"METs"];
                }
                [data addObject:dic];
            }
            break;
        case 3:
            sqliteStr = [NSString stringWithFormat:@"select * from GETSPORTY_LOGPOINT where type = %s",[datatype UTF8String]];
            rs =[db executeQuery:@"select type from t_sports"];
            while ([rs next]) {
                NSString* sportName = [rs stringForColumn:@"form"];
                NSString* rate = [rs stringForColumn:@"rate"];
                NSString* pictureaddress = [rs stringForColumn:@"pictureaddress"];
                dic = [[[NSMutableDictionary alloc] init]autorelease];
                [dic setObject:rate forKey:@"rate"];
                [dic setObject:sportName forKey:@"sportName"];
                [dic setObject:pictureaddress forKey:@"pictureaddress"];
                [data addObject:dic];
            }
            break;
        default:
            break;
    }
    [db close];
    
    return [data autorelease];
}

-(void)upadteFavoriteReadStateByItemId:(NSString *)itemid withType:(int)type withState:(NSString *)loveState
{
    @try {
        FMDatabase* db = [self getDB];
        NSString *sql = nil;
        if (type == 1)
        {
            sql = [NSString stringWithFormat:@"UPDATE TCC_INGREDIENTS SET collect = '%@' WHERE id = '%@'",loveState,itemid];
        }
        else
        {
            sql = [NSString stringWithFormat:@"UPDATE GETSPORTY_LOGPOINT SET collect = '%@' WHERE id = '%@'",loveState,itemid];
        }
        
        if ([db executeUpdate:sql]) {
            NSLog(@"筛选的更新成功");
            [db close];
            return ;
        } else {
            NSLog(@"updata failed!");
            [db close];
            return ;
        }
    }
    @catch (NSException *exception) {
        
    }
}

/**
 *  查询方案数据
 *
 *  @param datatype 要查询的数据字段
 *  @param type     界面等级
 *
 *  @return 需要的数组
 */
- (NSMutableArray*)getPlanAllData:(NSString*)datatype type:(int)type ids:(NSString*)textId
{
    FMDatabase* db = [self getDB];
    FMResultSet* rs;
    NSMutableArray* data = [[NSMutableArray alloc]init];
//    NSString * sqliteStr;
    NSMutableDictionary* dic;
    switch (type) {
        case 1:
            rs =[db executeQuery:@"SELECT * FROM MANUAL_CATALOG"];
            while ([rs next]) {
                dic = [[[NSMutableDictionary alloc] init]autorelease];
                [dic setObject:[rs stringForColumn:@"ID"] forKey:@"id"];
                [dic setObject:[rs stringForColumn:@"NAME"] forKey:@"title"];
                [dic setObject:[rs stringForColumn:@"information"] forKey:@"information"];
                [dic setObject:[rs stringForColumn:@"becareful"] forKey:@"data"];
                [dic setObject:[rs stringForColumn:@"subscribe_dt"] forKey:@"time"];
                [dic setObject:[rs stringForColumn:@"allday"] forKey:@"comments"];
                if([rs stringForColumn:@"img"]){
                    [dic setObject:[rs stringForColumn:@"img"] forKey:@"img"];
                }
                [dic setObject:[rs stringForColumn:@"ct_title"] forKey:@"ct_title"];
                [dic setObject:[rs stringForColumn:@"ct"] forKey:@"ct"];
                [dic setObject:[rs stringForColumn:@"ct_level"] forKey:@"ct_level"];
                [dic setObject:[rs stringForColumn:@"ct_desc"] forKey:@"ct_desc"];
                [dic setObject:[rs stringForColumn:@"ct_img"] forKey:@"ct_img"];

                [data addObject:dic];
            }
            break;
        case 2:
        {
            NSString * strs = [NSString stringWithFormat:@"SELECT NAME,ID,PID,IMG,RANK FROM MANUAL_SECTIONS where PID = '%@'",textId];
            rs =[db executeQuery:strs];
            int num = 0;
            while ([rs next]) {
                NSString* task = [rs stringForColumn:@"NAME"];
                task = [task stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                NSString* titleid = [rs stringForColumn:@"ID"];
                NSString* pid = [rs stringForColumn:@"PID"];
//                NSString *img = [rs stringForColumn:@"IMG"];
                NSString * RANK = [rs stringForColumn:@"RANK"];
                dic = [[[NSMutableDictionary alloc] init]autorelease];
                [dic setObject:task forKey:@"text"];
                [dic setObject:titleid forKey:@"id"];
                [dic setObject:pid forKey:@"pid"];
//                if (img) {
//                    [dic setObject:img forKey:@"img"];
//                }
                if (RANK) {
                    [dic setObject:RANK forKey:@"RANK"];
                }
                [data addObject:dic];
                num++;
                if ([datatype intValue]==num) {
                    break;
                }
            }
        }
            break;
        case 3:
        {
            NSString * strs = [NSString stringWithFormat:@"SELECT CONTENT FROM MANUAL_SECTIONS where RANK = '%@' and PID = '%@'",textId,datatype];
            rs =[db executeQuery:strs];
            while ([rs next]) {
                //解密
                NSString * CONTENT = [self decryptionWithStr:[rs stringForColumn:@"CONTENT"]];
                if (CONTENT) {
                    [data addObject:CONTENT];
                }
            }
        }
            break;

        default:
            break;
    }
    [db close];
    
    return [data autorelease];
}

/**
 *  查询康友数据
 *
 *  @param datatype 要查询的数据字段
 *  @param type     界面等级
 *
 *  @return 需要的数组
 */
- (NSMutableArray*)getPlanAllText:(NSString*)textId Pid:(NSString*)pid
{
    FMDatabase* db = [self getDB];
    FMResultSet* rs;
    NSMutableArray* data = [[NSMutableArray alloc]init];
    //    NSString * sqliteStr;
    NSMutableDictionary* dic;
    NSString * str = [NSString stringWithFormat:@"SELECT * FROM MANUAL_ITEM where SECTIONS_ID = '%@'",textId];
    rs =[db executeQuery:str];
    while ([rs next]) {
        dic = [[[NSMutableDictionary alloc] init]autorelease];
        if ([rs stringForColumn:@"RANK"]) {
            [dic setObject:[rs stringForColumn:@"RANK"] forKey:@"rank"];
        }
        if ([rs stringForColumn:@"TITLE"]) {
            [dic setObject:[rs stringForColumn:@"TITLE"] forKey:@"title"];
        }
        if ([rs stringForColumn:@"IMG"]) {
            [dic setObject:[rs stringForColumn:@"IMG"] forKey:@"img"];
        }
        if ([rs stringForColumn:@"CONTENT"]) {
            [dic setObject:[rs stringForColumn:@"CONTENT"] forKey:@"content"];
        }
        [data addObject:dic];
    }
    [db close];
    
    return [data autorelease];
}

//插入报告建议
- (BOOL)insertEvaluateToDBWithData:(NSDictionary*)data
{
    NSString* title = data[@"title"];
    NSString* time = data[@"time"];
    NSString* number = data[@"score"];
    NSString* userid = data[@"id"];
    FMDatabase* db = [self getLocalRecordDB];
    NSString *sqlite = [NSString stringWithFormat:@"INSERT INTO evaluate(title,time,score,id) VALUES ('%@','%@','%@','%@')",title,time,number,userid];
    NSLog(@"%@",sqlite);
    if ([db executeUpdate:sqlite]) {
        NSLog(@"insert success !");
        [db close];
        return YES;
    } else {
        NSLog(@"insert failed!");
        [db close];
        return NO;
    }
}

//获取测一测报告数据
- (NSMutableArray*)getAllEvaluateData
{
    FMDatabase* db = [self getLocalRecordDB];
    FMResultSet* rs;
    NSMutableArray* data = [[NSMutableArray alloc]init];
    //    NSString * sqliteStr;
    NSMutableDictionary* dic;
    NSString *sqlite = [NSString stringWithFormat:@"SELECT * FROM evaluate where id = '%@'",g_nowUserInfo.userid];

    rs =[db executeQuery:sqlite];
    while ([rs next]) {
        dic = [[[NSMutableDictionary alloc] init]autorelease];
        [dic setObject:[rs stringForColumn:@"title"] forKey:@"title"];
        [dic setObject:[rs stringForColumn:@"time"] forKey:@"time"];
        [dic setObject:[rs stringForColumn:@"score"] forKey:@"score"];
//        [dic setObject:[rs stringForColumn:@"id"] forKey:@"userid"];
        [data addObject:dic];
    }
    [db close];
    
    return [data autorelease];
}

//根据存储时间和userid删除报告数据
- (BOOL)DeleteEvaluateData:(NSString*)time
{
    FMDatabase* db = [self getLocalRecordDB];
    
    NSString *sql = [NSString stringWithFormat:@"delete from evaluate WHERE time = '%@' AND id = '%@'",time,g_nowUserInfo.userid];
    if ([db executeUpdate:sql]) {
        NSLog(@"delte success!");
        [db close];
        return YES;
    } else {
        NSLog(@"delete failed!");
        [db close];
        return NO;
    }
}

//体检参考数据
- (NSMutableArray*)getAllReportData
{
    FMDatabase* db = [self getDB];
    FMResultSet* rs;
    NSMutableArray* data = [[NSMutableArray alloc]init];
    //    NSString * sqliteStr;
    NSMutableDictionary* dic;

    rs =[db executeQuery:@"SELECT * FROM DMKBASE_EXAMINATION"];
    while ([rs next]) {
        dic = [[[NSMutableDictionary alloc] init]autorelease];
        [dic setObject:[rs stringForColumn:@"id"] forKey:@"id"];
        [dic setObject:[rs stringForColumn:@"item"] forKey:@"item"];
        [dic setObject:[rs stringForColumn:@"pinyin"] forKey:@"pinyin"];
        [dic setObject:[rs stringForColumn:@"normal"] forKey:@"normal"];
        //解密
        [dic setObject:[self decryptionWithStr:[rs stringForColumn:@"clinical_high"]] forKey:@"clinical_high"];
        if ([rs stringForColumn:@"clinical_low"]) {
            //解密
            [dic setObject:[self decryptionWithStr:[rs stringForColumn:@"clinical_low"]] forKey:@"clinical_low"];
        }else{
            [dic setObject:@"无" forKey:@"clinical_low"];

        }
        if ([rs stringForColumn:@"objective"]) {
            [dic setObject:[rs stringForColumn:@"objective"] forKey:@"objective"];
        }else{
            [dic setObject:@"无" forKey:@"objective"];

        }

        [data addObject:dic];
    }
    [db close];
    return [data autorelease];
}

//创建聊天表
//- (BOOL)createDBWithTable
//{
//    FMDatabase* db = [self getDB];
//    
//    BOOL isCreate = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS chatrecord(id INTEGER PRIMARY KEY AUTOINCREMENT, userId text(32) NOT NULL, doctorId text(32), msgContent text(1024), time text(16), isreply text(2), isSendOK text(2), contentType text(2), fromSelf text(2) NOT NULL, consultID text(32))"]; //fromSelf 0为自己, 1为别人, 2为系统    //isreply 0为已读, 1为未读    //contentType 0 文字，1 图片, 2音频    //isSendOK  0发送成功, 1正在发送, 2发送失败, 3图片发送成功,消息没有发送成功
//    [db close];
//    
//    return isCreate;
//}

//插入聊天行
- (BOOL)insertChatRecordToDBWithData:(NSDictionary*)data
{
    NSString* fromSelf = data[@"forSelf"];
	NSString* time = data[@"createTime"];
//	NSString* showTime = data[@"showTime"];
    NSString* msginfo = data[@"content"];
    NSString* contentType = data[@"contentType"];
    NSString *isSendOK = data[@"isSendOK"];
    NSString* userid = g_nowUserInfo.userid;
    NSString *doctorId = data[@"friendId"];
    int audioTime = [data[@"audioTime"] intValue];
//    NSString *height = [data objectForKey:@"height"];
//    NSString *width = data[@"width"];
//    NSString *isShow = data[@"isShow"];
    
//    isSendOK = [isSendOK isEqualToString:@"1"] ? @"0" : isSendOK;
    NSString* isreply = @"0";
    
    NSString *sqlite = [NSString stringWithFormat:@"INSERT INTO chatrecord(fromSelf,createTime,content,userId,isreply,contentType,isSendOK, friendId, audioTime) VALUES ('%@','%@','%@','%@', '%@', '%@', '%@', '%@', '%d')",fromSelf,time,msginfo,userid,isreply,contentType, isSendOK, doctorId, audioTime];//, height, width    , '%@', '%@'    , height, width
    return [self insertDataForLocalSQL:sqlite];
}

//查询聊天列表
- (NSMutableArray*)getChatRecordData:(int)page withFriendId:(NSString*)friendId
{
    FMDatabase* db = [self getLocalRecordDB];
    
    NSMutableArray* data = [[NSMutableArray alloc]init];
    NSMutableDictionary* dic;
    
    FMResultSet * rs = [db executeQuery:@"SELECT * FROM chatrecord WHERE userId = ? AND friendId = ? ORDER BY createTime DESC LIMIT ? OFFSET ?",g_nowUserInfo.userid, friendId, [NSString stringWithFormat:@"%d", 15],[NSString stringWithFormat:@"%d",page]];
    while ([rs next]) {
        dic = [NSMutableDictionary dictionary];
        [dic setObject:[rs stringForColumn:@"fromSelf"] forKey:@"forSelf"];
		[dic setObject:[rs stringForColumn:@"createTime"] forKey:@"createTime"];
        [dic setObject:[Common isNULLString3:[rs stringForColumn:@"content"]] forKey:@"content"];
        [dic setObject:[rs stringForColumn:@"userId"] forKey:@"fromId"];
        [dic setObject:[rs stringForColumn:@"isreply"] forKey:@"isreply"];
        [dic setObject:[rs stringForColumn:@"contentType"] forKey:@"contentType"];
        [dic setObject:[rs stringForColumn:@"isSendOK"] forKey:@"isSendOK"];
        [dic setObject:[rs stringForColumn:@"friendId"] forKey:@"friendId"];
        [dic setObject:[rs stringForColumn:@"audioTime"] forKey:@"audioTime"];
//        [dic setObject:[rs stringForColumn:@"height"] forKey:@"height"];
//        [dic setObject:[rs stringForColumn:@"width"] forKey:@"width"];
        
        [data addObject:dic];
    }
    [db close];
    return [data autorelease];
}

//查询信箱列表
- (NSMutableArray*)getMsgListData:(int)page type:(int)type
{
    FMDatabase* db = [self getLocalRecordDB];
    
    NSMutableArray* data = [[NSMutableArray alloc]init];
    NSMutableDictionary* dic;
    FMResultSet * rs = [db executeQuery:@"SELECT * FROM systemMsg0 WHERE userId = ? ORDER BY createTime DESC LIMIT ? OFFSET ?",g_nowUserInfo.userid, [NSString stringWithFormat:@"%d", g_everyPageNum], [NSString stringWithFormat:@"%d",page]];
    if (type) {
        rs = [db executeQuery:@"SELECT * FROM systemMsg1 WHERE userId = ? ORDER BY createTime DESC LIMIT ? OFFSET ?",g_nowUserInfo.userid, [NSString stringWithFormat:@"%d", g_everyPageNum], [NSString stringWithFormat:@"%d",page]];
    }
    while ([rs next]) {
        dic = [NSMutableDictionary dictionary];
        [dic setObject:[rs stringForColumn:@"id"] forKey:@"id"];
        [dic setObject:[rs stringForColumn:@"title"] forKey:@"title"];
        [dic setObject:[Common isNULLString3:[rs stringForColumn:@"content"]] forKey:@"content"];
        [dic setObject:[rs stringForColumn:@"createUserName"] forKey:@"createUserName"];
        [dic setObject:[rs stringForColumn:@"createTime"] forKey:@"createTime"];
        [dic setObject:[rs stringForColumn:@"broadcastId"] forKey:@"broadcastId"];
        [dic setObject:[rs stringForColumn:@"broadcastType"] forKey:@"broadcastType"];//系统消息0; //私有新建1; //挑战书2; //评论帖子3; //回复4;
        [dic setObject:[rs stringForColumn:@"isRead"] forKey:@"isRead"]; //0为未读, 1为已读
        
        [data addObject:dic];
    }
    [db close];
    return [data autorelease];
}

//插入消息
- (BOOL)insertMegToDBWithData:(NSDictionary*)data type:(int)type
{
    NSString* content = data[@"content"];
    NSString* broadcastId = data[@"broadcastId"];
    NSString* broadcastType = data[@"broadcastType"];
    NSString *createUserName = data[@"createUserName"];
    NSString* userid = g_nowUserInfo.userid;
    NSString *title = data[@"title"];
    NSString *createTime = data[@"createTime"];
    NSString * dStr = [NSString stringWithFormat:@"systemMsg%d",type];

    NSString *sqlite = [NSString stringWithFormat:@"INSERT INTO %@(content,broadcastId,broadcastType,isRead,createUserName,title,createTime,userId) VALUES ('%@','%@','%@','%d', '%@', '%@', '%@', '%@')",dStr,content,broadcastId,broadcastType,0,createUserName,title, createTime, userid];
    return [self insertDataForLocalSQL:sqlite];
}

//删除信箱信息
- (BOOL)DeleteMegToDBWithData:(NSDictionary*)data type:(int)type
{
    FMDatabase* db = [self getLocalRecordDB];
    NSString* broadcastId = data[@"broadcastId"];
    NSString *sql = [NSString stringWithFormat:@"delete from systemMsg%d WHERE broadcastId = '%@'",type,broadcastId];
    if ([db executeUpdate:sql]) {
        NSLog(@"delte success!");
        [db close];
        return YES;
    } else {
        NSLog(@"delete failed!");
        [db close];
        return NO;
    }
}

//删除信箱信息
- (BOOL)ClearMegToDBType:(int)type
{
    FMDatabase* db = [self getLocalRecordDB];
    
    NSString *sql = [NSString stringWithFormat:@"delete from systemMsg%d WHERE broadcastId > 0",type];
    if ([db executeUpdate:sql]) {
        NSLog(@"delte success!");
        [db close];
        return YES;
    } else {
        NSLog(@"delete failed!");
        [db close];
        return NO;
    }
}


//获取未读消息数
- (int)getNoReadCount;
{
    FMDatabase* db = [self getLocalRecordDB];
    int count = 0,count1 = 0;
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) AS count FROM systemMsg0 WHERE userId = %@ AND isRead = 0", g_nowUserInfo.userid];
    
    FMResultSet * rs = [db executeQuery:sql];//, g_nowUserInfo.userid, 0];
    while ([rs next]) {
        count = [rs intForColumn:@"count"];
    }
    sql = [NSString stringWithFormat:@"SELECT COUNT(*) AS count FROM systemMsg1 WHERE userId = %@ AND isRead = 0", g_nowUserInfo.userid];
    
    rs = [db executeQuery:sql];//, g_nowUserInfo.userid, 0];
    while ([rs next]) {
        count1 = [rs intForColumn:@"count"];
    }
    [db close];
    return count+count1;
}

@end
