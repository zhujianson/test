//
//  SymptomsDiseaseViewController.h
//  jiuhaoHealth2.0
//
//  Created by wangmin on 14-4-20.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
@interface SymptomsDiseaseViewController : CommonViewController

@property (nonatomic,assign)CGFloat allOdds;//所有的权重值总和
@property (nonatomic,retain) NSArray *diseaseArray;//疾病数组
@end
