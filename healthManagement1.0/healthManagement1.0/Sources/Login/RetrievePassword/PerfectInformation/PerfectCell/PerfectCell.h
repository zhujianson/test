//
//  PerfectCell.h
//  jiuhaohealth4.0
//
//  Created by xjs on 15/5/28.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PerfectBlock)(NSDictionary *dic);
@interface PerfectCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic,retain) PerfectBlock P_block;

- (void)setInfoWithDic:(NSDictionary*)dic row:(NSInteger)row;

- (void)setP_block:(PerfectBlock)P_block;
- (void)setInfoWithDic:(NSDictionary*)dic;

- (void)removeTextFirst;
@end
