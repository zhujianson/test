//
//  SportsTypeTableViewCell.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-21.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "SportsTypeTableViewCell.h"

@implementation SportsTypeTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _backView =
        [[UIView alloc] initWithFrame:CGRectMake(10, 0, kDeviceWidth-20, 210)];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 4;
        _backView.layer.borderWidth = 0.5;
        _backView.layer.borderColor =
        [[CommonImage colorWithHexString:@"DADADA"] CGColor];
        
        [self addSubview:_backView];
        [_backView release];
        
        UIImageView* backImage =
        [[UIImageView alloc] initWithFrame:CGRectMake(10, 38, kDeviceWidth-40, 156)];
        backImage.tag = 110;
//        backImage.backgroundColor = [UIColor redColor];
        [_backView addSubview:backImage];
        [backImage release];

        UILabel* titleLable = [Common createLabel:CGRectMake(10, 0, kDeviceWidth-120, 40)
                                        TextColor:@"333333"
                                             Font:[UIFont systemFontOfSize:17]
                                    textAlignment:NSTextAlignmentLeft
                                         labTitle:nil];
        titleLable.tag = 1;
        [_backView addSubview:titleLable];

    }
    return self;
}

- (void)setDataForCell:(NSDictionary*)dic row:(int)row
{
    UILabel* lable;
    lable = (UILabel*)[self viewWithTag:1];
    lable.text = dic[@"CATALOG"];
//    test_image3@2x.png
    
    UIImageView * view = (UIImageView*)[self viewWithTag:110];
    view.image = [UIImage imageNamed:[NSString stringWithFormat:@"common.bundle/common/BigImage/test1_image%d.png",row]];
    
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
