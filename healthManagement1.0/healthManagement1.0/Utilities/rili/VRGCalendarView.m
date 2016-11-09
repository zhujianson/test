//
//  VRGCalendarView.m
//  Vurig
//
//  Created by in 't Veen Tjeerd on 5/8/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//

#import "VRGCalendarView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDate+convenience.h"
#import "NSMutableArray+convenience.h"
#import "UIView+convenience.h"
#import "Common.h"
#import "DiaryModelView.h"

static NSString *const kAtferDayColor = @"999999";

@implementation VRGCalendarView
@synthesize currentMonth,delegate,labelToday,leftButton,rightButton;
@synthesize calendarHeight,selectedDate, m_array;

#pragma mark - Select Date
-(void)selectDate:(int)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:1];
    NSDateComponents *comps = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:self.currentMonth];
    [comps setDay:date];
    NSDate *selectDate = [gregorian dateFromComponents:comps];
    [gregorian release];
    
    if ([self decideTheMonthAfterNowDate:selectDate withDaySeleclt:YES])
    {
//        [Common TipDialog:@"不能在未来添加记录!"];
        return;
    }
    self.selectedDate = selectDate;
    int selectedDateYear = [selectedDate year];
    int selectedDateMonth = [selectedDate month];
    int currentMonthYear = [currentMonth year];
    int currentMonthMonth = [currentMonth month];
    
    if (selectedDateYear < currentMonthYear) {
        [self showPreviousMonth];
    } else if (selectedDateYear > currentMonthYear) {
        [self showNextMonth];
    } else if (selectedDateMonth < currentMonthMonth) {
        [self showPreviousMonth];
    } else if (selectedDateMonth > currentMonthMonth) {
        [self showNextMonth];
    } else {
        [self setNeedsDisplay];
    }
    if ([delegate respondsToSelector:@selector(calendarView:dateSelected:)]) [delegate calendarView:self dateSelected:self.selectedDate];
}

//判断时间选择 //年月日 //daySelect 为判断日期 yes 判断月份 no
-(BOOL)decideTheMonthAfterNowDate:(NSDate *)newDate withDaySeleclt:(BOOL)daySelect
{
    NSUInteger unitFlags = daySelect? (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit):(NSYearCalendarUnit | NSMonthCalendarUnit
                                                                                                       );
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *componentsNow =
    [gregorian components:unitFlags fromDate: [NSDate new]];
    
    NSDateComponents *components =
    [gregorian components:unitFlags fromDate: newDate];
    
    NSDate *currenteDate = [gregorian dateFromComponents:componentsNow];
    NSDate *SelecteDate = [gregorian dateFromComponents:components];
    
    [gregorian release];
    
    if ([currenteDate compare:SelecteDate] == NSOrderedAscending )
    {
        return YES;//时间大于现在时间跳出
    }
    return NO;
}

-(void)markDates:(NSArray *)dates
{
    
}
-(void)markDates:(NSArray *)dates withColors:(NSArray *)colors
{
    
}

#pragma mark - Set date to now
-(void)reset {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components =
    [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |
                           NSDayCalendarUnit) fromDate: [NSDate date]];
    self.currentMonth = [gregorian dateFromComponents:components]; //clean month
    [gregorian release];
    
    [self updateSize];
    [self setNeedsDisplay];
//    [delegate calendarView:self switchedToMonth:currentMonth targetHeight:self.calendarHeight animated:NO];
     if ([delegate respondsToSelector:@selector(calendarView:dateSelected:)]) [delegate calendarView:self dateSelected:[NSDate date]];
}

#pragma mark - Next & Previous
-(UIImage *)drawCurrentStateBottom
{
//    UIGraphicsBeginImageContext(CGSizeMake(kVRGCalendarViewWidth, kVRGCalendarViewTopBarHeight));
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kVRGCalendarViewWidth, kVRGCalendarViewTopBarHeight), NO, [UIScreen mainScreen].scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, -self.calendarHeight+kVRGCalendarViewTopBarHeight);    // <-- shift everything up by 40px when drawing.
    [self.layer renderInContext:c];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

-(void)showNextMonth {
    if (isAnimating) return;
    
    if ([self decideTheMonthAfterNowDate:[self.currentMonth offsetMonth:1]withDaySeleclt:NO])
    {
//        [Common TipDialog:@"不能查看未来的记录!"];
        return;
    }
    
//    self.markedDates=nil;
    isAnimating=YES;
    prepAnimationNextMonth=YES;
    
    [self setNeedsDisplay];
    
    int lastBlock = [currentMonth firstWeekDayInMonth]+[currentMonth numDaysInMonth]-1;
    int numBlocks = [self numRows]*7;
    BOOL hasNextMonthDays = lastBlock<numBlocks;
    
    //Old month
    float oldSize = self.calendarHeight;
    UIImage *imageCurrentMonth = [self drawCurrentState];
    
    //底部图片
    UIImage *bottomImage = [self drawCurrentStateBottom];
    
    //New month
    self.currentMonth = [currentMonth offsetMonth:1];
    prepAnimationNextMonth=NO;
    [self setNeedsDisplay];
    
    UIImage *imageNextMonth = [self drawCurrentState];
    float targetSize = fmaxf(oldSize, self.calendarHeight);
    UIView *animationHolder = [[UIView alloc] initWithFrame:CGRectMake(0, kVRGCalendarViewWeekHeight, kVRGCalendarViewWidth, targetSize-kVRGCalendarViewTopBarHeight-kVRGCalendarViewWeekHeight)];
    [animationHolder setClipsToBounds:YES];
    [self addSubview:animationHolder];
    [animationHolder release];
    
    //Animate
    animationView_A = [[UIImageView alloc] initWithImage:imageCurrentMonth];
    animationView_B = [[UIImageView alloc] initWithImage:imageNextMonth];
    [animationHolder addSubview:animationView_A];
    [animationHolder addSubview:animationView_B];
    
    
    if (hasNextMonthDays) {
        animationView_B.frameY = animationView_A.frameY + animationView_A.frameHeight - (kVRGCalendarViewDayHeight);
    } else {
        animationView_B.frameY = animationView_A.frameY + animationView_A.frameHeight -3;
    }
    __block UIImageView *bottomView = [[UIImageView alloc] initWithImage:bottomImage];
    [self addSubview:bottomView];
    [self bringSubviewToFront:bottomView];
    
    bottomView.frameY = oldSize- kVRGCalendarViewTopBarHeight;
    //Animation
//    __block VRGCalendarView *blockSafeSelf = self;
    [UIView animateWithDuration:0.35
                     animations:^{
                         [self updateSize];
                         //blockSafeSelf.frameHeight = 100;
                         if (hasNextMonthDays) {
                             animationView_A.frameY = -animationView_A.frameHeight + kVRGCalendarViewDayHeight;
                         } else {
                             animationView_A.frameY = -animationView_A.frameHeight + 3;
                         }
                         animationView_B.frameY = 0;
                         bottomView.frameY = self.calendarHeight- kVRGCalendarViewTopBarHeight;
                     }
                     completion:^(BOOL finished) {
                         [animationView_A release];
                         [animationView_B release];
                         [animationView_A removeFromSuperview];
                         [animationView_B removeFromSuperview];
                         [bottomView release];
                         [bottomView removeFromSuperview];
                         bottomView = nil;
                         animationView_A=nil;
                         animationView_B=nil;
                         isAnimating=NO;
                         [animationHolder removeFromSuperview];
                     }
     ];
    
    if ([delegate respondsToSelector:@selector(calendarView:switchedToMonth:targetHeight: animated:)])
        [delegate calendarView:self switchedToMonth:currentMonth  targetHeight:self.calendarHeight animated:YES];
}

-(void)showPreviousMonth {
    
    if (isAnimating) return;
    isAnimating=YES;
//    self.markedDates=nil;
    //Prepare current screen
    prepAnimationPreviousMonth = YES;
    [self setNeedsDisplay];
    BOOL hasPreviousDays = [currentMonth firstWeekDayInMonth]>1;
    float oldSize = self.calendarHeight;
    UIImage *imageCurrentMonth = [self drawCurrentState];
    //底部图片
    UIImage *bottomImage = [self drawCurrentStateBottom];
    
    //Prepare next screen
    self.currentMonth = [currentMonth offsetMonth:-1];
    prepAnimationPreviousMonth=NO;
    [self setNeedsDisplay];
    UIImage *imagePreviousMonth = [self drawCurrentState];
    
    float targetSize = fmaxf(oldSize, self.calendarHeight);
    UIView *animationHolder = [[UIView alloc] initWithFrame:CGRectMake(0, kVRGCalendarViewWeekHeight, kVRGCalendarViewWidth, targetSize-kVRGCalendarViewWeekHeight-kVRGCalendarViewTopBarHeight)];
    
    [animationHolder setClipsToBounds:YES];
    [self addSubview:animationHolder];
    [animationHolder release];
    
    animationView_A = [[UIImageView alloc] initWithImage:imageCurrentMonth];
    animationView_B = [[UIImageView alloc] initWithImage:imagePreviousMonth];
    [animationHolder addSubview:animationView_A];
    [animationHolder addSubview:animationView_B];
    
    if (hasPreviousDays) {
        animationView_B.frameY = animationView_A.frameY - (animationView_B.frameHeight-kVRGCalendarViewDayHeight);
    } else {
        animationView_B.frameY = animationView_A.frameY - animationView_B.frameHeight + 3;
    }
    
    __block UIImageView *bottomView = [[UIImageView alloc] initWithImage:bottomImage];
    [self addSubview:bottomView];
    [self bringSubviewToFront:bottomView];
//    UIImageWriteToSavedPhotosAlbum(bottomImage, self,  nil , nil );
    bottomView.frameY = oldSize- kVRGCalendarViewTopBarHeight;
    
//    __block VRGCalendarView *blockSafeSelf = self;
    [UIView animateWithDuration:0.35                     animations:^{
                         [self updateSize];
                         
                         if (hasPreviousDays) {
                             animationView_A.frameY = animationView_B.frameHeight-(kVRGCalendarViewDayHeight);
                             
                         } else {
                             animationView_A.frameY = animationView_B.frameHeight-3;
                         }
                         
                         animationView_B.frameY = 0;
                        bottomView.frameY = self.calendarHeight- kVRGCalendarViewTopBarHeight;
                     }
                     completion:^(BOOL finished) {
                         [animationView_A release];
                         [animationView_B release];
                         [animationView_A removeFromSuperview];
                         [animationView_B removeFromSuperview];
                         [bottomView release];
                         [bottomView removeFromSuperview];
                         bottomView = nil;
                         animationView_A=nil;
                         animationView_B=nil;
                         isAnimating=NO;
                         [animationHolder removeFromSuperview];
                     }
     ];
    
    if ([delegate respondsToSelector:@selector(calendarView:switchedToMonth:targetHeight:animated:)])
        [delegate calendarView:self switchedToMonth:currentMonth targetHeight:self.calendarHeight animated:YES];
}


#pragma mark - update size & row count
-(void)updateSize {
    self.frameHeight = self.calendarHeight;
    [self setNeedsDisplay];
}

-(float)calendarHeight {
    return kVRGCalendarViewTopBarHeight + [self numRows]*(kVRGCalendarViewDayHeight)+1 +kVRGCalendarViewWeekHeight;
}

-(int)numRows {
    float lastBlock = [self.currentMonth numDaysInMonth]+([self.currentMonth firstWeekDayInMonth]-1);
    return ceilf(lastBlock/7);
}

#pragma mark - Touches
//点击事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{       
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
//    touchPoint.y -= 44;
    
    self.selectedDate=nil;
    
    //Touch a specific day
    if (touchPoint.y > kVRGCalendarViewWeekHeight && touchPoint.y <self.calendarHeight-kVRGCalendarViewTopBarHeight) {
        float xLocation = touchPoint.x;
        float yLocation = touchPoint.y-kVRGCalendarViewWeekHeight;
        
        int column = floorf(xLocation/(kVRGCalendarViewDayWidth));
        int row = floorf(yLocation/(kVRGCalendarViewDayHeight));
        
        int blockNr = (column+1)+row*7;
        int firstWeekDay = [self.currentMonth firstWeekDayInMonth]-1; //-1 because weekdays begin at 1, not 0
        int date = blockNr-firstWeekDay;
        [self selectDate:date];
        return;
    }
    
    CGRect rectArrowLeft = CGRectMake(0, self.calendarHeight -kVRGCalendarViewTopBarHeight, kVRGCalendarViewDayWidth*1.5, kVRGCalendarViewTopBarHeight);
    CGRect rectArrowRight = CGRectMake(kVRGCalendarViewDayWidth*1.5, self.calendarHeight-kVRGCalendarViewTopBarHeight,kVRGCalendarViewDayWidth*1.5, kVRGCalendarViewTopBarHeight);
    
    //Touch either arrows or month in middle

    if (CGRectContainsPoint(rectArrowLeft, touchPoint)) {
//        [self showPreviousMonth];
    } else if (CGRectContainsPoint(rectArrowRight, touchPoint)) {
//        [self showNextMonth];
    } else if (CGRectContainsPoint(self.labelToday.frame, touchPoint)) {
        //Detect touch in current month
//        int currentMonthIndex = [self.currentMonth month];
//        int todayMonth = [[NSDate date] month];
//        [self reset];
//        if ((todayMonth!=currentMonthIndex) && [delegate respondsToSelector:@selector(calendarView:switchedToMonth:targetHeight:animated:)]) [delegate calendarView:self switchedToMonth:currentMonth  targetHeight:self.calendarHeight animated:NO];
    }
    
  
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect
{
    NSLog(@"------------%@",self.currentMonth );
    int firstWeekDay = [self.currentMonth firstWeekDayInMonth]-1; //-1 because weekdays begin at 1, not 0
    [currentMonth firstWeekDayInMonth];
    
    self.labelToday.frame =  [Common rectWithOrigin: self.labelToday.frame x:kDeviceWidth-self.labelToday.width-15 y:self.calendarHeight-kVRGCalendarViewTopBarHeight + (kVRGCalendarViewTopBarHeight-self.labelToday.height)/2];
    
    leftButton.frame =  [Common rectWithOrigin: leftButton.frame x:14 y:self.labelToday.top];
    rightButton.frame =  [Common rectWithOrigin: rightButton.frame x:leftButton.right+15 y:self.labelToday.top];
    float y = kVRGCalendarViewTopBarHeight ;
    
    CGContextClearRect(UIGraphicsGetCurrentContext(),rect);
    CGContextRef context = UIGraphicsGetCurrentContext();
//    背景颜色
    CGRect rectangle = CGRectMake(0, 0, self.frame.size.width, self.calendarHeight);
    CGContextAddRect(context, rectangle);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);

    CGContextAddRect(context, CGRectMake(0, self.calendarHeight-kVRGCalendarViewTopBarHeight, kDeviceWidth, y));
    CGContextSetFillColorWithColor(context, [CommonImage colorWithHexString:@"ffffff"].CGColor);
    CGContextFillPath(context);
    
    //left
//    UIImage *image = [UIImage imageNamed:@"common.bundle/common/left_normal.png"];
//    [image drawInRect:CGRectMake(kVRGCalendarViewDayWidth-image.size.width, self.calendarHeight-kVRGCalendarViewTopBarHeight +(kVRGCalendarViewTopBarHeight-image.size.height)/2, image.size.width, image.size.height)];
//    
//    //right
//    image = [UIImage imageNamed:@"common.bundle/common/right_normal.png"];
//    [image drawInRect:CGRectMake(kVRGCalendarViewDayWidth*2, self.calendarHeight-kVRGCalendarViewTopBarHeight+(kVRGCalendarViewTopBarHeight-image.size.height)/2, image.size.width, image.size.height)];
    
    CGContextSetShouldAntialias(context, YES);
    UIColor *textColor = nil;
	NSArray *array = [NSArray arrayWithObjects:@"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
    for (int i =0; i<[array count]; i++) {
//        颜色区分
//        if (i%2 == 0)
//        {
            CGRect rectangleGrid = CGRectMake(kVRGCalendarViewDayWidth*i,0,kVRGCalendarViewDayWidth,kVRGCalendarViewWeekHeight-0.5);
            CGContextAddRect(context, rectangleGrid);
            CGContextSetFillColorWithColor(context, [CommonImage colorWithHexString:@"ebebeb"].CGColor);
            CGContextFillPath(context);
//        }
        if (i==0 || i== array.count-1)
        {
            textColor = [CommonImage colorWithHexString:VERSION_ERROR_TEXT_COLOR];
        }
        else
            textColor = [CommonImage colorWithHexString:@"666666"];
        CGContextSetFillColorWithColor(context, textColor.CGColor);
        NSString *weekdayValue = [array objectAtIndex:i];
        UIFont *font = [UIFont systemFontOfSize:14];
        [weekdayValue drawInRect:CGRectMake(i*kVRGCalendarViewDayWidth, 5, kVRGCalendarViewDayWidth, 20) withFont:font lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
    }
    int numRows = [self numRows];
    int numBlocks = numRows*7;
    NSDate *previousMonth = [self.currentMonth offsetMonth:-1];
    int currentMonthNumDays = [currentMonth numDaysInMonth];
    int prevMonthNumDays = [previousMonth numDaysInMonth];
    NSDate *nextMonth = [self.currentMonth offsetMonth:1];
    
    int selectedDateBlock = ([selectedDate day]-1)+firstWeekDay;
    
    //prepAnimationPreviousMonth nog wat mee doen
    //prev next month
    BOOL isSelectedDatePreviousMonth = prepAnimationPreviousMonth;
    BOOL isSelectedDateNextMonth = prepAnimationNextMonth;
    
    if (self.selectedDate!=nil) {
        isSelectedDatePreviousMonth = ([selectedDate year]==[currentMonth year] && [selectedDate month]<[currentMonth month]) || [selectedDate year] < [currentMonth year];
        
        if (!isSelectedDatePreviousMonth) {
            isSelectedDateNextMonth = ([selectedDate year]==[currentMonth year] && [selectedDate month]>[currentMonth month]) || [selectedDate year] > [currentMonth year];
        }
    }
    
    if (isSelectedDatePreviousMonth) {
        int lastPositionPreviousMonth = firstWeekDay-1;
        selectedDateBlock=lastPositionPreviousMonth-([selectedDate numDaysInMonth]-[selectedDate day]);
    } else if (isSelectedDateNextMonth) {
        selectedDateBlock = [currentMonth numDaysInMonth] + (firstWeekDay-1) + [selectedDate day];
    }
    
    
    NSDate *todayDate = [NSDate date];
    int todayBlock = -1;
    
    if ([todayDate month] == [currentMonth month] && [todayDate year] == [currentMonth year]) {
        todayBlock = [todayDate day] + firstWeekDay - 1;
    }
    //当月的天数
    int days = [DiaryModelView getMonthDaysWithDate:currentMonth];
    BOOL isatferDayGray = NO;
    if (days != currentMonthNumDays)
    {
        isatferDayGray = YES;
    }
//    CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.5);
//    CGContextSetLineWidth(context, 0.5);
//    CGContextMoveToPoint(context,0, kVRGCalendarViewTopBarHeight+(numBlocks/7)*kVRGCalendarViewDayHeight);
//    CGContextAddLineToPoint(context,kDeviceWidth, kVRGCalendarViewTopBarHeight+(numBlocks/7)*kVRGCalendarViewDayHeight);
//    CGContextStrokePath(context);
//    CGContextSetShouldAntialias(context, YES );
    
    NSString *strDate;
    for (int i=0; i<numBlocks; i++) {
        int targetDate = 0;
        int targetColumn = i%7;
        int targetRow = i/7;
        float targetX = targetColumn * kVRGCalendarViewDayWidth;
        float targetY = targetRow * kVRGCalendarViewDayHeight + kVRGCalendarViewWeekHeight;
        
        NSString *hex = @"#333333";
        if (i<firstWeekDay) { //previous month
            targetDate = (prevMonthNumDays-firstWeekDay)+(i+1);
            hex = @"#cccccc";
            NSString *month = [previousMonth month]<10 ? [NSString stringWithFormat:@"0%d", [previousMonth month]] : [NSString stringWithFormat:@"%d", [previousMonth month]];
            NSString *day = targetDate<10 ? [NSString stringWithFormat:@"0%d", targetDate] : [NSString stringWithFormat:@"%d", targetDate];
            
            strDate = [NSString stringWithFormat:@"%d/%@/%@",[previousMonth year], month, day];
            
        } else if (i>=(firstWeekDay+currentMonthNumDays)) { //next month
            targetDate = (i+1) - (firstWeekDay+currentMonthNumDays);
            hex = @"#cccccc";
            
            NSString *month = [nextMonth month]<10 ? [NSString stringWithFormat:@"0%d", [nextMonth month]] : [NSString stringWithFormat:@"%d", [nextMonth month]];
            NSString *day = targetDate<10 ? [NSString stringWithFormat:@"0%d", targetDate] : [NSString stringWithFormat:@"%d", targetDate];
            
            strDate = [NSString stringWithFormat:@"%d/%@/%@",[nextMonth year], month, day];
        } else { //current month
            targetDate = (i-firstWeekDay)+1;
            NSString *month = [currentMonth month]<10 ? [NSString stringWithFormat:@"0%d", [currentMonth month]] : [NSString stringWithFormat:@"%d", [currentMonth month]];
            NSString *day = targetDate<10 ? [NSString stringWithFormat:@"0%d", targetDate] : [NSString stringWithFormat:@"%d", targetDate];
            strDate = [NSString stringWithFormat:@"%d/%@/%@",[currentMonth year], month, day];
            if (isatferDayGray && targetDate>days)
            {
                 hex = kAtferDayColor;
            }
        }
        
        NSString *date = [NSString stringWithFormat:@"%i",targetDate];
        
        //draw selected date
        if (todayBlock==i) {
            hex = @"ffffff";//当天显示颜色
//            CGRect rectangleGrid = CGRectMake(targetX,targetY,kVRGCalendarViewDayWidth-0.5,kVRGCalendarViewDayHeight-0.5);
//            CGContextAddArc(context, targetX+kVRGCalendarViewDayWidth/2.0, targetY+kVRGCalendarViewDayHeight/2.0, MIN(kVRGCalendarViewDayWidth, kVRGCalendarViewDayHeight)/2.0, 0, 2*M_PI, 0);
              CGContextAddArc(context, targetX+kVRGCalendarViewDayWidth/2.0, targetY+kVRGCalendarViewDayHeight/2.0, 35.0/2.0, 0, 2*M_PI, 0);
//            CGContextAddEllipseInRect(context, rectangleGrid);
//            CGContextAddRect(context, rectangleGrid);
            CGContextSetFillColorWithColor(context, [CommonImage colorWithHexString:COLOR_FF5351].CGColor);
            CGContextFillPath(context);
            
        }else if (selectedDate && i==selectedDateBlock) {
            hex = COLOR_FF5351;
            CGContextSetLineWidth(context, 0.5);
            CGContextSetStrokeColorWithColor(context, [CommonImage colorWithHexString:COLOR_FF5351].CGColor);
//            CGContextAddArc(context, targetX+kVRGCalendarViewDayWidth/2.0, targetY+kVRGCalendarViewDayHeight/2.0, MIN(kVRGCalendarViewDayWidth, kVRGCalendarViewDayHeight)/2.0, 0, 2*M_PI, 0);
             CGContextAddArc(context, targetX+kVRGCalendarViewDayWidth/2.0, targetY+kVRGCalendarViewDayHeight/2.0, 35.0/2.0, 0, 2*M_PI, 0);
//            CGRect rectangleGrid = CGRectMake(targetX,targetY,kVRGCalendarViewDayWidth-0.5,kVRGCalendarViewDayHeight-1);
//            CGContextAddRect(context, rectangleGrid);
            CGContextStrokePath(context);
//            CGContextSetFillColorWithColor(context, [CommonImage colorWithHexString:@"ffffff"].CGColor);
            CGContextFillPath(context);
            
        } else {
//            if (targetColumn%2 == 0)
//            {
//                //格子的颜色
//                CGRect rectangleGrid = CGRectMake(targetX,targetY,kVRGCalendarViewDayWidth,kVRGCalendarViewDayHeight);
//                CGContextAddRect(context, rectangleGrid);
//                CGContextSetFillColorWithColor(context, [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR2].CGColor);
//                CGContextFillPath(context);
//            }
        }
        //字
        CGContextSetFillColorWithColor(context, [CommonImage colorWithHexString:hex].CGColor);
        [date drawInRect:CGRectMake(targetX+(kVRGCalendarViewDayWidth-20)/2, targetY+(kVRGCalendarViewDayHeight-20)/2, 20, 20) withFont:[UIFont fontWithName:@"HelveticaNeue"size:16] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
        
        CGContextSetShouldAntialias(context, NO);//不抗锯齿 显示正常 抗锯齿显示为2
//        for (int i = 0; i<numRows+1; i++)
//        {
//            //xian
//            CGContextSetStrokeColorWithColor(context,  [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN].CGColor);
//            CGContextMoveToPoint(context, 0, kVRGCalendarViewWeekHeight-0.5 + i*kVRGCalendarViewDayHeight);
//            CGContextSetLineWidth(context, 0.5);
//            CGContextAddLineToPoint(context, kDeviceWidth,kVRGCalendarViewWeekHeight-0.5+i*kVRGCalendarViewDayHeight);
//            CGContextStrokePath(context);
//        }
          CGContextSetShouldAntialias(context, YES);
//画标示
        if (i >=firstWeekDay && i < (firstWeekDay+currentMonthNumDays))
        {
            targetDate = (i-firstWeekDay);
            if (targetDate <m_array.count)
            {
//                    CGRect rectangleGrid;
                    int isshow = [m_array[targetDate] intValue];
                    switch (isshow)
                    {
                        case 0:
                            break;
                        case 2:
                        {
                            CGContextAddArc(context, targetX+kVRGCalendarViewDayWidth/2.0, targetY+kVRGCalendarViewDayHeight/2.0+14.0, 2.0, 0, 2*M_PI, 0);
                            CGContextSetFillColorWithColor(context, [CommonImage colorWithHexString:COLOR_FF5351].CGColor);
                            CGContextFillPath(context);
                        }
                            break;
                        case 1:
                        {
                            CGContextAddArc(context, targetX+kVRGCalendarViewDayWidth/2.0, targetY+kVRGCalendarViewDayHeight/2.0+14.0, 2.0, 0, 2*M_PI, 0);
                            CGContextSetFillColorWithColor(context, [CommonImage colorWithHexString:@"cccccc"].CGColor);
                            CGContextFillPath(context);
                            
                        }
                            break;
                        default:
                            break;
                    }
                
            }

        }
    }
}


//格式化时间
- (NSString *)formatDate:(NSString *)time
{
    if ((NSNull *)time == [NSNull null])
    {
        return @"";
    }

    NSString *localDateString  = [ [time substringToIndex:10] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];

    return localDateString;
}

#pragma mark - Draw image for animation
-(UIImage *)drawCurrentState {
    float targetHeight = kVRGCalendarViewTopBarHeight + [self numRows]*(kVRGCalendarViewDayHeight)+1+kVRGCalendarViewWeekHeight;
    
//    UIGraphicsBeginImageContext(CGSizeMake(kVRGCalendarViewWidth, targetHeight-kVRGCalendarViewTopBarHeight-kVRGCalendarViewWeekHeight));
     UIGraphicsBeginImageContextWithOptions(CGSizeMake(kVRGCalendarViewWidth, targetHeight-kVRGCalendarViewTopBarHeight-kVRGCalendarViewWeekHeight), NO, [UIScreen mainScreen].scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, -kVRGCalendarViewWeekHeight);    // <-- shift everything up by 40px when drawing.
    [self.layer renderInContext:c];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

#pragma mark - Init

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.contentMode = UIViewContentModeTop;
//        self.clipsToBounds=YES;
//        self.backgroundColor = [UIColor whiteColor];
//        
//        isAnimating=NO;
//        self.labelCurrentMonth = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, kDeviceWidth, 50)];
//        [self addSubview:labelCurrentMonth];
//        self.labelCurrentMonth.backgroundColor = [UIColor clearColor];
//        labelCurrentMonth.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:23];
//        labelCurrentMonth.textColor = [CommonImage colorWithHexString:@"#666666"];
//        labelCurrentMonth.textAlignment = NSTextAlignmentCenter;
//        
//        [self performSelector:@selector(reset) withObject:nil afterDelay:0.1]; //so delegate can be set after init and still get called on init
//        //        [self reset];
//    }
//    return self;
//}

-(id)init {
    self = [super initWithFrame:CGRectMake(0, 0, kVRGCalendarViewWidth, 0)];
    if (self) {
        self.contentMode = UIViewContentModeTop;
        self.clipsToBounds=YES;
        self.backgroundColor = [UIColor clearColor];
        
        isAnimating=NO;
        
//        self.labelToday = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55, 25)];
        self.labelToday = [UIButton buttonWithType:UIButtonTypeCustom];
        self.labelToday.frame = CGRectMake(0, 0, 55, 25);
        [self.labelToday setTitle:@"今天" forState:UIControlStateNormal];
        [self addSubview:labelToday];
//        self.labelToday.text = @"今天";
        self.labelToday.backgroundColor = [UIColor redColor];
        self.labelToday.layer.cornerRadius = 2.0;
        self.labelToday.layer.borderWidth = 0.5;
//        self.labelToday.userInteractionEnabled = NO;
        [self.labelToday addTarget:self action:@selector(btntoday) forControlEvents:UIControlEventTouchUpInside];
        self.labelToday.layer.borderColor = [CommonImage colorWithHexString:@"c8c8c8"].CGColor;
        self.labelToday.layer.masksToBounds = YES;
         self.labelToday.backgroundColor = [UIColor clearColor];
        labelToday.titleLabel.font = [UIFont systemFontOfSize:13];
//        labelToday.textColor = [CommonImage colorWithHexString:@"666666"];
        
        UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"ffffff"]];
        [labelToday setBackgroundImage:image forState:UIControlStateNormal];
        
        [labelToday setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [labelToday setTitleColor:[CommonImage colorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
//        labelToday.textAlignment = NSTextAlignmentCenter;
        
        for (int i = 0; i<2; i++)
        {
            UIButton * button= [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0,40, self.labelToday.height);
            [self addSubview:button];
            button.backgroundColor = [UIColor redColor];
            button.layer.cornerRadius = 2.0;
            button.layer.borderWidth = 0.5;
            [button addTarget:self action:@selector(butEventleftAndRight:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.borderColor = [CommonImage colorWithHexString:@"c8c8c8"].CGColor;
            button.tag = 111+i;
            button.layer.masksToBounds = YES;
            button.backgroundColor = [UIColor clearColor];
            UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"ffffff"]];
            UIImage *normalImage = [UIImage imageNamed:@"common.bundle/diary/leftRight.png"];
            [button setBackgroundImage:image forState:UIControlStateNormal];
            if (i == 0)
            {
                leftButton = button;
                normalImage = [UIImage imageWithCGImage:normalImage.CGImage scale:normalImage.scale orientation:UIImageOrientationDown];
            }
            else
            {
                rightButton = button;
            }
                [button setImage:normalImage forState:UIControlStateNormal];
                [button setImage:normalImage forState:UIControlStateHighlighted];
        }
//        [self performSelector:@selector(reset) withObject:nil afterDelay:0.1]; //so delegate can be set after init and still get called on init
//        [self addSwipeGestureRecognizer];
    }
    return self;
}

-(void)btntoday
{
    [self.currentMonth month];
    [[NSDate date] month];
    [self reset];
//    if ((todayMonth!=currentMonthIndex) && [delegate respondsToSelector:@selector(calendarView:switchedToMonth:targetHeight:animated:)]) [delegate calendarView:self switchedToMonth:currentMonth  targetHeight:self.calendarHeight animated:NO];

}
- (void)butEventleftAndRight:(UIButton *)btn
{
    switch (btn.tag) {
        case 111:
             [self showPreviousMonth];
            break;
        case 112:
            [self showNextMonth];
            break;
        default:
            break;
    }
}

-(void)dealloc {
    
    self.delegate=nil;
    self.currentMonth=nil;
    [self.labelToday release];

    [super dealloc];
}

//-(void)addSwipeGestureRecognizer
//{
//    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
//    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
//    
//    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
//    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
//    
//    [self addGestureRecognizer:leftSwipeGestureRecognizer];
//    [self addGestureRecognizer:rightSwipeGestureRecognizer];
//}
//
//- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
//{
//    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
//        [self showNextMonth];
//    }
//    else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
//       [self showPreviousMonth];
//    }
//}
@end
