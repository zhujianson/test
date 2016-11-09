//
//  ListCellTableViewCell.m
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-8-6.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "ListCellTableViewCell.h"
//#import "web"

@implementation ListCellTableViewCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        m_butShwo = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        [m_butShwo addTarget:self action:@selector(butShowEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:m_butShwo];
        
        m_labTitle = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 100, 20)];
        m_labTitle.backgroundColor = [UIColor clearColor];
        m_labTitle.textColor = [CommonImage colorWithHexString:@"333333"];
        m_labTitle.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:m_labTitle];
        
        m_labCon = [[UILabel alloc] initWithFrame:CGRectMake(80, 4, 100, 20)];
        m_labCon.backgroundColor = [UIColor clearColor];
        m_labCon.textColor = [CommonImage colorWithHexString:@"666666"];
        m_labCon.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:m_labCon];
        
        m_imageIsOK = [[UIImageView alloc] initWithFrame:CGRectMake(200, 20, 40, 40)];
        [self.contentView addSubview:m_imageIsOK];
        
        m_butAdd = [[UIButton alloc] initWithFrame:CGRectMake(260, 0, 40, 40)];
        [m_butAdd addTarget:self action:@selector(butAddEvetn) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:m_butAdd];
    }
    return self;
}

- (void)butShowEvent
{
    [delegate butShowEvent:self.m_dicInfo];
}

- (void)butAddEvetn
{
    [delegate butAddEvent:self.m_dicInfo];
}

- (void)setM_dicInfo:(NSDictionary *)dic
{
    [m_butShwo setBackgroundImage:[UIImage imageNamed:[dic objectForKey:@"icon"]] forState:UIControlStateNormal];
    m_labTitle.text = [dic objectForKey:@"name"];
    m_labCon.text = [dic objectForKey:@"cfnl"];
    if ([[dic objectForKey:@"isAdd"] boolValue]) {
        
        [m_butShwo setBackgroundImage:[UIImage imageNamed:[dic objectForKey:@""]] forState:UIControlStateNormal];
    }
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [m_butShwo release];
    [m_butAdd release];
    [m_labTitle release];
    [m_labCon release];
    [m_imageIsOK release];
    
    [super dealloc];
}

@end
