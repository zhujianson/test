//
//  TradingCell.m
//  jiuhaohealth4.0
//
//  Created by xjs on 15/8/19.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "TradingCell.h"

@implementation TradingCell
{
    UILabel * labelName;
    UILabel * labelTime;
    UILabel * labelNum;

}
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        labelName = [Common createLabel:CGRectMake(15, 10, kDeviceWidth/2, 20) TextColor:@"333333" Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft labTitle:nil];
        [self addSubview:labelName];
        labelTime = [Common createLabel:CGRectMake(15, labelName.bottom, kDeviceWidth/2, 20) TextColor:@"666666" Font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft labTitle:nil];
        [self addSubview:labelTime];
        labelNum = [Common createLabel:CGRectMake(kDeviceWidth/2-15, 0, kDeviceWidth/2, 55) TextColor:COLOR_FF5351 Font:[UIFont systemFontOfSize:21] textAlignment:NSTextAlignmentRight labTitle:nil];
        [self addSubview:labelNum];

    }
    return self;
}

- (void)setInfoDic:(NSDictionary*)dic
{
    labelName.text = dic[@"desc"];
    labelTime.text = dic[@"time"];
    NSString* str = @"+";
    labelNum.textColor = [CommonImage colorWithHexString:COLOR_FF5351];
    if ([dic[@"type"] isEqualToString:@"D"]) {
        str = @"-";
        labelNum.textColor = [CommonImage colorWithHexString:@"4d7df8"];
    }
    labelNum.text = [NSString stringWithFormat:@"%@%.2f",str,[dic[@"value"] floatValue]/100];

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
