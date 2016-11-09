//
//  RadarDoctorList.h
//  jiuhaohealth4.0
//
//  Created by xjs on 15/5/27.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
//#import "IconOperationQueue.h"
#import "FriendApplyViewController.h"

@interface RadarDoctorList : CommonViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) ENUM_FRIEND_TYPE type;//0医生，1糖友

@end
