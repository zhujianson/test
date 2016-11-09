//
//  UserInfoCell.m
//  jiuhaohealth4.0
//
//  Created by xjs on 15/4/21.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "UserInfoCell.h"

@implementation UserInfoCell
{
    UILabel * titleLab;
    UILabel * textLab;

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLab = [Common createLabel:CGRectMake(15, 0, 100, 40) TextColor:@"333333" Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft labTitle:nil];
        [self.contentView addSubview:titleLab];
        textLab = [Common createLabel:CGRectMake(kDeviceWidth-15-200, 0, 200, 40) TextColor:@"999999" Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentRight labTitle:nil];
        [self.contentView addSubview:textLab];

        
    }
    return self;
}

- (void)setDataFromDic:(NSDictionary*)dic 
{
    NSString * titleName =dic[@"title"];
    titleLab.text =titleName;
    if (!self.isMeFlag || [titleName isEqualToString:@"总步数"] || [titleName isEqualToString:@"总里程"] || [titleName isEqualToString:@"总消耗"] || [titleName isEqualToString:@"挑战纪录"]) {
        textLab.frame = [Common rectWithOrigin:textLab.frame x:kDeviceWidth-15-200 y:0];
    }else{
        textLab.frame = [Common rectWithOrigin:textLab.frame x:kDeviceWidth-35-200 y:0];
    }
    
    textLab.hidden = NO;
    if ([dic[@"title"] isEqualToString:@"挑战纪录"]) {
    textLab.textColor = [CommonImage colorWithHexString:@"0e8df8"];
    NSArray * arr = [dic[@"data"] componentsSeparatedByString:@" "];
    textLab.attributedText = [self replaceRedColorWithNSString:dic[@"data"] andUseKeyWord:arr[0] andWithFontSize:16 TextColor:@"ff5232"];
    }else if ([dic[@"title"] isEqualToString:@"最近血糖"] && [dic[@"isMe"] boolValue]) {
        textLab.hidden = YES;
        NSString *bsValueString = dic[@"bsValue"];
        BOOL hasSwitchFlag =  (BOOL)(dic[@"isMe"]);
        if(bsValueString.length != 0){
            CGFloat w = 0;
            BOOL resultFlag = [dic[@"bsFlag"] isEqualToString:@"1"]? YES : NO;
            if (hasSwitchFlag) {
                UISwitch *switchView = (UISwitch*)[self.contentView viewWithTag:88];
                if (!switchView) {
                    switchView = [[UISwitch alloc] initWithFrame:CGRectMake(kDeviceWidth -(IOS_7? 65:90),5, 50, 30)];
                    switchView.tag = 88;
                    switchView.onTintColor = [CommonImage colorWithHexString:@"ff5232"];
                    switchView.on = resultFlag;//[self.dataDic[@"bsFlag"] intValue];
                    [switchView addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
                    [self.contentView addSubview:switchView];
                    w = switchView.width+10;
                }
            }
            UILabel *sugarLabel = (UILabel*)[self.contentView viewWithTag:89];
            if (!sugarLabel) {
                sugarLabel = [Common createLabel:CGRectMake(kDeviceWidth-w-165, 0, 150, 40) TextColor:COLOR_FF5351 Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentRight labTitle:nil];
                sugarLabel.tag = 89;
                sugarLabel.hidden = !resultFlag;
                sugarLabel.textColor = [CommonImage colorWithHexString:@"ff5232"];
                sugarLabel.attributedText = [self replaceWithNSString:[NSString stringWithFormat:@"%@ mmol/L" ,dic[@"data"]] andUseKeyWord:@"mmol/L" andWithFontSize:12 keywordColor:@"999999"];
                [self.contentView addSubview:sugarLabel];
            }
        }

    }else{
        textLab.textColor = [CommonImage colorWithHexString:@"999999"];
        textLab.text = [dic[@"data"] length]?dic[@"data"]:@"暂无";
    }
}

- (void)switchValueChanged:(UISwitch*)switchView
{
    UILabel *lab = (UILabel*)[self.contentView viewWithTag:89];
    lab.hidden = !switchView.on;
    if(!switchView.on){
        [Common TipDialog2:@"关闭后血糖值将不会被别人看到。"];
    }
    int temp = switchView.on;
    
    _switchBlock(temp);
}

- (void)setSwitchStatusFlag:(SwitchStatusFlagBlock)blocks
{
    _switchBlock = [blocks copy];
}

//描红
- (NSMutableAttributedString *)replaceRedColorWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )s TextColor:(NSString*)coler
{
    NSMutableAttributedString *attrituteString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:coler], NSFontAttributeName : [UIFont systemFontOfSize:s]} range:range];
    return attrituteString;
}

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


@end
