//
//  RankTableViewCell.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-9-28.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "RankTableViewCell.h"

@interface RankTableViewCell ()

@property (nonatomic,retain) UIImageView *photoImageView;//头像
@property (nonatomic,retain) UIImageView *sexImageView;//性别
@property (nonatomic,retain) UILabel *userName;//姓名
@property (nonatomic,retain) UILabel *allLengthLabel;//所有的历程
@property (nonatomic,retain) UILabel *allStepCount;//总步子数
@property (nonatomic,retain) UILabel *allStepCountNameLabel;//总步子文字
@property (nonatomic,retain) UILabel *rankLabel;//排名
@property (nonatomic,retain) UILabel *changeLabel;//排名情况
@property (nonatomic,retain) UIImageView *vImageView;//是否是志愿者

@end

@implementation RankTableViewCell
- (void)dealloc
{
    self.photoImageView = nil;
    self.sexImageView = nil;
    self.userName = nil;
    self.allLengthLabel = nil;
    self.allStepCount = nil;
    self.allStepCountNameLabel = nil;
    self.rankLabel = nil;
    self.changeLabel = nil;
    self.dataDic = nil;
    self.vImageView = nil;
    
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
    //头像
    self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 40, 40)];
    self.photoImageView.layer.cornerRadius = 20;
    self.photoImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.photoImageView];
    [self.photoImageView release];
    //性别
    self.sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15+31, 8, 20, 20)];
    [self.contentView addSubview:self.sexImageView];
    self.sexImageView.image = [UIImage imageNamed:@"common.bundle/move/move_icon_female.png"];
    [self.sexImageView release];
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(self.photoImageView.origin.x-10, self.photoImageView.origin.y+self.photoImageView.size.height+7,60, 17)];
//    //加v
//    self.vImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.photoImageView.origin.x+31, 40-8, 20, 20)];
//    [self.contentView addSubview:self.vImageView];
//    self.vImageView.backgroundColor = [UIColor clearColor];
//    self.vImageView.image = [UIImage imageNamed:@"common.bundle/move/v_03.png"];
//    [self.vImageView release];

    
    
    self.userName.textColor = [CommonImage colorWithHexString:@"333333"];
    self.userName.textAlignment = NSTextAlignmentCenter;
    self.userName.font = [UIFont systemFontOfSize:14.0f];
    self.userName.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.userName];
    [self.userName release];
    //计算间距
    CGFloat leftwidth = (kDeviceWidth-(15+31+20)-35);
    CGFloat marginx = (leftwidth - 70 - 75 - 35)/3.0f;
    
//    NSArray *array = [UIFont familyNames];
    
    //总里程
    self.allLengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.sexImageView.origin.x+self.sexImageView.size.width+marginx, 21, 65+5, 15)];//75
    self.allLengthLabel.textColor = [CommonImage colorWithHexString:@"333333"];
    self.allLengthLabel.font = [UIFont systemFontOfSize:17.0f];
    self.allLengthLabel.backgroundColor = [UIColor clearColor];
    self.allLengthLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.allLengthLabel];
    [self.allLengthLabel release];
    //总里程Label
    UILabel *allLengthNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.allLengthLabel.origin.x, self.allLengthLabel.origin.y+15+10, self.allLengthLabel.size.width, 14)];
    allLengthNameLabel.tag = 999;
    allLengthNameLabel.textColor = [CommonImage colorWithHexString:@"666666"];
    allLengthNameLabel.text = @"总里程(km)";
    allLengthNameLabel.backgroundColor = [UIColor clearColor];
    allLengthNameLabel.textAlignment = NSTextAlignmentCenter;
    allLengthNameLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:allLengthNameLabel];
    [allLengthNameLabel release];
    //总步数
    self.allStepCount = [[UILabel alloc] initWithFrame:CGRectMake(self.allLengthLabel.origin.x+self.allLengthLabel.size.width+marginx, 21, 70+5, 15)];//170
    self.allStepCount.textColor = [CommonImage colorWithHexString:@"333333"];
    self.allStepCount.font = [UIFont systemFontOfSize:17.0f];
    self.allStepCount.backgroundColor = [UIColor clearColor];
    self.allStepCount.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.allStepCount];
    [self.allStepCount release];
    //总步数Label
    self.allStepCountNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.allStepCount.origin.x,self.allStepCount.origin.y+15+10, self.allStepCount.size.width, 14)];
    self.allStepCountNameLabel.textColor = [CommonImage colorWithHexString:@"666666"];
    self.allStepCountNameLabel.text = @"总步数";
    self.allStepCountNameLabel.backgroundColor = [UIColor clearColor];
    self.allStepCountNameLabel.textAlignment = NSTextAlignmentCenter;
    self.allStepCountNameLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:self.allStepCountNameLabel];
    [self.allStepCountNameLabel release];
    //排名
    self.rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.allStepCountNameLabel.origin.x+self.allStepCountNameLabel.size.width+marginx, 16, 40, 20)];//260
    self.rankLabel.textColor = [CommonImage colorWithHexString:@"333333"];
    self.rankLabel.textColor = [UIColor redColor];
    self.rankLabel.font = [UIFont systemFontOfSize:17.0f];
    self.rankLabel.backgroundColor = [UIColor clearColor];
    self.rankLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.rankLabel];
    [self.rankLabel release];
    //排名Label
    UILabel *rankNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.rankLabel.origin.x, self.rankLabel.origin.y+20+10, self.rankLabel.size.width, 14)];
    rankNameLabel.textColor = [CommonImage colorWithHexString:@"666666"];
    rankNameLabel.text = @"排名";
    rankNameLabel.backgroundColor = [UIColor clearColor];
    rankNameLabel.textAlignment = NSTextAlignmentCenter;
    rankNameLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:rankNameLabel];
    [rankNameLabel release];
    //升降情况
    self.changeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-35, rankNameLabel.origin.y, 35, 15)];
    self.changeLabel.textColor = [UIColor redColor];
    self.changeLabel.text = @"↑3";//@"↓5";
    self.changeLabel.backgroundColor = [UIColor clearColor];
    self.changeLabel.textAlignment = NSTextAlignmentCenter;
    self.changeLabel.font = [UIFont systemFontOfSize:12.0f];
    self.changeLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:self.changeLabel];
    [self.changeLabel release];
    
    UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(0, 79.5,kDeviceWidth, 0.5)];
    lineView.backgroundColor =  [CommonImage colorWithHexString:@"e5e5e5"];
    [self.contentView addSubview:lineView];
    [lineView release];


}

- (void)setDataDic:(NSDictionary *)dataDic isFirst:(BOOL)yes isDay:(BOOL)yesDay
{
    if(_dataDic != dataDic){
        
        [_dataDic release];
        _dataDic = [dataDic retain];
    }
    
    
    UILabel *distanceLabel = (UILabel *)[self.contentView viewWithTag:999];
    if(yesDay){
        distanceLabel.text = @"里程(km)";
    }else{
        distanceLabel.text = @"总里程(km)";
    }

//    [CommonImage setPicImageQiniu:dataDic[@"userPhoto"] View:self.photoImageView Type:0 Delegate:nil];
    [CommonImage setImageFromServer:dataDic[@"userPhoto"] View:self.photoImageView Type:0];

    NSString *sex = dataDic[@"sex"];
     self.sexImageView.hidden = NO;
    if([sex intValue] ==  1){
        //男
         self.sexImageView.image = [UIImage imageNamed:@"common.bundle/move/move_icon_male.png"];
    }else if([sex intValue] ==  2){
        //女
         self.sexImageView.image = [UIImage imageNamed:@"common.bundle/move/move_icon_female.png"];
    }else {
        self.sexImageView.hidden = YES;
    }
    self.userName.text = dataDic[@"nickName"];
    self.allLengthLabel.text = [NSString stringWithFormat:@"%.2f",[dataDic[@"distance"] floatValue]/1000];
    self.allLengthLabel.adjustsFontSizeToFitWidth = YES;
    self.allStepCount.text = [NSString stringWithFormat:@"%@",dataDic[@"stepCnt"]];
    self.allStepCount.adjustsFontSizeToFitWidth = YES;
//    if(yes){
//       self.allStepCountNameLabel.text = @"人数";
//        self.backgroundColor = [CommonImage colorWithHexString:@"e8f9f9"];
//    }else{
    
    if(yes){
         self.backgroundColor = [CommonImage colorWithHexString:@"ecf5ff"];
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
    
    if(yesDay){
        self.allStepCountNameLabel.text = @"步数";
    }else{
           self.allStepCountNameLabel.text = @"总步数";
    }
//    }
    self.rankLabel.text = dataDic[@"rank"];
    if([[NSString stringWithFormat:@"%@",dataDic[@"rank"]] isEqualToString:@"暂无"]){
    
        self.rankLabel.font = [UIFont systemFontOfSize:13.0f];
    }else{
        self.rankLabel.font = [UIFont systemFontOfSize:16.0f];
        self.rankLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    if([dataDic.allKeys containsObject:@"change"]){
        //包含
        self.changeLabel.hidden = NO;
        if([dataDic[@"change"] intValue]>0){
            if(abs([dataDic[@"change"] intValue])>99){
                self.changeLabel.text = @"↑99+";
            }else{
                self.changeLabel.text = [NSString stringWithFormat:@"↑%d",abs([dataDic[@"change"] intValue])];
            }
        }else if([dataDic[@"change"] intValue]<0){
            if(abs([dataDic[@"change"] intValue])>99){
                self.changeLabel.text = @"↓99+";
            }else{
                self.changeLabel.text = [NSString stringWithFormat:@"↓%d",abs([dataDic[@"change"] intValue])];
            }
        }else{
//            self.changeLabel.hidden = YES;
            self.changeLabel.text = @"↑0";
        }
    }else{
        self.changeLabel.hidden = YES;
    }
    
    
//    self.changeLabel.hidden = NO;
//    self.changeLabel.text = @"↑3";
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
