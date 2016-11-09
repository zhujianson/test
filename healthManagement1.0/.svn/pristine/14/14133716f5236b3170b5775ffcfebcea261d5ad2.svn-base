//
//  FoodMatchTableViewCell.m
//  jiuhaohealth2.1
//
//  Created by 徐国洪 on 14-8-6.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "FoodMatchTableViewCell.h"

@implementation FoodMatchTableViewCell
@synthesize m_dicInfo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        m_imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        m_imageIcon.layer.cornerRadius = m_imageIcon.width/2;
        m_imageIcon.clipsToBounds = YES;
        [self.contentView addSubview:m_imageIcon];
        
        m_labTitle = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 100, 20)];
        m_labTitle.backgroundColor = [UIColor clearColor];
        m_labTitle.font = [UIFont systemFontOfSize:14];
        m_labTitle.textColor = [CommonImage colorWithHexString:@"333333"];
        [self.contentView addSubview:m_labTitle];
        
        m_butAdd = [[UIButton alloc] initWithFrame:CGRectMake(120, 0, 50, 50)];
        [m_butAdd setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        [m_butAdd setTitle:<#(NSString *)#> forState:<#(UIControlState)#>]
        [m_butAdd addTarget:self action:@selector(butEventAdd) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:m_butAdd];
        
        m_labCon = [[UILabel alloc] initWithFrame:CGRectMake(80, 35, 230, 0)];
        m_labCon.numberOfLines = 0;
        m_labCon.backgroundColor = [UIColor clearColor];
        m_labCon.font = [UIFont systemFontOfSize:14];
        m_labCon.textColor = [CommonImage colorWithHexString:@"333333"];
        [self.contentView addSubview:m_labCon];
    }
    return self;
}

- (void)butEventAdd
{
}

- (void)setM_dicInfo:(NSDictionary *)dic
{
    m_imageIcon.image = [UIImage imageNamed:[dic objectForKey:@"icon"]];
    m_labTitle.text = [dic objectForKey:@"title"];
    m_labCon.text = [dic objectForKey:@"con"];
    CGRect rect = m_labCon.frame;
    rect.size.height = [[dic objectForKey:@"height"] floatValue];
    m_labCon.frame = rect;
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
    [m_imageIcon release];
    [m_labTitle release];
    [m_labCon release];
    [m_butAdd release];
    
    [super dealloc];
}

@end
