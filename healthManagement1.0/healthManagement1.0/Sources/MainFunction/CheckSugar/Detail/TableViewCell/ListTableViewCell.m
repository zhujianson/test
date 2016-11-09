//
//  ListTableViewCell.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-15.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "ListTableViewCell.h"

@interface ListTableViewCell ()

{
    UIImageView *_backView;//背景
    UILabel *_titleView;//标题
    UILabel *_detailLabel1;
    UILabel *_detailLabel2;
    UIView *_lineView;
}

@end

@implementation ListTableViewCell

- (void)dealloc
{
    [_lineView release];

    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _backView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, kDeviceWidth-20, 44)];
//        _backView.backgroundColor = [UIColor whiteColor];
//        _backView.layer.cornerRadius = 8.0f;
//        _backView.layer.borderColor = [CommonImage colorWithHexString:@"e3e3e3"].CGColor;
//        _backView.layer.borderWidth = 0.5f;
        [self.contentView addSubview:_backView];
        [_backView release];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, _backView.frame.size.width, 0.5)];
        _lineView.backgroundColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_SHEN];
        [_backView addSubview:_lineView];
        
        
//        _titleView = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kDeviceWidth-20, 34)];
//        _titleView.backgroundColor = [UIColor whiteColor];
//        _titleView.layer.borderColor = [CommonImage colorWithHexString:@"e3e3e3"].CGColor;
//        _titleView.layer.borderWidth = 0.5f;
//        [self.contentView addSubview:_titleView];
//        [_titleView release];
        
        _detailLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 44)];
        _detailLabel1.backgroundColor = [UIColor clearColor];
        _detailLabel1.textColor = [CommonImage colorWithHexString:@"333333"];
        _detailLabel1.font = [UIFont systemFontOfSize:15.0f];
        [_backView addSubview:_detailLabel1];
        [_detailLabel1 release];

        _detailLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-20-165, 0, 150, 44)];
        _detailLabel2.backgroundColor = [UIColor clearColor];
        _detailLabel2.font = [UIFont systemFontOfSize:15.0f];
        _detailLabel2.textColor = [CommonImage colorWithHexString:@"333333"];
        _detailLabel2.textAlignment = NSTextAlignmentRight;
        [_backView addSubview:_detailLabel2];
        [_detailLabel2 release];
    }
    return self;
}
- (NSMutableAttributedString *)replaceRedColorWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )size
{
    NSMutableAttributedString *attrituteString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:@"666666"], NSFontAttributeName : [UIFont systemFontOfSize:size]} range:range];
    return attrituteString;
}
- (void)setDataKey:(NSString *)key Value:(NSString *)value Index:(int)row lastRow:(BOOL)lastRow hasSmall:(BOOL)yes specialKey:(NSString *)specialKey
{
    if(row == 0)
    {
//        _titleView.hidden = NO;
//        CGRect flowViewRect = _titleView.frame;
//        flowViewRect.origin.y = 10;
//        _titleView.frame = flowViewRect;
        
        _backView.image = [[UIImage imageNamed:@"box_top.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:12];
        _detailLabel1.font = [UIFont systemFontOfSize:15.0f];
        _detailLabel1.frame = CGRectMake(10, 0, 150, 44);
        if(yes){
            
            _detailLabel1.attributedText = [self replaceRedColorWithNSString:key andUseKeyWord:specialKey andWithFontSize:12];
            _detailLabel1.textColor = [CommonImage colorWithHexString:@"333333"];
        }else{
            _detailLabel1.text = key;
        }
        _detailLabel2.text = @"";
        _lineView.hidden = NO;
        CGRect lineRect = _lineView.frame;
        lineRect.origin.x = 0;
        lineRect.size.width = _backView.frame.size.width;
        _lineView.frame = lineRect;
        
        
    }else{
        _detailLabel1.font = [UIFont systemFontOfSize:15.0f];
        _detailLabel2.font = [UIFont systemFontOfSize:15.0f];
        _detailLabel1.frame = CGRectMake(16, 0, 150, 44);
        if(lastRow){
        //最后一个
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
        
        _detailLabel1.text = key;
        _detailLabel2.text = value;
        
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
