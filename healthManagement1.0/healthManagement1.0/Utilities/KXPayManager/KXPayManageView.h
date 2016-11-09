//
//  KXPayManageView.h
//  jiuhaohealth4.2
//
//  Created by jiuhao-yangshuo on 15/12/21.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KXPayManageViewCell.h"

typedef enum : NSUInteger {
    KXPayManageTypeAli = 0,
    KXPayManageTypeWX,
    KXPayManageTypeWXDaifu
} KXPayManageType;

typedef void (^KXPayManageViewBlock)(KXPayManageType selecteContent);

@interface KXPayManageView : UIView

+(void )showKXPayManageViewWithBlock:(KXPayManageViewBlock )block;

@end