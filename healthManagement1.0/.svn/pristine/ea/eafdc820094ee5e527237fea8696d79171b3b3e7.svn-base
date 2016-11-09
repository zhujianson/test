//
//  AudioSession.h
//  Hello_qyqx
//
//  Created by 国洪 徐 on 12-11-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AVFoundation/AVFoundation.h>

@protocol MyAudioRecorderDelegate <NSObject>
@optional
- (void)setAudioChange:(double)value;
- (BOOL)playEndCallback:(NSMutableDictionary*)row;

- (void)playTime:(int)time;

- (void)recorderEnd;

@end

//typedef void(^XHRecordProgress)(float progress);

@interface AudioSession : NSObject <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
	AVAudioRecorder * m_recorder;
	AVAudioSession *m_session;
	
	NSMutableDictionary *m_settings;
    
//    NSString *m_rootFilePath;    
    NSString *m_audioName;
    
	NSTimer *m_timer;
	AVAudioPlayer *m_player;
}
@property (nonatomic, assign) id <MyAudioRecorderDelegate> delegate;

@property (nonatomic, retain) AVAudioSession *m_session;
@property (nonatomic, retain) AVAudioRecorder *m_recorder;

@property (nonatomic, assign) NSString *m_audioName;

@property (nonatomic, assign) NSMutableDictionary *m_nowDic;

@property (nonatomic) float maxRecordTime; // 默认 60秒为最大
@property (nonatomic, readonly) NSTimeInterval currentTimeInterval;


- (BOOL)startAudioSession;

- (BOOL)record;
//- (NSData*)stopRecording;
- (NSData*)stopRecording:(BOOL)isSave;

- (void)playAudio:(NSMutableDictionary*)dic;

- (void)stopPlayAudio;

@end
