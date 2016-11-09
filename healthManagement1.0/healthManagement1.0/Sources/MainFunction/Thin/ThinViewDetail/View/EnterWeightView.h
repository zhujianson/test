//
//  EnterWeightView.h
//  healthManagement1.0
//
//  Created by jiuhao-yangshuo on 16/6/3.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kWeight = @"kWeight";
@interface EnterWeightView : UIView

@property (nonatomic,strong) NSDictionary *infoDict;
+(void )showEnterWeightViewWithBlock:(KXBasicBlock)block withDict:(NSDictionary *)dict;

@end
