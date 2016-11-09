//
//  FoodRestraintTableViewCell.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-21.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "FoodRestraintTableViewCell.h"

@interface FoodRestraintTableViewCell ()
{

    UIImageView *_backView;//背景
    UILabel *_titleView;//标题
    UILabel *_detailLabel1;
    UILabel *_detailLabel2;
    UIView *_lineView;
    UIView *_bottomView;
}

@end

@implementation FoodRestraintTableViewCell


- (void)dealloc
{
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _backView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, kDeviceWidth-20, 44)];

        [self.contentView addSubview:_backView];
        [_backView release];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, _backView.frame.size.width, 0.5)];
        _lineView.backgroundColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_SHEN];
        [_backView addSubview:_lineView];
        [_lineView release];
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, _backView.frame.size.width, 0.5)];
        _bottomView.backgroundColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_SHEN];
        [_backView addSubview:_bottomView];
        [_bottomView release];
        
        
        _detailLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kDeviceWidth-20-20, 44)];
        _detailLabel1.backgroundColor = [UIColor clearColor];
        _detailLabel1.font = [UIFont systemFontOfSize:15.0f];
        _detailLabel1.textColor = [CommonImage colorWithHexString:@"333333"];
        _detailLabel1.font = [UIFont systemFontOfSize:15.0f];
        [_backView addSubview:_detailLabel1];
        [_detailLabel1 release];
        
        _detailLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, kDeviceWidth-20-20, 35)];
        _detailLabel2.backgroundColor = [UIColor clearColor];
        _detailLabel2.font = [UIFont systemFontOfSize:15.0f];
        _detailLabel2.numberOfLines = 0;
        _detailLabel2.textColor = [CommonImage colorWithHexString:@"666666"];
        _detailLabel2.textAlignment = NSTextAlignmentLeft;
        [_backView addSubview:_detailLabel2];
        [_detailLabel2 release];
        
    }
    return self;
}

- (void)setDataKey:(NSString *)key Value:(NSString *)value Index:(int)row lastRow:(BOOL)lastRow hasSmall:(BOOL)yes specialKey:(NSString *)specialKey
{
    
    _backView.frame = CGRectMake(10, 0, kDeviceWidth-20, 44);
    _detailLabel1.frame = CGRectMake(10, 0, kDeviceWidth-20-20, 44);
    _detailLabel2.frame = CGRectMake(10, 35, kDeviceWidth-20-20, 35);
    _lineView.frame = CGRectMake(0, 43.5, _backView.frame.size.width, 0.5);
    _bottomView.frame = CGRectMake(0, 43.5, _backView.frame.size.width, 0.5);
    
    if(row == 0)
    {
        _bottomView.hidden = YES;
        _backView.image = [[UIImage imageNamed:@"box_top.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:12];
        _detailLabel1.font = [UIFont systemFontOfSize:15.0f];
        _detailLabel1.frame = CGRectMake(10, 0, 150, 44);

        _detailLabel1.text = key;
        _detailLabel2.text = @"";
        _lineView.hidden = NO;
        CGRect lineRect = _lineView.frame;
        lineRect.origin.x = 0;
        lineRect.size.width = _backView.frame.size.width;
        _lineView.frame = lineRect;
        
        
    }else{

        _detailLabel1.font = [UIFont systemFontOfSize:15.0f];
        _detailLabel2.font = [UIFont systemFontOfSize:15.0f];
        CGSize valueSize = [Common heightForString:value Width:kDeviceWidth-20-32 Font:[UIFont systemFontOfSize:15]];
        
        CGFloat valueHeight = valueSize.height < 35? 35 : valueSize.height;
        _detailLabel1.frame = CGRectMake(16, 0, kDeviceWidth-20-32, 35);

        _detailLabel2.frame = CGRectMake(16, 35+10, kDeviceWidth-20-32, valueHeight);
        
        
        CGRect backRect = _backView.frame;
        backRect.size.height = 35+10 + valueHeight + 10;
        _backView.frame = backRect;
        
        if(lastRow){
            //最后一个
            _backView.image = [[UIImage imageNamed:@"box_back.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:8];
            _bottomView.hidden = YES;
            _lineView.hidden = NO;
        }else{
            _bottomView.hidden = NO;
            _lineView.hidden = NO;
            _backView.image = [[UIImage imageNamed:@"box_middle.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:12];
            _lineView.hidden = NO;
            
        }
        
        CGRect lineRect = _lineView.frame;
        lineRect.origin.x = 16;
        lineRect.size.width = _backView.frame.size.width-16;
        lineRect.origin.y = 34.5;
        _lineView.frame = lineRect;
        
        CGRect bottomRect = _bottomView.frame;
        bottomRect.origin.x = 0;
        bottomRect.size.width = _backView.frame.size.width;
        bottomRect.origin.y = _backView.size.height-0.5;
        _bottomView.frame = bottomRect;
        
        _detailLabel1.text = key;
        _detailLabel2.text = value;

//        self.detailLabel1.text = self.m_keyString;
//        _detailLabel2.text = self.m_valueString;
//        [_backView addSubview:_detailLabel1];
    }
}

- (void)description
{
    
    NSLog(@"---%@",_backView.subviews);
    NSLog(@"---detailLabel1:%@,lineViewHidden:%d,backViewFrame:%@,_detaiLabel1Frame:%@",_detailLabel1.text,_lineView.hidden,NSStringFromCGRect(_backView.frame),NSStringFromCGRect(_detailLabel1.frame));

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
