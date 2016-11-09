//
//  PickerView.h
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-8-13.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PickerViewBlock)(NSString *content);
@interface PickerView : NSObject <UIPickerViewDataSource,UIPickerViewDelegate>
{
    BOOL _isOneComoponent;
    NSArray *m_defalutArray;
    UIView *m_view;
    PickerViewBlock picBlock;
}
@property (nonatomic, assign) UIPickerView *m_pickerView;
@property (nonatomic, assign) NSInteger m_row;

- (void)createPickViewWithArray:(NSArray *)array andWithSelectString:(NSString *)selectString setTitle:(NSString *)title isShow:(BOOL)isLine;

- (void)setPickerViewBlock:(PickerViewBlock)back;

@end
