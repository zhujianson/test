//
//  PanViewRoom.m
//  jiuhaohealth4.2
//
//  Created by wangmin on 15/12/3.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "PanViewRoom.h"

@implementation PanViewRoom
{
    
    UIView *targetView;
}

- (instancetype)initWithTargetView:(UIView *)view
{
    self = [super init];
    if(self){
    
        targetView = view;
        
        UIImage *image = [UIImage imageNamed:@"common.bundle/common/flowManager.png"];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(targetView.bounds.size.width-image.size.width, kDeviceHeight-image.size.height-49, image.size.width, image.size.height)];
        imageView.image = image;
        [targetView addSubview:imageView];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFunc:)];
        [imageView addGestureRecognizer:panGesture];
        imageView.userInteractionEnabled = YES;

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendPostFunc:)];
        [imageView addGestureRecognizer:tapGesture];
    }
    
    return self;
    
}

/**
 *  发帖按钮动
 *
 *  @param recognizer
 */
- (void)panFunc:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:targetView];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:targetView];
    
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        [self showAnimation:recognizer.view viewRect:recognizer.view.frame superRect:recognizer.view.superview.frame];
        
    }
    
}

- (void)sendPostFunc:(UIPanGestureRecognizer *)recognizer
{

        [self.delegate tapPanView];
}


- (void)showAnimation:(UIView *)view viewRect:(CGRect)viewRect superRect:(CGRect)superViewRect
{
    CGFloat halfWidth = CGRectGetWidth(superViewRect)/2.0f;
    CGFloat quarteredHeight = CGRectGetHeight(superViewRect)/8.0f;
    CGFloat bottomQuarteredHeight = CGRectGetHeight(superViewRect)- 49 - quarteredHeight;
    
    CGFloat curentX = CGRectGetMidX(viewRect);
    CGFloat currentY = CGRectGetMidY(viewRect);
    CGFloat centerX = CGRectGetWidth(viewRect)/2.0f;
    CGFloat centerY = CGRectGetHeight(viewRect)/2.0f;
    CGFloat bottomCenterY = CGRectGetHeight(superViewRect)-centerY;
    
    
    [UIView animateWithDuration:0.05 animations:^{
        
        if(curentX <= halfWidth && (currentY > quarteredHeight && currentY <= bottomQuarteredHeight)){
            //靠左
            view.center = CGPointMake(centerX, view.center.y);
            
        }else if(curentX <= halfWidth && currentY <= quarteredHeight){
            //靠左上
            if(view.center.x < centerX){
                 view.center = CGPointMake(centerX, centerY);
            }else{
               view.center = CGPointMake(view.center.x, centerY);
            }
           
            
        }else if(curentX <= halfWidth && currentY > bottomQuarteredHeight){
            //靠左下
            
            if(view.center.x < centerX){
                view.center = CGPointMake(centerX, bottomCenterY-49);
            }else{
                view.center = CGPointMake(view.center.x, bottomCenterY-49);
            }
            
            
        }else  if(curentX > halfWidth && (currentY > quarteredHeight && currentY <= bottomQuarteredHeight)){
            //靠右
            view.center = CGPointMake(CGRectGetWidth(superViewRect) - centerX, view.center.y);
            
        }else if(curentX > halfWidth && currentY <= quarteredHeight){
            //靠右上
            if(view.center.x > CGRectGetWidth(superViewRect)- centerX){
              view.center = CGPointMake(CGRectGetWidth(superViewRect)- centerX, centerY);
            }else{
              view.center =  CGPointMake(view.center.x, centerY);
            }
           
            
        }else if(curentX > halfWidth && currentY > bottomQuarteredHeight){
            //靠右下
            if(view.center.x > CGRectGetWidth(superViewRect)- centerX){
                view.center = CGPointMake(CGRectGetWidth(superViewRect) - centerX, bottomCenterY-49);
            }else{
                view.center =  CGPointMake(view.center.x, bottomCenterY-49);
            }

        }
        
    }];
    
    
}

@end
