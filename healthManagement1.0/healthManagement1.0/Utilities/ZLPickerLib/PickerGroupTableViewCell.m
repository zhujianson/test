//
//  PickerGroupTableViewCell.m
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 14-11-13.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import "PickerGroupTableViewCell.h"
#import "PickerGroup.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PickerGroupTableViewCell ()

@end

@implementation PickerGroupTableViewCell
{
    UIImageView *groupImageView;
    UILabel *groupNameLabel;
}
- (void)setGroup:(PickerGroup *)group{
    _group = group;
    
    NSString *groupName = group.groupName;
    NSString *groupCount = [NSString stringWithFormat:@"(%d)",(int)group.assetsCount ];
    
    groupImageView.image = group.thumbImage;
    groupNameLabel.attributedText = [self replaceRedColorWithNSString:[NSString stringWithFormat:@"%@   %@",groupName,groupCount] andUseKeyWord:groupCount andWithFontSize:16];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        groupImageView = [[UIImageView alloc]init];
        groupImageView.frame = CGRectMake(0,0, 57, 57);
        [self.contentView addSubview:groupImageView];
     
        groupNameLabel= [Common createLabel:CGRectMake(groupImageView.right+10, 20, kDeviceWidth-80, 20) TextColor:@"333333" Font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentLeft labTitle:nil];
        [self.contentView addSubview:groupNameLabel];
        
    }
    return self;
}

- (NSMutableAttributedString *)replaceRedColorWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )size
{
    NSMutableAttributedString *attrituteString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:@"999999"], NSFontAttributeName : [UIFont systemFontOfSize:size]} range:range];
    return attrituteString;
}

-(void)dealloc
{
    [groupNameLabel release];
    [groupImageView release];
    [super dealloc];
}
@end
