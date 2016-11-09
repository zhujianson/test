//
//  SportsLibraryTableViewCell.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-7.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "SportsLibraryTableViewCell.h"

@implementation SportsLibraryTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UILabel * nameLable = [Common createLabel:CGRectMake(20, 0, 80, 50) TextColor:@"333333" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft labTitle:nil];
        nameLable.tag = 1;
        [self addSubview:nameLable];
        
        UILabel * unitLable = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 100, 50)];
        unitLable.textColor = [CommonImage colorWithHexString:@"999999"];
        unitLable.textAlignment = NSTextAlignmentLeft;
        unitLable.font = [UIFont systemFontOfSize:15];
        unitLable.text = @"卡／30分钟";
        [self addSubview:unitLable];
        [unitLable release];

        UILabel * numLable = [Common createLabel:CGRectMake(88, 0, 40, 50) TextColor:@"E75441" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentRight labTitle:nil];
        numLable.tag = 2;
        [self addSubview:numLable];
        
        
    }
    return self;
}

- (void)setNumberAndName:(NSString*)name num:(NSString*)num
{
    UILabel * lab;
    for (int i =1; i<3; i++) {
        lab = (UILabel*)[self viewWithTag:i];
        if (i==1) {
            lab.text = name;
        }else{
            lab.text = num;
        }
    }
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
