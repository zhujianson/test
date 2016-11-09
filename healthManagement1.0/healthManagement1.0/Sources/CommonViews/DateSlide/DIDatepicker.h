//
//  Created by Dmitry Ivanenko on 14.04.14.
//  Copyright (c) 2014 Dmitry Ivanenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIDatepickerDateView.h"


extern const CGFloat kDIDetepickerHeight;


@interface DIDatepicker : UIControl

@property (assign, nonatomic) NSDate *selectedDate;
//@property

- (id)initWithFrame:(CGRect)frame froViewCon:(UIViewController*)vc;

- (void)fillCurrentMonth:(NSDate*)date;
- (void)selectDate:(NSDate *)date;

+ (BOOL)isTheSameData:(NSDate*)detaildate1 :(NSDate*)detaildate2;

- (void)setShowDataDian:(NSArray*)array;


@end
