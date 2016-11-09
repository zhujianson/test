//
//  PhysicalProjectViewController.h
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-5.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "Common.h"

@protocol PhysicalPushDelegate <NSObject>

- (void)pushPhysicalData:(NSString*)physical;

@end

@interface PhysicalProjectViewController
    : CommonViewController 
@property (nonatomic, assign) id<PhysicalPushDelegate> myDelegate;
@property (nonatomic, retain) NSMutableArray* pingyinArrp;
@property (nonatomic, retain) NSMutableArray* nameArr;
@property (nonatomic, retain) NSMutableDictionary* nameIndexesDictionary;
@property (nonatomic, retain) NSMutableDictionary* allDataDictionary;
@property (nonatomic, retain) NSMutableArray* nameIndexesArray;
@property (nonatomic, retain) NSMutableArray* finalArray;
@property (nonatomic, retain) NSMutableDictionary* dataDic;

@end
