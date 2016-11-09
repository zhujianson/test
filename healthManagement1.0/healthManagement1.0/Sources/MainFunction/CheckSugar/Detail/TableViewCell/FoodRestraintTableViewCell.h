//
//  FoodRestraintTableViewCell.h
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-21.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface FoodRestraintTableViewCell : UITableViewCell


- (void)setDataKey:(NSString *)key Value:(NSString *)value Index:(int)row lastRow:(BOOL)lastRow hasSmall:(BOOL)yes specialKey:(NSString *)specialKey;

- (void)description;
@end
