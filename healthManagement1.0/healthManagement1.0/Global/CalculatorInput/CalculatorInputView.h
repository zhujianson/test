//
//  CalculatorInputView.h
//  jiuhaohealth3.0
//
//  Created by 徐国洪 on 15-1-13.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorInputView : UIView

- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate;

@property (nonatomic, retain) NSString *m_value;

@end
