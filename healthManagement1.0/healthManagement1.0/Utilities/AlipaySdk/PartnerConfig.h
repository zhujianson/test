//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088021458463108"
//收款支付宝账号
#define SellerID  @"service01@jiuhaohealth.com"

//回调地址
//#define kAliNotify_url  @"http://kxpay.kangxun360.com/charge/sendGoods"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @""

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAKUlNxQFKNoisxQXtWx1nDQYGzefqQGEdKMzqVNdftf0UNMLpPS0VFDhmhbSZSR9M96gd/xVf3NZ0LuuJuFzlt9k9w9GTq3N7rFdrzxo0Zq7GaT991YJwOMMJhPtrdt3Y3VNmzgzI849WPc0FJ8flcCaPDFLNs8L5WMP2Lf5qox1AgMBAAECgYAsV6LDWGNQtvJ4makYFzg68KIWPGOHycX7sDpt7PPLDonJMR44qlbdZMYYDKQluQx9YX72HQrcsSgPzMIZ1QyUPrZERvObk5jJaulG/rVCadP0Cbl+JzUrslHM2t7JYKN3FEHk4fBJn+frwJVNqCgyR6Oht+DdaSRUqFFAPL7lHQJBANME3JMM+jv77dF1rFtVxRmjRbGW2gPheO5/7tngB/nia+S3lfgJsIm/dFJUkRbsuOruZK/nacYA6YmTxOW8cmcCQQDIWREP7bzVjBlP7ZhCBvRiPwxk9IapbjB4Qsenwv+1tHt77s3zKPYVsD13X/oNhXupzlqo6yQ+X/1VehXGVFjDAkBCktIUApAfxIdvAbTyy8h3Ii+mq3T0rHm+pNXyHt/lUi2/5ruFmWj8zE4ie1Oa6+wbEkLpzBRux3LmWJxR7nYZAkEAjhl2G5kgbUpADcvUSUiLfz9+uAAjnvqTkEi1OYz6N1O6nc1j78qmt/1Xq1q8jWiWrHq7HMIi48bLdRvxY8khZwJANko4uRwqU95TyxcPg7XiqdiOdQX1qaP3eCX7bAFlV9kGWyE7iMVlVdmxpGSeq+OhUuJP39lAPU8gYGR+qPB7tQ=="

//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQClJTcUBSjaIrMUF7VsdZw0GBs3n6kBhHSjM6lTXX7X9FDTC6T0tFRQ4ZoW0mUkfTPeoHf8VX9zWdC7ribhc5bfZPcPRk6tze6xXa88aNGauxmk/fdWCcDjDCYT7a3bd2N1TZs4MyPOPVj3NBSfH5XAmjwxSzbPC+VjD9i3+aqMdQIDAQAB"

#endif
