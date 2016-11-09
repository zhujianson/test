//
//  MeterAudio.m
//  Hello_qyqx
//
//  Created by 国洪 徐 on 12-11-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MeterAudio.h"

@implementation MeterAudio

double DbToAmp(double inDb)
{
	return pow(10., 0.05 * inDb);
}

- (id)init
{
	[super init];
	
	mMinDecibels = -80.;
	mDecibelResolution = mMinDecibels / (400 - 1);
	mScaleFactor = (1. / mDecibelResolution);
	
	mTable = (float*)malloc(400*sizeof(float));
	
	double minAmp = DbToAmp(mMinDecibels);
	double ampRange = 1. - minAmp;
	double invAmpRange = 1. / ampRange;
	
	double rroot = 1. / 2.0;
	for (size_t i = 0; i < 400; ++i) {
		double decibels = i * mDecibelResolution;
		double amp = DbToAmp(decibels);
		double adjAmp = (amp - minAmp) * invAmpRange;
		mTable[i] = pow(adjAmp, rroot);
	}
	
	return self;
}

- (float)ValueAt:(float)inDecibels
{
	if (inDecibels < mMinDecibels) return  0.;
	if (inDecibels >= 6.) return 1.;
	int index = (int)(inDecibels * mScaleFactor);
	return mTable[index];
}

- (void)dealloc
{
	free(mTable);
	[super dealloc];
}

@end
