//
//  RecommendTableViewCell.h
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-15.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface RecommendTableViewCell : UITableViewCell

- (void)setValue:(NSString *)value hasImageView:(BOOL)has imageName:(NSString *)imageName row:(int)row last:(BOOL)last;
@end
