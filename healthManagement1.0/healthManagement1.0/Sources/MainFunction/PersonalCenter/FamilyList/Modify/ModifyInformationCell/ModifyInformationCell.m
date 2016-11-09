//
//  ModifyInformationCell.m
//  jiuhaohealth4.0
//
//  Created by xjs on 15/6/15.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "ModifyInformationCell.h"
#import "KXSwitch.h"

@implementation ModifyInformationCell
{
    UILabel * titleLab;
    UILabel * nameLab;

    UIView * redView;
    
    UIImageView * headerImage;
    KXSwitch*switchV;
    UIImageView*rightView;
    
    UITextField * m_field;
}
@synthesize headerImage;

- (void)awakeFromNib {
    // Initialization code
}

- (void)dealloc
{
    [headerImage release];
    [switchV release];
    [rightView release];
    [m_field release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        rightView = [[[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-18,33/2, 13/2, 21/2)]autorelease];
        rightView.image = [UIImage imageNamed:@"common.bundle/common/right-arrow_pre.png"];
        [self addSubview:rightView];

        redView = [[UIView alloc]initWithFrame:CGRectMake(11/2, 41/2, 4, 4)];
        redView.clipsToBounds = YES;
        redView.layer.cornerRadius = redView.width/2;
        redView.backgroundColor = [CommonImage colorWithHexString:COLOR_FF5351];
        [self addSubview:redView];
        
        titleLab = [Common createLabel:CGRectMake(15, 0, 100, 45) TextColor:COLOR_666666 Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft labTitle:nil];
        [self addSubview:titleLab];
        
        nameLab = [Common createLabel:CGRectMake(kDeviceWidth/3, 0, kDeviceWidth/3*2-30, 45) TextColor:COLOR_666666 Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentRight labTitle:nil];
        [self addSubview:nameLab];

//        m_textLab = [Common createLabel:CGRectMake(m_nameLab.right, 0, kDeviceWidth-m_nameLab.right-35, 45) TextColor:@"666666" Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentRight labTitle:nil];
//        [self addSubview:m_textLab];

    }
    return self;
}

- (void)setInfoWithDic:(NSDictionary*)dic object:(id)object isHide:(BOOL)isShow headerImage:(UIImage*)h_image
{
    NSString * titleT = [dic objectForKey:@"title"];
    titleLab.text = titleT;
    rightView.hidden = NO;
    nameLab.hidden = NO;
    switchV.hidden = YES;
    headerImage.hidden = YES;
    if ([titleT isEqualToString:@"头像"] || [titleT isEqualToString:@"既往病史"] || [titleT isEqualToString:@"并发症"] || [titleT isEqualToString:@"绑定设备"]) {
        redView.hidden = YES;
    }else{
        redView.hidden = isShow;
    }
    nameLab.text = dic[@"value"];
    if ([titleT isEqualToString:@"头像"]){
        nameLab.hidden = YES;
        titleLab.frame = [Common rectWithSize:titleLab.frame width:0 height:80];
        rightView.frame = [Common rectWithOrigin:rightView.frame x:0 y:68/2];

        if (!headerImage) {
            headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-92, 7, 62, 62)];
            headerImage.layer.cornerRadius = headerImage.width / 2; //圆形
            headerImage.clipsToBounds = YES;
            if (h_image) {
                headerImage.image = h_image;
            }else{
            if ([dic[@"value"] length]) {
//                [CommonImage setPicImageQiniu:dic[@"value"] View:headerImage Type:0 Delegate:nil];
                [CommonImage setImageFromServer:dic[@"value"] View:headerImage Type:0];

            }else{
                headerImage.image = [UIImage imageNamed:@"common.bundle/common/center_my-family_head_icon.png"];
            }
            }
            [self.contentView addSubview:headerImage];
        }
        headerImage.hidden = NO;
    }else if([titleT isEqualToString:@"性别"])
    {
        rightView.hidden = YES;
        if (!switchV) {
            switchV = [[KXSwitch alloc]
                       initWithFrame:CGRectMake(IOS_7 ? (kDeviceWidth-78) : (kDeviceWidth-110), 7, 63, 36)];
            self.accessoryType = UITableViewCellAccessoryNone;
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            switchV.onText = @"男";
            switchV.offText = @"女";
            switchV.on = [dic[@"value"] isEqualToString:@"女"]? NO :YES;
            [switchV addTarget:object
                        action:@selector(switchValueChanged:)
              forControlEvents:UIControlEventValueChanged];
            [self addSubview:switchV];
            switchV.onTintColor = [CommonImage colorWithHexString:COLOR_FF5351];
            switchV.tintColor = [CommonImage colorWithHexString:COLOR_FF5351];
        }
        titleLab.frame = [Common rectWithSize:titleLab.frame width:0 height:45];
        switchV.hidden = NO;
    }else if([titleT isEqualToString:@"身高"] || [titleT isEqualToString:@"体重"])
    {
        nameLab.hidden = YES;
        if (!m_field) {
            m_field = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth-55, 45)];
            m_field.placeholder = [NSString stringWithFormat:@"请输入%@",titleT];
            m_field.keyboardType = UIKeyboardTypeDecimalPad;
            m_field.textAlignment = NSTextAlignmentRight;
            m_field.textColor = [CommonImage colorWithHexString:COLOR_333333];
            m_field.delegate = self;
            [self addSubview:m_field];
            
            UILabel * lab = [Common createLabel:CGRectMake(m_field.width, 0, 25, m_field.height) TextColor:COLOR_333333 Font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft labTitle:[titleT isEqualToString:@"身高"]?@"cm":@"kg"];
            [self addSubview:lab];
        }
        m_field.text = dic[@"value"];
    }
    else{
        titleLab.frame = [Common rectWithSize:titleLab.frame width:0 height:45];
        rightView.frame = [Common rectWithOrigin:rightView.frame x:0 y:33/2];
    }
    
    if([titleT isEqualToString:@"绑定设备"])
    {
        rightView.hidden = YES;
    }
}

- (void)setHeaderImageView:(UIImage*)image
{
    headerImage.image = image;
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSMutableString *changeString = [NSMutableString stringWithString:textField.text];
    [changeString replaceCharactersInRange:range withString:string];
    if ([changeString floatValue]>300) {
//        [Common TipDialog2:@"请输入正常值"];
        return NO;
    }
    NSRange range1 = [changeString rangeOfString:@"." options:NSBackwardsSearch];
    if (range1.location != NSNotFound && (range1.location<(changeString.length-2))) {
        return NO;
    }

    if ([changeString length]>10) {
        return NO;
    }
    return [Common textField:textField replacementString:string];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text length]) {
        if ([[textField.text substringFromIndex:[textField.text length]-1] isEqualToString:@"."]) {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
        }
    }

    if ([textField.text length]>0 && [textField.text floatValue]>0) {
    m_block(@{@"text": textField.text,@"title": textField.placeholder});
    }
}

- (void)setP_block:(ModifyInfoBlock)P_block
{
    m_block = [P_block copy];
}

- (void)setResignFirstResponder
{
    [m_field resignFirstResponder];
}

- (void)setbecomeFirstResponder
{
    [m_field becomeFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
