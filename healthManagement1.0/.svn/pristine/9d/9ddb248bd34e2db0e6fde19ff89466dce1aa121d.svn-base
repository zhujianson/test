//
//  KXPayManageViewCell.m
//  jiuhaohealth4.2
//
//  Created by jiuhao-yangshuo on 15/12/21.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "KXPayManageViewCell.h"

@implementation KXPayManageViewCell
{
    UILabel *nameLable;
    UIImageView * headerImage;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        float spaceImageW = 25.0;
        headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, (kKXPayManageViewCellH-spaceImageW)/2.0, spaceImageW, spaceImageW)];
        headerImage.layer.cornerRadius = headerImage.width/2.0;
        headerImage.clipsToBounds = YES;
//        headerImage.image = [UIImage imageNamed:@"common.bundle/common/center_my-family_head_icon.png"];
        [self.contentView addSubview:headerImage];
        
        nameLable = [Common createLabel:CGRectMake(headerImage.right+10, 0,kDeviceWidth-headerImage.right-10-headerImage.left, kKXPayManageViewCellH) TextColor:@"333333" Font:[UIFont systemFontOfSize:M_FRONT_SIXTEEN] textAlignment:NSTextAlignmentLeft labTitle:@"123"];
        [self.contentView addSubview:nameLable];
    }
    return self;
}

- (void)dealloc
{
//    [headerImage release];
    nameLable = nil;
    headerImage = nil;
//    [super dealloc];
}

-(void)setM_dict:(NSDictionary *)m_dict
{
    headerImage.image = [UIImage imageNamed:m_dict[kImagePath]];
    nameLable.text = m_dict[kImageTitle];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
