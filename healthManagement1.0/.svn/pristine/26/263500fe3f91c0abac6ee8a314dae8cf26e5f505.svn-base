//
//  AudioSession.m
//  Hello_qyqx
//
//  Created by 国洪 徐 on 12-11-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AudioSession.h"
#import "amrFileCodec.h"

#define XMAX	20.0f

@interface AudioSession()
{
    NSTimer *_timer;
}

@property (nonatomic, readwrite) NSTimeInterval currentTimeInterval;

@end

@implementation AudioSession
@synthesize delegate;
@synthesize m_session;
@synthesize m_recorder;
@synthesize m_audioName;
@synthesize m_nowDic;

- (void)dealloc
{
	[m_settings release];
	if (m_player) {
		[m_player stop];
		[m_player release];
    }
    if (m_audioName) {
        [m_audioName release];
        m_audioName = nil;
    }
	
	[super dealloc];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{	
	[m_player release];
	m_player = nil;
	if (delegate) {
		if ([delegate respondsToSelector:@selector(playEndCallback:)]) {
			[delegate playEndCallback:m_nowDic];
		}
	}
}

- (void)playAudio:(NSMutableDictionary*)dic
{
    m_nowDic = dic;
    NSString *path = [m_nowDic objectForKey:@"content"];
	NSError *error;
	if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error])
	{
		NSLog(@"Error: %@", [error localizedDescription]);
	}
	
	if (m_player) {
		if ([m_player isPlaying]) {
			[m_player stop];
		}
		[m_player release];
	}
	NSString *rootFilePath = [Common getAudioPath];

    NSString* strCon = [path stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSData *data = [NSData dataWithContentsOfFile:[rootFilePath stringByAppendingFormat:@"/%@", strCon]];
    
    if (!data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
            if (data) {
                [data writeToFile:[rootFilePath stringByAppendingFormat:@"/%@", strCon] atomically:YES];
                dispatch_async( dispatch_get_main_queue(), ^(void){
                    
                    [self play:data];
                });
            }
            else {
                dispatch_async( dispatch_get_main_queue(), ^(void){
                    
                    [delegate playEndCallback:m_nowDic];
                });
            }
        });
    }
    else {
    
        [self play:data];
    }
}

- (void)play:(NSData*)data
{
    @try {
        
        if (data) {
            
            data = DecodeAMRToWAVE(data);
            m_player = [[AVAudioPlayer alloc] initWithData:data error:nil];
            m_player.delegate = self;
            
            [m_player play];
        }
        else {
            
            [delegate playEndCallback:m_nowDic];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)stopPlayAudio
{
    self.m_nowDic = nil;
	if (m_player) {
		if ([m_player isPlaying]) {
			[m_player stop];
		}
		[m_player release];
		m_player = nil;
        m_nowDic = nil;
	}
}

- (NSData*)stopRecording:(BOOL)isSave
{
	[self.m_recorder stop];
	[self.m_recorder release];
    
//    NSString *strCon1 = [[Common getImagePath] stringByAppendingFormat:@"/%@", strTest];
//    [data writeToFile:strCon1 atomically:YES];
//    [self addMessage:dic];
    
	NSString *rootFilePath = [Common getAudioPath];
	NSString *path = [rootFilePath stringByAppendingFormat:@"/%@.caf", m_audioName];
    NSData* data = EncodeWAVEToAMR([NSData dataWithContentsOfFile:path], 1, 16);
	
	[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
	
    if (isSave) {
        NSString *amrFilePath = [rootFilePath stringByAppendingFormat:@"/%@", m_audioName];
        [data writeToFile:amrFilePath atomically:YES];
    }
	
//	[SQLite insertOneDataFile:nil ISVideoList:NO];

	return data;
}

- (void)removeAudioFile:(NSString*)path
{
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

- (BOOL)record
{
	NSError *error;
	if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error])
	{
	}
	
	[self stopPlayAudio];
	
	// File URL
    NSString *rootFilePath = [Common getAudioPath];
    if (m_audioName) {
        [m_audioName release];
        m_audioName = nil;
    }
    m_audioName = [[NSString stringWithFormat:@"%@_%ld_%d", g_nowUserInfo.userid, [CommonDate getLongTime], arc4random()%1000] retain];
//	m_audioName = [Common getLongTime];
	
	NSURL *url = [NSURL fileURLWithPath:[rootFilePath stringByAppendingFormat:@"/%@.caf",m_audioName]];
//	NSLog(@"%@",m_moreFilePath);
	// Create recorder
	self.m_recorder = [[AVAudioRecorder alloc] initWithURL:url settings:m_settings error:&error];
	if (!self.m_recorder)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return NO;
	}
	
	// Initialize degate, metering, etc.
	self.m_recorder.delegate = self;
	self.m_recorder.meteringEnabled = YES;
	
	if (![self.m_recorder prepareToRecord])
	{
		NSLog(@"Error: Prepare to record failed");
		return NO;
	}
	
	if (![self.m_recorder record])
	{
		NSLog(@"Error: Record failed");
		return NO;
	}
    
    [self resetTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
    
	return YES;
}

- (BOOL)startAudioSession
{
	// Prepare the audio session
	NSError *error;

	self.m_session = [AVAudioSession sharedInstance];
	
	if (![self.m_session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error])
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return NO;
	}
	
	if (![self.m_session setActive:YES error:&error])
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return NO;
	}
	
	// Recording settings
	m_settings = [[NSMutableDictionary alloc] init];
	[m_settings setValue: [NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
	[m_settings setValue: [NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
	[m_settings setValue: [NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey]; // mono
	[m_settings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
	[m_settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
	[m_settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
	return self.m_session.inputAvailable;
}

- (void)resetTimer {
    if (!_timer)
        return;
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)updateMeters
{
    if (!m_recorder)
        return;
    
    WS(weakSelf);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [m_recorder updateMeters];
        
        self.currentTimeInterval = m_recorder.currentTime;
        
        if ([weakSelf.delegate respondsToSelector:@selector(playTime:)]) {
            [weakSelf.delegate playTime:self.currentTimeInterval];
        }
        
        float peakPower = [m_recorder averagePowerForChannel:0];
        double ALPHA = 0.015;
        double peakPowerForChannel = pow(10, (ALPHA * peakPower));
        
        if ([weakSelf.delegate respondsToSelector:@selector(setAudioChange:)]) {
            [weakSelf.delegate setAudioChange:peakPowerForChannel];
        }
        
        if (self.currentTimeInterval > self.maxRecordTime) {
            [self stopRecording:YES];
//            dispatch_async(dispatch_get_main_queue(), ^{
            
                if ([weakSelf.delegate respondsToSelector:@selector(recorderEnd)]) {
                    [weakSelf.delegate recorderEnd];
                }
//            });
        }
    });
}

@end
