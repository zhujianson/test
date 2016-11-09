//
//  FriendApplyViewController.h
//  jiuhaohealth3.0
//
//  Created by jiuhao-yangshuo on 15-3-9.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

typedef enum{
    userApply = 1,
    doctorApply = 2,
}ENUM_FRIEND_TYPE;

typedef void (^FriendApplyViewBlock)(NSMutableDictionary *dataDic);

@interface FriendApplyViewController : CommonViewController

@property (nonatomic, assign) ENUM_FRIEND_TYPE applyType;
@property (nonatomic, copy) FriendApplyViewBlock applyViewBlock;

@end
