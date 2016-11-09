//
//  TextTableViewCell.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-15.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "TextTableViewCell.h"

@interface TextTableViewCell()
{
    UIImageView *_backView;
    UILabel *_titleView;
    UILabel *_detailLabel1;
    UIView *_lineView;

}

@end

@implementation TextTableViewCell

- (void)dealloc
{
    _backView = nil;
    _titleView = nil;
    _detailLabel1 = nil;
    _lineView = nil;
    [_lineView release];

    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _backView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, kDeviceWidth-20, 44)];
        _backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_backView];
        [_backView release];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, _backView.frame.size.width, 0.5)];
        _lineView.backgroundColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_SHEN];
        [_backView addSubview:_lineView];

        
        //第一个元素
        _detailLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kDeviceWidth-20-15*2, 44)];
        _detailLabel1.backgroundColor = [UIColor clearColor];
        _detailLabel1.numberOfLines = 0;
        _detailLabel1.font = [UIFont systemFontOfSize:15.0f];
        _detailLabel1.textColor = [CommonImage colorWithHexString:@"#333333"];
        [_backView addSubview:_detailLabel1];
        [_detailLabel1 release];

        
        
    }
    return self;
}

- (void)setvalue:(NSString *)value row:(int)row last:(BOOL)last
{
    if(row == 0){
        
        _backView.image = [[UIImage imageNamed:@"box_top.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:12];
        
        _backView.frame = CGRectMake(10, 0, kDeviceWidth-20, 44);
        _detailLabel1.frame = CGRectMake(15, 0, kDeviceWidth-20-15*2, 44);
        _detailLabel1.font = [UIFont systemFontOfSize:15.0f];
        _detailLabel1.text = value;
        _lineView.hidden = NO;
        CGRect lineRect = _lineView.frame;
        lineRect.origin.x = 0;
        lineRect.size.width = _backView.frame.size.width;
        _lineView.frame = lineRect;
        
    }else{
    
        if(last){
            
            _backView.image = [[UIImage imageNamed:@"box_back.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:8];
            _lineView.hidden = YES;
        }else{
        
            _backView.image = [[UIImage imageNamed:@"box_middle.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:12];
            _lineView.hidden = NO;
            CGRect lineRect = _lineView.frame;
            lineRect.origin.x = 16;
            lineRect.size.width = _backView.frame.size.width-16;
            _lineView.frame = lineRect;
        }
        
        
        CGFloat height = [Common heightForString:value Width:kDeviceWidth-20-15*2 Font:[UIFont systemFontOfSize:14.0f]].height;
        _detailLabel1.font = [UIFont systemFontOfSize:14.0f];
        CGRect detailRect = _detailLabel1.frame;
        detailRect.size.height = height;
        _detailLabel1.frame = detailRect;
        
        CGRect backViewRect = _backView.frame;
        backViewRect.size.height = height + 20;
        _backView.frame = backViewRect;
        
        
        _detailLabel1.text = value;
        
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
