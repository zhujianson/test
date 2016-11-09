//
//  AccordingView.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-12-4.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "AccordingView.h"
#import <AVFoundation/AVFoundation.h>
#import "ScoreRewardsViewController.h"
//#import "DefauleViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CoreFoundation/CoreFoundation.h>
#import "WebViewController.h"

@interface AccordingView ()
{
    UIView * m_view;
    UIView * backView;
    CommonNavViewController *m_nav;
}
@end

@implementation AccordingView

- (void)dealloc
{

    [m_view release];
    [backView release];

    [super dealloc];
}

- (id)initWithNumber:(int)num type:(NSString*)typeStr Nav:(CommonNavViewController*)nav
{
    self = [super init];
    if (self) {
        
        //增加积分动画
        //            [[AccordingView alloc]initWithNumber:20 type:@"登录获取积分"];
        float y = 0;
//        @try {
//            m_nav = nav;
//            y = ((DefauleViewController*)nav.m_DefalutViewCon).customBarView.hidden ? 0 : -49;
//        }
//        @catch (NSException *exception) {
//            y = -49;
//            m_nav = nil;
//        }
//        @finally {
//            
//        }
        m_view = [[UIView alloc] initWithFrame:CGRectMake(0, kDeviceHeight+64-(IOS_7?0:20)-50 + y, kDeviceWidth, 50)];
        //        m_view.userInteractionEnabled = NO;
        m_view.backgroundColor = [UIColor clearColor];
        m_view.clipsToBounds = YES;
        
        backView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, kDeviceWidth, 50)];
        //        backView.center = CGPointMake(m_view.width/2, m_view.height/2);
        backView.backgroundColor = [UIColor blackColor];
        //        backView.layer.cornerRadius = 4;
        backView.alpha = 0.6f;
        [m_view addSubview:backView];
    
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePicture:)];
        [backView addGestureRecognizer:tap];
        [tap release];
        
        
        [APP_DELEGATE addSubview:m_view];
    
        UIView * b_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, backView.width, backView.height)];
        b_view.backgroundColor = [UIColor clearColor];
        //        b_view.center = CGPointMake(m_view.width/2, m_view.height/2);
        [backView addSubview:b_view];
        [b_view release];
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(19, (50-28)/2, 33, 28)];
        image.image = [UIImage imageNamed:@"common.bundle/common/tab_supernatant_gold.png"];
        image.contentMode = UIViewContentModeScaleAspectFill;
        [b_view addSubview:image];
        [image release];
        
        
        NSString *strTitle = [NSString stringWithFormat:@"%@", typeStr];
        CGSize size = [strTitle sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(kDeviceWidth-113, 1000) lineBreakMode:NSLineBreakByCharWrapping];
        UILabel * textlab = [Common createLabel:CGRectMake(image.right + 5, 0, size.width, 50) TextColor:@"ffffff" Font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentLeft labTitle:strTitle];
        textlab.numberOfLines = 0;
        [b_view addSubview:textlab];
        
        //＋金钱
        UILabel * lab = [Common createLabel:CGRectMake(textlab.right + 5, 0, 80, 50) TextColor:@"ffa344" Font:[UIFont systemFontOfSize:30] textAlignment:NSTextAlignmentLeft labTitle:[NSString stringWithFormat:@"＋%d",num]];
        [b_view addSubview:lab];
        
        //积分怎么用?
        UILabel * lab1 = [Common createLabel:CGRectMake(kDeviceWidth - 100, 0, 95, 50) TextColor:@"ffa34d" Font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentRight labTitle:@""];
        [b_view addSubview:lab1];
        
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"积分怎么用?   "]];
        NSRange contentRange = {0,[content length]};
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        lab1.attributedText = content;
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector: @selector(stopPlay) userInfo:nil repeats:NO];

        @try {
            [self play_shake_sound_male];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        [UIView animateWithDuration:0.2 animations:^{
            //            if ([m_nav childViewControllers].count == 1) {
            //                backView.transform = CGAffineTransformMakeTranslation(0, -50 - 49);
            //            }
            //            else {
            backView.transform = CGAffineTransformMakeTranslation(0, -50);
            //            }
        } completion:^(BOOL finished) {
        }];
    }
    return self;
}

-(void)play_shake_sound_male
{
    static SystemSoundID shake_sound_male_id = 0;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"common.bundle/mp3/receivegold" ofType:@"mp3"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
        //        AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
    }
    AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}

- (void)takePicture:(UITapGestureRecognizer*)tap
{
    WebViewController *help = [[WebViewController alloc] init];
//    help.isUrl = YES;
    help.m_url = HEALP_SERVER_POINTDES;
    help.title = @"积分说明";
    
//    ScoreRewardsViewController *score = [[ScoreRewardsViewController alloc] init];
    if (m_nav) {
        [m_nav.nowViewController.navigationController pushViewController:help animated:YES];
    }
    [help release];
//    [score release];
    [backView removeGestureRecognizer:tap];
}

- (void)stopPlay{
    [UIView animateWithDuration:0.2 animations:^{
//        m_view.alpha = 0;
        backView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [m_view removeFromSuperview];
        [self release];
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
