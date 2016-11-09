//
//  ChartDataTableViewCell.h
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-25.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartDataTableViewCell : UITableViewCell

@property (nonatomic,assign) CGFloat cellWidth;//cell的宽度
@property (nonatomic,assign) int numberOfOneCell;//一行有几列

@property (nonatomic,assign) int numberOfRowInOneCell;//一个cell有几行

- (void)healthDataView;
- (void)healthStepDataView;
- (void)setkey:(NSString *)key valueArray:(NSArray *)valueArray;

- (void)setBloodPressKey:(NSString *)key valueArray:(NSArray *)valueArray;

- (void)setWeightsKey:(NSString *)key valueArray:(NSArray *)valueArray uid:(NSString *)uid;
- (void)setStepKey:(NSString *)key valueArray:(NSArray *)valueArray;
@end
