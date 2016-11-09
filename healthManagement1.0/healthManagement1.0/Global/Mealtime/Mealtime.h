//
//  Mealtime.h
//  jiuhaohealth4.0
//
//  Created by 徐国洪 on 15-6-25.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    allMealtime,
    todayMealtime,
    nowMealtimeConf
} MealtimeType;

typedef void (^MealtimeBlock)(id);

@interface Mealtime : NSObject
{
    NSMutableArray *m_array;
    id m_vc;
    MealtimeType mealtimeType;
}

@property (nonatomic, copy) MealtimeBlock mealtimeBlock;
//@property (nonatomic, assign) MealtimeType mealtimeType;


- (id)initWithBlock:(MealtimeBlock)Mblock withType:(MealtimeType)type withView:(id)view;

- (void)writerMealtime:(NSMutableArray*)array;

@end
