//
//  VRGCalendarView.h
//  Vurig
//
//  Created by in 't Veen Tjeerd on 5/8/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UIColor+expanded.h"

#define kVRGCalendarViewTopBarHeight 50
#define kVRGCalendarViewWeekHeight 30

#define kVRGCalendarViewWidth [UIScreen mainScreen].bounds.size.width

#define kVRGCalendarViewDayWidth ([UIScreen mainScreen].bounds.size.width/7.0)
//宽高比例 280/320
#define kVRGCalendarViewDayHeight (([UIScreen mainScreen].bounds.size.width/7.0) *(280/320.0))

@protocol VRGCalendarViewDelegate;
@interface VRGCalendarView : UIView {
    
    NSDate *currentMonth;
    
    UIButton *labelToday;
    
    BOOL isAnimating;
    BOOL prepAnimationPreviousMonth;
    BOOL prepAnimationNextMonth;
    
    UIImageView *animationView_A;
    UIImageView *animationView_B;
    
    NSArray *markedDates;
    NSArray *markedColors;
}

@property (nonatomic, assign) id <VRGCalendarViewDelegate> delegate;
@property (nonatomic, strong) NSDate *currentMonth;
@property (nonatomic, strong) UIButton *labelToday;
@property (nonatomic, strong) UIButton *leftButton;//左边
@property (nonatomic, strong) UIButton *rightButton;//右边

@property (nonatomic, getter = calendarHeight) float calendarHeight;
@property (nonatomic, strong, getter = selectedDate) NSDate *selectedDate;

@property (nonatomic, strong) NSArray *m_array;

-(void)selectDate:(int)date;
-(void)reset;

-(void)markDates:(NSArray *)dates;
-(void)markDates:(NSArray *)dates withColors:(NSArray *)colors;

-(void)showNextMonth;
-(void)showPreviousMonth;

-(int)numRows;
-(void)updateSize;
-(UIImage *)drawCurrentState;

-(float)calendarHeight;

@end

@protocol VRGCalendarViewDelegate <NSObject>
-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(NSDate *)month targetHeight:(float)targetHeight animated:(BOOL)animated;
-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date;
@end
