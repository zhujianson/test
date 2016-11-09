//
//  FriendListCell.h
//  jiuhaohealth3.0
//
//  Created by jiuhao-yangshuo on 15-3-9.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendModel.h"

@interface FriendListCell : UITableViewCell

@property(nonatomic, assign) UIImageView* m_headerView;//

@property(nonatomic, assign) UIImageView *redImage;//未读

- (void)setInfoModel:(FriendModel*)friendModel;
//+(void)convertCreatTimeWithDict:(NSMutableDictionary *)indexDict;

@end

