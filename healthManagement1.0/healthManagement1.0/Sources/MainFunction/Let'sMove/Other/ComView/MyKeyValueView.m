//
//  MyKeyValueView.m
//  jiuhaohealth2.1
//
//  Created by 王敏 on 14-11-30.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "MyKeyValueView.h"

static const float leftMargin = 15;//左边距

@implementation MyKeyValueView


- (NSMutableAttributedString *)replaceWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )size keywordColor:(NSString *)colorString
{
    NSMutableAttributedString *attrituteString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
    if(!keyWord){
        return attrituteString;
    }
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:colorString], NSFontAttributeName : [UIFont systemFontOfSize:size]} range:range];
    return attrituteString;
}

- (void)getCellViewWithKey:(NSString *)key Value:(NSAttributedString *)value index:(int)row hasAccessView:(BOOL)yes
{
    //key
    CGFloat originY = 15;
    UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, originY, 80, 16)];
    keyLabel.font = [UIFont systemFontOfSize:16];
    keyLabel.textColor = [CommonImage colorWithHexString:@"333333"];
    keyLabel.text = key;
    keyLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:keyLabel];
    [keyLabel release];
    
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-175, originY, 160, 16)];
    valueLabel.textAlignment = NSTextAlignmentRight;
    valueLabel.textColor = [CommonImage colorWithHexString:@"fea94c"];
    valueLabel.attributedText = value;
    valueLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:valueLabel];
    [valueLabel release];
    valueLabel.tag = 100+row;
    valueLabel.textColor = [CommonImage colorWithHexString:@"999999"];

    if(yes){
        
      CGRect valueLabelFrame = valueLabel.frame;
        valueLabelFrame.origin.x -= 22;
        valueLabel.frame = valueLabelFrame;
        UIImageView *accessView = [[UIImageView alloc] initWithFrame:CGRectMake(valueLabelFrame.origin.x+valueLabelFrame.size.width+15, originY, 7, 15)];
        accessView.image = [UIImage imageNamed:@"common.bundle/move/move_icon_next.png"];
        [self addSubview:accessView];
        [accessView release];
        
    }
    
    CGFloat offset = 15;
    if([key isEqualToString:@"用户编号"]){
        offset = 0;
    }
    
    UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(offset, originY-15+44.5,kDeviceWidth, 0.5)];
    lineView.backgroundColor =  [CommonImage colorWithHexString:@"e6e6e6"];
    [self addSubview:lineView];
    [lineView release];
    
    
}

- (void)getCellViewWithKey:(NSString *)key ValueString:(NSString *)value index:(int)row hasAccessView:(BOOL)yes
{
    //key
    CGFloat originY = 15;
    UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, originY, 80, 15)];
    keyLabel.font = [UIFont systemFontOfSize:16];
    keyLabel.textColor = [CommonImage colorWithHexString:@"333333"];
    keyLabel.text = key;
    [self addSubview:keyLabel];
    [keyLabel release];
    
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-175, originY, 160, 15)];
    valueLabel.textAlignment = NSTextAlignmentRight;
    valueLabel.textColor = [CommonImage colorWithHexString:@"fea94c"];
    valueLabel.text = value;
    [self addSubview:valueLabel];
    [valueLabel release];
    valueLabel.tag = 100+row;
    valueLabel.textColor = [CommonImage colorWithHexString:@"999999"];
    
    if(yes){
        
        CGRect valueLabelFrame = valueLabel.frame;
        valueLabelFrame.origin.x -= 22;
        valueLabel.frame = valueLabelFrame;
        UIImageView *accessView = [[UIImageView alloc] initWithFrame:CGRectMake(valueLabelFrame.origin.x+valueLabelFrame.size.width+15, originY, 7, 15)];
        accessView.image = [UIImage imageNamed:@"common.bundle/move/move_icon_next.png"];
        [self addSubview:accessView];
        [accessView release];
        
    }
    
    
    UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(15, originY-15+44.5,kDeviceWidth, 0.5)];
    lineView.backgroundColor =  [CommonImage colorWithHexString:@"e6e6e6"];
    [self addSubview:lineView];
    [lineView release];
    
    
}


@end
