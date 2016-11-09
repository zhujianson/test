//
//  CalculatorInputView.m
//  jiuhaohealth3.0
//
//  Created by 徐国洪 on 15-1-13.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "CalculatorInputView.h"

@implementation CalculatorInputView

- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate
{
    self = [super initWithFrame:CGRectMake(100, 100, 159, 150)];
    if (self) {
        self.m_value = @"0";
        //kvo注册
        [self addObserver:delegate forKeyPath:@"m_value" options:NSKeyValueObservingOptionNew context:nil];
        
        self.backgroundColor = [UIColor orangeColor];
        NSArray *array = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @".", @"0", @""];
        UIButton *but;
        NSString *title;
        int row, list, widht = 48, height = 30;
        for (int i = 0; i < array.count; i++) {
            row = i / 3;
            list = i % 3;
            but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.autoresizingMask =
            UIViewAutoresizingFlexibleLeftMargin |
            UIViewAutoresizingFlexibleWidth        |
            UIViewAutoresizingFlexibleRightMargin  |
            UIViewAutoresizingFlexibleTopMargin   |
            UIViewAutoresizingFlexibleHeight      |
            UIViewAutoresizingFlexibleBottomMargin;
            but.layer.cornerRadius = 2;
            but.layer.borderColor = [CommonImage colorWithHexString:@"c8c8c8"].CGColor;
            but.layer.borderWidth = 0.5;
            but.frame = CGRectMake((widht + 7)*list, (height+10)*row, widht, height);
            but.tag = 10+i;
            [but addTarget:self action:@selector(butEvent:) forControlEvents:UIControlEventTouchUpInside];
            title = [array objectAtIndex:i];
            if (title.length) {
                [but setTitle:title forState:UIControlStateNormal];
            }
            else {
                [but setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            }
            [self addSubview:but];
        }
    }
    
    return self;
}

- (void)butEvent:(UIButton*)but
{
    NSString *title = but.titleLabel.text;
    if (title.length) {
        if ([self.m_value isEqualToString:@"0"] && ![title isEqualToString:@"."]) {
            self.m_value = title;
        }
        else {
            self.m_value = [self.m_value stringByAppendingString:title];
        }
    }
    else {
        if (self.m_value.length == 1) {
            self.m_value = @"0";
        }
        else {
            self.m_value = [self.m_value substringToIndex:self.m_value.length-1];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
