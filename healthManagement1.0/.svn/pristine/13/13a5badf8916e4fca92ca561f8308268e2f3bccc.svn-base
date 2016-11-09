//
//  MemberTableViewCell.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-11-28.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "MemberTableViewCell.h"

@interface MemberTableViewCell ()

@property (nonatomic,retain) UIImageView *myPhotoImageView;//本人头像
@property (nonatomic,retain) UIImageView *winImageView;//胜负
@property (nonatomic,retain) UILabel *memNameLabel;//姓名
@property (nonatomic,retain) UIImageView *levelImageView;//级别
@property (nonatomic,retain) UILabel *numberStepLabel;//步数
@property (nonatomic,retain) UIImageView *vImageView;//是否是志愿者

@end

@implementation MemberTableViewCell

- (void)dealloc
{
    self.myPhotoImageView = nil;
    self.winImageView = nil;
    self.memNameLabel = nil;
    self.levelImageView = nil;
    self.numberStepLabel = nil;
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
    self.myPhotoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 50, 50)];
    self.myPhotoImageView.layer.cornerRadius = 25;
    self.myPhotoImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.myPhotoImageView];
    [self.myPhotoImageView release];
    //胜负
    self.winImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.myPhotoImageView.origin.x+35, 8, 20, 20)];
    [self.contentView addSubview:self.winImageView];
    [self.winImageView release];
//    //加v
//    self.vImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.myPhotoImageView.origin.x+35, 50-8, 20, 20)];
//    [self.contentView addSubview:self.vImageView];
//    self.vImageView.backgroundColor = [UIColor clearColor];
//    self.vImageView.image = [UIImage imageNamed:@"common.bundle/move/v_03.png"];
//    [self.vImageView release];
    
    //名字
    CGFloat nameX = self.myPhotoImageView.origin.x+self.myPhotoImageView.size.width+12;
    //取小值
    CGFloat width = 4 * 15 +5 < kDeviceWidth-nameX-100-15 ? 4*15 + 5 : kDeviceWidth-nameX-100-15;
    
    
    self.memNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameX, 27, width, 17)];
    self.memNameLabel.font = [UIFont systemFontOfSize:15.0f];
    self.memNameLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.memNameLabel];
    [self.memNameLabel release];
    //等级
    self.levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.memNameLabel.origin.x+self.memNameLabel.size.width+3, self.memNameLabel.origin.y-2, 20, 20)];
    [self.contentView addSubview:self.levelImageView];
    [self.levelImageView release];
    
    //步数
    self.numberStepLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-100-15, 27, 100, 16)];
    self.numberStepLabel.font = [UIFont systemFontOfSize:15.0f];
    self.numberStepLabel.textAlignment = NSTextAlignmentRight;
    self.numberStepLabel.backgroundColor = [UIColor clearColor];
    self.numberStepLabel.textColor = [CommonImage colorWithHexString:@"fe6339"];
    
    self.numberStepLabel.center = CGPointMake(self.numberStepLabel.center.x, self.memNameLabel.center.y);
    [self.contentView addSubview:self.numberStepLabel];
    [self.numberStepLabel release];

    
    
    UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(0, 69.5,kDeviceWidth, 0.5)];
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
    if(!_dataDic){
        
        return;
    }
    
//    [CommonImage setPicImageQiniu:dataDic[@"userPhoto"] View:self.myPhotoImageView Type:0 Delegate:nil];
    [CommonImage setImageFromServer:dataDic[@"userPhoto"] View:self.myPhotoImageView Type:0];

    
    //if(加v){}
    //    self.vImageView.image = [UIImage imageNamed:@"common.bundle/move/v_03.png"];
    
    
    CGFloat nameX = self.myPhotoImageView.origin.x+self.myPhotoImageView.size.width+12;
//    CGFloat width = [dataDic[@"userName"] length] * 15 +5 < kDeviceWidth-nameX-100-15 ?[dataDic[@"userName"] length] * 15 +5 : kDeviceWidth-nameX-100-15;
    
    CGSize size = [dataDic[@"nickName"] sizeWithFont:self.memNameLabel.font constrainedToSize:CGSizeMake(kDeviceWidth-nameX-100-15, 16)];
    
    self.memNameLabel.frame = CGRectMake(nameX, 27, size.width, 18);

    self.memNameLabel.text = dataDic[@"nickName"];
    
    
    NSArray *titleArray = @[@"100",@"300",@"600",@"1000",@"1500",@"2500",@"4000",@"6000"];//km
    
    int mylevel = 0;
    
    CGFloat totalDistance = [dataDic[@"totalDistance"] floatValue]/1000;//转化为km
//    totalDistance = 6001;
    for(NSString *distanceString in titleArray){
        CGFloat distance = distanceString.floatValue;
        if(totalDistance > distance){
            mylevel++;
        }else{
            break;
        }
    }
//    int level = [dataDic[@"level"] intValue]-1;
    int level = mylevel;
//    NSArray *imagesArray = @[@"move_icon_turtle_blue.png",@"move_icon_turtle_green.png",@"move_icon_rabbit_green.png",@"move_icon_rabbit_yellow.png",@"move_icon_leopard_orange.png",@"move_icon_leopard_red.png"];
    NSArray *imagesArray = @[@"common.bundle/move/levelImg/small/move_icon_turtle01_small.png",@"common.bundle/move/levelImg/small/move_icon_turtle02_small.png",@"common.bundle/move/levelImg/small/move_icon_turtle03_small.png",@"common.bundle/move/levelImg/small/move_icon_rabbit01_small.png",@"common.bundle/move/levelImg/small/move_icon_rabbit02_small.png",@"common.bundle/move/levelImg/small/move_icon_rabbit03_small.png",@"common.bundle/move/levelImg/small/move_icon_leopard01_small.png",@"common.bundle/move/levelImg/small/move_icon_leopard02_small.png",@"common.bundle/move/levelImg/small/move_icon_leopard03_small.png"];
    NSArray *numArray = @[@"move_icon_number1.png",@"move_icon_number2.png",@"move_icon_number3.png"];
    
    UIImage *image = [UIImage imageNamed:imagesArray[level]];
    self.levelImageView.frame = CGRectMake(self.memNameLabel.origin.x+self.memNameLabel.size.width+3, self.memNameLabel.origin.y, image.size.width, image.size.height);
    self.levelImageView.image = image;
    self.numberStepLabel.text = [NSString stringWithFormat:@"%@ 步",dataDic[@"realStepCnt"]];
    int row = (int)[(NSIndexPath *)dataDic[@"index"] row];
    switch (row) {
        case 0:
        case 1:
        case 2:
        {
            self.winImageView.hidden = NO;
            self.winImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"common.bundle/move/MemList/%@",numArray[row]]];
        }
            break;
        default:
        {
            self.winImageView.hidden = YES;
        }
            break;
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
