//
//  MulticolorView.h
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-9-27.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MulticolorView : UIView

@property (nonatomic, assign) CGFloat          lineWidth;  // 圆的线宽
@property (nonatomic, assign) CFTimeInterval   sec;        // 秒
@property (nonatomic, assign) CGFloat          percent;    // 百分比

@property (nonatomic, strong) NSArray         *colors;     // 颜色组(CGColor)

- (void)startAnimation;
- (void)endAnimation;
- (void)setupMulticolor;

@end
