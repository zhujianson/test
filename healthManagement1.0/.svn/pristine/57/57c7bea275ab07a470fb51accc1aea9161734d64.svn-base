//
//  FriendApplyCell.m
//  jiuhaohealth3.0
//
//  Created by jiuhao-yangshuo on 15-3-9.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "FriendApplyCell.h"

@implementation FriendApplyCell
{
    UILabel *m_contentTitle;
   
    FriendApplyCellBlock _inBlock;
}
@synthesize m_headerView,m_addButton,m_nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        m_headerView = [[UIImageView alloc]init];
        m_headerView.clipsToBounds = YES;
        m_headerView.frame = CGRectMake(10, 10, 40, 40);
        m_headerView.layer.cornerRadius = m_headerView.width/2.0;
        [self.contentView addSubview:m_headerView];
        
        m_nameLabel = [Common createLabel:CGRectMake(m_headerView.right+10, m_headerView.top, 190, 20) TextColor:@"333333" Font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentLeft labTitle:@"123"];
        [self.contentView addSubview:m_nameLabel];
        
        m_contentTitle = [Common createLabel:CGRectMake(m_nameLabel.left, m_nameLabel.bottom+3, kDeviceWidth-m_nameLabel.left, 20) TextColor:@"999999" Font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft labTitle:@"123"];
        [self.contentView addSubview:m_contentTitle];
        
        m_addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        m_addButton.frame = CGRectMake(kDeviceWidth - 15-50,0, 50, 25);
        UIImage *image = [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"2fcd58"]];
        [m_addButton setBackgroundImage:image forState:UIControlStateNormal];
        [m_addButton addTarget:self action:@selector(btnAcceptClick:) forControlEvents:UIControlEventTouchUpInside];
        [m_addButton setTitleColor:[CommonImage colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
         m_addButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:m_addButton];
        
        m_addButton.center = CGPointMake(m_addButton.center.x, m_headerView.center.y);
    }
    return self;
}

- (void)dealloc
{
    [m_headerView release];
    m_nameLabel  = nil;
    m_contentTitle = nil;
    [_inBlock release];
    [super dealloc];
}

- (void)setInfoDic:(NSMutableDictionary *)dic with:(FriendApplyCellBlock)_handler
{
    _inBlock = [_handler copy];
//     m_nameLabel.text = dic[@"nickName"];
    m_nameLabel.text = [dic[@"markName"] length]? dic[@"markName"]:dic[@"nickName"];
    if (!m_nameLabel.text.length)
    {
        m_nameLabel.text = @"新的朋友";
        [dic setObject:m_nameLabel.text forKey:@"nickName"];
    }
    NSString *content = dic[@"content"];//备注
    m_contentTitle.text = content.length?content:@"请求添加您为好友";
    
    NSString *dfsf;
     //0:申请 1:接受 2:拒绝 3:过期 4:删除
    int applyType = [dic[@"flag"] intValue];
    if (!applyType)
    {
//      m_addButton.selected = NO;
        m_addButton.layer.cornerRadius = 2.5f;
        m_addButton.clipsToBounds = YES;
        m_addButton.enabled = YES;
        
        dfsf = @"接受";
    }
    else if (applyType == 1) {
        dfsf = @"已接受";
        [self changeMaddButtonState];
    }
    else
    {
        [self changeMaddButtonState];
    }
    [m_addButton setTitle:@"接受" forState:UIControlStateNormal];
}

///  改变申请状态
- (void)changeMaddButtonState
{
     m_addButton.enabled = NO;
    [m_addButton setTitle:@"已添加" forState:UIControlStateNormal];
    [m_addButton setTitleColor:[CommonImage colorWithHexString:@"999999"] forState:UIControlStateNormal];
    UIImage *image = [CommonImage createImageWithColor:[CommonImage colorWithHexString:@"ffffff"]];
    [m_addButton setBackgroundImage:image forState:UIControlStateNormal];
    
}

- (void)btnAcceptClick:(UIButton *)btn
{
    _inBlock();
}

@end


