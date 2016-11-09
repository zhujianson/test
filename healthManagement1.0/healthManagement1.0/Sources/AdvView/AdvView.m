//
//  AdvView.m
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-10-16.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "AdvView.h"

@implementation AdvView
{
    UIWebView *newsWebView;
}

- (id)init
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
        
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"ADVInfo"];
        
        newsWebView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 10, kDeviceWidth-20, kDeviceHeight+44)];
//        newsWebView.center = CGPointMake(kDeviceWidth/2, (kDeviceHeight+64)/2);
        newsWebView.backgroundColor = self.backgroundColor;
        newsWebView.tag = 854;
        newsWebView.layer.cornerRadius = 4;
        newsWebView.clipsToBounds = YES;
        newsWebView.opaque = NO;
        [self addSubview:newsWebView];
        [newsWebView release];
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(newsWebView.width - 40, 0, 40, 40);
        [but setImage:[UIImage imageNamed:@"common.bundle/nav/advertisement_icon_close.png"] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(butEventWebClose) forControlEvents:UIControlEventTouchUpInside];
        [newsWebView addSubview:but];
        
        for (UIView* aView in [newsWebView subviews]) {
            if ([aView isKindOfClass:[UIScrollView class]]) {
                //            [(UIScrollView*)aView setShowsVerticalScrollIndicator:NO]; //右侧的滚动条 （水平的类似）
                for (UIView* shadowView in aView.subviews) {
                    if ([shadowView isKindOfClass:[UIImageView class]]) {
                        shadowView.hidden = YES; //上下滚动出边界时的黑色的图片 也就是拖拽后的上下阴影
                    }
                }
            }
        }
        
        NSString *url = [@"http://admin.kangxun365.com/operation/post/share.jsp?type=adv&id=" stringByAppendingString:[dic objectForKey:@"id"]];
        [newsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        
        newsWebView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:0.2 animations:^{
            newsWebView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL f) {
            [UIView animateWithDuration:0.1 animations:^{
                newsWebView.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }];
    }
    
    return self;
}

- (void)butEventWebClose
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        newsWebView.transform = CGAffineTransformMakeScale(0.4, 0.4);
        newsWebView.alpha = 0;
    } completion:^(BOOL f) {
        [self removeFromSuperview];
    }];
}

@end
