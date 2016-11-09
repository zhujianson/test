//
//  StepHomeCell.m
//  jiuhaohealth4.0
//
//  Created by jiuhao-yangshuo on 15-4-22.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "StepHomeCell.h"

@implementation StepHomeCell
{
    UILabel * m_labTitle;
    UILabel * m_labTitleContent;
}

@synthesize indexCellModel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        m_labTitle = [Common createLabel:CGRectMake(15, 0, 100, 45) TextColor:@"333333" Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft labTitle:nil];
        [self.contentView addSubview:m_labTitle];
        
        m_labTitleContent = [Common createLabel:CGRectMake(m_labTitle.right , 0, kDeviceWidth-m_labTitle.right-35, 45) TextColor:@"999999" Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentRight labTitle:nil];
        [self.contentView addSubview:m_labTitleContent];
        
        UIImage*  rightImage = [UIImage imageNamed:@"common.bundle/diary/entrance_btn_right-arrow_normal.png"];
        UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-15-rightImage.size.width, (m_labTitleContent.height-rightImage.size.height)/2.0, rightImage.size.width, rightImage.size.height)];
        rightImageView.image = rightImage;
        [self.contentView addSubview:rightImageView];
        [rightImageView release];
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

-(void)setIndexCellModel:(CellModel *)indexModel
{
    m_labTitle.text = indexModel.cellModelTitle;
    if ([indexModel.cellModelTitle isEqualToString: @"计步人数 / 目前排名"])
    {
        CGSize size =  [Common heightForString:indexModel.cellModelTitle Width:kDeviceWidth Font:[UIFont systemFontOfSize:16.0]];
        m_labTitle.frameWidth = size.width;
    }
//    NSString *count = [dic objectForKey:@"todayPostsCount"];
//    NSString *strPostsCount = [NSString stringWithFormat:@"今日贴数%@", count];
    m_labTitleContent.text = indexModel.cellModelContent;
}

@end
