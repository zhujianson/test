//
//  ResultView.h
//  healthManagement1.0
//
//  Created by jiuhao-yangshuo on 16/2/24.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BodyMeasure.h"

@interface ResultView : UIView

-(id)initWithBodyMeasuret:(BodyMeasure *)value;
+(void)showResultViewWithBodyMeasuret:(BodyMeasure *)value;

@end
