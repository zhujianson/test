//
//  ImageTableViewCell.h
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-15.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

typedef  void (^ShowDetailBlock)(void);

@interface ImageTableViewCell : UITableViewCell

@property (nonatomic,retain)NSDictionary *imageInfoDic;

@property (nonatomic,copy) ShowDetailBlock showDetailBlock;
@end
