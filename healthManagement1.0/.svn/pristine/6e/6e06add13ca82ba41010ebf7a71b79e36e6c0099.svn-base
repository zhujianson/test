//
//  PanViewRoom.h
//  jiuhaohealth4.2
//
//  Created by wangmin on 15/12/3.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TapCallBackProtocol

- (void)tapPanView;

@end

@interface PanViewRoom : NSObject


@property (nonatomic,assign) id<TapCallBackProtocol> delegate;


- (instancetype)initWithTargetView:(UIView *)view;

/**
 *  停靠处理
 *
 *  @param view
 *  @param viewRect
 *  @param superViewRect
 */
- (void)showAnimation:(UIView *)view viewRect:(CGRect)viewRect superRect:(CGRect)superViewRect;

@end
