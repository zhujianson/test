//
//  HeaderCollectionReusableView.m
//  healthManagement1.0
//
//  Created by xjs on 16/7/5.
//  Copyright © 2016年 xuGuohong. All rights reserved.
//

#import "HeaderCollectionReusableView.h"

@implementation HeaderCollectionReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [CommonImage colorWithHexString:@"f2f2f2"];
        _viewheader2 = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_viewheader2];
        
        _viewheader = [[UIView alloc] initWithFrame:CGRectMake(15, (45-13)/2, 3, 13)];
        self.viewheader.backgroundColor = [CommonImage colorWithHexString:The_ThemeColor];
        [self addSubview:self.viewheader];
        
        _label = [Common createLabel:CGRectMake(self.viewheader.right+10, 0, 200, 45) TextColor:@"999999" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft labTitle:nil];
        [self addSubview:_label];
        
//        viewheader = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5+7, kDeviceWidth, 0.5)];
//        viewheader.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
//        [self addSubview:viewheader];
        
        _butMore = [UIButton buttonWithType:UIButtonTypeCustom];
        _butMore.frame = CGRectMake(kDeviceWidth-15-6-26-7, 0, 13*2, _label.height);

        [_butMore setTitle:@"更多" forState:UIControlStateNormal];
        [_butMore setTitleColor:[CommonImage colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [_butMore addTarget:self action:@selector(butEventMoreNews:) forControlEvents:UIControlEventTouchUpInside];
        _butMore.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_butMore];
        
        _rightI = [[UIImageView alloc]initWithFrame:CGRectMake(_butMore.right+7, _butMore.top, 6, _butMore.height)];
        self.rightI.image = [UIImage imageNamed:@"common.bundle/common/smallR.png"];
        //        rightI.backgroundColor = [UIColor redColor];
        self.rightI.contentMode =  UIViewContentModeCenter;
        [self addSubview:self.rightI];

        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.size.width, 0.5)];
        _lineView.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
        [self addSubview:_lineView];

    }
    return self;
}

- (void)butEventMoreNews:(UIButton*)btn
{
//    NSLog(@"%d",btn.tag);
    _m_block((int)btn.tag);
    
}

@end








@implementation Header2CollectionReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [CommonImage colorWithHexString:@"f2f2f2"];
        
        _viewheader2 = [[UIView alloc] initWithFrame:CGRectMake(0, 8, CGRectGetWidth(frame), CGRectGetHeight(frame)-8)];
        [self addSubview:_viewheader2];
        
        _viewheader = [[UIView alloc] initWithFrame:CGRectMake(15, (_viewheader2.height-13)/2, 3, 13)];
        self.viewheader.backgroundColor = [CommonImage colorWithHexString:The_ThemeColor];
        [_viewheader2 addSubview:self.viewheader];
        
        _label = [Common createLabel:CGRectMake(self.viewheader.right+8, 0, 200, _viewheader2.height) TextColor:@"000000" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft labTitle:nil];
        [_viewheader2 addSubview:_label];
        
        
//        _rightI = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(frame)-20, 0, 6, CGRectGetHeight(frame))];
//        self.rightI.image = [UIImage imageNamed:@"common.bundle/common/smallR.png"];
//        //        rightI.backgroundColor = [UIColor redColor];
//        self.rightI.contentMode =  UIViewContentModeCenter;
//        [self addSubview:self.rightI];
        
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _viewheader2.height-0.5, self.size.width, 0.5)];
        _lineView.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
        [_viewheader2 addSubview:_lineView];
        
    }
    return self;
}

- (void)butEventMoreNews:(UIButton*)btn
{
    //    NSLog(@"%d",btn.tag);
    _m_block((int)btn.tag);
    
}

@end







@implementation FooterCollectionReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 500)];
        header.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR2];
        [self addSubview:header];

        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 30)];
        UIActivityIndicatorView* activi = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, 8, 30, 30)];
        activi.tag = tableFooterViewActivityTag;
        [activi startAnimating];
        activi.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        //	view.hidden = YES;
        [view addSubview:activi];
        
        UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(122, 0, 100, 45)];
        lab.center = CGPointMake(kDeviceWidth/2, 22);
        lab.tag = tableFooterViewLabTag;
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.backgroundColor = [UIColor clearColor];
        lab.textColor = [CommonImage colorWithHexString:@"#31302f"];
        lab.text = NSLocalizedString(@"加载中...", nil);
        [view addSubview:lab];
        [header addSubview:view];
        
    }
    return self;
}

@end
