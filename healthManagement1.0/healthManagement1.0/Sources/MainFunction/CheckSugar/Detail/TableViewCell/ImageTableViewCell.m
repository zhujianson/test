//
//  ImageTableViewCell.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-15.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "ImageTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface ImageTableViewCell ()

{
    UIView *_backView;
    UIImageView *_recommendImv;
    UIImageView *_picImageView;
    UILabel *_detailLabel1;
    UILabel *_detailLabel2;
    UILabel *_detailLabel3;
    UILabel *_titleView;
    UIButton *askBtn;
    
}

@end

@implementation ImageTableViewCell
- (void)dealloc
{
    _backView = nil;
    _picImageView = nil;
    _detailLabel1 = nil;
    _detailLabel2 = nil;
    _detailLabel3 = nil;
    _titleView = nil;
    [super dealloc];
}
- (NSMutableAttributedString *)replaceRedColorWithNSString:(NSString *)str andUseKeyWord:(NSString *)keyWord andWithFontSize:(float )size
{
    NSMutableAttributedString *attrituteString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
    NSRange range = [str rangeOfString:keyWord];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [CommonImage colorWithHexString:@"666666"], NSFontAttributeName : [UIFont systemFontOfSize:size]} range:range];
    return attrituteString;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kDeviceWidth-20, 44+157+10+15+10+15+15)];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 6.0f;
        _backView.layer.borderColor = [CommonImage colorWithHexString:VERSION_LIN_COLOR_SHEN].CGColor;
        _backView.layer.borderWidth = 0.5f;
        [self.contentView addSubview:_backView];
        [_backView release];
        
        _titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth-20, 44)];
        _titleView.backgroundColor = [UIColor clearColor];
        _titleView.font = [UIFont systemFontOfSize:15.0f];
        [_backView addSubview:_titleView];
        [_titleView release];
        //推荐图标
        _recommendImv = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-20-35, 10, 25, 25)];
       
        [_titleView addSubview:_recommendImv];
        [_recommendImv release];
        


        
        _picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 44, kDeviceWidth-20-20, 157)];
        [_backView addSubview:_picImageView];
        [_picImageView release];
        
        CGFloat leftWidth = kDeviceWidth-20 - 15 -15;
        CGFloat marginx = (leftWidth - 100 - 70 - 90)/2.0f;
        
        //第一个元素
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, _picImageView.origin.y+_picImageView.size.height+10, 100, 15)];
        label1.backgroundColor = [UIColor clearColor];
        label1.font = [UIFont systemFontOfSize:14.0f];
        label1.textColor = [CommonImage colorWithHexString:@"#333333"];
        label1.attributedText = [self replaceRedColorWithNSString:@"热量(千卡/100克)" andUseKeyWord:@"(千卡/100克)" andWithFontSize:12];
        [_backView addSubview:label1];
        [label1 release];
        
        
        _detailLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(15, _picImageView.origin.y+_picImageView.size.height+15+10+5, 100, 30)];
        _detailLabel1.backgroundColor = [UIColor clearColor];
        _detailLabel1.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
        _detailLabel1.textAlignment = NSTextAlignmentCenter;
        _detailLabel1.textColor = [CommonImage colorWithHexString:@"#333333"];
        [_backView addSubview:_detailLabel1];
        [_detailLabel1 release];
        
        //第二个元素
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(_detailLabel1.origin.x+_detailLabel1.size.width+marginx, _picImageView.origin.y+_picImageView.size.height+10, 70, 15)];
        label2.backgroundColor = [UIColor clearColor];
        label2.font = [UIFont systemFontOfSize:15.0f];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.textColor = [CommonImage colorWithHexString:@"#333333"];
        label2.attributedText = [self replaceRedColorWithNSString:@"升糖指数" andUseKeyWord:@"" andWithFontSize:14];
        [_backView addSubview:label2];
        [label2 release];
        
        _detailLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(label2.origin.x, _picImageView.origin.y+_picImageView.size.height+15+10+5, 70, 30)];
        _detailLabel2.backgroundColor = [UIColor clearColor];
        _detailLabel2.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
        _detailLabel2.textAlignment = NSTextAlignmentCenter;
        _detailLabel2.textColor = [CommonImage colorWithHexString:@"#333333"];
        [_backView addSubview:_detailLabel2];
        [_detailLabel2 release];
        //第三个元素
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(_detailLabel2.origin.x+_detailLabel2.size.width+marginx, _picImageView.origin.y+_picImageView.size.height+10, 90, 15)];
        label3.backgroundColor = [UIColor clearColor];
        label3.font = [UIFont systemFontOfSize:15.0f];
        label3.textColor = [CommonImage colorWithHexString:@"#333333"];
        label3.attributedText = [self replaceRedColorWithNSString:@"血糖风险指数" andUseKeyWord:@"" andWithFontSize:10];
        [_backView addSubview:label3];
        [label3 release];
        
        _detailLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(label3.origin.x, _picImageView.origin.y+_picImageView.size.height+15+10+5, 90, 30)];
        _detailLabel3.backgroundColor = [UIColor clearColor];
        _detailLabel3.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
        _detailLabel3.textAlignment = NSTextAlignmentCenter;
        _detailLabel3.textColor = [CommonImage colorWithHexString:@"#e9867f"];
        [_backView addSubview:_detailLabel3];
        [_detailLabel3 release];
        _detailLabel3.userInteractionEnabled = YES;
        askBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        askBtn.frame = CGRectMake(70, 5, 20, 20);
        [askBtn setImage:[UIImage imageNamed:@"common.bundle/common/search_infor_btn_nor.png"] forState:UIControlStateNormal];
        [askBtn setImage:[UIImage imageNamed:@"common.bundle/common/search_infor_btn_pre.png"] forState:UIControlStateHighlighted];
        [askBtn addTarget:self action:@selector(showDeatil:) forControlEvents:UIControlEventTouchUpInside];
        [_detailLabel3 addSubview:askBtn];
        
        _titleView.hidden = YES;
        _recommendImv.hidden = YES;
        _detailLabel1.hidden = YES;
        _detailLabel2.hidden = YES;
        _detailLabel3.hidden = YES;
        label1.hidden = YES;
        label2.hidden = YES;
        label3.hidden = YES;
        
      _backView.frame = CGRectMake(10, 0, kDeviceWidth-20, 10+157+10);
        
      _picImageView.frame = CGRectMake(10, 10, kDeviceWidth-20-20, 157);
 
        
    }
    return self;
}

- (void)showDeatil:(id)sender
{

    self.showDetailBlock();


}

- (void)setImageInfoDic:(NSDictionary *)imageInfoDic
{
    if(_imageInfoDic != imageInfoDic){
        [_imageInfoDic release];
        _imageInfoDic = [imageInfoDic retain];
    }
    //标题
    NSString *title = _imageInfoDic[@"title"];

    if([title isEqualToString:[NSString stringWithFormat:@"  %@",NSLocalizedString(@"宜食", @"")]]){
        _titleView.textColor = [CommonImage colorWithHexString:@"56b2ff"];
    }else if([title isEqualToString:[NSString stringWithFormat:@"  %@",NSLocalizedString(@"不宜食", @"")]]){
        _titleView.textColor = [CommonImage colorWithHexString:@"ffa34d"];
    }else {
        _titleView.textColor = [CommonImage colorWithHexString:@"e75441"];
    }

    //评价栏
    
    _titleView.text = title;
    //推荐图标---添加逻辑
    _recommendImv.image = nil;//[UIImage imageNamed:@"common.bundle/topic/Recommend.png"];

    //图片名
    NSString *imageName = _imageInfoDic[@"imageName"];
//    [CommonImage setPicImageQiniu:imageName View:_picImageView Type:2 Delegate:nil];
//    [CommonImage setImageFromServer:imageName View:_picImageView Type:2];
    UIImage *defaul = [UIImage imageNamed:@"common.bundle/common/conversation_logo.png"];
    [_picImageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:defaul];

    NSString *value1 = _imageInfoDic[@"value1"];
    _detailLabel1.text = value1;
    //生糖指数
    NSString *value2 = _imageInfoDic[@"value2"];
    _detailLabel2.text = value2;
    //血糖值
    NSString *value3 = _imageInfoDic[@"value3"];
    _detailLabel3.text = value3;
    _detailLabel3.textColor = _titleView.textColor;
    

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
