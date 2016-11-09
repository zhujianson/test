//
//  MessageFaceView.h
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-12.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>
#import "ZBFaceView.h"

@interface emoStruct : NSObject

@property (nonatomic, assign) BOOL m_bigEmo;
@property (nonatomic, assign) BOOL m_smallEmo;

@end

@protocol ZBMessageManagerFaceViewDelegate <NSObject>

- (void)SendTheFaceStr:(NSString *)faceStr isDelete:(BOOL)dele;
- (void)SendBig:(NSString *)big;
- (void)sendMsgChar;

@end

@interface ZBMessageManagerFaceView : UIView<UIScrollViewDelegate,ZBFaceViewDelegate>

@property (nonatomic, assign)id<ZBMessageManagerFaceViewDelegate>delegate;


- (id)initWithFrame:(CGRect)frame withDic:(emoStruct*)dic;

@end
