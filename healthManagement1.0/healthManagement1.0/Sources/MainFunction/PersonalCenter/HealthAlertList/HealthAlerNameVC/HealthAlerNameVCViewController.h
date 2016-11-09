//
//  HealthAlerNameVCViewController.h
//  jiuhaohealth2.1
//
//  Created by jiuhao-yangshuo on 14-8-18.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HealthAlerNameVCViewControllerBlock)(NSString  *content);

@interface HealthAlerNameVCViewController : CommonViewController
{
    NSString *m_Content;
}

-(void)setHealthAlerNameVCViewControllerBlock:(HealthAlerNameVCViewControllerBlock)_handler;

- (id)initWithTitle:(NSString *)title andWithPlaceHoder:(NSString *)placeHoder;

@property(nonatomic,copy) NSString *m_Content;

@end
