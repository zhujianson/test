//
//  RedPacketCell.m
//  jiuhaohealth4.2
//
//  Created by jiuhao-yangshuo on 15/12/11.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "RedPacketCell.h"

@implementation RedPacketCell
@synthesize m_redPacketUseType;

-(void)setUpDict:(NSDictionary *)dict withModelType:(RedPacketUseType)redPacketUseType
{
    [super setUpDict:dict withModelType:redPacketUseType];
    [self fillData];
    switch (redPacketUseType) {
        case RedPacketUseTypeNoUse:
            [self fillDataRedPacketUseTypeNoUse];
            break;
        case RedPacketUseTypeExpire:
             [self fillDataRedPacketUseTypeExpire];
            break;
        case RedPacketUseTypeUse:
            [self fillDataRedPacketUseTypeUse];
            break;
        default:
            break;
    }
}

-(void)fillData
{
    NSString *countStr = [self.m_dictInfo[@"bonusValue"] stringValue];
    NSString *countTypeStr = [self createUnitStringWithDict:self.m_dictInfo];
    NSString *countAllStr = [countStr stringByAppendingFormat:@"\n%@",countTypeStr];
    NSMutableAttributedString *attributedStr = [[self class] replaceRedColorWithNSString:countAllStr andUseKeyWord:countStr andWithFontSize:M_FRONT_THIRTY andWithFrontColor:@"ffffff"];
    self.moneyCountLabel.attributedText = attributedStr;
    
    NSString *describeStr = self.m_dictInfo[@"amountDesc"];
    NSString *describeAllStr = [describeStr stringByAppendingFormat:@"\n使  用"];
    self.moneyUseDescriptionLabel.text = describeAllStr;
    
    self.redPaketNameLabel.text =self.m_dictInfo[@"bonusName"];
    self.redPaketCategoryLabel.text =self.m_dictInfo[@"bonusExplain"];
    self.redPaketExpireLabel.text = self.m_dictInfo[@"deadline"];
}

+(NSMutableAttributedString *)replaceRedColorWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )size andWithFrontColor:(NSString *)frontColor
{
    NSMutableParagraphStyle *paragraphStyle =[[NSMutableParagraphStyle  alloc] init];
//    paragraphStyle.minimumLineHeight = 30;
//    paragraphStyle.maximumLineHeight = 30;
//    paragraphStyle.lineSpacing = 0;//增加行高
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributtes = @{
                                  NSParagraphStyleAttributeName : paragraphStyle,
                                  NSForegroundColorAttributeName : [CommonImage colorWithHexString:@"ffffff"],
                                  NSFontAttributeName : [UIFont systemFontOfSize:M_FRONT_TWELEVE]
                                  };
    NSMutableAttributedString *attrituteString = [[[NSMutableAttributedString alloc] initWithString:str attributes:attributtes] autorelease];
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:frontColor], NSFontAttributeName : [UIFont fontWithName:@"Arial-BoldMT" size:size]} range:range];
    return attrituteString;
}
//未用
-(void)fillDataRedPacketUseTypeNoUse
{
    self.redPaketNameLabel.textColor = [CommonImage colorWithHexString:COLOR_333333];
  
    self.redPaketCategoryLabel.textColor = [CommonImage colorWithHexString:COLOR_333333];
  
    self.redPaketExpireLabel.textColor = [CommonImage colorWithHexString:COLOR_FF5351];
}

-(NSString *)createUnitStringWithDict:(NSDictionary *)dict
{
    int countType = [dict[@"unit"] intValue];
    NSString *unitString = @"积分";
    if (countType ==1)
    {
        unitString = @"RMB";
    }
    return unitString;
}
//已经用
-(void)fillDataRedPacketUseTypeUse
{
    self.redPaketExpireLabel.textColor = [CommonImage colorWithHexString:COLOR_999999];
    self.redPaketCategoryLabel.textColor = [CommonImage colorWithHexString:COLOR_999999];
    self.redPaketNameLabel.textColor = [CommonImage colorWithHexString:COLOR_999999];
}

//已过期
-(void)fillDataRedPacketUseTypeExpire
{
//    self.redPaketExpireLabel.text = @"已过期";
    self.redPaketExpireLabel.textColor = [CommonImage colorWithHexString:COLOR_999999];
    self.redPaketCategoryLabel.textColor = [CommonImage colorWithHexString:COLOR_999999];
    self.redPaketNameLabel.textColor = [CommonImage colorWithHexString:COLOR_999999];
}
@end
