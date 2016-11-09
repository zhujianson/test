//
//  PickerImageView.m
//  相机
//
//  Created by 张磊 on 14-11-11.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import "PickerImageView.h"

@interface PickerImageView ()

@property (nonatomic , retain) UIView *maskView;
@property (nonatomic , retain) UIImageView *tickImageView;

@end

@implementation PickerImageView

-(void)dealloc
{
    self.tickImageView = nil;
    self.maskView = nil;
    self.maskViewColor = nil;
    [super dealloc];
}

- (UIView *)maskView{
    if (!_maskView) {
        UIView *maskView = [[UIView alloc] init];
        maskView.frame = self.bounds;
        maskView.backgroundColor = [UIColor whiteColor];
        maskView.alpha = 0.5;
        maskView.hidden = YES;
        [self addSubview:maskView];
        self.maskView = maskView;
        [maskView release];
    }
    return _maskView;
}

- (UIImageView *)tickImageView{
    if (!_tickImageView) {
        UIImageView *tickImageView = [[UIImageView alloc] init];
        tickImageView.frame = CGRectMake(self.bounds.size.width - 22, 0, 22, 22);
        tickImageView.image = [UIImage imageNamed:@"common.bundle/diary/selected_on.png"];
        tickImageView.hidden = YES;
        [self addSubview:tickImageView];
        self.tickImageView = tickImageView;
        [tickImageView release];
    }
    return _tickImageView;
}

- (void)setMaskViewFlag:(BOOL)maskViewFlag{
    _maskViewFlag = maskViewFlag;
    
    self.maskView.hidden = !maskViewFlag;
    self.animationRightTick = maskViewFlag;
}

- (void)setMaskViewColor:(UIColor *)maskViewColor{
    _maskViewColor = maskViewColor;
    
    self.maskView.backgroundColor = maskViewColor;
}

- (void)setMaskViewAlpha:(CGFloat)maskViewAlpha{
    _maskViewAlpha = maskViewAlpha;
    
    self.maskView.alpha = maskViewAlpha;
}

- (void)setAnimationRightTick:(BOOL)animationRightTick{
    _animationRightTick = animationRightTick;
    self.tickImageView.hidden = !animationRightTick;
}
@end
