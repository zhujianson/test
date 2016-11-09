//
//  UserPhotoView.h
//  jiuhaohealth3.0
//
//  Created by wangmin on 15-1-27.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OnClickEvent)(void);

@interface UserPhotoView : UIView

//点击头像回调事件
@property (nonatomic,copy) OnClickEvent onClickViewEvent;

//传入CGRectZero 则不显示改元素  参考 frame CGRectMake(0, 0, 70, 70); sexBounds vBounds CGRectMake(0, 0, 20, 20)
- (instancetype)initWithFrame:(CGRect)frame withSexImageBounds:(CGRect)sexBounds andVImageBounds:(CGRect)vBounds;

//设置图片 不需要传nil
- (void)setImageURLString:(NSString *)urlString sexImageName:(NSString *)sexString andVImageName:(NSString *)vString;

@end
