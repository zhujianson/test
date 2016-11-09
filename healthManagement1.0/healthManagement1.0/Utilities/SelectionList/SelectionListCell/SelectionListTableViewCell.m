//
//  SelectionListTableViewCell.m
//  jiuhaohealth2.1
//
//  Created by xjs on 14-8-28.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "SelectionListTableViewCell.h"

@implementation SelectionListTableViewCell
@synthesize leftLabel,checkBox;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        leftLabel = [Common createLabel:CGRectMake(10, 8, 150, 30) TextColor:@"#000000" Font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft labTitle:nil];
        [self.contentView addSubview:leftLabel];
        
        checkBox = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(kDeviceWidth-60, 7, 30, 30) style:kSSCheckBoxViewStyleDark checked:NO];
        checkBox.userInteractionEnabled = NO;
        [self.contentView addSubview:checkBox];

    }
    return self;
}

- (void)dealloc
{
    [leftLabel release];
    [checkBox release];
    [super dealloc];
}

- (void)setLableText:(NSString*)text check:(BOOL)isCheck
{
    leftLabel.text = text;
    if (isCheck) {
        checkBox.checked = YES;
    }else{
        checkBox.checked = NO;
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

@end
