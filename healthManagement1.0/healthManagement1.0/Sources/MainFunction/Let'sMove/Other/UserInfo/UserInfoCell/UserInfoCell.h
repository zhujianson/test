//
//  UserInfoCell.h
//  jiuhaohealth4.0
//
//  Created by xjs on 15/4/21.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SwitchStatusFlagBlock)(int isSwirch);
@interface UserInfoCell : UITableViewCell

@property (nonatomic,assign) BOOL isMeFlag;

- (void)setDataFromDic:(NSDictionary*)dic;

@property (nonatomic,copy) SwitchStatusFlagBlock switchBlock;

- (void)setSwitchStatusFlag:(SwitchStatusFlagBlock)blocks;

@end
