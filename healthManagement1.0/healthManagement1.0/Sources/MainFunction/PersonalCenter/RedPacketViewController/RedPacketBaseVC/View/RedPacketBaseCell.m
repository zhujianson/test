//
//  RedPacketBaseCell.m
//  jiuhaohealth4.2
//
//  Created by jiuhao-yangshuo on 15/12/11.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "RedPacketBaseCell.h"

@implementation RedPacketBaseCell
{
    UIView *backView;
}
@synthesize redPaketCategoryLabel;
@synthesize redPaketExpireLabel;
@synthesize redPaketImageView;
@synthesize redPaketNameLabel;
@synthesize moneyCountLabel;
@synthesize moneyUseDescriptionLabel;
@synthesize m_dictInfo;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self getCellSubViews];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)getCellSubViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor =[CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR2];
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kRedPacketCellH)];
    backView.backgroundColor = [CommonImage colorWithHexString:@"ffffff"];
    [self.contentView addSubview:backView];
    
    redPaketImageView = [[UIImageView alloc]init];
    redPaketImageView.frame = CGRectMake(kRedPacketLeftMargin, kRedPacketTopMargin, 270/2.0, backView.height-2*kRedPacketTopMargin);
    [backView addSubview:redPaketImageView];
    
    float kMoneyCountLabelW = 115/2.0;
    moneyCountLabel = [Common createLabel:CGRectMake(kRedPacketLeftMargin, redPaketImageView.top, kMoneyCountLabelW, redPaketImageView.height) TextColor:@"ffffff" Font:[UIFont systemFontOfSize:M_FRONT_THIRTY] textAlignment:NSTextAlignmentCenter labTitle:@""];
    moneyCountLabel.text = @"30\n积分";
    moneyCountLabel.numberOfLines = 0;
    [backView addSubview:moneyCountLabel];
    
    moneyUseDescriptionLabel = [Common createLabel:CGRectMake(moneyCountLabel.right, moneyCountLabel.top ,redPaketImageView.width-moneyCountLabel.width, moneyCountLabel.height) TextColor:@"ffffff" Font:[UIFont systemFontOfSize:M_FRONT_FOURTEEN] textAlignment:NSTextAlignmentCenter labTitle:@""];
    moneyUseDescriptionLabel.text = @"无门槛\n使 用";
    moneyUseDescriptionLabel.numberOfLines = 0;
    [backView addSubview:moneyUseDescriptionLabel];
    
    float labelH = redPaketImageView.height/3.0;
    redPaketNameLabel = [Common createLabel:CGRectMake(redPaketImageView.right + kRedPacketImageToLabelSpace, moneyCountLabel.top ,backView.width-kRedPacketLeftMargin-redPaketImageView.right - kRedPacketImageToLabelSpace, labelH) TextColor:COLOR_333333 Font:[UIFont systemFontOfSize:M_FRONT_SIXTEEN] textAlignment:NSTextAlignmentLeft labTitle:@""];
    redPaketNameLabel.text = @"123";
    [backView addSubview:redPaketNameLabel];
    
    redPaketCategoryLabel = [Common createLabel:CGRectMake(redPaketNameLabel.left, redPaketNameLabel.bottom , redPaketNameLabel.width,labelH) TextColor:COLOR_666666 Font:[UIFont systemFontOfSize:M_FRONT_THREETEEN] textAlignment:NSTextAlignmentLeft labTitle:@""];
    redPaketCategoryLabel.text = @"123";
    [backView addSubview:redPaketCategoryLabel];
    
    redPaketExpireLabel = [Common createLabel:CGRectMake(redPaketNameLabel.left, redPaketCategoryLabel.bottom  , redPaketCategoryLabel.width, labelH) TextColor:COLOR_FF5351 Font:[UIFont systemFontOfSize:M_FRONT_THREETEEN] textAlignment:NSTextAlignmentLeft labTitle:@""];
    redPaketExpireLabel.text = @"123";
    [backView addSubview:redPaketExpireLabel];
}

-(void)setUpDict:(NSDictionary *)dict withModelType:(RedPacketUseType)m_redPacketUseType
{
    self.m_dictInfo = dict;
    BOOL stateCanUse = m_redPacketUseType == RedPacketUseTypeNoUse?YES:NO;
    [self setUpRedPaketImageViewPicetureWithCanUse:stateCanUse];
}

-(void)setUpRedPaketImageViewPicetureWithCanUse:(BOOL)canUse
{
    NSString * redPacketImage =  canUse?@"common.bundle/personnal/redPacketNomal_p.png":@"common.bundle/personnal/redPacketNomal.png";
    redPaketImageView.image = [UIImage imageNamed:redPacketImage];
}
@end
