//
//  ChartDataTableViewCell.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-25.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "ChartDataTableViewCell.h"

@implementation ChartDataTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)healthStepDataView
{
    int itemWidth = self.cellWidth/self.numberOfOneCell;
    //0 1 2 3 4 5
    
    
    UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, itemWidth, 40*self.numberOfRowInOneCell)];
    keyLabel.backgroundColor = [UIColor clearColor];
    keyLabel.numberOfLines = 0;
    keyLabel.tag = 999;
    keyLabel.font = [UIFont systemFontOfSize:14.0f];
    keyLabel.textColor = [CommonImage colorWithHexString:@"a9a9a9"];
    keyLabel.adjustsFontSizeToFitWidth = YES;
    keyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:keyLabel];
    [keyLabel release];
    
    CGFloat offsetY = 0;
    for(int j= 0; j < self.numberOfRowInOneCell;j++){
        
        offsetY = j * 40;
        for (int i = 1; i < self.numberOfOneCell; i++) {
            
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*itemWidth, offsetY, itemWidth, 40)];
            contentLabel.backgroundColor = [UIColor clearColor];
            //            contentLabel.numberOfLines = 0;
            contentLabel.tag = 100+j*10+i;
            contentLabel.font = [UIFont systemFontOfSize:14.0f];
            contentLabel.adjustsFontSizeToFitWidth = YES;
            contentLabel.textColor = [CommonImage colorWithHexString:@"333333"];
            contentLabel.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:contentLabel];
            [contentLabel release];
            if (i == 2) {
                CGRect rect = contentLabel.frame;
                rect.size.width = itemWidth+20;
                rect.origin.x -= 10;
                contentLabel.frame = rect;
            }
        }
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY-0.5, itemWidth, 0.5)];
        lineView.backgroundColor = [CommonImage colorWithHexString:@"e5e5e5"];
        [self.contentView addSubview:lineView];
        [lineView release];
        if(j < self.numberOfRowInOneCell -1){
            lineView.frame = CGRectMake(itemWidth, (j+1)*40-0.5, self.cellWidth-itemWidth, 0.5);
        }else{
            //最后一个
            lineView.frame = CGRectMake(0, (j+1)*40-0.5, self.cellWidth, 0.5);
            
        }
    }
    //
    //
    //
    //    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.5, 43.5, self.cellWidth-1, 0.5)];
    //    bottomView.backgroundColor = [UIColor lightGrayColor];
    //    [self.contentView addSubview:bottomView];
    //    [bottomView release];
    //    
    
    
    
}

- (void)healthDataView
{
    int itemWidth = self.cellWidth/self.numberOfOneCell;
    //0 1 2 3 4 5
    
    
    UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, itemWidth, 40*self.numberOfRowInOneCell)];
    keyLabel.backgroundColor = [UIColor clearColor];
    keyLabel.numberOfLines = 0;
    keyLabel.tag = 999;
    keyLabel.font = [UIFont systemFontOfSize:14.0f];
    keyLabel.textColor = [CommonImage colorWithHexString:@"333333"];
    keyLabel.adjustsFontSizeToFitWidth = YES;
    keyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:keyLabel];
    [keyLabel release];
    
    CGFloat offsetY = 0;
    for(int j= 0; j < self.numberOfRowInOneCell;j++){
    
        offsetY = j * 40;
        for (int i = 1; i < self.numberOfOneCell; i++) {
            
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*itemWidth, offsetY, itemWidth, 40)];
            contentLabel.backgroundColor = [UIColor clearColor];
//            contentLabel.numberOfLines = 0;
            contentLabel.tag = 100+j*10+i;
            contentLabel.font = [UIFont systemFontOfSize:14.0f];
            contentLabel.adjustsFontSizeToFitWidth = YES;
            contentLabel.textColor = [CommonImage colorWithHexString:@"666666"];
            contentLabel.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:contentLabel];
            [contentLabel release];
            if (i == 2) {
                CGRect rect = contentLabel.frame;
                rect.size.width = itemWidth+20;
                rect.origin.x -= 10;
                contentLabel.frame = rect;
            }
        }
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY-0.5, itemWidth, 0.5)];
        lineView.backgroundColor = [CommonImage colorWithHexString:@"e5e5e5"];
        [self.contentView addSubview:lineView];
        [lineView release];
        if(j < self.numberOfRowInOneCell -1){
            lineView.frame = CGRectMake(itemWidth, (j+1)*40-0.5, self.cellWidth-itemWidth, 0.5);
        }else{
        //最后一个
            lineView.frame = CGRectMake(0, (j+1)*40-0.5, self.cellWidth, 0.5);
            
        }
        
    }
//
//
//    
//    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.5, 43.5, self.cellWidth-1, 0.5)];
//    bottomView.backgroundColor = [UIColor lightGrayColor];
//    [self.contentView addSubview:bottomView];
//    [bottomView release];
//    
    
    
    
}

- (void)setkey:(NSString *)key valueArray:(NSArray *)valueArray
{
    
    [self.contentView removeAllSubviews];
    [self  healthDataView];
    
    UILabel *keyLabel = (UILabel *)[self.contentView viewWithTag:999];
    keyLabel.text = key;
    
    for(int j= 0; j < self.numberOfRowInOneCell;j++){
        for (int i = 1; i < self.numberOfOneCell; i++) {
             UILabel *valueLabel = (UILabel *)[self.contentView viewWithTag:100+j*10+i];
            
            NSString *oneRowString = valueArray[j];
            NSArray *valuesArray = [oneRowString componentsSeparatedByString:@"|"];
            valueLabel.text = valuesArray[i-1];
            
        }
    
    }

}

- (void)setStepKey:(NSString *)key valueArray:(NSArray *)valueArray
{
    [self.contentView removeAllSubviews];
    [self  healthStepDataView];
    UILabel *keyLabel = (UILabel *)[self.contentView viewWithTag:999];
    keyLabel.textColor = [CommonImage colorWithHexString:@"a9a9a9"];
    keyLabel.text = key;
    
    for(int j= 0; j < self.numberOfRowInOneCell;j++){
        NSString *oneRowString = valueArray[j];
        NSArray *valuesArray = [oneRowString componentsSeparatedByString:@"|"];
        for (int i = 1; i < self.numberOfOneCell; i++) {
            UILabel *valueLabel = (UILabel *)[self.contentView viewWithTag:100+j*10+i];
            
            NSString *valueString = valuesArray[i-1];
            NSArray *valueAndColorArray = [valueString componentsSeparatedByString:@"@"];
            NSString *colorString = @"333333";
            NSString *value = valueAndColorArray[0];
            if(valueAndColorArray.count == 2){
                colorString = [self getColorStringWithConstrast:valueAndColorArray[1]];
            }
            //            valueLabel.text = valuesArray[i-1];
            valueLabel.text = value;
            valueLabel.textColor = [CommonImage colorWithHexString:colorString];
            
        }
        
    }
    
}

- (void)setBloodPressKey:(NSString *)key valueArray:(NSArray *)valueArray
{
    [self.contentView removeAllSubviews];
    [self  healthDataView];
    UILabel *keyLabel = (UILabel *)[self.contentView viewWithTag:999];
     keyLabel.textColor = [CommonImage colorWithHexString:@"a9a9a9"];
    keyLabel.text = key;
    
    for(int j= 0; j < self.numberOfRowInOneCell;j++){
        NSString *oneRowString = valueArray[j];
        NSArray *valuesArray = [oneRowString componentsSeparatedByString:@"|"];
        for (int i = 1; i < self.numberOfOneCell; i++) {
            UILabel *valueLabel = (UILabel *)[self.contentView viewWithTag:100+j*10+i];
            
            NSString *valueString = valuesArray[i-1];
            NSArray *valueAndColorArray = [valueString componentsSeparatedByString:@"@"];
            NSString *colorString = @"666666";
            NSString *value = valueAndColorArray[0];
            if(valueAndColorArray.count == 2){
                colorString = [self getColorStringWithConstrast:valueAndColorArray[1]];
            }
//            valueLabel.text = valuesArray[i-1];
            valueLabel.text = value;
            valueLabel.textColor = [CommonImage colorWithHexString:colorString];
            
        }
        
    }

}

- (void)setWeightsKey:(NSString *)key valueArray:(NSArray *)valueArray uid:(NSString *)uid
{
    [self.contentView removeAllSubviews];
    [self  healthDataView];
    UILabel *keyLabel = (UILabel *)[self.contentView viewWithTag:999];
    keyLabel.textColor = [CommonImage colorWithHexString:@"a9a9a9"];
    keyLabel.text = key;
    
    for(int j= 0; j < self.numberOfRowInOneCell;j++){
        NSString *oneRowString = valueArray[j];
        NSArray *valuesArray = [oneRowString componentsSeparatedByString:@"|"];
        for (int i = 1; i < self.numberOfOneCell; i++) {
            UILabel *valueLabel = (UILabel *)[self.contentView viewWithTag:100+j*10+i];
            
            NSString *valueString = valuesArray[i-1];
            NSString *colorString = @"666666";
            if(i == 1){
                NSString *constrast = [NSString stringWithFormat:@"%d",[self setWeightAndHeigh:valueString.intValue userId:uid]];
                colorString = [self getColorStringWithConstrast:constrast];
            }
            //            valueLabel.text = valuesArray[i-1];
            valueLabel.text = valueString;
            valueLabel.textColor = [CommonImage colorWithHexString:colorString];
        }
        
    }
    
}

//分析体重是否正常  1.高，2.正常，3.低
- (int)setWeightAndHeigh:(int)y userId:(NSString*)Uid
{
    CGFloat h;
    if ([Uid isEqualToString:g_nowUserInfo.userid]) {
        h = g_nowUserInfo.height*g_nowUserInfo.height/100/100;
    }else{
        for (int i=0; i<g_familyList.count; i++) {
            if ([g_familyList[i][@"id"] isEqualToString:Uid]) {
                h = [g_familyList[i][@"hight"] intValue]*[g_familyList[i][@"hight"] intValue]/100/100;
                break;
            }
        }
    }
    int bmi = y/h;
    int temp = 2;
    if (bmi<19) {
        temp = 3;
    }else if(bmi>24)
    {
        temp = 1;
    }
    return temp;
}


- (NSString *)getColorStringWithConstrast:(NSString *)constrast
{
    int constrastInt = constrast.intValue;
    NSString *colorString = @"666666";
    
    switch (constrastInt) {
        case 1:
            colorString = @"fd8989";
            break;
        case 2:
            colorString = @"666666";
            break;
        case 3:
            colorString = @"33b3e8";
        default:
            break;
    }
    return colorString;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
