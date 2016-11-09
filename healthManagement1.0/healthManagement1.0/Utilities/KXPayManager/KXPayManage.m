//
//  KXPayManage.h
//  testAliPay
//
//  Created by JSen on 14/9/29.
//  Copyright (c) 2014年 wifitong. All rights reserved.
//

#import "KXPayManage.h"
#import "AlixPayOrder.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "DataVerifier.h"
#import <AlipaySDK/AlipaySDK.h>
#import <UIKit/UIKit.h>
#import "WXConfig.h"
#import <AlipaySDK/AlipaySDK.h>
//APP端签名相关头文件
#import "payRequsestHandler.h"
#import "KXPayManage.h"
#import "WXUtil.h"

@interface KXPayManage ()<WXApiDelegate,WXApiManagerDelegate>

@end

@implementation KXPayManage
+ (instancetype)sharePayEngine
{
    static KXPayManage *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _resultSEL = @selector(paymentResult:);
    }
    return self;
}

+ (void)setUpPayManage
{
//    BOOL isok = [WXApi registerApp:kWXAppID];
//    if (isok)
//    {
//        NSLog(@"注册微信成功");
//    }
//    else
//    {
//        NSLog(@"注册微信失败");
//    }
    [KXPayManage connectAliPayWithSchema:kAppSchema partner:PartnerID seller:SellerID RSAPrivateKey:PartnerPrivKey RSAPublicKey:AlipayPubKey];
}


- (void)paymentResult:(NSDictionary *)result
{
    //    if (_finishBlock) {
    //                _finishBlock(result.statusCode, result.statusMessage, result.resultString, nil, nil);
    //            }
    if (result)
    {
        int code = [result[@"resultStatus"] intValue];
        NSString *message = @"";
        switch (code)
        {
            case 9000:
                message = @"订单支付成功";
                break;
            case 8000:
                message = @"正在处理中";
                break;
            case 4000:
                message = @"订单支付失败";
                break;
            case 6001:
                message = @"订单支付取消";
                break;
            case 6002:
                message = @"网络连接出错";
                break;
            default:
                break;
        }
        
        [Common MBProgressTishi:message forHeight:kDeviceHeight];
    }
}

- (void)setAliPaySchema:(NSString *)schema
                partner:(NSString *)partnerKey
                 seller:(NSString *)sellerKey
          RSAPrivateKey:(NSString *)privateKey
           RSAPublicKey:(NSString *)publickKey
{
    _schema = schema;
    _partnerKey = partnerKey;
    _sellerKey = sellerKey;
    _RSAPrivateKey = privateKey;
    _RSAPublicKey = publickKey;
}

+ (void)connectAliPayWithSchema:(NSString *)schema
                        partner:(NSString *)partnerKey
                         seller:(NSString *)sellerKey
                  RSAPrivateKey:(NSString *)privateKey
                  RSAPublicKey :(NSString *)publicKey
{
    [[KXPayManage sharePayEngine] setAliPaySchema:schema
                                          partner:partnerKey
                                           seller:sellerKey
                                    RSAPrivateKey:privateKey
                                     RSAPublicKey:publicKey];
}

+ (void)paymentWithInfo:(NSDictionary *)payInfo result:(paymentFinishCallBack)block
{
    //    NSURL * myURL_APP_A = [NSURL URLWithString:@"alipay:"];
    //    if (![[UIApplication sharedApplication] canOpenURL:myURL_APP_A])
    //    {
    //        //如果没有安装支付宝客户端那么需要安装
    //        [Common MBProgressTishi:@"请安装支付宝钱包!" forHeight:kDeviceHeight];
    ////        UIAlertView *message = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"点击确定安装支付宝钱包!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    ////        [message show];
    //        return;
    //    }
    [[KXPayManage sharePayEngine] paymentWithInfo:payInfo result:block];
}

- (void)paymentWithInfo:(NSDictionary *)payInfo result:(paymentFinishCallBack)block
{
    _finishBlock = [block copy];
    NSString *orderID = payInfo[kOrderID];
    NSString *total = payInfo[kTotalAmount];
    NSString *produceDes = payInfo[kProductDescription];
    NSString *productName = payInfo[kProductName];
    NSString *notifyURL = payInfo[kNotifyURL];
    
    if (orderID.length == 0) {
        orderID = [self generateTradeNO];
    }
    if (_partnerKey.length == 0 || _sellerKey.length == 0) {
        NSError *err = [NSError errorWithDomain:@"partner或seller参数为空" code:-1 userInfo:nil];
        if (_finishBlock) {
            _finishBlock(-1, nil, nil, err, nil);
        }
        return ;
    }
    
    AlixPayOrder *aliOrder = [[AlixPayOrder alloc]init];
    aliOrder.partner = _partnerKey;
    aliOrder.seller = _sellerKey;
    aliOrder.tradeNO = orderID;
    aliOrder.productDescription = produceDes;
    aliOrder.productName = productName;
    aliOrder.amount = total;  //暂时
    aliOrder.notifyURL = notifyURL;
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [aliOrder description];
    NSString *signedStr = [self doRsa:orderSpec];
    
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             aliOrder, signedStr, @"RSA"];
    WS(weakSelf);
    if (orderString != nil)
    {
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:kAppSchema callback:^(NSDictionary *resultDic)
        {
            [weakSelf paymentResult:resultDic];
            NSLog(@"reslut = %@",resultDic);
            if (_finishBlock)
            {
                NSString *payState = [resultDic[@"resultStatus"] intValue] == 9000?kPaySuccess:@"";
                _finishBlock(0, payState, resultDic, nil, nil);
            }
        }];
    }
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

/*
 *随机生成15位订单号,外部商户根据自己情况生成订单号
 */
- (NSString *)generateTradeNO
{
    const int N = 15;
    
    NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *result = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < N; i++)
    {
        unsigned index = rand() % [sourceString length];
        NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
        [result appendString:s];
    }
    return result;
}

#pragma mark -wxNet
- (void)getWXPlayInfo:(NSDictionary*)item
{
    [g_winDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:kWXAppID forKey:@"appId"];
    [dic setObject:item[kOrderID] forKey:@"tradeNo"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:URL_wxPrePay values:dic requestKey:URL_wxPrePay delegate:self controller:APP_DELEGATE actiViewFlag:1 title:nil];
}

- (void)closePlay
{
    NSString *add = [NSString stringWithFormat:@"%x", (unsigned int)self];
    NSMutableArray* array = [g_winDic objectForKey:add];
    for (ASIHTTPRequest* asi in array) {
        if (!asi.winCloseIsNoCancle) {
            [asi cancel];
        }
    }
    [g_winDic removeObjectForKey:add];
}

- (void)didFinishFail:(ASIHTTPRequest*)loader
{
    NSLog(@"");
    [self closePlay];
}

- (void)didFinishSuccess:(ASIHTTPRequest*)loader
{
    NSString* responseString = [loader responseString];
    NSDictionary* dic = [responseString KXjSONValueObject];
    NSDictionary *head = [dic objectForKey:@"head"];
    if (![[head objectForKey:@"state"] intValue])
    {
        NSMutableDictionary *body = [dic objectForKey:@"body"];
        if([loader.username isEqualToString:URL_wxPrePay])
        {
            [self handleWxPayWithResult:body];
        }
    }
    else
    {
        [Common TipDialog2:dic[@"head"][@"msg"]];
    }
    [self closePlay];
}

#pragma mark - 微信支付过程
-(void)handleWxPayWithResult:(NSMutableDictionary *)dict
{
    [dict setObject:kWXAppID forKey:@"appid"];
    [dict setObject:@"Sign=WXpay" forKey:@"package"];
    NSMutableString *stamp  = dict[@"timestamp"];
    
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject: dict[@"appid"]        forKey:@"appid"];
    [signParams setObject: dict[@"noncestr"]    forKey:@"noncestr"];
    [signParams setObject: dict[@"package"]      forKey:@"package"];
    [signParams setObject:  dict[@"partnerid"]      forKey:@"partnerid"];
    [signParams setObject: stamp   forKey:@"timestamp"];
    [signParams setObject: dict[@"prepayid"]     forKey:@"prepayid"];
    //[signParams setObject: @"MD5"       forKey:@"signType"];
    //生成签名
    NSString *sign  = [self createMd5Sign:signParams];
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [dict objectForKey:@"appid"];
    req.partnerId           = [dict objectForKey:@"partnerid"];
    req.prepayId            = [dict objectForKey:@"prepayid"];
    req.nonceStr            = [dict objectForKey:@"noncestr"];
    req.timeStamp           = stamp.intValue;
    req.package             = [dict objectForKey:@"package"];
    req.sign                = sign;
    //     req.sign                = dict[@"sign"];
    BOOL state = [WXApi sendReq:req];
    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
    [WXApiManager sharedManager].delegate = self;
}

-(void)wxPayInstaceActionWithInfo:(NSDictionary *)payInfo result:(paymentFinishCallBack)block
{
    if (![WXApi isWXAppInstalled])
    {
        [Common MBProgressTishi:@"请安装微信客户端!" forHeight:kDeviceHeight];
        return;
    }
    [self getWXPlayInfo:payInfo];
    _finishBlock = [block copy];
    
    //    [self pay];
    return;
    
    //{{{
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
    
    //创建支付签名对象
    //    payRequsestHandler *req = [payRequsestHandler alloc];
    //    //初始化支付签名对象
    //    [req init:kWXAppID mch_id:MCH_ID];
    //    //设置密钥
    //    [req setKey:PARTNER_ID];
    //
    //    //}}}
    //
    //    //获取到实际调起微信支付的参数后，在app端调起支付
    //    NSMutableDictionary *dict = [req sendPayWithDict:payInfo];
    //
    //    if(dict == nil){
    //        //错误提示
    //        NSString *debug = [req getDebugifo];
    //        [Common MBProgressTishi:debug forHeight:kDeviceHeight];
    //        NSLog(@"%@\n\n",debug);
    //    }else{
    //        NSLog(@"%@\n\n",[req getDebugifo]);
    //        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
    //        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
    //        //调起微信支付
    //        PayReq* req             = [[PayReq alloc] init];
    //        req.openID              = [dict objectForKey:@"appid"];
    //        req.partnerId           = [dict objectForKey:@"partnerid"];
    //        req.prepayId            = [dict objectForKey:@"prepayid"];
    //        req.nonceStr            = [dict objectForKey:@"noncestr"];
    //        req.timeStamp           = stamp.intValue;
    //        req.package             = [dict objectForKey:@"package"];
    //        req.sign                = [dict objectForKey:@"sign"];
    //        [WXApi sendReq:req];
    //    }
    //    
    //    [WXApiManager sharedManager].delegate = self;
}


-(void)managerDidRecvPayResp:(PayResp *)response
{
    if (_finishBlock)
    {
        NSString *payState = WXSuccess == response.errCode?kPaySuccess:@"";
        _finishBlock(response.errCode, payState, nil, nil, nil);
    }
}

-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", PARTNER_ID];
    //得到MD5 sign签名
    NSString *md5Sign =[WXUtil md5:contentString];
    
    //输出Debug Info
    //    [debugInfo appendFormat:@"MD5签名字符串：\n%@\n\n",contentString];
    
    return md5Sign;
}

+(void)wxPayActionWithInfo:(NSDictionary *)payInfo result:(paymentFinishCallBack)block
{
    NSMutableDictionary *newDict = [payInfo mutableCopy];
    NSString *strTotalAmount = payInfo[kTotalAmount];
    float count = [strTotalAmount floatValue];
    int countInt = count *100;
    if (countInt <= 0)
    {
        NSLog(@"金额错误");
//        return;
    }
    NSString *totalAmount = [NSString stringWithFormat:@"%d",countInt];
    [newDict setObject:totalAmount forKey:kTotalAmount];
    [[KXPayManage sharePayEngine] wxPayInstaceActionWithInfo:newDict result:block];
}

-(void)setUpNilBlock
{
    if (_finishBlock)
    {
        _finishBlock = nil;
    }
}


+(void)wxPayWithHandleServerResult:(NSMutableDictionary *)dict result:(paymentFinishCallBack)block
{
    [KXPayManage sharePayEngine].finishBlock = block;
    [[KXPayManage sharePayEngine] handleWxPayWithResult:dict];
}

@end
