//
//  Created by Dmitry Ivanenko on 15.04.14.
//  Copyright (c) 2014 Dmitry Ivanenko. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
	dian_notShow = 0,
	dian_show_gray = 1,
	dian_show_red
}dian_is_show;

extern const CGFloat kDIDatepickerItemWidth;
//extern const CGFloat kDIDatepickerSelectionLineWidth;


@interface DIDatepickerDateView : UIControl

// data
@property (assign, nonatomic) NSDate *date;

@property (nonatomic, assign) dian_is_show is_show;

- (void)setHighlighted1:(BOOL)highlighted;

+ (NSDate *)dateForToday;

@end
