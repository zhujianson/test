//
//  AlertTimeViewController.h
//  jiuhaoHealth2.0
//
//  Created by yangshuo on 14-4-3.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

typedef void (^AlertTimeViewControllerBlock)(NSString *timeContent);

@interface AlertTimeViewController : CommonViewController

@property(nonatomic,retain)NSString *defaultString;

-(void)setAlertTimeViewControllerBlock:(AlertTimeViewControllerBlock)_handler;

- (id)initWithTimeString:(NSString *)timeString;

@end
