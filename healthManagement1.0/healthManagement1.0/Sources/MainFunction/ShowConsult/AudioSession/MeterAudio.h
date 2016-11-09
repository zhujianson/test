//
//  MeterAudio.h
//  Hello_qyqx
//
//  Created by 国洪 徐 on 12-11-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeterAudio : NSObject
{
	float	mMinDecibels;
	float	mDecibelResolution;
	float	mScaleFactor;
	float	*mTable;
}
- (float)ValueAt:(float)inDecibels;
double DbToAmp(double inDb);

@end
