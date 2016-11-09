//
//  XHVoiceRecordHUD.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-13.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "KXVoiceRecordHUD.h"

#define kXHVoiceRecordPauseString @"手指上滑，取消发送"
#define kXHVoiceRecordResaueString @"松开手指，取消发送"
#define kXHVoiceRecordShotString @"说话时间太短"

@interface KXVoiceRecordHUD ()

@property (nonatomic, assign) UILabel *remindLabel;
@property (nonatomic, assign) UIImageView *microPhoneImageView; //左边麦克风
@property (nonatomic, assign) UIImageView *cancelRecordImageView; //取消
@property (nonatomic, assign) UIImageView *recordingHUDImageView; //音量
//@property (nonatomic, assign) UIImageView *failureImageView;
@property (nonatomic, assign) UILabel *countdownLabel; //倒计时
@property (nonatomic, assign) UIActivityIndicatorView *waitActivityView;

/**
 *  逐渐消失自身
 *
 *  @param compled 消失完成的回调block
 */
- (void)dismissCompled:(void(^)(BOOL fnished))compled withDelay:(float)af;

/**
 *  配置是否正在录音，需要隐藏和显示某些特殊的控件
 *
 *  @param recording 是否录音中
 */
- (void)configRecoding:(BOOL)recording;

/**
 *  根据语音输入的大小来配置需要显示的HUD图片
 *
 *  @param peakPower 输入音频的声音大小
 */
- (void)configRecordingHUDImageWithPeakPower:(CGFloat)peakPower;

/**
 *  配置默认参数
 */
- (void)setup;

@end

@implementation KXVoiceRecordHUD

- (void)dealloc
{
    self.remindLabel = nil;
    self.microPhoneImageView = nil;
    self.cancelRecordImageView = nil;
    self.recordingHUDImageView = nil;
    
    [super dealloc];
}

- (void)startRecordingHUDAtView:(UIView *)view {
    CGPoint center = CGPointMake(CGRectGetWidth(view.frame) / 2.0, CGRectGetHeight(view.frame) / 2.0);
    self.center = center;
    [view addSubview:self];
//    [self configRecoding:YES];
    [self setWaitRecord];
}

- (void)setWaitRecord
{
    self.microPhoneImageView.hidden = NO;
    self.waitActivityView.hidden = NO;
    self.recordingHUDImageView.hidden = YES;
    self.cancelRecordImageView.hidden = YES;
}

- (void)pauseRecord {
    [self configRecoding:YES];
    self.remindLabel.backgroundColor = [UIColor clearColor];
    self.remindLabel.text = kXHVoiceRecordPauseString;
}

- (void)resaueRecord {
    [self configRecoding:NO];
    self.remindLabel.backgroundColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.630];
    self.remindLabel.text = kXHVoiceRecordResaueString;
}

- (void)stopRecordCompled:(void(^)(BOOL fnished))compled {
    [self dismissCompled:compled withDelay:0];
}

- (void)cancelRecordCompled:(void(^)(BOOL fnished))compled {
    [self dismissCompled:compled withDelay:0];
}

- (void)dismissCompled:(void(^)(BOOL fnished))compled withDelay:(float)af {
    [UIView animateWithDuration:0.3 delay:af options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
        if (compled) {
            compled(finished);
        }
    }];
}

- (void)configRecoding:(BOOL)recording {
    self.microPhoneImageView.hidden = !recording;
    self.recordingHUDImageView.hidden = !recording;
    self.cancelRecordImageView.image = [UIImage imageNamed:@"common.bundle/msg/record/RecordCancel.png"];
    self.cancelRecordImageView.hidden = recording;
}

- (void)configRecordingHUDImageWithPeakPower:(CGFloat)peakPower {
    NSString *imageName = @"common.bundle/msg/record/RecordingSignal00";
    if (peakPower >= 0 && peakPower <= 0.1) {
        imageName = [imageName stringByAppendingString:@"1"];
    } else if (peakPower > 0.1 && peakPower <= 0.2) {
        imageName = [imageName stringByAppendingString:@"2"];
    } else if (peakPower > 0.3 && peakPower <= 0.4) {
        imageName = [imageName stringByAppendingString:@"3"];
    } else if (peakPower > 0.4 && peakPower <= 0.5) {
        imageName = [imageName stringByAppendingString:@"4"];
    } else if (peakPower > 0.5 && peakPower <= 0.6) {
        imageName = [imageName stringByAppendingString:@"5"];
    } else if (peakPower > 0.7 && peakPower <= 0.8) {
        imageName = [imageName stringByAppendingString:@"6"];
    } else if (peakPower > 0.8 && peakPower <= 0.9) {
        imageName = [imageName stringByAppendingString:@"7"];
    } else if (peakPower > 0.9 && peakPower <= 1.0) {
        imageName = [imageName stringByAppendingString:@"8"];
    } else {
        imageName = [imageName stringByAppendingString:@"1"];
    }
    
    self.recordingHUDImageView.image = [UIImage imageNamed:imageName];
}

- (void)setPeakPower:(CGFloat)peakPower
{
    _peakPower = peakPower;
    [self configRecordingHUDImageWithPeakPower:peakPower];
}

- (void)startRecord
{
    [self configRecoding:YES];
    self.waitActivityView.hidden = YES;
}

- (void)showCountdown:(int)time
{
    self.microPhoneImageView.hidden = YES;
    self.recordingHUDImageView.hidden = YES;
    self.cancelRecordImageView.hidden = YES;
    self.waitActivityView.hidden = YES;
    self.remindLabel.hidden = YES;
    
    self.countdownLabel.hidden = NO;
    self.countdownLabel.text = [NSString stringWithFormat:@"%d", time];
}

- (void)showShort:(void(^)(BOOL fnished))compled
{
    [self configRecoding:NO];
    self.cancelRecordImageView.image = [UIImage imageNamed:@"common.bundle/msg/record/MessageTooShort.png"];
    self.remindLabel.text = kXHVoiceRecordShotString;
    [self dismissCompled:compled withDelay:0.4];
//    [UIView animateWithDuration:0.3 delay:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        [super removeFromSuperview];
//        if (compled) {
//            compled(finished);
//        }
//    }];
}

- (void)setup {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    
    if (!_remindLabel) {
        UILabel *remindLabel= [[UILabel alloc] initWithFrame:CGRectMake(9.0, 114.0, 120.0, 21.0)];
        remindLabel.textColor = [UIColor whiteColor];
        remindLabel.font = [UIFont systemFontOfSize:13];
        remindLabel.layer.masksToBounds = YES;
        remindLabel.layer.cornerRadius = 4;
        remindLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        remindLabel.backgroundColor = [UIColor clearColor];
        remindLabel.text = kXHVoiceRecordPauseString;
        remindLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:remindLabel];
        _remindLabel = remindLabel;
    }
    
    //
    if (!_microPhoneImageView) {
        UIImageView *microPhoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(27.0, 8.0, 50.0, 99.0)];
        microPhoneImageView.image = [UIImage imageNamed:@"common.bundle/msg/record/RecordingBkg"];
        microPhoneImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        microPhoneImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:microPhoneImageView];
        _microPhoneImageView = microPhoneImageView;
    }
    
    if (!_recordingHUDImageView) {
        UIImageView *recordHUDImageView = [[UIImageView alloc] initWithFrame:CGRectMake(82.0, 34.0, 18.0, 61.0)];
        recordHUDImageView.image = [UIImage imageNamed:@"common.bundle/msg/record/RecordingSignal001"];
        recordHUDImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        recordHUDImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:recordHUDImageView];
        _recordingHUDImageView = recordHUDImageView;
    }
    
    if (!_cancelRecordImageView) {
        UIImageView *cancelRecordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19.0, 7.0, 100.0, 100.0)];
        cancelRecordImageView.image = [UIImage imageNamed:@"common.bundle/msg/record/RecordCancel"];
        cancelRecordImageView.hidden = YES;
        cancelRecordImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        cancelRecordImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:cancelRecordImageView];
        _cancelRecordImageView = cancelRecordImageView;
    }
    
    if (!_waitActivityView) {
        UIActivityIndicatorView* activi = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(_microPhoneImageView.right+6, 55, 20, 20)];
        activi.tag = tableFooterViewActivityTag;
        [activi startAnimating];
        activi.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        activi.hidden = YES;
        [self addSubview:activi];
        _waitActivityView = activi;
    }
    
    if (!_countdownLabel) {
        UILabel *remindLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        remindLabel.textColor = [UIColor whiteColor];
        remindLabel.font = [UIFont systemFontOfSize:110];
        remindLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        remindLabel.backgroundColor = [UIColor clearColor];
        remindLabel.text = @"10";
        remindLabel.textAlignment = NSTextAlignmentCenter;
        remindLabel.hidden = YES;
        [self addSubview:remindLabel];
        _countdownLabel = remindLabel;
    }
    
//    if (!_failureImageView) {
//        UIImageView *cancelRecordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19.0, 7.0, 100.0, 100.0)];
//        cancelRecordImageView.image = [UIImage imageNamed:@"common.bundle/msg/record/RecordCancel"];
//        cancelRecordImageView.hidden = YES;
//        cancelRecordImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
//        cancelRecordImageView.contentMode = UIViewContentModeScaleToFill;
//        [self addSubview:cancelRecordImageView];
//        _cancelRecordImageView = cancelRecordImageView;
//    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
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
