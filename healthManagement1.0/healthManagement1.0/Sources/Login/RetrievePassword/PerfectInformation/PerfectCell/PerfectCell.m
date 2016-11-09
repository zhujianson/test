//
//  PerfectCell.m
//  jiuhaohealth4.0
//
//  Created by xjs on 15/5/28.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "PerfectCell.h"
#import "KXSwitch.h"

@implementation PerfectCell
{
    UIView * redView;
    KXSwitch*switchV;
    UITextField * m_field;
    UILabel * m_UnitLab;

    UILabel * m_nameLab;
    UILabel * m_textLab;
}
- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        redView = [[UIView alloc]initWithFrame:CGRectMake(5, 41/2, 4, 4)];
        redView.clipsToBounds = YES;
        redView.layer.cornerRadius = redView.width/2;
        redView.backgroundColor = [CommonImage colorWithHexString:@"ff5232"];
        [self addSubview:redView];

        m_nameLab = [Common createLabel:CGRectMake(15, 0, 100, 45) TextColor:@"666666" Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft labTitle:nil];
        [self addSubview:m_nameLab];
        
        m_textLab = [Common createLabel:CGRectMake(m_nameLab.right, 0, kDeviceWidth-m_nameLab.right-35, 45) TextColor:@"666666" Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentRight labTitle:nil];
        [self addSubview:m_textLab];
        
    }
    return self;
}

- (void)setInfoWithDic:(NSDictionary*)dic row:(NSInteger)row
{
    m_nameLab.text = dic[@"title"];
    if (!row) {
        m_textLab.hidden = YES;
        UITextField*nameField = (UITextField*)[self viewWithTag:110];
        if (!nameField) {
            nameField = [self createTextField:nil];
            nameField.tag = 110;
            nameField.frame = CGRectMake(0, 0, kDeviceWidth  - 35, 45);
            nameField.textAlignment = NSTextAlignmentRight;
            nameField.delegate = self;
            nameField.placeholder = @"真实姓名";
            [self addSubview:nameField];
        }else{
            nameField.text = dic[@"nickName"];
        }
        
    }else if(row == 7)
    {
        m_textLab.hidden = YES;
        UITextField*photoField = (UITextField*)[self viewWithTag:111];
        if (!photoField) {
            photoField = [self createTextField:nil];
            photoField.tag = 111;
            photoField.frame = CGRectMake(0, 0, kDeviceWidth  - 35, 45);
            photoField.textAlignment = NSTextAlignmentRight;
            photoField.delegate = self;
            photoField.placeholder = @"请输入家人手机号(选填)";
            [self addSubview:photoField];
        }else{
            photoField.text = dic[@"photo"];
        }
    }else{
    m_textLab.hidden = NO;
    m_textLab.text = dic[@"value"];
    }
    
    if (row<3) {
        redView.hidden = NO;
    }else{
        redView.hidden = YES;
    }
}

- (void)setInfoWithDic:(NSDictionary*)dic
{
    m_nameLab.frame = [Common rectWithSize:m_nameLab.frame width:0 height:50];
    m_textLab.frame = [Common rectWithSize:m_textLab.frame width:0 height:50];
    switchV.hidden = YES;
    m_nameLab.text = dic[@"title"];
    redView.hidden = YES;
    m_textLab.text = dic[@"value"];
    m_UnitLab.hidden = YES;
    m_field.hidden = YES;

    if ([m_nameLab.text isEqualToString:@"性别"]){
        m_textLab.hidden = YES;
        if (!switchV) {
            switchV = [[KXSwitch alloc]
                       initWithFrame:CGRectMake(IOS_7 ? (kDeviceWidth-70) : (kDeviceWidth-102), 10, 55, 36)];
            self.accessoryType = UITableViewCellAccessoryNone;
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            switchV.onText = @"男";
            switchV.offText = @"女";
            [switchV addTarget:self
                        action:@selector(switchValueChanged:)
              forControlEvents:UIControlEventValueChanged];
            [self addSubview:switchV];
            switchV.onTintColor = [CommonImage colorWithHexString:The_ThemeColor];
            switchV.tintColor = [CommonImage colorWithHexString:The_ThemeColor];
        }
        switchV.on = [dic[@"value"] intValue];
        switchV.hidden = NO;
    }else if ([m_nameLab.text isEqualToString:@"身高"] || [m_nameLab.text isEqualToString:@"当前体重"]){
        m_textLab.hidden = YES;
        NSString * unit = @"kg",*value =dic[@"value"];
        if ([m_nameLab.text isEqualToString:@"身高"]) {
            unit = @"cm";
        }
        if (!m_field) {
            m_field = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth-55, 50)];
            m_field.placeholder = [NSString stringWithFormat:@"请输入%@",m_nameLab.text];
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
    }

}

- (void)switchValueChanged:(KXSwitch*)s
{
    NSString * st= nil;
    
    if (s.on) {
        st = @"1";
    }else{
        st = @"0";

    }
    _P_block(@{@"tag": @"0",@"text": st});

}

- (UITextField*)createTextField:(NSString*)title
{
    UITextField* text = [[[UITextField alloc] init]autorelease];
    text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    text.contentMode = UIViewContentModeCenter;
    text.autocapitalizationType = UITextAutocapitalizationTypeNone;
    text.placeholder = title;
    text.returnKeyType = UIReturnKeyDone;
    
    //    text.clearButtonMode = YES;
    text.delegate = self;
    [text setTextColor:[CommonImage colorWithHexString:@"#666666"]];
    [text setFont:[UIFont systemFontOfSize:14]];
    return text;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (m_field == textField) {
        if ([textField.placeholder isEqualToString:@"请输入当前体重"]) {
//            g_nowUserInfo.weight = [textField.text floatValue];
            _P_block(@{@"tag": @"2",@"text": textField.text});
        }else{
//            g_nowUserInfo.height = [textField.text floatValue];
            _P_block(@{@"tag": @"1",@"text": textField.text});
        }
        return;
    }
    UITextField*nameField = (UITextField*)[self viewWithTag:110];
    UITextField*photoField = (UITextField*)[self viewWithTag:111];
    NSLog(@"%@,%@",nameField.text,photoField.text);
    _P_block(@{@"nickName": nameField.text?nameField.text:@"",@"photo": photoField.text?photoField.text:@""});
    
}

- (void)setP_block:(PerfectBlock)P_block
{
    _P_block = [P_block copy];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSMutableString *changeString = [NSMutableString stringWithString:textField.text];
    [changeString replaceCharactersInRange:range withString:string];
    
    if (textField.tag == 110) {
        if ([changeString length]>10) {
            return NO;
        }
    }
    if (m_field == textField) {
        if ([changeString floatValue]>300) {
            return NO;
        }
        NSRange range1 = [changeString rangeOfString:@"." options:NSBackwardsSearch];
        if (range1.location != NSNotFound && (range1.location<(changeString.length-2))) {
            return NO;
        }
        return [Common textField:textField replacementString:string];
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.tag == 110) {
    if (textField.text.length > 10) {
        textField.text = [textField.text substringToIndex:10];
    }
    }
}

- (void)removeTextFirst
{
    [m_field resignFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
