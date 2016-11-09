//
//  MyMessageTableViewCell.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-18.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "MyMessageTableViewCell.h"
#import "MyMessageViewController.h"
//#import "RichTextView.h"

@implementation MyMessageTableViewCell
{
     MLEmojiLabel *m_commentTitle;
}
@synthesize m_headerView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        m_headerView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        m_headerView.layer.cornerRadius = 40/2;
        m_headerView.clipsToBounds = YES;
        m_headerView.image = [UIImage imageNamed:@"common.bundle/common/center_my-family_head_icon.png"];
        [self.contentView addSubview:m_headerView];
        m_headerView.tag = 1;
        
        UILabel * timeLab = [Common createLabel:CGRectMake(kDeviceWidth-85, m_headerView.frame.origin.y, 80, 20) TextColor:@"999999" Font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentRight labTitle:nil];
        timeLab.tag = 3;
        [self.contentView addSubview:timeLab];
        
        UILabel * nameLab = [Common createLabel:CGRectMake(60, m_headerView.frame.origin.y, timeLab.left-60, 20) TextColor:@"333333" Font:[UIFont systemFontOfSize:M_FRONT_EIGHTEEN] textAlignment:NSTextAlignmentLeft labTitle:nil];
        nameLab.tag = 2;
        [self.contentView addSubview:nameLab];
        
//        UILabel * dataLab = [Common createLabel:CGRectMake(nameLab.frame.origin.x, nameLab.height+10, kDeviceWidth-80, 20) TextColor:@"999999" Font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentLeft labTitle:nil];
//        dataLab.numberOfLines = 0;
//        dataLab.tag = 4;
//        [self addSubview:dataLab];
        m_commentTitle = [[MLEmojiLabel alloc] initWithFrame:CGRectMake(nameLab.left, nameLab.bottom+10, kDeviceWidth-80, 30)];
        m_commentTitle.numberOfLines = 0;
        m_commentTitle.tag = 4;
        m_commentTitle.font = [UIFont systemFontOfSize:M_FRONT_SIXTEEN];
        m_commentTitle.lineBreakMode = NSLineBreakByCharWrapping;
        m_commentTitle.isNeedAtAndPoundSign = YES;
        m_commentTitle.disableThreeCommon = YES;
        m_commentTitle.textColor = [CommonImage colorWithHexString:@"999999"];
        m_commentTitle.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        m_commentTitle.customEmojiPlistName = @"expression.plist";
        [self.contentView addSubview:m_commentTitle];
        
        UIImageView * redImage = [[UIImageView alloc]initWithFrame:CGRectMake(m_headerView.frame.origin.x+25, m_headerView.frame.origin.y-3, 15, 15)];
        redImage.image = [UIImage imageNamed:@"common.bundle/topic/conversation_icon_redpoint.png"];
        redImage.tag = 5;
        [self.contentView addSubview:redImage];
        [redImage release];
        
    }
    return self;
}

-(void)hiddenRedImage
{
    UIImageView * header;
    header = (UIImageView*)[self viewWithTag:5];
    header.hidden = YES;
}

-(void)dealloc
{
    [m_commentTitle release];
    [m_headerView release];
    [super dealloc];
}

- (void)setMessageData:(NSDictionary*)dic
{
    UIImageView * header;
    header = (UIImageView*)[self viewWithTag:5];
    if ([dic[@"isRead"] boolValue]) {
        header.hidden = YES;
    }else{
        header.hidden = NO;
    }
    UILabel * lab;
    for (int i = 1; i<5; i++) {
        switch (i) {
            case 1:
                header = (UIImageView*)[self.contentView viewWithTag:i];
                break;
            case 2:
                lab = (UILabel*)[self.contentView viewWithTag:i];
                lab.text = dic[@"nickName"];
                break;
            case 3:
                lab = (UILabel*)[self.contentView viewWithTag:i];
                lab.text = [CommonDate getServerTime:([dic[@"createTime"] longLongValue]/1000) type:3];
                break;
            case 4:
            {
//              CGFloat heigt = [Common heightForString:dic[@"content"] Width:(kDeviceWidth-80) Font:[UIFont systemFontOfSize:15]].height;
                lab = (MLEmojiLabel*)[self.contentView viewWithTag:i];
                float hightContent = 0;
//                hightContent = [dic[kTextHeight] floatValue];
                lab.frameHeight = hightContent;
                [(MLEmojiLabel*)lab setEmojiText:dic[@"content"]];
            }
                break;
            default:
                break;
        }
    }
}

//行高
+(float)getCellHeightWithDict:(NSMutableDictionary *)dict withHandler:(id)handler
{
    float kContentWeight = kDeviceWidth-80;
    float cellHeight = 40;
    
    NSString *str = dict[@"content"];
    float contentHeight = [(MyMessageViewController *)handler getContentHeightWithDict:dict withKeyConentString:str withContentWidth:kContentWeight ];
    cellHeight += contentHeight+10;
    return cellHeight;
}

@end
