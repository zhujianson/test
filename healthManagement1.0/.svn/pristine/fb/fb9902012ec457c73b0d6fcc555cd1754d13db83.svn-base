//
//  MyGGTTableViewCell.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-11-27.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "MyGGTTableViewCell.h"

@interface MyGGTTableViewCell ()

@property (nonatomic,retain) UIImageView *photoImageView;//头像
@property (nonatomic,retain) UILabel *teamNameLabel;//团名称
@property (nonatomic,retain) UILabel *localLabel;//位置1
@property (nonatomic,retain) UILabel *localLabel2;//位置2
@property (nonatomic,retain) UILabel *teamDesLabel;//介绍
@property (nonatomic,retain) UILabel *teamNumLabel;//介绍



@end

@implementation MyGGTTableViewCell

- (void)dealloc
{
    self.photoImageView = nil;
    self.teamNameLabel = nil;
    self.localLabel = nil;
    self.localLabel2 = nil;
    self.teamDesLabel = nil;
    self.teamNumLabel = nil;
    self.dataDic = nil;
    [super dealloc];
}


- (void)awakeFromNib {
    // Initialization code
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self getSubviews];
        
    }
    return self;
}

- (void)getSubviews
{
    //头像
    self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 70, 70)];
    self.photoImageView.layer.cornerRadius = 35;
    self.photoImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.photoImageView];
    [self.photoImageView release];
    //团名称
    CGFloat nameX = self.photoImageView.frame.origin.x+self.photoImageView.width+12;
    self.teamNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameX, 15, kDeviceWidth-nameX-15, 16)];
    self.teamNameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    
    [self.contentView addSubview:self.teamNameLabel];
    [self.teamNameLabel release];
    //位置1
    self.localLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameX, self.teamNameLabel.origin.y+self.teamNameLabel.size.height+7, 38, 17)];//名字长度*15+8----但是限制一个最大值
    self.localLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    self.localLabel.text = @"北京";
    self.localLabel.textColor = [UIColor whiteColor];
    self.localLabel.textAlignment = NSTextAlignmentCenter;
    self.localLabel.layer.cornerRadius = 2.0f;
    self.localLabel.layer.masksToBounds = YES;
    self.localLabel.backgroundColor = [CommonImage colorWithHexString:VERSION_TEXT_COLOR];
    
    [self.contentView addSubview:self.localLabel];
    [self.localLabel release];
    
    //位置2
    self.localLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.localLabel.origin.x+self.localLabel.size.width+5, self.teamNameLabel.origin.y+self.teamNameLabel.size.height+7, 68, 17)];//名字长度*15+8
    self.localLabel2.font = [UIFont boldSystemFontOfSize:13.0f];
    self.localLabel2.textColor = [UIColor whiteColor];
    self.localLabel2.textAlignment = NSTextAlignmentCenter;
    self.localLabel2.layer.cornerRadius = 2.0f;
    self.localLabel2.layer.masksToBounds = YES;
    self.localLabel2.backgroundColor = [CommonImage colorWithHexString:@"ffa34d"];
    
    [self.contentView addSubview:self.localLabel2];
    [self.localLabel2 release];
    //总人数
    self.teamNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-50-15, self.teamNameLabel.origin.y+self.teamNameLabel.size.height+7, 50, 17)];//名字长度*15+5
    self.teamNumLabel.font = [UIFont systemFontOfSize:13.0f];
    self.teamNumLabel.backgroundColor = [UIColor clearColor];
    self.teamNumLabel.textColor = [CommonImage colorWithHexString:@"b0b0b0"];
    self.teamNumLabel.textAlignment = NSTextAlignmentCenter;
    self.teamNumLabel.layer.cornerRadius = 2.0f;
    self.teamNumLabel.layer.masksToBounds = YES;
    
    [self.contentView addSubview:self.teamNumLabel];
    [self.teamNumLabel release];
        
    //简介
    self.teamDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameX, self.localLabel2.origin.y+self.localLabel2.size.height+7, kDeviceWidth-nameX-15, 17)];//名字长度*15+8
    self.teamDesLabel.font = [UIFont systemFontOfSize:15.0f];
    
    self.teamDesLabel.textColor = [CommonImage colorWithHexString:@"b0b0b0"];
    [self.contentView addSubview:self.teamDesLabel];
    [self.teamDesLabel release];

    UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(0, 89.5,kDeviceWidth, 0.5)];
    lineView.backgroundColor =  [CommonImage colorWithHexString:@"e5e5e5"];
    [self.contentView addSubview:lineView];
    [lineView release];
    
    
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    if(_dataDic != dataDic){
        [_dataDic release];
        _dataDic = [dataDic retain];
    }

//    @"common.bundle/common/center_icon_nor.png"
//    [CommonImage setPicImageQiniu:dataDic[@"filePath"] View:self.photoImageView Type:4 Delegate:nil];
    [CommonImage setImageFromServer:dataDic[@"filePath"] View:self.photoImageView Type:4];

    self.teamNameLabel.text = dataDic[@"name"];
    
    NSString *local1String = dataDic[@"activityArea"];
    
    
    CGSize size = [local1String sizeWithFont:self.localLabel.font constrainedToSize:CGSizeMake(40, 17)];
    self.localLabel.text = dataDic[@"activityArea"];
    CGRect localLabelRect = self.localLabel.frame;
    localLabelRect.size.width = size.width+10;//local1String.length*15 + 8 > 70 ? 70 :local1String.length*15 + 8;
    self.localLabel.frame = localLabelRect;
    
    //位置2
    NSString *local2String = dataDic[@"activityAddress"];
    size = [local2String sizeWithFont:self.localLabel2.font constrainedToSize:CGSizeMake(100, 17)];
    CGRect local2LabelRect =  self.localLabel2.frame;
    local2LabelRect.origin.x = self.localLabel.origin.x+self.localLabel.size.width+5;
    local2LabelRect.size.width = (int)size.width+10;//local2String.length*15 + 8 > 80 ? 90 :local2String.length*15 + 8;
    self.localLabel2.frame = local2LabelRect;
    self.localLabel2.text = local2String;
    
    self.teamNumLabel.text = [NSString stringWithFormat:@"%@/%@",[[Common isNULLString3:dataDic[@"memberCount"]] length] == 0?@"0":[Common isNULLString3:dataDic[@"memberCount"]],dataDic[@"total"]];
    self.teamDesLabel.text = dataDic[@"manifesto"];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
