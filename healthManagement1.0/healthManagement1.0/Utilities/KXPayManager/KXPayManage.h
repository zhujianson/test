//
//  KXPayManage.h
//  testAliPay
//
//  Created by JSen on 14/9/29.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>
#import "CommonUtil.h"
#import "AFURLSessionManager.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import "WXConfig.h"

static NSString *const kOrderID = @"OrderID";
static NSString *const kTotalAmount = @"TotalAmount";
static NSString *const kProductDescription = @"productDescription";
static NSString *const kProductName = @"productName";
static NSString *const kNotifyURL = @"NotifyURL";
static NSString *const kAppSchema = @"com.9haohealth.jiuhao";
static NSString *const kPaySuccess = @"kPaySuccess";

typedef void(^paymentFinishCallBack)(int statusCode, NSString *statusMessage, id resultDict, NSError *error, NSData *data);

@interface KXPayManage : NSObject
{
    
    NSString *_schema;
    NSString *_partnerKey;
    NSString *_sellerKey;
    NSString *_RSAPrivateKey;
    NSString *_RSAPublicKey;
    
//    paymentFinishCallBack _finishBlock;
    SEL _resultSEL;
}


@property (nonatomic,copy)  paymentFinishCallBack finishBlock;

//设置支付
+ (void)setUpPayManage;

+ (instancetype)sharePayEngine;

+ (void)connectAliPayWithSchema:(NSString *)schema
                        partner:(NSString *)partnerKey
                         seller:(NSString *)sellerKey
                  RSAPrivateKey:(NSString *)privateKey
                  RSAPublicKey :(NSString *)publicKey;

+ (void)paymentWithInfo:(NSDictionary *)payInfo result:(paymentFinishCallBack)block;

/*
 由于微信支付有部分工作需要服务器来做故这里只是放一个示例，以助大家了解整个过程，实际开发中不能这么做
 微信支付过程
 1.获取accessToken
 2.获取prepayId
 3.构造支付请求(PayReq)，支付
 4.支付结束回调
 */
+(void)wxPayActionWithInfo:(NSDictionary *)payInfo result:(paymentFinishCallBack)block;

//置为空
-(void)setUpNilBlock;

//直接拿服务器数据支付
+(void)wxPayWithHandleServerResult:(NSMutableDictionary *)dict result:(paymentFinishCallBack)block;
@end