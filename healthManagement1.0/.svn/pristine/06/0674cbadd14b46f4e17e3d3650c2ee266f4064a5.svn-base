//
//  RuningInBackground.h
//  jiuhaohealth3.0
//
//  Created by wangmin on 15-4-15.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface RuningInBackground : NSObject <AVAudioPlayerDelegate>
{
    __block UIBackgroundTaskIdentifier bgTask;
    __block dispatch_block_t expirationHandler;
    __block NSTimer * timer;
    __block AVAudioPlayer *player;
    
}
-(void) startBackgroundTasks;
-(void) stopBackgroundTask;

@end
