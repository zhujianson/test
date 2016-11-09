//
//  HealthRecordCell.h
//  healthManagement1.0
//
//  Created by wangmin on 16/1/6.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthRecordModel.h"


@interface BaseHealthRecordCell : UITableViewCell

@property (nonatomic,strong) UIView *lineView;


@end


@interface HealthRecordCell : BaseHealthRecordCell

- (void)setData:(HealthRecordModel *)model;


@end

@interface HealthRecordPairCell : BaseHealthRecordCell

- (void)setData:(HealthRecordModel *)model;


@end


@interface  HealthRecordTextCell : BaseHealthRecordCell

- (void)setData:(HealthRecordModel *)model;


@end


@interface HealthRecordDiseaseCell : BaseHealthRecordCell

- (void)setData:(HealthRecordModel *)model;

@end

