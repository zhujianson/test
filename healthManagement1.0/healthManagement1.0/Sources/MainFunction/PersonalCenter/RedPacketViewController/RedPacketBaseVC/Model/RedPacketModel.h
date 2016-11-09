//
//  RedPacketType.h
//  jiuhaohealth4.2
//
//  Created by jiuhao-yangshuo on 15/12/11.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>

//0:未使用   1:已过期   2:已使用
typedef enum : NSUInteger {
    RedPacketUseTypeNoUse = 0,
    RedPacketUseTypeExpire,
    RedPacketUseTypeUse
} RedPacketUseType;

@interface RedPacketModel : NSObject

@end
