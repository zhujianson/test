//
//  KXMoviePlayer.h
//  jiuhaohealth4.2
//
//  Created by jiuhao-yangshuo on 15/11/30.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALMoviePlayerController.h"

typedef enum : NSUInteger {
    KXMoviePlayerTypeWindow,
    KXMoviePlayerTypeViewController
} KXMoviePlayerType;

@interface KXMoviePlayer : NSObject

@property (nonatomic,retain) ALMoviePlayerController *m_moviePlayerView;
@property (nonatomic,assign) KXMoviePlayerType m_KXMoviePlayerType;//播放器类型
@property (nonatomic,assign) CGRect movieViewFrame;
///  播放
///
///  @param playerUrl      地址
///  @param viewController 所在viewController
-(void)loadMoviePlayerInWindowWithUrl:(NSString *)playerUrl;

-(void)loadMoviePlayerWithUrl:(NSString *)playerUrl inParentViewControler:(UIViewController *)viewController;

-(void)loadMoviePlayerWithUrl:(NSString *)playerUrl inParentView:(UIView *)view;

//根据方向重新配置
-(void)configureViewForOrientation:(UIInterfaceOrientation)orientation;

-(void)stopMoviePlayer;//暂停播放

- (void)showStatusBar;//状态栏隐藏/显示

- (void)hideStatusBar;

- (void)movieFinishedCallback:(NSNotification*)aNotification;;

//地下滚动图不滚动
- (void)noEnbleScrollBackView:(UIView *)scrollView;

////设置高度 重新设置
//- (void)setUpMoviePlayerHight:(float)hight;

@end
