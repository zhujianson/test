//
//  WeekActivityView.h
//  healthManagement1.0
//
//  Created by jiuhao-yangshuo on 16/6/3.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSInteger, type) {
//    type1,
//    type2,
//    type2
//};

static float kLeftw = 15.0;
@interface WeekActivityView : UIView

@property (nonatomic,strong) NSDictionary *infoDict;

@property (nonatomic,copy) KXBasicBlock thinPlanViewBlock;

- (void)closeWebViewItem;

- (void)setUpWeekPuchState;

@end
