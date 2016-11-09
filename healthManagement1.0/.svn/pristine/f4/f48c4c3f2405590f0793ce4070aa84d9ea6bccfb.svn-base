//
//  AudioInputView.m
//  jiuhaohealth3.0
//
//  Created by 徐国洪 on 15-1-20.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "AudioInputView.h"

@implementation AudioInputView
{
//    UIView* m_view;
    NSTimer *m_timer;
    
    int m_registerTimeLen;
    
    BOOL m_DwonSpeck;
}

//@synthesize delegaet;

- (void)dealloc
{
//    [m_view release];
    AudioInputBlock = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, kDeviceHeight, kDeviceWidth, 216)];
    if (self) {

//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kDeviceHeight, kDeviceWidth, 216)];
        self.backgroundColor = [CommonImage colorWithHexString:@"fafafa"];
        
        UILabel *latTitle = [Common createLabel];
        latTitle.tag = 50;
        latTitle.frame = CGRectMake(0, 0, self.width, 30);
        latTitle.text = @"按住说话";
        latTitle.font = [UIFont systemFontOfSize:14];
        latTitle.textAlignment = NSTextAlignmentCenter;
        latTitle.textColor = [CommonImage colorWithHexString:@"999999"];
        [self addSubview:latTitle];
        [latTitle release];
        
        //用时
        UILabel *labTitle = [Common createLabel];
        labTitle.tag = 51;
        labTitle.frame = CGRectMake(20, 10, 100, 30);
        labTitle.font = [UIFont systemFontOfSize:25];
        labTitle.textColor = [CommonImage colorWithHexString:@"999999"];
        labTitle.text = @"00:00";
        [self addSubview:labTitle];
        [labTitle release];
        
        
        UIImageView *butColse = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180, 180)];
        butColse.userInteractionEnabled = YES;
        butColse.center = CGPointMake(self.width/2, self.height/2);
        butColse.contentMode = UIViewContentModeCenter;
        butColse.image = [UIImage imageNamed:@"common.bundle/msg/voice_normal.png"];
        butColse.tag = 100;
        butColse.animationDuration = 1.2;
        butColse.animationRepeatCount = 0;
        NSArray *array = [NSArray arrayWithObjects:[UIImage imageNamed:@"common.bundle/msg/voice_pressed.png"], [UIImage imageNamed:@"common.bundle/msg/voice_pressed01.png"], [UIImage imageNamed:@"common.bundle/msg/voice_pressed02.png"], nil];
        butColse.animationImages = array;
        //    [butColse setImage:[UIImage imageNamed:@"common.bundle/msg/shuhua.png"] forState:UIControlStateNormal];
        //    [butColse setImage:[UIImage imageNamed:@"common.bundle/msg/shuhua_p.png"] forState:UIControlStateHighlighted];
        [self addSubview:butColse];
    }
    return self;
}

- (void)setAudioInputViewOKBlock:(AudioInputViewOK)bl
{
    AudioInputBlock = [bl copy];
}

- (void)showWithAlpha:(UIView*)view
{
    m_view = view;
    [m_view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^ {
        self.transform = CGAffineTransformMakeTranslation(0, -self.height);
    }];
}

- (void)hideView
{
    [UIView animateWithDuration:0.3 animations:^ {
        self.transform = CGAffineTransformIdentity;
//        m_view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL is) {
        [self removeFromSuperview];
    }];
}

- (UIView*)createTitle
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
    view.tag = 40;
    view.backgroundColor = [CommonImage colorWithHexString:@"ffd145" alpha:0.9];
    
    UILabel *labTitle = [Common createLabel];
    labTitle.textAlignment = NSTextAlignmentCenter;
    labTitle.frame = CGRectMake(0 , 0, view.width, view.height);
    labTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
    labTitle.textColor = [CommonImage colorWithHexString:@"ffffff"];
    labTitle.text = @"松开手指，取消发送";
    [view addSubview:labTitle];
    [labTitle release];
    
    return view;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIImageView *view = (UIImageView*)[[touches anyObject] view];
    if (view.tag == 100) {
        [view startAnimating];
        AudioInputBlock(1, 0);
        
        [self butEventDown];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (m_DwonSpeck) {
        UIView *viewR = [m_view viewWithTag:40];
        
        CGPoint point = [[touches anyObject] locationInView:self];
        
        UIImageView *view = (UIImageView*)[self viewWithTag:100];
        BOOL is = CGRectContainsPoint(view.frame, point);
        
        if (!is) {
            if (!viewR) {
                viewR = [self createTitle];
                [m_view addSubview:viewR];
                [viewR release];
            }
            viewR.hidden = NO;
            
        }else {
            if (viewR) {
                viewR.hidden = YES;
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (m_DwonSpeck) {
        
        //
        [self stopRecord];
        
        CGPoint point = [[touches anyObject] locationInView:self];
        
        UIImageView *view = (UIImageView*)[self viewWithTag:100];
        BOOL is = CGRectContainsPoint(view.frame, point);
        
        if (!is) {
            
            AudioInputBlock(0, 0);
        }
        else {
            
            if (m_registerTimeLen < 1) {
                
                MBProgressHUD *progress_ = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.height)];
                progress_.labelText = @"不能发送,时间太短";
                progress_.mode = MBProgressHUDModeText;
                progress_.userInteractionEnabled = NO;
                [[[UIApplication sharedApplication].windows lastObject] addSubview:progress_];
                [progress_ show:YES];
                [progress_ showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                } completionBlock:^{
                    [progress_ release];
                    [progress_ removeFromSuperview];
                }];
                
                AudioInputBlock(0, 0);
                
            } else {
                AudioInputBlock(2, m_registerTimeLen);
            }
        }
        
        m_DwonSpeck = FALSE;
    }
}

- (void)butEventDown
{
    UILabel *latTitle = (UILabel*)[self viewWithTag:50];
    latTitle.text = @"松开发送";
    
    m_DwonSpeck = TRUE;
    m_registerTimeLen = 0;
    m_timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
}

//录音计时
- (void)updateMeters
{
    m_registerTimeLen++;
    
    UILabel *labTitle = (UILabel*)[self viewWithTag:51];
    
    NSString *textColor = @"999999";
    NSString *title = [NSString stringWithFormat:@"00:0%d", m_registerTimeLen];
    
    if (m_registerTimeLen >= 60) {
        title = @"01:00";
        AudioInputBlock(2, 60);
        [self stopRecord];
        
        return;
    }
    else if (m_registerTimeLen >= 50) {
        
        textColor = @"ff0000";
        title = [NSString stringWithFormat:@"%d", 60 - m_registerTimeLen];
    }
    else if (m_registerTimeLen >= 10) {
        title = [NSString stringWithFormat:@"00:%d", m_registerTimeLen];
    }
    
    labTitle.text = title;
    labTitle.textColor = [CommonImage colorWithHexString:textColor];
}

- (void)stopRecord
{
    m_DwonSpeck = FALSE;
    
    UIImageView *view = (UIImageView*)[self viewWithTag:100];
    [view stopAnimating];
    
    UIView *viewR = [m_view viewWithTag:40];
    if (viewR) {
        viewR.hidden = YES;
    }
    
    UILabel *labTitle = (UILabel*)[self viewWithTag:51];
    labTitle.text = @"00:00";
    labTitle.textColor = [CommonImage colorWithHexString:@"999999"];
    
    //
    UILabel *latTitle = (UILabel*)[self viewWithTag:50];
    latTitle.text = @"按住说话";
    
    [m_timer invalidate];
}

- (void)removeView
{
    UIButton *butOK = (UIButton*)[self viewWithTag:101];
    [self butEvent:butOK];
}


@end
