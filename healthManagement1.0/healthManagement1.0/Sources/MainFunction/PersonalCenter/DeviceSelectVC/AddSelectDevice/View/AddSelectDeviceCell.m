//
//  AddSelectDeviceCell.m
//  healthManagement1.0
//
//  Created by jiuhao-yangshuo on 16/2/23.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "AddSelectDeviceCell.h"

@implementation AddSelectDeviceCell
{
    UILabel *nameLable;
    UIImageView * headerImage;
    UIView *m_backView;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, kDeviceWidth-60, kAddSelectDeviceCellH-15)];
        [self.contentView addSubview:backView];
        m_backView = backView;
        backView.layer.cornerRadius = 2.5;
        backView.layer.masksToBounds = YES;
        backView.layer.borderColor = [CommonImage colorWithHexString:@"dcdcdc"].CGColor;
        backView.layer.borderWidth = 0.5;
        
        float spaceImageW = backView.height-2*10.0;
        headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, (backView.height-spaceImageW)/2.0, spaceImageW, spaceImageW)];
        headerImage.clipsToBounds = YES;
//        headerImage.backgroundColor = [UIColor redColor];
        [backView addSubview:headerImage];
        
        nameLable = [Common createLabel:CGRectMake(headerImage.right+15, headerImage.top,kDeviceWidth-headerImage.right-30, headerImage.frameHeight) TextColor:@"333333" Font:[UIFont systemFontOfSize:M_FRONT_SEVENTEEN] textAlignment:NSTextAlignmentLeft labTitle:@"123"];
        [backView addSubview:nameLable];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor =[CommonImage colorWithHexString:@"f5f5f5"];
    }
    return self;
}

- (void)dealloc
{
    nameLable = nil;
    headerImage = nil;
}

-(void)setM_deviceModel:(DeviceModel *)m_deviceModel
{
    headerImage.image = [UIImage imageNamed:m_deviceModel.deviceImage];
    nameLable.text = m_deviceModel.deviceName;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    m_backView.backgroundColor = [CommonImage colorWithHexString:highlighted? @"ebebeb":@"ffffff"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    m_backView.backgroundColor = [CommonImage colorWithHexString:selected? @"ebebeb":@"ffffff"];
    // Configure the view for the selected state
}

@end
