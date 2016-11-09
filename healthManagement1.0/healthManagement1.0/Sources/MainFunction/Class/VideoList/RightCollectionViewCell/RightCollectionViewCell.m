//
//  RightCollectionViewCell.m
//  Group
//
//  Created by randy on 16/3/1.
//  Copyright © 2016年 Randy. All rights reserved.
//

#import "RightCollectionViewCell.h"


#define Cell_H (55+190/2*kDeviceWidth/375)
@implementation RightCollectionViewCell


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0,frame.size.height>Cell_H?8:0, self.size.width, CGRectGetHeight(frame)-55)];
        _imageview.contentMode = UIViewContentModeScaleAspectFill;
        _imageview.clipsToBounds = YES;
        [self addSubview:_imageview];
        
        _viedoType = [[UIImageView alloc]initWithFrame:CGRectMake(_imageview.width-65/2, 0, 65/2, 65/2)];
        [_imageview addSubview:_viedoType];

        _titleLabel = [Common createLabel:CGRectMake(_imageview.left, _imageview.bottom+11, _imageview.width, 15) TextColor:@"000000" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft labTitle:nil];
        [self addSubview:_titleLabel];

        UIImage * image = [UIImage imageNamed:@"common.bundle/home/spark"];
        _sparkImage = [[UIImageView alloc]initWithFrame:CGRectMake(_imageview.left, _titleLabel.bottom+5, image.size.width, image.size.height)];
        _sparkImage.image = image;
        _sparkImage.contentMode = UIViewContentModeLeft;
        [self addSubview:_sparkImage];

        _readingLab = [Common createLabel:CGRectMake(_sparkImage.right+5, _sparkImage.top, _titleLabel.width-_sparkImage.right, 12) TextColor:@"ff654c" Font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft labTitle:nil];
        [self addSubview:_readingLab];
    }

    return self;
}

@end




@implementation DescCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _titleLabel = [Common createLabel];
        self.titleLabel.frame = CGRectMake(15, 0, CGRectGetWidth(frame)-30, frame.size.height);
        self.titleLabel.tag = 300;
//        self.titleLabel.backgroundColor = [UIColor redColor];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textColor = [CommonImage colorWithHexString:@"666666"];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.text = @"太平吉象有幸邀请到中医协会主席黄老邪，著名体质调理专家给大家做这一次的线上讲座。本次主要针对亚健康人群，白领上班族常见的一些身体不适做了一些中医方面的建议……";
        [self addSubview:self.titleLabel];
    }
    
    return self;
}

@end