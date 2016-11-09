//
//  RecommendTableViewCell.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-15.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "RecommendTableViewCell.h"

@interface RecommendTableViewCell ()

{
    UIImageView *_backView;
    UILabel *_textLabel;
    UIImageView *_picImageView;
    UIView *_lineView;

}


@end


@implementation RecommendTableViewCell

- (void)dealloc
{
    _backView = nil;
    _textLabel = nil;
    _picImageView = nil;
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

        
        _picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 50, 50)];
        [_backView addSubview:_picImageView];
        [_picImageView release];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, _backView.size.width-20, _backView.size.height)];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont systemFontOfSize:15.0f];
        [_backView addSubview:_textLabel];
        [_textLabel release];
        
        
    }
    return self;
}

- (void)setValue:(NSString *)value hasImageView:(BOOL)has imageName:(NSString *)imageName row:(int)row last:(BOOL)last
{

    if(row == 0){
        _backView.image = [[UIImage imageNamed:@"box_top.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:12];
        _backView.frame = CGRectMake(10, 0, kDeviceWidth-20, 44);
        _textLabel.frame = CGRectMake(10, 0, _backView.size.width-20, _backView.size.height);
        _picImageView.hidden = YES;
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.font = [UIFont systemFontOfSize:15.0f];
        _textLabel.text = value;
        
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
            lineRect.origin.y = 59.5;
            lineRect.size.width = _backView.frame.size.width-16;
            _lineView.frame = lineRect;

        }
        _backView.frame = CGRectMake(10, 0, kDeviceWidth-20, 60);
        _textLabel.frame = CGRectMake(10, 0, _backView.size.width-20, _backView.size.height);
        _picImageView.hidden = NO;
//        [CommonImage setPicImageQiniu:imageName View:_picImageView Type:2 Delegate:nil];
        [CommonImage setImageFromServer:imageName View:_picImageView Type:2];

        _picImageView.layer.cornerRadius = 25.0;
        _picImageView.layer.masksToBounds = YES;
        _textLabel.textAlignment = NSTextAlignmentRight;
        _textLabel.font = [UIFont systemFontOfSize:15.0f];
        _textLabel.text = value;
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
