//
//  ChallengeListCell.m
//  jiuhaohealth2.1
//
//  Created by 王敏 on 14-9-28.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "ChallengeListCell.h"

@interface ChallengeListCell()

@property (nonatomic,retain) UIImageView *myPhotoImageView;//本人头像
@property (nonatomic,retain) UILabel *myNameLabel;//本人姓名
@property (nonatomic,retain) UILabel *myPerDayNumLabel;//本人日均步数

@property (nonatomic,retain) UILabel *otherNameLabel;//别人姓名
@property (nonatomic,retain) UILabel *otherPerDayNumLabel;//别人昨日步数

@property (nonatomic,retain) UIImageView *winImageView;//胜负

@property (nonatomic,retain) UILabel *fenLabel;//筹码
@property (nonatomic,retain) UILabel *progressLabel;//进度

@property (nonatomic,retain) UIImageView *vImageView;//加v

@property (nonatomic,retain) UILabel *statusLabel;//比赛状态

@end

@implementation ChallengeListCell

- (void)dealloc
{
    self.myPhotoImageView = nil;
    self.myNameLabel = nil;
    self.myPerDayNumLabel = nil;
    self.otherPhotoImageView = nil;
    self.otherNameLabel = nil;
    self.otherPerDayNumLabel = nil;
    self.winImageView = nil;
    self.dataDic = nil;
    self.fenLabel = nil;
    self.progressLabel = nil;
    self.vImageView = nil;
    self.statusLabel = nil;
    
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
- (NSMutableAttributedString *)replaceRedColorWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )size
{
    if(keyWord.length == 0){
        
        return nil;
    }
    NSMutableAttributedString *attrituteString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:@"ff6969"], NSFontAttributeName : [UIFont systemFontOfSize:size]} range:range];
    return attrituteString;
}

- (void)getSubviews
{
    //头像
    self.myPhotoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 15, 70, 70)];
    self.myPhotoImageView.layer.cornerRadius = 35;
    self.myPhotoImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.myPhotoImageView];
    [self.myPhotoImageView release];
    //胜负
    self.winImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.myPhotoImageView.origin.x+50, 11, 30, 30)];
    [self.contentView addSubview:self.winImageView];
    self.winImageView.image = [UIImage imageNamed:@"common.bundle/move/move_icon_victory_small.png"];
    [self.winImageView release];
//    //加v
//    self.vImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.myPhotoImageView.origin.x+50, 70-11, 30, 30)];
//    [self.contentView addSubview:self.vImageView];
//    self.vImageView.backgroundColor = [UIColor redColor];
//    self.vImageView.image = [UIImage imageNamed:@"common.bundle/move/move_icon_victory_small.png"];
//    [self.vImageView release];
    
    //姓名
    self.myNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.myPhotoImageView.origin.x, self.myPhotoImageView.origin.y+self.myPhotoImageView.size.height+10, self.myPhotoImageView.size.width, 16)];
    self.myNameLabel.textAlignment = NSTextAlignmentCenter;
    self.myNameLabel.text = @"奥巴马";
    self.myNameLabel.textColor = [CommonImage colorWithHexString:@"333333"];
    self.myNameLabel.backgroundColor = [UIColor clearColor];
    self.myNameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.myNameLabel];
    [self.myNameLabel release];
   //本人昨日
    self.myPerDayNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, self.myNameLabel.origin.y+self.myNameLabel.size.height+9, 120, 15)];
    self.myPerDayNumLabel.textAlignment = NSTextAlignmentLeft;
    
    self.myPerDayNumLabel.textColor = [CommonImage colorWithHexString:@"666666"];
//    self.myPerDayNumLabel.attributedText = [self  replaceRedColorWithNSString:@"日均 123 步" andUseKeyWord:@"123" andWithFontSize:14];
    self.myPerDayNumLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.myPerDayNumLabel];
    [self.myPerDayNumLabel release];
    
    //VS
    UILabel *vsLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth-30)/2.0, 26, 30, 20)];
    vsLabel.textAlignment = NSTextAlignmentCenter;
    vsLabel.text = @"VS";
    vsLabel.textColor = [CommonImage colorWithHexString:@"ff6969"];
    vsLabel.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:vsLabel];
    [vsLabel release];
    
    //筹码
    self.fenLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth-110)/2.0, vsLabel.origin.y+vsLabel.size.height+3, 110, 13)];
    self.fenLabel.textAlignment = NSTextAlignmentCenter;
    self.fenLabel.textColor = [CommonImage colorWithHexString:@"666666"];
//    self.fenLabel.attributedText = [self  replaceRedColorWithNSString:@"筹码 10 积分" andUseKeyWord:@"10" andWithFontSize:14];
    self.fenLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:self.fenLabel];
    [self.fenLabel release];
    //进度
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth-110)/2.0, self.fenLabel.origin.y+self.fenLabel.size.height+2, 110, 14)];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.textColor = [CommonImage colorWithHexString:@"666666"];
//    self.progressLabel.attributedText = [self  replaceRedColorWithNSString:@"进度 2/3 天" andUseKeyWord:@"2/3" andWithFontSize:14];
    self.progressLabel.font = [UIFont systemFontOfSize:11];
    self.progressLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.progressLabel];
    [self.progressLabel release];
    
    
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth-110)/2.0, self.progressLabel.origin.y+self.progressLabel.size.height+3, 110, 15)];
    self.statusLabel.font = [UIFont systemFontOfSize:13];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.textColor = [CommonImage colorWithHexString:@"666666"];
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel release];
    
    
    
    
    
    //对手头像
    self.otherPhotoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-70-35), 15, 70, 70)];
    self.otherPhotoImageView.layer.cornerRadius = 35;
    self.otherPhotoImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.otherPhotoImageView];
    [self.otherPhotoImageView release];
    //对手姓名
    self.otherNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.otherPhotoImageView.origin.x, self.otherPhotoImageView.origin.y+self.otherPhotoImageView.size.height+10, self.otherPhotoImageView.size.width, 17)];
    self.otherNameLabel.textAlignment = NSTextAlignmentCenter;
//    self.otherNameLabel.text = @"普京";
    self.otherNameLabel.textColor = [CommonImage colorWithHexString:@"333333"];
    self.otherNameLabel.backgroundColor = [UIColor clearColor];
    self.otherNameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.otherNameLabel];
    [self.otherNameLabel release];
    //对手昨日
    self.otherPerDayNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-35-120, self.otherNameLabel.origin.y+self.otherNameLabel.size.height+9, 120, 15)];
    self.otherPerDayNumLabel.textAlignment = NSTextAlignmentRight;
    self.otherPerDayNumLabel.textColor = [CommonImage colorWithHexString:@"666666"];
//    self.otherPerDayNumLabel.attributedText = [self  replaceRedColorWithNSString:@"日均 123 步" andUseKeyWord:@"123" andWithFontSize:14];
    self.otherPerDayNumLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.otherPerDayNumLabel];
    [self.otherPerDayNumLabel release];
    UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(0, 144.5,kDeviceWidth, 0.5)];
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
    
    //我的
    NSDictionary *myDic = dataDic[@"accountA"];
//    [Common setPicImage:myScoreDic[@"iconPath"] View:self.myPhotoImageView isUser:YES];
//    [CommonImage setPicImageQiniu:myDic[@"userPhoto"] View:self.myPhotoImageView  Type:0 Delegate:nil];
    [CommonImage setImageFromServer:myDic[@"userPhoto"] View:self.myPhotoImageView Type:0];

    self.myNameLabel.text = myDic[@"nickName"];

    self.myPerDayNumLabel.attributedText = [self  replaceRedColorWithNSString:[NSString stringWithFormat:@"日均 %@ 步",myDic[@"avgStepCount"]] andUseKeyWord:[NSString  stringWithFormat:@"%@",myDic[@"avgStepCount"]] andWithFontSize:14];

    //对手
//    [Common setPicImage:otherDic[@"iconPath"] View:self.otherPhotoImageView isUser:YES];
//    [CommonImage setPicImageQiniu:dataDic[@"bFilePath"] View:self.otherPhotoImageView Type:0 Delegate:nil];
     NSDictionary *otherDic = dataDic[@"accountB"];
    self.otherNameLabel.text = otherDic[@"nickName"];
    self.otherPerDayNumLabel.attributedText = [self  replaceRedColorWithNSString:[NSString stringWithFormat:@"日均 %@ 步",otherDic[@"avgStepCount"]]andUseKeyWord:[NSString  stringWithFormat:@"%@",otherDic[@"avgStepCount"]] andWithFontSize:14];
    
    //胜负
    NSString *flag = dataDic[@"myPkResult"];
    if([flag intValue] == 1){
        //胜利
        self.winImageView.image = [UIImage imageNamed:@"common.bundle/move/move_icon_victory_small.png"];
    }else{
        self.winImageView.image = [UIImage imageNamed:@"common.bundle/move/move_icon_fail_small.png"];
    }
    
    if([dataDic[@"status"] intValue] == 1){
        self.winImageView.hidden = YES;
        self.statusLabel.text = @"申请中...";
    }else if([dataDic[@"status"] intValue] == 2){
        self.winImageView.hidden = YES;
        self.statusLabel.text = @"进行中...";
    }else{
        self.winImageView.hidden = NO;
        self.statusLabel.text = @"已结束";
    
    }
    
//    if(!([dataDic[@"status"] intValue] == 2) && [dataDic[@"status"] intValue] == 1){
//        self.winImageView.hidden = NO;
//        self.statusLabel.text = @"已结束";
//    }else{
//        self.statusLabel.text = @"进行中...";
//        self.winImageView.hidden = YES;
//    }
    

    
    self.fenLabel.attributedText = [self  replaceRedColorWithNSString:[NSString stringWithFormat:@"筹码 %@ 积分",[NSString stringWithFormat:@"%@",dataDic[@"chips"]]] andUseKeyWord:[NSString stringWithFormat:@"%@",dataDic[@"chips"]] andWithFontSize:11];
    
    self.progressLabel.attributedText = [self  replaceRedColorWithNSString:[NSString stringWithFormat:@"进度 %@/%@ 天",dataDic[@"startedDay"],dataDic[@"complyDay"]] andUseKeyWord:[NSString stringWithFormat:@"%@/%@",dataDic[@"startedDay"],dataDic[@"complyDay"]] andWithFontSize:11];
    
}

- (void)setIconImage:(UIImage*)image
{
    self.otherPhotoImageView.image = image;
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
