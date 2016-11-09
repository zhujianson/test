//
//  Created by Dmitry Ivanenko on 14.04.14.
//  Copyright (c) 2014 Dmitry Ivanenko. All rights reserved.
//

#import "DIDatepicker.h"


const CGFloat kDIDatepickerSpaceBetweenItems = 2.5;


@interface DIDatepicker ()
{
    DIDatepickerDateView *selDateView;
    NSMutableArray *m_arrayView;
    UIScrollView *datesScrollView;
    
    NSMutableArray *dates;
    
    NSCalendar *m_calendar;
}


@end


@implementation DIDatepicker

- (id)initWithFrame:(CGRect)frame froViewCon:(UIViewController*)vc
{
    self = [super initWithFrame:frame];
    if (self)
    {
        m_arrayView = [[NSMutableArray alloc] init];
        datesScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        datesScrollView.showsHorizontalScrollIndicator = NO;
        datesScrollView.autoresizingMask = self.autoresizingMask;
        [self addSubview:datesScrollView];
        
        dates = [[NSMutableArray alloc] init];
        
        m_calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [m_calendar setLocale:[NSLocale currentLocale]];
        [m_calendar setFirstWeekday:1];
        
//        UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
//        leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
//        [vc.view addGestureRecognizer:leftSwipeGestureRecognizer];
//        [leftSwipeGestureRecognizer release];
//        
//        UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
//        rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
//        [vc.view addGestureRecognizer:rightSwipeGestureRecognizer];
//        [rightSwipeGestureRecognizer release];
    }
    
    return self;
}

- (void)dealloc
{
    [datesScrollView release];
    [dates release];
    [m_arrayView release];
    
    if (_selectedDate) {
        [_selectedDate release];
        _selectedDate = nil;
    }
    
    [super dealloc];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    int index = [CommonDate getMonthDay:self.selectedDate]-1;
    DIDatepickerDateView *dateV;
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"left");
        
        index++;
        if (index >= dates.count) {
            
            NSDate *date = [self getPriousorLaterDateFromDate:self.selectedDate withMonth:1];
            [self fillCurrentMonth:date];
            index = 0;
            [self selectDate:[dates objectAtIndex:0]];
            
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
        else {
            
            dateV = [m_arrayView objectAtIndex:index];
            if (!dateV.userInteractionEnabled || dateV.hidden) {
                index--;
            }
        }
    }
    else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"right");
        index--;
        if (index < 0) {
            NSDate *date = [self getPriousorLaterDateFromDate:self.selectedDate withMonth:-1];
            [self fillCurrentMonth:date];
            index = (int)dates.count-1;
            [self selectDate:[dates objectAtIndex:index]];
            
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
    dateV = [m_arrayView objectAtIndex:index];
    
    [dateV setHighlighted1:YES];
    
    [self updateSelectedDate:dateV];
}

//获取一个月后的日期
- (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    [comps release];
    [calender release];
    
    return mDate;
}

#pragma mark Setters | Getters

- (void)setSelectedDate:(NSDate *)selectedDate
{
    if (_selectedDate) {
        [_selectedDate release];
        _selectedDate = nil;
    }
    _selectedDate = [selectedDate retain];
    
    [self updateSelectedDatePosition];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark Public methods

- (NSRange)numberOfDayInMonthContainingDate:(NSDate *)date {
    return [m_calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
}

- (void)fillCurrentMonth:(NSDate*)date
{
    NSDateComponents *todayComponents = [m_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    
    NSRange days = [self numberOfDayInMonthContainingDate:date];
    
    [dates removeAllObjects];
    
    for (NSInteger day = days.location; day <= days.length; day++) {
        [todayComponents setDay:day];
		NSDate *date2 = [m_calendar dateFromComponents:todayComponents];
		NSLog(@"%@", date2);
        [dates addObject:date2];
    }

    [self updateDatesView];
}

- (void)selectDate:(NSDate *)date
{
    NSLog(@"date:%@",date);
    self.selectedDate = date;
    NSLog(@"self.selectedDate:%@",self.selectedDate);

    DIDatepickerDateView *dateView;
    int tag;
    for (NSDate *date in dates) {
        NSLog(@"----date:%@",date);
        tag = [CommonDate getMonthDay:date]+100;
        dateView = (DIDatepickerDateView*)[self viewWithTag:tag];
        BOOL isSel = [DIDatepicker isTheSameData:date :self.selectedDate];
        [dateView setHighlighted1:isSel];
        if (isSel) {
//            [self updateSelectedDate:dateView];
            selDateView = dateView;
//            [self updateSelectedDatePosition];
//            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

- (void)updateDatesView
{
    CGFloat currentItemXPosition = kDIDatepickerSpaceBetweenItems;
    
//    int days;
//    if ([Common getMonth:_selectedDate] >= [Common getMonth:[NSDate date]]) {
//        days = [Common getMonthDay:[NSDate date]];
//    }

    int tag;
    DIDatepickerDateView *dateView;
    for (NSDate *date in dates) {
        tag = [CommonDate getMonthDay:date]+100;
        dateView = (DIDatepickerDateView*)[self viewWithTag:tag];
        if (!dateView)
        {
            dateView = [[DIDatepickerDateView alloc] initWithFrame:CGRectMake(currentItemXPosition, 0, kDIDatepickerItemWidth, self.frame.size.height)];
            dateView.tag = tag;
            [dateView addTarget:self action:@selector(updateSelectedDate:) forControlEvents:UIControlEventValueChanged];
            [m_arrayView addObject:dateView];
            [dateView release];
            [datesScrollView addSubview:dateView];
            [dateView release];
        }
        dateView.date = date;
        dateView.hidden = NO;        

        currentItemXPosition += kDIDatepickerItemWidth + kDIDatepickerSpaceBetweenItems;
    }
    datesScrollView.contentSize = CGSizeMake(currentItemXPosition, self.frame.size.height);
    
    int num = (int)m_arrayView.count - (int)dates.count;
    if (num > 0) {
        UIControl *view;
        for (int i = (int)dates.count; i < m_arrayView.count; i++) {
            view = [m_arrayView objectAtIndex:i];
            view.hidden = YES;
        }
    }
}

- (void)setShowDataDian:(NSArray*)array
{
	int tag;
	DIDatepickerDateView *dateView;
	for (NSDate *date in dates) {
		tag = [CommonDate getMonthDay:date]+100;
		dateView = (DIDatepickerDateView*)[self viewWithTag:tag];
		[dateView setIs_show:[[array objectAtIndex:tag-101] intValue]];
		NSLog(@"index ========= %d =========%d", tag, [[array objectAtIndex:tag-100] intValue]);
	}
}

- (void)updateSelectedDate:(DIDatepickerDateView *)dateView
{
    if (![DIDatepicker isTheSameData:_selectedDate :dateView.date])
    {
        [selDateView setHighlighted1:NO];
        
        selDateView = dateView;
        
        self.selectedDate = dateView.date;
    }
}

- (void)updateSelectedDatePosition
{
    NSUInteger itemIndex = [CommonDate getMonthDay:self.selectedDate]-1;

    CGSize itemSize = CGSizeMake(kDIDatepickerItemWidth + kDIDatepickerSpaceBetweenItems, self.frame.size.height);
    CGFloat itemOffset = itemSize.width * itemIndex - (self.frame.size.width - (kDIDatepickerItemWidth + 2 * kDIDatepickerSpaceBetweenItems)) / 2;

    itemOffset = MAX(0, MIN(datesScrollView.contentSize.width - (self.frame.size.width ), itemOffset));

    [datesScrollView setContentOffset:CGPointMake(itemOffset, 0) animated:YES];
}

+ (BOOL)isTheSameData:(NSDate*)detaildate1 :(NSDate*)detaildate2
{
    if (!detaildate1 || !detaildate2) {
        return NO;
    }
    
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *comps1 = [[[NSDateComponents alloc] init] autorelease];
    NSDateComponents *comps2 = [[[NSDateComponents alloc] init] autorelease];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    comps1 = [calendar components:unitFlags fromDate:detaildate1];
    comps2 = [calendar components:unitFlags fromDate:detaildate2];
	
	if ([comps1 year] == [comps2 year] && [comps1 month] == [comps2 month] && [comps1 day] == [comps2 day]) {
		return YES;
	}else {
		return FALSE;
	}
}

@end
