//
//  GuidePageView.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-9-16.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "GuidePageView.h"

@implementation GuidePageView
{
    UIView* m_view;

}

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithType:(int)type
{
    self = [super init];
    if (self) {
        // Initialization code
        m_view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight+64)];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.6f;
        [m_view addSubview:backView];
        [backView release];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddl)];
        [m_view addGestureRecognizer:tap];
        [tap release];
        
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"common.bundle/guide/guide_Page%d.png",type]];
        
        UIImageView * backImage = [[UIImageView alloc]init];
        
        switch (type) {
            case 1:
                backImage.frame = CGRectMake((kDeviceWidth/4-50)/2, 20, 592/2, 707/2);
                break;
            case 2:
                backImage.frame = CGRectMake(IOS_7?10:5, 20+7, 250, 153);

                break;
            case 3:
                image = [[UIImage imageNamed:[NSString stringWithFormat:@"common.bundle/guide/guide_Page%d.png",type]]stretchableImageWithLeftCapWidth:300
                                        topCapHeight:227.5];
                backImage.frame = CGRectMake(0, 158+20+44+20, kDeviceWidth, 455/2);
                break;
            case 4:
            {
                backImage.frame = CGRectMake(kDeviceWidth-(IOS_7?10:5)-261, 20+7, 261, 168);
                
                UIImageView * back = [[UIImageView alloc]initWithFrame:CGRectMake(0, 248+64, kDeviceWidth, 150)];
                back.image = [[UIImage imageNamed:[NSString stringWithFormat:@"common.bundle/guide/guide_Page%d.png",++type]] stretchableImageWithLeftCapWidth:318 topCapHeight:150];
                [m_view addSubview:back];
                [back release];
            }
                break;
             default:
                break;
        }
        
//        backImage.contentMode = UIViewContentModeTop;
//        backView.clipsToBounds = YES;
        
        backImage.image = image;
        [m_view addSubview:backImage];
        [backImage release];
        [APP_DELEGATE addSubview:m_view];
        [m_view release];

//        [UIView animateWithDuration:0.35 animations:^{
//            m_view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
//        }];
//
//        
    }
    return self;
}

- (void)hiddl
{
    [UIView animateWithDuration:0 animations:^{
        m_view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL f) {
        [m_view removeFromSuperview];
        [self removeFromSuperview];
        [self release];
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
