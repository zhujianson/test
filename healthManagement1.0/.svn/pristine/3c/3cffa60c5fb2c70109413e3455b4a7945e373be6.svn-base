//
//  MedicalHistoryTableViewCell.m
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-10-13.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "MedicalHistoryTableViewCell.h"

@implementation MedicalHistoryTableViewCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.isEdit = YES;
        
        m_MedicalName = [Common createLabel];
        m_MedicalName.frame = CGRectMake(15, 0, kDeviceWidth - 30, 45);
        m_MedicalName.text = @"疾病：";
        m_MedicalName.font = [UIFont systemFontOfSize:15];
        m_MedicalName.textColor = [CommonImage colorWithHexString:@"333333"];
        [self.contentView addSubview:m_MedicalName];
        
        butN = [UIButton buttonWithType:UIButtonTypeCustom];
        butN.frame = CGRectMake(15, 0, 200, 45);
        butN.tag = 150;
        [butN addTarget:self action:@selector(butEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:butN];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, m_MedicalName.bottom, kDeviceWidth-15, 0.5)];
        line.backgroundColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_QIAN];
        [self.contentView addSubview:line];
        
        m_MedicalTime = [Common createLabel];
        m_MedicalTime.frame = CGRectMake(15, line.bottom, kDeviceWidth - 30, 45);
        m_MedicalTime.text = @"确诊时间：";
        m_MedicalTime.font = [UIFont systemFontOfSize:15];
        m_MedicalTime.textColor = [CommonImage colorWithHexString:@"333333"];
        [self.contentView addSubview:m_MedicalTime];
        
        butT = [UIButton buttonWithType:UIButtonTypeCustom];
        butT.frame = CGRectMake(15, line.bottom, 200, 45);
        butT.tag = 151;
        [butT addTarget:self action:@selector(butEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:butT];
    }
    return self;
}

- (void)butEvent:(UIButton*)but
{
//    if (self.isEdit) {
    
        if (but.tag == 150) {
            [delegate butEventName:self.m_dicInfo];
        }
        else {
            [delegate butEventTime:self.m_dicInfo];
        }
//    }
}

- (void)setM_dicInfo:(NSMutableDictionary *)dic
{
    _m_dicInfo = dic;
    m_MedicalName.text = [NSString stringWithFormat:@"疾病：%@", [Common isNULLString3:[dic objectForKey:@"title"]]];
    m_MedicalTime.text = [NSString stringWithFormat:@"确诊时间：%@", [Common isNULLString3:[dic objectForKey:@"date"]]];
}

- (void)setButEvent
{
    [butN sendActionsForControlEvents:UIControlEventTouchDragExit];
    [butT sendActionsForControlEvents:UIControlEventTouchDragExit];
    self.isEdit = NO;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [m_MedicalName release];
    [m_MedicalTime release];
    
    self.m_dicInfo = nil;
    
    [super dealloc];
}

@end
