//
//  ReportCollectionViewCell.m
//  healthManagement1.0
//
//  Created by xjs on 16/7/12.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "ReportCollectionViewCell.h"

@implementation ReportCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        UIView * view= [[UIView alloc]initWithFrame:CGRectMake(0, 15, self.size.width, self.size.height-15)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 4;
//        view.clipsToBounds = YES;//
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowRadius = 4.f;
        view.layer.shadowOffset = CGSizeMake(0.f, 0.f);
        view.layer.shadowOpacity = 0.05;

        [self addSubview:view];
        
        _sparkImage = [[UIImageView alloc]initWithFrame:CGRectMake(42, 20, 80, 90)];
        _sparkImage.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:_sparkImage];
        _sparkImage.center = CGPointMake(view.width/2, (view.height-55)/2);

        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(12, (int)(view.height-55), view.width-24, 0.5)];
        lineView.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
        [view addSubview:lineView];
        
        _titleLabel = [Common createLabel:CGRectMake(0, lineView.bottom+9, view.width, 20) TextColor:@"000000" Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentCenter labTitle:nil];
        [view addSubview:_titleLabel];
        
        _timeLab = [Common createLabel:CGRectMake(_titleLabel.left, _titleLabel.bottom, _titleLabel.width, 15) TextColor:@"999999" Font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentCenter labTitle:nil];
        [view addSubview:_timeLab];
        
    }
    
    return self;
}

@end