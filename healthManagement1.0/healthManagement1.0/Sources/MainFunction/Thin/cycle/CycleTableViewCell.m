//
//  CycleTableViewCell.m
//  healthManagement1.0
//
//  Created by xjs on 16/6/2.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "CycleTableViewCell.h"

@implementation CycleTableViewCell
{
    UIImageView * m_logoImage;
    UILabel * m_nameLab;
    UILabel * m_type;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        m_logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 29/2, 21, 21)];
        m_logoImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:m_logoImage];

        m_nameLab = [Common createLabel:CGRectMake(15, 0, 200, 50) TextColor:@"666666" Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft labTitle:nil];
        [self.contentView addSubview:m_nameLab];
        
        m_type = [Common createLabel:CGRectMake(kDeviceWidth-150/2, 25/2, 60, 25) TextColor:@"666666" Font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter labTitle:nil];
        [self.contentView addSubview:m_type];
        m_type.layer.borderWidth = 0.5;
        m_type.clipsToBounds = YES;
        m_type.layer.cornerRadius = 4;
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellInfo:(NSString*)dic week:(NSString*)week
{
    
    m_logoImage.hidden = YES;
    m_type.hidden = NO;
    m_nameLab.font = [UIFont systemFontOfSize:16];
    m_nameLab.frame = [Common rectWithOrigin:m_nameLab.frame x:15 y:0];
    if ([dic rangeOfString:@","].location ==NSNotFound) {
        m_logoImage.hidden = NO;
        m_nameLab.font = [UIFont systemFontOfSize:14];
        m_nameLab.frame = [Common rectWithOrigin:m_nameLab.frame x:45 y:0];
        m_type.hidden = YES;
//        [CommonImage setImageFromServer:nil View:m_logoImage Type:2];
        [self setlocnImage:dic];
        m_nameLab.text = dic;
    }else{
        NSArray * arr = [dic componentsSeparatedByString:@","];
        [self setLabType:[arr[1] intValue] lab:m_type];
        m_nameLab.text = [NSString stringWithFormat:@"第%@周",week];
    }
}

- (void)setlocnImage:(NSString*)str
{
    if ([str isEqualToString:@"准备期"]) {
        m_logoImage.image =k_fetchImage(@"recently1");
    }else if([str isEqualToString:@"强化期"]){
        m_logoImage.image =k_fetchImage(@"recently2");
    }else{
        m_logoImage.image =k_fetchImage(@"recently3");
    }
}


- (void)setLabType:(int)type lab:(UILabel*)lab
{
    lab.backgroundColor = [UIColor clearColor];
    switch (type) {
        case 0:
            lab.text = @"未开始";
            lab.textColor = [CommonImage colorWithHexString:@"cccccc"];
            break;
        case 1:
            lab.text = @"进行中";
            lab.textColor = [CommonImage colorWithHexString:@"ffffff"];
            lab.backgroundColor = [CommonImage colorWithHexString:@"2bd45b"];
            break;
        case 2:
            lab.text = @"已完成";
            lab.textColor = [CommonImage colorWithHexString:@"ffb525"];
            break;
        default:
            break;
    }
    lab.layer.borderColor = lab.textColor.CGColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
