//
//  SelectedView.h
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-24.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBlock) (int index);


//两种风格一种为segment 一种为独立的小块
typedef NS_ENUM(NSInteger, FaceStyle) {
    SegmentStyle = 0,
    SingleStyle = 1
};


@interface SelectedView : UIView

- (void)initwithArray:(NSArray *)array;

@property (nonatomic,copy) SelectedBlock selectedBtnBlock;

@property (nonatomic,assign) FaceStyle theStyle;
@property (nonatomic,assign) CGFloat offsetX;

@property (nonatomic,assign) BOOL isSteperView;

@property (nonatomic,assign) CGFloat spaceWidth;

- (void)justShowSelectedViewAtIndex:(int)index;

- (void)setChooseView;
@end
