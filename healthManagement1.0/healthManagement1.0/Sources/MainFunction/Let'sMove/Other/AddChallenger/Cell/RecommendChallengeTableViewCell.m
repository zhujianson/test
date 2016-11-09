//
//  RecommendTableViewCell.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-9-29.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "RecommendChallengeTableViewCell.h"

@interface RecommendChallengeTableViewCell ()

@property (nonatomic,retain) UIImageView *photoImageView;//头像
@property (nonatomic,retain) UIImageView *sexImageView;//性别
@property (nonatomic,retain) UILabel *userName;//姓名
@property (nonatomic,retain) UILabel *allLengthLabel;//所有的历程
@property (nonatomic,retain) UILabel *allStepCount;//总步子数
@property (nonatomic,retain) UILabel *allStepCountNameLabel;//总步子文字
@property (nonatomic,retain) UILabel *rankLabel;//排名

@end

@implementation RecommendChallengeTableViewCell

- (void)dealloc
{
    self.selectedImageView = nil;
    self.photoImageView = nil;
    self.sexImageView = nil;
    self.userName = nil;
    self.allLengthLabel = nil;
    self.allStepCount = nil;
    self.allStepCountNameLabel = nil;
    self.rankLabel = nil;
    self.dataDic = nil;

    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
    //选中的view---默认选中
    self.selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 19, 19)];
    self.selectedImageView.image = [UIImage imageNamed:@"common.bundle/move/move_icon_checkbox_pressed.png"];

    [self.contentView addSubview:self.selectedImageView];
    [self.selectedImageView release];
    
    
    //头像
    self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 12, 40, 40)];
    [self.contentView addSubview:self.photoImageView];
    self.photoImageView.layer.cornerRadius = 20;
    self.photoImageView.layer.masksToBounds = YES;
    [self.photoImageView release];
    //性别
    self.sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(45+31, 8, 22, 22)];
    [self.contentView addSubview:self.sexImageView];
    self.sexImageView.image = [UIImage imageNamed:@"common.bundle/move/move_icon_female.png"];
    [self.sexImageView release];
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(self.photoImageView.origin.x-5, self.photoImageView.origin.y+self.photoImageView.size.height+7,50, 16)];
    self.userName.textColor = [CommonImage colorWithHexString:@"333333"];
//    self.userName.text = @"迈克尔";
    
    self.userName.textAlignment = NSTextAlignmentCenter;
    self.userName.font = [UIFont systemFontOfSize:14.0f];
    self.userName.adjustsFontSizeToFitWidth = YES;
    self.userName.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.userName];
    [self.userName release];
    
    CGFloat leftWidth = kDeviceWidth - self.sexImageView.origin.x-self.sexImageView.size.width-20;
    CGFloat marginx = (leftWidth-65-65-30)/3.0f;
    
    
    
    //总里程
    self.allLengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.sexImageView.origin.x+self.sexImageView.size.width+marginx, 21, 65, 15)];
    self.allLengthLabel.textColor = [CommonImage colorWithHexString:@"333333"];
//    self.allLengthLabel.text = @"13.3";
    self.allLengthLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.allLengthLabel];
    [self.allLengthLabel release];
    //总里程Label
    UILabel *allLengthNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.allLengthLabel.origin.x, self.allLengthLabel.origin.y+15+10, self.allLengthLabel.size.width, 14)];
    allLengthNameLabel.textColor = [CommonImage colorWithHexString:@"666666"];
    allLengthNameLabel.text = @"总里程(km)";
    allLengthNameLabel.backgroundColor = [UIColor clearColor];
    allLengthNameLabel.textAlignment = NSTextAlignmentCenter;
    allLengthNameLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:allLengthNameLabel];
    [allLengthNameLabel release];
    //总步数
    self.allStepCount = [[UILabel alloc] initWithFrame:CGRectMake(self.allLengthLabel.origin.x+self.allLengthLabel.size.width+marginx, 21, 65, 15)];
    self.allStepCount.textColor = [CommonImage colorWithHexString:@"333333"];
//    self.allStepCount.text = @"34079";
    self.allStepCount.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.allStepCount];
    [self.allStepCount release];
    //总步数Label
    self.allStepCountNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.allStepCount.frame.origin.x, self.allStepCount.origin.y+15+10, self.allStepCount.size.width, 14)];
    self.allStepCountNameLabel.textColor = [CommonImage colorWithHexString:@"333333"];
    self.allStepCountNameLabel.text = @"总步数";
    self.allStepCountNameLabel.backgroundColor = [UIColor clearColor];
    self.allStepCountNameLabel.textAlignment = NSTextAlignmentCenter;
    self.allStepCountNameLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:self.allStepCountNameLabel];
    [self.allStepCountNameLabel release];
    //排名
    self.rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.allStepCount.origin.x+self.allStepCount.size.width+marginx, 21, 30, 15)];
    self.rankLabel.textColor = [CommonImage colorWithHexString:@"333333"];
    self.rankLabel.textColor = [UIColor redColor];
    self.rankLabel.font = [UIFont systemFontOfSize:15];
//    self.rankLabel.text = @"4";
    self.rankLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.rankLabel];
    [self.rankLabel release];
    //排名Label
    UILabel *rankNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.rankLabel.origin.x, self.rankLabel.origin.y+15+10, self.rankLabel.size.width, 14)];
    rankNameLabel.textColor = [CommonImage colorWithHexString:@"666666"];
    rankNameLabel.text = @"排名";
    rankNameLabel.backgroundColor = [UIColor clearColor];
    rankNameLabel.textAlignment = NSTextAlignmentCenter;
    rankNameLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:rankNameLabel];
    [rankNameLabel release];

    
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    if(_dataDic != dataDic){
        
        [_dataDic release];
        _dataDic = [dataDic retain];
    }
    
    self.allLengthLabel.text = [NSString stringWithFormat:@"%.2f",[dataDic[@"totalDistance"] floatValue]/1000];
    self.allStepCount.text = dataDic[@"totalStepCnt"];
    self.rankLabel.text = dataDic[@"rank"];
    self.userName.text = dataDic[@"userName"];
    NSString *sex = dataDic[@"sex"];
    if([sex intValue]){
        //男
        self.sexImageView.image = [UIImage imageNamed:@"common.bundle/move/move_icon_male.png"];
    }else{
        //女
        self.sexImageView.image = [UIImage imageNamed:@"common.bundle/move/move_icon_female.png"];
    }
}

- (void)setIconImage:(UIImage*)image
{
    self.photoImageView.image = image;
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
