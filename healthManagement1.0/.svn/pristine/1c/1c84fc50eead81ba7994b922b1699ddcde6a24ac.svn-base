//
//  MedicineDetailCell.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-7.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "MedicineDetailCell.h"


@interface MedicineDetailCell ()

@property (nonatomic,retain) UILabel *titleLabel;

@property (nonatomic,retain) UIImageView *iconImv;

@property (nonatomic,retain) UIView *backView;

@end

@implementation MedicineDetailCell

- (void)dealloc
{
    self.backView = nil;
    self.titleLabel = nil;
    self.contentLabel = nil;
//    self.detaiDic = nil;
    self.iconImv = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self getsubViews];
        
    }
    return self;
}

- (void)getsubViews
{
    
    CGFloat ios6OffsetX = 10;
    if(IOS_7){
        ios6OffsetX = 0;
    }
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(30-ios6OffsetX, 0, kDeviceWidth-40, 90)];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.cornerRadius = 6.0f;
    _backView.layer.borderColor = [CommonImage colorWithHexString:@"e3e3e3"].CGColor;
    _backView.layer.borderWidth = 0.5f;
    [self.contentView addSubview:_backView];
    [_backView release];
    
    UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(10-ios6OffsetX, 15, 41, 41)];
    circleView.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR2];
    circleView.layer.cornerRadius = 41/2.0f;
    circleView.layer.borderColor = [CommonImage colorWithHexString:@"e3e3e3"].CGColor;
    circleView.layer.borderWidth = 0.5f;
    [self.contentView addSubview:circleView];
    [circleView release];
    
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(10-ios6OffsetX, 15, 20, 41)];
    shadowView.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR2];
    [self.contentView addSubview:shadowView];
    [shadowView release];
    
    
    
    self.iconImv = [[UIImageView alloc] initWithFrame:CGRectMake(13-ios6OffsetX, 18, 35, 35)];
    self.iconImv.image = [UIImage imageNamed:@"img.bundle/answer/down_normal.png"];
    [self.contentView addSubview:_iconImv];
    [_iconImv release];
//    self.iconImv.hidden = YES;
    
    
    //标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 0, _backView.size.width-33-10, 44.0f)];
    self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.titleLabel.textColor = [CommonImage colorWithHexString:@"333333"];
    [_backView addSubview:_titleLabel];
    [_titleLabel release];
    //内容
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 60, _backView.size.width-33-10, 20)];
    self.contentLabel.font = [UIFont systemFontOfSize:15.0f];
    self.contentLabel.textColor = [CommonImage colorWithHexString:@"666666"];
    self.contentLabel.numberOfLines = 0;
    [_backView addSubview:_contentLabel];
    [_contentLabel release];
    
    //分隔线
    UIView *lineView = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, kDeviceWidth-40, 0.5)];
    lineView.backgroundColor = [CommonImage colorWithHexString:@"e3e3e3"];
    [_backView addSubview:lineView];
    [lineView release];
    
}

- (void)setDetaiDic:(NSDictionary *)detaiDic
{
//    if(_detaiDic != detaiDic){
//        
//        [_detaiDic release];
//        
//        _detaiDic = [detaiDic retain];
//    }
    
    self.titleLabel.text = detaiDic[@"title"];
    
    self.contentLabel.text = detaiDic[@"content"];
    
    self.iconImv.image = [UIImage imageNamed:[NSString stringWithFormat:@"common.bundle/tools/medicineLib/%@",detaiDic[@"icon"]]];
    
    //计算内容高度
    CGFloat contentHeight = [Common heightForString:detaiDic[@"content"] Width:self.contentLabel.size.width Font:self.contentLabel.font].height;
    CGRect contentLabelRect = self.contentLabel.frame;
    contentLabelRect.size.height = contentHeight;
    self.contentLabel.frame = contentLabelRect;
    //修改backview的大小
    
    CGRect backViewRect = self.backView.frame;
    backViewRect.size.height = contentHeight + self.contentLabel.origin.y + 15;
    self.backView.frame = backViewRect;
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
