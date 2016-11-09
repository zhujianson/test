//
//  ShowText.m
//  jiuhaohealth4.0
//
//  Created by 徐国洪 on 15-6-10.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "ShowText.h"
#import "MLEmojiLabel.h"
#import "MobClick.h"

@implementation ShowText
{
    MLEmojiLabel *m_emoLabel;
    
    BOOL m_statusBarHiddenInited;
}
@synthesize m_title;

+ (ShowText*)showText
{
    ShowText *show = [[ShowText alloc] init];
    return show;
}

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight+64)];
    if (self) {
        [MobClick event:[NSString stringWithFormat:@"_%d", 407]];
        m_statusBarHiddenInited = [UIApplication sharedApplication].isStatusBarHidden;
        // 隐藏状态栏
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0;
        
        // 监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleTap];
        [singleTap release];
    }
    return self;
}

- (void)show
{
    MLEmojiLabel *emojiLabel = [[MLEmojiLabel alloc] initWithFrame:CGRectMake(20, 0, kDeviceWidth-40, 30)];
    emojiLabel.numberOfLines = 0;
    emojiLabel.font = [UIFont systemFontOfSize:26.0f];
    emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    emojiLabel.textColor = [CommonImage colorWithHexString:@"333333"];
    emojiLabel.isNeedAtAndPoundSign = YES;
    emojiLabel.disableThreeCommon = YES;
    emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    emojiLabel.customEmojiPlistName = @"expression.plist";
    emojiLabel.emojiText = m_title;
    [self addSubview:emojiLabel];
    [emojiLabel sizeToFit];
    emojiLabel.center = CGPointMake(kDeviceWidth/2.f, kDeviceHeight/2.f-20);
    [emojiLabel release];
    
    UIWindow *window = APP_DELEGATE;
    [window addSubview:self];
    [self release];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)butEventClose
{
    [self hide];
}

#pragma mark - 手势处理
- (void)handleSingleTap:(UITapGestureRecognizer *)tap
{
    [self hide];
}

- (void)hide
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
//        [UIApplication sharedApplication].statusBarHidden = m_statusBarHiddenInited;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dealloc
{
    [super dealloc];
}

@end
