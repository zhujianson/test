//
//  HomeIndexCollectionViewCell.m
//  healthManagement1.0
//
//  Created by jiuhao-yangshuo on 16/1/18.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "HomeIndexCollectionViewCell.h"
#import "HomeModel.h"

@implementation HomeIndexCollectionViewCell
{
    UIView *m_backView;
    UIImageView *m_imageView;
    UIButton *m_butDel;
    UILabel *m_labTitle;
    UILabel *lineLabel;
    UILabel *lineLabelRight;
    UIImageView *m_redImage;
    
    NSMutableDictionary *mDict;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        m_backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        m_backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:m_backView];
        
        m_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        m_imageView.backgroundColor = [UIColor clearColor];
        m_imageView.contentMode = UIViewContentModeScaleAspectFill;
        m_imageView.clipsToBounds = YES;
        [m_backView addSubview:m_imageView];
        m_imageView.centerX = m_backView.centerX;
        m_imageView.centerY = m_backView.centerY-10;
        
        m_labTitle = [Common createLabel];
        m_labTitle.frame = CGRectMake(0, m_imageView.bottom+5, m_backView.width, 30);
        m_labTitle.font = [UIFont systemFontOfSize:15];
        m_labTitle.textColor = [CommonImage colorWithHexString:@"666666"];
        m_labTitle.textAlignment = NSTextAlignmentCenter;
        [m_backView addSubview:m_labTitle];
        
        m_redImage = [[UIImageView alloc]initWithFrame:CGRectMake(m_imageView.right -2, m_imageView.top+2, 8, 8)];
        m_redImage.backgroundColor = [CommonImage colorWithHexString:VERSION_ERROR_TEXT_COLOR];
        m_redImage.clipsToBounds = YES;
        m_redImage.layer.cornerRadius = 4;
        m_redImage.hidden = YES;
        m_redImage.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:m_redImage];
        
        float space = 12.0;
//        lineLabel = [Common createLabel:CGRectMake(0, space, m_backView.width, 0.5) TextColor:@"000000" Font:nil textAlignment:NSTextAlignmentCenter labTitle:@""];
//        [m_backView addSubview:lineLabel];
//        
//        lineLabelRight = [Common createLabel:CGRectMake(space, 0, 0.5, m_backView.height) TextColor:@"000000" Font:nil textAlignment:NSTextAlignmentCenter labTitle:@""];
//        [m_backView addSubview:lineLabelRight];
    }
    return self;
}

-(void)setM_infoDict:(NSDictionary *)m_infoDict
{
    mDict = m_infoDict;
    m_labTitle.text = m_infoDict[@"iconName"];
    [CommonImage setImageFromServer:m_infoDict[@"imgUrl"] View:m_imageView Type:2];
    if([m_infoDict[@"fontColor"] length]){
        m_labTitle.textColor = [CommonImage colorWithHexString:m_infoDict[@"fontColor"]];
    }
    lineLabel.top = 2.;
    lineLabelRight.left = 1.5;
    
    m_redImage.hidden = [HomeModel isShowRedImageWithDict:m_infoDict];
}

-(void)hidenImage
{
    m_redImage.hidden = YES;
    [HomeModel setNoRedImageWithDict:mDict];
}

-(void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    m_backView.backgroundColor = highlighted?[CommonImage colorWithHexString:@"f5f5f5"]:[UIColor whiteColor];
}
@end


@implementation HomeIndexCollectionReusableView
{
    UILabel *lineLabel;
}
@synthesize m_footerLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        m_footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth,40)];
        m_footerLabel.text = @"点击进入,长按拖放顺序";
        m_footerLabel.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR2];;
        m_footerLabel.textColor = [CommonImage colorWithHexString:@"999999"];
        m_footerLabel.textAlignment = NSTextAlignmentCenter;
        m_footerLabel.font = [UIFont systemFontOfSize:M_FRONT_FOURTEEN];
        [self addSubview:m_footerLabel];
        
        lineLabel = [Common createLineLabelWithHeight:0];
        lineLabel.backgroundColor = [CommonImage colorWithHexString:@"ededed"];
        [self addSubview:lineLabel];
        
    }
    return self;
}

-(void)showText:(BOOL)show
{
    if (show)
    {
        m_footerLabel.text = @"点击进入";
        m_footerLabel.frameHeight = 40;
    }
    else
    {
        m_footerLabel.text = @"";
        m_footerLabel.frameHeight = 7;
    }
    m_footerLabel.hidden = !show;
    lineLabel.bottom = m_footerLabel.height-0.5;
}

@end


@implementation HomeIndexCollectionAddViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UILabel*lastTipLabel = [Common createLabel:CGRectMake(0, 0, frame.size.width, frame.size.height) TextColor:@"999999" Font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter labTitle:@"以上服务\n会出现在首页"];
        lastTipLabel.backgroundColor = [UIColor whiteColor];
        lastTipLabel.numberOfLines = 0;
        [self addSubview:lastTipLabel];
    }
    return self;
}

@end

@implementation HomeIndexCollectionFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UILabel *lineLabel = [Common createLineLabelWithHeight:0];
        lineLabel.backgroundColor = [CommonImage colorWithHexString:@"ededed"];
        [self addSubview:lineLabel];
    }
    return self;
}

@end