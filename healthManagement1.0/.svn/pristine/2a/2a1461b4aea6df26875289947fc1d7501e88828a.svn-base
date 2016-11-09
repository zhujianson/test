//
//  Created by Dmitry Ivanenko on 15.04.14.
//  Copyright (c) 2014 Dmitry Ivanenko. All rights reserved.
//

#import "DIDatepickerDateView.h"


const CGFloat kDIDatepickerItemWidth = 44;
//const CGFloat kDIDatepickerSelectionLineWidth = 51.;


@interface DIDatepickerDateView ()
{
    UILabel *m_labWeek;
    UILabel *m_labHao;
	UIView *m_isView;
}

@end


@implementation DIDatepickerDateView
@synthesize is_show;

+ (NSDate *)dateForToday
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
	NSDate *todayDate = [calendar dateFromComponents:components];
	
	return todayDate;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupViews];
    
        m_labWeek = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 24)];
        m_labWeek.backgroundColor = [UIColor clearColor];
        m_labWeek.font = [UIFont systemFontOfSize:12];
        m_labWeek.textAlignment = NSTextAlignmentCenter;
        [self addSubview:m_labWeek];

        m_labHao = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-36)/2, m_labWeek.bottom, 36, 36)];
        m_labHao.backgroundColor = [UIColor clearColor];
        m_labHao.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        m_labHao.layer.borderColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_SHEN].CGColor;
        m_labHao.layer.borderWidth = 0.5;
        m_labHao.layer.cornerRadius = m_labHao.height/2.f;
        m_labHao.lineBreakMode = NSLineBreakByWordWrapping;
        m_labHao.textAlignment = NSTextAlignmentCenter;
//        m_labHao.textColor = [CommonImage colorWithHexString:@""];
        m_labHao.clipsToBounds = YES;
        [self addSubview:m_labHao];
		
		m_isView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width-6)/2, m_labHao.bottom+3, 6, 6)];
		m_isView.layer.cornerRadius = m_isView.width/2.0;
		m_isView.clipsToBounds = YES;
		[self addSubview:m_isView];
		
//		self.backgroundColor = [UIColor redColor];
    }
    
    return self;
}

- (void)dealloc
{
    [m_labWeek release];
    [m_labHao release];
	[m_isView release];
    
    [super dealloc];
}

- (void)setupViews
{
    [self addTarget:self action:@selector(dateWasSelected) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setDate:(NSDate *)date
{
    _date = date;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSInteger day = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date] weekday];
	NSArray *array = [NSArray arrayWithObjects:@"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
    m_labWeek.text = [array objectAtIndex:day-1];

    [dateFormatter setDateFormat:@"d"];
    NSString *dayFormattedString = [dateFormatter stringFromDate:date];
    m_labHao.text = dayFormattedString;
    
    NSString *strColor;
    if ([self isWeekday:date]) {
        strColor = @"999999";
    }
    else {
        strColor = @"333333";
    }
    m_labWeek.textColor = [CommonImage colorWithHexString:strColor];
    
    [dateFormatter release];
}

- (void)setHighlighted1:(BOOL)highlighted
{
    if (highlighted) {
        m_labHao.backgroundColor = [CommonImage colorWithHexString:@"e75441"];
        m_labHao.textColor = [CommonImage colorWithHexString:@"ffffff"];
        m_labHao.layer.borderColor = [CommonImage colorWithHexString:@"e75441"].CGColor;
    } else {
        long selDate = [self.date timeIntervalSince1970]/86400;
        long nowDate = [[DIDatepickerDateView dateForToday] timeIntervalSince1970]/86400;//---转化为天
        
        if (selDate > nowDate) {
            m_labHao.textColor = [CommonImage colorWithHexString:@"999999"];
            m_labHao.backgroundColor = [UIColor clearColor];
            m_labHao.layer.borderColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_SHEN].CGColor;
            self.userInteractionEnabled = NO;
        }else {
            m_labHao.backgroundColor = [UIColor clearColor];
            m_labHao.textColor = [CommonImage colorWithHexString:@"666666"];
            m_labHao.layer.borderColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_SHEN].CGColor;
            self.userInteractionEnabled = YES;
        }
    }
}

- (void)setIs_show:(dian_is_show)isshow
{
	switch (isshow)
	{
		case dian_notShow:
			m_isView.hidden = YES;
			break;
		case dian_show_gray:
			m_isView.hidden = NO;
			m_isView.backgroundColor = [UIColor grayColor];
			break;
		case dian_show_red:
			m_isView.hidden = NO;
			m_isView.backgroundColor = [CommonImage colorWithHexString:@"e65341"];;
			break;
			
		default:
			break;
	}
}

#pragma mark Other methods

- (BOOL)isWeekday:(NSDate *)date
{
    NSInteger day = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date] weekday];

    const NSInteger kSunday = 1;
    const NSInteger kSaturday = 7;

    BOOL isWeekdayResult = day == kSunday || day == kSaturday;

    return isWeekdayResult;
}

- (void)dateWasSelected
{
    [self setHighlighted1:YES];

    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
