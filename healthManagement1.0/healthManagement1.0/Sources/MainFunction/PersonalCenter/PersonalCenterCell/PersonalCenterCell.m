//
//  PersonalCenterCell.m
//  jiuhaohealth2.1
//
//  Created by jiuhao-yangshuo on 14-7-25.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "PersonalCenterCell.h"

//#define WEIGHT (kDeviceWidth -75*kRelativity6DeviceWidth)
#define WEIGHT (kDeviceWidth)

@implementation PersonalCenterCell {
    NSDictionary* m_dic;
    UILabel * m_Vlaue;
    UIImageView * m_RightView;
    UIView * m_View;
    
}
@synthesize labelName, labelTip, cellImageView;
//- (void)dealloc
//{
//    self.labelName = nil;
//    self.labelTip = nil;
//    self.cellImageView = nil;
//
//    [super dealloc];
//}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 46)];
//        view.backgroundColor = [CommonImage colorWithHexString:@"fefdfb"];
//        [self.contentView addSubview:view];
//        [view release];
//        self.backgroundColor = []

        cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, self.height)];
        cellImageView.contentMode = UIViewContentModeCenter;
        cellImageView.hidden = YES;
        [self.contentView addSubview:cellImageView];
        [cellImageView release];

        UIImage * image = [UIImage imageNamed:@"common.bundle/common/right-arrow_pre.png"];
        m_RightView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-20-image.size.width, 0,image.size.width, 55)];
        m_RightView.contentMode = UIViewContentModeCenter;
        m_RightView.image = image;
        [self.contentView addSubview:m_RightView];
        [m_RightView release];
        
        labelName = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 130, 55)];
        labelName.backgroundColor = [UIColor clearColor];
        labelName.font = [UIFont systemFontOfSize:15];
        labelName.textColor = [CommonImage colorWithHexString:@"000000"];
        [self.contentView addSubview:labelName];
        [labelName release];

        m_Vlaue = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WEIGHT-35, self.height)];
        m_Vlaue.backgroundColor = [UIColor clearColor];
        m_Vlaue.textAlignment = NSTextAlignmentRight;
        m_Vlaue.font = [UIFont systemFontOfSize:M_FRONT_FOURTEEN];
        m_Vlaue.textColor = [CommonImage colorWithHexString:@"999999" alpha:0.8];
        [self.contentView addSubview:m_Vlaue];
        [m_Vlaue release];

        labelTip = [[UILabel alloc] initWithFrame:CGRectMake(320 - 44, 13, 18, 18)];
        labelTip.clipsToBounds = YES;
        labelTip.backgroundColor = [CommonImage colorWithHexString:@"e75442"];
        labelTip.textColor = [UIColor whiteColor];
        labelTip.textAlignment = NSTextAlignmentCenter;
        labelTip.font = [UIFont systemFontOfSize:10];
        labelTip.layer.cornerRadius = 18 / 2;
        [self.contentView addSubview:labelTip];
        [labelTip release];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setDicInfo:(NSDictionary*)dic
{
//    cellImageView.frame = [Common rectWithSize:cellImageView.frame width:0 height:self.height];
//    labelName.frame = [Common rectWithSize:labelName.frame width:0 height:self.height];
//    m_Vlaue.frame = [Common rectWithSize:m_Vlaue.frame width:0 height:self.height];
//    m_RightView.frame = [Common rectWithOrigin:m_RightView.frame x:0 y:(self.height-21/2)/2];
    
    labelName.hidden = NO;
    cellImageView.hidden = YES;
    labelTip.hidden = NO;
    m_RightView.hidden = NO;

    labelName.text = dic[@"title"];
//    cellImageView.image = [UIImage imageNamed:dic[@"image"]];
    m_Vlaue.hidden = YES;
//    if (dic[@"value"]) {
//        m_Vlaue.hidden = NO;
//        m_Vlaue.text = dic[@"value"];
//    }
    
    int tipNum = [dic[@"tipNum"] intValue];
    if (!tipNum) {
        labelTip.hidden = YES;
    }
    else {
        labelTip.hidden = NO;
        NSString *str = [NSString stringWithFormat:@"%d",tipNum];
        if (tipNum > 9) {
            str = @"9+";
        }
        labelTip.text = str;
    }
}

- (void)createBtn:(id)object isShow:(BOOL)isShow array:(NSArray*)arr
{
    NSInteger num = arr.count,num2 = (num/4.1+1);
    labelName.hidden = YES;
    cellImageView.hidden = YES;
    m_Vlaue.hidden = YES;
    labelTip.hidden = YES;
    m_RightView.hidden = YES;
    
    m_View.hidden = isShow;
    if (!arr.count) {
        return;
    }
    if (isShow) {
        return;
    }
    if (m_View) {
        return;
    }
    m_View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 90*num2)];
    m_View.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:m_View];
    UIButton * btn = nil;
    UIImageView * imageV;
    CGFloat x,y;
    CGFloat weight = kDeviceWidth/num;
    if (num>4) {
        weight = kDeviceWidth/4;
    }
    for (int i = 0; i<num; i++) {
        x = i%4;
        y = i/4;
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(weight*x, y*90-0.5, weight, 90+1);
//        [btn setBackgroundColor:[CommonImage colorWithHexString:@"999999"]];
        btn.tag = 100+i;
//        btn.layer.cornerRadius = 4;
//        btn.clipsToBounds = YES;
//        btn.layer.borderWidth = 0.5;
//        btn.layer.borderColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN alpha:0.8].CGColor;

        [btn addTarget:object action:@selector(touchWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"" forState:UIControlStateNormal];
        [m_View addSubview:btn];
        
        NSString * titleBtn = arr[i][@"buttonName"];
        imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
        imageV.image = [UIImage imageNamed:@"common.bundle/common/conversation_logo.png"];
        imageV.center = CGPointMake(btn.width/2, (btn.height-20)/2);
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        [btn addSubview:imageV];
        [imageV release];
        NSString *imagePath = [arr[i][@"imgUrl"] stringByAppendingString:@"?imageView2/1/w/56/h/56"];

        [CommonImage setImageFromServer:imagePath View:imageV Type:2];
        [btn.titleLabel setContentMode:UIViewContentModeCenter];
        [btn.titleLabel setBackgroundColor:[UIColor clearColor]];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(32,
                                                         0,
                                                         0.0,
                                                         0.0)];
        [btn setTitleColor:[CommonImage colorWithHexString:arr[i][@"colour"]] forState:UIControlStateNormal];
//        [btn setTitleColor:[CommonImage colorWithHexString:COLOR_666666] forState:UIControlStateNormal];

        [btn setTitleColor:[CommonImage colorWithHexString:@"999999"] forState:UIControlStateHighlighted];

        [btn setTitle:titleBtn forState:UIControlStateNormal];
    }
    UIView * lineView;
    //竖线
    for (int i = 0; i<3; i++) {
        lineView = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth/4*(i+1)-0.25, 0, 0.5, m_View.height)];
        lineView.backgroundColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
        [m_View addSubview:lineView];
        [lineView release];
    }
    //横线
    for (int i = 1; i<num2; i++) {
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, btn.height*i-0.25, kDeviceWidth, 0.5)];
        lineView.backgroundColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
        [m_View addSubview:lineView];
        [lineView release];
    }
}

- (void)touchWithBtn:(UIButton*)btn
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    labelTip.backgroundColor = [CommonImage colorWithHexString:@"d05151"];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    labelTip.backgroundColor = [CommonImage colorWithHexString:@"d05151"];
}

@end