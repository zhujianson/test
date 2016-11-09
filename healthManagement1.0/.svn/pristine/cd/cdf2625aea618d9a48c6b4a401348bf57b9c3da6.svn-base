//
//  SOSTableViewCell.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-6.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "SOSTableViewCell.h"
@interface SOSTableViewCell()

@property (nonatomic,retain) UILabel *titleLabel;//标题

@property (nonatomic,retain) UILabel *contentLabel;//内容

@property (nonatomic,retain) UIView *backView;//背景

@end

@implementation SOSTableViewCell

- (void)dealloc
{
    self.titleLabel = nil;
    self.contentLabel = nil;
    self.backView = nil;
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
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(15-ios6OffsetX, 0, kDeviceWidth-30, 90)];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.cornerRadius = 8.0f;
    _backView.layer.borderColor = [CommonImage colorWithHexString:@"e3e3e3"].CGColor;
    _backView.layer.borderWidth = 0.5f;
    [self.contentView addSubview:_backView];
    [_backView release];
    
    //标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 44.0f)];
    self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.titleLabel.textColor = [CommonImage colorWithHexString:@"333333"];
    [_backView addSubview:_titleLabel];
    [_titleLabel release];
    //内容
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 60, kDeviceWidth-30-2*11, 20)];
    self.contentLabel.font = [UIFont systemFontOfSize:15.0f];
    self.contentLabel.textColor = [CommonImage colorWithHexString:@"666666"];
    self.contentLabel.numberOfLines = 0;
    [_backView addSubview:_contentLabel];
    [_contentLabel release];
    
    //分隔线
    UIView *lineView = [[UILabel alloc] initWithFrame:CGRectMake(0, 43.5, kDeviceWidth-30, 0.5)];
    lineView.backgroundColor = [CommonImage colorWithHexString:@"e5e5e5"];
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
    _detaiDic = detaiDic;
    
    self.titleLabel.text = detaiDic[@"title"];
    
    self.contentLabel.text = detaiDic[@"content"];
    //计算内容高度
    CGFloat contentHeight = [Common heightForString:_contentLabel.text Width:_contentLabel.width Font:_contentLabel.font].height;
    CGRect contentLabelRect = _contentLabel.frame;
    contentLabelRect.size.height = contentHeight;
    _contentLabel.frame = contentLabelRect;
    //修改backview的大小
    
    CGRect backViewRect = self.backView.frame;
    backViewRect.size.height = contentHeight + self.contentLabel.origin.y + 15-1;
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
