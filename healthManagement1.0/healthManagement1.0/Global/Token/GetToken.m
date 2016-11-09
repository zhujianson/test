//
//  GetToken.m
//  jiuhaohealth3.0
//
//  Created by 徐国洪 on 15-1-17.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//


#import "GetToken.h"
#import "QiniuSDK.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation GetToken

//NSString *m_token;
NSLock *m_lockArray;

NSMutableArray *g_array;

+ (NSString *)hmac_sha1:(NSString *)key text:(NSString *)text
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    
    char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    NSString *hash = [HMAC base64Encoding];//base64Encoding函数在NSData+Base64中定义（NSData+Base64网上有很多资源）
    [HMAC release];
    return hash;
}

+ (NSString*)getTokenStr:(long)time
{
    NSString *ak = @"Cw7jYmgPGOGntAXzphtgN5ONMA4XVK6oZ9U3AL35";
    NSString *sk = @"AJ5hvAg3nYLOFdYMOZUgOWDf2B4YHyvu9syx6MXZ";
    
//    NSString *ak = @"XjGoSNfrOrbEvuFyxL4ng53y5tkyyhkty0UMbGAI";
//    NSString *sk = @"ufCzPB8VEp3QY6K8LTjPAVq1syLXDZmU-PYMHqSP";
//    [dic setObject:@"xuguohong" forKey:@"scope"];//
    
//    NSTimeInterval secondsPerDay = 60*60;
//    NSDate* date = [[NSDate date] dateByAddingTimeInterval:secondsPerDay];
//    long time = [date timeIntervalSince1970];
//    long time = [Common getLongTime]+60*60;
    if (time - g_longTime > 40 * 60) {
        g_longTime = time;
    }
    NSDictionary *putPolicy = @{@"scope":@"kangxun", @"deadline":[NSNumber numberWithLong:time]};

    NSString *strDic = [putPolicy KXjSONString];
    NSString *encoded = [[strDic dataUsingEncoding:NSUTF8StringEncoding] base64Encoding];
    NSString *encode_signed = [GetToken hmac_sha1:sk text:encoded];
    
    NSString *token = [ak stringByAppendingString:[NSString stringWithFormat:@":%@:%@", encode_signed, encoded]];
    
    return token;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    [g_array release];
    [super dealloc];
}

+ (void)submitData:(NSData*)data withBlock:(submitDataReturn)delegate withName:(NSString*)name1
{
    NSString *name = [NSString stringWithFormat:@"%@_%ld_%d", g_nowUserInfo.userid, [CommonDate getLongTime],arc4random()%1000];
    if (name1) {
        name = name1;
    }

    static GetToken *gtoken = nil;
    if (!gtoken) {
        gtoken = [[GetToken alloc] init];
        g_array = [[NSMutableArray alloc] init];
//        m_lockArray = [[NSLock alloc] init];
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[data retain] forKey:@"data"];
    [dic setObject:[delegate copy] forKey:@"delegate"];
    [dic setObject:[name retain] forKey:@"name"];
    
//    [m_lockArray lock];
    [g_array addObject:dic];
//    [dic release];
//    [m_lockArray unlock];
    
    [gtoken getToken:^(NSString *token){
        
        if (!token) {
            delegate(NO, name);
        } else {
//            [m_lockArray lock];
            NSDictionary *dic1 = [g_array objectAtIndex:0];
            NSData *data1 = [dic1 objectForKey:@"data"];
//            NSLog(@"imageSize==========================================%d", [data1 length]);
            submitDataReturn delegate1 = [dic1 objectForKey:@"delegate"];
            NSString *name1 = [dic1 objectForKey:@"name"];
            [g_array removeObjectAtIndex:0];
            [dic1 release];

            [gtoken submitData:data1 withName:name1 withToken:g_nowUserInfo.qiniuToken withBlock:delegate1];
            
//            [m_lockArray unlock];
        }

    }];
}

- (void)submitData:(NSData*)data withName:(NSString*)name withToken:(NSString*)token withBlock:(submitDataReturn)delegate
{
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    
    [upManager putData:data key:name token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  BOOL isOK = YES;
                  if (info.statusCode != 200) {
                      g_longTime = 0;
                      isOK = NO;
                  }
                  delegate(isOK, name);
                  [upManager release];
                  [data release];
                  [name release];
                  [delegate release];
              } option:nil];    
}

- (void)getToken:(getTokenDataReturn)block
{
    if (!m_block) {
        m_block = [block copy];
    }
    
//    [g_submitData lock];
    long time = [CommonDate getLongTime];
    if (time - g_longTime > 11 * 60 * 60) {
        if (g_nowUserInfo.qiniuToken) {
            [g_nowUserInfo.qiniuToken release];
            g_nowUserInfo.qiniuToken = nil;
        }
        
        NSString *ss = [NSString stringWithFormat:@"%x", (unsigned int)self];
        [g_winDic setObject:[NSMutableArray array] forKey:ss];
        [[CommonHttpRequest defaultInstance] sendNewPostRequest:GET_QINIU_TOKEN values:[NSDictionary dictionary] requestKey:GET_QINIU_TOKEN delegate:self controller:APP_DELEGATE actiViewFlag:1 title:nil];
    }
    else {
        m_block(g_nowUserInfo.qiniuToken);
    }
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    m_block(nil);
//    [g_submitData unlock];
}

- (void)didFinishSuccess:(ASIHTTPRequest*)loader
{
    NSString* responseString = [loader responseString];
    NSDictionary* dict = [responseString KXjSONValueObject];
    NSDictionary * dic = dict[@"head"];
    
    if (![[dic objectForKey:@"state"] intValue] == 0) {
        [Common TipDialog:[dic objectForKey:@"msg"]];
        return;
    }

    if ([loader.username isEqualToString:GET_QINIU_TOKEN]) {
        g_longTime = [CommonDate getLongTime];
        g_nowUserInfo.qiniuToken = dict[@"body"][@"token"];
        m_block(g_nowUserInfo.qiniuToken);
    }
//    [g_submitData unlock];
}

@end
