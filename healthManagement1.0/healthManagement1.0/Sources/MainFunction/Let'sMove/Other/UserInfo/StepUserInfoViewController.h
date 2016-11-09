//
//  StepUserInfoViewController.h
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-11-28.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepUserInfoViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL isMeFlag;

@property (nonatomic,retain) NSString *userId;//用户id

@property (nonatomic,retain) NSMutableDictionary *publishPostsDic;



@end
