//
//  LookingDoctorCell.m
//  jiuhaohealth4.0
//
//  Created by xjs on 15/5/12.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "LookingDoctorCell.h"

@implementation LookingDoctorCell
{
    UILabel * m_nameLabel;
    UILabel * m_hospitalLabel;
    UILabel * m_diseaseLabel;
    UIButton * invitationBtn;
}
@synthesize m_headerView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)dealloc
{
    [m_headerView release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        m_headerView = [[UIImageView alloc]init];
        m_headerView.clipsToBounds = YES;
        m_headerView.backgroundColor = [UIColor redColor];
        m_headerView.contentMode = UIViewContentModeScaleAspectFill;
        m_headerView.frame = CGRectMake(15, 10, 60, 60);
        m_headerView.layer.cornerRadius = m_headerView.width/2.0;
        [self.contentView addSubview:m_headerView];
        
        m_nameLabel = [Common createLabel:CGRectMake(m_headerView.right+15, m_headerView.top, kDeviceWidth-75-80, 20) TextColor:@"333333" Font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentLeft labTitle:nil];
        [self.contentView addSubview:m_nameLabel];
        
        m_hospitalLabel = [Common createLabel:CGRectMake(m_nameLabel.left, m_nameLabel.bottom, m_nameLabel.width, 20) TextColor:@"999999" Font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft labTitle:@"青岛市第一人民医院（内分泌科）"];
        [self.contentView addSubview:m_hospitalLabel];
        
        m_diseaseLabel = [Common createLabel:CGRectMake(m_nameLabel.left, m_hospitalLabel.bottom, m_nameLabel.width, 20) TextColor:@"999999" Font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft labTitle:@"II型糖尿病与肾病综合症治疗，心脑血管"];
        [self.contentView addSubview:m_diseaseLabel];
        
        invitationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        invitationBtn.frame = CGRectMake(kDeviceWidth-50-15, 24, 50, 28);
        invitationBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        invitationBtn.layer.cornerRadius = 4;
        invitationBtn.clipsToBounds = YES;
        [invitationBtn addTarget:self action:@selector(invitation:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:invitationBtn];

        
    }
    return self;
}

- (void)invitation:(UIButton*)addBtn
{
    m_block(nil);
    
    [addBtn setTitleColor:[CommonImage colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [addBtn setTitle:NSLocalizedString(@"已邀请", nil) forState:UIControlStateNormal];
    addBtn.userInteractionEnabled = NO;
    UIImage* image =  [CommonImage createImageWithColor:[UIColor clearColor]];
    [addBtn setBackgroundImage:image forState:UIControlStateNormal];

}

- (void)setData:(NSMutableDictionary*)dic
{
    if ([dic[@"rankName"] length]) {
        m_nameLabel.attributedText = [self replaceRedColorWithNSString:[NSString stringWithFormat:@"%@ (%@)",dic[@"nickName"],dic[@"rankName"]] andUseKeyWord:[NSString stringWithFormat:@"(%@)",dic[@"rankName"]] andWithFontSize:12 TextColor:@"666666"];
    }else{
        m_nameLabel.text = dic[@"nickName"];
    }
    if ([dic[@"hospital"] length]) {
        if ([dic[@"department"] length]) {
            m_hospitalLabel.text = [NSString stringWithFormat:@"%@ (%@)",dic[@"hospital"],dic[@"department"]];
        }else{
            m_hospitalLabel.text = dic[@"hospital"];
        }
    }else{
        m_hospitalLabel.text = dic[@"department"];
    }
    m_diseaseLabel.text = dic[@"professional"];

    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
    if (![dic[@"is_invitation"] intValue]) {
        [invitationBtn setTitleColor:[CommonImage colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        [invitationBtn setTitle:NSLocalizedString(@"邀请", nil) forState:UIControlStateNormal];
        invitationBtn.userInteractionEnabled = YES;
        invitationBtn.layer.borderWidth = 0;
        [invitationBtn setBackgroundImage:image forState:UIControlStateNormal];
    }else{
        [invitationBtn setTitleColor:[CommonImage colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [invitationBtn setTitle:NSLocalizedString(@"已邀请", nil) forState:UIControlStateNormal];
        invitationBtn.userInteractionEnabled = NO;
        invitationBtn.layer.borderWidth = 0.5;
        invitationBtn.layer.borderColor = [CommonImage colorWithHexString:LINE_COLOR].CGColor;
        image =  [CommonImage createImageWithColor:[UIColor clearColor]];
        [invitationBtn setBackgroundImage:image forState:UIControlStateNormal];
    }
}

- (void)setPickerImage:(UIImage*)image
{
    m_headerView.image = image;
}

- (void)setLookingDoctorBlock:(LookingDoctorBlock)look
{
    m_block = [look copy];
}

//描红
- (NSMutableAttributedString *)replaceRedColorWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )s TextColor:(NSString*)coler
{
    NSMutableAttributedString *attrituteString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:coler], NSFontAttributeName : [UIFont systemFontOfSize:s]} range:range];
    return attrituteString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
