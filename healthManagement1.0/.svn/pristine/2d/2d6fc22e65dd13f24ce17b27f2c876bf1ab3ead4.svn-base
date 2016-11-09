//
//  AudioInputView.h
//  jiuhaohealth3.0
//
//  Created by 徐国洪 on 15-1-20.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AudioInputViewOK)(int type, int lenght);

//@protocol AudioInputViewDelegate <NSObject>
//@optional
//- (void)startRecordView;
//- (void)stopRecordView;
//@end


@interface AudioInputView : UIView
{
    AudioInputViewOK AudioInputBlock;
    UIView *m_view;
}

@property (nonatomic, assign) int nowVolume;
//@property (nonatomic, assign) id<AudioInputViewDelegate> delegaet;

- (void)setAudioInputViewOKBlock:(AudioInputViewOK)_handler;

- (void)butEvent:(UIButton*)but;

- (void)removeView;

- (void)showWithAlpha:(UIView*)superView;

- (void)hideView;

@end
