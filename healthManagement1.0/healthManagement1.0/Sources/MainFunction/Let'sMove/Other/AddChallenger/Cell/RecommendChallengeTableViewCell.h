//
//  RecommendTableViewCell.h
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-9-29.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendChallengeTableViewCell : UITableViewCell

@property (nonatomic,retain) NSDictionary *dataDic;
@property (nonatomic,retain) UIImageView *selectedImageView;//选中的view

@property (nonatomic,assign) BOOL  isSelectedFlag;//是否被选中

- (void)setIconImage:(UIImage*)image;

@end
