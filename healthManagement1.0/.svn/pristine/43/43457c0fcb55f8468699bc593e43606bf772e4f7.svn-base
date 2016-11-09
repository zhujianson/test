//
//  RadarDoctorCell.m
//  jiuhaohealth4.0
//
//  Created by xjs on 15/5/12.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "RadarDoctorCell.h"

@implementation RadarDoctorCell
{
//    UIImageView*m_headerView;
    UILabel * m_nameLabel;
    UILabel * m_sexLabel;
    UILabel * m_addressLabel;
    UITextField * m_textView;
    UIButton * invitationBtn;
}

@synthesize m_headerView;
@synthesize m_textView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)dealloc
{
    [m_headerView release];
    [m_textView release];
    [m_radar release];
    
    [super dealloc];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        m_headerView = [[UIImageView alloc]init];
        m_headerView.clipsToBounds = YES;
        m_headerView.contentMode = UIViewContentModeScaleAspectFill;
        m_headerView.frame = CGRectMake(15, 20, 60, 60);
        m_headerView.layer.cornerRadius = m_headerView.width/2.0;
        [self.contentView addSubview:m_headerView];
        
        m_nameLabel = [Common createLabel:CGRectMake(m_headerView.right+15, m_headerView.top, 200, 20) TextColor:@"333333" Font:[UIFont fontWithName:@"TrebuchetMS-Bold" size:16] textAlignment:NSTextAlignmentLeft labTitle:@""];
        [self.contentView addSubview:m_nameLabel];

        m_sexLabel = [Common createLabel:CGRectMake(m_nameLabel.left, m_nameLabel.bottom+5, 200, 20) TextColor:@"999999" Font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft labTitle:@""];
        [self.contentView addSubview:m_sexLabel];

        m_addressLabel = [Common createLabel:CGRectMake(m_nameLabel.left, m_sexLabel.bottom, 200, 20) TextColor:@"999999" Font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft labTitle:@""];
        [self.contentView addSubview:m_addressLabel];

        UIView*lineView  = [[UIView alloc] initWithFrame:CGRectMake(0, 100-0.25,kDeviceWidth, 0.5)];
        lineView.backgroundColor =  [CommonImage colorWithHexString:LINE_COLOR];
        [self.contentView addSubview:lineView];
        [lineView release];

        m_textView = [[UITextField alloc] initWithFrame:CGRectMake(m_headerView.left, lineView.bottom, kDeviceWidth-30, 45)];
        m_textView.backgroundColor = [UIColor clearColor];
        m_textView.delegate = self;
        m_textView.returnKeyType = UIReturnKeyDone;
        m_textView.textColor = [CommonImage colorWithHexString:@"#333333"];
        m_textView.font = [UIFont systemFontOfSize:16];
        m_textView.placeholder = NSLocalizedString(@"请输入验证信息", nil);
        [self.contentView addSubview:m_textView];
        
//        [[KXTextView alloc] initWithFrame:CGRectMake(m_headerView.left, lineView.bottom, kDeviceWidth-30, 45)];
//        [m_textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
//        m_textView.backgroundColor = [UIColor clearColor];
////        [m_textView setEditable:YES];
//        m_textView.delegate = self;
//        m_textView.returnKeyType = UIReturnKeyDone;
//        m_textView.textColor = [CommonImage colorWithHexString:@"#333333"];
//        m_textView.font = [UIFont systemFontOfSize:16];
//        m_textView.placeholder = NSLocalizedString(@"请输入验证信息", nil);
//        m_textView.placeholderColor = [CommonImage colorWithHexString:@"#bbbbbb"];
//        m_textView.placeHolderLabel.font = [UIFont systemFontOfSize:16];
//        [self.contentView addSubview:m_textView];
        
        
        invitationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        invitationBtn.frame = CGRectMake(kDeviceWidth-50-15, 72/2, 50, 28);
        invitationBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        invitationBtn.layer.cornerRadius = 4;
        invitationBtn.clipsToBounds = YES;
        invitationBtn.layer.borderWidth = 0.5;
        invitationBtn.layer.borderColor = [CommonImage colorWithHexString:LINE_COLOR].CGColor;
        [invitationBtn addTarget:self action:@selector(invitation:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:invitationBtn];

    }
    return self;
}

- (void)invitation:(UIButton*)btn
{
    m_radar(m_textView.text);
    
    [m_textView resignFirstResponder];
    m_textView.userInteractionEnabled = NO;

    [invitationBtn setTitleColor:[CommonImage colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [invitationBtn setTitle:NSLocalizedString(@"已邀请", nil) forState:UIControlStateNormal];
    invitationBtn.userInteractionEnabled = NO;
    UIImage* image=  [CommonImage createImageWithColor:[UIColor clearColor]];
    [invitationBtn setBackgroundImage:image forState:UIControlStateNormal];

}

- (void)setUserData:(NSMutableDictionary*)dic
{
    m_nameLabel.text = dic[@"nickName"];
    m_sexLabel.text = [NSString stringWithFormat:@"%@  %@岁",[CommonUser getSex:[NSString stringWithFormat:@"%@",dic[@"sex"]]],dic[@"age"]];
    if ([dic[@"city"] isEqualToString:dic[@"province"]]) {
        m_addressLabel.text = [NSString stringWithFormat:@"来自%@",[dic[@"province"] length]?dic[@"province"]:@"北京"];
    }else{
        m_addressLabel.text = [NSString stringWithFormat:@"来自%@%@",dic[@"province"],dic[@"city"]];
    }
    
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
    if (![dic[@"is_invitation"] intValue]) {
        m_textView.userInteractionEnabled = YES;
        [invitationBtn setTitleColor:[CommonImage colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        [invitationBtn setTitle:NSLocalizedString(@"邀请", nil) forState:UIControlStateNormal];
        invitationBtn.userInteractionEnabled = YES;
        [invitationBtn setBackgroundImage:image forState:UIControlStateNormal];
    }else{
        m_textView.userInteractionEnabled = NO;
        [invitationBtn setTitleColor:[CommonImage colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [invitationBtn setTitle:NSLocalizedString(@"已邀请", nil) forState:UIControlStateNormal];
        invitationBtn.userInteractionEnabled = NO;
        image =  [CommonImage createImageWithColor:[UIColor clearColor]];
        [invitationBtn setBackgroundImage:image forState:UIControlStateNormal];
    }

}

////接收处理
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
////    UITextView *mTrasView = object;
//    CGFloat topCorrect = ([m_textView bounds].size.height - [m_textView contentSize].height);
//    topCorrect = (topCorrect <0.0 ?0.0 : topCorrect);
//    m_textView.contentOffset = (CGPoint){.x =0, .y = -topCorrect/2};
//}

- (void)setRadarDoctorBlock:(RadarDoctorBlock)look
{
    m_radar = [look copy];
}

- (void)setPickerImage:(UIImage*)image
{
    m_headerView.image = image;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    m_radar(nil);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)resign
{
    [m_textView resignFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
