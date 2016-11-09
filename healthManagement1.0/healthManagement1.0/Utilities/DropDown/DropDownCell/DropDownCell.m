//
//  DropDownCell.m
//  jiuhaohealth4.1
//
//  Created by jiuhao-yangshuo on 15/9/21.
//  Copyright © 2015年 xuGuohong. All rights reserved.
//

#import "DropDownCell.h"

@implementation DropDownCell
{
    UILabel *titleLabel;
    UIImageView * redImage;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        titleLabel = [Common createLabel:CGRectMake(20, 0, 80, 45) TextColor:@"000000" Font:[UIFont systemFontOfSize:M_FRONT_FIFTEEN] textAlignment:NSTextAlignmentLeft labTitle:nil];
        [self.contentView addSubview:titleLabel];
        
        redImage = [[UIImageView alloc]initWithFrame:CGRectMake(titleLabel.left-14, 11, 6, 6)];
        redImage.clipsToBounds = YES;
        redImage.layer.cornerRadius = redImage.width/2.0;
        redImage.backgroundColor = [CommonImage colorWithHexString:COLOR_FF5351];
        [self.contentView  addSubview:redImage];
        redImage.centerY = titleLabel.height/2.0;
    }
    return self;
}

-(void)setM_dict:(NSDictionary *)infoDict
{
    titleLabel.text = infoDict[kTitleName];
    redImage.hidden = ![infoDict[kTitleNumber] intValue];
//    redImage.hidden = NO;
}

-(void)dealloc
{
    [redImage release];
    [super dealloc];
}

@end
