//
//  TheAgentTableViewCell.m
//  healthManagement1.0
//
//  Created by xjs on 16/7/21.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "TheAgentTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation TheAgentTableViewCell
{
    UIImageView * headerImage;
    UILabel * nameLab;
    UILabel * phoneLab;
}
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(25, 20, 50, 50)];
        headerImage.layer.cornerRadius = headerImage.width/2;
        [self addSubview:headerImage];
        
        nameLab = [Common createLabel:CGRectMake(headerImage.right+10, headerImage.top, kDeviceWidth-headerImage.right-10, 25) TextColor:@"000000" Font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentLeft labTitle:nil];
        [self addSubview:nameLab];
        
        phoneLab = [Common createLabel:CGRectMake(headerImage.right+10, nameLab.bottom, kDeviceWidth-headerImage.right-10, 25) TextColor:@"999999" Font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft labTitle:nil];
        [self addSubview:phoneLab];

        
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setAgentInfo:(NSDictionary*)dic
{
    UIImage *defaul = [UIImage imageNamed:@"common.bundle/common/center_my-family_head_icon.png"];
    [headerImage sd_setImageWithURL:[NSURL URLWithString:dic[@"pictureUrl"]] placeholderImage:defaul];
    
    nameLab.text = dic[@"name"];
    phoneLab.text = [NSString stringWithFormat:@"手机号:%@",dic[@"mobile"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
