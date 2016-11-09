//
//  MyKeyValueView.h
//  jiuhaohealth2.1
//
//  Created by 王敏 on 14-11-30.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  得到键值view
 */
@interface MyKeyValueView : UIView

- (void)getCellViewWithKey:(NSString *)key Value:(NSAttributedString *)value index:(int)row hasAccessView:(BOOL)yes;

- (void)getCellViewWithKey:(NSString *)key ValueString:(NSString *)value index:(int)row hasAccessView:(BOOL)yes;

- (NSMutableAttributedString *)replaceWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )size keywordColor:(NSString *)colorString;
@end
