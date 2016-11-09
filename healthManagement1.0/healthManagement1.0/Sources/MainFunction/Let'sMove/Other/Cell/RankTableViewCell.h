//
//  RankTableViewCell.h
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-9-28.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankTableViewCell : UITableViewCell


@property (nonatomic,retain) NSDictionary *dataDic;

- (void)setDataDic:(NSDictionary *)dataDic isFirst:(BOOL)yes isDay:(BOOL)yesDay;

@end
