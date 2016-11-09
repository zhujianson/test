//
//  LeftSliderViewController.h
//  healthManagement1.0
//
//  Created by jiuhao-yangshuo on 16/1/15.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "CommonViewController.h"

@interface LeftSliderViewController : CommonViewController

@property (nonatomic, retain) UIView* contentView; // 所有要显示的子控件全添加到这里
@property (nonatomic, assign) BOOL isSidebarShown;

@property (nonatomic,assign) BOOL canSwipe;

- (void)showHideSidebar;

//重新设置
-(void)setUpContentView;

+(LeftSliderViewController *)showLeftSliderViewControllerWithMainViewController:(CommonViewController *)mainViewController;

- (void)panMainDetected:(UIPanGestureRecognizer*)recoginzer;

- (void)panDetected:(UIPanGestureRecognizer *)recoginzer;

- (void)panGestureRecognizerEnble:(BOOL)enble WithMainViewController:(CommonViewController *)mainViewController;
@end
