//
//  AccountCell.m
//  jiuhaohealth4.1
//
//  Created by xjs on 15/9/21.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "AccountCell.h"
#import "KXSwitch.h"
#import "UIImageView+WebCache.h"

@implementation AccountCell
{
    UILabel * titleLab;
    UILabel * nameLab;
    UIImageView * headerImage;
    KXSwitch*switchV;
    UIImageView*rightView;
    UIImageView * m_codeImage;
    UITextField * m_field;
    UILabel * m_UnitLab;

}
@synthesize headerImage;
- (void)awakeFromNib {
    // Initialization code
}

- (void)dealloc
{
    NSLog(@"+++++++++++++++++++++++++++++++++++++++++");
    [headerImage release];
    [switchV release];
    [rightView release];
    [m_field release];
    [m_codeImage release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        rightView = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-18,(46-10.5)/2, 13/2, 21/2)];
        rightView.image = [UIImage imageNamed:@"common.bundle/common/right-arrow_pre.png"];
        [self addSubview:rightView];
        
        titleLab = [Common createLabel:CGRectMake(15, 0, 100, 45) TextColor:COLOR_333333 Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft labTitle:nil];
        [self addSubview:titleLab];
        
        nameLab = [Common createLabel:CGRectMake(kDeviceWidth/3, 0, kDeviceWidth/3*2-30, 45) TextColor:COLOR_666666 Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentRight labTitle:nil];
        [self addSubview:nameLab];
        
        //        m_textLab = [Common createLabel:CGRectMake(m_nameLab.right, 0, kDeviceWidth-m_nameLab.right-35, 45) TextColor:@"666666" Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentRight labTitle:nil];
        //        [self addSubview:m_textLab];
        
    }
    return self;
}

- (void)setInfoWithDic:(NSString*)titleT object:(id)object
{
    titleLab.frame = [Common rectWithSize:titleLab.frame width:0 height:45];
    rightView.frame = [Common rectWithOrigin:rightView.frame x:0 y:(46-10.5)/2];

    titleLab.text = titleT;
    rightView.hidden = NO;
    nameLab.hidden = NO;
    switchV.hidden = YES;
    headerImage.hidden = YES;
    m_codeImage.hidden = YES;
    m_field.hidden = YES;
    m_UnitLab.hidden = YES;

    if ([titleT isEqualToString:@"头像"]) {
        nameLab.hidden = YES;
        titleLab.frame = [Common rectWithSize:titleLab.frame width:0 height:86];
        rightView.frame = [Common rectWithOrigin:rightView.frame x:0 y:(86-10.5)/2];
        if (!headerImage) {
            headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-92, 12, 62, 62)];
            headerImage.layer.cornerRadius = headerImage.width / 2; //圆形
            headerImage.clipsToBounds = YES;
            if ([g_nowUserInfo.filePath length]) {
//                NSString *imagePath = [g_nowUserInfo.filePath stringByAppendingString:@"?imageView2/1/w/80/h/80"];
//                [CommonImage setImageFromServer:imagePath View:headerImage Type:0];
                NSString *imagePath = [g_nowUserInfo.filePath stringByAppendingString:@"?imageView2/1/w/80/h/80"];
                UIImage *defaul = [UIImage imageNamed:@"common.bundle/common/center_my-family_head_icon.png"];
                [headerImage sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:defaul];

            }else{
                headerImage.image = [UIImage imageNamed:@"common.bundle/common/center_my-family_head_icon.png"];
            }
            [self.contentView addSubview:headerImage];
        }
        headerImage.hidden = NO;
    }else if ([titleT isEqualToString:@"姓名"]){
        nameLab.text = g_nowUserInfo.nickName;
    }else if ([titleT isEqualToString:@"性别"]){
        rightView.hidden = YES;
        nameLab.hidden = YES;
        if (!switchV) {
            switchV = [[KXSwitch alloc]
                       initWithFrame:CGRectMake(IOS_7 ? (kDeviceWidth-78) : (kDeviceWidth-110), 7, 63, 36)];
            self.accessoryType = UITableViewCellAccessoryNone;
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            switchV.onText = @"男";
            switchV.offText = @"女";
            switchV.on = [g_nowUserInfo.sex intValue]==2? NO :YES;
            [switchV addTarget:object
                        action:@selector(switchValueChanged:)
              forControlEvents:UIControlEventValueChanged];
            [self addSubview:switchV];
            switchV.onTintColor = [CommonImage colorWithHexString:COLOR_FF5351];
            switchV.tintColor = [CommonImage colorWithHexString:COLOR_FF5351];
        }
        titleLab.frame = [Common rectWithSize:titleLab.frame width:0 height:45];
        switchV.hidden = NO;
    }else if ([titleT isEqualToString:@"生日"]){
        nameLab.text = g_nowUserInfo.birthday;
    }else if ([titleT isEqualToString:@"身高"] || [titleT isEqualToString:@"体重"]){
        nameLab.hidden = YES;
        NSString * unit = @"kg",*value =[NSString stringWithFormat:@"%g",g_nowUserInfo.weight];
        if ([titleT isEqualToString:@"身高"]) {
            unit = @"cm";
            value =[NSString stringWithFormat:@"%g",g_nowUserInfo.height];
        }
        if (!m_field) {
            m_field = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth-55, 45)];
            m_field.placeholder = [NSString stringWithFormat:@"请输入%@",titleT];
            m_field.keyboardType = UIKeyboardTypeDecimalPad;
            m_field.textAlignment = NSTextAlignmentRight;
            m_field.textColor = [CommonImage colorWithHexString:COLOR_666666];
            m_field.delegate = self;
            [self addSubview:m_field];
            
            m_UnitLab = [Common createLabel:CGRectMake(m_field.width, 0, 25, m_field.height) TextColor:COLOR_333333 Font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft labTitle:unit];
            [self.contentView addSubview:m_UnitLab];
        }
        m_UnitLab.hidden = NO;
        m_UnitLab.text = unit;
        m_field.text = value;
        m_field.hidden = NO;
    }else if ([titleT isEqualToString:@"糖尿病类型"]){
        nameLab.text = [CommonUser getBloodSugarDic1][g_nowUserInfo.diabetesType];

    }else if ([titleT isEqualToString:@"既往病史"]){
        nameLab.text = [Common isNULLString5:g_nowUserInfo.medical_history];

    }else if ([titleT isEqualToString:@"并发症"]){
        nameLab.text = [self setComplication:g_nowUserInfo.complications];

    }else if ([titleT isEqualToString:@"手机号"]){
        nameLab.text = g_nowUserInfo.mobilePhone;
        rightView.hidden = YES;
    }else if ([titleT isEqualToString:@"密码修改"]){
        nameLab.text = @"";

    }else if ([titleT isEqualToString:@"我的二维码"]){
        nameLab.hidden = YES;
        m_codeImage.hidden = NO;
        if (!m_codeImage) {
            m_codeImage = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-35-46, 0, 46, 46)];
            m_codeImage.image = [UIImage imageNamed:@"common.bundle/personnal/Orcode_image.png"];
            m_codeImage.contentMode = UIViewContentModeRight;
            [self.contentView addSubview:m_codeImage];
        }
        
    }else if ([titleT isEqualToString:@"绑定设备"]){
        nameLab.text = [g_nowUserInfo.isBindEquipment intValue]?@"已绑定设备":@"未绑定设备";
        rightView.hidden = YES;
    }
}

- (void)setHeaderImageView:(UIImage*)image
{
    headerImage.image = image;
}

- (void)switchValueChanged:(KXSwitch*)s
{
    
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


- (NSString*)setComplication:(NSString*)complication
{
    if ([complication isEqualToString:@"1"]) {
        return @"有";
    }else{
        return @"无";
    }
}

- (void)setResignFirstResponder
{
    [m_field resignFirstResponder];
}

- (void)setbecomeFirstResponder
{
    [m_field becomeFirstResponder];
}

@end
