//
//  DocDetailViewController.h
//  jiuhaohealth3.0
//
//  Created by wangmin on 15-3-10.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendModel.h"

@interface DocDetailViewController : CommonViewController

@property (nonatomic, assign) BOOL hasOnTimeFlag;//是否显示在线时间

//@property (nonatomic, retain) NSMutableDictionary *m_dicInfo;

@property (nonatomic, assign) FriendModel *friendModel;

@end
