//
//  FriendApplyCell.h
//  jiuhaohealth3.0
//
//  Created by jiuhao-yangshuo on 15-3-9.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FriendApplyCellBlock)();

@interface FriendApplyCell : UITableViewCell

@property(nonatomic,retain)UIImageView* m_headerView;

@property(nonatomic,retain) UIButton *m_addButton;

@property(nonatomic,retain) UILabel *m_nameLabel;

- (void)setInfoDic:(NSMutableDictionary *)dic with:(FriendApplyCellBlock )_handler;

///  改变申请状态
-(void)changeMaddButtonState;

@end
