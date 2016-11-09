//
//  YRilView.m
//  jiuhaohealth3.0
//
//  Created by jiuhao-yangshuo on 15-1-12.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "YRilView.h"
#import "VRGCalendarView.h"

@interface YRilView ()<VRGCalendarViewDelegate>

@end

@implementation YRilView
{
     YRilViewBlock _inBlock;
     UIView* m_view;
    VRGCalendarView *calendar;
     BOOL showing;
}
@synthesize selectedDate,m_view;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        m_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        m_view.backgroundColor = [UIColor clearColor];
        [self addSubview:m_view];
    
        calendar = [[VRGCalendarView alloc] init];
        calendar.delegate = self;
        [self addSubview:calendar];

        selectedDate = [NSDate date];
    }
    return self;
}

//防止第一次 出先选中对应的日期 界面移除
- (void)selectDate:(NSDate *)date 
{
    showing = YES;
    calendar.currentMonth = date;
    NSCalendar *myCalendar = [NSCalendar currentCalendar];
    int count = (int)[myCalendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    [calendar performSelector:@selector(updateSize) withObject:nil afterDelay:0.1];
    [calendar selectDate:count];
}
- (void)dealloc
{
    _inBlock = nil;
    calendar.delegate = nil;
    [calendar release];
    [m_view release];
    [super dealloc];
}

-(void)setYRilViewBlockBlock:(YRilViewBlock)handler
{
    [self showAnimation];
     _inBlock = [handler copy];
}

- (void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(NSDate *)month targetHeight:(float)targetHeight animated:(BOOL)animated
{
    selectedDate = month;
    NSLog(@"Selected date = %@",month);
     _inBlock(month,NO);
}

#pragma mark calendarViewDeleate
- (void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    NSLog(@"Selected date = %@",date);
    if (showing)
    {
        showing = NO;
    }
    else
    {
        _inBlock(date,YES);
        selectedDate = date;
        [self removeView];
    }
}

-(void)showAnimation
{
    float y =  calendar.calendarHeight;
    calendar.frame  =[Common rectWithOrigin:calendar.frame x:0 y:-y];
    
    [UIView animateWithDuration:0.35 animations:^{
          m_view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
          calendar.frame  =[Common rectWithOrigin:calendar.frame x:0 y:0.1];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)removeView
{
    [UIView animateWithDuration:0.35 animations:^{
        calendar.frame  =[Common rectWithOrigin:calendar.frame x:0 y:-calendar.height];
        m_view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [m_view removeFromSuperview];
        m_view = nil;
        [self removeFromSuperview];
    }];
}

-(void)updateRillViewWithArray:(NSArray *)array
{
    if (array.count == 0)
    {
        return;
    }
    [calendar setM_array:array];
    [calendar setNeedsDisplay];
}
@end
